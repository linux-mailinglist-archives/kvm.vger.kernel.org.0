Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF01294511
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 00:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439035AbgJTWTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 18:19:48 -0400
Received: from mga06.intel.com ([134.134.136.31]:64503 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439030AbgJTWTs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 18:19:48 -0400
IronPort-SDR: VnnyZUdScRSZxd3INidwHYtlyXW8ZI8utZNKEEKvU8oxuFgUpKvFy2qbAtrV0WcyXEov/X+E/i
 Z6GxPnEW2eZA==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="228912474"
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="228912474"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 15:19:47 -0700
IronPort-SDR: YufWTnp5j+7SXsjq4win+/pcvnwB/sv/SnI32MAf1NNt5ZG+Ajz2xYkc7INY7eWXBDJmnOWKk1
 RSSVfKJt509w==
X-IronPort-AV: E=Sophos;i="5.77,399,1596524400"; 
   d="scan'208";a="301884020"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 15:19:46 -0700
Date:   Tue, 20 Oct 2020 15:19:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND v4 2/2] KVM: VMX: Enable bus lock VM exit
Message-ID: <20201020221943.GB9031@linux.intel.com>
References: <20201012033542.4696-1-chenyi.qiang@intel.com>
 <20201012033542.4696-3-chenyi.qiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012033542.4696-3-chenyi.qiang@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 12, 2020 at 11:35:42AM +0800, Chenyi Qiang wrote:
> @@ -6138,6 +6149,26 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  	return 0;
>  }
>  
> +static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
> +{
> +	int ret = __vmx_handle_exit(vcpu, exit_fastpath);
> +
> +	/*
> +	 * Even when current exit reason is handled by KVM internally, we
> +	 * still need to exit to user space when bus lock detected to inform
> +	 * that there is a bus lock in guest.
> +	 */
> +	if (to_vmx(vcpu)->exit_reason.bus_lock_detected) {
> +		if (ret > 0)
> +			vcpu->run->exit_reason = KVM_EXIT_BUS_LOCK;
> +		else
> +			vcpu->run->flags |= KVM_RUN_BUS_LOCK;

This should always set flags.KVM_RUN_BUS_LOCK, e.g. so that userspace can
always check flags.KVM_RUN_BUS_LOCK instead of having to check both the flag
and the exit reason.  As is, it's really bad because the flag is undefined,
which could teach userspace to do the wrong thing.

> +		return 0;
> +	}
> +	vcpu->run->flags &= ~KVM_RUN_BUS_LOCK;

Hmm, I feel like explicitly clearing flags is should be unnecessary.  By
that, I mean that's it's necessary in the current patch, bit I think we should
figure out how to make that not be the case.  With the current approach, every
chunk of code that needs to set a flag also needs to clear it, which increases
the odds of missing a case and ending up with a flag in an undefined state.

The easiest way I can think of is to add another prep patch that zeros
run->flags at the beginning of kvm_arch_vcpu_ioctl_run(), and changes
post_kvm_run_save() to do:

	if (is_smm(vcpu))
		kvm_run->flags |= KVM_RUN_X86_SMM;

Then this patch can omit clearing KVM_RUN_BUS_LOCK, and doesn't have to touch
the SMM flag.

> +	return ret;
> +}
> +
>  /*
>   * Software based L1D cache flush which is used when microcode providing
>   * the cache control MSR is not loaded.
