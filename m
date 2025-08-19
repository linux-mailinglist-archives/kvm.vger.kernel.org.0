Return-Path: <kvm+bounces-54965-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EE40BB2BCA6
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 11:10:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 68E8D7AAC1B
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 09:08:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 708CF31CA72;
	Tue, 19 Aug 2025 09:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sg0bko44"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AD731AF25
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 09:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755594544; cv=none; b=PLi9vSPTdXgg1n8tOkccNPqqYpovzDSgLQePutj78rCNrej6lJ7M8NXsHdqhhGeizx/Mw/Gqy4MnLFVOYPGVrLqdTSpYGV8skJVd1OZCJM8a+cCAs1SH6mqj1JnQiFN5bCz/Y4ZfOpSxPW/titIi9OHCKvGKjH5B4JHtPrnVRLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755594544; c=relaxed/simple;
	bh=/UoRxomHA1M2V2aUUXQmoA60DOqPM2oKLqITF3Q6naA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GWajoCukOhCnuPw/YkIjipGztTQKdgR81HzSz3MQmYYcTOAO4bJGcAqsgAqUrqhocPi6uKbV8PvZmV3Z7u7rzy0rbXDFkyjmhUQHdEhoXZbl7GUyoI+mvz7WBHKKzmkevtVwnC2wZ+6/RKa6BCqmRALMU/bNgjnaTiYWrt++Zsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sg0bko44; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45a1b0060bfso26717435e9.0
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 02:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755594541; x=1756199341; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YVk9a2k32/h6AWhwvz8AjLIHmDt75XL0D5Be34oDUlo=;
        b=sg0bko44sJDUYHrBCLSYVahhF6x0qEz6BJHINEOzrA9qoe2zGwE1nn7c43Lb0j9yFr
         pOokajXSTvsB8UcybNwX2X/fzoS0+UUPlScGPC1dGa362ZLsfRGnz1/ZUPl80VIlzT8/
         HCXlPA6WN3fnWRHNtyJKr5GsGfi5XxG94IkgDC3qSJ7SSSivJLkVp0nPR+q4r/erckRd
         /Agry6SeZiFsOE+XAeTE0mEI0JpvdP9ti/11mP8OaJKuautYAhp45Fmox5ytHm4qPrik
         WI78kXXgt/8xSYUdyMFGQc1cs6uKa81nCc2qlA8u/aUrqWJANtKIAkfRj+dLguDVJtPA
         9SRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755594541; x=1756199341;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YVk9a2k32/h6AWhwvz8AjLIHmDt75XL0D5Be34oDUlo=;
        b=IFcL+anu0OHZYjS8ryv9IswIYoofTh22/9RPhomAmLpxWzOHOaiL99hIgt3OJfj1dn
         zwfKIef6qQ5zbRxgdOXlxIWIVAkiAb8VKeWVDS5Lx9WYRwjQ4Z9RrXMEyn+exCJCjk2U
         W2j/01dbjJ38rlcvdnxuMV/mHldmxkkEjFGBaqgLIiuvtJbSKAO1vXjmdnbzVYQpCg+g
         O5XcsBVuNQN83U22q+SYX1A4+XB1EgHDjm70UtP3wDo3tflFXUt256pGJfMw1MFVVtX4
         WnManATRQyXhWnEenOShinR1dCA7yN+4QEuBIMXbUL5ZOe0dT0VtvMRYeyB23M8k0oSt
         CHBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDp0/BuMnr+BQ1T4sEAoh2Z8uzi5Z6BAIZ4GxtpNrgdzMfeKLkYjFn7+2vTy6mvAhs8C0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbBuwBLZLzSV4G6wxVqr2xh1QOeRy8lx5NKGK0iBdMKPApRKDT
	8iZUvnJVa0psDt03Ujo8tUR/MBY5T1cCufcLt/hyf0jAx4bszsSd7V4VYaRreLjpIVDWHtSHPYV
	nLw==
X-Google-Smtp-Source: AGHT+IGTjX+cyo/FUylA2G0KujL7y3t2s4M6bbVMk0SnbkXB4aY/ErPaSd+f/dDH9fy1iC89j9dagd09LA==
X-Received: from wmbel5.prod.google.com ([2002:a05:600c:3e05:b0:459:e01c:3d6d])
 (user=keirf job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e91:b0:456:19be:5cc
 with SMTP id 5b1f17b1804b1-45b43dd3118mr11414045e9.14.1755594540927; Tue, 19
 Aug 2025 02:09:00 -0700 (PDT)
Date: Tue, 19 Aug 2025 09:08:52 +0000
In-Reply-To: <20250819090853.3988626-1-keirf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250819090853.3988626-1-keirf@google.com>
X-Mailer: git-send-email 2.51.0.rc1.193.gad69d77794-goog
Message-ID: <20250819090853.3988626-4-keirf@google.com>
Subject: [PATCH v3 3/4] KVM: Implement barriers before accessing kvm->buses[]
 on SRCU read paths
From: Keir Fraser <keirf@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Eric Auger <eric.auger@redhat.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Keir Fraser <keirf@google.com>
Content-Type: text/plain; charset="UTF-8"

This ensures that, if a VCPU has "observed" that an IO registration has
occurred, the instruction currently being trapped or emulated will also
observe the IO registration.

At the same time, enforce that kvm_get_bus() is used only on the
update side, ensuring that a long-term reference cannot be obtained by
an SRCU reader.

Signed-off-by: Keir Fraser <keirf@google.com>
---
 arch/x86/kvm/vmx/vmx.c   |  7 +++++++
 include/linux/kvm_host.h | 10 +++++++---
 virt/kvm/kvm_main.c      | 33 +++++++++++++++++++++++++++------
 3 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aa157fe5b7b3..2d3c8cb4f860 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5785,6 +5785,13 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 		if (kvm_test_request(KVM_REQ_EVENT, vcpu))
 			return 1;
 
+		/*
+		 * Ensure that any updates to kvm->buses[] observed by the
+		 * previous instruction (emulated or otherwise) are also
+		 * visible to the instruction we are about to emulate.
+		 */
+		smp_rmb();
+
 		if (!kvm_emulate_instruction(vcpu, 0))
 			return 0;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 15656b7fba6c..e7d6111cf254 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -966,11 +966,15 @@ static inline bool kvm_dirty_log_manual_protect_and_init_set(struct kvm *kvm)
 	return !!(kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET);
 }
 
+/*
+ * Get a bus reference under the update-side lock. No long-term SRCU reader
+ * references are permitted, to avoid stale reads vs concurrent IO
+ * registrations.
+ */
 static inline struct kvm_io_bus *kvm_get_bus(struct kvm *kvm, enum kvm_bus idx)
 {
-	return srcu_dereference_check(kvm->buses[idx], &kvm->srcu,
-				      lockdep_is_held(&kvm->slots_lock) ||
-				      !refcount_read(&kvm->users_count));
+	return rcu_dereference_protected(kvm->buses[idx],
+					 lockdep_is_held(&kvm->slots_lock));
 }
 
 static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6c07dd423458..4f35ae23ee5a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1103,6 +1103,15 @@ void __weak kvm_arch_create_vm_debugfs(struct kvm *kvm)
 {
 }
 
+/* Called only on cleanup and destruction paths when there are no users. */
+static inline struct kvm_io_bus *kvm_get_bus_for_destruction(struct kvm *kvm,
+							     enum kvm_bus idx)
+{
+	return rcu_dereference_protected(kvm->buses[idx],
+					 !refcount_read(&kvm->users_count));
+}
+
+
 static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 {
 	struct kvm *kvm = kvm_arch_alloc_vm();
@@ -1228,7 +1237,7 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 out_err_no_arch_destroy_vm:
 	WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
 	for (i = 0; i < KVM_NR_BUSES; i++)
-		kfree(kvm_get_bus(kvm, i));
+		kfree(kvm_get_bus_for_destruction(kvm, i));
 	kvm_free_irq_routing(kvm);
 out_err_no_irq_routing:
 	cleanup_srcu_struct(&kvm->irq_srcu);
@@ -1276,7 +1285,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 
 	kvm_free_irq_routing(kvm);
 	for (i = 0; i < KVM_NR_BUSES; i++) {
-		struct kvm_io_bus *bus = kvm_get_bus(kvm, i);
+		struct kvm_io_bus *bus = kvm_get_bus_for_destruction(kvm, i);
 
 		if (bus)
 			kvm_io_bus_destroy(bus);
@@ -5843,6 +5852,18 @@ static int __kvm_io_bus_write(struct kvm_vcpu *vcpu, struct kvm_io_bus *bus,
 	return -EOPNOTSUPP;
 }
 
+static struct kvm_io_bus *kvm_get_bus_srcu(struct kvm *kvm, enum kvm_bus idx)
+{
+	/*
+	 * Ensure that any updates to kvm_buses[] observed by the previous VCPU
+	 * machine instruction are also visible to the VCPU machine instruction
+	 * that triggered this call.
+	 */
+	smp_mb__after_srcu_read_lock();
+
+	return srcu_dereference(kvm->buses[idx], &kvm->srcu);
+}
+
 int kvm_io_bus_write(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 		     int len, const void *val)
 {
@@ -5855,7 +5876,7 @@ int kvm_io_bus_write(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 		.len = len,
 	};
 
-	bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &vcpu->kvm->srcu);
+	bus = kvm_get_bus_srcu(vcpu->kvm, bus_idx);
 	if (!bus)
 		return -ENOMEM;
 	r = __kvm_io_bus_write(vcpu, bus, &range, val);
@@ -5874,7 +5895,7 @@ int kvm_io_bus_write_cookie(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx,
 		.len = len,
 	};
 
-	bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &vcpu->kvm->srcu);
+	bus = kvm_get_bus_srcu(vcpu->kvm, bus_idx);
 	if (!bus)
 		return -ENOMEM;
 
@@ -5924,7 +5945,7 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 		.len = len,
 	};
 
-	bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &vcpu->kvm->srcu);
+	bus = kvm_get_bus_srcu(vcpu->kvm, bus_idx);
 	if (!bus)
 		return -ENOMEM;
 	r = __kvm_io_bus_read(vcpu, bus, &range, val);
@@ -6033,7 +6054,7 @@ struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 
-	bus = srcu_dereference(kvm->buses[bus_idx], &kvm->srcu);
+	bus = kvm_get_bus_srcu(kvm, bus_idx);
 	if (!bus)
 		goto out_unlock;
 
-- 
2.51.0.rc1.193.gad69d77794-goog


