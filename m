Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33455636241
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 15:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236773AbiKWOsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 09:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237215AbiKWOr7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 09:47:59 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BFB64563;
        Wed, 23 Nov 2022 06:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669214878; x=1700750878;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=a+8IwRRWnlMenj05niCZLxI+GsQk8uB7E1I3p8nlM2A=;
  b=XuzY5LWo8gvjvvN8sC0BcdXyj+7hCB+OcMPmIPYxCs6aixedUyI6t5wy
   JAbe+hscn4M8T3nqx99WuM+rfaTdVzXpgaI2jPnPHtUjeUgw0Rx0xSZqU
   hMFt7Fvj1qpNTkGqi0pWbumS28ZnvPnGiQ3ktXJ0tcP6XtcLFx14afMo7
   1ekLNb817ksOzEzqb55F8yEksKpdr3Q8es/YFsSflOvYbEGyWWYP0aAVl
   wpgF24cPpt2o0noTHjuqg1BDVHuFbIS284GKj1v13cQU+Dw3+oxFjofkk
   XvxOYlodTivbnolU4augWefPW3fuVe5EZKUpr0isF8MbCf3LuzXqccVAR
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="340959168"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="340959168"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 06:47:58 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="730803960"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="730803960"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.249.168.208]) ([10.249.168.208])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 06:47:56 -0800
Message-ID: <731bcbc7-67dd-44d1-4e19-2ae165f16beb@linux.intel.com>
Date:   Wed, 23 Nov 2022 22:47:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v10 100/108] KVM: TDX: Handle TDX PV report fatal error
 hypercall
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <82671e3e811ab5ad423e125186c050f46621dd86.1667110240.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <82671e3e811ab5ad423e125186c050f46621dd86.1667110240.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/30/2022 2:23 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> Wire up TDX PV report fatal error hypercall to KVM_SYSTEM_EVENT_CRASH KVM
> exit event.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c   | 20 ++++++++++++++++++++
>   include/uapi/linux/kvm.h |  1 +
>   2 files changed, 21 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index e3062c245e70..16f168f4f21a 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1068,6 +1068,24 @@ static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
>   	return 1;
>   }
>   
> +static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * Exit to userspace device model for teardown.
> +	 * Because guest TD is already panicing

panicking


> , returning an error to guerst

typo, guest



>   TD
> +	 * doesn't make sense.  No argument check is done.
> +	 */
> +
> +	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> +	vcpu->run->system_event.type = KVM_SYSTEM_EVENT_TDX;
> +	vcpu->run->system_event.ndata = 3;
> +	vcpu->run->system_event.data[0] = TDG_VP_VMCALL_REPORT_FATAL_ERROR;
> +	vcpu->run->system_event.data[1] = tdvmcall_a0_read(vcpu);
> +	vcpu->run->system_event.data[2] = tdvmcall_a1_read(vcpu);
> +
> +	return 0;
> +}
> +
>   static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>   {
>   	if (tdvmcall_exit_type(vcpu))
> @@ -1086,6 +1104,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>   		return tdx_emulate_rdmsr(vcpu);
>   	case EXIT_REASON_MSR_WRITE:
>   		return tdx_emulate_wrmsr(vcpu);
> +	case TDG_VP_VMCALL_REPORT_FATAL_ERROR:
> +		return tdx_report_fatal_error(vcpu);
>   	default:
>   		break;
>   	}
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 49386e4de8b8..504a8f73284b 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -478,6 +478,7 @@ struct kvm_run {
>   #define KVM_SYSTEM_EVENT_WAKEUP         4
>   #define KVM_SYSTEM_EVENT_SUSPEND        5
>   #define KVM_SYSTEM_EVENT_SEV_TERM       6
> +#define KVM_SYSTEM_EVENT_TDX            7
>   			__u32 type;
>   			__u32 ndata;
>   			union {
