Return-Path: <kvm+bounces-20797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F17D891DFE7
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 14:52:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B96E1C2153D
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 12:52:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D89D15A863;
	Mon,  1 Jul 2024 12:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AbOh2tbC"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46149145B09;
	Mon,  1 Jul 2024 12:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719838339; cv=none; b=M9hblGZiIQksyscdkUIIirEDxl6DesjcZkcJPpIR6uzbeh2BCjqG4tGgawZx1mrWdZRcL1EDp8RkM8ppwXIOkpqKj+i/xtna6rmEN9U3KV0QFJfKdVFO50w58anEIi+OLNp7RsvOfzGbtS1CwOQ9RejqbyLh/Kd91ESk73ZSpgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719838339; c=relaxed/simple;
	bh=UNORtFYxSHmLILKBNh+BaXXL3TICgUlio276C9/IBX4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RyT6zgPi1yfhVWBJIW08J8a3rt3fSsg454ORCv8C8gpHwBissJjiVcUkUKU5Amh3iX7AVHfegMs7EJf3yNs8qAhiOf3x5zrpj1pSCovs0LLdZsNRuK0Ae1jddnr+3vJvN5r2u1R6yTEmO2HMc1xvy4miyU+jQntj8LJouc7VJXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AbOh2tbC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7C6C116B1;
	Mon,  1 Jul 2024 12:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719838338;
	bh=UNORtFYxSHmLILKBNh+BaXXL3TICgUlio276C9/IBX4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=AbOh2tbCSZQ73teQiLEboH9cVkekkt8TQRlG7PW8UWl3znyL7KLTmd3DUXP7cTl93
	 tB4z16fcVJ+nCZYkaioD0JvbVzDmK1Q627CQ9ZIIUym2lilwYu2+jo7UXKyAvVovyv
	 nwsbDyVMMvt07t0T2ceMnEijkoNhxfhol7cIl+kCi4RRUwGYm7yfTlF8gh9mH0aEEU
	 Iqi31HP+9MEy5hxPHYU4cCianc3pQtGzdqJrPsMAXyEI4S+RlVLsVCAIO2sgkMjy4j
	 7c8uUZt8++uSIFCBt5IU+YrC4XBJJwNxiYsIyA7N/sNLoOJc3dXf9u8mEyU5il6Zj3
	 MDQg/905R9JtQ==
Message-ID: <52d965101127167388565ed1520e1f06d8492d3b.camel@kernel.org>
Subject: Re: [PATCH v2] KVM: SVM: let alternatives handle the cases when RSB
 filling is required
From: Amit Shah <amit@kernel.org>
To: Jim Mattson <jmattson@google.com>, Sean Christopherson
 <seanjc@google.com>
Cc: pbonzini@redhat.com, x86@kernel.org, kvm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de,  dave.hansen@linux.intel.com, hpa@zytor.com,
 kim.phillips@amd.com,  david.kaplan@amd.com
Date: Mon, 01 Jul 2024 14:52:14 +0200
In-Reply-To: <CALMp9eSfZsGTngMSaWbFrdvMoWHyVK_SWf9W1Ps4BFdwAzae_g@mail.gmail.com>
References: <20240626073719.5246-1-amit@kernel.org>
	 <Zn7gK9KZKxBwgVc_@google.com>
	 <CALMp9eSfZsGTngMSaWbFrdvMoWHyVK_SWf9W1Ps4BFdwAzae_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 (3.52.2-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2024-06-28 at 11:48 -0700, Jim Mattson wrote:
> On Fri, Jun 28, 2024 at 9:09=E2=80=AFAM Sean Christopherson
> <seanjc@google.com> wrote:
> >=20
> > On Wed, Jun 26, 2024, Amit Shah wrote:
> > > ---
> > > =C2=A0arch/x86/kvm/svm/vmenter.S | 8 ++------
> > > =C2=A01 file changed, 2 insertions(+), 6 deletions(-)
> > >=20
> > > diff --git a/arch/x86/kvm/svm/vmenter.S
> > > b/arch/x86/kvm/svm/vmenter.S
> > > index a0c8eb37d3e1..2ed80aea3bb1 100644
> > > --- a/arch/x86/kvm/svm/vmenter.S
> > > +++ b/arch/x86/kvm/svm/vmenter.S
> > > @@ -209,10 +209,8 @@ SYM_FUNC_START(__svm_vcpu_run)
> > > =C2=A07:=C2=A0=C2=A0 vmload %_ASM_AX
> > > =C2=A08:
> > >=20
> > > -#ifdef CONFIG_MITIGATION_RETPOLINE
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* IMPORTANT: Stuff the RSB immediatel=
y after VM-Exit,
> > > before RET! */
> > > -=C2=A0=C2=A0=C2=A0=C2=A0 FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOP=
S,
> > > X86_FEATURE_RETPOLINE
> > > -#endif
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 FILL_RETURN_BUFFER %_ASM_AX, RSB_CLEAR_LOOP=
S,
> > > X86_FEATURE_RSB_VMEXIT
> >=20
> > Out of an abundance of paranoia, shouldn't this be?
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 FILL_RETURN_BUFFER %_ASM_CX,=
 RSB_CLEAR_LOOPS,
> > X86_FEATURE_RSB_VMEXIT,\
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 X86_FEATURE_RSB_VMEXIT_LITE
> >=20
> > Hmm, but it looks like that would incorrectly trigger the "lite"
> > flavor for
> > families 0xf - 0x12.=C2=A0 I assume those old CPUs aren't affected by
> > whatever on earth
> > EIBRS_PBRSB is.
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* AMD Family 0xf - 0x12 */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VULNWL_AMD(0x0f,=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 NO_MELTDOWN | NO_SSB | NO_L1TF |
> > NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_BHI),
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VULNWL_AMD(0x10,=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 NO_MELTDOWN | NO_SSB | NO_L1TF |
> > NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_BHI),
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VULNWL_AMD(0x11,=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 NO_MELTDOWN | NO_SSB | NO_L1TF |
> > NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_BHI),
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VULNWL_AMD(0x12,=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 NO_MELTDOWN | NO_SSB | NO_L1TF |
> > NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_BHI),
> >=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* FAMILY_ANY must be last, =
otherwise 0x0f - 0x12 matches
> > won't work */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VULNWL_AMD(X86_FAMILY_ANY,=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 NO_MELTDOWN | NO_L1TF |
> > NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_EIBRS_PBRSB |
> > NO_BHI),
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 VULNWL_HYGON(X86_FAMILY_ANY,=
=C2=A0=C2=A0=C2=A0 NO_MELTDOWN | NO_L1TF |
> > NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_EIBRS_PBRSB |
> > NO_BHI),
>=20
> Your assumption is correct. As for why the cpu_vuln_whitelist[]
> doesn't say so explicitly, you need to read between the lines...
>=20
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * AMD's AutoIBRS is equivale=
nt to Intel's eIBRS - use the
> > Intel feature
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * flag and protect from vend=
or-specific bugs via the
> > whitelist.
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 *
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Don't use AutoIBRS when SN=
P is enabled because it
> > degrades host
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * userspace indirect branch =
performance.
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if ((x86_arch_cap_msr & ARCH_CAP_I=
BRS_ALL) ||
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (cpu_has(c=
, X86_FEATURE_AUTOIBRS) &&
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !cpu=
_feature_enabled(X86_FEATURE_SEV_SNP))) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 if (!cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB)
> > &&
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !(x86_arch_cap_msr & ARCH_CAP_PBRSB=
_NO))
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 setup_force=
_cpu_bug(X86_BUG_EIBRS_PBRSB);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>=20
> Families 0FH through 12H don't have EIBRS or AutoIBRS, so there's no
> cpu_vuln_whitelist[] lookup. Hence, no need to set the NO_EIBRS_PBRSB
> bit, even if it is accurate.

The commit that adds the RSB_VMEXIT_LITE feature flag does describe the
bug in a good amount of detail:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D2b1299322016731d56807aa49254a5ea3080b6b3

I've not seen any indication this is required for AMD CPUs.

David, do you agree we don't need this?

		Amit
>=20


