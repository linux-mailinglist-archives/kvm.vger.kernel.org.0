Return-Path: <kvm+bounces-27089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37F0297BE9C
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 17:29:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B9651C219A7
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 15:29:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21BDA1C9DE8;
	Wed, 18 Sep 2024 15:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="gJBO30TQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8784F1C9863
	for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 15:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.95.49.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726673307; cv=none; b=YKEzWv6BtpiF9brANRORd6UhqaQVVzrnwVr17sDLRtz+5AazbDm9gjJnFBQdGf+oIUeqcvGxcgw0HrrYBApDJlbp5ucGf+dJMjEu4wF+FwFmyApv/quzFvJ2y5wAUFxTl12ae/sri1e+FkEQHTw7LvXFZXMPyUOye8DuFDSvk/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726673307; c=relaxed/simple;
	bh=nXvFGyAITAu4ekprdmS+sLhABiY4x0FQ60YvS6VUg5k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HVr/HsSNtywZLbWhy1pSpqy6VW46KYZRk4nS+WZnRUYZWb1TbSLB5rJ6ow9nDcb0+Pv6MvZ48mYp0ImtXBMThPTJzk9/Ch3CqjKeCErw7aZGzx1pdk1oX4N9mY5Gec4AEEkBRQhGPTHsJWtV6OoH4WlghR43jkseHrNguiuHygo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=gJBO30TQ; arc=none smtp.client-ip=52.95.49.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726673306; x=1758209306;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=8XYY163qVrhuzbZHidEl0QQXvKIZLmTJ/Kwsl2aJs0Y=;
  b=gJBO30TQCceMiMst61VbcI77TgU0/8xOsnmWuElX+MqxPn81q49sojVv
   RWCFpFdjrtAyuKRe/JD9BUBNUWsL2FnRlVdG6wAHHxcECN1h+yFOC0S6J
   fTlGV2PnBh340WmxnlGWvRR2jw1WvaOOtf9v2RuA4QZ28en/wtYrFUwZw
   c=;
X-IronPort-AV: E=Sophos;i="6.10,239,1719878400"; 
   d="scan'208";a="434305187"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 15:28:22 +0000
Received: from EX19MTAEUB001.ant.amazon.com [10.0.43.254:30066]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.41.159:2525] with esmtp (Farcaster)
 id fe3dd968-f541-43d1-af70-bc02ad3d8ab8; Wed, 18 Sep 2024 15:28:20 +0000 (UTC)
X-Farcaster-Flow-ID: fe3dd968-f541-43d1-af70-bc02ad3d8ab8
Received: from EX19D018EUC002.ant.amazon.com (10.252.51.143) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 18 Sep 2024 15:28:19 +0000
Received: from EX19MTAUWC001.ant.amazon.com (10.250.64.145) by
 EX19D018EUC002.ant.amazon.com (10.252.51.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 18 Sep 2024 15:28:19 +0000
Received: from email-imr-corp-prod-iad-all-1a-93a35fb4.us-east-1.amazon.com
 (10.25.36.210) by mail-relay.amazon.com (10.250.64.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Wed, 18 Sep 2024 15:28:18 +0000
Received: from dev-dsk-lilitj-1a-5039c68b.eu-west-1.amazon.com (dev-dsk-lilitj-1a-5039c68b.eu-west-1.amazon.com [172.19.104.233])
	by email-imr-corp-prod-iad-all-1a-93a35fb4.us-east-1.amazon.com (Postfix) with ESMTPS id CFCFC40421;
	Wed, 18 Sep 2024 15:28:16 +0000 (UTC)
From: Lilit Janpoladyan <lilitj@amazon.com>
To: <kvm@vger.kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<james.morse@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<nh-open-source@amazon.com>, <lilitj@amazon.com>
Subject: [PATCH 5/8] KVM: arm64: get dirty pages from the page tracking device
Date: Wed, 18 Sep 2024 15:28:04 +0000
Message-ID: <20240918152807.25135-6-lilitj@amazon.com>
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

If a page tracking device is available, use it in
kvm_arch_sync_dirty_log to read device dirty log and mark logged
pages as dirty. Allocate a page to use as a buffer for reading
device dirty log; the allocation and access to the page are not
synchronized - assumes that userspace won't try to enable/disable
dirty logging and read dirty log at the same time.

Signed-off-by: Lilit Janpoladyan <lilitj@amazon.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 +-
 arch/arm64/kvm/arm.c              | 46 ++++++++++++++++++++++++++++++-
 2 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index db9bf42123e1..a76f25d4d2bc 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -379,9 +379,10 @@ struct kvm_arch {
 	struct kvm_protected_vm pkvm;
 
 	/*
-	 * Stores page tracking context if page tracking device is in use
+	 * Stores page tracking context and buffer if page tracking device is in use
 	 */
 	void *page_tracking_ctx;
+	gpa_t *page_tracking_pg;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c8dcf719ee99..139d7e929266 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1822,6 +1822,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 int kvm_arch_enable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot *memslot)
 {
 	void *ctx = NULL;
+	unsigned long read_buffer;
 	struct pt_config config;
 	int r;
 
@@ -1836,16 +1837,31 @@ int kvm_arch_enable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot
 			return -ENOENT;
 
 		kvm->arch.page_tracking_ctx = ctx;
+
+		read_buffer = __get_free_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+		if (!read_buffer) {
+			r = -ENOMEM;
+			goto out_free;
+		}
+
+		kvm->arch.page_tracking_pg = (gpa_t *)read_buffer;
 	}
 
 	r = page_tracking_enable(kvm->arch.page_tracking_ctx, -1);
 
+out_free:
 	if (r) {
 		if (ctx) {
 			page_tracking_release(ctx);
 			kvm->arch.page_tracking_ctx = NULL;
 		}
+
+		if (read_buffer) {
+			free_page(read_buffer);
+			kvm->arch.page_tracking_pg = NULL;
+		}
 	}
+
 	return r;
 }
 
@@ -1866,13 +1882,41 @@ int kvm_arch_disable_dirty_logging(struct kvm *kvm, const struct kvm_memory_slot
 	} else {
 		page_tracking_release(kvm->arch.page_tracking_ctx);
 		kvm->arch.page_tracking_ctx = NULL;
+
+		if (kvm->arch.page_tracking_pg) {
+			free_page((unsigned long)kvm->arch.page_tracking_pg);
+			kvm->arch.page_tracking_pg = NULL;
+		}
 	}
 	return r;
 }
 
-void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
+int kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
+	int r;
+	u32 i;
+	u32 max_pages = PAGE_SIZE/sizeof(gpa_t);
 
+	if (!kvm->arch.page_tracking_ctx)
+		return 0;
+
+	if (!kvm->arch.page_tracking_pg)
+		return -ENOENT;
+
+	r = page_tracking_read_dirty_pages(kvm->arch.page_tracking_ctx, -1,
+					   kvm->arch.page_tracking_pg, max_pages);
+
+	while (r > 0) {
+		for (i = 0; i < r; ++i) {
+			u32 gfn =  kvm->arch.page_tracking_pg[i] >> PAGE_SHIFT;
+
+			memslot = gfn_to_memslot(kvm, gfn);
+			mark_page_dirty_in_slot(kvm, memslot, gfn);
+		}
+		r = page_tracking_read_dirty_pages(kvm->arch.page_tracking_ctx, -1,
+						   kvm->arch.page_tracking_pg, max_pages);
+	}
+	return r < 0 ? r : 0;
 }
 
 static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
-- 
2.40.1


