Return-Path: <kvm+bounces-41570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 50B2EA6A893
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 15:32:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6952188BE0E
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 14:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 679EF226183;
	Thu, 20 Mar 2025 14:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3AG9xUgc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331722253FD
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 14:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742480431; cv=none; b=tiwsd6HK61JZp9CQ3ZmuKFnaWOonwEHA+eBnA/3R15/XPuTHhUjNnH7ENZa3FFube91Zt1IMgjSu/aGzbZTy9q8QgQd0mjIgInJpOpfPA13QqDFiZRH08vhjRfNvBqYM4DnZsON64vmJ7n1R/W8gjr6oSkeD4bJpzDWP8VmObP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742480431; c=relaxed/simple;
	bh=Il0oi8W0P1a3TdzcT4YRMppA6PiszW9iVacc6BETtEU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EiXBfeUxjf56+SuauGGr6g1GKEoFLaP3vbNXYzKlrmO2H1l8hcfhH06gtfU1nAXAJ4V3kcvjy4213KKTsjAJNpOPo50S0lO0F2X9ml4oFyt8Sqsv26KVFo8hRIUY//rgN+18q/M3+R6/LphL3C08tlyA5LGuisPWuxB4gyvBGZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3AG9xUgc; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff7cf599beso2037419a91.0
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 07:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1742480429; x=1743085229; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qmMYNbiE7NCmjn3AfFSyN2d7EeiAyZE9x1WOdP/HlBU=;
        b=3AG9xUgc3lGd6Pprwr5yr5yEN1mF7TejSfjEUZ/gzhImLPe8OsrvWOCIAtz4MDuiJn
         CwyQTTwYdjpSjPRJPcpsIt2EnuaU/4l4959u0cEwtvQaewkwDAmej+tCF55jGUiJ+vjL
         ldgcB+C4f1ddKuFBxU0tIZjIHBZ+c86EKWQjss74HgXc1lbOJc2EQFDL6Nv6YTyhLxsa
         cJG8PUfyhhvQ7h2FXFS1KVCl0NVZ+EQFeadT25obuVL9vLe8+LrfUkYMN5a+fKRMNzQR
         /EAqe5WJY+VCqok6IhnApi+JY/KQN6K9LIO5jsp6uv0xPMGDczTOjlGJ7MdMGYroquI3
         zbeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742480429; x=1743085229;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qmMYNbiE7NCmjn3AfFSyN2d7EeiAyZE9x1WOdP/HlBU=;
        b=fDL13WBGfFlre2OPpAEvSrs4NihjXHy2cLJ1CsFYPHzOt8n4YINT8j96kVcL37UVAy
         bJi6YmzKtj88fFXs0niqefG5BkTXnfnEXFkohxqGSLN0MvoWRIpZKxKwt1eUU2lkN7yq
         S6bOdk9SV2/jfJC3Zq9GuFTo7qzjuT/FW0jQWZoZFoYEdBAfx+zgXDzIXXW8IN6DPP+9
         FuQ/4MExeGvUn9jTezjgVBJKToYWLyPpZB7ledtH/eeq7HTYoQDT2KGPKP55n6diPAbH
         jP0EW6L73HM0u/sH9N8Y1l7q1EhhS0FhYZ7TvfcCr5cTkjGWLp8Ci+HrnO8QOL9Dr5QH
         PkTA==
X-Gm-Message-State: AOJu0Yxh4CXGtetOixF8wizhB9w3+ymcfbKZ7mogsfWq6+nkbcq26Cj/
	HQdD5Ns9LvvjF45TKXFiuvcKhtYvkzCLzLUba9+/kBou4YuP1XWNd0RTbjNqt5ICP8mPgy6zdoT
	Rww==
X-Google-Smtp-Source: AGHT+IE+kfb1HoHRnQ267XvStqDZApTqRyoY0YWXiW9OB48WA4CtrHH/pA04OI5VxdB4Gu95vkhQH/SyzBw=
X-Received: from pjur8.prod.google.com ([2002:a17:90a:d408:b0:2fa:b84:b308])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f84:b0:2fe:8c08:88c6
 with SMTP id 98e67ed59e1d1-301bde53e35mr11107321a91.7.1742480429675; Thu, 20
 Mar 2025 07:20:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 20 Mar 2025 07:20:22 -0700
In-Reply-To: <20250320142022.766201-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250320142022.766201-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250320142022.766201-4-seanjc@google.com>
Subject: [PATCH v2 3/3] KVM: x86: Add a module param to control and enumerate
 device posted IRQs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"

Add a module param to allow disabling device posted interrupts without
having to sacrifice all of APICv/AVIC, and to also effectively enumerate
to userspace whether or not KVM may be utilizing device posted IRQs.
Disabling device posted interrupts is very desirable for testing, and can
even be desirable for production environments, e.g. if the host kernel
wants to interpose on device interrupts.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/x86.c              | 9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d881e7d276b1..bf11c5ee50cb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1922,6 +1922,7 @@ struct kvm_arch_async_pf {
 extern u32 __read_mostly kvm_nr_uret_msrs;
 extern bool __read_mostly allow_smaller_maxphyaddr;
 extern bool __read_mostly enable_apicv;
+extern bool __read_mostly enable_device_posted_irqs;
 extern struct kvm_x86_ops kvm_x86_ops;
 
 #define kvm_x86_call(func) static_call(kvm_x86_##func)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f76d655dc9a8..e7eb2198db26 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -227,6 +227,10 @@ EXPORT_SYMBOL_GPL(allow_smaller_maxphyaddr);
 bool __read_mostly enable_apicv = true;
 EXPORT_SYMBOL_GPL(enable_apicv);
 
+bool __read_mostly enable_device_posted_irqs = true;
+module_param(enable_device_posted_irqs, bool, 0444);
+EXPORT_SYMBOL_GPL(enable_device_posted_irqs);
+
 const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
 	KVM_GENERIC_VM_STATS(),
 	STATS_DESC_COUNTER(VM, mmu_shadow_zapped),
@@ -9772,6 +9776,9 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (r != 0)
 		goto out_mmu_exit;
 
+	enable_device_posted_irqs &= enable_apicv &&
+				     irq_remapping_cap(IRQ_POSTING_CAP);
+
 	kvm_ops_update(ops);
 
 	for_each_online_cpu(cpu) {
@@ -13552,7 +13559,7 @@ EXPORT_SYMBOL_GPL(kvm_arch_has_noncoherent_dma);
 
 bool kvm_arch_has_irq_bypass(void)
 {
-	return enable_apicv && irq_remapping_cap(IRQ_POSTING_CAP);
+	return enable_device_posted_irqs;
 }
 EXPORT_SYMBOL_GPL(kvm_arch_has_irq_bypass);
 
-- 
2.49.0.395.g12beb8f557-goog


