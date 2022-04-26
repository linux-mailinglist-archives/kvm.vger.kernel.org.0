Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0EC510AD2
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 22:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355185AbiDZVAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 17:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354172AbiDZU77 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 16:59:59 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995363EABB;
        Tue, 26 Apr 2022 13:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651006610; x=1682542610;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Y0ulhIQqzBKXGy12E1sQmGLQd0l893bCe6cbVpbAvyQ=;
  b=LWJzByo2JNnwo3XpCKOvdwLvPUj4Y5ywzF3swDN8vYSxz6+hVokWI428
   cmdSHbwOdV7Qe40KgXOAZuo7JwF5EnxMzHvJ+TnGs3fbrjp1PobMNAuNM
   LHBcbAA/ggLKttOhawqyUdIEVXxTt63fCy+1kNPZQVy7j1FFE9P+E2pS9
   YFcmIVnzbVDx51/5f0kFKcixqHfrEZc/91lg+D2T7FIlyTiDPfITzQEWJ
   THFu5b9jOoqQd4mC+IUfg75lscMzMqYlZa7ZmCM1qU7+ZoSNSowYHQtiF
   cBxwqpF/l+curpmkNuAaKy71j7L1b74kxjYBMW4k72o+GWImjUYlmoF+V
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="265243134"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="265243134"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 13:56:50 -0700
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="580153799"
Received: from dsocek-mobl2.amr.corp.intel.com (HELO [10.212.69.119]) ([10.212.69.119])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 13:56:48 -0700
Message-ID: <b3c81b7f-3016-8f4e-3ac5-bff1fc52a879@intel.com>
Date:   Tue, 26 Apr 2022 13:59:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 06/21] x86/virt/tdx: Shut down TDX module in case of
 error
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, len.brown@intel.com,
        tony.luck@intel.com, rafael.j.wysocki@intel.com,
        reinette.chatre@intel.com, dan.j.williams@intel.com,
        peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com
References: <cover.1649219184.git.kai.huang@intel.com>
 <3f19ac995d184e52107e7117a82376cb7ecb35e7.1649219184.git.kai.huang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <3f19ac995d184e52107e7117a82376cb7ecb35e7.1649219184.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/5/22 21:49, Kai Huang wrote:
> TDX supports shutting down the TDX module at any time during its
> lifetime.  After TDX module is shut down, no further SEAMCALL can be
> made on any logical cpu.

Is this strictly true?

I thought SEAMCALLs were used for the P-SEAMLDR too.

> Shut down the TDX module in case of any error happened during the
> initialization process.  It's pointless to leave the TDX module in some
> middle state.
> 
> Shutting down the TDX module requires calling TDH.SYS.LP.SHUTDOWN on all
> BIOS-enabled cpus, and the SEMACALL can run concurrently on different
> cpus.  Implement a mechanism to run SEAMCALL concurrently on all online
> cpus.  Logical-cpu scope initialization will use it too.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 40 ++++++++++++++++++++++++++++++++++++-
>  arch/x86/virt/vmx/tdx/tdx.h |  5 +++++
>  2 files changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 674867bccc14..faf8355965a5 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -11,6 +11,8 @@
>  #include <linux/cpumask.h>
>  #include <linux/mutex.h>
>  #include <linux/cpu.h>
> +#include <linux/smp.h>
> +#include <linux/atomic.h>
>  #include <asm/msr-index.h>
>  #include <asm/msr.h>
>  #include <asm/cpufeature.h>
> @@ -328,6 +330,39 @@ static int seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
>  	return 0;
>  }
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

Why bother returning something that's not read?

>  static inline bool p_seamldr_ready(void)
>  {
>  	return !!p_seamldr_info.p_seamldr_ready;
> @@ -437,7 +472,10 @@ static int init_tdx_module(void)
>  
>  static void shutdown_tdx_module(void)
>  {
> -	/* TODO: Shut down the TDX module */
> +	struct seamcall_ctx sc = { .fn = TDH_SYS_LP_SHUTDOWN };
> +
> +	seamcall_on_each_cpu(&sc);
> +
>  	tdx_module_status = TDX_MODULE_SHUTDOWN;
>  }
>  
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index 6990c93198b3..dcc1f6dfe378 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -35,6 +35,11 @@ struct p_seamldr_info {
>  #define P_SEAMLDR_SEAMCALL_BASE		BIT_ULL(63)
>  #define P_SEAMCALL_SEAMLDR_INFO		(P_SEAMLDR_SEAMCALL_BASE | 0x0)
>  
> +/*
> + * TDX module SEAMCALL leaf functions
> + */
> +#define TDH_SYS_LP_SHUTDOWN	44
> +
>  struct tdx_module_output;
>  u64 __seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
>  	       struct tdx_module_output *out);

