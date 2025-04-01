Return-Path: <kvm+bounces-42330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4119CA77FBB
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:00:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A45DA3AED3C
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 15:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F20520E00A;
	Tue,  1 Apr 2025 15:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MR5rVmpw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67CC20CCFB
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 15:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523042; cv=none; b=Fr/GVNlv6HTrtLKNStf4L/hIJFPE8YyKnSOIFfokN+ldk5d9+8cG5TtGpj5zcW7kpbcmRtblKjNj/QEyGAm1Q8ZsXxuEa7F+b6ZeV8P3rVJL57cAoEYl0FhpJLWuPLDOil5UNYPqjdF1JCMEFJll4n0eH1wIPKIyEGChASD/B6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523042; c=relaxed/simple;
	bh=0ZZQsy5iR/tBBwSV2RsNwEBEpyYjNX9rkaOvEJOwHEo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IDtuMb38XO1jdf6Hkmfl+HEbxU1BEcVqKyMte1F8sE42fUGA5V316Lt9PwqD7cyk4Ku0pqE23o7FZ7DfGk7wRdlIHOhNMEc1tH6fTMv0KoekPnjeCCbqmY+ap896ZxbKLZPkNMjvuUagVAALVsStNP+Wsl6wUr9eLQc3ygZL7Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MR5rVmpw; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff581215f7so6529244a91.3
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 08:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743523040; x=1744127840; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qA3FLGTWw4iTy7QH63sW/7/WyR1uRH4cACOa/5NAWCI=;
        b=MR5rVmpwhfFU7Kk7zoQdF/DA7BYy8CS10sch71A0/6TPL43vYo0VWwoM/ZRTon0rci
         2N1wOvqVAe/mVqt9s5HPj8UJ2QqPQc8jMCAJ3wifadS3C88mQ5Rw/xzcl3OC4g6tX805
         Lx6ljp3SIYVYm/W0tH9ZyWdLtB6cimXdE86W5D0wGocMK8RTu4IXY3wEZ/94nb1yqaX7
         I+7GBBjtrR4h69qKA9JIDRf7TYYxao1/46lpx05/qLW14/yz/Lbx1Q4UQ9lVp4m+2SEm
         XMfNoD7qfov2HFIBfb4NzVa3bXzUfmbGQV2tzutopo4YQPnmDlzkOnAPdN+f/MXPqlEU
         vbxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523040; x=1744127840;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qA3FLGTWw4iTy7QH63sW/7/WyR1uRH4cACOa/5NAWCI=;
        b=LlSWhRb4eZ1cXOMaPmciHQauUJ2aZtG3nlEpPfc5jXjJGeSDim48CbzUUpMvugw5UE
         88E3Y824COT8HL+SCSuXlsfUPgxr0Vu09LDG7CiwDKMYpbBekzcFwUgBvHihXguquzo6
         bRRJlp1KKCLsRBXMAg09SE2uHGeo6PMgbkdtTy8Q5O5UhWsyqUhc4n+jWtIUvnbxzniz
         gJGTLVvp3vX3KsOAW70ynfeG9jwdcKgGlUg1N4N58j3+Gkk/0BapKJgvr+/w4/lzQdzo
         ySowfyJ+tbAV7J0omYzM8pGJ6ekDD7WJ04Yn8Z8K/c8+lbgimlH0bRE9+790VLeWv29a
         3ZTg==
X-Gm-Message-State: AOJu0YwpxSDmCFO5BnCOnJCcAFwJvN8YEnQJh0Nt/QfhtGkpImVnIciy
	fyOZ6ItRqD4WR1W0+bj3zMBia/bhRIufQqqXx3Q4vAF/n6Yzvxd0ApMq95UssFmGtlWQYjiIDQ5
	p8w==
X-Google-Smtp-Source: AGHT+IFfRx5K6oY4RAb5pZkeJwowkj1BgVmibF8BfPMQekfaCGm2fIiGn7Kg30MfKpJzguRbFKy2Jg4G68k=
X-Received: from pfbli7.prod.google.com ([2002:a05:6a00:7187:b0:736:a983:dc43])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:c889:b0:1f5:6c94:2cc1
 with SMTP id adf61e73a8af0-2009f640589mr24122182637.21.1743523040124; Tue, 01
 Apr 2025 08:57:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 08:57:13 -0700
In-Reply-To: <20250401155714.838398-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250401155714.838398-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250401155714.838398-3-seanjc@google.com>
Subject: [PATCH v2 2/3] KVM: x86: Allocate kvm_vmx/kvm_svm structures using kzalloc()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Now that the size of "struct kvm" is less than 2KiB, switch back to using
kzalloc() to allocate the VM structures.  Add compile-time assertions in
vendor code to ensure the size is an order-0 allocation, i.e. to prevent
unknowingly letting the size balloon in the future.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 2 +-
 arch/x86/kvm/svm/svm.c          | 1 +
 arch/x86/kvm/vmx/vmx.c          | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e523d7d8a107..6c7fd7db6f11 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1940,7 +1940,7 @@ void kvm_x86_vendor_exit(void);
 #define __KVM_HAVE_ARCH_VM_ALLOC
 static inline struct kvm *kvm_arch_alloc_vm(void)
 {
-	return __vmalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	return kzalloc(kvm_x86_ops.vm_size, GFP_KERNEL_ACCOUNT);
 }
 
 #define __KVM_HAVE_ARCH_VM_FREE
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8abeab91d329..589adc5f92e0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5536,6 +5536,7 @@ static int __init svm_init(void)
 	if (r)
 		goto err_kvm_init;
 
+	BUILD_BUG_ON(get_order(sizeof(struct kvm_svm) != 0));
 	return 0;
 
 err_kvm_init:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b70ed72c1783..01264842bf45 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8755,6 +8755,7 @@ static int __init vmx_init(void)
 	if (r)
 		goto err_kvm_init;
 
+	BUILD_BUG_ON(get_order(sizeof(struct kvm_vmx) != 0));
 	return 0;
 
 err_kvm_init:
-- 
2.49.0.472.ge94155a9ec-goog


