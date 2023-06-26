Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3CF73ECB6
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 23:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbjFZVPU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 17:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjFZVPT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 17:15:19 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43548E5B
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 14:15:17 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bb2a7308f21so5121722276.2
        for <kvm@vger.kernel.org>; Mon, 26 Jun 2023 14:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687814116; x=1690406116;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4cwqySIl0zrvyJR1a97p66vr+UthjL+qON8WoF64SHI=;
        b=4+4Iq23bk63JNu2KypmpQAiE0iUGVrJf3DB5XcBnilF67WEwId76dGVTpo5K+1wQBT
         G6czgGE7OEy9bjKJLE1UaIIcaFH+3RWdmP/nPYszA3dfjUK/zePRfQvdfSBY0ERbpq44
         cmpVMUBKiEeqER1B3XYKfRXUk4yFFcUg/mKUUl0aPZPUvzx0wTc3tWShFwf97mp1xc33
         c7UetKUnfQ3gV3WvKHdFxQf9wkKtGPlcZgOsF74STGxkle8Jtsoh1/40ZmKW7rMCVukl
         JwRfn/U4/mFYfdXLNz7rBq2/BewMAn56Go5PiFgOkVpkMGNQGc2xYHj8JhFaUtPqipoz
         h+Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687814116; x=1690406116;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4cwqySIl0zrvyJR1a97p66vr+UthjL+qON8WoF64SHI=;
        b=MvhHJDwQYrleRsu9wdY83C2l1VWlFhTBYwhyEt+/27cOzbzWdS4lkq01GhLitmxP37
         IeyuxCxYtgcy7ZOOVBlL1BQfc9LkUknBrJmjj3QL5WmdoagMODE7pR1U5+7w6a/1jlPZ
         TX9Ot5RUy3AM7Np3B7GyjgGFlYEP8oydT96tcPIX6mStJZMmKQ73u87305FMypmqj3kx
         g0Jbdt0aFjga/4mOPSaHo7b04BbhFAA5RLiDxBk7FZ3VYbQDJAboTQxcqLgqLBQofxOs
         iaqQt6RZemAnHKBiFiPfKSkcDzCQ48nlWAQObgDRIIaZhobNZ/RSLWb6CNN4UHCRTUIC
         cjRg==
X-Gm-Message-State: AC+VfDw2ODk+x0Eu3iRgeFeCIrNdw8CPsP+jE8kriZDhI42csKT6yUmD
        TxaWMQ6tXc15VSH6y0/hXpX2lfO5Kac=
X-Google-Smtp-Source: ACHHUZ7XOB1SIhYjOA6x33Zqyshy1ZiI4i5aWBJI1tfr58tOURcNdt8TR+SgEfwBNxaUPAHwVC7yJviIaNA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:6906:0:b0:bc3:abea:b3f1 with SMTP id
 e6-20020a256906000000b00bc3abeab3f1mr12552921ybc.8.1687814116482; Mon, 26 Jun
 2023 14:15:16 -0700 (PDT)
Date:   Mon, 26 Jun 2023 14:15:14 -0700
In-Reply-To: <9b12207f-7aec-7d46-9b7a-99355bc9d38d@intel.com>
Mime-Version: 1.0
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-14-weijiang.yang@intel.com> <ZJYwg3Lnq3nJZgQf@google.com>
 <9b12207f-7aec-7d46-9b7a-99355bc9d38d@intel.com>
Message-ID: <ZJn/4qC35eFjfqJv@google.com>
Subject: Re: [PATCH v3 13/21] KVM:VMX: Emulate reads and writes to CET MSRs
From:   Sean Christopherson <seanjc@google.com>
To:     Weijiang Yang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 26, 2023, Weijiang Yang wrote:
>=20
> On 6/24/2023 7:53 AM, Sean Christopherson wrote:
> > On Thu, May 11, 2023, Yang Weijiang wrote:
> > Side topic, what on earth does the SDM mean by this?!?
> >=20
> >    The linear address written must be aligned to 8 bytes and bits 2:0 m=
ust be 0
> >    (hardware requires bits 1:0 to be 0).
> >=20
> > I know Intel retroactively changed the alignment requirements, but the =
above
> > is nonsensical.  If ucode prevents writing bits 2:0, who cares what har=
dware
> > requires?
>=20
> So do I ;-/

Can you follow-up with someone to get clarification?  If writing bit 2 with=
 '1'
does not #GP despite the statement that it "must be aligned", then KVM shou=
ldn't
injected a #GP on that case.

> > > +			return 1;
> > > +		kvm_set_xsave_msr(msr_info);
> > > +		break;
> > >   	case MSR_IA32_PERF_CAPABILITIES:
> > >   		if (data && !vcpu_to_pmu(vcpu)->version)
> > >   			return 1;
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index b6eec9143129..2e3a39c9297c 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -13630,6 +13630,26 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vc=
pu, unsigned int size,
> > >   }
> > >   EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
> > > +bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu, struct msr_dat=
a *msr)
> > > +{
> > > +	if (!kvm_cet_user_supported())
> > This feels wrong.  KVM should differentiate between SHSTK and IBT in th=
e host.
> > E.g. if running in a VM with SHSTK but not IBT, or vice versa, KVM shou=
ld allow
> > writes to non-existent MSRs.
>=20
> I don't follow you, in this case, which part KVM is on behalf of? guest o=
r
> user space?

Sorry, typo.  KVM *shouldn't* allow writes to non-existent MSRs. =20

> > I.e. this looks wrong:
> >=20
> > 	/*
> > 	 * If SHSTK and IBT are available in KVM, clear CET user bit in
> > 	 * kvm_caps.supported_xss so that kvm_cet_user_supported() returns
> > 	 * false when called.
> > 	 */
> > 	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> > 	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
> > 		kvm_caps.supported_xss &=3D ~XFEATURE_MASK_CET_USER;
>=20
> The comment is wrong, it should be "are not available in KVM". My intent =
is,=EF=BF=BD
> if both features are not available in KVM, then clear the precondition bi=
t so
> that all dependent checks will fail quickly.

Checking kvm_caps.supported_xss.CET_USER is worthless in 99% of the cases t=
hough.
Unless I'm missing something, the only time it's useful is for CR4.CET, whi=
ch
doesn't differentiate between SHSTK and IBT.  For everything else that KVM =
cares
about, at some point KVM needs to precisely check for SHSTK and IBT support
anyways

> > and by extension, all dependent code is also wrong.  IIRC, there's a vi=
rtualization
> > hole, but I don't see any reason why KVM has to make the hole even bigg=
er.
>=20
> Do you mean the issue that both SHSTK and IBT share one control MSR? i.e.=
,
> U_CET/S_CET?

I mean that passing through PLx_SSP if the host has IBT but *not* SHSTK is =
wrong.

> > > +		return false;
> > > +
> > > +	if (msr->host_initiated)
> > > +		return true;
> > > +
> > > +	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
> > > +	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
> > > +		return false;
> > > +
> > > +	if (msr->index =3D=3D MSR_IA32_PL3_SSP &&
> > > +	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
> > I probably asked this long ago, but if I did I since forgot.  Is it rea=
lly just
> > PL3_SSP that depends on SHSTK?  I would expect all shadow stack MSRs to=
 depend
> > on SHSTK.
>=20
> All PL{0,1,2,3}_SSP plus INT_SSP_TAB msr depend on SHSTK. In patch 21, I
> added more MSRs in this helper.

Sure, except that patch 21 never adds handling for PL{0,1,2}_SSP.  I see:

	if (!kvm_cet_user_supported() &&
	    !(kvm_cpu_cap_has(X86_FEATURE_IBT) ||
	      kvm_cpu_cap_has(X86_FEATURE_SHSTK)))
		return false;

	if (msr->host_initiated)
		return true;

	if (!guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
	    !guest_cpuid_has(vcpu, X86_FEATURE_IBT))
		return false;

	/* The synthetic MSR is for userspace access only. */
	if (msr->index =3D=3D MSR_KVM_GUEST_SSP)
		return false;

	if (msr->index =3D=3D MSR_IA32_U_CET)
		return true;

	if (msr->index =3D=3D MSR_IA32_S_CET)
		return guest_cpuid_has(vcpu, X86_FEATURE_IBT) ||
		       kvm_cet_kernel_shstk_supported();

	if (msr->index =3D=3D MSR_IA32_INT_SSP_TAB)
		return guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) &&
		       kvm_cet_kernel_shstk_supported();

	if (msr->index =3D=3D MSR_IA32_PL3_SSP &&
	    !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK))
		return false;

	mask =3D (msr->index =3D=3D MSR_IA32_PL3_SSP) ? XFEATURE_MASK_CET_USER :
						  XFEATURE_MASK_CET_KERNEL;
	return !!(kvm_caps.supported_xss & mask);

Which means that KVM will allow guest accesses to PL{0,1,2}_SSP regardless =
of
whether or not X86_FEATURE_SHSTK is enumerated to the guest.

And the above is also wrong for host_initiated writes to SHSTK MSRs.  E.g. =
if KVM
is running on a CPU that has IBT but not SHSTK, then userspace can write to=
 MSRs
that do not exist.

Maybe this confusion is just a symptom of the series not providing proper
Supervisor Shadow Stack support, but that's still a poor excuse for posting
broken code.

I suspect you tried to get too fancy.  I don't see any reason to ever care =
about
kvm_caps.supported_xss beyond emulating writes to XSS itself.  Just require=
 that
both CET_USER and CET_KERNEL are supported in XSS to allow IBT or SHSTK, i.=
e. let
X86_FEATURE_IBT and X86_FEATURE_SHSTK speak for themselves.  That way, this=
 can
simply be:

bool kvm_cet_is_msr_accessible(struct kvm_vcpu *vcpu, struct msr_data *msr)
{
	if (is_shadow_stack_msr(...))
		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
			return false;

		return msr->host_initiated ||
		       guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
	}

	if (!kvm_cpu_cap_has(X86_FEATURE_IBT) &&
	    !kvm_cpu_cap_has(X86_FEATURE_SHSTK))
		return false;

	return msr->host_initiated ||
	       guest_cpuid_has(vcpu, X86_FEATURE_IBT) ||
	       guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
}

> > > + * and reload the guest fpu states before read/write xsaves-managed =
MSRs.
> > > + */
> > > +static inline void kvm_get_xsave_msr(struct msr_data *msr_info)
> > > +{
> > > +	fpregs_lock_and_load();
> > KVM already has helpers that do exactly this, and they have far better =
names for
> > KVM: kvm_fpu_get() and kvm_fpu_put().  Can you convert kvm_fpu_get() to
> > fpregs_lock_and_load() and use those isntead? And if the extra consiste=
ncy checks
> > in fpregs_lock_and_load() fire, we definitely want to know, as it means=
 we probably
> > have bugs in KVM.
>=20
> Do you want me to do some experiments to make sure the WARN()=EF=BF=BD in
> fpregs_lock_and load() would be triggered or not?

Yes, though I shouldn't have to clarify that.  The well-documented (as of n=
ow)
expectation is that any code that someone posts is tested, unless explicitl=
y
stated otherwise.  I.e. you should not have to ask if you should verify the=
 WARN
doesn't trigger, because you should be doing that for all code you post.

> If no WARN() trigger, then replace fpregs_lock_and_load()/fpregs_unlock()
> with kvm_fpu_get()/
>=20
> kvm_fpu_put()?

Yes.
