Return-Path: <kvm+bounces-47162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D57EEABE118
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 18:49:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 117873BBBF2
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 16:48:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 062742701B6;
	Tue, 20 May 2025 16:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ld+qggO7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A6A2571AA
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 16:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747759711; cv=none; b=pgXG6Rm89B/MHdgM/sHbFkwO3Nl2Po6mJUWXeh/JW3X1yFFU1zMsgcsj52EG12dwjDt2Lsucv1XGhvfxRSYJYln7Ky7JMJXC/cwDtv3u8zT5ePi4hHSCME2lx6UpfGNrG8qbB4Q4mnCJ5sgZ6VMxnjJ0CXiOCRWeLqUefiXuIfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747759711; c=relaxed/simple;
	bh=KlV0RXmqKpJ77CyyCsB0Wo5O3FyVrt7eDZrhGXiZPok=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RrVHmPFqisaHnq+sGIMze9flbiHGKwCx+O6f4lwNXvEcKJlP7pdYpTaS12t0ykRjBCKlH4DYSjAUaj88Su9Y8WSjFKECB36XiPExr+4K5bhDxKUAmhJxy9GOv+7gSs+xDtM5wRg3OeSs9deHmKqIogMam9Ge1QD6YrKeYcd1X8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ld+qggO7; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b0f807421c9so3503565a12.0
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 09:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747759709; x=1748364509; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KuJYydDReX9RTl05bbdXTXs3Odmmz9RsQYChmIkMKX8=;
        b=ld+qggO7zrvfVgzUjwUWUm05Ba+/1u05BO5SrY7ZMAtt+3eXXv6/x62NiTqaRggIOI
         FViM+a2VIZhMrWy/nhZ6N2XjRzRyJbe0f3Ks29crwYDZZ1WmEoDZO0kJmYRVQoafukR4
         dFb/lySmEOD3PPWNiD+kxUqL3P9P/HZ7Pucq0qdyHsET9j/bjz5lJWMWb/PDOHXA5EHQ
         Ikf5rWpMHBw0D7G7dER15/IKjUdJhBbfrxr8in8Z+/mVGgB943synN359wAGQy4kk5jA
         HAaSt/y1OE1fn/Vj2hx4jFayT01i8SDDgn8SsOxN4xhfYpzkjD+9MFqqxtRBBUKS0Rrv
         WXyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747759709; x=1748364509;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KuJYydDReX9RTl05bbdXTXs3Odmmz9RsQYChmIkMKX8=;
        b=n6AtkoXzFFaAPUhKPWOEjN8h51SrqcXPWcp/5fAtHX+hvw9nDo32DEL2SFYGCqhFSU
         wTQy95GK9fNGxaEMC0MqI/JupASLww7S5j1oAQ23HT8sG4aAZPiaj0bH6IU4wRyINNnw
         7LrjLTFYIl8bZljo5xgakfivLVF7gAhxMbO+zwfaKX8sk+wMfT2fosorDhvfq3Ea2rpl
         IApKaqHoN6lZN9ELdxF5LRptowtyd40mPkmhFkpqqj0PVs1qZtEotxNkFkFzn+YvbcpF
         iGK1jxM1Z0Fq0VoXnGPqMEFe1dvlmQ+c0OdwzgeezTGE3yTu02BDnZ298iVqiwN56rvz
         4HwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVFsdDxlA6CDeXYzqRWxfcvIO4Mu4afokT9VkvVTIa5Sx7eNdslh7I8odqU62ehq7YoRx4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzl958K1TZ27pyikpcpW19932fnJPqPZmKzQ5gWUmelOtq3TYjK
	VTbCN6a6BTRa/d4PMBovi268CWKLDY2GzpQiZLi7xyKKjNaUiAxf1tGkpj98QfkTO/73P5Zf//t
	GfON3FQ==
X-Google-Smtp-Source: AGHT+IEGFK1iHgjNql7Jg32erSL4VFEPnjrseOMCWC27oDhyRo6xkoj3Gu6mn3PMHwbhO+N/ywLOodNSFGQ=
X-Received: from pjbpl16.prod.google.com ([2002:a17:90b:2690:b0:30e:7003:7604])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3846:b0:2ff:6788:cc67
 with SMTP id 98e67ed59e1d1-30e7d5ceeb4mr22007339a91.34.1747759709435; Tue, 20
 May 2025 09:48:29 -0700 (PDT)
Date: Tue, 20 May 2025 09:48:08 -0700
In-Reply-To: <20250502050346.14274-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250502050346.14274-1-manali.shukla@amd.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <174742194085.2506614.18155306395568716918.b4-ty@google.com>
Subject: Re: [PATCH v5 0/5] Add support for the Bus Lock Threshold
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Manali Shukla <manali.shukla@amd.com>
Cc: pbonzini@redhat.com, nikunj@amd.com, bp@alien8.de
Content-Type: text/plain; charset="utf-8"

On Fri, 02 May 2025 05:03:41 +0000, Manali Shukla wrote:
> Misbehaving guests can cause bus locks to degrade the performance of
> a system. Non-WB (write-back) and misaligned locked RMW (read-modify-write)
> instructions are referred to as "bus locks" and require system wide
> synchronization among all processors to guarantee the atomicity. The bus
> locks can impose notable performance penalties for all processors within
> the system.
> 
> [...]

Applied to kvm-x86 svm, with a heavily modified test, and the comment typo fix
for patch 4.

[1/5] KVM: x86: Make kvm_pio_request.linear_rip a common field for user exits
      https://github.com/kvm-x86/linux/commit/e9628b011bbd
[2/5] x86/cpufeatures: Add CPUID feature bit for the Bus Lock Threshold
      https://github.com/kvm-x86/linux/commit/faad6645e112
[3/5] KVM: SVM: Add architectural definitions/assets for Bus Lock Threshold
      https://github.com/kvm-x86/linux/commit/827547bc3a2a
[4/5] KVM: SVM: Add support for KVM_CAP_X86_BUS_LOCK_EXIT on SVM CPUs
      https://github.com/kvm-x86/linux/commit/89f9edf4c69d
[5/5] KVM: selftests: Add test to verify KVM_CAP_X86_BUS_LOCK_EXIT
      https://github.com/kvm-x86/linux/commit/72df72e1c6dd

--
https://github.com/kvm-x86/linux/tree/next

