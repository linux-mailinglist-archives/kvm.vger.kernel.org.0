Return-Path: <kvm+bounces-7507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2672B84313D
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 00:28:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B29D1C23D16
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 23:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DCAA762D6;
	Tue, 30 Jan 2024 23:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AX2A6ypD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFEA79941
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 23:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706657273; cv=none; b=IuI/ZEHU/Ez4R5CyRyTAVmtFncuSWVVJ9xug8PAs98WWZ4HKNDd6vt4XIjbeD5SouxS074wfAfFkYD5IPvwNE8EHR++qWl+R/73MJJqRcvWvXtKbhgJKO4t1Un4qrzuhBQSERCT9Lp6g/tRt8by5RiT16wT2XGgkDec3ksrUgUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706657273; c=relaxed/simple;
	bh=KfTemhN3MAvuoqt6yf5Kxs1pawxGT8UvKf0mXE649a4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AFAm739HokbCPpwV8cFX+2tYVt78mAeqljz6nzWycoQk79y327unUNyBi4o26rMHIZaxKPc9CE1y17LRFRlijc+wt4Ov2CNZdndY5Yf3Bb2uj/lAL/J6/oEsoO1YCAtChqFvotnWI7/svEcr3M5zsbbdFvh3OP5jmn40tWpg3Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AX2A6ypD; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbf216080f5so8121832276.1
        for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 15:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706657270; x=1707262070; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4LUZBTwgQWOqcUDdzUzVaclv3cSncxEYBiXIU8rhjPo=;
        b=AX2A6ypDaChfkgaj23qrbsy+YKRTa+OHCweeTH8CB7Zb1fNKwkOXSufQ316+JU3+kJ
         4yvtd+gcam1mo7tVJNJ9tC1y0gGB9lY1JwOSMf+5fgLTbQ2A6jGXAkKeVuisKefq59xM
         MJ/kjG/Z7y8I6/I6Vjdwz6sILPcYQ9NI8n37k6y5dIV0T7+uIWxSsq+qTjov3X6Tzm09
         cOn5HsqxQ2CK/YexloGxySgma737AzyVxk9qNmfKTixRs4+koaTegJGntBBDDoyeKoCP
         6c1wN0wuabD8yO+MOzwec8bzKgmV5l3mutFvWMgi6TWTYLXYFOAs+2Udiu+BtCKH6GqD
         nRag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706657270; x=1707262070;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4LUZBTwgQWOqcUDdzUzVaclv3cSncxEYBiXIU8rhjPo=;
        b=s1hNe+qdZ+HXR9BqDNy5MaE14KVu4NLyXuThvOEP/IEZ0vYgaqWosoiw8QhKPw/3L6
         sUsucb4VH2umScbRYIx8nfWQaJIKPITVQd9g+PGg9MfjC7DJp1xgNZRnZn1t/QUVZWnr
         8cdyJwwrqHJ9CWehX7v21m2Hp0luQILimR43HtMN1NeF+Ad/zr9mlucyUt8m/nbJFvuf
         NC+A0LslwsT9AAAuEmBfDO9y+7s7N3UdtsnL78CgT3VPWJNJmuBCvh5aFmhOHpHI4nK7
         qVJbN29sLAeovw7VqBziSMrJatm3R3iRka8EOqG0T4vWsQY8/tNKIllvDTrV2hwrIHed
         V3YA==
X-Gm-Message-State: AOJu0YzgdIoq0XJTowVKKQmO7xNBQcrDF9+r/5DpzCBW9gP8c758T/xL
	fcpEokZrHITuLV65XNJLncVS3ci0xHpX+RhvWOlvzd2N1RKus3Ueku/0yi3Fn97w393SibksOhU
	yiA==
X-Google-Smtp-Source: AGHT+IGSOgtoOGUWy8KSdhTU0rJMoKxy/AeQnKMPIP2EYsFE4hLAMhJ/aHErXLGnJf88ZCIpOSHUxuMe89A=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1b10:b0:dc6:9e4a:f950 with SMTP id
 eh16-20020a0569021b1000b00dc69e4af950mr14836ybb.3.1706657270711; Tue, 30 Jan
 2024 15:27:50 -0800 (PST)
Date: Tue, 30 Jan 2024 15:27:49 -0800
In-Reply-To: <cce0483f-539b-4be3-838d-af0ec91db8f0@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240109230250.424295-1-seanjc@google.com> <20240109230250.424295-17-seanjc@google.com>
 <5f51fda5-bc07-42ac-a723-d09d90136961@linux.intel.com> <ZaGxNsrf_pUHkFiY@google.com>
 <cce0483f-539b-4be3-838d-af0ec91db8f0@linux.intel.com>
Message-ID: <ZbmF9eM84cQhdvGf@google.com>
Subject: Re: [PATCH v10 16/29] KVM: selftests: Test Intel PMU architectural
 events on gp counters
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Jim Mattson <jmattson@google.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Aaron Lewis <aaronlewis@google.com>, 
	Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 15, 2024, Dapeng Mi wrote:
>=20
> On 1/13/2024 5:37 AM, Sean Christopherson wrote:
> > On Fri, Jan 12, 2024, Dapeng Mi wrote:
> > > On 1/10/2024 7:02 AM, Sean Christopherson wrote:
> > > > +/*
> > > > + * If an architectural event is supported and guaranteed to genera=
te at least
> > > > + * one "hit, assert that its count is non-zero.  If an event isn't=
 supported or
> > > > + * the test can't guarantee the associated action will occur, then=
 all bets are
> > > > + * off regarding the count, i.e. no checks can be done.
> > > > + *
> > > > + * Sanity check that in all cases, the event doesn't count when it=
's disabled,
> > > > + * and that KVM correctly emulates the write of an arbitrary value=
.
> > > > + */
> > > > +static void guest_assert_event_count(uint8_t idx,
> > > > +				     struct kvm_x86_pmu_feature event,
> > > > +				     uint32_t pmc, uint32_t pmc_msr)
> > > > +{
> > > > +	uint64_t count;
> > > > +
> > > > +	count =3D _rdpmc(pmc);
> > > > +	if (!this_pmu_has(event))
> > > > +		goto sanity_checks;
> > > > +
> > > > +	switch (idx) {
> > > > +	case INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX:
> > > > +		GUEST_ASSERT_EQ(count, NUM_INSNS_RETIRED);
> > > > +		break;
> > > > +	case INTEL_ARCH_BRANCHES_RETIRED_INDEX:
> > > > +		GUEST_ASSERT_EQ(count, NUM_BRANCHES);
> > > > +		break;
> > > > +	case INTEL_ARCH_CPU_CYCLES_INDEX:
> > > > +	case INTEL_ARCH_REFERENCE_CYCLES_INDEX:
> > > Since we already support slots event in below guest_test_arch_event()=
, we
> > > can add check for INTEL_ARCH_TOPDOWN_SLOTS_INDEX here.
> > Can that actually be tested at this point, since KVM doesn't support
> > X86_PMU_FEATURE_TOPDOWN_SLOTS, i.e. this_pmu_has() above should always =
fail, no?
>=20
> I suppose X86_PMU_FEATURE_TOPDOWN_SLOTS has been supported in KVM.=C2=A0 =
The
> following output comes from a guest with latest kvm-x86 code on the Sapph=
ire
> Rapids platform.
>=20
> sudo cpuid -l 0xa
> CPU 0:
> =C2=A0=C2=A0 Architecture Performance Monitoring Features (0xa):
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 version ID=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 =3D 0x2 (2)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 number of counters per logical processor =
=3D 0x8 (8)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bit width of counter=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 =3D 0x30 (48)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 length of EBX bit vector=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 =3D 0x8 (8)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 core cycle event=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D available
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 instruction retired event=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 =3D available
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reference cycles event=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 =3D available
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 last-level cache ref event=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D a=
vailable
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 last-level cache miss event=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D availab=
le
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 branch inst retired event=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 =3D available
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 branch mispred retired event=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D available
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 top-down slots event=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 =3D available
>=20
> Current KVM doesn't support fixed counter 3 and pseudo slots event yet, b=
ut
> the architectural slots event is supported and can be programed on a GP
> counter. Current test code can cover this case, so I think we'd better ad=
d
> the check for the slots count.

Can you submit a patch on top, with a changelog that includes justification=
 that
that explains exactly what assertions can be made on the top-down slots eve=
nt
given the "workload" being measured?  I'm definitely not opposed to adding =
coverage
for top-down slots, but at this point, I don't want to respin this series, =
nor do
I want to make that change when applying on the fly.

