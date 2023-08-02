Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2ED76D0F7
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 17:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234796AbjHBPF4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 11:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234471AbjHBPFl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 11:05:41 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D273AAC
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 08:04:45 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d2082104a44so6316265276.2
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 08:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690988683; x=1691593483;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UUMABgRf8+JLrJEPYxIPAcBfEzRgqars/lrXYCb1BUE=;
        b=rSbGrQHo3VRf0sw+Ax8g0TxoxBZdQnoZh2HFkFM71zPpXZx/A3RCmEzkepLrMt7T3k
         xPLUVeQYTz7USaEGMHSpxHS+MfkHoKSv4GhxoPCGB6E+IoC64HSHnvrcIHe1J2Uo6KHs
         p5OvsWht9tX3QU5dCiNxQC1FNRnP8KthSqNyvyPAuBNG8rSshP07rWmGsTj33H1UpuZF
         UyUCZbphP1jFYX6CJ3iF3GjZJJ2hECe2bfvdUOndflz7Jcp4QY29J09VRVPPTmgYOV28
         ZCghnJ0ohRCf16vO0Jf9WIFO0ag+NO1xE594ltOegaPWmFCRa9ZRcmIKgSIWs/Wx8QTY
         NXSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690988683; x=1691593483;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UUMABgRf8+JLrJEPYxIPAcBfEzRgqars/lrXYCb1BUE=;
        b=A9inb5xzFFHy/BIwgnfkHhVPEsphQK3JMPmsLhJt+6cAoghrRFHruYH12z6AC0U8Ad
         iARGQF7CEZJnLND2PyKfLmGUX7sEK8xD+ZHm0erBfJ1b7r1lP2rHAMIsvDO2MrU+qF3y
         0dDmFFl3YJrppK1j7SIXYL7dsUbywPmyq3LMMfYnrE4jM+aSURARn/AIqC35Qm0R6A5H
         6QZpv3iYADnDKEvUlYZlhsJmyuPyltbSVip6IDCmLcnJ1AxspwYsY7bKY/IYvNJ6o94b
         Pb5EHohh6zLY7oWwXkQU484XmWe1GfNGTASD6OJA7Ji9usMOOYOqHmPCyRYtB00yJv2o
         413g==
X-Gm-Message-State: ABy/qLaOSJ/0bZJX2z2EgAafO0KjmXiAwW25td8ynPO+TVdv88TLYPYf
        qTyZPPOCZq/1WM4vHWTNBy09bS7wtlM=
X-Google-Smtp-Source: APBJJlEDEY0vSR2vn4i6PKsne/SSwUoYgKvwd++64qeUXGXac8cOKaNc1PGFy/Ghcc7t9rpN566hdBQ5LiM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:69c6:0:b0:d0f:cf5:3282 with SMTP id
 e189-20020a2569c6000000b00d0f0cf53282mr123293ybc.1.1690988683739; Wed, 02 Aug
 2023 08:04:43 -0700 (PDT)
Date:   Wed, 2 Aug 2023 08:04:41 -0700
In-Reply-To: <7a4f3f59-1482-49c4-92b2-aa621e9b06b3@amd.com>
Mime-Version: 1.0
References: <8eb933fd-2cf3-d7a9-32fe-2a1d82eac42a@mail.ustc.edu.cn>
 <ZMfFaF2M6Vrh/QdW@google.com> <4ebb3e20-a043-8ad3-ef6c-f64c2443412c@amd.com>
 <544b7f95-4b34-654d-a57b-3791a6f4fd5f@mail.ustc.edu.cn> <ZMpEUVsv5hSmrcH8@iZuf6hx7901barev1c282cZ>
 <ZMphvF+0H9wHQr5B@google.com> <bbc52f40-2661-3fa2-8e09-bec772728812@amd.com> <7a4f3f59-1482-49c4-92b2-aa621e9b06b3@amd.com>
Message-ID: <ZMpwiSw9CBZh9xcc@google.com>
Subject: Re: [Question] int3 instruction generates a #UD in SEV VM
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Wu Zongyo <wuzongyo@mail.ustc.edu.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        linux-coco@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 02, 2023, Tom Lendacky wrote:
> On 8/2/23 09:25, Tom Lendacky wrote:
> > On 8/2/23 09:01, Sean Christopherson wrote:
> > > > You're right. The #UD is injected by KVM.
> > > >=20
> > > > The path I found is:
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 svm_vcpu_run
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 svm_complete_inter=
rupts
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_requeue_exception //=
 vector =3D 3
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
kvm_make_request
> > > >=20
> > > > =C2=A0=C2=A0=C2=A0=C2=A0 vcpu_enter_guest
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_check_and_inje=
ct_events
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 svm_inject_exception
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
svm_update_soft_interrupt_rip
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
__svm_skip_emulated_instruction
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 x86_emulate_instruction
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 svm_can_emulate_instruction
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_queue_exception(vcpu, =
UD_VECTOR)
> > > >=20
> > > > Does this mean a #PF intercept occur when the guest try to deliver =
a
> > > > #BP through the IDT? But why?
> > >=20
> > > I doubt it's a #PF.=C2=A0 A #NPF is much more likely, though it could=
 be
> > > something
> > > else entirely, but I'm pretty sure that would require bugs in both
> > > the host and
> > > guest.
> > >=20
> > > What is the last exit recorded by trace_kvm_exit() before the #UD is
> > > injected?
> >=20
> > I'm guessing it was a #NPF, too. Could it be related to the changes tha=
t
> > went in around svm_update_soft_interrupt_rip()?
> >=20
> > 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the
> > instruction")
>=20
> Sorry, that should have been:
>=20
> 7e5b5ef8dca3 ("KVM: SVM: Re-inject INTn instead of retrying the insn on "=
failure"")
>=20
> >=20
> > Before this the !nrips check would prevent the call into
> > svm_skip_emulated_instruction(). But now, there is a call to:
> >=20
> >  =C2=A0 svm_update_soft_interrupt_rip()
> >  =C2=A0=C2=A0=C2=A0 __svm_skip_emulated_instruction()
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_emulate_instruction()
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 x86_emulate_instruction() (=
passed a NULL insn pointer)
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kvm_can_emulate=
_insn() (passed a NULL insn pointer)
> >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 svm=
_can_emulate_instruction() (passed NULL insn pointer)
> >=20
> > Because it is an SEV guest, it ends up in the "if (unlikely(!insn))" pa=
th
> > and injects the #UD.

Yeah, my money is on that too.  I believe this is the least awful solution:

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d381ad424554..2eace114a934 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -385,6 +385,9 @@ static int __svm_skip_emulated_instruction(struct kvm_v=
cpu *vcpu,
        }
=20
        if (!svm->next_rip) {
+               if (sev_guest(vcpu->kvm))
+                       return 0;
+
                if (unlikely(!commit_side_effects))
                        old_rflags =3D svm->vmcb->save.rflags;
=20
I'll send a formal patch (with a comment) if that solves the problem.


Side topic, KVM should require nrips for SEV and beyond, I don't see how SE=
V can
possibly work if KVM doesn't utilize nrips.  E.g. this

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2eace114a934..43e500503d48 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5111,9 +5111,11 @@ static __init int svm_hardware_setup(void)
=20
        svm_adjust_mmio_mask();
=20
+       nrips =3D nrips && boot_cpu_has(X86_FEATURE_NRIPS);
+
        /*
         * Note, SEV setup consumes npt_enabled and enable_mmio_caching (wh=
ich
-        * may be modified by svm_adjust_mmio_mask()).
+        * may be modified by svm_adjust_mmio_mask()), as well as nrips.
         */
        sev_hardware_setup();
=20
@@ -5125,11 +5127,6 @@ static __init int svm_hardware_setup(void)
                        goto err;
        }
=20
-       if (nrips) {
-               if (!boot_cpu_has(X86_FEATURE_NRIPS))
-                       nrips =3D false;
-       }
-
        enable_apicv =3D avic =3D avic && avic_hardware_setup();
=20
        if (!enable_apicv) {

