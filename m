Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFAC2690A7
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 17:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgINPvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 11:51:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:11032 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726570AbgINPtQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 11:49:16 -0400
IronPort-SDR: Hb0sgpb08b0duN4nC0GfuOfdNmwuIR9MRTZh/f4m88FixfMCbJpH23z3GISaVdIOjFTKOdEsjr
 yZKoLQPHTeUw==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="158382439"
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="158382439"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 08:48:58 -0700
IronPort-SDR: sAS51Zd7vK4uPjyKW10il0QyGWylQQ0XKQvEJADi9AWMc+8qMnaCqt8Tm+Som2P+obcsJD3YqT
 uGdaLkmZ4Xhw==
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="301794716"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 08:48:57 -0700
Date:   Mon, 14 Sep 2020 08:48:56 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Paul K ." <kronenpj@kronenpj.dyndns.org>
Subject: Re: [PATCH RESEND 3/3] KVM: SVM: Reenable
 handle_fastpath_set_msr_irqoff() after complete_interrupts()
Message-ID: <20200914154856.GE6855@sjchrist-ice>
References: <1599620237-13156-1-git-send-email-wanpengli@tencent.com>
 <1599620237-13156-3-git-send-email-wanpengli@tencent.com>
 <da8342cc-5c7f-b04a-ed79-8527cf74b746@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da8342cc-5c7f-b04a-ed79-8527cf74b746@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Sep 12, 2020 at 08:15:46AM +0200, Paolo Bonzini wrote:
> The overall patch is fairly simple:
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 03dd7bac8034..d6ce75e107c0 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2938,8 +2938,6 @@ static int handle_exit(struct kvm_vcpu *vcpu,
> fastpath_t exit_fastpath)
>  	if (npt_enabled)
>  		vcpu->arch.cr3 = svm->vmcb->save.cr3;
> 
> -	svm_complete_interrupts(svm);
> -
>  	if (is_guest_mode(vcpu)) {
>  		int vmexit;
> 
> @@ -3504,7 +3502,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct
> kvm_vcpu *vcpu)
>  	stgi();
> 
>  	/* Any pending NMI will happen here */
> -	exit_fastpath = svm_exit_handlers_fastpath(vcpu);
> 
>  	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
>  		kvm_after_interrupt(&svm->vcpu);
> @@ -3537,6 +3534,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct
> kvm_vcpu *vcpu)
>  		     SVM_EXIT_EXCP_BASE + MC_VECTOR))
>  		svm_handle_mce(svm);
> 
> +	svm_complete_interrupts(svm);
> +	exit_fastpath = svm_exit_handlers_fastpath(vcpu);
> +
>  	vmcb_mark_all_clean(svm->vmcb);
>  	return exit_fastpath;
>  }
> 
> so I will just squash everything.

The thought behind the multi-patch series was to allow automatically applying
the fix to the 5.8 stable tree without having to take on the risk of moving
svm_complete_interrupts().
