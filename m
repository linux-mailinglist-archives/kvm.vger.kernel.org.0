Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11F0786454
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 02:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238927AbjHXAwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 20:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238921AbjHXAwI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 20:52:08 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B323DE78
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 17:52:06 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58c4d30c349so82546397b3.2
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 17:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692838326; x=1693443126;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cm4zrlQPJ60iEp18zbGG5mFea7W5Vtg6J5KaS9d3MTk=;
        b=0FfXQweW4a2H7pdnsuem3+pc31pQIYxbpD3p6e4QsevHscurraY5elU8lpE0etqCrS
         Dzr43zus7BozbXcvy7KOtIBGEN856TJnRBLs6pTr2eCMkdl0fyhVr3DpNsUR8/CFLu89
         IKVWVlPjuXY9Ti8yL1emCApEQL5WkSn8mQf62G3VQg0xkNdotXTSpnKEOAYOnlD/Ngkn
         JxbH+uetj9eaFG6O8XXEEaQuNcdc5GL52fRPpduvaZ3p/SdExJON3MIbjt+IgTFsBTdT
         D6B+njlZsPwC9UTUNEd/JqXssQXkX/7WxsMk5OHpyzuC88eeDlY3QU9/2gjyVVDeflCc
         u2FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692838326; x=1693443126;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Cm4zrlQPJ60iEp18zbGG5mFea7W5Vtg6J5KaS9d3MTk=;
        b=IoPU56IJJCTC4kw3gmKfztVY3yJRCU4a/m0v+3CpgvYBNyAW1fOn/ECjhGeF+0ZQBl
         YsxstTqPk/mKtTeyGZ3rnvAMzZ2k9B5myPd3bcAGs0I+FVMCTXZThin8n+na+bfx/en9
         DCNUg6h6EZqVb+rdhRe5+Ofqu3Wk/USs73eC4+RnlTyGU9d08DdtxOq/vcyx3Gv5j6/8
         vkR38CS4BGDtLg265Y6JH+6FYkH9yLRW2+is0I+h6lxdeFFX6Gj+EeTZxDFygCWkO0n7
         h/ZnYYNytor07eFHh0oME+9Lb27P5HdWTxlGzsBoqbeofsgSuVKpCG7v6l0jZRaQThJ+
         0Qcg==
X-Gm-Message-State: AOJu0Ywp9oDPv0T31z/gUuhLArLPxxFgnb3TPDKy1s9PrDq0g0rKMq0Z
        GFC0CzycQAnvdmjb1E6KafUD5gWkSPI=
X-Google-Smtp-Source: AGHT+IGRPsIN6eeC2ZZocCc6d4OVhBWSFGLEHSgvgftv3GcFh8uyTgKJqWqik8mPDsKaTBI7yWw9Rm7XgSQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:ec01:0:b0:586:b332:8618 with SMTP id
 q1-20020a0dec01000000b00586b3328618mr201758ywn.7.1692838325798; Wed, 23 Aug
 2023 17:52:05 -0700 (PDT)
Date:   Wed, 23 Aug 2023 17:52:04 -0700
In-Reply-To: <5da12792-1e5d-b89d-ea0-e1159c645568@ewheeler.net>
Mime-Version: 1.0
References: <5fc6cea-9f51-582c-8bb3-21e0b4bf397@ewheeler.net>
 <ZOP4lwiMU2Uf89eQ@google.com> <468b1298-e43e-2397-5f3-4b6af6e2f461@ewheeler.net>
 <ZOTQPUk5kxskDcsi@google.com> <58f24fa2-a5f4-c59a-2bcf-c49f7bddc5b@ewheeler.net>
 <ZOZH3xe0u4NHhvL8@google.com> <db7c65b-6530-692-5e50-c74a7757f22@ewheeler.net>
 <347d3526-7f8d-4744-2a9c-8240cc556975@ewheeler.net> <ZOaUdP46f8XjQvio@google.com>
 <5da12792-1e5d-b89d-ea0-e1159c645568@ewheeler.net>
Message-ID: <ZOaptK09RbJtFbmk@google.com>
Subject: Re: Deadlock due to EPT_VIOLATION
From:   Sean Christopherson <seanjc@google.com>
To:     Eric Wheeler <kvm@lists.ewheeler.net>
Cc:     Amaan Cheval <amaan.cheval@gmail.com>, brak@gameservers.com,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 23, 2023, Eric Wheeler wrote:
> On Wed, 23 Aug 2023, Sean Christopherson wrote:
> > Not a coincidence, at all.  The bug is that, in v6.1, is_page_fault_sta=
le() takes
> > the local @mmu_seq snapshot as an int, whereas as the per-VM count is s=
tored as an
> > unsigned long.
>=20
> I'm surprised that there were no compiler warnings about signedness or
> type precision.  What would have prevented such a compiler warning?

-Wconversion can detect this, but it detects freaking *everything*, i.e. it=
s
signal to noise ratio is straight up awful.  It's so noisy in fact that it'=
s not
even in the kernel's W=3D1 build, it's pushed down all the way to W=3D3.  W=
=3D1 is
basically "you'll get some noise, but it may find useful stuff.  W=3D3 is e=
ssentially
"don't bother wading through the warnings unless you're masochistic".

E.g. turning it on leads to:

linux/include/linux/kvm_host.h:891:60: error:
conversion to =E2=80=98long unsigned int=E2=80=99 from =E2=80=98int=E2=80=
=99 may change the sign of the result [-Werror=3Dsign-conversion]
  891 |                           (atomic_read(&kvm->online_vcpus) - 1))
      |                           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~

which is completely asinine (suppressing the warning would require declarin=
g the
above literal as 1u).

FWIW, I would love to be able to prevent these types of bugs as this isn't =
the
first implicit conversion bug that has hit KVM x86[*], but the signal to no=
ise
ratio is just so, so bad.

[*] commit d5aaad6f8342 ("KVM: x86/mmu: Fix per-cpu counter corruption on 3=
2-bit builds")

> > When the sequence sets bit 31, the local @mmu_seq value becomes
> > a signed *negative* value, and then when that gets passed to mmu_invali=
date_retry_hva(),
> > which correctly takes an unsigned long, the negative value gets sign-ex=
tended and
> > so the comparison ends up being
> >=20
> > 	if (0x8002dc25 !=3D 0xffffffff8002dc25)
> >
> > and KVM thinks the sequence count is stale.  I missed it for so long be=
cause I
> > was stupidly looking mostly at upstream code (see below), and because o=
f the subtle
> > sign-extension behavior (I was mostly on the lookout for a straight tru=
ncation
> > bug where bits[63:32] got dropped).
> >=20
> > I suspect others haven't hit this issues because no one else is generat=
ing anywhere
> > near the same number of mmu_notifier invalidations, and/or live migrate=
s VMs more
> > regularly (which effectively resets the sequence count).
> >=20
> > The real kicker to all this is that the bug was accidentally fixed in v=
6.3 by
> > commit ba6e3fe25543 ("KVM: x86/mmu: Grab mmu_invalidate_seq in kvm_faul=
tin_pfn()"),
> > as that refactoring correctly stored the "local" mmu_seq as an unsigned=
 long.
> >=20
> > I'll post the below as a proper patch for inclusion in stable kernels.
>=20
> Awesome, and well done.  Can you think of a "simple" patch for the
> 6.1-series that would be live-patch safe?

This is what I'm going to post for 6.1, it's as safe and simple a patch as =
can
be.  The only potential hiccup for live-patching is that it's all but guara=
nteed
to be inlined, but the scope creep should be limited to one-level up, e.g. =
to
direct_page_fault().

Author: Sean Christopherson <seanjc@google.com>
Date:   Wed Aug 23 16:28:12 2023 -0700

    KVM: x86/mmu: Fix an sign-extension bug with mmu_seq that hangs vCPUs
   =20
    Take the vCPU's mmu_seq snapshot as an "unsigned long" instead of an "i=
nt"
    when checking to see if a page fault is stale, as the sequence count is
    stored as an "unsigned long" everywhere else in KVM.  This fixes a bug
    where KVM will effectively hang vCPUs due to always thinking page fault=
s
    are stale, which result in KVM refusing to "fix" faults.
   =20
    mmu_invalidate_seq (n=C3=A9e mmu_notifier_seq) is sequence counter used=
 when
    KVM is handling page faults to detect if userspace mapping relevant to =
the
    guest was invalidated snapshotting the counter and acquiring mmu_lock, =
to
    ensure that the host pfn that KVM retrieved is still fresh.  If KVM see=
s
    that the counter has change, KVM resumes the guest without fixing the
    fault.
   =20
    What _should_ happen is that the source of the mmu_notifier invalidatio=
ns
    eventually goes away, mmu_invalidate_seq will become stable, and KVM ca=
n
    once again fix guest page fault(s).
   =20
    But for a long-lived VM and/or a VM that the host just doesn't particul=
arly
    like, it's possible for a VM to be on the receiving end of 2 billion (w=
ith
    a B) mmu_notifier invalidations.  When that happens, bit 31 will be set=
 in
    mmu_invalidate_seq.  This causes the value to be turned into a 32-bit
    negative value when implicitly cast to an "int" by is_page_fault_stale(=
),
    and then sign-extended into a 64-bit unsigned when the signed "int" is
    implicitly cast back to an "unsigned long" on the call to
    mmu_invalidate_retry_hva().
   =20
    As a result of the casting and sign-extension, given a sequence counter=
 of
    e.g. 0x8002dc25, mmu_invalidate_retry_hva() ends up doing
   =20
            if (0x8002dc25 !=3D 0xffffffff8002dc25)
   =20
    and signals that the page fault is stale and needs to be retried even
    though the sequence counter is stable, and KVM effectively hangs any vC=
PU
    that takes a page fault (EPT violation or #NPF when TDP is enabled).
   =20
    Note, upstream commit ba6e3fe25543 ("KVM: x86/mmu: Grab mmu_invalidate_=
seq
    in kvm_faultin_pfn()") unknowingly fixed the bug in v6.3 when refactori=
ng
    how KVM tracks the sequence counter snapshot.
   =20
    Reported-by: Brian Rak <brak@vultr.com>
    Reported-by: Amaan Cheval <amaan.cheval@gmail.com>
    Reported-by: Eric Wheeler <kvm@lists.ewheeler.net>
    Closes: https://lore.kernel.org/all/f023d927-52aa-7e08-2ee5-59a2fbc6595=
3@gameservers.com
    Fixes: a955cad84cda ("KVM: x86/mmu: Retry page fault if root is invalid=
ated by memslot update")
    Signed-off-by: Sean Christopherson <seanjc@google.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 230108a90cf3..beca03556379 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4212,7 +4212,8 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, str=
uct kvm_page_fault *fault)
  * root was invalidated by a memslot update or a relevant mmu_notifier fir=
ed.
  */
 static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
-                               struct kvm_page_fault *fault, int mmu_seq)
+                               struct kvm_page_fault *fault,
+                               unsigned long mmu_seq)
 {
        struct kvm_mmu_page *sp =3D to_shadow_page(vcpu->arch.mmu->root.hpa=
);
=20

