Return-Path: <kvm+bounces-47187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 186C7ABE6DC
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 00:25:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C320C4C6AC8
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 22:25:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E3F725F7A1;
	Tue, 20 May 2025 22:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2z2PAlc6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0868B25C818
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 22:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747779900; cv=none; b=hqBQvXrk9j+/vPE+DBwUUwY5W8rj/g+uwTYjM/ZMWMK2w/SnmvJMj7MeQEIoCANFbhiFnp5B+QBftfxN1KK3t/Ff81nECaUoKflkuwJ0VmC2u+EI5EKwAUetyEKrie4ayPKZ6xSet6VvehTJQMurfivIH2e65toaz5WlpIGTSO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747779900; c=relaxed/simple;
	bh=1fY4fCUL5YGMyXxzGQmGeHjD5qzIGXLa97k6xBFOGKI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JASfkmkI9URu0DkyCEVvBbfsM9M9a7sp17L9uRVlNm7VO8l+gT4Ji93OzbJn0Bj2G6c0o7cVFGP8MTw+guJNT3C5TSc7CO+9NZt88QmFX6nStkthlqWjAXBg8US9/rDEUeSHXXDdc4Q8o+XjmuZg7qnhkZeQKU92l1Od6oCGjQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2z2PAlc6; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30a39fa0765so9382515a91.3
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 15:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747779898; x=1748384698; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1fY4fCUL5YGMyXxzGQmGeHjD5qzIGXLa97k6xBFOGKI=;
        b=2z2PAlc6za43AYnxH7iJn0wSspkd9NxpKPXSiLKcnCYqJA7V3TvVu5be4rtKc33eFs
         2SsbaQi3dkU+vj2zJQ9ZKsIBeKhZmlamq+H2UaV1gHEV6wIu061dw4I83e958Tkb5JqD
         lrcIiTKxdsn+RU1FZURlYcbBctFFHohHGwmpbNeQU9oean3Dn1AsEXN0V+iA/HWbm+hy
         7Buhwm6IF3FdycWucIslr5jt0BmavqQt/IN1gOrMkTfMwsgbioinoiLO25oezbg3jkaR
         3AXZ6kt+9mVMMy7BYWDOmaWKqK/Pb6GhYxFtKft27vbN7i1ji2hpku6QugHXp/LBxNV6
         LIjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747779898; x=1748384698;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1fY4fCUL5YGMyXxzGQmGeHjD5qzIGXLa97k6xBFOGKI=;
        b=qj0ar5H/0r1uKXWhVPXpMQnscbf83dLauNyGwI+YGkKX/4k/s1Ho3sOfaYcNL0KPPU
         UjCVGt99XTgZph/sLDVRKPwYylEbiPa1uoJkfBR3zKUJFRlHBYI5dcXYDkLIRec0eia9
         8a6UvbVYGO8qZBd1dP9HRKICTsVHKRX7LhOh/EJIUePiJwvjHjJ4m/2GJxDK5mPur+DO
         8n57ScuvuQzjNDzG3f2BaZj9TIv7Uzcvo4Sjw54yQNCAXzzL5Ml/XSXaQBKtPOJwClXc
         W/aGFLOe7Gx1U0RfTn8QJ5nBk6wZP6xXo/x/AXbsAaac5i2+rZOUc8U+BL3FyigPzHkz
         FBXg==
X-Gm-Message-State: AOJu0Yz377tBlyEV1isllcuIi7h0ESx8Hhb0l1wayPViGUDxAnzQ+hqQ
	vp76JEtNAMTIHaSsLpqV9DBrLpmJo7iRc1EZ6TJsrTBg5Aaeo11NvE9iBYl3I+BFGUSilE0kO4S
	9hKGWLw==
X-Google-Smtp-Source: AGHT+IGaHyYJa+Rf++C/1dMkyjLd3cn1f3dzajoz2ypKpUcZvvvjQmY+fmHrkfp4/rpt1/V8H13Sg+zxMnc=
X-Received: from pjbsw15.prod.google.com ([2002:a17:90b:2c8f:b0:301:4260:4d23])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d888:b0:30e:823f:ef3c
 with SMTP id 98e67ed59e1d1-30e823ff09dmr29760229a91.25.1747779898326; Tue, 20
 May 2025 15:24:58 -0700 (PDT)
Date: Tue, 20 May 2025 15:24:56 -0700
In-Reply-To: <20250515005353.952707-4-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250515005353.952707-1-mlevitsk@redhat.com> <20250515005353.952707-4-mlevitsk@redhat.com>
Message-ID: <aC0BOJoXF45iCO9C@google.com>
Subject: Re: [PATCH v4 3/4] x86: nVMX: check vmcs12->guest_ia32_debugctl value
 given by L2
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	x86@kernel.org, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

"KVM: nVMX:" for the shortlog scope.

