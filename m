Return-Path: <kvm+bounces-42337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A6A1A77FE2
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 18:12:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 568D91890923
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 16:12:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0469C20F078;
	Tue,  1 Apr 2025 16:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YPQdvFYH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7422620E336
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 16:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743523885; cv=none; b=J/npKTQVJx2I7Fset4+mpFC7kC9lfG6riZ3DfJdVPWVfqpXekaAo7lOjvX8Py7Mfk/MGtKE6+I3JiPHmSLWAPzEfGNS2MEkHFHgJyceSsFVXXOaA9Mz+RE3N6ke6Q2isOiw+7ny9H1V8qVYBbOH6HpNFvgT+j9USvCOYJrlRus8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743523885; c=relaxed/simple;
	bh=v8jKs9c/aSFeCCmvqZ/YRl3Cj78RpyaLQZNO8QjAPqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkzKrxNVKeaAJfuajJt5bMksPkq0YGaYGAtp3tPcE/BsjsNZDjfKYQDji4w875WB3wZe69kyPiKFWAyAGQj7WA+uWB1Q+Y9CTMEix3vWykJfkIqY79ekjMoWT9z2aFCsPGBwIwFM+VC9Fp93u4W0rcVSqbdpRchTShn3pwNPcn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YPQdvFYH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743523882;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZVj8LxmRYtpLGVaJMpm0cMjRCHl/hUqQsU3rCt2if/8=;
	b=YPQdvFYHfxG9svK8nZBOzQaxW7Ki7nZO+zprBz4EBZhvLMYwV/ooUTY5BRP9j8uekGQKg5
	xGPPwKClHoRCkFyKR08i80fGGD1mAQokOqSCc3r3EabubCPyQRDw5WFU1KZBGebDA8i/00
	WujLoztQMUiOPaeqOS1JSqEWKRK9DA4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-54-OG99hOJdMwq7WJ1Ikqo8vQ-1; Tue, 01 Apr 2025 12:11:21 -0400
X-MC-Unique: OG99hOJdMwq7WJ1Ikqo8vQ-1
X-Mimecast-MFC-AGG-ID: OG99hOJdMwq7WJ1Ikqo8vQ_1743523880
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43cf327e9a2so48729695e9.3
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 09:11:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743523880; x=1744128680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZVj8LxmRYtpLGVaJMpm0cMjRCHl/hUqQsU3rCt2if/8=;
        b=bD2EEsOUgsJwUMt0mLuYIgVvEHTrd+Skuhm5ALagjfprAA0Y5A4pJSMtAOEV/i2naK
         O+UVDLxrWFLf6QPlKt76N1hUeQwfWeRiyAsl+k3S3MqYVqFB7UBXVLwuMXXlP7GAKr6s
         tWrupRW8EuoHfFlyJYsTU6zii5/gTu7N0ZrxNSpvy5uVs0H4U5y6gJgvqwqT171lzM2v
         LUQlilwcsMonwm6tbpa03dxtMBTActD9U2AEuYOuvYp4+FMbeCITOlXMLkZSqOFTllhx
         Yqm4ODBRtH+I/cShUbR+h8Hp66NLvEW8Id0SRXBROxzK3QQhITXRaNMDyX0FwTaFtFAF
         3WIg==
X-Forwarded-Encrypted: i=1; AJvYcCXGjjXW1VH9KMFmW2jLt3xxRzb9tH5jNaHsZQNd0kiwplFlxWIwHIHPSCWzu7ceq5IhTqs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGtEUPiHP+CKcPN82EGqJ8oRE56NOQV4ulUK3k2XZRDXDUeyhQ
	HCxoQvyVJGLdhd3JwucIoOqolQWbF+V/dwIwx87oxpETZ+SIOdFCgZu68vZkP9oKFKvX9bCKg0H
	P8uD16beXMf87C1g7Zn0FZLGzCdzZRCq5k/Eii7zkpRCAd02cSg==
X-Gm-Gg: ASbGncvau+8GVINevMSAGsd2mmmBbXVi5Dv2zkff/2VEg5PLrdZK7ug/rCQVgIdsSk8
	LEfdr1ARBPVqPK6cIeAQe5o5nSJKuG3gu3JYiDgVau+tFmJ7sSSLvCzzKCYPW2TYyrAVgfyv4y3
	q92z8DN24VLersyOHbsjIBEeAzv0jNU5ZdTgzDrjUp8VOBWwqyG6uDZIFd608/pL5BSxbHLRawx
	MdDCxK4L2d2uMx303NG4s3OfJZaG9azDrp8Q/xQKOb+C3vnSYl4IIwK7sDtNjzsjFQ5lxdpQoQe
	0cnAlmravTST4qZueStxoQ==
X-Received: by 2002:a05:600c:3d06:b0:43c:f184:2e16 with SMTP id 5b1f17b1804b1-43eaa03e0b9mr29476055e9.5.1743523879940;
        Tue, 01 Apr 2025 09:11:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+E1xmwedldRJqmLtJk3EgwSLiKjTaPQFsZDp0oRIihpMjpWkbFC2kwYxD4KB/4aSNm+zhoQ==
X-Received: by 2002:a05:600c:3d06:b0:43c:f184:2e16 with SMTP id 5b1f17b1804b1-43eaa03e0b9mr29475595e9.5.1743523879524;
        Tue, 01 Apr 2025 09:11:19 -0700 (PDT)
Received: from [192.168.10.48] ([176.206.111.201])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b79e3b0sm14455968f8f.74.2025.04.01.09.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 09:11:18 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: roy.hopkins@suse.com,
	seanjc@google.com,
	thomas.lendacky@amd.com,
	ashish.kalra@amd.com,
	michael.roth@amd.com,
	jroedel@suse.de,
	nsaenz@amazon.com,
	anelkz@amazon.de,
	James.Bottomley@HansenPartnership.com
Subject: [PATCH 04/29] KVM: introduce struct kvm_arch_plane
Date: Tue,  1 Apr 2025 18:10:41 +0200
Message-ID: <20250401161106.790710-5-pbonzini@redhat.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250401161106.790710-1-pbonzini@redhat.com>
References: <20250401161106.790710-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h     | 5 +++++
 arch/loongarch/include/asm/kvm_host.h | 5 +++++
 arch/mips/include/asm/kvm_host.h      | 5 +++++
 arch/powerpc/include/asm/kvm_host.h   | 5 +++++
 arch/riscv/include/asm/kvm_host.h     | 5 +++++
 arch/s390/include/asm/kvm_host.h      | 5 +++++
 arch/x86/include/asm/kvm_host.h       | 6 ++++++
 include/linux/kvm_host.h              | 2 ++
 virt/kvm/kvm_main.c                   | 3 +++
 9 files changed, 41 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d919557af5e5..b742275cda4d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -227,6 +227,9 @@ struct kvm_s2_mmu {
 struct kvm_arch_memory_slot {
 };
 
+struct kvm_arch_plane {
+};
+
 /**
  * struct kvm_smccc_features: Descriptor of the hypercall services exposed to the guests
  *
@@ -1334,6 +1337,8 @@ static inline bool kvm_system_needs_idmapped_vectors(void)
 	return cpus_have_final_cap(ARM64_SPECTRE_V3A);
 }
 
+static inline void kvm_arch_init_plane(struct kvm_plane *plane) {}
+static inline void kvm_arch_free_plane(struct kvm_plane *plane) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 
 void kvm_init_host_debug_data(void);
diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
index 2281293a5f59..24c1dafac855 100644
--- a/arch/loongarch/include/asm/kvm_host.h
+++ b/arch/loongarch/include/asm/kvm_host.h
@@ -73,6 +73,9 @@ struct kvm_arch_memory_slot {
 	unsigned long flags;
 };
 
+struct kvm_arch_plane {
+};
+
 #define HOST_MAX_PMNUM			16
 struct kvm_context {
 	unsigned long vpid_cache;
@@ -325,6 +328,8 @@ static inline bool kvm_is_ifetch_fault(struct kvm_vcpu_arch *arch)
 }
 
 /* Misc */
+static inline void kvm_arch_init_plane(struct kvm_plane *plane) {}
+static inline void kvm_arch_free_plane(struct kvm_plane *plane) {}
 static inline void kvm_arch_hardware_unsetup(void) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index f7222eb594ea..d7be72c529b3 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -147,6 +147,9 @@ struct kvm_vcpu_stat {
 struct kvm_arch_memory_slot {
 };
 
+struct kvm_arch_plane {
+};
+
 #ifdef CONFIG_CPU_LOONGSON64
 struct ipi_state {
 	uint32_t status;
@@ -886,6 +889,8 @@ extern unsigned long kvm_mips_get_ramsize(struct kvm *kvm);
 extern int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 			     struct kvm_mips_interrupt *irq);
 
+static inline void kvm_arch_init_plane(struct kvm_plane *plane) {}
+static inline void kvm_arch_free_plane(struct kvm_plane *plane) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_free_memslot(struct kvm *kvm,
 					 struct kvm_memory_slot *slot) {}
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 6e1108f8fce6..6023f0fd637b 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -256,6 +256,9 @@ struct kvm_arch_memory_slot {
 #endif /* CONFIG_KVM_BOOK3S_HV_POSSIBLE */
 };
 
+struct kvm_arch_plane {
+};
+
 struct kvm_hpt_info {
 	/* Host virtual (linear mapping) address of guest HPT */
 	unsigned long virt;
@@ -902,6 +905,8 @@ struct kvm_vcpu_arch {
 #define __KVM_HAVE_ARCH_WQP
 #define __KVM_HAVE_CREATE_DEVICE
 
+static inline void kvm_arch_init_plane(struct kvm_plane *plane) {}
+static inline void kvm_arch_free_plane(struct kvm_plane *plane) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen) {}
 static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index cc33e35cd628..72f862194a0c 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -97,6 +97,9 @@ struct kvm_vcpu_stat {
 struct kvm_arch_memory_slot {
 };
 
+struct kvm_arch_plane {
+};
+
 struct kvm_vmid {
 	/*
 	 * Writes to vmid_version and vmid happen with vmid_lock held
@@ -301,6 +304,8 @@ static inline bool kvm_arch_pmi_in_guest(struct kvm_vcpu *vcpu)
 	return IS_ENABLED(CONFIG_GUEST_PERF_EVENTS) && !!vcpu;
 }
 
+static inline void kvm_arch_init_plane(struct kvm_plane *plane) {}
+static inline void kvm_arch_free_plane(struct kvm_plane *plane) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 
 #define KVM_RISCV_GSTAGE_TLB_MIN_ORDER		12
diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index 9a367866cab0..63b79ce5c8ac 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -799,6 +799,9 @@ struct kvm_vm_stat {
 struct kvm_arch_memory_slot {
 };
 
+struct kvm_arch_plane {
+};
+
 struct s390_map_info {
 	struct list_head list;
 	__u64 guest_addr;
@@ -1056,6 +1059,8 @@ bool kvm_s390_pv_cpu_is_protected(struct kvm_vcpu *vcpu);
 extern int kvm_s390_gisc_register(struct kvm *kvm, u32 gisc);
 extern int kvm_s390_gisc_unregister(struct kvm *kvm, u32 gisc);
 
+static inline void kvm_arch_init_plane(struct kvm_plane *plane) {}
+static inline void kvm_arch_free_plane(struct kvm_plane *plane) {}
 static inline void kvm_arch_sync_events(struct kvm *kvm) {}
 static inline void kvm_arch_free_memslot(struct kvm *kvm,
 					 struct kvm_memory_slot *slot) {}
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 383b736cc6f1..8240f565a764 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1086,6 +1086,9 @@ struct kvm_arch_memory_slot {
 	unsigned short *gfn_write_track;
 };
 
+struct kvm_arch_plane {
+};
+
 /*
  * Track the mode of the optimized logical map, as the rules for decoding the
  * destination vary per mode.  Enabling the optimized logical map requires all
@@ -2357,6 +2360,9 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm);
 void kvm_make_scan_ioapic_request_mask(struct kvm *kvm,
 				       unsigned long *vcpu_bitmap);
 
+static inline void kvm_arch_init_plane(struct kvm_plane *plane) {}
+static inline void kvm_arch_free_plane(struct kvm_plane *plane) {}
+
 bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
 				     struct kvm_async_pf *work);
 void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0e16c34080ef..6bd9b0b3cbee 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -763,6 +763,8 @@ struct kvm_memslots {
 struct kvm_plane {
 	struct kvm *kvm;
 	int plane;
+
+	struct kvm_arch_plane arch;
 };
 
 struct kvm {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 67773b6b9576..e83db27580da 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1104,6 +1104,8 @@ static struct kvm_plane *kvm_create_vm_plane(struct kvm *kvm, unsigned plane_id)
 
 	plane->kvm = kvm;
 	plane->plane = plane_id;
+
+	kvm_arch_init_plane(plane);
 	return plane;
 }
 
@@ -1277,6 +1279,7 @@ static void kvm_destroy_devices(struct kvm *kvm)
 
 static void kvm_destroy_plane(struct kvm_plane *plane)
 {
+	kvm_arch_free_plane(plane);
 }
 
 static void kvm_destroy_vm(struct kvm *kvm)
-- 
2.49.0


