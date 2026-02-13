Return-Path: <kvm+bounces-71068-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +BHhMn1Vj2lqQQEAu9opvQ
	(envelope-from <kvm+bounces-71068-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 17:46:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 469E11385AB
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 17:46:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 064E8301980F
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:46:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E0C83659E0;
	Fri, 13 Feb 2026 16:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SpBFEJ1l";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aJO69kzE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CCE3659F9
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 16:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771001206; cv=none; b=NBSvMns/dMGuYgMVBjJ2UT+eBG8+Mv3nr1Hf0JZJnq2WH+fBs8hm4NpwfSOAklVbA9GVhLIPHJRnBsoU4KIJkicBBD5e4zLRgyKSuvhseI6zXN3p2HLaIWPnoar3uJBmTcUXBz+N+mI6ez+IQ4Swxn5ZmgFlviypXQ0Hbo1ZmxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771001206; c=relaxed/simple;
	bh=27rVjBPXxz9GsYo6zYxVo4RSxaz61V7B8OpGTw3/foc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CznRuiQ6xXbsus8JPMuK4swmkpsF0hW5aEDgzvuXdSguY0rL+8f28XQskWo/Wp2jCdwZy1zzr3iJRmtmbSLk2LOYhYMWPNtxsd664oBGS4FHyxChGGfcBCQChlGtRnQEWwRf08MZY63gtVV2lzpsCvvfcan4xtVrOeXQEl4EhLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SpBFEJ1l; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aJO69kzE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771001202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OiMU1K8Q+G3NNaqVMsfaJgjScBXnkEWAPz5l7NAIjWM=;
	b=SpBFEJ1lMjHf2M7m5U2AHaLx+gsDLOga+fDbzTLQKOt2H62wgmpSsMLXW+hot11KDIqyr2
	MISHHDW40N0ZzMDyCb3HSXduK4kGigpmPTgLLXP09cTSDSAV8K4D9t1kF5Od+DyCDMlmUX
	2Y+lqCrl3yNeStQwMCRwP6fcz37cM0A=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-307-_2D7WqAXP0aH7kPXEjvV9g-1; Fri, 13 Feb 2026 11:46:40 -0500
X-MC-Unique: _2D7WqAXP0aH7kPXEjvV9g-1
X-Mimecast-MFC-AGG-ID: _2D7WqAXP0aH7kPXEjvV9g_1771001200
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4832c4621c2so12797125e9.3
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 08:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771001199; x=1771605999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OiMU1K8Q+G3NNaqVMsfaJgjScBXnkEWAPz5l7NAIjWM=;
        b=aJO69kzEdAw4j2bkvNgr0+roHW/7mjdU+XAAZpK+KGyD7CoYo8THeDCM6Y9JnC9wI6
         vsIWyVZpYSK7FQKutFVVBb0JmzZ/luTLxS7qNEce0wkj7c3evjiAGegFbB5mmuN6Siha
         pN5iCWdwCGOsZFqx3OugJ7rwnFqS1YahhW2pmuvPIMttUEqhyunyqs/RvR3RYjPZ4iNW
         cNL/3oZr6SdJi6h9etiPxVJA0FFKPuIex/2JHOOHOJAwSHwtNUkcmHz4pX4qsDSJCJRA
         OSLkMKx3uxf4/kfLI76AOPqSbY2j+FtxHV1lzpremhzh958NsDASw0sOvLqTr6MZ870S
         2SWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771001199; x=1771605999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OiMU1K8Q+G3NNaqVMsfaJgjScBXnkEWAPz5l7NAIjWM=;
        b=agf4iZh83KLT1SFDs1/tI/qdXRmByWmVYLrIvwOKnSmQdmY524oM6anPIhJwBzdPqW
         uY32qUzty962DfR+C+E6soMyEixel3P/6qualEop2gJKswW+SAu9BZBl+I9RUAgDQP/g
         qJg9fAVWlJUhC4Ciww/+SuRcP6CA3YFpf/CtD+7E4Jp2tihDoDRsLl01ImEiOQ0kDCeN
         GEpCSJgY2CAFPbI6s8yent1/Bwx9FDbToKhTtg1PP3MREQOYxxenu6WzeKe3YXMBq7XK
         D1nwS2ns/oeoh0RuVNv4voEzE5Wt2RuIGda2YMhhzRzSDrfqojj0Y0ySEfXuacprP7ZC
         xU8w==
X-Forwarded-Encrypted: i=1; AJvYcCXhWFTGDrVuOO0IwHFHy96bY9u8qSsHIQZDttsvDkaaiC90mbTt7DKs3r0xmLhtpaPzgL8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+IY+TINooqU8QzZKwnMSmdnwZOJ7LeHfmmYwNschKz2iqNtvH
	eCElNr+yVrwxwjQ2szHVJHJsqNt+AnE1FHIgcktbWTXcKgFZAWRylGKIxWn7kwkVC/q7yXWaIzW
	KvnLBVerPVQ0ta/9tXy5ZolAm6XUEQbVJ6SGdVBiTseourA47z7cDkMRhBlm1pw==
X-Gm-Gg: AZuq6aK61/Og9bJwFaeMMrUn95vchsAyjaEORbvh3vLfBHMxH2B7bGCzaY6ySOQALx8
	4G1/+V5czvuOiSZaidcYpwP55Uls6KY40it7ZbVLggnr4Shh45RewFTe9uTYZi/m6NLJO5VPEB4
	0hpAzESk/aya4BVA94/Km1IFeGgWoY+i8iTCr+aEwlq/A22V5kvnz4FSyXQTkbGfhw0Vl+yFmh8
	mqA1kV9oNpCTc9wSauWfUvlsVV3XsmM0AzMF1Oh6O0lsHq2Nft7ZPCJTm+60MB4s9quSPWbU40r
	Qsh97vNYZg3H8C/fFVGb19wgUSbp4RoglroVFZ90KKwBQa8hWE/pb4tdMZQnXi0IrC/fI8WBsan
	u0WTkhMfuZa+TNlRtkT52oG3Vlrn3dfy1tGTFX+xA6JBjHycKvPZyrmoOt2Z+3w1Z1ev/lrV31/
	2y75EQfNakHBUqrPmaDk+vSvejkA==
X-Received: by 2002:a05:600c:3f0c:b0:47d:5e02:14e5 with SMTP id 5b1f17b1804b1-483739ffa1emr40293345e9.5.1771001199063;
        Fri, 13 Feb 2026 08:46:39 -0800 (PST)
X-Received: by 2002:a05:600c:3f0c:b0:47d:5e02:14e5 with SMTP id 5b1f17b1804b1-483739ffa1emr40292905e9.5.1771001198569;
        Fri, 13 Feb 2026 08:46:38 -0800 (PST)
Received: from [192.168.10.48] ([151.61.26.160])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4834d82a4afsm492647105e9.11.2026.02.13.08.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Feb 2026 08:46:38 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH v2 1/2] KVM: remove CONFIG_KVM_GENERIC_MMU_NOTIFIER
Date: Fri, 13 Feb 2026 17:46:34 +0100
Message-ID: <20260213164635.33630-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260213164635.33630-1-pbonzini@redhat.com>
References: <20260213164635.33630-1-pbonzini@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71068-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 469E11385AB
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
 arch/s390/kvm/Kconfig      |  2 --
 arch/x86/kvm/Kconfig       |  1 -
 include/linux/kvm_host.h   |  7 +------
 virt/kvm/Kconfig           |  9 +--------
 virt/kvm/kvm_main.c        | 16 ----------------
 11 files changed, 2 insertions(+), 42 deletions(-)

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
index 917ac740513e..5b835bc6a194 100644
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -28,9 +28,7 @@ config KVM
 	select HAVE_KVM_INVALID_WAKEUPS
 	select HAVE_KVM_NO_POLL
 	select KVM_VFIO
-	select MMU_NOTIFIER
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
index 267c7369c765..794976b88c6f 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -5,6 +5,7 @@ config KVM_COMMON
        bool
        select EVENTFD
        select INTERVAL_TREE
+       select MMU_NOTIFIER
        select PREEMPT_NOTIFIERS
 
 config HAVE_KVM_PFNCACHE
@@ -93,24 +94,16 @@ config HAVE_KVM_PM_NOTIFIER
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


