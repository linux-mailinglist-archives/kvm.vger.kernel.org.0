Return-Path: <kvm+bounces-59481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8501EBB8628
	for <lists+kvm@lfdr.de>; Sat, 04 Oct 2025 01:27:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F6384A67CA
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 23:27:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA3C82DC353;
	Fri,  3 Oct 2025 23:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ukO/mnIG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3427F2C08D5
	for <kvm@vger.kernel.org>; Fri,  3 Oct 2025 23:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759533983; cv=none; b=e6aNYWqeraeSTHhmi83spsIbpiuM6sQGNbSVQimdWNYKi2Qc5nDxxBUsgEyWnLVYISFCF/kt9aMuLP4EcpCLixwvL7ayZrPaA6C5Z8yjRNKNuvKN8L08DbaCGnmymukKChlUeGvZTUzF4LVgjKVMx72UFgLUNupweM2nyGl0zT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759533983; c=relaxed/simple;
	bh=hVeXdPDZE/s1WX7ZLbBu0X7hAQNL0mbXw0X5RRQ5iC8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p9TQyvoYpEuHChlaGUpMYtejD3LRK5LzelfhZIJDJuupXmPURMur1xzjNNWrj40XFAwbnJF/LD54E/b3yI9U2NaDpILvrDshRDezH0QjPDQKfa+/4dx4FhDFF8qSrKMQeTZTxZm5rUuT/obYRc6Kdu9LBWHlTafPh0Jn9a7S6uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ukO/mnIG; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33428befd39so5443394a91.0
        for <kvm@vger.kernel.org>; Fri, 03 Oct 2025 16:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759533981; x=1760138781; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BnqXgrEp0BrPyyaZOXVty/y9QlyaxhKDq3CIvXTV4iM=;
        b=ukO/mnIGy2dKTJi3jwXdjP2nc9GSoCSHg3uOvnTexie7b0yD1MOBnrmU/eA8sVo2bq
         fetoFRc2e7LithDaJF7TlgFvZYKY9magod11xraysn5s8J9me08OxMm+3v+SaysdFvQE
         nvut5sSC4/g/wucZBTIlrIGSgJQOFs8jFhrnsM2cdCB9PEwQgznnZ/u/FXOchVpwy1N+
         7kfk50KYrrsX9hhYtl5Lxy9GqLM1iuhx8IHYCTj6+MEGLFQikqF/rODH74HwoWbx/J/Q
         S4txcqlR0Rm/1nMfiuaBdOnA7dfzYPMx1QSkZOguCvqZFKKnKPJYekqRsNvHooRm+eXn
         CYZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759533981; x=1760138781;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BnqXgrEp0BrPyyaZOXVty/y9QlyaxhKDq3CIvXTV4iM=;
        b=IhEV7hifdeIvfgWgjSrX14iOQaXycnGBeWaT4PaBCIbsZmEVPZaIJaYDeb7UexJbay
         cGGe4xJ6vLFHff5oYcAwkuVuM19HouAZR9DC+6mtv480BybHYkxoHmJJuPx4oe4ZSLFz
         wjHYB5YIGYajKq/xfvwvXcq0XOsqImJYth6pWYP6JNTnG8vsPE1st67iw+FFySMlfXPE
         2GdbdOqJLZDu+2yQkMqZT097VkIsZhZnPt/TyDvclBnpKWTd2D6blrA7od46D5N0Kkdo
         XZmTVvX4SP+edBccGwt1Qou4q8Y7H0u+iut4HpCIKZi1dXCjVcwCtPQtA9NrPLlBhWn4
         qF1Q==
X-Gm-Message-State: AOJu0Yxs9Q4rFIA2Q9LNc1cL+X+9ARSlNuyjKKMl/MDAwBBAuGAry835
	pYD4UUJoRQQHtGsLA1EpuJnL78LlXNQOv1AyjDLxiSpMJ0vhRpjCHWZMUJJXec1QNNCvfUu2E9W
	7wGWnoQ==
X-Google-Smtp-Source: AGHT+IHCp+k6bhpHyajHgY7Z2md8cqG1GHHJ3a+LGG8538QDAIuyMFLtajpOAADKCcS+hN7/x3QuGCcmmiM=
X-Received: from pjvh15.prod.google.com ([2002:a17:90a:db8f:b0:330:6eb8:6ae4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d8d:b0:32b:c9c0:2a11
 with SMTP id 98e67ed59e1d1-339c2707c2emr5796988a91.4.1759533981554; Fri, 03
 Oct 2025 16:26:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  3 Oct 2025 16:25:58 -0700
In-Reply-To: <20251003232606.4070510-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251003232606.4070510-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003232606.4070510-6-seanjc@google.com>
Subject: [PATCH v2 05/13] KVM: guest_memfd: Allow mmap() on guest_memfd for
 x86 VMs with private memory
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

Allow mmap() on guest_memfd instances for x86 VMs with private memory as
the need to track private vs. shared state in the guest_memfd instance is
only pertinent to INIT_SHARED.  Doing mmap() on private memory isn't
terrible useful (yet!), but it's now possible, and will be desirable when
guest_memfd gains support for other VMA-based syscalls, e.g. mbind() to
set NUMA policy.

Lift the restriction now, before MMAP support is officially released, so
that KVM doesn't need to add another capability to enumerate support for
mmap() on private memory.

Fixes: 3d3a04fad25a ("KVM: Allow and advertise support for host mmap() on guest_memfd files")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c       |  7 ++++---
 include/linux/kvm_host.h | 12 +++++++++++-
 virt/kvm/guest_memfd.c   |  9 ++-------
 virt/kvm/kvm_main.c      |  6 +-----
 4 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4b8138bd4857..fe3dc3eb4331 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13942,10 +13942,11 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
 /*
- * KVM doesn't yet support mmap() on guest_memfd for VMs with private memory
- * (the private vs. shared tracking needs to be moved into guest_memfd).
+ * KVM doesn't yet support initializing guest_memfd memory as shared for VMs
+ * with private memory (the private vs. shared tracking needs to be moved into
+ * guest_memfd).
  */
-bool kvm_arch_supports_gmem_mmap(struct kvm *kvm)
+bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 {
 	return !kvm_arch_has_private_mem(kvm);
 }
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 19b8c4bebb9c..680ca838f018 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -729,7 +729,17 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 #endif
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
-bool kvm_arch_supports_gmem_mmap(struct kvm *kvm);
+bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
+
+static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
+{
+	u64 flags = GUEST_MEMFD_FLAG_MMAP;
+
+	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
+		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
+
+	return flags;
+}
 #endif
 
 #ifndef kvm_arch_has_readonly_mem
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index e10d2c71e78c..fbca8c0972da 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -485,7 +485,7 @@ static const struct inode_operations kvm_gmem_iops = {
 	.setattr	= kvm_gmem_setattr,
 };
 
-bool __weak kvm_arch_supports_gmem_mmap(struct kvm *kvm)
+bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 {
 	return true;
 }
@@ -549,13 +549,8 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 {
 	loff_t size = args->size;
 	u64 flags = args->flags;
-	u64 valid_flags = 0;
 
-	if (kvm_arch_supports_gmem_mmap(kvm))
-		valid_flags |= GUEST_MEMFD_FLAG_MMAP |
-			       GUEST_MEMFD_FLAG_INIT_SHARED;
-
-	if (flags & ~valid_flags)
+	if (flags & ~kvm_gmem_get_supported_flags(kvm))
 		return -EINVAL;
 
 	if (size <= 0 || !PAGE_ALIGNED(size))
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5f644ca54af3..b7a0ae2a7b20 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4929,11 +4929,7 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_GUEST_MEMFD:
 		return 1;
 	case KVM_CAP_GUEST_MEMFD_FLAGS:
-		if (!kvm || kvm_arch_supports_gmem_mmap(kvm))
-			return GUEST_MEMFD_FLAG_MMAP |
-			       GUEST_MEMFD_FLAG_INIT_SHARED;
-
-		return 0;
+		return kvm_gmem_get_supported_flags(kvm);
 #endif
 	default:
 		break;
-- 
2.51.0.618.g983fd99d29-goog


