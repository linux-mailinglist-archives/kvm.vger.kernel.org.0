Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361D76EFBE5
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 22:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239912AbjDZUtg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 16:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239879AbjDZUt3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 16:49:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBE51FF6
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 13:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682542121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yw/qg9ZMelIu975aR1yZ+pEtPkzHJPTmHJWSzPl/G9s=;
        b=A1YRaX+PI6LMH9869GHTwcFAB7uDgzKWtmTwFg1wU519mE1CCw7SpHtFYdrAiC1MmYlhwW
        StpUgcbU69rTYQ90GhrbCSOJ+9qC4obZjt10JGt4ggfeQmuust1HggvF5fThy+pNsOhPkH
        Ak/C5IEAiH5vsIhCtZx+kBuFwgsPysc=
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com
 [209.85.222.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-491-xnSnKq2pOmqHGoAaV81X6w-1; Wed, 26 Apr 2023 16:48:40 -0400
X-MC-Unique: xnSnKq2pOmqHGoAaV81X6w-1
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-77262610a3eso2534774241.2
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 13:48:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682542119; x=1685134119;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yw/qg9ZMelIu975aR1yZ+pEtPkzHJPTmHJWSzPl/G9s=;
        b=gRdwYHQjFBAIRbMeQoBCO0thqdvvmaUHhn2qH9SgCef/C7bMQ/pAsfGPxPlmx7dhjn
         aBYJB/M3PCQCv6u8Ucn492k31Q1VF1qeqd1mBc1GlA2gmDt0/NBGAyZ6lDZTcZPKzt2z
         zspQkncYJW5pCOLYRZ9MAu9pmK6mrz702ktQLsOV0hNq8/YL/0loVdteWXyVRe9Y8n43
         uVNBSXW1Cqb9FKWAFvSLhRUkoWEZ/T4DGfgvSaEuB5rmOm8q3ZaWnaouDRy7jsN2uevk
         oRGMsh7Kk/ZfczFTiSkNGL5GOuqhZNWdN8eC8OWgONrZK4DZpIxb4AMyNBWvnJ2fkgQ8
         MU6g==
X-Gm-Message-State: AAQBX9fF1gzIq3leY+b4i2LO4TB8hHXPcbV7l9VrkzEfEMn3aT0nB6MA
        abk7+5Pelmy17Y8u+RHq1NXoE1c8QUD4rYhuEe0uQcWP3D8lyoNpNtJ3O512Jd/j9wtgjqv/EOG
        Itq/Jf69KtYsJSId760ykB7rFvsBDMvuVISOTnPUrHQ==
X-Received: by 2002:a05:6102:481:b0:42c:6cf7:34aa with SMTP id n1-20020a056102048100b0042c6cf734aamr9345495vsa.33.1682542119403;
        Wed, 26 Apr 2023 13:48:39 -0700 (PDT)
X-Google-Smtp-Source: AKy350bNHWIrbJz1bju0ExyiGnneWjmnGM1LugnZbVuNfAUQRy9M4ukmpC3P2jHkKslYUkgLagC0XvmR1bv7ftQK6P0=
X-Received: by 2002:a05:6102:481:b0:42c:6cf7:34aa with SMTP id
 n1-20020a056102048100b0042c6cf734aamr9345492vsa.33.1682542119085; Wed, 26 Apr
 2023 13:48:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230424173529.2648601-1-seanjc@google.com> <20230424173529.2648601-6-seanjc@google.com>
 <CABgObfaXqx1nM5tc5jSBfHCv_Ju4=CPtn6atyuGJdeawE2EcFg@mail.gmail.com> <ZEmDVOifOywZGllP@google.com>
In-Reply-To: <ZEmDVOifOywZGllP@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Wed, 26 Apr 2023 22:48:27 +0200
Message-ID: <CABgObfYkaxMYoGazW+rC=zUF2g6j1AfRkOTDyCBSE2GTm9GNhQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: SVM changes for 6.4
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 26, 2023 at 10:02=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> > This is probably the sub-PR for which I'm more interested in giving
> > the code a closer look, but this is more about understanding the
> > changes than it is about expecting something bad in it.
>
> 100% agree.  If you were to scrutinize only one thing for 6.4, the vNMI c=
hanges
> are definitely my choice for extra eyeballs.

Interesting read. The split commits left me wondering _why_ patches
1-7 were needed for vNMI, but that's a known limitation of losing the
cover letter, and the Link or Message-Id trailers try to amend for
that.

I have a few comments indeed, most of which are absolutely nits and
can be ignored or fixed as follow-ups. It's my turn to send a "belated
review" patch series, which I'll do for -rc2, but please check if
there are any disagreements.

First of all, this comment caught my attention:

+    /*
+     * Rules for synchronizing int_ctl bits from vmcb02 to vmcb01:
+     *
+     * V_IRQ, V_IRQ_VECTOR, V_INTR_PRIO_MASK, V_IGN_TPR:  If L1 doesn't
+     * intercept interrupts, then KVM will use vmcb02's V_IRQ (and related
+     * flags) to detect interrupt windows for L1 IRQs (even if L1 uses
+     * virtual interrupt masking).  Raise KVM_REQ_EVENT to ensure that
+     * KVM re-requests an interrupt window if necessary, which implicitly
+     * copies this bits from vmcb02 to vmcb01.
+     *
+     * V_TPR: If L1 doesn't use virtual interrupt masking, then L1's vTPR
+     * is stored in vmcb02, but its value doesn't need to be copied from/t=
o
+     * vmcb01 because it is copied from/to the virtual APIC's TPR register
+     * on each VM entry/exit.
+     *
+     * V_GIF: If nested vGIF is not used, KVM uses vmcb02's V_GIF for L1's
+     * V_GIF.  However, GIF is architecturally clear on each VM exit, thus
+     * there is no need to copy V_GIF from vmcb02 to vmcb01.
+     */

"Rules for synchronizing int_ctl bits from vmcb02 to vmcb01" suggests
that this is work done here, and it also misled me into looking at
nested_sync_control_from_vmcb02 (which is instead about vmcb02 ->
vmcb12).

So what about replacing it with

    * int_ctl bits from vmcb02 have to be synchronized to both vmcb12
and vmcb01.
    * The former is in nested_sync_control_from_vmcb02, invoked on every vm=
exit,
    * while the latter is scattered all over the place:

and perhaps also call out nested_svm_virtualize_tpr(), sync_lapic_to_cr8() =
and
sync_cr8_to_lapic in the V_TPR part?

Another super small thing which is not worth a respin (would have been):

 Subject: [PATCH 05/13] KVM: x86: Raise an event request when processing NM=
Is
- if an NMI is pending
+ iff an NMI is pending

The "if" suggests that we were missing an event request, while "iff"
suggests that we were doing them unnecessarily.

As an aside, I like the "coding style violation" of commit
400fee8c9b2d. Because the "limit =3D 2" case is anti-architectural, it
makes more sense to have it as an "else" rather than as the default.
An alternative could have been:

  unsigned limit =3D 1;
  if (!static_call(kvm_x86_get_nmi_mask)(vcpu) && !vcpu->arch.nmi_injected)
      limit =3D 2;

but the ugly condition makes this solution worse.

Next on, commit ab2ee212a57b ("KVM: x86: Save/restore all NMIs when
multiple NMIs are pending"). Here, "allows userspace to restore 255
pending NMIs" in the commit message is kinda scary, and I thought
about following up with a fixlet to KVM_SET_VCPU_EVENTS:

+        events->nmi.pending =3D min(vcpu->arch.nmi_pending, 2);
         vcpu->arch.nmi_pending =3D 0;
         atomic_set(&vcpu->arch.nmi_queued, events->nmi.pending);
         kvm_make_request(KVM_REQ_NMI, vcpu);

but really this isn't needed because process_nmi() does have

     vcpu->arch.nmi_pending =3D min(vcpu->arch.nmi_pending, limit);

So in the end this is also fine, just a remark on the commit message.
May be worth an additional comment instead here in
KVM_SET_VCPU_EVENTS, before the atomic_set().

On to the actual vNMI patch:

+    /*
+     * KVM should never request an NMI window when vNMI is enabled, as KVM
+     * allows at most one to-be-injected NMI and one pending NMI, i.e. if
+     * two NMIs arrive simultaneously, KVM will inject one and set
+     * V_NMI_PENDING for the other.  WARN, but continue with the standard
+     * single-step approach to try and salvage the pending NMI.
+     */
+    WARN_ON_ONCE(is_vnmi_enabled(svm));

Understandable, but also scary. :) I am not sure losing a pending NMI
is a big deal. IIRC the "limit =3D 2" case only matters because Windows
uses an NMI shootdown when rebooting the system and in some cases it
would hang; but in this case we're in a buggy situation. And it means
having to think about how the IRET+single-step method interacts with
vNMI, and what is the meaning of !svm->awaiting_iret_completion
(tested right below) in this buggy case. I'd just "return" here.

And another small nit to conclude - kvm_get_nr_pending_nmis() could be stat=
ic.

The only thing that leaves me a bit puzzled is the naming and
rationale of get_vnmi_vmcb_l1(). I'll let you or Santosh clarify that.

Thanks,

Paolo

