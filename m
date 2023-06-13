Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB62972EFEB
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 01:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240755AbjFMXUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 19:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233025AbjFMXT6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 19:19:58 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1551BC3
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 16:19:57 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-65252a80823so3613383b3a.1
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 16:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686698396; x=1689290396;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JkQ9jDzdkfw8kDMXLyweZ1MunDOJDJDEoHZrAtEzt+E=;
        b=XVd+zE15yfQ+17ZfxDi+KI7BvefSYsbnEQGVgcHc/rgWYZqumb/xLuGir1rePIn3er
         /FPPPkhf5gcDOi5VZpF+9rLWzgZWKXKbSlxbzyGoFqNarKs5wFhLnUiIvUnpkWaCJIm1
         gU9iI515mdfBgRW71XjgCjfdxJuLehPGM5cyYjWIATitkWcasFFvGpqs5IUWxuJzwW87
         tXultnM6OEL7meT6lNJ9btE9Hni4DE4y8w5b1i8dY+rAamOPhbbMnBtnKXOkXEGKat3V
         IGcdlCobi5KWG5Yf3U/jfr0136BrrlponazLzS+Z9EQVjHf8UAYpdc4dBh35p8LdXA49
         jRwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686698396; x=1689290396;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JkQ9jDzdkfw8kDMXLyweZ1MunDOJDJDEoHZrAtEzt+E=;
        b=RIT7ozIgfVR+a/2QK1LTarQEXwjQlBJp+/DtwXhUP55gfH8SndfeaOhKcntH0RX/NG
         tm18glhNbAP9SDfLjoY29zBLRnfIxIaGi34E3k7iH3jQDZGQAjJfHXD3f2huxJE0r1ZQ
         ry8LgCnwuCOOxTT1OzXVODPDTNns+HAxoUhyy7u2KQ6/dL2VJ+Q5ba7sCEpySnrAbz+/
         tKpm5Vnxpz26P91plxXEdRi/bkz59sxQbTDPWp0szNqPDPUoJfb5b+aFnr43tUSiPDlg
         RrWzeW9p3JyRbyJUGsRbLwj2g0arn4XnOl+xJp4AIBZRYzpdqk8NSu0Q2Vp2jq+UgUxi
         YBRQ==
X-Gm-Message-State: AC+VfDyZPM9nlT07SutV7gJW9BcU1RuxPj3+WUXyK+Cdh2FWvX+G+0Uc
        HqXjy2wdR1qsZpLs7ORGsShCUk7C+jI=
X-Google-Smtp-Source: ACHHUZ7uRu6vjmISuq8l1TDjCnEZ+Jvrzhyj1RqXhJ1l74AbwFhDTE2oa4/Yvd26MppB1/H50IOyi1DuBGw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1252:b0:643:ae47:9bc0 with SMTP id
 u18-20020a056a00125200b00643ae479bc0mr82041pfi.3.1686698396483; Tue, 13 Jun
 2023 16:19:56 -0700 (PDT)
Date:   Tue, 13 Jun 2023 16:19:54 -0700
In-Reply-To: <5e7c6b3d-2c69-59ca-1b9f-2459430e2643@amd.com>
Mime-Version: 1.0
References: <20230411125718.2297768-1-aik@amd.com> <20230411125718.2297768-6-aik@amd.com>
 <ZGv9Td4p1vtXC0Hy@google.com> <719a6b42-fd91-8eb4-f773-9ed98d2fdb07@amd.com>
 <ZGzfWQub4FQOrEtw@google.com> <fc82a8a7-af38-5037-1862-ba2315c4e5af@amd.com>
 <ZHDEkuaVjs/0kM6t@google.com> <64336829-60c5-afe1-81ad-91b4f354aef3@amd.com> <5e7c6b3d-2c69-59ca-1b9f-2459430e2643@amd.com>
Message-ID: <ZIj5ms+DohcLyXHE@google.com>
Subject: Re: [PATCH kernel v5 5/6] KVM: SEV: Enable data breakpoints in SEV-ES
From:   Sean Christopherson <seanjc@google.com>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Pankaj Gupta <pankaj.gupta@amd.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Santosh Shukla <santosh.shukla@amd.com>,
        Carlos Bilbao <carlos.bilbao@amd.com>
Content-Type: multipart/mixed; charset="UTF-8"; boundary="Tsz77BKxl4wQNE2/"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_MIME_HB_SEP,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--Tsz77BKxl4wQNE2/
Content-Type: text/plain; charset=3Diso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Jun 02, 2023, Alexey Kardashevskiy wrote:
> Sean, ping?
>=20
> I wonder if this sev-es-not-singlestepping is a showstopper or it is alri=
ght
> to repost this patchset without it? Thanks,

Ah, shoot, I completely lost this in my inbox.  Sorry :-/

> > > Side topic, isn't there an existing bug regarding SEV-ES NMI windows?
> > > KVM can't actually single-step an SEV-ES guest, but tries to set
> > > RFLAGS.TF anyways.
> >=20
> > Why is it a "bug" and what does the patch fix? Sound to me as it is
> > pointless and the guest won't do single stepping and instead will run
> > till it exits somehow, what do I miss?

The bug is benign in the end, but it's still a bug.  I'm not worried about =
fixing
any behavior, but I dislike having dead, misleading code, especially for so=
mething
like this where both NMI virtualization and SEV-ES are already crazy comple=
x and
subtle.  I think it's safe to say that I've spent more time digging through=
 SEV-ES
and NMI virtualization than most KVM developers, and as evidenced by the nu=
mber of
things I got wrong below, I'm still struggling to keep track of the bigger =
picture.
Developers that are new to all of this need as much help as they can get.

> > > Blech, and suppressing EFER.SVME in efer_trap() is a bit gross,
> >=20
> > Why suppressed? svm_set_efer() sets it eventually anyway.

svm_set_efer() sets SVME in hardware, but KVM's view of the guest's value t=
hat's
stored in vcpu->arch.efer doesn't have SVME set.  E.g. from the guest's per=
spective,
EFER.SVME will have "Reserved Read As Zero" semantics.

> > > but I suppose since the GHCB doesn't allow for CLGI or STGI it's "fin=
e".
> >=20
> > GHCB does not mention this, instead these are always intercepted in
> > init_vmcb().

Right, I'm calling out that the absense of protocol support for requesting =
CLGI
or STGI emulation means dropping the guest's EFER.SVME is ok (though gross =
:-) ).

> > > E.g. shouldn't KVM do this?
> >=20
> > It sure can and I am happy to include this into the series, the commit
> > log is what I am struggling with :)
> >=20
> > >=20
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index ca32389f3c36..4e4a49031efe 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -3784,6 +3784,16 @@ static void svm_enable_nmi_window(struct
> > > kvm_vcpu *vcpu)
> > > =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD if (svm_get_nmi_mask(vcpu) && !svm->awaiting_iret_completion)
> > > =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
 return; /* IRET will cause a vm exit */
> > > +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD /*
> > > +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD * KV=
M can't single-step SEV-ES guests and instead assumes
> > > that IRET
> > > +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD * in=
 the guest will always succeed,
> >=20
> > It relies on GHCB's NMI_COMPLETE (which SVM than handles is it was IRET=
):
> >=20
> >  =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD case S=
VM_VMGEXIT_NMI_COMPLETE:
> >  =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD ret =3D =
svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
> >  =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD break;

Ah, right, better to say that the guest is responsible for signaling that i=
t's
ready to accept NMIs, which KVM handles by "emulating" IRET.

> > > i.e. clears NMI masking on the
> > > +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD * ne=
xt VM-Exit.=EF=BF=BD Note, GIF is guaranteed to be '1' for
> > > SEV-ES guests
> > > +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD * as=
 the GHCB doesn't allow for CLGI or STGI (and KVM suppresses
> > > +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD * EF=
ER.SVME for good measure, see efer_trap()).
> >=20
> > SVM KVM seems to not enforce EFER.SVME, the guest does what it wants an=
d
> > KVM is only told the new value via EFER_WRITE_TRAP. And "writes by
> > SEV-ES guests to EFER.SVME are always ignored by hardware" says the APM=
.

Ahhh, that blurb in the APM is what I'm missing.

Actually, there's a real bug here.  KVM doesn't immediately unmask NMIs in =
response
to NMI_COMPLETE, and instead goes through the whole awaiting_iret_completio=
n =3D>
svm_complete_interrupts(), which means that KVM doesn't unmask NMIs until t=
he
*next* VM-Exit.  Theoretically, that could be never, e.g. if the host is ti=
ckless
and the guest is configured to busy wait idle CPUs.

Attached patches are compile tested only.

--Tsz77BKxl4wQNE2/
Content-Type: text/x-diff; charset=3Dus-ascii
Content-Disposition: attachment;
	filename=3D"0001-KVM-SVM-Don-t-defer-NMI-unblocking-until-next-exit-f.patc=
h"

From eb126f1c02b418df0b5dce9e3cdbd984fc4b0611 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 13 Jun 2023 16:08:18 -0700
Subject: [PATCH 1/2] KVM: SVM: Don't defer NMI unblocking until next exit f=
or
 SEV-ES guests

Immediately mark NMIs as unmasked in response to #VMGEXIT(NMI complete)
instead of setting awaiting_iret_completion and waiting until the *next*
VM-Exit to unmask NMIs.  The whole point of "NMI complete" is that the
guest is responsible for telling the hypervisor when it's safe to inject
an NMI, i.e. there's no need to wait.  And because there's no IRET to
single-step, the next VM-Exit could be a long time coming, i.e. KVM could
incorrectly hold an NMI pending for far longer than what is required and
expected.

Opportunistically fix a stale reference to HF_IRET_MASK.

Fixes: 4444dfe4050b ("KVM: SVM: Add NMI support for an SEV-ES guest")
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c |  5 ++++-
 arch/x86/kvm/svm/svm.c | 10 +++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index d65578d8784d..9a0e74cb6cb9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2887,7 +2887,10 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 					    svm->sev_es.ghcb_sa);
 		break;
 	case SVM_VMGEXIT_NMI_COMPLETE:
-		ret =3D svm_invoke_exit_handler(vcpu, SVM_EXIT_IRET);
+		++vcpu->stat.nmi_window_exits;
+		svm->nmi_masked =3D false;
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+		ret =3D 1;
 		break;
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 		ret =3D kvm_emulate_ap_reset_hold(vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b29d0650582e..b284706edde2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2508,12 +2508,13 @@ static int iret_interception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm =3D to_svm(vcpu);
=20
+	WARN_ON_ONCE(sev_es_guest(vcpu->kvm));
+
 	++vcpu->stat.nmi_window_exits;
 	svm->awaiting_iret_completion =3D true;
=20
 	svm_clr_iret_intercept(svm);
-	if (!sev_es_guest(vcpu->kvm))
-		svm->nmi_iret_rip =3D kvm_rip_read(vcpu);
+	svm->nmi_iret_rip =3D kvm_rip_read(vcpu);
=20
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	return 1;
@@ -3916,12 +3917,11 @@ static void svm_complete_interrupts(struct kvm_vcpu=
 *vcpu)
 	svm->soft_int_injected =3D false;
=20
 	/*
-	 * If we've made progress since setting HF_IRET_MASK, we've
+	 * If we've made progress since setting awaiting_iret_completion, we've
 	 * executed an IRET and can allow NMI injection.
 	 */
 	if (svm->awaiting_iret_completion &&
-	    (sev_es_guest(vcpu->kvm) ||
-	     kvm_rip_read(vcpu) !=3D svm->nmi_iret_rip)) {
+	    kvm_rip_read(vcpu) !=3D svm->nmi_iret_rip) {
 		svm->awaiting_iret_completion =3D false;
 		svm->nmi_masked =3D false;
 		kvm_make_request(KVM_REQ_EVENT, vcpu);

base-commit: 5e74470e279654d9fa8742184c8c89837b899078
--=20
2.41.0.162.gfafddb0af9-goog


--Tsz77BKxl4wQNE2/
Content-Type: text/x-diff; charset=3Dus-ascii
Content-Disposition: attachment;
	filename=3D"0002-KVM-SVM-Don-t-try-to-pointlessly-single-step-SEV-ES-.patc=
h"

From fe7634942b49a243ec42ca1aaa8b9354c126b2a3 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 13 Jun 2023 15:50:44 -0700
Subject: [PATCH 2/2] KVM: SVM: Don't try to pointlessly single-step SEV-ES
 guests for NMI window

Bail early from svm_enable_nmi_window() for SEV-ES guests without trying
to enable single-step of the guest, as single-stepping an SEV-ES guest is
impossible and the guest is responsible for *telling* KVM when it is ready
for an new NMI to be injected.

Functionally, setting TF and RF in svm->vmcb->save.rflags is benign as the
field is ignored by hardware, but it's all kinds of confusing.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b284706edde2..06d50c9c1e48 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3768,6 +3768,20 @@ static void svm_enable_nmi_window(struct kvm_vcpu *v=
cpu)
 	if (svm_get_nmi_mask(vcpu) && !svm->awaiting_iret_completion)
 		return; /* IRET will cause a vm exit */
=20
+	/*
+	 * SEV-ES guests are responsible for signaling when a vCPU is ready to
+	 * receive a new NMI, as SEV-ES guests can't be single-stepped, i.e.
+	 * KVM can't intercept and single-step IRET to detect when NMIs are
+	 * unblocked (architecturally speaking).  See SVM_VMGEXIT_NMI_COMPLETE.
+	 *
+	 * Note, GIF is guaranteed to be '1' for SEV-ES guests as hardware
+	 * ignores SEV-ES guest writes to EFER.SVME, KVM suppresses EFER.SVME
+	 * (see efer_trap()), *and* CLGI/STGI are not supported NAEs in the
+	 * GHCB protocol.
+	 */
+	if (sev_es_guest(vcpu->kvm))
+		return;
+
 	if (!gif_set(svm)) {
 		if (vgif)
 			svm_set_intercept(svm, INTERCEPT_STGI);
--=20
2.41.0.162.gfafddb0af9-goog


--Tsz77BKxl4wQNE2/--
