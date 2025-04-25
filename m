Return-Path: <kvm+bounces-44374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF2C6A9D62E
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 01:23:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6ED49A1511
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 23:23:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EBB4297A48;
	Fri, 25 Apr 2025 23:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Poums8hn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6541218821
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 23:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745623410; cv=none; b=WVesmwzY6HDhiczEP5Am+dQDrWP8FTkRWOBzLRqj5vzUqYxja7ZAwPaPzAqDmm2/d+wISW3EEB+SrKyf9CyagIoiResZ6EJ5/M6KoeMkJW1u/cdkALclhQu2HpycNhicSJuFGQHSdtAwexy/RBfzGt8xpR/Nx5ndesDZXxsBHPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745623410; c=relaxed/simple;
	bh=xRQfMP1XFOx9qITimYkGXWDvRrdKrkeHm+DJCoV+Prk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=feGT8oduWrP/ibANfYeWICeZN41WGufzUhjo7JzdNpgcFWTJ1N0W6znNQ5q7LG6J4hvq24t1l/QDcTdRiZkfFywO9wyAY13Nwtc3ydUvOvULQzNcwk4FO+SpqF5kriFZ1+2+/+p+Dwf8593uj7mVoQMNWkDi9h0OPsGYp5AZPdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Poums8hn; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2254e500a73so19642605ad.0
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 16:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745623408; x=1746228208; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ywngk5EyrH43CSmFrX2G8BVOihut64iaWtRXLrbOWSE=;
        b=Poums8hnsmcZsMIzFoYFHduhssn2oN/W2959doE6GOJ2ODHHIbeGgyOSuXdVOjGHIV
         lU0/KyA0kvl6YbdfVFwW9FmXg0JtgBQxo5Byo4UIzfTnPkJ2i7Amj+t7DpeYo99AtG+p
         bmuDz+hHdqEBEJl+Gt4kYdA2OBcXdcCK0dMc+AC9H0yy2ImcKTBAQykJszPyLujJWMDq
         s0K0xp9mHSYeULUQ8fXRupAakQtZydXEB3FzmDExMAU9MdZ9SuSuT6VmqaxgmTCG3bJ9
         /HC7EGhQpnKTGc2WIY8fGGQjlOYDTW/rVRps6UHgpIz5VwxTnpMXbs8wxglvxLiNHwcC
         R4dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745623408; x=1746228208;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ywngk5EyrH43CSmFrX2G8BVOihut64iaWtRXLrbOWSE=;
        b=Em3yKM0sCc3UbouLpL/434gnitE7JeTrjCatFVmqwL5Jc6T8R3/h8YBBb2X0naVDYY
         vxSv5bvUoUYgbZ7czyVKcxraaOe9zoqahCXk/vr4OBR1i8McwKeuWTfNiyDTQkDFM20p
         JJZEvrS9HK0EpYgd6XmCbbVsTvUOPCdvZfR1YxffQdYRTofC1mi8YDKhD8vkesnZisBU
         nJ/EZK2L5KBDm1RZb0HN7v8RTnJ3TDcC5Vu2rlDQfeWrkADqUv+iCnD973T4H0rtqGxC
         JWO5yiZ68BZRLGdy4uhPIS4abT/8plITenCNLkKC1pEtt86XsghUcDF/3KS1qrE3Gs63
         DIQg==
X-Forwarded-Encrypted: i=1; AJvYcCVMorXPYrgw9+zF/UxFvdhav/rZ5idWRL8P/dNJ5m36/SMenwLUqQ6jtAhT/TngfcLW4wk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9SejAuUOU4sBN5W4JLCy/4mQzaj/0Ys83t301IRQMXWon0DCz
	6xUxX3tW5YETamgETkmm6HFA9a0UV+985Vmuok5+H+aUCtqTpBbe/rG6cqBlQwIOHGn1cq3DwRM
	WqQ==
X-Google-Smtp-Source: AGHT+IHVxXK3XxZbeGt/u4CyqKrgiBasZXhRdDliozQ4/a+jP1h/kb8v1M5XZMgqEeCFii+UcH9HIfN932k=
X-Received: from plblf7.prod.google.com ([2002:a17:902:fb47:b0:220:ddee:5ee])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2ec7:b0:223:5945:ffd5
 with SMTP id d9443c01a7336-22dbf6409femr57525515ad.32.1745623408006; Fri, 25
 Apr 2025 16:23:28 -0700 (PDT)
Date: Fri, 25 Apr 2025 16:23:14 -0700
In-Reply-To: <ee1c08fc400bb574a2b8f2c6a0bd9def10a29d35.1744130533.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ee1c08fc400bb574a2b8f2c6a0bd9def10a29d35.1744130533.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.49.0.850.g28803427d3-goog
Message-ID: <174562166515.1002335.4837189500291274188.b4-ty@google.com>
Subject: Re: [PATCH] x86/cpufeatures: Define X86_FEATURE_PREFETCHI (AMD)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, pbonzini@redhat.com, 
	Babu Moger <babu.moger@amd.com>
Cc: x86@kernel.org, hpa@zytor.com, daniel.sneddon@linux.intel.com, 
	jpoimboe@kernel.org, pawan.kumar.gupta@linux.intel.com, 
	thomas.lendacky@amd.com, perry.yuan@amd.com, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 08 Apr 2025 17:57:09 -0500, Babu Moger wrote:
> The latest AMD platform has introduced a new instruction called PREFETCHI.
> This instruction loads a cache line from a specified memory address into
> the indicated data or instruction cache level, based on locality reference
> hints.
> 
> Feature bit definition:
> CPUID_Fn80000021_EAX [bit 20] - Indicates support for IC prefetch.
> 
> [...]

Applied to kvm-x86 misc, with a rewritten shortlog and changelog to make it super
clear this is KVM enabling.

[1/1] KVM: x86: Advertise support for AMD's PREFETCHI
      https://github.com/kvm-x86/linux/commit/d88bb2ded2ef

--
https://github.com/kvm-x86/linux/tree/next

