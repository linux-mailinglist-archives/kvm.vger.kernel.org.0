Return-Path: <kvm+bounces-52621-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FEADB0744F
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 13:09:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BFAD165E1D
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 11:08:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86F332F4A08;
	Wed, 16 Jul 2025 11:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aq14s6dg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52C62F4319
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 11:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752664070; cv=none; b=TzKJhdxse3ECDgntlyn/pTtC/+GgfikeH9/m4DmvDXP53ywhdIbmSfZgTbjKjzC8yQhHkoZ0SQIGGl/szpM7Aj+hYRtUvb6WQkoN8ApBmcC7EI+GoQJpD+QxvJctqyajU+O/2KwYCwpy9ouiAkxAtvAJISxfFhv9WaEQ0aQRiTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752664070; c=relaxed/simple;
	bh=bp/5ZyCkFH6I6+8VSptNOyl0ICot7qcphUT+rW69J2I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PaQIGaP//E5KMYi1eaNtFn4x6v9FBbuPs6jofIeFBk2/Ua5wvpb/7tynyx8gmSW8gHlVeZUAEcxCjMoNOHFIfhmLe4iF7YcIuJotxgq+HyXf7Vjti9ry9RasRaVfqYw5MJNWhBezW0bfVan4qq7o8+mm12gSD+t1buAmAxWNZ9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aq14s6dg; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--keirf.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-451d2037f1eso42049975e9.0
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 04:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752664067; x=1753268867; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DkXH9+Ju9qLefqDmLXr88CY0f/QuBhkcRpVqVhxrcMo=;
        b=aq14s6dgk9teEly7y0VydG+qFPGKTz6+qSoLKD0O9GQj4NToKUpegJeot8h7TzZZzd
         OAj3fVyItf4C9MsoRpF5bNxUAQ5fX7LXQPAiHW3GxqmB6dnyWhQ7KIo/wkiLPnkN4t5d
         2XIXMeyGtVlsUDmfiKW8/uYIF8xRel/yTlILq1jNGPVN0K+e2qpYHUzU+ijTnpuamlIh
         80z5pkZHnEVQU+yxEljN6j9T4HiufCRVTzrX4mkoab1mA+k3K+MvmDXe9VwHXYy/DtpA
         8w9qybfWCbDD5i3q4PtJL3xcHjIf3DvBTw89lcQaNTh/BSJqf//TsqbvQunrmVW8Kofq
         N9vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752664067; x=1753268867;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DkXH9+Ju9qLefqDmLXr88CY0f/QuBhkcRpVqVhxrcMo=;
        b=CQiRlcKZDIoSaj6Fz9taMqY2TNlQxxqQ+UsiIt8KaEMpnoYN3DzZHGt7UWQU+7+2sd
         Pv0WMlzfQKNWlPGthvbokNMxf6S5zwegHaaf14DNpIlvk/U45/dErjGbsaPaOcU4U3Kg
         /NJqoNoySTIjgrF9A+EUCSkTV4Ipef/+aBeaStEoCoqQHJ9rQoWV9zi/tYDoMp1/HXSC
         rgluRwi/n171IDJZ9/cZcNKZUJK5IIfOy6FH7dLM5DfmjW3GsFl6aQN0GttcfyfJS7J2
         ueUMcM472JVXzoCl97IlGg4149I3FNGjhVqW+rQ5ahfgSptCOjyFKnwjDvGDzZ57V6oe
         jSRw==
X-Forwarded-Encrypted: i=1; AJvYcCWvG4Z35CkXrNl27XV4TnBROPQeT5sjb/SzEwI8RUGry5R+YV6F1q/hIJyzCQvktNwu46A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy63ltOSr34KcNjQjMJyMqQjtoXl7DGPFppJ3OQVKDFwM/YtjFA
	qW5RS6g7HiEyx8jLLmPvk2CU6KUEfNSi+eJ8M/iQKp6cULOVy4962UPO1GI9XOYw8OLaGMy1wTZ
	8fg==
X-Google-Smtp-Source: AGHT+IFpoWhoafJFWbwsE4WRdqTI2xCnHqs5MSPVmR8sRs6DH+HGmbw1n5hUPgrnRCYka3njSht1T7VPaw==
X-Received: from wmby19.prod.google.com ([2002:a05:600c:c053:b0:456:1b6f:c878])
 (user=keirf job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3e15:b0:439:86fb:7340
 with SMTP id 5b1f17b1804b1-4562e39865dmr26121765e9.30.1752664067193; Wed, 16
 Jul 2025 04:07:47 -0700 (PDT)
Date: Wed, 16 Jul 2025 11:07:36 +0000
In-Reply-To: <20250716110737.2513665-1-keirf@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250716110737.2513665-1-keirf@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250716110737.2513665-4-keirf@google.com>
Subject: [PATCH v2 3/4] KVM: Implement barriers before accessing kvm->buses[]
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
index 191a9ed0da22..425e3d8074ab 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5861,6 +5861,13 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
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
index 3bde4fb5c6aa..9132148fb467 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -965,11 +965,15 @@ static inline bool kvm_dirty_log_manual_protect_and_init_set(struct kvm *kvm)
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
index 222f0e894a0c..9ec3b96b9666 100644
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
@@ -5838,6 +5847,18 @@ static int __kvm_io_bus_write(struct kvm_vcpu *vcpu, struct kvm_io_bus *bus,
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
@@ -5850,7 +5871,7 @@ int kvm_io_bus_write(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 		.len = len,
 	};
 
-	bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &vcpu->kvm->srcu);
+	bus = kvm_get_bus_srcu(vcpu->kvm, bus_idx);
 	if (!bus)
 		return -ENOMEM;
 	r = __kvm_io_bus_write(vcpu, bus, &range, val);
@@ -5869,7 +5890,7 @@ int kvm_io_bus_write_cookie(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx,
 		.len = len,
 	};
 
-	bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &vcpu->kvm->srcu);
+	bus = kvm_get_bus_srcu(vcpu->kvm, bus_idx);
 	if (!bus)
 		return -ENOMEM;
 
@@ -5919,7 +5940,7 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 		.len = len,
 	};
 
-	bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &vcpu->kvm->srcu);
+	bus = kvm_get_bus_srcu(vcpu->kvm, bus_idx);
 	if (!bus)
 		return -ENOMEM;
 	r = __kvm_io_bus_read(vcpu, bus, &range, val);
@@ -6028,7 +6049,7 @@ struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 
 	srcu_idx = srcu_read_lock(&kvm->srcu);
 
-	bus = srcu_dereference(kvm->buses[bus_idx], &kvm->srcu);
+	bus = kvm_get_bus_srcu(kvm, bus_idx);
 	if (!bus)
 		goto out_unlock;
 
-- 
2.50.0.727.gbf7dc18ff4-goog


