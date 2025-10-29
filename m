Return-Path: <kvm+bounces-61369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9066AC1782E
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 01:20:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6B94950449C
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 00:19:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B7E124DCEB;
	Wed, 29 Oct 2025 00:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y7GXAFqX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75914231A41
	for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 00:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761697102; cv=none; b=gy7MePvm7NZyGZxizpv/4vOK6Rpaopr49pn+hxK/mZ17AJayEZRauwMa2xsBkTai6ZuOKH/5LvuO8swtCBRUDwATBYI6enaJmxxgRfRbVrVSkNzFx0tn8h4YJBQAtyz7NhVunQcG2tksWpAJ0/VAZmp1jpvL3Tbq3QZ0Cgi21jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761697102; c=relaxed/simple;
	bh=22/nznoWxrr1M4DyGKwTP7a2kVlwm2rr2jC9dcrWhcs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tZjaVl2vH8mwsI2jpQuktgUu8tIJ0k0m5wpxT3OeKNQjUzaq1gpeV4NQi+q94MCQIbDfMAwLParrygy+ktrVygQrQKKbFvNMZbd7wI4kuHdaWQcp2BqN1sPHRlRWaJjpbYNQqZN6wofYoIjYdgQLwduP8GcZh4GNXXts1BOc+UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y7GXAFqX; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2904e9e0ef9so122248715ad.3
        for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 17:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761697100; x=1762301900; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qy2qXVOYw07i2SUD7z+JY9/nqRL+5ts2SDInMchoxOI=;
        b=y7GXAFqX/a5dWzggLnNzwI0KQvubltHafzQaz5kvFmIxi9Z9SUMAQXDLFoY/hOnt3p
         NLCYdabuFX62l5G57hVWkg0dkXDHDHou7vF7q9w9FVWr0SVPa090TCZ+e01tRGV8PcLr
         78WTqPc0vt3f1Y4tjM3Z6E1Wj9MRssjmOhdVQoVxfl43v44ZndHLGIH2CIb9aeVCE5pX
         EGCvU1UvZ375DFnV/2dk85jxQqh9Rwu4HFb/2XQ7GZBJQyt8q4/rfuhC+BDtcTfWYMZl
         5xxMvzReNvKSQGDkad9AbC8ZHhsQywSXU5BjqIAbQtZ/7lBMEGVQl2QZQO6HnJF39usd
         NoRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761697100; x=1762301900;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qy2qXVOYw07i2SUD7z+JY9/nqRL+5ts2SDInMchoxOI=;
        b=WzVssqPvkAPZrcHiguWSkaWmZJ/FmmIDDxOS82P1m+H4V+fBGq1AowB4s6Gk81fQ1o
         iFRy3He1N0QxFi503Xx/ZrMzUEXgUdzPFJ5AKPXkhhtN5UEIe4IdfqJ/yqi+fTiPW3Qk
         G+D0kdznAPvgyJEfa/z8pbpl2H3JXh0C13b81O6YBycWGGq73bDRSWXBfd51VJK0E7XA
         I7ISB0k6y0+B7QLxls3JnCW71wq0x2/plpLCxWigdQ5CMyOc74hsBgF9k2+nDcm2/7P4
         ijSX8y2PAVe1t/dhieSo8AL0820UZHwAdCnhXrb2etURmapSRKAvtkm2tSEHkiZ8s9LD
         fZ/A==
X-Forwarded-Encrypted: i=1; AJvYcCWeU6b8ic4t7kPAR+GZ/NHN0hyVavGxSvy+NjgAfd16g/pAlZK7Fw6r46O6iE3NsJOwYbE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdzzC511V2F3q0LNlWI6iq+9O+mUtK7JJezyKeDM3nIC+RR5Hh
	1BErRySXWy7y7dwnsZEWXiVcgIEskI5HftbyZUll0tO1nsTclVWL7eABrxr98ygMhSkowYU8p2k
	dA4tNEg==
X-Google-Smtp-Source: AGHT+IEmIeoh8oylkl0P3Y0Ro5ZGOZkHHEfj3tw0WwaV3db7iM3hKqb44CM5SLy2kyTf7DJrc+4+zvtYX70=
X-Received: from plld6.prod.google.com ([2002:a17:902:7286:b0:26a:23c7:68d3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2301:b0:272:a900:c42b
 with SMTP id d9443c01a7336-294dee996f7mr13719855ad.31.1761697099721; Tue, 28
 Oct 2025 17:18:19 -0700 (PDT)
Date: Tue, 28 Oct 2025 17:18:18 -0700
In-Reply-To: <aQBmME40vhf-lh7R@telecaster>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <71043b76fc073af0fb27493a8e8d7f38c3c782c0.1761606191.git.osandov@fb.com>
 <aQANT9rvO9FMmmkG@google.com> <aQBmME40vhf-lh7R@telecaster>
Message-ID: <aQFdSkjj1vYmL53a@google.com>
Subject: Re: [PATCH] KVM: SVM: Don't skip unrelated instruction if INT3 is replaced
From: Sean Christopherson <seanjc@google.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Gregory Price <gourry@gourry.net>, kernel-team@fb.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 27, 2025, Omar Sandoval wrote:
> On Mon, Oct 27, 2025 at 05:24:47PM -0700, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 593fccc9cf1c..500f9b7f564e 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9351,6 +9351,23 @@ static bool is_vmware_backdoor_opcode(struct x86_emulate_ctxt *ctxt)
> >         return false;
> >  }
> >  
> > +static bool is_soft_int_instruction(struct x86_emulate_ctxt *ctxt, u8 vector)
> > +{
> > +       if (WARN_ON_ONCE(vector != BP_VECTOR && vector != OF_VECTOR))
> > +               return false;
> 
> This warning triggers when called from the svm_inject_irq() path since
> that case uses vcpu->arch.interrupt.nr. I can't tell whether it'd be
> okay to set vcpu->arch.exception.vector = vcpu->arch.interrupt.nr in
> that case

It's not, they are two separate things/concepts.  Even if we can somehow squeak
by (an exception can't/shouldn't be pending), that crosses over the "acceptable
hack" threshold for me.

> or if we need yet another emultype.

We have enough EMULTYPE bits available, we can just shove the vector into bits
23:16.  That definitely makes me question whether or not handling this in the
emulator is actually better than dealing with it entirely in svm.c, but after
looking at your original patch again, my vote is still to handle it in the
emulator, as there are subtle flaws in the original patch.

-               if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP))
+               if (vector == 0) {

This actually needs to be "vector < 0", with @vector being an "int", as I'm
pretty sure that generating a #DE with INTn is legal.

+                       if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP))
+                               return 0;
+               } else if (x86_decode_emulated_instruction(vcpu, EMULTYPE_SKIP,
+                                                          NULL,
+                                                          0) != EMULATION_OK ||
+                          !emulated_instruction_matches_vector(vcpu, vector) ||
+                          !kvm_emulate_instruction(vcpu,
+                                                   EMULTYPE_SKIP |
+                                                   EMULTYPE_NO_DECODE)) {
                        return 0;

And this early return is flawed because it doesn't unwind save.rflags, which
somewhat confusingly would need to be done irrespective of the value of
@commit_side_effects.  That's easy enough to fix, though the code would be ugly.
All in all, I think dealing with this in SVM would be harder to follow, even
though it would be nice to contain the SVM insanity to SVM :-/

+               }

                if (unlikely(!commit_side_effects))
                        svm->vmcb->save.rflags = old_rflags;

> (I believe my patch had the same problem, but silently.)

Gah, I was looking for that path and couldn't find it.  Hrm, the entire WARN is
somewhat bogus as the INTn case means vector can be anything architecturally
legal.  Side note, that also the "vector == ctxt->src.val" check for 0xcd is
meaningful.

> > +       switch (ctxt->b) {
> > +       case 0xcc:
> > +               return vector == BP_VECTOR;
> > +       case 0xcd:
> > +               return vector == ctxt->src.val;
> > +       case 0xce:
> > +               return vector == OF_VECTOR;
> > +       default:
> > +               return false;
> > +       }
> > +}
> > +
> >  /*
> >   * Decode an instruction for emulation.  The caller is responsible for handling
> >   * code breakpoints.  Note, manually detecting code breakpoints is unnecessary
> > @@ -9461,6 +9478,10 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> >          * injecting single-step #DBs.
> >          */
> >         if (emulation_type & EMULTYPE_SKIP) {
> > +               if ((emulation_type & EMULTYPE_SKIP_SOFT_INT) &&
> 
> This needs to be (emulation_type & EMULTYPE_SKIP_SOFT_INT) == EMULTYPE_SKIP_SOFT_INT
> (either that or making EMULTYPE_SKIP_SOFT_INT not include
> EMULTYPE_SKIP).

Hrm, for consistency with the other EMULTYPE flags, probably best to make it
separate.

> Did you intend to send this out as a patch, or should I send a v2 based
> on this?

Your choice.  I'm happy to send a formal patch, but I'm just as happy to let you
do the testing and take all the credit :-).  If you want, you can also throw a
Co-developed-by: my way, but that's entirely optional.

Roughly this?  In the end, it doesn't look too awful.

---
Signed-off-by: Sean Christopherson <seanjc@google.com>

---
 arch/x86/include/asm/kvm_host.h |  4 ++++
 arch/x86/kvm/svm/svm.c          | 24 +++++++++++++-----------
 arch/x86/kvm/x86.c              | 21 +++++++++++++++++++++
 3 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 48598d017d6f..e6c242d89869 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2153,6 +2153,10 @@ u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
 #define EMULTYPE_PF		    (1 << 6)
 #define EMULTYPE_COMPLETE_USER_EXIT (1 << 7)
 #define EMULTYPE_WRITE_PF_TO_SP	    (1 << 8)
+#define EMULTYPE_SKIP_SOFT_INT	    (1 << 9)
+
+#define EMULTYPE_SET_SOFT_INT_VECTOR(v)	(((v) & 0xff) << 16)
+#define EMULTYPE_GET_SOFT_INT_VECTOR(e)	(((e) >> 16) & 0xff)
 
 static inline bool kvm_can_emulate_event_vectoring(int emul_type)
 {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f14709a511aa..625f51890e29 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -272,6 +272,7 @@ static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
 }
 
 static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
+					   int emul_type,
 					   bool commit_side_effects)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -293,7 +294,7 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
 		if (unlikely(!commit_side_effects))
 			old_rflags = svm->vmcb->save.rflags;
 
-		if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP))
+		if (!kvm_emulate_instruction(vcpu, emul_type))
 			return 0;
 
 		if (unlikely(!commit_side_effects))
@@ -311,11 +312,13 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
 
 static int svm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
-	return __svm_skip_emulated_instruction(vcpu, true);
+	return __svm_skip_emulated_instruction(vcpu, EMULTYPE_SKIP, true);
 }
 
-static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
+static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu, u8 vector)
 {
+	const int emul_type = EMULTYPE_SKIP | EMULTYPE_SKIP_SOFT_INT |
+			      EMULTYPE_GET_SOFT_INT_VECTOR(vector);
 	unsigned long rip, old_rip = kvm_rip_read(vcpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -331,7 +334,7 @@ static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
 	 * in use, the skip must not commit any side effects such as clearing
 	 * the interrupt shadow or RFLAGS.RF.
 	 */
-	if (!__svm_skip_emulated_instruction(vcpu, !nrips))
+	if (!__svm_skip_emulated_instruction(vcpu, emul_type, !nrips))
 		return -EIO;
 
 	rip = kvm_rip_read(vcpu);
@@ -367,7 +370,7 @@ static void svm_inject_exception(struct kvm_vcpu *vcpu)
 	kvm_deliver_exception_payload(vcpu, ex);
 
 	if (kvm_exception_is_soft(ex->vector) &&
-	    svm_update_soft_interrupt_rip(vcpu))
+	    svm_update_soft_interrupt_rip(vcpu, ex->vector))
 		return;
 
 	svm->vmcb->control.event_inj = ex->vector
@@ -3642,11 +3645,12 @@ static bool svm_set_vnmi_pending(struct kvm_vcpu *vcpu)
 
 static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 {
+	struct kvm_queued_interrupt *intr = &vcpu->arch.interrupt;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 type;
 
-	if (vcpu->arch.interrupt.soft) {
-		if (svm_update_soft_interrupt_rip(vcpu))
+	if (intr->soft) {
+		if (svm_update_soft_interrupt_rip(vcpu, intr->nr))
 			return;
 
 		type = SVM_EVTINJ_TYPE_SOFT;
@@ -3654,12 +3658,10 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 		type = SVM_EVTINJ_TYPE_INTR;
 	}
 
-	trace_kvm_inj_virq(vcpu->arch.interrupt.nr,
-			   vcpu->arch.interrupt.soft, reinjected);
+	trace_kvm_inj_virq(intr->nr, intr->soft, reinjected);
 	++vcpu->stat.irq_injections;
 
-	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
-				       SVM_EVTINJ_VALID | type;
+	svm->vmcb->control.event_inj = intr->nr | SVM_EVTINJ_VALID | type;
 }
 
 void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4b5d2d09634..9dc66cca154d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9338,6 +9338,23 @@ static bool is_vmware_backdoor_opcode(struct x86_emulate_ctxt *ctxt)
 	return false;
 }
 
+static bool is_soft_int_instruction(struct x86_emulate_ctxt *ctxt,
+				    int emulation_type)
+{
+	u8 vector = EMULTYPE_GET_SOFT_INT_VECTOR(emulation_type);
+
+	switch (ctxt->b) {
+	case 0xcc:
+		return vector == BP_VECTOR;
+	case 0xcd:
+		return vector == ctxt->src.val;
+	case 0xce:
+		return vector == OF_VECTOR;
+	default:
+		return false;
+	}
+}
+
 /*
  * Decode an instruction for emulation.  The caller is responsible for handling
  * code breakpoints.  Note, manually detecting code breakpoints is unnecessary
@@ -9448,6 +9465,10 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 * injecting single-step #DBs.
 	 */
 	if (emulation_type & EMULTYPE_SKIP) {
+		if (emulation_type & EMULTYPE_SKIP_SOFT_INT &&
+		    !is_soft_int_instruction(ctxt, emulation_type))
+			return 0;
+
 		if (ctxt->mode != X86EMUL_MODE_PROT64)
 			ctxt->eip = (u32)ctxt->_eip;
 		else

base-commit: 4cc167c50eb19d44ac7e204938724e685e3d8057
--

