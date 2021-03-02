Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4026032A6D6
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1575876AbhCBPxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 10:53:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:29278 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232759AbhCBAvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 19:51:35 -0500
IronPort-SDR: BHq/Bw+iF7q/iC9AindFVLDZ23eCswXmh6KRj7oZCwH3P2eUy/RLI7YWPvpMMQlPpeRJ+2dM1k
 +Hvm+9nGr2ww==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="186760064"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="186760064"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 16:50:37 -0800
IronPort-SDR: dqy3hV9UQna8YMyFddiYA90+14nnlnjcQpuU1sF7AyhwRQa6//MPQQCA9FjHlxDwOOCJKc3FCM
 110kEtkz034g==
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="397992096"
Received: from yueliu2-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.139.111])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 16:50:33 -0800
Date:   Tue, 2 Mar 2021 13:50:31 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com
Subject: Re: [PATCH 19/25] KVM: VMX: Add basic handling of VM-Exit from SGX
 enclave
Message-Id: <20210302135031.afc28d2efc2d5ead57983d21@intel.com>
In-Reply-To: <YD0bvUPfTRsxnTfT@google.com>
References: <cover.1614590788.git.kai.huang@intel.com>
        <918aaa770de5d98cf81cce8b6cdb6faad32cbeb7.1614590788.git.kai.huang@intel.com>
        <YD0bvUPfTRsxnTfT@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 1 Mar 2021 08:52:13 -0800 Sean Christopherson wrote:
> On Mon, Mar 01, 2021, Kai Huang wrote:
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 50810d471462..df8e338267aa 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -1570,12 +1570,18 @@ static int vmx_rtit_ctl_check(struct kvm_vcpu *vcpu, u64 data)
> >  
> >  static bool vmx_can_emulate_instruction(struct kvm_vcpu *vcpu, void *insn, int insn_len)
> >  {
> > +	if (to_vmx(vcpu)->exit_reason.enclave_mode) {
> > +		kvm_queue_exception(vcpu, UD_VECTOR);
> 
> Rereading my own code, I think it would be a good idea to add a comment here
> explaining that injecting #UD is technically wrong, but avoids giving guest
> userspace an easy way to DoS the guest.  The EPT misconfig is a good example;
> guest userspace could have executed a simple MOV <reg>, <mem> instruction, in
> which case injecting a #UD is bizarre behavior.  But, the alternative is exiting
> to userspace with KVM_INTERNAL_ERROR_EMULATION, which is all but guaranteed to
> kill the guest.
> 
> If KVM, specifically handle_emulation_failure(), ever gains a more sophisticated
> mechanism for handling userspace emulation errors, this should be updated too.
> 
> 	/*
> 	 * Emulation of instructions in SGX enclaves is impossible as RIP does
> 	 * not point  tthe failing instruction, and even if it did, the code
> 	 * stream is inaccessible.  Inject #UD instead of exiting to userspace
> 	 * so that guest userspace can't DoS the guest simply by triggering
> 	 * emulation (enclaves are CPL3 only).
> 	 */

Agreed. Will add above comment.

> 
> > +		return false;
> > +	}
> >  	return true;
> >  }
> 
> ...
> 
> > @@ -5384,6 +5415,9 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
> >  {
> >  	gpa_t gpa;
> >  
> > +	if (!vmx_can_emulate_instruction(vcpu, NULL, 0))
> > +		return 1;
> > +
> >  	/*
> >  	 * A nested guest cannot optimize MMIO vmexits, because we have an
> >  	 * nGPA here instead of the required GPA.
> > -- 
> > 2.29.2
> > 
