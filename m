Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8114450CBE0
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 17:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbiDWPmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Apr 2022 11:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235570AbiDWPmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Apr 2022 11:42:16 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8473D1FA;
        Sat, 23 Apr 2022 08:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650728357; x=1682264357;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IAOFBiTClx5seV4hqvri48KpKIvtRs+vNMmvrP+07EM=;
  b=FqOP9x7cNs6PkzxG/CCiLJsJolcmGMIsjdIfcJirOu+KT8EhewVosIsx
   Mi5pW/08CPkVFPKASnHDJr6UkuGnE39ZDyLKPBYuH0FqOqXQX3H+hwsKX
   yw6FoGwtq645qVtCFglCE50eN8iiinOeRcRiEPixUbcG/hNzTXoPIhPhf
   PcZYQyxvRbwoKJC2r2f74eOf8lsSAOdHCoBzoXwuOhIUiEJ7Y5LCi1rHX
   qNzN2bv8tzw1yPwsJvHpw8yTWtba5ROv/5l3sUhNyjTfzemn4W1ghrxcD
   pBvYZmCGCA4DYROkiDcapdvnmA4kG3jnhGsEMI3gycOnamrrcGM5DKjlO
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10326"; a="246818099"
X-IronPort-AV: E=Sophos;i="5.90,284,1643702400"; 
   d="scan'208";a="246818099"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2022 08:39:17 -0700
X-IronPort-AV: E=Sophos;i="5.90,284,1643702400"; 
   d="scan'208";a="728968016"
Received: from mhammack-mobl1.amr.corp.intel.com (HELO [10.212.213.135]) ([10.212.213.135])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2022 08:39:16 -0700
Message-ID: <82d3cb0b-cebc-d1da-abc1-e802cb8f8ff8@linux.intel.com>
Date:   Sat, 23 Apr 2022 08:39:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH v3 06/21] x86/virt/tdx: Shut down TDX module in case of
 error
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com, isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <3f19ac995d184e52107e7117a82376cb7ecb35e7.1649219184.git.kai.huang@intel.com>
From:   Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <3f19ac995d184e52107e7117a82376cb7ecb35e7.1649219184.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/5/22 9:49 PM, Kai Huang wrote:
> TDX supports shutting down the TDX module at any time during its
> lifetime.  After TDX module is shut down, no further SEAMCALL can be
> made on any logical cpu.
> 
> Shut down the TDX module in case of any error happened during the
> initialization process.  It's pointless to leave the TDX module in some
> middle state.
> 
> Shutting down the TDX module requires calling TDH.SYS.LP.SHUTDOWN on all

May be adding specification reference will help.

> BIOS-enabled cpus, and the SEMACALL can run concurrently on different
> cpus.  Implement a mechanism to run SEAMCALL concurrently on all online

 From TDX Module spec, sec 13.4.1 titled "Shutdown Initiated by the Host
VMM (as Part of Module Update)",

TDH.SYS.LP.SHUTDOWN is designed to set state variables to block all
SEAMCALLs on the current LP and all SEAMCALL leaf functions except
TDH.SYS.LP.SHUTDOWN on the other LPs.

As per above spec reference, executing TDH.SYS.LP.SHUTDOWN in
one LP prevent all SEAMCALL leaf function on all other LPs. If so,
why execute it on all CPUs?

> cpus.  Logical-cpu scope initialization will use it too.

Concurrent SEAMCALL support seem to be useful for other SEAMCALL
types as well. If you agree, I think it would be better if you move
it out to a separate common patch.

> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 40 ++++++++++++++++++++++++++++++++++++-
>   arch/x86/virt/vmx/tdx/tdx.h |  5 +++++
>   2 files changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 674867bccc14..faf8355965a5 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -11,6 +11,8 @@
>   #include <linux/cpumask.h>
>   #include <linux/mutex.h>
>   #include <linux/cpu.h>
> +#include <linux/smp.h>
> +#include <linux/atomic.h>
>   #include <asm/msr-index.h>
>   #include <asm/msr.h>
>   #include <asm/cpufeature.h>
> @@ -328,6 +330,39 @@ static int seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
>   	return 0;
>   }
>   
> +/* Data structure to make SEAMCALL on multiple CPUs concurrently */
> +struct seamcall_ctx {
> +	u64 fn;
> +	u64 rcx;
> +	u64 rdx;
> +	u64 r8;
> +	u64 r9;
> +	atomic_t err;
> +	u64 seamcall_ret;
> +	struct tdx_module_output out;
> +};
> +
> +static void seamcall_smp_call_function(void *data)
> +{
> +	struct seamcall_ctx *sc = data;
> +	int ret;
> +
> +	ret = seamcall(sc->fn, sc->rcx, sc->rdx, sc->r8, sc->r9,
> +			&sc->seamcall_ret, &sc->out);
> +	if (ret)
> +		atomic_set(&sc->err, ret);
> +}
> +
> +/*
> + * Call the SEAMCALL on all online cpus concurrently.
> + * Return error if SEAMCALL fails on any cpu.
> + */
> +static int seamcall_on_each_cpu(struct seamcall_ctx *sc)
> +{
> +	on_each_cpu(seamcall_smp_call_function, sc, true);
> +	return atomic_read(&sc->err);
> +}
> +
>   static inline bool p_seamldr_ready(void)
>   {
>   	return !!p_seamldr_info.p_seamldr_ready;
> @@ -437,7 +472,10 @@ static int init_tdx_module(void)
>   
>   static void shutdown_tdx_module(void)
>   {
> -	/* TODO: Shut down the TDX module */
> +	struct seamcall_ctx sc = { .fn = TDH_SYS_LP_SHUTDOWN };
> +
> +	seamcall_on_each_cpu(&sc);

May be check the error and WARN_ON on failure?

> +
>   	tdx_module_status = TDX_MODULE_SHUTDOWN;
>   }
>   
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 6990c93198b3..dcc1f6dfe378 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -35,6 +35,11 @@ struct p_seamldr_info {
>   #define P_SEAMLDR_SEAMCALL_BASE		BIT_ULL(63)
>   #define P_SEAMCALL_SEAMLDR_INFO		(P_SEAMLDR_SEAMCALL_BASE | 0x0)
>   
> +/*
> + * TDX module SEAMCALL leaf functions
> + */
> +#define TDH_SYS_LP_SHUTDOWN	44
> +
>   struct tdx_module_output;
>   u64 __seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
>   	       struct tdx_module_output *out);

-- 
Sathyanarayanan Kuppuswamy
Linux Kernel Developer
