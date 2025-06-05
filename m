Return-Path: <kvm+bounces-48605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3A73ACF85D
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:51:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BFBC3AFA0B
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C68027F72D;
	Thu,  5 Jun 2025 19:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WhqAjHeJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB9827E7C1
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 19:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749153028; cv=none; b=XE8xOiOQQ6kcUxIHQ9uAxwwVc8t66VzVwi824yeBqYcUULa/HuIFnVg10j7vk2iDBv0zf6WH4LrLkUNWJm0X083CkJ2b5Iau5j9seZ2CaWR5PF68YZuDST1Y3I+jltF4OOLOgP0w4v7msiZC3/cqX6hbxszKLfqTvw/VowubOYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749153028; c=relaxed/simple;
	bh=tl81ljfB6m8YEQiW9w1zLjezK6LB1wYGmVO0WO5cqpw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=l8Tq6X9tO3SZutoEiUyulMsRcVyfnMZN75uz8YSBK5nT8hKzbzQR7Vovt1gg0P9ljyYgGBNzCxg8sV39dqmmpfNZiSvE3YYffe4IQm63uLSw8jkMDr4RobTqrkFQ+Zb4F/pbi7wKeTnMi1Qp94HZiSIGhysT/TTalIGDNOKof0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WhqAjHeJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-312eaf676b3so1857812a91.3
        for <kvm@vger.kernel.org>; Thu, 05 Jun 2025 12:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749153026; x=1749757826; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cgrnOpyorI2GhVZsMGYu/YaMrQ323arhHY5WTGYiVCI=;
        b=WhqAjHeJZ60174zfRoBfnp6771s/VNB5m6Xx78FcSptRm4YOP2wjp0tOeC3NwkUEMN
         TCPgK1qHNX7D82uG0zo/PbGXEhhnEuiuUf9J5gDZmU4rgs81CZCLcLM+JQTWjJ52GHIs
         CZ1BNIPvvdPn4mVFjxXrLNR+CSANedzC+osCsKJaGhQfmYlTJjkksS1LDwdp1EU3RNAv
         HLsKzmR+hMnHEeBLrH6OgMpIqDNsaJl1o0maGa83ELZMCkZGSigq9y6DrTkHbzWqToJF
         mIPOnp1YIEaUrNtTOk3Ao3vey+HTNMJRS9DAUZYMngsEjCmgm8j7Fwf8aqZQsSUIU+8K
         P+Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749153026; x=1749757826;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cgrnOpyorI2GhVZsMGYu/YaMrQ323arhHY5WTGYiVCI=;
        b=ayJ04FTQDFC26CvnVkev8BCKjVK2h7M6+K1qI28KPwT0KPME4F1+QrkcSk9UlTdd18
         Luwhx06j+tDnPggZEp6D2zGd7WiKoH1yAwMqhmgxOch7GlZQBdoMlCLa/Hc3rtD8t36u
         3ZOWra8yFDaE3RlDjWBo5oExhV1/mCSyoE6/sHPoHauL/MauQFfaquBj8HigaVAr+tGC
         5HNCju/6IkcWR3U+0yCP3fI2F1fmuaVfvvM1CD+C7EJCASSlas+m4oa+wgpXa9yVdhVP
         l8ZG3amnFMugEzObXd3883NW/0dqSIwyYHbzVjqkOHyY/1FpWZLDcR9/uiPoUOwB+WmU
         7bzw==
X-Gm-Message-State: AOJu0Yzb/0qgWNKFru0gVl93ETAA4ELyh96YpWq2gwhG1hbWNFFjCgWU
	ab1W5fUmVsUSgOPGaTof7jDIioSyrs0LU2dCY88Ro1t72RrhOJwdtdzKbTXX+P8x7Ak4KCJV9HW
	T4iqHKg==
X-Google-Smtp-Source: AGHT+IEZob+J3u5Z2wcBpwf1N4gsPZ0uQKkkjBrhxp9Yl3Dih0oUARprTHpqEFsp7BJJHZ5reANLHpSk/Q0=
X-Received: from pjg16.prod.google.com ([2002:a17:90b:3f50:b0:30e:5bd5:880d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3fcb:b0:313:2b30:e7bb
 with SMTP id 98e67ed59e1d1-31347308dfamr1432898a91.15.1749153026536; Thu, 05
 Jun 2025 12:50:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  5 Jun 2025 12:50:16 -0700
In-Reply-To: <20250605195018.539901-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605195018.539901-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250605195018.539901-3-seanjc@google.com>
Subject: [PATCH 2/4] KVM: x86: WARN and reject KVM_RUN if vCPU's MP_STATE is SIPI_RECEIVED
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+c1cbaedc2613058d5194@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

WARN if KVM_RUN is reached with a vCPU's mp_state set to SIPI_RECEIVED, as
KVM no longer uses SIPI_RECEIVED internally, and should morph SIPI_RECEIVED
into INIT_RECEIVED with a pending SIPI if userspace forces SIPI_RECEIVED.

See commit 66450a21f996 ("KVM: x86: Rework INIT and SIPI handling") for
more history and details.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7e3ab297a1bf..c3cbcd9e39f6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11547,6 +11547,20 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 	trace_kvm_fpu(0);
 }
 
+static int kvm_x86_vcpu_pre_run(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * SIPI_RECEIVED is obsolete; KVM leaves the vCPU in Wait-For-SIPI and
+	 * tracks the pending SIPI separately.  SIPI_RECEIVED is still accepted
+	 * by KVM_SET_VCPU_EVENTS for backwards compatibility, but should be
+	 * converted to INIT_RECEIVED.
+	 */
+	if (WARN_ON_ONCE(vcpu->arch.mp_state == KVM_MP_STATE_SIPI_RECEIVED))
+		return -EINVAL;
+
+	return kvm_x86_call(vcpu_pre_run)(vcpu);
+}
+
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 {
 	struct kvm_queued_exception *ex = &vcpu->arch.exception;
@@ -11649,7 +11663,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		goto out;
 	}
 
-	r = kvm_x86_call(vcpu_pre_run)(vcpu);
+	r = kvm_x86_vcpu_pre_run(vcpu);
 	if (r <= 0)
 		goto out;
 
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


