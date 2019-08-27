Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5519F26F
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 20:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730651AbfH0Sfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 14:35:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9523 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730262AbfH0Sfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 14:35:53 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7C8934E832;
        Tue, 27 Aug 2019 18:35:53 +0000 (UTC)
Received: from flask (unknown [10.43.2.55])
        by smtp.corp.redhat.com (Postfix) with SMTP id 77BF460C05;
        Tue, 27 Aug 2019 18:35:50 +0000 (UTC)
Received: by flask (sSMTP sendmail emulation); Tue, 27 Aug 2019 20:35:49 +0200
Date:   Tue, 27 Aug 2019 20:35:49 +0200
From:   Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] KVM: x86: Don't update RIP or do single-step on faulting
 emulation
Message-ID: <20190827183549.GC65641@flask>
References: <20190823205544.24052-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190823205544.24052-1-sean.j.christopherson@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 27 Aug 2019 18:35:53 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

2019-08-23 13:55-0700, Sean Christopherson:
> Don't advance RIP or inject a single-step #DB if emulation signals a
> fault.  This logic applies to all state updates that are conditional on
> clean retirement of the emulation instruction, e.g. updating RFLAGS was
> previously handled by commit 38827dbd3fb85 ("KVM: x86: Do not update
> EFLAGS on faulting emulation").
> 
> Not advancing RIP is likely a nop, i.e. ctxt->eip isn't updated with
> ctxt->_eip until emulation "retires" anyways.  Skipping #DB injection
> fixes a bug reported by Andy Lutomirski where a #UD on SYSCALL due to
> invalid state with RFLAGS.RF=1 would loop indefinitely due to emulation
> overwriting the #UD with #DB and thus restarting the bad SYSCALL over
> and over.
> 
> Cc: Nadav Amit <nadav.amit@gmail.com>
> Cc: stable@vger.kernel.org
> Reported-by: Andy Lutomirski <luto@kernel.org>
> Fixes: 663f4c61b803 ("KVM: x86: handle singlestep during emulation")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> 
> Note, this has minor conflict with my recent series to cleanup the
> emulator return flows[*].  The end result should look something like:
> 
>                 if (!ctxt->have_exception ||
>                     exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
>                         kvm_rip_write(vcpu, ctxt->eip);
>                         if (r && ctxt->tf)
>                                 r = kvm_vcpu_do_singlestep(vcpu);
>                         __kvm_set_rflags(vcpu, ctxt->eflags);
>                 }
> 
> [*] https://lkml.kernel.org/r/20190823010709.24879-1-sean.j.christopherson@intel.com
> 
>  arch/x86/kvm/x86.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b4cfd786d0b6..d2962671c3d3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6611,12 +6611,13 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
>  		unsigned long rflags = kvm_x86_ops->get_rflags(vcpu);
>  		toggle_interruptibility(vcpu, ctxt->interruptibility);
>  		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
> -		kvm_rip_write(vcpu, ctxt->eip);
> -		if (r == EMULATE_DONE && ctxt->tf)
> -			kvm_vcpu_do_singlestep(vcpu, &r);
>  		if (!ctxt->have_exception ||
> -		    exception_type(ctxt->exception.vector) == EXCPT_TRAP)
> +		    exception_type(ctxt->exception.vector) == EXCPT_TRAP) {

Hm, EXCPT_TRAP is either #OF, #BP, or another #DB, none of which we want
to override.  The first two disable TF and the last one is the same as
its fault variant must take other path, so it works out in the end...

I've fixed the RF in commit message when applying, thanks.

---
We still seem to have at least a minor problem with single stepping:

SDM, Interrupt 1—Debug Exception (#DB):

  The following items detail the treatment of debug exceptions on the
  instruction boundary following execution of the MOV or the POP
  instruction that loads the SS register:
    • If EFLAGS.TF is 1, no single-step trap is generated.

I think a check for KVM_X86_SHADOW_INT_MOV_SS in
kvm_vcpu_do_singlestep() is missing.
