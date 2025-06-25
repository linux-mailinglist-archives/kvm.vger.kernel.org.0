Return-Path: <kvm+bounces-50692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF394AE8586
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 16:04:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CC1B16D8DB
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 14:03:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A84B5264613;
	Wed, 25 Jun 2025 14:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="T8Fk7up+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8888625DD15
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 14:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750860201; cv=none; b=msu67f6DIncDJnDSw2DW7UPVkUWhZHtoEoIHFMDpax0/MQ01nrXXsu/5R4VYkmawYiytu8725QaHkus1I7U1hsCR4K7raWBxgdRe2Ss6nJK4zJQNRyZ8iSwbWddBNm9amYEa39ToEoFAx5py/YRhAYRQaGDI32PJ7bV/L562KiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750860201; c=relaxed/simple;
	bh=oSn8aYDBwOVsGZBtcp8W1lJNZEOJOPKnDHPf7p7wKzE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=usJGclzQIt1/NMuCX15Td/N7vFdRSQt4bjBphrukFTZ81P3rYD4kHkfWqoPsKB+y5NrB3yRulnVHAT1gyeMlVHxV2Vfago906PX8kgAs3iY76RSAFMEjigQmy53ubiBSc+tNcZnnt5f8FYThdoL2ARfPVfDxn2i5vJ2zWLnn0c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=T8Fk7up+; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-234a102faa3so13028485ad.0
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 07:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750860200; x=1751465000; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3YRJII8pCdLW2ImwCfhoApg2mNV52pabTRz+63LafFc=;
        b=T8Fk7up+RiT3gfkU5V1yucoM288t4F7ZkCzFvjz2lGGQO49TdoSUw3fZ5QPWIpdrlQ
         YbKf6jVnYRlJumWl2ENL1BmV4C3g3uiuVfMaGC6zA0NtN2DC6wVqWHmec6NnJZE18eWC
         OSvBrM80hguqT6J3sUF3nczxjjs+YqufWAUXa5jOz1OC2HZkwbKgZYR+LmCXNba4yLLx
         D6XokNn8kqrJCF5xImnypOJMvYtSrOVvl954w2TpjlMdpgXy/8RwKDhwzcsXBuDRPf+A
         yE6SlkhrK66+fyAlr550yhe0FHrLUVhnpNg0nx8Sjht3Y3Edu62bFbja98imORXLlyND
         eLQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750860200; x=1751465000;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3YRJII8pCdLW2ImwCfhoApg2mNV52pabTRz+63LafFc=;
        b=cY/0ELm9WcEGBaftb+pM6IFChaL9tsAY7IjMUl+ahugFqgQfChEB8g4k0c8bX63tTS
         4NzRH071v+EUzgD/4w5Cq18VqMEJWYzov6EcQc1J1ES5mlHpQw0t3Z5nFgq13uzlU1Dd
         YNeAh3eZ96/BRMZMm0vj3uRK3Et5Edm4lJ4oLVUpqnnSIO1wbULfebVnU73lbPWLE2pn
         xFMBitZe7GSIYRwDT5C0v/W9Offga2HEma5fB0uhJezZidMCZRkf/iN1jV/5pzWfrkoN
         zz64VR2NsyRijNlHDYiJAqtBUcfgbIhzND1WtAVxYxeQu8fCW7Zlf5+lz1PiqBv2Szes
         dt6g==
X-Forwarded-Encrypted: i=1; AJvYcCVr9psEl5vi1ahy5jMdjNhVe7+dRmO9LH604Yis1K62ihilrN8SPHYimrfZXp10Riew/PM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwqPcyFk8ZQ7LucdqBBj3ea8O3Y+ho2oTFJNnGpCkKAh1iOW975
	GhyPz2ugBc4xSJX8f9CuVTazTEF8EAR9ZjLBKYV40mPrHLDThV5p/BywO1fU5twDw9HGJLS8ZUI
	EkRE2fw==
X-Google-Smtp-Source: AGHT+IFRtZBV4HtJQNLgaZY/PncR/dkJpNjxC1l7beeBFFZHiTSO5jkDC7b1biZ3vWvgDQjI6sqkJMk8vqg=
X-Received: from plble7.prod.google.com ([2002:a17:902:fb07:b0:235:85e:1fac])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:41c3:b0:234:a66d:cce5
 with SMTP id d9443c01a7336-2382407fdf9mr55258965ad.46.1750860199804; Wed, 25
 Jun 2025 07:03:19 -0700 (PDT)
Date: Wed, 25 Jun 2025 07:03:18 -0700
In-Reply-To: <20250610175424.209796-13-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com> <20250610175424.209796-13-Neeraj.Upadhyay@amd.com>
Message-ID: <aFwBpmO3OSCsAEOx@google.com>
Subject: Re: [RFC PATCH v7 12/37] x86/apic: KVM: Move lapic get/set_reg()
 helpers to common code
From: Sean Christopherson <seanjc@google.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com, 
	francescolavra.fl@gmail.com, tiala@microsoft.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 10, 2025, Neeraj Upadhyay wrote:
> Move the apic_get_reg() and apic_set_reg() helper functions to
> apic.h in order to reuse them in the Secure AVIC guest apic driver
> in later patches to read/write 32-bit registers from/to the APIC
> backing page.

Please squash this with the next patch that moves apic_{g,s}et_reg64().  Calling
out the need to access 32-bit registers is weird and confusing, and gives the
impression that the kernel doesn't need the 64-bit accessors, which is obviously
not true.

