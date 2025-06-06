Return-Path: <kvm+bounces-48672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CD12AD0859
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 20:56:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2207417ADD3
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 18:56:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3DCB1F3B91;
	Fri,  6 Jun 2025 18:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WZhHRuzc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA501D432D
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 18:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749236186; cv=none; b=d5vL5DurTMS3z90jkHvZ7RXjP+hC7ck8hr1DkEafGwGkbk5z9z5IStOHm3sDiuQBGeVxLW2cmQtjPIvfavuUTA+D7FN9V8+uWagkzYBJZ11PZr+E8XeY4yZ2FS/gCn20C7Bi98sS0kjnKFL54N77HSZkvIkMbNZXJGbvACLflFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749236186; c=relaxed/simple;
	bh=Lv8M8SJfFr3b41JpFYH00ihI/lyselj4x1KfCSp2bLo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y+GOjTIcaq+Ljz8CC1UXH5FegZNTkwGr2Ywes7J1fmlADkfBwVcmreN0sn7pGkHjlVJbsHNaYUsHu8hIbNfac7rTZGa8pSNjKjgCeF2Rnr3n0K7cPHkKd2hfwN1Ej6GZktlYSey2VCoo/iRJfTIti6ZTx0wGl0laxPw4MBKLMlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WZhHRuzc; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b26e0fee53eso1579119a12.1
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 11:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749236184; x=1749840984; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HpZlxNfQQcVcyA2xJgYAPilmDs6fYmkhiO+1JW8Md0U=;
        b=WZhHRuzcmufnrqzWGyNvaB018gA3rWUjZYjl0XMEVR74pzIvqjbxO8iEZMV0QILE5P
         lRahLzeBSyR+S8Dn7lSYd/F2syZCsXFEburwjnJGi21xq2IrkUBKzsiHTVoEn2qdjM2Y
         2Y7zF74aIi/fzTvDs5xOS7/6VYC4mfG0Fd7CKQJJ6vCY+BFNPNROibZvaQHp2pl+lndj
         r+gtHWUpE9Ey908zzT/rsH9Kq8LP5Ow5MeRyHHbrdURbJdisggaE1FcbIfUrS+kCf7Kc
         +fSoi241oHO31ti8PrJv5syvoswrr6GId2lcZI6Y8uO8Ar/ord43alKxCP3uHkv6++tr
         Lehw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749236184; x=1749840984;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HpZlxNfQQcVcyA2xJgYAPilmDs6fYmkhiO+1JW8Md0U=;
        b=tJ58Q8KAQscSkYjCpULNG1QMVtVFsJ3LZqzHjUgl3ibS0gFFOe5agYEQ3trM2Fsadl
         FWxZWVo6Lk5x6lWwWphegSGrh+juno0RwVQ8wC3wLjdQV0HXREzbQZawFX5uYG1dDXCw
         e9B1PP0Ib1MU61VPf9s/uICvVmVDpLKOc/85eXLyEo6Wuo8jQhuUpv3Q3/kMxQj7bkWg
         IBqxRGWGbQeiU3hqyGBol9pHI5911NGVex135BSzYd+s2Mis5aSK6aVS/ARC0UgTbotI
         I1InQkWhNNTGR5l5lLrGHaoHhpoI/VkpUYj1if+SF+ET7XId3mhgIAiWb9T+sb6wWVsA
         GdXg==
X-Forwarded-Encrypted: i=1; AJvYcCXslDUAZOE2pj0NMRE62tOAndOL7cckinBH5XAYyr0zyV9AWySEIbnQlGYYgZCfd9rfmAE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyuK4p5R3xzyIxQ/JWN7CbAKOCDyaAoZrCCvFOgS9+GGFDtKNQ
	lIypLdPwCzU/o7S6ESgL7Mnm9YTegZtIAl01gY3kwnckoitt2XRiUTup3oWTwlzvtIhmXSQdfhk
	PAv6Yxw==
X-Google-Smtp-Source: AGHT+IGqcoPYRkSjOcLS22pMmTmd9oUCkEfjRM6IzDAHp9YG5cvIGYKKgJc8IWu1CzorqLJUH+Aa5cN/Dnw=
X-Received: from pjd5.prod.google.com ([2002:a17:90b:54c5:b0:310:f76d:7b8d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c52:b0:312:1cd7:b337
 with SMTP id 98e67ed59e1d1-31346af99a1mr5984007a91.5.1749236184001; Fri, 06
 Jun 2025 11:56:24 -0700 (PDT)
Date: Fri, 6 Jun 2025 11:56:21 -0700
In-Reply-To: <aEM3rBrlxHMk6Mct@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
 <20250514071803.209166-8-Neeraj.Upadhyay@amd.com> <20250524121241.GKaDG3uWICZGPubp-k@fat_crate.local>
 <4dd45ddb-5faf-4766-b829-d7e10d3d805f@amd.com> <aEM3rBrlxHMk6Mct@google.com>
Message-ID: <aEM51U1RnYC0Dh_j@google.com>
Subject: Re: [RFC PATCH v6 07/32] KVM: x86: apic_test_vector() to common code
From: Sean Christopherson <seanjc@google.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com, 
	francescolavra.fl@gmail.com, tiala@microsoft.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 06, 2025, Sean Christopherson wrote:
> Actually, looking at the end usage, just drop VEC_POS/REG_POS entirely.  IIRC, I
> suggested keeping the shorthand versions for KVM, but I didn't realize there would
> literally be two helpers left.  At that point, keeping VEC_POS and REG_POS is
> pure stubborness :-)
> 
>  1. Rename VEC_POS/REG_POS => APIC_VECTOR_TO_BIT_NUMBER/APIC_VECTOR_TO_REG_OFFSET
>  2. Rename all of the KVM helpers you intend to move out of KVM.

Looking at the earlier patches again, I vote to add a 4th:

   2a. Replace all "char *" with "void *" in all affected helpers.

Pointer arithmetic for "void *" and "char *" operate identically, and AFAICT that's
the only reason why e.g. __kvm_lapic_set_reg64() takes a "char *".  That way there
is even less of a chance of doing the wrong thing, e.g. neglecting to cast and
reading a byte instead of the desired size.

>  3. Move all of the helpers out of KVM.

