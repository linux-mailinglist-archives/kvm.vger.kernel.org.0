Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA2748DC47
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 17:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236930AbiAMQ5f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 11:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiAMQ5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 11:57:34 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770BAC061574
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 08:57:34 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id b3so1608492plc.7
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 08:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IDu36Q/8jeKxXBMvNlI5EGcL6+rCrj1OafVPDxD7U30=;
        b=efdPusnCFU6tDV4fN2YgrIBvga/8ORb5yRUAyUp/OEAwb2yn5Z2+kk4bRET+uNuHos
         FgepAAuSCK1m0IDrzZu38jjoQtHP9et6qYT63Ir+P7WGz0RJMD7kJ53eWjKYYA68UpV/
         7AzSmqTCE37zc2i0SVPyiI0mtjSgVRErpylA7VDVOk1lBihQWBe7EUhjHACIs/kABpMJ
         y701lfjOIRVmnJjjWKlzV1BuFkMjjpMGf3uRoNq/jF9H3JemlYWbBBy5oHpdAbYi1HLT
         Wc/mO8/EXHHVmvgUWwWfBjcQOqx5vkOwbHLvJMamxieqKqqobCK55q+W+dDLDRNz0t1j
         7UmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IDu36Q/8jeKxXBMvNlI5EGcL6+rCrj1OafVPDxD7U30=;
        b=8ANaVc7IIC28lIRZmDwXnes98s6w3DJQrPTOLQJAFQXrqUuScANLKB76SxJuTxdu7Y
         COL2F6E3be3+yVbOgufyk84FDENR1/B9LaUM809En/TrY5qoMKJ8CLQQwavNe6mt4P56
         ci2EP2nAH8y6BI5w9zq3nfT7jySR6GsQhT/6VP4RSz3hVhh5zUaTgX+/hVAxEx7LBPtz
         b9pILT7S/lexCJEXc6fxXyCQQgZ3DY8/KHdf0gb06QbItyZqxrpaNsM3UfuNdGpAEpVj
         0AzUW6Ej8x54h6St1sdlqqTpsk2kildo1mb8AAfDflSardW45vkn7SxUQGf3Ud4rang2
         C5pA==
X-Gm-Message-State: AOAM530Vu0eb95/MrJTTtI+7LeH8wVseKvX4CBKOqn/fJO/Yb94tFXdE
        uWZ60SnQqXlpRzF8M+SqEzyA6g==
X-Google-Smtp-Source: ABdhPJyrGMFHe2XQz3Ed+0GGOjmVEm82BGzMlKYQ/j6vUtuNKzafRsIf1wOM7y5lt4eVVhHz6AGv4w==
X-Received: by 2002:a17:902:d64f:b0:149:4d01:fb42 with SMTP id y15-20020a170902d64f00b001494d01fb42mr5343651plh.13.1642093053759;
        Thu, 13 Jan 2022 08:57:33 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k10sm3138017pfi.52.2022.01.13.08.57.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 08:57:33 -0800 (PST)
Date:   Thu, 13 Jan 2022 16:57:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Liam Merwick <liam.merwick@oracle.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        sean.j.christopherson@intel.com,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: Query about calling kvm_vcpu_gfn_to_memslot() with a GVA (Re:
 [PATCH 1/2] KVM: SVM: avoid infinite loop on NPF from bad address
Message-ID: <YeBZ+QcXUIQ7/fD2@google.com>
References: <20200417163843.71624-2-pbonzini@redhat.com>
 <74de09d4-6c3a-77e1-5051-c122de712f9b@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74de09d4-6c3a-77e1-5051-c122de712f9b@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 13, 2022, Liam Merwick wrote:
> On Fri, Apr 17, 2020 at 12:38:42PM -0400, Paolo Bonzini wrote:
> > When a nested page fault is taken from an address that does not have
> > a memslot associated to it, kvm_mmu_do_page_fault returns RET_PF_EMULATE
> > (via mmu_set_spte) and kvm_mmu_page_fault then invokes
> svm_need_emulation_on_page_fault.
> >
> > The default answer there is to return false, but in this case this just
> > causes the page fault to be retried ad libitum.  Since this is not a
> > fast path, and the only other case where it is taken is an erratum,
> > just stick a kvm_vcpu_gfn_to_memslot check in there to detect the
> > common case where the erratum is not happening.
> >
> > This fixes an infinite loop in the new set_memory_region_test.
> >
> > Fixes: 05d5a4863525 ("KVM: SVM: Workaround errata#1096 (insn_len maybe
> zero on SMAP violation)")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/kvm/svm/svm.c | 7 +++++++
> >  virt/kvm/kvm_main.c    | 1 +
> >  2 files changed, 8 insertions(+)
> >
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index a91e397d6750..c86f7278509b 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -3837,6 +3837,13 @@ static bool svm_need_emulation_on_page_fault(struct
> kvm_vcpu *vcpu)
> >  	bool smap = cr4 & X86_CR4_SMAP;
> >  	bool is_user = svm_get_cpl(vcpu) == 3;
> >
> > +	/*
> > +	 * If RIP is invalid, go ahead with emulation which will cause an
> > +	 * internal error exit.
> > +	 */
> > +	if (!kvm_vcpu_gfn_to_memslot(vcpu, kvm_rip_read(vcpu) >> PAGE_SHIFT))
> 
> When looking into an SEV issue it was noted that the second arg to
> kvm_vcpu_gfn_to_memslot() is a gfn_t but kvm_rip_read() will return guest
> RIP which is a guest virtual address and memslots hold guest physical
> addresses. How is KVM supposed to translate it to a memslot
> and indicate if the guest RIP is valid?

Ugh, magic?  That code is complete garbage.  It worked to fix the selftest issue
because the selftest identity maps the relevant guest code.

The entire idea is a hack.  If KVM gets into an infinite loop because the guest
is attempting to fetch from MMIO, then the #NPF/#PF should have the FETCH bit set
in the error code.  I.e. I believe the below change should fix the original issue,
at which point we can revert the above.  I'll test today and hopefully get a patch
sent out.

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c3d9006478a4..e1d2a46e06bf 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1995,6 +1995,17 @@ static void svm_set_dr7(struct kvm_vcpu *vcpu, unsigned long value)
        vmcb_mark_dirty(svm->vmcb, VMCB_DR);
 }

+static char *svm_get_pf_insn_bytes(struct vcpu_svm *svm)
+{
+       if (!static_cpu_has(X86_FEATURE_DECODEASSISTS))
+               return NULL;
+
+       if (svm->vmcb->control.exit_info_1 & PFERR_FETCH_MASK)
+               return NULL;
+
+       return svm->vmcb->control.insn_bytes;
+}
+
 static int pf_interception(struct kvm_vcpu *vcpu)
 {
        struct vcpu_svm *svm = to_svm(vcpu);
@@ -2003,9 +2014,8 @@ static int pf_interception(struct kvm_vcpu *vcpu)
        u64 error_code = svm->vmcb->control.exit_info_1;

        return kvm_handle_page_fault(vcpu, error_code, fault_address,
-                       static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
-                       svm->vmcb->control.insn_bytes : NULL,
-                       svm->vmcb->control.insn_len);
+                                    svm_get_pf_insn_bytes(svm),
+                                    svm->vmcb->control.insn_len);
 }

 static int npf_interception(struct kvm_vcpu *vcpu)
@@ -2017,9 +2027,8 @@ static int npf_interception(struct kvm_vcpu *vcpu)

        trace_kvm_page_fault(fault_address, error_code);
        return kvm_mmu_page_fault(vcpu, fault_address, error_code,
-                       static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
-                       svm->vmcb->control.insn_bytes : NULL,
-                       svm->vmcb->control.insn_len);
+                                 svm_get_pf_insn_bytes(svm),
+                                 svm->vmcb->control.insn_len);
 }

 static int db_interception(struct kvm_vcpu *vcpu)
