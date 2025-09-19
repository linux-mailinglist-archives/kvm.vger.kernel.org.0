Return-Path: <kvm+bounces-58154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 50CB6B8A1B5
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 16:55:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D2F118876E0
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 14:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71B73112C2;
	Fri, 19 Sep 2025 14:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zh7bio4X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98A61F3FEC
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 14:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758293713; cv=none; b=pIJ8OpM7ePdZ/kI/4TyXSyq5ogIa9idLTZzniyluIJj1xNLD6SCZY2Oj/LFd+MdNz2kvQUeOXYqbOC5RKcOhyqXnncoj6Y9ELbEFOEmO3jyNNQFxd6WIjhLhFGNXeOUY/Du7bayi51mFAaEugnPDqgtDgUIYWKMXoCQaqtWAqg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758293713; c=relaxed/simple;
	bh=AcD69okMOpEbxEQkwsqp0PT3CELtBK6EsZ3jJIbiM+U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lCC17GWYHI1gQM2ObIJKhAiPC+Z9j+lIU4Gq/+6AE7bQ0qfOIXTFI/cW2x8llR80s6L5Yph3voS8v/NIrGaP5Jw9aHQ5dv4Fm6AoLe/+iRWM1btFGaoXnBveP5a4iw8R3rLbInFhI9UW72NVrrc2BSAcmqdHqg1sA0DVbY2mBY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zh7bio4X; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-268141f759aso23445505ad.2
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 07:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758293711; x=1758898511; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ukxipGRfsdTkRjH+xOeneAls5BFz/ZvVQ9NXnmVWsy4=;
        b=Zh7bio4XtLI0vHUKFeV9Ag3i2wJrvcfCh1Fzdhy+mTXdm4YzYTzE2SoVyVpuyEEI4u
         eUTka+yykyzLhWlE7buVbAZueOhcqpP1JMHDkUrrQobBpG/YmL/ycnaWue1Eeeb0rLxo
         URb/Gxfb/hUHCBRRS2z0Z4Xn9RDpaRADHLmYCIkAKj3DzE9iSbeCztpwr2DRpKkrkLzJ
         Y2VBgyoRI/yAPhB3BiTnhtUuVX21bUf8ShaG2egT5V4qbGsNNXg2ZmczypC3IJqUYG3D
         t28SR+3HFONtadSYSKVpparHdLFvnPMrL2AiuMoUVO9jt457k9a4XU7gIR3DA2siiPaM
         Zo3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758293711; x=1758898511;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ukxipGRfsdTkRjH+xOeneAls5BFz/ZvVQ9NXnmVWsy4=;
        b=EvgPhAjlwZ5DFcXOAMychx0UDeM77bOMVhXy/eLpesViHUrY0x/bHCtEFsOBGZ+V9a
         lMKJel/b2tveH0z93VM1niYgL3rWpsTL/PYSnuMheT5QOkqBogYDmxTD6xyNXbsKxpcN
         UDOz2XJwj8c7qOP0ddoTcBnzbWzVvoVuYi1wsAvDaAaL48Br78nWsa6X4LIYzMcTa/mX
         Xx8ZO95VIHSEjLebh2NU9yyQBbTIpSexgfkK3hcltwb+dID9YbaenSGTlXoOVaO/QKuj
         ugstXVUOEj8oSYTPkIYa4XueO0kT/yxZfLGPzHL8r/i+ZqeZUGPGrTOQo9G9V4sZiqTQ
         UIEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpJfYN4dW3LdN3DQY9kTPQW4p9apzaB3aTmVzhE2RwJXcExUaoZP2wf5D2o3SIjrX5R1k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7YH990pEfQ9YBGSIf1K4n2h2KO/3x9LHhbLUU+4CCdmgKoDOe
	Qm+iz0N6QpNuxyqSaez5jQ2VUK5Tv4aV1gaRQ3lKUVstkvftlixKNZ3mw8xNgTN4NkZVgjtSh2d
	im2mW8Q==
X-Google-Smtp-Source: AGHT+IEPv+dMGHlbROIguDvWPOh2MSP4wIEpD1hQevdkOddIgSAniwuj5qvJ5S/5KY6sgA6Wv/GK8O6BCmY=
X-Received: from pjbnc8.prod.google.com ([2002:a17:90b:37c8:b0:32e:bcc3:ea8e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:46d0:b0:24f:fb79:e25f
 with SMTP id d9443c01a7336-269ba544991mr49200515ad.46.1758293710936; Fri, 19
 Sep 2025 07:55:10 -0700 (PDT)
Date: Fri, 19 Sep 2025 07:55:09 -0700
In-Reply-To: <dd2d2e23-083e-46cf-b0bd-7dfb3198d403@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919004512.1359828-1-seanjc@google.com> <20250919004512.1359828-6-seanjc@google.com>
 <dd2d2e23-083e-46cf-b0bd-7dfb3198d403@linux.intel.com>
Message-ID: <aM1uzfweXxoaaLpt@google.com>
Subject: Re: [PATCH v3 5/5] KVM: selftests: Handle Intel Atom errata that
 leads to PMU event overcount
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yi Lai <yi1.lai@intel.com>, dongsheng <dongsheng.x.zhang@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 19, 2025, Dapeng Mi wrote:
>=20
> On 9/19/2025 8:45 AM, Sean Christopherson wrote:
> > diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tool=
s/testing/selftests/kvm/x86/pmu_counters_test.c
> > index baa7b8a2d459..acb5a5c37296 100644
> > --- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> > +++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
> > @@ -163,10 +163,18 @@ static void guest_assert_event_count(uint8_t idx,=
 uint32_t pmc, uint32_t pmc_msr
> > =20
> >  	switch (idx) {
> >  	case INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX:
> > -		GUEST_ASSERT_EQ(count, NUM_INSNS_RETIRED);
> > +		/* Relax precise count check due to VM-EXIT/VM-ENTRY overcount issue=
 */
> > +		if (this_pmu_has_errata(INSTRUCTIONS_RETIRED_OVERCOUNT))
>=20
> The pmu_errata_mask is a bitmap, so the argument should be
> BIT_ULL(INSTRUCTIONS_RETIRED_OVERCOUNT) instead of
> INSTRUCTIONS_RETIRED_OVERCOUNT?

Gah, I just forgot to use BIT_ULL() in this_pmu_has_errata().

diff --git a/tools/testing/selftests/kvm/include/x86/pmu.h b/tools/testing/=
selftests/kvm/include/x86/pmu.h
index 25d2b476daf4..308c9f6f0d57 100644
--- a/tools/testing/selftests/kvm/include/x86/pmu.h
+++ b/tools/testing/selftests/kvm/include/x86/pmu.h
@@ -115,7 +115,7 @@ void kvm_init_pmu_errata(void);
=20
 static inline bool this_pmu_has_errata(enum pmu_errata errata)
 {
-       return pmu_errata_mask & errata;
+       return pmu_errata_mask & BIT_ULL(errata);
 }
=20
 #endif /* SELFTEST_KVM_PMU_H */


>=20
> Or better, directly define INSTRUCTIONS_RETIRED_OVERCOUNT as a bitmap, li=
ke
> this.
>=20
> diff --git a/tools/testing/selftests/kvm/include/x86/pmu.h
> b/tools/testing/selftests/kvm/include/x86/pmu.h
> index 25d2b476daf4..9af448129597 100644
> --- a/tools/testing/selftests/kvm/include/x86/pmu.h
> +++ b/tools/testing/selftests/kvm/include/x86/pmu.h
> @@ -106,8 +106,8 @@ extern const uint64_t intel_pmu_arch_events[];
> =C2=A0extern const uint64_t amd_pmu_zen_events[];
>=20
> =C2=A0enum pmu_errata {
> -=C2=A0 =C2=A0 =C2=A0 =C2=A0INSTRUCTIONS_RETIRED_OVERCOUNT,
> -=C2=A0 =C2=A0 =C2=A0 =C2=A0BRANCHES_RETIRED_OVERCOUNT,
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0INSTRUCTIONS_RETIRED_OVERCOUNT =3D (1 << 0),
> +=C2=A0 =C2=A0 =C2=A0 =C2=A0BRANCHES_RETIRED_OVERCOUNT=C2=A0 =C2=A0 =C2=
=A0=3D (1 << 1),

I want to utilize the auto-incrementing behavior of enums, without having t=
o
resort to double-defines or anything.=20

