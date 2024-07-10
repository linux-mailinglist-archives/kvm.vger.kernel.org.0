Return-Path: <kvm+bounces-21390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CCD292DD06
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 01:47:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 095311F22E60
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 23:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF6AC16D4EE;
	Wed, 10 Jul 2024 23:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xxpa8ncT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f73.google.com (mail-ua1-f73.google.com [209.85.222.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B8616CD0E
	for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 23:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654976; cv=none; b=ZU7ekY8lR95V92sfNGksBRuHAuYm1Ku4pEWXRHaCAT5CldZgMZxotmIuw1piOUjHyDNuwq7lmg0kSRtEcJhAcAvYXIhnE+YSaNjJlU3NECq+A6NUAs3EOll1Ge2AKyLN86+KrGlcsWz6P46fcC9+L0I8zOLeT6z8+DmO31LaIYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654976; c=relaxed/simple;
	bh=8593VQW+qY6IG/jYYpHCncdh+HTnZZx/ZSFesd4ewL0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cJ1QfJ5QVvqtBZT6FJgj/WV+UmHq53XvN+zNoIOsBXB4NYMNpgPXIwt+hLIhUtBekgYCgI9CcmMG1n19vV7wRKl3qINBiSIcZe4OGde33wy4cfaaRIgstcYDLmtP0kEvFXqrM1aKSxpgtSXYhc629nREwmOQnShm7HFN4od64/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xxpa8ncT; arc=none smtp.client-ip=209.85.222.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-ua1-f73.google.com with SMTP id a1e0cc1a2514c-810549fde5fso65814241.2
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2024 16:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654974; x=1721259774; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KrWHeRDFVlfzCLm2guf0VTYM9h/W1rUjUnfwvHRBaDY=;
        b=Xxpa8ncTdgyuNQ996Gw0ta5/yYEut2AJIhDg3+yQwm/UPIA274rODqe0+bAvn++daV
         z7pi3hj55R3y+anqcc1egnqgM1VMRqWyqqUXTzM8b04EKorwb2qPzLgmC2S0VOer6rEM
         uvewnx3ThRcFoOhqtBy9P74tgDmnyIlu+hRI9NiGwBP3hx2dD1l2Kf4MkfoiA9nkMdmy
         b2EUeR3mUD+MdNVZ5jpEZ4S4W/XYdjha7U1FQuxb1YxTdERolyRmzr5+yCz8Y+9tXEO+
         jYEPOhQ6Xq/JHeaih7VRmfmZJsmkJdH122A6LrAUVw5ULn81szmZKaXUkiwNmeAhOaJH
         r09w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654974; x=1721259774;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KrWHeRDFVlfzCLm2guf0VTYM9h/W1rUjUnfwvHRBaDY=;
        b=ABmF5w5pV2bcZsKlUTtFZHi6OcEQhG/1JQIzMM4MogR+c6L2n7+efaAS46Yhv3jCCG
         iIeov+OfLa6zLtuB6Kq0fWgRkHqyiB2B6Q4IvmisSLGPra5VmIOwn8Nw4iZyIUFLwDdF
         Mj6VnX23od0QAMx+IxLEEAXGbFMdPrXB8cvS4dgy+6tRJQQvYa9CUvd3M+Ojv5Kl4rk2
         o8SIKwY7F0GpCdy4SFXiCrm+7yWwWdrMHPD6Wy4fi1bH0enY0T2rHhuK/dDQDrTBLpAf
         ZHL9o6kaz/3iTMDRYYZWIpGD2TgTJxtXTFAxqOjlCwGdq4gZzTZbzIQAkYrjrjgSseIh
         X9rQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVcMczCm0wj7LaxwzYN++3TMUl1pgPUJlcJ6QGQ5msN5M1uPJUYN30zoCchg4RmKEug8cVo2FrCslOxvlIvN7FWTy9
X-Gm-Message-State: AOJu0Yztu/6Pee5dxT6P3sifx5WLNW6CnZ5I4FRB/Nu5IhZ52zuL01cL
	0Z9Rv63Db72ot6/O2MPtwN7v8qCm/ul89au9lnnfUCR/XLOoA9C2AK6mXN7b/ts3ykfrwQOixUn
	xSdQJvMEzNQDQsOuz4A==
X-Google-Smtp-Source: AGHT+IEk1FL65vqiK6UE5KirHXI/3mEOw3BUqoQ0HFsCZaEXrmaSc1CqWM95u18pik8VbBJeKyVeyhW9FRI1OD+8
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6102:5490:b0:48d:89b6:85d2 with
 SMTP id ada2fe7eead31-49031dbea2dmr435474137.0.1720654973979; Wed, 10 Jul
 2024 16:42:53 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:20 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-17-jthoughton@google.com>
Subject: [RFC PATCH 16/18] KVM: Advertise KVM_CAP_USERFAULT in KVM_CHECK_EXTENSION
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Advertise support for KVM_CAP_USERFAULT when CONFIG_KVM_USERFAULT is
enabled.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 virt/kvm/kvm_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d2ca16ddcaa1..90ce6b8ff0ab 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4916,6 +4916,10 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 #ifdef CONFIG_KVM_PRIVATE_MEM
 	case KVM_CAP_GUEST_MEMFD:
 		return !kvm || kvm_arch_has_private_mem(kvm);
+#endif
+#ifdef CONFIG_KVM_USERFAULT
+	case KVM_CAP_USERFAULT:
+		return 1;
 #endif
 	default:
 		break;
-- 
2.45.2.993.g49e7a77208-goog


