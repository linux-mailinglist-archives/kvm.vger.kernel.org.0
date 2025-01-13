Return-Path: <kvm+bounces-35320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB69FA0C24C
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 21:02:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E54D3A6966
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 20:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E00A11CD21E;
	Mon, 13 Jan 2025 20:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uM2dseJ4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E6424022B
	for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 20:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736798543; cv=none; b=qtU2XfS7kwLuCs/3HZ4wXdEqoc/Ifa3NlU83NGyACKYAffWgY2LSSegMmrKX4fwlKCH7NGriVwMAOwfWgxzwNAIW2K3CpYZr5YrFtHMtMgjKn5YUK8OEXNjwMHjLSvLNQJ0xQl6VwfVK9ubuNgHlmwiqQNx/C+vIGkKePccnIWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736798543; c=relaxed/simple;
	bh=y5ufo5HJPFN2RcwMCC8eOXrwkfbixM9+exZ8kXK1s1I=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=U3wFKVB8i21tPvGErsJ8XX/I0b/si9/u/8+mSLLMbeOf7p/VVrgj61GbRmyEINZNCtx9dSH54An+Hh+ZSmT6h26i0Z2YF+2vM5hTn3NaOfOIgKam1euptIKIS4xstvhORVkROnSShXq3zSUQHWtqfY4PALaOCSrP2nVp5yJN8Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uM2dseJ4; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef775ec883so7973113a91.1
        for <kvm@vger.kernel.org>; Mon, 13 Jan 2025 12:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736798541; x=1737403341; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9Wq7rUaX+FmJEL8OIfxyxBlZUI1BbsVMQOwmExtNi8Y=;
        b=uM2dseJ4E4g8X+7xQmmJOO5ho0xTvuv10h+kXS5PjGpSHCVQDqDjbrgnXtn93CEGF7
         tHlsPlySA0BjciqlHGqxLbFFcU0JmHAq3P2kPkPi5WLIJTABoD2CZgqV1UWjoFgdp73L
         /X0wn1KNw7tdMnk2LPoiWKDg+VC+S+S7y8ZR0E5rd5jZMIR9Y7la5yXhTnHd/XjtwBFB
         ql0dxjkgx6+W1kYsbD8a90lKU85kw0jXvQvAoodPt50cinHjvsUmgFPxDO5S5iV6GmE4
         oTpLjkCcpQ05m66SFoBY1gonpmQZ5GfIjSN6Xa8Gg1Qlk2HkhNch1Doe28i/X2gQ8YSB
         3MbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736798541; x=1737403341;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9Wq7rUaX+FmJEL8OIfxyxBlZUI1BbsVMQOwmExtNi8Y=;
        b=kdwt31ttUhDpOExUMH5TvelH8MUgaAhtAUMuiSm6kD5A5mmscl4o5RenZtJNiejgkI
         yB/zqd1isJXtGybDI9FAwrRwcxP3hJs2Et7Q/GEObc7CMczFiN9ScZ/UP9Fu8v7W075d
         qRzAVThGJ8HQsHtFBFo+rMCJq0sSuKRpobKlba63az6vpDtQSrH3aiYKl9Vi/SxY9il7
         f1UdDxEiYFuQKeLxnWsqH5YUakyjvZRF5k3hQsCXxi9tFtZzOY3gTjarf0qYUFtkAzlT
         uACwuMClgefBw7LzmMCgyZSIv/kklQRAEBBUeVEjWnAKHsTufl9vCTRGRnk/aB7dyDgT
         C2eg==
X-Forwarded-Encrypted: i=1; AJvYcCU94q9dPTCwWaC2akllPXGVu/hPoSxD8iMvu8YEIZOkqvLVaOLT9A/BpKel1W2bOpPyBjI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyF/p9rH2sCTTIgrOOkzu80UGqGhfqZC5FxMdPWpKp20z+tblAY
	ttRo2pjcHDXXYoH+f/Ek1EFykOPKJTYCILeFD86OKbeezfnjulIbmVLmrTkadcUsILIm69rqZ8s
	5rfin7VRPlw==
X-Google-Smtp-Source: AGHT+IHknmOdDkMDC0vWFmWT1WpIm3FNInlrqrNGIXliKpG3nITNEmkcvNSS1l/byi3F2HubUmveqs9c8P2TeA==
X-Received: from pjbsg17.prod.google.com ([2002:a17:90b:5211:b0:2e2:8d64:6213])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1f85:b0:2f2:a796:26b with SMTP id 98e67ed59e1d1-2f548f103d2mr29111660a91.1.1736798541092;
 Mon, 13 Jan 2025 12:02:21 -0800 (PST)
Date: Mon, 13 Jan 2025 12:01:42 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.688.g23fc6f90ad-goog
Message-ID: <20250113200150.487409-1-jmattson@google.com>
Subject: [PATCH 0/2] KVM: x86: Clean up MP_STATE transitions
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>, 
	Gleb Natapov <gleb@redhat.com>, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>, 
	Suzuki Poulose <suzuki@in.ibm.com>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, 
	Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Introduce a generic setter, kvm_set_mp_state(), and use that to ensure that
pv_unhalted is cleared on all transitions to KVM_MP_STATE_RUNNABLE.

Jim Mattson (2):
  KVM: x86: Introduce kvm_set_mp_state()
  KVM: x86: Clear pv_unhalted on all transitions to
    KVM_MP_STATE_RUNNABLE

 arch/x86/kvm/lapic.c      |  6 +++---
 arch/x86/kvm/svm/nested.c |  2 +-
 arch/x86/kvm/svm/sev.c    |  5 ++---
 arch/x86/kvm/vmx/nested.c |  4 ++--
 arch/x86/kvm/x86.c        | 18 ++++++++----------
 arch/x86/kvm/x86.h        |  7 +++++++
 arch/x86/kvm/xen.c        |  4 ++--
 7 files changed, 25 insertions(+), 21 deletions(-)


base-commit: c45323b7560ec87c37c729b703c86ee65f136d75
-- 
2.47.1.688.g23fc6f90ad-goog


