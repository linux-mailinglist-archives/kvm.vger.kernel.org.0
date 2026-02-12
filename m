Return-Path: <kvm+bounces-70949-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cE1aLhSxjWmz5wAAu9opvQ
	(envelope-from <kvm+bounces-70949-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 11:53:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 31C2412CB80
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 11:53:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C010A303D8B0
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 10:52:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0456531987D;
	Thu, 12 Feb 2026 10:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FIxF5Mbs";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ay54Ruyc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E0C3164C5
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 10:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770893543; cv=none; b=GCJlCDF8wW92muUC2+YlowvTODyQtOcWsm0vGriS9YuQvVc1f3W3a/mMeKupY1gXnywfJTWAZftyKN43VfdIh6/9kTIX3P+gvSY0a4wHUEhjPVXGu0b68tSS+CwKb60hbajDU5eGt/KLRTTHYRfYYUR/oAxwdv96137x57xsF6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770893543; c=relaxed/simple;
	bh=RIGmj2isparUhNGULKkS5CPBPUvuGQrSv430BaLbBiw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPtKniHQTycfRwhbKt7pq8tAaouVxMeXW+GbBsnNW64krakTLIAl3qSEOkdqAOhANMqXFOJy4RlSEJD1WONzMkIb3ztGSE++XbOlqMu5AHNTXfvG49QNSv/5BXYwdOGvH+l7/2GwQfBSw2GE/hxxYKirEm9JjkJ1JacqeKnJd8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FIxF5Mbs; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ay54Ruyc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770893539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VzEBZu10AOrKqYdvECfIBrc7fZqtfKlGow6WgkhXBRY=;
	b=FIxF5Mbsp2lstejCmRy7iJ75bdecDrgQlyt++wBD0JHChDu5TsGYDnV72zPTwwkxjspvZi
	yApCr5thSJkNX41s8E8ks0SZ6zP+S0MwD1o47ZnS2FMw3ZBj5B30ZeqSJPmvI0T+Stl3IW
	VfBQSLmsvpEB9D29pY2EOi9yz6u3LCg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-WgEMFhJUM1K3yY5i76NDjw-1; Thu, 12 Feb 2026 05:52:17 -0500
X-MC-Unique: WgEMFhJUM1K3yY5i76NDjw-1
X-Mimecast-MFC-AGG-ID: WgEMFhJUM1K3yY5i76NDjw_1770893536
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4806cfffca6so87048885e9.2
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 02:52:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770893536; x=1771498336; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VzEBZu10AOrKqYdvECfIBrc7fZqtfKlGow6WgkhXBRY=;
        b=Ay54Ruycbb338bnEZe+o5I4e7Eok0PhITVsDwb8Px/QxQ3sVIwwyQSCHX9uTaLf3zS
         2X/iVFOF/llSouEWbRlfsgKcC3dC2OlS9mXoXq1YnqZYeZhCsVmGz83O8Tsd7wy29m7y
         bbMsrBP0Kli1h4uSkEoG+Hjpdi5gsN0e9i1uK0WhSonQKlPmcESJe4FdWuTFBwNOFVM+
         OUBG1+jNrD1Eke6zTbD+5QifyzcLMjMaGdyO6J5bIEXwPNUVxGmnVvS56377JSHGI3Vl
         uU3+DnjjqSua1UJO+nw+OLpZk7EJYhH4owQEmepqsVBanXSNpQ2HJ0SqqWxtsGKHkPhT
         rSEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770893536; x=1771498336;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VzEBZu10AOrKqYdvECfIBrc7fZqtfKlGow6WgkhXBRY=;
        b=ILw/9sucwWmSlhsEGBvhPje8XU84mZhgp/lYFlTvBlP0EzdfDxt7xTlufikKgN0dol
         7V9ACRN3JelAn302jS+k/58QvSPevam8py/w74cPhydBx384e8Ofid42e6Du3X+EO1iG
         rgTPgmgGAzL1AUqkINCpMsfLjy3pZPqif/5R2IC36fLLqSMSjbPcHiXl6RRO9l7Ugmpp
         CAqGTEsGwbsoFWU71jpshdHsTUGmQrsnq4ES78DCNebr/EaQPEfcnv2FOgkJmnHkvfYx
         8CD+Zx79DgamKjpkpiCCmR9UDXRN7LgWaiELmYEgASxi/xKPfuaPwz4WBeHk5H2BWmQG
         krcg==
X-Forwarded-Encrypted: i=1; AJvYcCWnYO9OB4mW+vA4OTt+YpfMXN1Jz/4zQzs5y8+F2Oxz4aUugcwgdr7Nlsw6d2bEEgG1BfM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwJJiWWVuukSWaJA74xIajjNcLFmOzXdENAJc1mvL2Ko499ltJ
	aoLNh5TEz3Jh7I44Td1B+8v1CaQG3vPt07s+m+nkVfttwUcSmxxv/3UGX0LsmGOEPd35YKwFJDT
	jsO84NQ9km9ehRKau4ZSl21NYYv2R5qDf6ExjKtBH+A7v7s6SPCWKYKJX9KF9jA==
X-Gm-Gg: AZuq6aIAbHg9SYnXb9SgSJBpvtS7/rStK2gXuGQQSk9a4On+h4HU7rH6qqqzyHi9ggl
	vC1dG/0vF3oKCP0NQAewgE1ZFBEbWyW8QB33OsO/S7wHp0kLAW/NINZqVL8DuMVx7e5bJGuKGZ8
	MGVKkH4U4kuzGjlvrbwKKfvRsWCWAbkZgVRoWrHLli+s1+52Uyzbbv5kKXXz/8p7BDwFJ5NBkG+
	5AkZdBaJgEIvXYamEJp0fgNOUNXtY7MlFkDKDrFm42lFWBLad9Z/DD8AHyF/hA63OHHnQoQmfD4
	lRuLwqridw9ONo843L8U9/dOT1ipizW1IHMbktL1urhVYu+2e+DI+8axDEb7Bk6o+a2e1xozKJy
	3ZnurBZZQ8eWgPcB0CKu4wRKU6bdJco0xYMx0y/r/cvxImRPMg/cHmwwGn+f7Z9Fp5s84JnbmLo
	Tkv7CSpsEcF5S0uuhopFPBlKEgxU/BWQRW/ldjp2sjG5Tr5NxwuuM=
X-Received: by 2002:a05:600c:4f48:b0:477:c71:1fc1 with SMTP id 5b1f17b1804b1-4836570d0dbmr30148725e9.19.1770893535532;
        Thu, 12 Feb 2026 02:52:15 -0800 (PST)
X-Received: by 2002:a05:600c:4f48:b0:477:c71:1fc1 with SMTP id 5b1f17b1804b1-4836570d0dbmr30148275e9.19.1770893535020;
        Thu, 12 Feb 2026 02:52:15 -0800 (PST)
Received: from [192.168.122.1] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835b9768c9sm76020765e9.2.2026.02.12.02.52.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 02:52:13 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH 1/2] KVM: remove CONFIG_KVM_GENERIC_MMU_NOTIFIER
Date: Thu, 12 Feb 2026 11:52:10 +0100
Message-ID: <20260212105211.1555876-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260212105211.1555876-1-pbonzini@redhat.com>
References: <20260212105211.1555876-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70949-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 31C2412CB80
X-Rspamd-Action: no action

All architectures now use MMU notifier for KVM page table management.
Remove the Kconfig symbol and the code that is used when it is
disabled.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm64/kvm/Kconfig     |  1 -
 arch/loongarch/kvm/Kconfig |  1 -
 arch/mips/kvm/Kconfig      |  1 -
 arch/powerpc/kvm/Kconfig   |  4 ----
 arch/powerpc/kvm/powerpc.c |  1 -
 arch/riscv/kvm/Kconfig     |  1 -
 arch/s390/kvm/Kconfig      |  1 -
 arch/x86/kvm/Kconfig       |  1 -
 include/linux/kvm_host.h   |  7 +------
 virt/kvm/Kconfig           |  8 --------
 virt/kvm/kvm_main.c        | 16 ----------------
 11 files changed, 1 insertion(+), 41 deletions(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 4f803fd1c99a..7d1f22fd490b 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -21,7 +21,6 @@ menuconfig KVM
 	bool "Kernel-based Virtual Machine (KVM) support"
 	select KVM_COMMON
 	select KVM_GENERIC_HARDWARE_ENABLING
-	select KVM_GENERIC_MMU_NOTIFIER
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select KVM_MMIO
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
diff --git a/arch/loongarch/kvm/Kconfig b/arch/loongarch/kvm/Kconfig
index ed4f724db774..8e5213609975 100644
--- a/arch/loongarch/kvm/Kconfig
+++ b/arch/loongarch/kvm/Kconfig
@@ -28,7 +28,6 @@ config KVM
 	select KVM_COMMON
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_GENERIC_HARDWARE_ENABLING
-	select KVM_GENERIC_MMU_NOTIFIER
 	select KVM_MMIO
 	select VIRT_XFER_TO_GUEST_WORK
 	select SCHED_INFO
diff --git a/arch/mips/kvm/Kconfig b/arch/mips/kvm/Kconfig
index cc13cc35f208..b1b9a1d67758 100644
--- a/arch/mips/kvm/Kconfig
+++ b/arch/mips/kvm/Kconfig
@@ -23,7 +23,6 @@ config KVM
 	select KVM_COMMON
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select KVM_MMIO
-	select KVM_GENERIC_MMU_NOTIFIER
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select HAVE_KVM_READONLY_MEM
 	help
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index c9a2d50ff1b0..9a0d1c1aca6c 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -38,7 +38,6 @@ config KVM_BOOK3S_64_HANDLER
 config KVM_BOOK3S_PR_POSSIBLE
 	bool
 	select KVM_MMIO
-	select KVM_GENERIC_MMU_NOTIFIER
 
 config KVM_BOOK3S_HV_POSSIBLE
 	bool
@@ -81,7 +80,6 @@ config KVM_BOOK3S_64_HV
 	tristate "KVM for POWER7 and later using hypervisor mode in host"
 	depends on KVM_BOOK3S_64 && PPC_POWERNV
 	select KVM_BOOK3S_HV_POSSIBLE
-	select KVM_GENERIC_MMU_NOTIFIER
 	select KVM_BOOK3S_HV_PMU
 	select CMA
 	help
@@ -203,7 +201,6 @@ config KVM_E500V2
 	depends on !CONTEXT_TRACKING_USER
 	select KVM
 	select KVM_MMIO
-	select KVM_GENERIC_MMU_NOTIFIER
 	help
 	  Support running unmodified E500 guest kernels in virtual machines on
 	  E500v2 host processors.
@@ -220,7 +217,6 @@ config KVM_E500MC
 	select KVM
 	select KVM_MMIO
 	select KVM_BOOKE_HV
-	select KVM_GENERIC_MMU_NOTIFIER
 	help
 	  Support running unmodified E500MC/E5500/E6500 guest kernels in
 	  virtual machines on E500MC/E5500/E6500 host processors.
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 9a89a6d98f97..3da40ea8c562 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -625,7 +625,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 #endif
 	case KVM_CAP_SYNC_MMU:
-		BUILD_BUG_ON(!IS_ENABLED(CONFIG_KVM_GENERIC_MMU_NOTIFIER));
 		r = 1;
 		break;
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
index 77379f77840a..ec2cee0a39e0 100644
--- a/arch/riscv/kvm/Kconfig
+++ b/arch/riscv/kvm/Kconfig
@@ -30,7 +30,6 @@ config KVM
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_MMIO
 	select VIRT_XFER_TO_GUEST_WORK
-	select KVM_GENERIC_MMU_NOTIFIER
 	select SCHED_INFO
 	select GUEST_PERF_EVENTS if PERF_EVENTS
 	help
diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
index 917ac740513e..7f2c966e70af 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -30,7 +30,6 @@ config KVM
 	select KVM_VFIO
 	select MMU_NOTIFIER
 	select VIRT_XFER_TO_GUEST_WORK
-	select KVM_GENERIC_MMU_NOTIFIER
 	select KVM_MMU_LOCKLESS_AGING
 	help
 	  Support hosting paravirtualized guest machines using the SIE
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index d916bd766c94..801bf9e520db 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -20,7 +20,6 @@ if VIRTUALIZATION
 config KVM_X86
 	def_tristate KVM if (KVM_INTEL != n || KVM_AMD != n)
 	select KVM_COMMON
-	select KVM_GENERIC_MMU_NOTIFIER
 	select KVM_ELIDE_TLB_FLUSH_IF_YOUNG
 	select KVM_MMU_LOCKLESS_AGING
 	select HAVE_KVM_IRQCHIP
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d42a95cbcfbc..db9b6856f6cb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -253,7 +253,6 @@ bool kvm_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu);
 #endif
 
-#ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
 union kvm_mmu_notifier_arg {
 	unsigned long attributes;
 };
@@ -275,7 +274,6 @@ struct kvm_gfn_range {
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
-#endif
 
 enum {
 	OUTSIDE_GUEST_MODE,
@@ -849,13 +847,12 @@ struct kvm {
 	struct hlist_head irq_ack_notifier_list;
 #endif
 
-#ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
 	struct mmu_notifier mmu_notifier;
 	unsigned long mmu_invalidate_seq;
 	long mmu_invalidate_in_progress;
 	gfn_t mmu_invalidate_range_start;
 	gfn_t mmu_invalidate_range_end;
-#endif
+
 	struct list_head devices;
 	u64 manual_dirty_log_protect;
 	struct dentry *debugfs_dentry;
@@ -2118,7 +2115,6 @@ extern const struct _kvm_stats_desc kvm_vm_stats_desc[];
 extern const struct kvm_stats_header kvm_vcpu_stats_header;
 extern const struct _kvm_stats_desc kvm_vcpu_stats_desc[];
 
-#ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
 static inline int mmu_invalidate_retry(struct kvm *kvm, unsigned long mmu_seq)
 {
 	if (unlikely(kvm->mmu_invalidate_in_progress))
@@ -2196,7 +2192,6 @@ static inline bool mmu_invalidate_retry_gfn_unsafe(struct kvm *kvm,
 
 	return READ_ONCE(kvm->mmu_invalidate_seq) != mmu_seq;
 }
-#endif
 
 #ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
 
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 267c7369c765..9e7d3553e6a7 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -93,24 +93,16 @@ config HAVE_KVM_PM_NOTIFIER
 config KVM_GENERIC_HARDWARE_ENABLING
        bool
 
-config KVM_GENERIC_MMU_NOTIFIER
-       select MMU_NOTIFIER
-       bool
-
 config KVM_ELIDE_TLB_FLUSH_IF_YOUNG
-       depends on KVM_GENERIC_MMU_NOTIFIER
        bool
 
 config KVM_MMU_LOCKLESS_AGING
-       depends on KVM_GENERIC_MMU_NOTIFIER
        bool
 
 config KVM_GENERIC_MEMORY_ATTRIBUTES
-       depends on KVM_GENERIC_MMU_NOTIFIER
        bool
 
 config KVM_GUEST_MEMFD
-       depends on KVM_GENERIC_MMU_NOTIFIER
        select XARRAY_MULTI
        bool
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 61dca8d37abc..bf5606d76f0c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -502,7 +502,6 @@ void kvm_destroy_vcpus(struct kvm *kvm)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_destroy_vcpus);
 
-#ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
 static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
 {
 	return container_of(mn, struct kvm, mmu_notifier);
@@ -901,15 +900,6 @@ static int kvm_init_mmu_notifier(struct kvm *kvm)
 	return mmu_notifier_register(&kvm->mmu_notifier, current->mm);
 }
 
-#else  /* !CONFIG_KVM_GENERIC_MMU_NOTIFIER */
-
-static int kvm_init_mmu_notifier(struct kvm *kvm)
-{
-	return 0;
-}
-
-#endif /* CONFIG_KVM_GENERIC_MMU_NOTIFIER */
-
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 static int kvm_pm_notifier_call(struct notifier_block *bl,
 				unsigned long state,
@@ -1226,10 +1216,8 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 out_err_no_debugfs:
 	kvm_coalesced_mmio_free(kvm);
 out_no_coalesced_mmio:
-#ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
 	if (kvm->mmu_notifier.ops)
 		mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
-#endif
 out_err_no_mmu_notifier:
 	kvm_disable_virtualization();
 out_err_no_disable:
@@ -1292,7 +1280,6 @@ static void kvm_destroy_vm(struct kvm *kvm)
 		kvm->buses[i] = NULL;
 	}
 	kvm_coalesced_mmio_free(kvm);
-#ifdef CONFIG_KVM_GENERIC_MMU_NOTIFIER
 	mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
 	/*
 	 * At this point, pending calls to invalidate_range_start()
@@ -1311,9 +1298,6 @@ static void kvm_destroy_vm(struct kvm *kvm)
 		kvm->mn_active_invalidate_count = 0;
 	else
 		WARN_ON(kvm->mmu_invalidate_in_progress);
-#else
-	kvm_flush_shadow_all(kvm);
-#endif
 	kvm_arch_destroy_vm(kvm);
 	kvm_destroy_devices(kvm);
 	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
-- 
2.52.0


