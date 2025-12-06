Return-Path: <kvm+bounces-65455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 39543CA9D19
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 02:13:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 9D5BF302349D
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 01:12:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ABA52C15A5;
	Sat,  6 Dec 2025 01:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lodkx/V+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03EC285073
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 01:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764983483; cv=none; b=jyoJ1qhgBky55E9zmoJZxR6LCi+hH9TC3Nk4GmPKHbdouYl4Fr4zsWToWrhVeO7pq2kT62SKv3mzbgNwoCEjkM9AOZawCx82+p10ScSu7nm1GU7xxwjeco7k9y5d5L05tck+Q+q2Y7+ryQt80a+qa7hBwqNzHs8I6s0co8Nv+kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764983483; c=relaxed/simple;
	bh=bkTcXhbD0K+GaH8lROgSlwAp7KEAKH17Wyu0+TXtIrs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CauT94yT99TuYIgBeuVrrbuF3gqJ9jKCKnT9wuDwauzPAuDbSCgNUfjXp18ArwutRQ5VOzKL3fiWEc0BzA2yfmkPbzlo1t/qE0idwZ9prGcKmfqCWUq7u+rAqZ+BcHL+e1XDUZyd/1FpWcKoYtPA21j6SLKLKPeEYuNIX3l0b7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lodkx/V+; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3418ad76023so4790295a91.0
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 17:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764983481; x=1765588281; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=VkOwSpZnzzGFCGAjywqik6ZsByr3pLNa/lziUDNxQoA=;
        b=lodkx/V+B/DOn30DfIr1aL1Hq8F2dbs8/M5TEUWJMw+Mgdj5ABSjt7nePgtZqwoSyx
         w2F7tZXrHsDL9O4MDxZ7lWtsEltBbCS7oV+AahT1jzO6Yofz32I9YGhvLtfSkckgKkCX
         V5xV75qyWSGsEUrOJw2dGGTSw4NhCMTqnp54qIF0Ee8pXcHM+M83xig7l+q2I26clfdy
         DFu011FY/c4LwtgcCbXKxr5xR/9ojL6mQjGM1uV87g2LFwiQ433lvTmorknsdlsD7HyR
         TNx/ChM00ROaPYVYwAI2faKHJarbrCOwKElxYxxmyRWtcqtLHDC8jaUNQlDRlFoeLIh/
         ioDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764983481; x=1765588281;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VkOwSpZnzzGFCGAjywqik6ZsByr3pLNa/lziUDNxQoA=;
        b=SXSH7oY8cOl1YHdinlTm7mMd2bvVKTA8dAWf4vSefWUMbol2Ohe7TCPzbtTcW+yL49
         vQSRX+/jWXN6NICIRkm8TZtIVvnuySoi8WgSwC/fz0HI0BrXafWlI5ayfn9IcvtK1yBj
         kg990QOPWiOoQytDR5ATjDNNOn0v1VPQSfI3PO90ZTmxrSIoZIikmODrPdxzDaXxnHaw
         dpmUxXG6j+z0TbdVBk/6qSQ87Ms1WqvASHbB7jBWxOSe8F8haX8cgR8DpOt+lkO/BYoZ
         rla/q6EeYswVfY+cddVGPDuCSbtWPwp4LsUv5Rh+yJLEG/DtCxyCodgod9TtCDS9jXuv
         swNA==
X-Forwarded-Encrypted: i=1; AJvYcCXFBUESm9Injwg6AYkS9x9AtinnxflEUKCDEJzNcMxiUb7iR5Rr3AcUYkcP0OgedWZAcgE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYfIpS50538ea4KqIO2GNVntYxIop9yYi93wKd72W193BAYOmo
	RmC2+nuzp/c1jOn9pF0ekC/4eWpEc55B/Gnk/ubyExV030AP4PsY0c4YXjWrOutuvs28ycBQQw6
	+kjo/9g==
X-Google-Smtp-Source: AGHT+IFWR4uQiL6EU4wkVoYXTg3vRHDDsenTnV3mWzHCmctEhaBhx5JH5zxDIa3kq4f+/zZVRo4jq1+s238=
X-Received: from pjbin12.prod.google.com ([2002:a17:90b:438c:b0:33f:e888:4aad])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ecd:b0:340:a1a8:eb87
 with SMTP id 98e67ed59e1d1-349a260d6b8mr829195a91.35.1764983481038; Fri, 05
 Dec 2025 17:11:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 17:10:54 -0800
In-Reply-To: <20251206011054.494190-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206011054.494190-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206011054.494190-8-seanjc@google.com>
Subject: [PATCH v2 7/7] KVM: Bury kvm_{en,dis}able_virtualization() in
 kvm_main.c once more
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"

Now that TDX handles doing VMXON without KVM's involvement, bury the
top-level APIs to enable and disable virtualization back in kvm_main.c.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h |  8 --------
 virt/kvm/kvm_main.c      | 17 +++++++++++++----
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a453fe6ce05a..ac9332104793 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2596,12 +2596,4 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 				    struct kvm_pre_fault_memory *range);
 #endif
 
-#ifdef CONFIG_KVM_GENERIC_HARDWARE_ENABLING
-int kvm_enable_virtualization(void);
-void kvm_disable_virtualization(void);
-#else
-static inline int kvm_enable_virtualization(void) { return 0; }
-static inline void kvm_disable_virtualization(void) { }
-#endif
-
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3278ee9381bd..ac2633e9cd80 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1111,6 +1111,9 @@ static inline struct kvm_io_bus *kvm_get_bus_for_destruction(struct kvm *kvm,
 					 !refcount_read(&kvm->users_count));
 }
 
+static int kvm_enable_virtualization(void);
+static void kvm_disable_virtualization(void);
+
 static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 {
 	struct kvm *kvm = kvm_arch_alloc_vm();
@@ -5693,7 +5696,7 @@ static struct syscore_ops kvm_syscore_ops = {
 	.shutdown = kvm_shutdown,
 };
 
-int kvm_enable_virtualization(void)
+static int kvm_enable_virtualization(void)
 {
 	int r;
 
@@ -5738,9 +5741,8 @@ int kvm_enable_virtualization(void)
 	--kvm_usage_count;
 	return r;
 }
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_enable_virtualization);
 
-void kvm_disable_virtualization(void)
+static void kvm_disable_virtualization(void)
 {
 	guard(mutex)(&kvm_usage_lock);
 
@@ -5751,7 +5753,6 @@ void kvm_disable_virtualization(void)
 	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
 	kvm_arch_disable_virtualization();
 }
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_disable_virtualization);
 
 static int kvm_init_virtualization(void)
 {
@@ -5767,6 +5768,14 @@ static void kvm_uninit_virtualization(void)
 		kvm_disable_virtualization();
 }
 #else /* CONFIG_KVM_GENERIC_HARDWARE_ENABLING */
+static int kvm_enable_virtualization(void)
+{
+	return 0;
+}
+static void kvm_disable_virtualization(void)
+{
+
+}
 static int kvm_init_virtualization(void)
 {
 	return 0;
-- 
2.52.0.223.gf5cc29aaa4-goog


