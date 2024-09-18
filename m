Return-Path: <kvm+bounces-27090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B1F597BE9D
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 17:29:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A7D11F226E8
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 15:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A64B1C9DEB;
	Wed, 18 Sep 2024 15:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="NHt6AG5D"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ED01C986A
	for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 15:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726673307; cv=none; b=Zd1TfEe4n0S25fAm7iLJEiJYu/n24FSz0bzyC+tqcjw6bc1PnU9PKMak41qefIDQbqgRC4hGdnQI7LTK6ayWLpUuBdU+XzuT1JaCDC7/cGvDX20GKpkCzaE3YDLOHcFJigthMcsZ9p6Uq6P+4sd27DgeoGgoU/k48QuemxiLI54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726673307; c=relaxed/simple;
	bh=Dnu2rnTshkRWcEVY9gMfGWqdViekhOAZM7F8/BSlsLs=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pGwUCEEAT2NiOylbdaxDgaOjJgBoS4umDjG8fAYlKLEcVrTlSamCMNFom4B/OzNndGvemfChAGffL6xhNoOeAiXSktS5TN5qlwEj9ekd0yrt+APyB7NUvTnA2YqX1d7qcov8xcvTjMuei89+NvP7RjPF9dKoP9CGIop+lMpj8yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=NHt6AG5D; arc=none smtp.client-ip=207.171.188.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726673306; x=1758209306;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=m9B4SiInU9rOI1ITAfRDRhI4QCBJrIfBHpaGOqadohU=;
  b=NHt6AG5DVBYS/VNHUUyoWJhQRzr4ZEXsEP9lW7IsiMtmZtGL0wT+z88e
   zOuXRqBjfn0tWi/WQipoai5vUhXLLnvyeq2bQz9rp/nTcb6cZWgQC4Vee
   4uMpEOmY/rdEC5Q7LzrCKs0VYwpSU2XNozrVJedCE4BjvHqNzF2oqLn98
   E=;
X-IronPort-AV: E=Sophos;i="6.10,239,1719878400"; 
   d="scan'208";a="761234704"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 15:28:18 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.10.100:30946]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.17.12:2525] with esmtp (Farcaster)
 id 7ba2c8b8-2c15-4fc6-9db5-2b8ff092fee0; Wed, 18 Sep 2024 15:28:17 +0000 (UTC)
X-Farcaster-Flow-ID: 7ba2c8b8-2c15-4fc6-9db5-2b8ff092fee0
Received: from EX19D018EUA002.ant.amazon.com (10.252.50.146) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 18 Sep 2024 15:28:17 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D018EUA002.ant.amazon.com (10.252.50.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 18 Sep 2024 15:28:16 +0000
Received: from email-imr-corp-prod-iad-all-1a-93a35fb4.us-east-1.amazon.com
 (10.25.36.214) by mail-relay.amazon.com (10.250.64.254) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Wed, 18 Sep 2024 15:28:16 +0000
Received: from dev-dsk-lilitj-1a-5039c68b.eu-west-1.amazon.com (dev-dsk-lilitj-1a-5039c68b.eu-west-1.amazon.com [172.19.104.233])
	by email-imr-corp-prod-iad-all-1a-93a35fb4.us-east-1.amazon.com (Postfix) with ESMTPS id 243CA4063B;
	Wed, 18 Sep 2024 15:28:15 +0000 (UTC)
From: Lilit Janpoladyan <lilitj@amazon.com>
To: <kvm@vger.kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<james.morse@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<nh-open-source@amazon.com>, <lilitj@amazon.com>
Subject: [PATCH 3/8] KVM: arm64: use page tracking interface to enable dirty logging
Date: Wed, 18 Sep 2024 15:28:02 +0000
Message-ID: <20240918152807.25135-4-lilitj@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240918152807.25135-1-lilitj@amazon.com>
References: <20240918152807.25135-1-lilitj@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

If page tracking device is available, use it to enable and disable
hardware dirty tracking. Allocate a tracking context on the first dirty
logging enablement (for the first memslot) and deallocate the context
when dirty logging is off for the VMID.

Allocation and use of the context is not synchronized as they are done
from the VM ioctls.

Signed-off-by: Lilit Janpoladyan <lilitj@amazon.com>
---
 arch/arm64/include/asm/kvm_host.h |  5 +++
 arch/arm64/kvm/arm.c              | 54 +++++++++++++++++++++++++++++++
 arch/mips/kvm/mips.c              | 10 ++++++
 arch/powerpc/kvm/book3s.c         | 10 ++++++
 arch/powerpc/kvm/booke.c          | 10 ++++++
 arch/s390/kvm/kvm-s390.c          | 10 ++++++
 arch/x86/kvm/x86.c                | 10 ++++++
 include/linux/kvm_host.h          |  2 ++
 virt/kvm/kvm_main.c               | 19 +++++++----
 9 files changed, 123 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5b5e3647fbda..db9bf42123e1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -377,6 +377,11 @@ struct kvm_arch {
 	 * the associated pKVM instance in the hypervisor.
 	 */
 	struct kvm_protected_vm pkvm;
+
+	/*
+	 * Stores page tracking context if page tracking device is in use
+	 */
+	void *page_tracking_ctx;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index aea56df8ac04..c8dcf719ee99 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -267,6 +267,9 @@ static void kvm_destroy_mpidr_data(struct kvm *kvm)
  */
 void kvm_arch_destroy_vm(struct kvm *kvm)
 {
+	if (kvm->arch.page_tracking_ctx)
+		page_tracking_release(kvm->arch.page_tracking_ctx);
+
 	bitmap_free(kvm->arch.pmu_filter);
 	free_cpumask_var(kvm->arch.supported_cpus);
 
@@ -1816,6 +1819,57 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	return r;
 }
 
+int kvm_arch_enable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *memslot)
+{
+	void *ctx = NULL;
+	struct pt_config config;
+	int r;
+
+	if (!page_tracking_device_registered())
+		return 0;
+
+	if (!kvm->arch.page_tracking_ctx) {
+		config.vmid = (u32)kvm->arch.mmu.vmid.id.counter;
+		config.mode = dirty_pages;
+		ctx = page_tracking_allocate(config);
+		if (!ctx)
+			return -ENOENT;
+
+		kvm->arch.page_tracking_ctx = ctx;
+	}
+
+	r = page_tracking_enable(kvm->arch.page_tracking_ctx, -1);
+
+	if (r) {
+		if (ctx) {
+			page_tracking_release(ctx);
+			kvm->arch.page_tracking_ctx = NULL;
+		}
+	}
+	return r;
+}
+
+int kvm_arch_disable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *memslot)
+{
+	int r = 0;
+
+	if (!page_tracking_device_registered())
+		return 0;
+
+	if (!kvm->arch.page_tracking_ctx)
+		return -ENOENT;
+
+	r = page_tracking_disable(kvm->arch.page_tracking_ctx, -1);
+
+	if (r == -EBUSY) {
+		r = 0;
+	} else {
+		page_tracking_release(kvm->arch.page_tracking_ctx);
+		kvm->arch.page_tracking_ctx = NULL;
+	}
+	return r;
+}
+
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index b5de770b092e..edc6f473af4e 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -974,6 +974,16 @@ long kvm_arch_vcpu_ioctl(struct file *filp, unsigned int ioctl,
 	return r;
 }
 
+int kvm_arch_enable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *memslot)
+{
+	return 0;
+}
+
+int kvm_arch_disable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *memslot)
+{
+	return 0;
+}
+
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index ff6c38373957..4c4a3ecc301c 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -844,6 +844,16 @@ int kvmppc_core_check_requests(struct kvm_vcpu *vcpu)
 	return vcpu->kvm->arch.kvm_ops->check_requests(vcpu);
 }
 
+int kvm_arch_enable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *memslot)
+{
+	return 0;
+}
+
+int kvm_arch_disable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *memslot)
+{
+	return 0;
+}
+
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index 6a5be025a8af..f263ebc8fa49 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -1814,6 +1814,16 @@ int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
 	return r;
 }
 
+int kvm_arch_enable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *memslot)
+{
+	return -EOPNOTSUPP;
+}
+
+int kvm_arch_disable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *memslot)
+{
+	return -EOPNOTSUPP;
+}
+
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 0fd96860fc45..d6a8f7dbc644 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -667,6 +667,16 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	return r;
 }
 
+int kvm_arch_enable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *memslot)
+{
+	return 0;
+}
+
+int kvm_arch_disable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *memslot)
+{
+	return 0;
+}
+
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 	int i;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c983c8e434b8..1be8bacfe2bd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6488,6 +6488,16 @@ static int kvm_vm_ioctl_reinject(struct kvm *kvm,
 	return 0;
 }
 
+int kvm_arch_enable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *memslot)
+{
+	return 0;
+}
+
+int kvm_arch_disable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *memslot)
+{
+	return 0;
+}
+
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0d5125a3e31a..ae905f54ec47 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1475,6 +1475,8 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 					struct kvm_memory_slot *slot,
 					gfn_t gfn_offset,
 					unsigned long mask);
+int kvm_arch_enable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *memslot);
+int kvm_arch_disable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *memslot);
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot);
 
 #ifndef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cb2b78e92910..1fd5e234c188 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1689,11 +1689,12 @@ static int kvm_prepare_memory_region(struct kvm *kvm,
 	return r;
 }
 
-static void kvm_commit_memory_region(struct kvm *kvm,
-				     struct kvm_memory_slot *old,
-				     const struct kvm_memory_slot *new,
-				     enum kvm_mr_change change)
+static int kvm_commit_memory_region(struct kvm *kvm,
+				    struct kvm_memory_slot *old,
+				    const struct kvm_memory_slot *new,
+				    enum kvm_mr_change change)
 {
+	int r;
 	int old_flags = old ? old->flags : 0;
 	int new_flags = new ? new->flags : 0;
 	/*
@@ -1709,6 +1710,10 @@ static void kvm_commit_memory_region(struct kvm *kvm,
 		int change = (new_flags & KVM_MEM_LOG_DIRTY_PAGES) ? 1 : -1;
 		atomic_set(&kvm->nr_memslots_dirty_logging,
 			   atomic_read(&kvm->nr_memslots_dirty_logging) + change);
+		if (change > 0)
+			r = kvm_arch_enable_dirty_logging(kvm, new);
+		else
+			r = kvm_arch_disable_dirty_logging(kvm, new);
 	}
 
 	kvm_arch_commit_memory_region(kvm, old, new, change);
@@ -1740,6 +1745,8 @@ static void kvm_commit_memory_region(struct kvm *kvm,
 	default:
 		BUG();
 	}
+
+	return r;
 }
 
 /*
@@ -1954,9 +1961,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 	 * will directly hit the final, active memslot.  Architectures are
 	 * responsible for knowing that new->arch may be stale.
 	 */
-	kvm_commit_memory_region(kvm, old, new, change);
-
-	return 0;
+	return kvm_commit_memory_region(kvm, old, new, change);
 }
 
 static bool kvm_check_memslot_overlap(struct kvm_memslots *slots, int id,
-- 
2.40.1


