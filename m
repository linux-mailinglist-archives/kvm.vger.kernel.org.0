Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20CFB672F2
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 18:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbfGLQDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 12:03:54 -0400
Received: from mga18.intel.com ([134.134.136.126]:36561 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbfGLQDx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 12:03:53 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jul 2019 09:03:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,483,1557212400"; 
   d="scan'208";a="174485411"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Jul 2019 09:03:52 -0700
Date:   Fri, 12 Jul 2019 09:03:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Tao Xu <tao3.xu@intel.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, xiaoyao.li@linux.intel.com,
        jingqi.liu@intel.com
Subject: Re: [PATCH v7 3/3] KVM: vmx: handle vm-exit for UMWAIT and TPAUSE
Message-ID: <20190712160352.GD29659@linux.intel.com>
References: <20190712082907.29137-1-tao3.xu@intel.com>
 <20190712082907.29137-4-tao3.xu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712082907.29137-4-tao3.xu@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 12, 2019 at 04:29:07PM +0800, Tao Xu wrote:
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5213,6 +5213,9 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
>  	case EXIT_REASON_ENCLS:
>  		/* SGX is never exposed to L1 */
>  		return false;
> +	case EXIT_REASON_UMWAIT: case EXIT_REASON_TPAUSE:

Grouped case statements are usually stacked vertically, e.g.:

	case EXIT_REASON_UMWAIT:
	case EXIT_REASON_TPAUSE:

> +		return nested_cpu_has2(vmcs12,
> +			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE);
>  	default:
>  		return true;
>  	}
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 0787f140d155..e026b1313dc3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5349,6 +5349,20 @@ static int handle_monitor(struct kvm_vcpu *vcpu)
>  	return handle_nop(vcpu);
>  }
>  
> +static int handle_umwait(struct kvm_vcpu *vcpu)
> +{
> +	kvm_skip_emulated_instruction(vcpu);
> +	WARN(1, "this should never happen\n");

Blech.  I'm guessing this code was copy-pasted from handle_xsaves() and
handle_xrstors().  The blurb of "this should never happen" isn't very
helpful, e.g. the WARN itself makes it pretty obvious that we don't expect
to reach this point.  WARN_ONCE would also be preferable, no need to spam
the log in the event things go completely haywire.

Rather than propagate ugly code, what about defining a common helper, e.g.

static int handle_unexpected_vmexit(struct kvm_vcpu *vcpu)
{
	kvm_skip_emulated_instruction(vcpu);
	WARN_ONCE(1, "Unexpected VM-Exit = 0x%x", vmcs_read32(VM_EXIT_REASON));
	return 1;
}

...
{
	[EXIT_REASON_XSAVES]                  = handle_unexpected_vmexit,
	[EXIT_REASON_XRSTORS]                 = handle_unexpected_vmexit,

	[EXIT_REASON_UMWAIT]                  = handle_unexpected_vmexit,
	[EXIT_REASON_TPAUSE]                  = handle_unexpected_vmexit,

}

> +	return 1;
> +}
> +
> +static int handle_tpause(struct kvm_vcpu *vcpu)
> +{
> +	kvm_skip_emulated_instruction(vcpu);
> +	WARN(1, "this should never happen\n");
> +	return 1;
> +}
> +
>  static int handle_invpcid(struct kvm_vcpu *vcpu)
>  {
>  	u32 vmx_instruction_info;
> @@ -5559,6 +5573,8 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[EXIT_REASON_VMFUNC]		      = handle_vmx_instruction,
>  	[EXIT_REASON_PREEMPTION_TIMER]	      = handle_preemption_timer,
>  	[EXIT_REASON_ENCLS]		      = handle_encls,
> +	[EXIT_REASON_UMWAIT]                  = handle_umwait,
> +	[EXIT_REASON_TPAUSE]                  = handle_tpause,
>  };
>  
>  static const int kvm_vmx_max_exit_handlers =
> -- 
> 2.20.1
> 
