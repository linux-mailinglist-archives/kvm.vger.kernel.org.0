Return-Path: <kvm+bounces-48677-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 565EEAD0A15
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 00:54:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7044C7AA020
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 22:53:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 215BC23D290;
	Fri,  6 Jun 2025 22:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gs+bO7aH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBC823C8BE
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 22:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749250470; cv=none; b=hKJFXimBlDjc675y1MGVRmwEeozYqBTPwviKgrdoMSYT2av8jmAo1y6I8HMUOvgf47wV35uabG9HnvgzZmbJILDmVkt+ZtnNY8cvhzIyQ+LEIQYSNi6XhVgUi4pkMauz+xVktRF4RLF61ZQKmjSJPsn3WEe7hoKuBqvbpPlyMsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749250470; c=relaxed/simple;
	bh=yKF/NLWN4FmuWNP17WEu5JAZceS64vG9Fm6ERB5njFg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iWuVj3bb+/PXCcN10W2IDLb0d6UxU2Ojt9xks1HrB2yKRM0YYxFfiXWu8uAg2TcV3GnvoGIjfCrWCyV7ZEI++9MV5pbf5mGl+mQuXM/mLyDNbtvvpFHHbpRzG4u+mrivemvo7ErDtzc2/uUIfBeMXE8/ineNrPw5v5LoDVDFCLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gs+bO7aH; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b0e0c573531so1501124a12.3
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 15:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749250468; x=1749855268; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EvySqspEQVoeGeRUTRhl2NUMgR5t7n/WU6Wag+8isF0=;
        b=gs+bO7aHza9Ch0kreP+gcZ2jE9BHMMbIe9F5Re/EvbxAkGAOQdULUV/mkKYXN0CjnJ
         dxHtNkEQnrZCgX2pQn3m5H5MNMIB8vFpl6+PqIDfNvpD5by2PvIYi/okkg+tIJBp29ez
         yVP4YAloXOA/vDr2KyPodbGma24gtRJJi3KmHelCOi5E9ZirkuAFmV2IIChr2FOv3rjr
         M1nW3i8ekHJrvACOFii6em6nedSq8hH8A2WC2nnz8RLwMOEe/gxpv8Oa8HN1IJdvhJE6
         UfeT8GKBxwrUEC7ktQdnjTYSS70AHjnTJgsuCafDcZXijR5yAxBz4Ajr90nZuUtVb+w9
         /l5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749250468; x=1749855268;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EvySqspEQVoeGeRUTRhl2NUMgR5t7n/WU6Wag+8isF0=;
        b=h7KQFXiuuxzqxl/oHXs4d4NqVInf6ZTA4SxpE6rePH+00W4RevVQA1sWjvUO24IYTh
         q/nEdeaPYAmdkWXMWLuimnxMM2ia4VxMm0IJlihlNIT/rCdpX7K5yvoskZY6jaf7QTpl
         j4aLeGL26I5iyIn3ysRotsbHuqot2q/9FrxyLMO9kIhr3y60nPL4FyMbil+XVlhFsndA
         Wpn8ZVEJiFpq055O+BDjIuMOn0wgsxovMGo5SqUAyZ5C9cdwGaRTctQ7qCpv3pOD6IFk
         rE0kQxvj5c1pMdnZJCqC7kYMyc3xjUlljH7BKrZ1BtJHf3SgJPqToSU2QCYeTMNBrAYo
         Qjmg==
X-Forwarded-Encrypted: i=1; AJvYcCX7TsS/7HhMOC96nh3R8h4N4Kse0IVYZtR7/cCsYGjfLV+omaE5r8iEc1hEJEad1DPVvqQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywz8SU2uUsiVEZEMVmyvsyJ4DdIfk5+y9uRzbS2rlEe2Z06g1Hv
	st5jZy2uDZ/HzPGb3zWB6Q2WxgynQtznJ/vTup+9mta/w2vbjBAHufsFTzd2vlobJMzCfPt3OJ7
	KL9gaDg==
X-Google-Smtp-Source: AGHT+IFqigLk0NIDwkjpeb5ApxutUdruTchcEBopM6slK/JX5IYYl81HW/7KTMr5YJOPKSr3iVnXbFeNfn0=
X-Received: from pfbho2.prod.google.com ([2002:a05:6a00:8802:b0:747:b76c:ab92])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:2d43:b0:21d:8dc:796d
 with SMTP id adf61e73a8af0-21ee254c5c0mr5268731637.23.1749250468097; Fri, 06
 Jun 2025 15:54:28 -0700 (PDT)
Date: Fri, 6 Jun 2025 15:54:26 -0700
In-Reply-To: <aELixaeTRl+BcfcH@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605192643.533502-1-seanjc@google.com> <20250605192643.533502-3-seanjc@google.com>
 <aELixaeTRl+BcfcH@intel.com>
Message-ID: <aENxom-bLZX03-u3@google.com>
Subject: Re: [kvm-unit-tests PATCH 2/3] x86/msr: Add a testcase to verify
 SPEC_CTRL exists (or not) as expected
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 06, 2025, Chao Gao wrote:
> On Thu, Jun 05, 2025 at 12:26:42PM -0700, Sean Christopherson wrote:
> >diff --git a/x86/msr.c b/x86/msr.c
> >index ac12d127..ca265fac 100644
> >--- a/x86/msr.c
> >+++ b/x86/msr.c
> >@@ -290,10 +290,37 @@ static void test_x2apic_msrs(void)
> > 	__test_x2apic_msrs(true);
> > }
> > 
> >-static void test_cmd_msrs(void)
> >+static void test_mitigation_msrs(void)
> > {
> >+	u64 spec_ctrl_bits = 0, val;
> > 	int i;
> > 
> >+	if (this_cpu_has(X86_FEATURE_SPEC_CTRL) || this_cpu_has(X86_FEATURE_AMD_IBRS))
> >+		spec_ctrl_bits |= SPEC_CTRL_IBRS;
> >+
> >+	if (this_cpu_has(X86_FEATURE_SPEC_CTRL) || this_cpu_has(X86_FEATURE_AMD_STIBP))
> >+		spec_ctrl_bits |= SPEC_CTRL_STIBP;
> 
> CPUID.(EAX=07H, ECX=0):EDX[26] enumerates IBRS and IBPB support, but it doesn't
> enumerate STIBP support. EDX[27] does.

Drat, that's what I get for trying to reverse engineer the kernel's mitigations.
It's super obvious when I actually look at the CPUID feature definitions.

Thanks!

