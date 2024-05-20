Return-Path: <kvm+bounces-17769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACB478C9EF5
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 16:44:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DB699B2272A
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 14:44:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33CF21369AB;
	Mon, 20 May 2024 14:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hXW4aAdh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F8E136669
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 14:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716216234; cv=none; b=XXit+l38mTSDAjch7gkN2FP5wFF2acsylRVuPM2znmVq9qeVYj33AL/RvJ4lom71s5/2VmEWZs5OFi5d0cKOgPJ2tRq7QE6cGgl9tyFK8JVQvCAE8JE7JnC0avvhfYuu1aIrmimm/X4bfkZ04e+0S4X5zpqBEX3pfzFkNgbcQhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716216234; c=relaxed/simple;
	bh=MoSgOt5fxFT/+R6I0KO9uKHcSqSJMKJi1edmKDPYmPk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KnCuDsxwQIpSRbJlkkIx/W71TGEWTuQdDaHAgwt+pboTjmD/8S5I+lc9/hxLQPwLxBUQKO3SMqB8mjThsRQI/xvdNsh95EyOhS8ybYPskPPeAZbLSBgW4J9cS+lzdvRy3SmBpYGR6St+RYYhYOq6DX9hekvWl5N9x6IB4Nrl9dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hXW4aAdh; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2b96fd83042so6102157a91.2
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 07:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716216232; x=1716821032; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GnqgQERlUWMMCygBELf46qCSU1XiJILWa10x9VjinnU=;
        b=hXW4aAdhyF0Y0baZOuraRnEy2pitKpVxSQz9bMGXu/oCi05jyiCEhR2GI1YjSHaKUc
         +MbhUEv+YsfrQtrgwQBcjqySZao0xi4ZVDzBLZeSihLwPvlbppVaz334H4blMb3ZTjah
         f8NCdu+D9j439hn3U/FNbzmVBV6nFSrjnQKpZtzFIhnyBDoTPaQvThxTvLru9qpZhS7z
         4hxR4101QTeaVdnMFSoqEDGyryYFUcqfFQn8HdmuTwqmhLcmvHykHPI2J/RX/uoyKh3/
         oTh8fRGz2JHgY3lHOooe2m5oD+ZVfJGkMr8bl+zcA5d5UY33AqHLeDEyao13kplwzwH2
         Lj1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716216232; x=1716821032;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GnqgQERlUWMMCygBELf46qCSU1XiJILWa10x9VjinnU=;
        b=oF3H5KoXdXXvSs1F9NgKpeu91N0gCxHOGFUI2//Rb+eZRf41k4i731G59Oh+93nAbl
         FRZEozeMNJZI13wBA1gX0BLKGKGHZM1SyZpB7BUZB2Ux0V1GdauSuW6NT180Vu3KIk8e
         Wh0sxGlKGqwD5pBQx0vFgxkGvkm0EUrlhffqPkwYOxDuILxDcTtZBJxBZWluvSK4jVRX
         kNJ5X7EhNyioNUCADi+Ms7uNBDZ/UwvECHW6Y2YUVxRns6zz1G0nqwJTg/5g9htA+lGd
         R5rthzGD6vspHCTO9Y/8DCTB+uD2+zgFd+cMJ/mO1jUK5JTaP7rmYMB4oYUmzYiYVS9Q
         gq3Q==
X-Gm-Message-State: AOJu0YzCao0YKakbNEaNBOMWU69ZpditpiWtsQT8eiZuhUtT3KiWksDx
	oOJUCjsvYL9SI0l8L3GRfNXN/rZ7x2WTET+WeVun2uLrwvJXJVXacadq5/1Q8amg7Hn8exo4LfH
	Vig==
X-Google-Smtp-Source: AGHT+IED+GOTISQrV54+H9+5Jb5DAkGCUvbIRU/WMMm17xsBdlru17z7JI1pmRPPDDDzgk1F++lEyq3ob0g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:3117:b0:2bd:6734:363e with SMTP id
 98e67ed59e1d1-2bd673438b9mr16824a91.9.1716216231961; Mon, 20 May 2024
 07:43:51 -0700 (PDT)
Date: Mon, 20 May 2024 07:43:50 -0700
In-Reply-To: <20240520022002.1494056-1-tao1.su@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240520022002.1494056-1-tao1.su@linux.intel.com>
Message-ID: <ZkthpjnKRD1Jpj2A@google.com>
Subject: Re: [PATCH] KVM: x86: Advertise AVX10.1 CPUID to userspace
From: Sean Christopherson <seanjc@google.com>
To: Tao Su <tao1.su@linux.intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, chao.gao@intel.com, 
	xiaoyao.li@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 20, 2024, Tao Su wrote:
> @@ -1162,6 +1162,22 @@ static inline int __do_cpuid_func(struct kvm_cpuid=
_array *array, u32 function)
>  			break;
>  		}
>  		break;
> +	case 0x24: {
> +		u8 avx10_version;
> +		u32 vector_support;
> +
> +		if (!kvm_cpu_cap_has(X86_FEATURE_AVX10)) {
> +			entry->eax =3D entry->ebx =3D entry->ecx =3D entry->edx =3D 0;
> +			break;
> +		}
> +		avx10_version =3D min(entry->ebx & 0xff, 1);

Taking the min() of '1' and anything else is pointless.  Per the spec, the =
version
can never be 0.

  CPUID.(EAX=3D24H, ECX=3D00H):EBX[bits 7:0]  Reports the Intel AVX10 Conve=
rged Vector ISA version. Integer (=E2=89=A5 1)

And it's probably too late, but why on earth is there an AVX10 version numb=
er?
Version numbers are _awful_ for virtualization; see the constant vPMU probl=
ems
that arise from bundling things under a single version number..  Y'all carv=
ed out
room for sub-leafs, i.e. there's a ton of room for "discrete feature bits",=
 so
why oh why is there a version number?

> +		vector_support =3D entry->ebx & GENMASK(18, 16);

Please add proper defines somewhere, this this can be something like:

		/* EBX[7:0] hold the AVX10 version; KVM supports version '1'. */
		entry->eax =3D 0;
		entry->ebx =3D (entry->ebx & AVX10_VECTOR_SIZES_MASK) | 1;
		entry->ecx =3D 0;
		entry->edx =3D 0;

Or perhaps we should have feature bits for the vector sizes, because that's=
 really
what they are.  Mixing feature bits in with a version number makes for pain=
ful
code, but there's nothing KVM can do about that.  With proper features, thi=
s then
becomes something like:

		entry->eax =3D 0;
		cpuid_entry_override(entry, CPUID_24_0_EBX);
		/* EBX[7:0] hold the AVX10 version; KVM supports version '1'. */
		entry->ebx |=3D 1;
		entry->ecx =3D 0;
		entry->edx =3D 0;

