Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4306EFD92
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 00:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240059AbjDZWlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 18:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236276AbjDZWl3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 18:41:29 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 155724693
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 15:41:05 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-64115ef7234so438687b3a.1
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 15:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682548804; x=1685140804;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g9hAxxlh84w5h+MiuMuh8Aa/u7bEJbj3tAxVyqWPe94=;
        b=g4ag7AdBfVHPQoShKvBbmAmYBvtOeaDOmLrkEc/B6BzVeg42+m/5X9eqNOuwQUjkoJ
         TUtaMQDDUYFu1E7OricbqOIA/4nMP5Kd5sePJwL1vtE7WTfYqdhiXpq0eU1gvhzUhAk4
         8sObvJASf/5C4lUM1+gX07EXF1sipwhqqv8uxz5uUoW2G/7kowUPiQkwPLfQ95oZw9Y9
         KJC9F6UhtmJSykcsxdfNvJrQwh6zDlFJ/JTfOM8tJmPcFup3ksEw+77ufQ8bxeu6YhkF
         5CeCj6tTUFVsSob8pVIb4WNw7Ap+tPTEKA5OWspZbpq7PGmQCYzy/TsZQOpmlDmt/yI6
         x7zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682548804; x=1685140804;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=g9hAxxlh84w5h+MiuMuh8Aa/u7bEJbj3tAxVyqWPe94=;
        b=F1jO/4OW2qhyOg/dD7zZMKMWBtnfPiGUufvST3RHRIKIRy6rtHj3iYgtwKFXpaEstC
         ZZNHA6UqU15E64dIH/7rjcqflfkmxRctDlZ+c3FvFGleMsfFB4WElGQfK6PEB8OK6Ufv
         aG3bwX9SPybprxfynpr/axT2Tt6IDA+JMylwdBKpT4410x1vc3012aI+UyI72kvT4q8Z
         oY7Ovyb869hQCtfKoO2OEDnrliVwc+Rzj0CLmTw9GMRUDbJvEgMUQ5uoVJPWQVc6LqTj
         vtDWEOVbUJdIcLJ3gwlAboRAyLDG5Oup1uW/dL9deipmuHKKHRj+tygkREGcE0g8uNHF
         K+zA==
X-Gm-Message-State: AC+VfDzAV8VaPz3+RxfeDlpLD9C0Wv8+2iwabakNaz9zRUakzzKAZudc
        wUabxTZpADIJzaPVpqGdSmn4UidUcIg=
X-Google-Smtp-Source: ACHHUZ4fGalfGTA25ZnpaGiDwL5w1Wl/qoau2BcQv4Xg12CABgVsjG6ExsRPcpeOsTg1hSTk5fL0YVR6/nY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:aa7:888b:0:b0:63b:6bc2:910f with SMTP id
 z11-20020aa7888b000000b0063b6bc2910fmr1757295pfe.1.1682548804263; Wed, 26 Apr
 2023 15:40:04 -0700 (PDT)
Date:   Wed, 26 Apr 2023 22:40:02 +0000
In-Reply-To: <CABgObfYkaxMYoGazW+rC=zUF2g6j1AfRkOTDyCBSE2GTm9GNhQ@mail.gmail.com>
Mime-Version: 1.0
References: <20230424173529.2648601-1-seanjc@google.com> <20230424173529.2648601-6-seanjc@google.com>
 <CABgObfaXqx1nM5tc5jSBfHCv_Ju4=CPtn6atyuGJdeawE2EcFg@mail.gmail.com>
 <ZEmDVOifOywZGllP@google.com> <CABgObfYkaxMYoGazW+rC=zUF2g6j1AfRkOTDyCBSE2GTm9GNhQ@mail.gmail.com>
Message-ID: <ZEmoQslJ3gPqI8jG@google.com>
Subject: Re: [GIT PULL] KVM: x86: SVM changes for 6.4
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 26, 2023, Paolo Bonzini wrote:
> On Wed, Apr 26, 2023 at 10:02=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > > This is probably the sub-PR for which I'm more interested in giving
> > > the code a closer look, but this is more about understanding the
> > > changes than it is about expecting something bad in it.
> >
> > 100% agree.  If you were to scrutinize only one thing for 6.4, the vNMI=
 changes
> > are definitely my choice for extra eyeballs.
>=20
> Interesting read. The split commits left me wondering _why_ patches
> 1-7 were needed for vNMI, but that's a known limitation of losing the
> cover letter, and the Link or Message-Id trailers try to amend for
> that.
>=20
> I have a few comments indeed, most of which are absolutely nits and
> can be ignored or fixed as follow-ups. It's my turn to send a "belated
> review" patch series, which I'll do for -rc2, but please check if
> there are any disagreements.
>=20
> First of all, this comment caught my attention:
>=20
> +    /*
> +     * Rules for synchronizing int_ctl bits from vmcb02 to vmcb01:
> +     *
> +     * V_IRQ, V_IRQ_VECTOR, V_INTR_PRIO_MASK, V_IGN_TPR:  If L1 doesn't
> +     * intercept interrupts, then KVM will use vmcb02's V_IRQ (and relat=
ed
> +     * flags) to detect interrupt windows for L1 IRQs (even if L1 uses
> +     * virtual interrupt masking).  Raise KVM_REQ_EVENT to ensure that
> +     * KVM re-requests an interrupt window if necessary, which implicitl=
y
> +     * copies this bits from vmcb02 to vmcb01.
> +     *
> +     * V_TPR: If L1 doesn't use virtual interrupt masking, then L1's vTP=
R
> +     * is stored in vmcb02, but its value doesn't need to be copied from=
/to
> +     * vmcb01 because it is copied from/to the virtual APIC's TPR regist=
er
> +     * on each VM entry/exit.
> +     *
> +     * V_GIF: If nested vGIF is not used, KVM uses vmcb02's V_GIF for L1=
's
> +     * V_GIF.  However, GIF is architecturally clear on each VM exit, th=
us
> +     * there is no need to copy V_GIF from vmcb02 to vmcb01.
> +     */
>=20
> "Rules for synchronizing int_ctl bits from vmcb02 to vmcb01" suggests
> that this is work done here, and it also misled me into looking at
> nested_sync_control_from_vmcb02 (which is instead about vmcb02 ->
> vmcb12).

+1.  I had a similar reaction when I first saw the code, but learned to liv=
e with
it after a few versions :-)

> So what about replacing it with
>=20
>     * int_ctl bits from vmcb02 have to be synchronized to both vmcb12
> and vmcb01.
>     * The former is in nested_sync_control_from_vmcb02, invoked on every =
vmexit,
>     * while the latter is scattered all over the place:
>=20
> and perhaps also call out nested_svm_virtualize_tpr(), sync_lapic_to_cr8(=
) and
> sync_cr8_to_lapic in the V_TPR part?
>=20
> Another super small thing which is not worth a respin (would have been):
>=20
>  Subject: [PATCH 05/13] KVM: x86: Raise an event request when processing =
NMIs
> - if an NMI is pending
> + iff an NMI is pending
>=20
> The "if" suggests that we were missing an event request, while "iff"
> suggests that we were doing them unnecessarily.

Gah, suprised I didn't catch that, I do love me some "iff".

> As an aside, I like the "coding style violation" of commit
> 400fee8c9b2d. Because the "limit =3D 2" case is anti-architectural, it
> makes more sense to have it as an "else" rather than as the default.
> An alternative could have been:
>=20
>   unsigned limit =3D 1;
>   if (!static_call(kvm_x86_get_nmi_mask)(vcpu) && !vcpu->arch.nmi_injecte=
d)
>       limit =3D 2;
>=20
> but the ugly condition makes this solution worse.
>=20
> Next on, commit ab2ee212a57b ("KVM: x86: Save/restore all NMIs when
> multiple NMIs are pending"). Here, "allows userspace to restore 255
> pending NMIs" in the commit message is kinda scary, and I thought
> about following up with a fixlet to KVM_SET_VCPU_EVENTS:
>=20
> +        events->nmi.pending =3D min(vcpu->arch.nmi_pending, 2);
>          vcpu->arch.nmi_pending =3D 0;
>          atomic_set(&vcpu->arch.nmi_queued, events->nmi.pending);
>          kvm_make_request(KVM_REQ_NMI, vcpu);
>=20
> but really this isn't needed because process_nmi() does have
>=20
>      vcpu->arch.nmi_pending =3D min(vcpu->arch.nmi_pending, limit);
>=20
> So in the end this is also fine, just a remark on the commit message.

Even restoring 255 NMIs would be fine from KVM's perspective.  The guest mi=
ght
not be happy, but that's likely true if there are _any_ spurious NMIs.  IIR=
C, I
didn't call out the process_nmi() behavior because having 255 pending virtu=
al
NMIs doesn't put KVM at risk anymore than does having 2 pending virtual NMI=
s.

> May be worth an additional comment instead here in
> KVM_SET_VCPU_EVENTS, before the atomic_set().
>=20
> On to the actual vNMI patch:
>=20
> +    /*
> +     * KVM should never request an NMI window when vNMI is enabled, as K=
VM
> +     * allows at most one to-be-injected NMI and one pending NMI, i.e. i=
f
> +     * two NMIs arrive simultaneously, KVM will inject one and set
> +     * V_NMI_PENDING for the other.  WARN, but continue with the standar=
d
> +     * single-step approach to try and salvage the pending NMI.
> +     */
> +    WARN_ON_ONCE(is_vnmi_enabled(svm));
>=20
> Understandable, but also scary. :) I am not sure losing a pending NMI
> is a big deal. IIRC the "limit =3D 2" case only matters because Windows
> uses an NMI shootdown when rebooting the system and in some cases it
> would hang; but in this case we're in a buggy situation. And it means
> having to think about how the IRET+single-step method interacts with
> vNMI, and what is the meaning of !svm->awaiting_iret_completion
> (tested right below) in this buggy case. I'd just "return" here.

Heh, Santosh originally had it return and I had the opposite reaction: why =
bail
and *guarantee* problems for the guest, instead of continuing on and *maybe=
*
causing problems for the guest.

 : Last thought, unless there's something that will obviously break, it's p=
robably
 : better to WARN and continue than to bail.  I.e. do the single-step and h=
ope for
 : the best.  Bailing at this point doesn't seem like it would help.

I don't have a super strong preference.  As you said, KVM is already in a b=
uggy
scenario, though my vote is still to carry on.

https://lkml.kernel.org/r/Y9mwz%2FG6%2BG8NSX3%2B%40google.com

> And another small nit to conclude - kvm_get_nr_pending_nmis() could be st=
atic.
>=20
> The only thing that leaves me a bit puzzled is the naming and
> rationale of get_vnmi_vmcb_l1(). I'll let you or Santosh clarify that.

Ah, I think what happened is that I complained about is_vnmi_enabled() bein=
g
misleading (https://lore.kernel.org/all/Y9m0q31NBmsnhVGD@google.com), but i=
nstead
of renaming the top-level helper, Santosh added an inner helper and here we=
 are.

Re-reading what I wrote, and looking at the code with fresh eyes, I don't t=
hink
I agree with past me regarding the name of is_vnmi_enabled().  My biggest
objection/confusion with the original code was the comment saying vNMI was
"inhibited".  Appending "for_l1()" makes the usage in the callers quite con=
fusing.

So my vote is to do:

static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
{
	if (!vnmi)
		return false;

	if (is_guest_mode(&svm->vcpu))
		return false;

	return !!(svm->vmcb01.ptr->control.int_ctl & V_NMI_ENABLE_MASK);
}

---
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f44751dd8d5d..5b604565d4b3 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -556,25 +556,15 @@ static inline bool is_x2apic_msrpm_offset(u32 offset)
               (msr < (APIC_BASE_MSR + 0x100));
 }
=20
-static inline struct vmcb *get_vnmi_vmcb_l1(struct vcpu_svm *svm)
+static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
 {
        if (!vnmi)
-               return NULL;
+               return false;
=20
        if (is_guest_mode(&svm->vcpu))
-               return NULL;
-       else
-               return svm->vmcb01.ptr;
-}
-
-static inline bool is_vnmi_enabled(struct vcpu_svm *svm)
-{
-       struct vmcb *vmcb =3D get_vnmi_vmcb_l1(svm);
-
-       if (vmcb)
-               return !!(vmcb->control.int_ctl & V_NMI_ENABLE_MASK);
-       else
                return false;
+
+       return !!(svm->vmcb01.ptr->control.int_ctl & V_NMI_ENABLE_MASK);
 }
=20
 /* svm.c */
