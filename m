Return-Path: <kvm+bounces-27084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E936B97BE97
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 17:28:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 124381C2148C
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 15:28:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FF1B1C9842;
	Wed, 18 Sep 2024 15:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="QUFpfKnG"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E741BAEF4
	for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 15:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726673301; cv=none; b=AnTe110FQh5RGtl6OTKYq8uhbZLAM0Pma1WZhKOISSAjwD8MZqRQiYBbW4aOg/SfeOHXiVn0wV67lS1wR1k6r/ppLLBPko9DQJ75V4JRf6ikJeJZ0kJ0fmPM0svFiyn1Ijwdt2G7kfuKGa0jRLoGCqgklaQ4dPU1oEMPcFmDYAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726673301; c=relaxed/simple;
	bh=GfPly/xfwNMZhmZd7O6Pa9rAtpA7qbVNaVYH8vNIrew=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aZZ1E6IeDui2EBZ88fZoFd5Fm5oVO9/CMPeOA7Q/znTuMJlBPdSM1/ovv64saMwUWlXFNVUeZlmtTTb80iDLhXDpY4lbf/uZiQlpiIcG9ZHKJYL4QvZUAJTq8YUqbFbtXEP9B0eAsg89/N5kk4wJNEXK0dDR/GKKe/aRCrO61kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=QUFpfKnG; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726673300; x=1758209300;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=xNhiMTqaGcTO02GCyyfzFGUNlD6mif6/4fY2DqZbTcA=;
  b=QUFpfKnGtcsJMcmhqqyqynonpxW1iDQYicAfEmlr/tnqOfpWUDHrrBkr
   4uqeiB+jxSUO4FQ7HTS3BDQ7BGJ0nvCJgWIppXRGAhh3Om2MYXZ0bqqiN
   0RSxBq4Cn3Af+ItncTZSY+opAabBUhgh0lXg2VBrP9poFulKjM1vtAl+j
   c=;
X-IronPort-AV: E=Sophos;i="6.10,239,1719878400"; 
   d="scan'208";a="127584763"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 15:28:18 +0000
Received: from EX19MTAEUA002.ant.amazon.com [10.0.43.254:29472]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.17.12:2525] with esmtp (Farcaster)
 id 0af88632-bff0-4ba6-af68-ea5498bad667; Wed, 18 Sep 2024 15:28:17 +0000 (UTC)
X-Farcaster-Flow-ID: 0af88632-bff0-4ba6-af68-ea5498bad667
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 18 Sep 2024 15:28:17 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D018EUA004.ant.amazon.com (10.252.50.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 18 Sep 2024 15:28:16 +0000
Received: from email-imr-corp-prod-iad-all-1a-93a35fb4.us-east-1.amazon.com
 (10.43.8.6) by mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Wed, 18 Sep 2024 15:28:16 +0000
Received: from dev-dsk-lilitj-1a-5039c68b.eu-west-1.amazon.com (dev-dsk-lilitj-1a-5039c68b.eu-west-1.amazon.com [172.19.104.233])
	by email-imr-corp-prod-iad-all-1a-93a35fb4.us-east-1.amazon.com (Postfix) with ESMTPS id F407F4041D;
	Wed, 18 Sep 2024 15:28:15 +0000 (UTC)
From: Lilit Janpoladyan <lilitj@amazon.com>
To: <kvm@vger.kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<james.morse@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<nh-open-source@amazon.com>, <lilitj@amazon.com>
Subject: [PATCH 4/8] KVM: return value from kvm_arch_sync_dirty_log
Date: Wed, 18 Sep 2024 15:28:03 +0000
Message-ID: <20240918152807.25135-5-lilitj@amazon.com>
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

Make kvm_arch_sync_dirty_log return a value, which is needed to
propagate errors that could happen when getting dirty pages via
a page tracking device.

Signed-off-by: Lilit Janpoladyan <lilitj@amazon.com>
---
 arch/loongarch/kvm/mmu.c  |  3 ++-
 arch/mips/kvm/mips.c      |  4 ++--
 arch/powerpc/kvm/book3s.c |  4 ++--
 arch/powerpc/kvm/booke.c  |  4 ++--
 arch/riscv/kvm/mmu.c      |  3 ++-
 arch/s390/kvm/kvm-s390.c  |  3 ++-
 arch/x86/kvm/x86.c        | 11 ++++++-----
 include/linux/kvm_host.h  |  2 +-
 virt/kvm/kvm_main.c       | 15 ++++++++++++---
 9 files changed, 31 insertions(+), 18 deletions(-)

diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 28681dfb4b85..825c60d35529 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -943,8 +943,9 @@ int kvm_handle_mm_fault(struct kvm_vcpu *vcpu, unsigned long gpa, bool write)
 	return 0;
 }
 
-void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
+int kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
+	return 0;
 }
 
 void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index edc6f473af4e..4326b8c721e9 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -984,9 +984,9 @@ int kvm_arch_disable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot
 	return 0;
 }
 
-void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
+int kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
-
+	return 0;
 }
 
 int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 4c4a3ecc301c..aab6f5c62aee 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -854,9 +854,9 @@ int kvm_arch_disable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot
 	return 0;
 }
 
-void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
+int kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
-
+	return 0;
 }
 
 int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index f263ebc8fa49..60629a320222 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -1824,9 +1824,9 @@ int kvm_arch_disable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot
 	return -EOPNOTSUPP;
 }
 
-void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
+int kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
-
+	return -EOPNOTSUPP;
 }
 
 int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index b63650f9b966..53ad23432b31 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -402,8 +402,9 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	gstage_wp_range(kvm, start, end);
 }
 
-void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
+int kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
+	return 0;
 }
 
 void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free)
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d6a8f7dbc644..5f1bb4bd4121 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -677,7 +677,7 @@ int kvm_arch_disable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot
 	return 0;
 }
 
-void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
+int kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 	int i;
 	gfn_t cur_gfn, last_gfn;
@@ -705,6 +705,7 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 			return;
 		cond_resched();
 	}
+	return 0;
 }
 
 /* Section: vm related */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1be8bacfe2bd..e95e070c9bf3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6498,7 +6498,7 @@ int kvm_arch_disable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot
 	return 0;
 }
 
-void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
+int kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
 
 	/*
@@ -6510,11 +6510,12 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 	struct kvm_vcpu *vcpu;
 	unsigned long i;
 
-	if (!kvm_x86_ops.cpu_dirty_log_size)
-		return;
+	if (kvm_x86_ops.cpu_dirty_log_size) {
+		kvm_for_each_vcpu(i, vcpu, kvm)
+			kvm_vcpu_kick(vcpu);
+	}
 
-	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvm_vcpu_kick(vcpu);
+	return 0;
 }
 
 int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_event,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ae905f54ec47..245b4172a7fb 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1477,7 +1477,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 					unsigned long mask);
 int kvm_arch_enable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *memslot);
 int kvm_arch_disable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *memslot);
-void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot);
+int kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot);
 
 #ifndef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
 int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1fd5e234c188..d55d92f599b0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2145,6 +2145,7 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
 	int i, as_id, id;
 	unsigned long n;
 	unsigned long any = 0;
+	int r;
 
 	/* Dirty ring tracking may be exclusive to dirty log tracking */
 	if (!kvm_use_dirty_bitmap(kvm))
@@ -2163,7 +2164,9 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
 	if (!(*memslot) || !(*memslot)->dirty_bitmap)
 		return -ENOENT;
 
-	kvm_arch_sync_dirty_log(kvm, *memslot);
+	r = kvm_arch_sync_dirty_log(kvm, *memslot);
+	if (r)
+		return r;
 
 	n = kvm_dirty_bitmap_bytes(*memslot);
 
@@ -2210,6 +2213,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 	unsigned long *dirty_bitmap;
 	unsigned long *dirty_bitmap_buffer;
 	bool flush;
+	int r;
 
 	/* Dirty ring tracking may be exclusive to dirty log tracking */
 	if (!kvm_use_dirty_bitmap(kvm))
@@ -2227,7 +2231,9 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 
 	dirty_bitmap = memslot->dirty_bitmap;
 
-	kvm_arch_sync_dirty_log(kvm, memslot);
+	r = kvm_arch_sync_dirty_log(kvm, memslot);
+	if (r)
+		return r;
 
 	n = kvm_dirty_bitmap_bytes(memslot);
 	flush = false;
@@ -2322,6 +2328,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	unsigned long *dirty_bitmap;
 	unsigned long *dirty_bitmap_buffer;
 	bool flush;
+	int r;
 
 	/* Dirty ring tracking may be exclusive to dirty log tracking */
 	if (!kvm_use_dirty_bitmap(kvm))
@@ -2349,7 +2356,9 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	    (log->num_pages < memslot->npages - log->first_page && (log->num_pages & 63)))
 	    return -EINVAL;
 
-	kvm_arch_sync_dirty_log(kvm, memslot);
+	r = kvm_arch_sync_dirty_log(kvm, memslot);
+	if (r)
+		return r;
 
 	flush = false;
 	dirty_bitmap_buffer = kvm_second_dirty_bitmap(memslot);
-- 
2.40.1


