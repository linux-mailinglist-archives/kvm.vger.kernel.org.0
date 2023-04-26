Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4936EF7A8
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 17:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241092AbjDZPT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 11:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbjDZPT1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 11:19:27 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654CE30E5;
        Wed, 26 Apr 2023 08:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682522366; x=1714058366;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xGuWhmIvZUObihipML0kUSaC7fW30PvqPKfyEWpF0sM=;
  b=SBicZZbKDrzUOO1TE0kWaQzYqjCXuQg4EajIIWENhmSuVKRG/MFekZfI
   GjWEGVRe6YHLoDBHVNxuHT1vmOdX+T/b2OORqD0/rz864wqIRx7UunEHF
   hgZZGXWjtNo6hPyBIBcykjFnp3BYvzIE2Qlfu7kdK5XJ88PmODIy75jVy
   OPtGcVv0T/MOflB8PAXA8cvGMKaQPQY09AbbkJj3z4BWHNQYLsbkkLZWH
   S0Nm+Uvi6iR3km8rHZdEaQiDNJwW1RB5qrE8jVSO9eudPCcMNXzwdEf6q
   3jAxvrjK6u2JYsI47+peIvgBBHlqylJGtl0r0kXEh4lpWacnkdNHeQHM1
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="412446761"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="412446761"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 08:19:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="671368625"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="671368625"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.249.168.108]) ([10.249.168.108])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 08:19:20 -0700
Message-ID: <3a71a01f-4c3d-f92c-58d7-2c124a0efa94@intel.com>
Date:   Wed, 26 Apr 2023 23:19:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH] KVM: x86: Add a vCPU stat for #AC exceptions
To:     Anselm Busse <abusse@amazon.com>
Cc:     dwmw@amazon.co.uk, hborghor@amazon.de, sironi@amazon.de,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230426082601.85372-1-abusse@amazon.com>
Content-Language: en-US
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20230426082601.85372-1-abusse@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/26/2023 4:26 PM, Anselm Busse wrote:
> This patch adds a KVM vCPU stat that reflects the number of #AC
> exceptions caused by a guest. This improves the identification and
> debugging of issues that are possibly caused by guests triggering
> split-locks and allows more insides compared to the current situation
> of having only a warning printed when an #AC exception is raised.

Note, on Intel platform, #AC exception has three sources according to 
the latest spec:

1. violation on alignment check when CPL = 3, while CR0.AM and EFLAG.AC 
are set;

2. split lock, when MSR_MEMORY_CTRL.[29] is set;

3. UC lock, when CPUID.0x7_0x2:EDX[16] is 1 and 
MSR_MEMORY_CTRL(0x33).[28] is 1. (see ISE version 048);

you cannot treat every #AC as split lock #AC.

> Signed-off-by: Anselm Busse <abusse@amazon.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 1 +
>   arch/x86/kvm/vmx/vmx.c          | 2 ++
>   arch/x86/kvm/x86.c              | 1 +
>   3 files changed, 4 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 808c292ad3f4..b4ab719fbc69 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1523,6 +1523,7 @@ struct kvm_vcpu_stat {
>   	u64 preemption_other;
>   	u64 guest_mode;
>   	u64 notify_window_exits;
> +	u64 split_lock_exceptions;
>   };
>   
>   struct x86_instruction_info;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d2d6e1b6c788..8f48fd8ddead 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5309,6 +5309,8 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>   		kvm_run->debug.arch.exception = ex_no;
>   		break;
>   	case AC_VECTOR:
> +		vmx->vcpu.stat.split_lock_exceptions++;
> +
>   		if (vmx_guest_inject_ac(vcpu)) {
>   			kvm_queue_exception_e(vcpu, AC_VECTOR, error_code);
>   			return 1;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3d852ce84920..416a1ed6c423 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -297,6 +297,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>   	STATS_DESC_COUNTER(VCPU, preemption_other),
>   	STATS_DESC_IBOOLEAN(VCPU, guest_mode),
>   	STATS_DESC_COUNTER(VCPU, notify_window_exits),
> +	STATS_DESC_COUNTER(VCPU, split_lock_exceptions),
>   };
>   
>   const struct kvm_stats_header kvm_vcpu_stats_header = {

