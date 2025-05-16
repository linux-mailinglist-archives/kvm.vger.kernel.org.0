Return-Path: <kvm+bounces-46878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D354ABA4DD
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 22:54:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26E8CA22D19
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 20:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13617278766;
	Fri, 16 May 2025 20:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P3B7bveB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17B622D4F9
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 20:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747428883; cv=none; b=H97ce6QOspwl+Jw9DQ23U48vilgy9Uk5xp6klNILtYx/BV/eqEZSv1C0Yk4vjubvRMuGXwUUTecApOH72wKarp36EuXBSZynj3Xq9pYOqUw6EDVdzzkYEzQ/WFN/NwF9s4hUrgm9QV92t3Wa01Ni6IUprWyzztpis0MifhfT/fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747428883; c=relaxed/simple;
	bh=QWFG0Ylh5oGGQ0y5MXw7J0v9cLYgY8UG3wLXOKRNB6I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ewMZK7C+0fYs7JxrFyY2x+Z060y9TXqwScUIpmywZRZD4fWYz8SnN2I+tGIOGGG961cfhx7/sa7uSUWBHy6ih8DILTtbtcJt3VRu/eQqemgQou7oCkYERiPg40Wv/M204GwFqKvgN59TVM8KndIMocxMLTGbe0vk1WXlc4s49JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P3B7bveB; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b26e120e300so1976537a12.1
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 13:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747428881; x=1748033681; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pUEdh5iBFBvuEiqTMp07Lu/KDXTezSp1m3vHIrINdEA=;
        b=P3B7bveBkhciad9rpRDaft6/0HMMZhqJpG1nEqbLj0xg7kYpV3HaLTu52g5UGJDvko
         Vqg9uYus3ZFT9vj40IHW7WeniOxJXjeaYh2lCNE0/RPGuEhvUQGCLBYORocESV9cwVf4
         aaBnXSbVwzu6dgn6zcucOKbaSTrPU1z2mVP6rLMuBJLXlXZZNqVlDx9Tn2krXkKBzmlk
         RvW96lbx5MmYIBF7mGAs53/j+gMcnBnM1U1FlkNKncDYQPr+2ervoCAa1veL2W2Ns79G
         izjRG+89orqrv9SIQT1954b5s3Yyw/bee2kWd2si3c+/uT8E86LPMOxg1mQ4lESPZwqE
         v4EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747428881; x=1748033681;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pUEdh5iBFBvuEiqTMp07Lu/KDXTezSp1m3vHIrINdEA=;
        b=RKTnRLaqzr9fNUMtECajmoIwnU1ZgOSW/XN6wNQOBC3hbdZSr429VBE0sdaiGFsjSn
         4YhubJ9f2C6BaRoH8HofFy7TlKiPLKfg8CnJXz/uT1LkYAtecEfbW0adTudKdA2H9cKX
         aKpJCIVpGPoEkddtjrjHJSkXqfirF8ic0W5cEVrXYSUSCSaJI4SMlgmm1nJ4DW+kzBb+
         thihzDlw+kwSsTlnhB2PLwlTBbqsOYyLO+Y6+4mKKtWCJPY+FOCu4G9q6dN4/VZxO87F
         yO1T0v8Fwv5KXpN579Yjf8eAx+MSxrKcSFs5IAU+RJ5diupdONdEnNoqoeXqlwGSVYne
         4CoA==
X-Forwarded-Encrypted: i=1; AJvYcCU4kV2N9JN0L7QdHWqk1eZiSHgAQpYbfF8FfqADiNRhJaWgUSsF5BVhF4q6EiE6KkL+HTA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/5y6sxM2Us9ZQ1nVZiRI2Zz38vFxWg7J0pcJCQutKxOidjd94
	oTCeOFRKQf7F36XN6fyV2JfXGowIJP+GMJ9SFElLHcKHs1y5caEhjrzqrse0c3HXdV2/LEsFmzt
	gsrffzA==
X-Google-Smtp-Source: AGHT+IEKXMvi6p5AYfeWYVVxoOJp0+T+HCMSwZBivOJAwnUFY68sURx/OiAsfMQfNNX7Rux9VtkV5C8ZiFM=
X-Received: from pgid6.prod.google.com ([2002:a63:ed06:0:b0:b26:de99:6f81])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6f83:b0:1f5:619a:8f79
 with SMTP id adf61e73a8af0-21621876910mr7462694637.1.1747428880970; Fri, 16
 May 2025 13:54:40 -0700 (PDT)
Date: Fri, 16 May 2025 13:54:34 -0700
In-Reply-To: <2d0d274c-6bc0-43c7-a8a8-92aa11872675@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250324173121.1275209-1-mizhang@google.com> <20250324173121.1275209-28-mizhang@google.com>
 <2d0d274c-6bc0-43c7-a8a8-92aa11872675@linux.intel.com>
Message-ID: <aCemClX6rKnVFqLt@google.com>
Subject: Re: [PATCH v4 27/38] KVM: x86/pmu: Handle PMU MSRs interception and
 event filtering
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Mingwei Zhang <mizhang@google.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Liang@google.com, 
	Kan <kan.liang@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yongwei Ma <yongwei.ma@intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Sandipan Das <sandipan.das@amd.com>, 
	Zide Chen <zide.chen@intel.com>, Eranian Stephane <eranian@google.com>, 
	Shukla Manali <Manali.Shukla@amd.com>, Nikunj Dadhania <nikunj.dadhania@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2025, Dapeng Mi wrote:
> On 3/25/2025 1:31 AM, Mingwei Zhang wrote:
> > +	if (kvm_mediated_pmu_enabled(pmu_to_vcpu(pmu))) {
> > +		bool allowed =3D check_pmu_event_filter(pmc);
> > +
> > +		if (pmc_is_gp(pmc)) {
> > +			if (allowed)
> > +				pmc->eventsel_hw |=3D pmc->eventsel &
> > +						    ARCH_PERFMON_EVENTSEL_ENABLE;
> > +			else
> > +				pmc->eventsel_hw &=3D ~ARCH_PERFMON_EVENTSEL_ENABLE;
> > +		} else {
> > +			int idx =3D pmc->idx - KVM_FIXED_PMC_BASE_IDX;
> > +
> > +			if (allowed)
> > +				pmu->fixed_ctr_ctrl_hw =3D pmu->fixed_ctr_ctrl;
>=20
> Sean, just found there is a potential bug here.=C2=A0 The
> "pmu->fixed_ctr_ctrl_hw" should not be assigned to "pmu->fixed_ctr_ctrl"
> here, otherwise the other filtered fixed counter (not this allowed fixed
> counter) could be enabled accidentally.
>=20
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index ba9d336f1d1d..f32e5f66f73b 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -473,7 +473,8 @@ static int reprogram_counter(struct kvm_pmc *pmc)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int idx =
=3D pmc->idx - KVM_FIXED_PMC_BASE_IDX;
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (allo=
wed)
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pmu->fixed_ctr_ctrl_hw =3D pmu->fixed_ctr=
_ctrl;
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pmu->fixed_ctr_ctrl_hw |=3D pmu->fixed_ct=
r_ctrl &
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> intel_fixed_bits_by_idx(idx, 0xf);

Hmm, I think that's fine, since pmu->fixed_ctr_ctrl should have changed?  B=
ut I'd
rather play it safe and do (completely untested):

	if (pmc_is_gp(pmc)) {
		pmc->eventsel_hw &=3D ~ARCH_PERFMON_EVENTSEL_ENABLE;
		if (allowed)
			pmc->eventsel_hw |=3D pmc->eventsel &
					    ARCH_PERFMON_EVENTSEL_ENABLE;
	} else {
		u64 mask =3D intel_fixed_bits_by_idx(pmc->idx - KVM_FIXED_PMC_BASE_IDX, 0=
xf);

		pmu->fixed_ctr_ctrl_hw &=3D ~mask;
		if (allowed)
			pmu->fixed_ctr_ctrl_hw |=3D pmu->fixed_ctr_ctrl & mask;
	}

