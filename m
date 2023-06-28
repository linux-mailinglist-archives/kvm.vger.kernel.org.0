Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64EFF74175E
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 19:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbjF1RkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 13:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbjF1RkU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 13:40:20 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B8B2102
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 10:40:19 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-56938733c13so664907b3.1
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 10:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687974018; x=1690566018;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Im4fFxXWg+oVOfUH+8SJrHwG1JicT9m6/P5cgR+BWzw=;
        b=SZpxzhcnhadOc346dhqn6V9xWrDfp0/Y29IDCtUvlFlOaJ3ac8zC5HOctOfMdc1Lxd
         smbqhhT0foT4AluoS1BMfq9FmR61Q0Sk8pBV0ms2Dy4Y5dyu5cKv0Rl0P64NW5nXa0sI
         7ftH1wYY4i0icYuPqNo8v36++h1Entv+Q76B6+tvWERKGy6O2ZuCn/y7KYzdcIDyl3Yu
         0i6gJ3d6F0uoF6jzA/ib/reDqAv0lbX8ZmqxTfy9VDIugQ3ysYJqGFhFKwxXmiNnBvR9
         /F8CddkcUEz9Le7WLSecsEDoZiKXhDoMwAywFZI66f/oXxuJAvQuXrpjouv7jvoMnlag
         dDDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687974018; x=1690566018;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Im4fFxXWg+oVOfUH+8SJrHwG1JicT9m6/P5cgR+BWzw=;
        b=DUo26up8rg+nj8sjOsjx3otAsMCzbtgJsMGu+UTpk1ZL8fMSYoXb1OkhMIigEq90E1
         UWRfdTW/sGGtL6LezObwS7GpHNsN3vyoD1KuEnFTA2HMLDeiFOCEqx/WLab/L69T1T3a
         pWYhtSyZ0nEp71dnRIKM5WQW9iW4Co+qBgM52rmnpogHxn5s10+EQTHf3lMTkHzCXAaB
         0Jgk12tcaLFT90QnENm0rwu9MGFRwTQtv/TJTPoAA2SRI5r/97nM99X9SGPPiyqi77dx
         Om+Ks7jrCK0vKD8N+GHTFT7hoDUl4C4Hjml1n2GvW6tlXzauza60pUR/+wbiHa8QbifH
         OXzg==
X-Gm-Message-State: AC+VfDz3Se43z9wO/ZHiqTiqP3OG+vMad/IWzcBwAhf5kr8CtqiT9E2k
        Vo8+evbaEIIX5UYB2pjemxpSeeeELMA=
X-Google-Smtp-Source: ACHHUZ4EWb7yMD0jDqHEhtw00eSYbqGcY9/m+arPcFTTx3+aL/4IJzSmJ1nizOBPBDoFlz4x7a9Aj2WCCIc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ae07:0:b0:570:200:18e1 with SMTP id
 m7-20020a81ae07000000b00570020018e1mr14078200ywh.3.1687974018560; Wed, 28 Jun
 2023 10:40:18 -0700 (PDT)
Date:   Wed, 28 Jun 2023 10:40:16 -0700
In-Reply-To: <e11e348c-3763-8eda-281d-c8d965cd52b6@linux.intel.com>
Mime-Version: 1.0
References: <20230606091842.13123-1-binbin.wu@linux.intel.com>
 <20230606091842.13123-4-binbin.wu@linux.intel.com> <ZJtzdftocuwTvp67@google.com>
 <e11e348c-3763-8eda-281d-c8d965cd52b6@linux.intel.com>
Message-ID: <ZJxwgCx3YatyH9or@google.com>
Subject: Re: [PATCH v9 3/6] KVM: x86: Virtualize CR3.LAM_{U48,U57}
From:   Sean Christopherson <seanjc@google.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@aculab.com, robert.hu@linux.intel.com
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

On Wed, Jun 28, 2023, Binbin Wu wrote:
>=20
>=20
> On 6/28/2023 7:40 AM, Sean Christopherson wrote:
> > I think I'd prefer to drop this field and avoid bikeshedding the name e=
ntirely.  The
> > only reason to effectively cache "X86_CR3_LAM_U48 | X86_CR3_LAM_U57" is=
 because
> > guest_cpuid_has() is slow, and I'd rather solve that problem with the "=
governed
> > feature" framework.
> Thanks for the suggestion.
>=20
> Is the below patch the lastest patch of "governed feature" framework
> support?
> https://lore.kernel.org/kvm/20230217231022.816138-2-seanjc@google.com/

Yes, I haven't refreshed it since the original posting.

> Do you have plan to apply it to kvm-x86 repo?

I'm leaning more and more towards pushing it through sooner than later as t=
his
isn't the first time in recent memory that a patch/series has done somewhat=
 odd
things to workaround guest_cpuid_has() being slow.  I was hoping to get fee=
dback
before applying, but that's not looking likely at this point.

> > More below.
> >=20
> > >   	unsigned long cr4;
> > >   	unsigned long cr4_guest_owned_bits;
> > >   	unsigned long cr4_guest_rsvd_bits;
> > > diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> > > index b1658c0de847..ef8e1b912d7d 100644
> > > --- a/arch/x86/kvm/cpuid.h
> > > +++ b/arch/x86/kvm/cpuid.h
> > > @@ -42,6 +42,11 @@ static inline int cpuid_maxphyaddr(struct kvm_vcpu=
 *vcpu)
> > >   	return vcpu->arch.maxphyaddr;
> > >   }
> > > +static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsi=
gned long cr3)
> > Heh, I think it makes sense to wrap this one.  I'll probably tell you d=
ifferently
> > tomorrow, but today, let's wrap.
> >=20
> > > +{
> > > +	return !((cr3 & vcpu->arch.reserved_gpa_bits) & ~vcpu->arch.cr3_ctr=
l_bits);
> > Don't open code something for which there is a perfect helper, i.e. use
> > kvm_vcpu_is_legal_gpa().
> I didn't use the helper because after masking the control bits (LAM bits)=
,
> CR3 is not=C2=A0 a GPA conceptally, i.e, it contains PCID or PWT/PCD in l=
ower
> bits.
> But maybe this is my overthinking=EF=BC=9FWill use the helper instead.

You're not overthinking it, I had the exact same reaction.  However, the ab=
ove
also directly looks at arch.reserved_gpa_bits, i.e. treats CR3 like a GPA f=
or
all intents and purposes, so it's not any better than using kvm_vcpu_is_leg=
al_gpa().
And I couldn't bring myself to suggest adding a "reserved CR3 bits" mask be=
cause
CR3 *does* contain a GPA, i.e. we'd still have to check kvm_vcpu_is_legal_g=
pa(),
and realistically the "reserved CR3 bits" will never be a superset of "ille=
gal
GPA bits".

> > If we go the governed feature route, this becomes:
> >=20
> > static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu,
> > 					 unsigned long cr3)
> > {
> > 	if (guest_can_use(vcpu, X86_FEATURE_LAM))
> > 		cr3 &=3D ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
> >=20
> > 	return kvm_vcpu_is_legal_gpa(cr3);
> > }
> >=20
> > > +}
> > > +
> > >   static inline bool kvm_vcpu_is_legal_gpa(struct kvm_vcpu *vcpu, gpa=
_t gpa)
> > >   {
> > >   	return !(gpa & vcpu->arch.reserved_gpa_bits);
> > > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > > index 92d5a1924fc1..81d8a433dae1 100644
> > > --- a/arch/x86/kvm/mmu.h
> > > +++ b/arch/x86/kvm/mmu.h
> > > @@ -144,6 +144,11 @@ static inline unsigned long kvm_get_active_pcid(=
struct kvm_vcpu *vcpu)
> > >   	return kvm_get_pcid(vcpu, kvm_read_cr3(vcpu));
> > >   }
> > > +static inline u64 kvm_get_active_cr3_ctrl_bits(struct kvm_vcpu *vcpu=
)
> > And then this becomes:
> >=20
> > static inline u64 kvm_get_active_cr3_lam_bits(struct kvm_vcpu *vcpu)
> > {
> > 	if (!guest_can_use(vcpu, X86_FEATURE_LAM))
> > 		return 0;
> >=20
> > 	return kvm_read_cr3(vcpu) & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
> > }
> >=20
> > > +{
> > > +	return kvm_read_cr3(vcpu) & vcpu->arch.cr3_ctrl_bits;
> > > +}
> > > +
> > >   static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
> > >   {
> > >   	u64 root_hpa =3D vcpu->arch.mmu->root.hpa;
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index c8961f45e3b1..deea9a9f0c75 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -3812,7 +3812,13 @@ static int mmu_alloc_shadow_roots(struct kvm_v=
cpu *vcpu)
> > >   	hpa_t root;
> > >   	root_pgd =3D kvm_mmu_get_guest_pgd(vcpu, mmu);
> > > -	root_gfn =3D root_pgd >> PAGE_SHIFT;
> > > +	/*
> > > +	 * Guest PGD can be CR3 or EPTP (for nested EPT case). CR3 may cont=
ain
> > > +	 * additional control bits (e.g. LAM control bits). To be generic,
> > > +	 * unconditionally strip non-address bits when computing the GFN si=
nce
> > > +	 * the guest PGD has already been checked for validity.
> > > +	 */
> > Drop this comment, the code is self-explanatory, and the comment is inc=
omplete,
> > e.g. it can also be nCR3.
> I was trying to use CR3 for both nested/non-nested cases. Sorry for the
> confusion.
> Anyway, will drop the comment.

FWIW, EPTP also has non-address bits.  But the real reason I don't think th=
is
warrants a comment is that "pgd" is a specifically not an address, i.e. it'=
s
fully expected and intuitive that retrieving the gfn from a pgd would need =
to
mask off bits.
