Return-Path: <kvm+bounces-26311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BADA1973D52
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:34:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DEBA21C247A9
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:34:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CACA11A4F2A;
	Tue, 10 Sep 2024 16:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="vxctVS38"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CBB1A3BD3;
	Tue, 10 Sep 2024 16:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.190.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725985896; cv=none; b=PpcNJAqWUOKaNz3L06XRUewK8OWOd8OkuYBjhLKlCTKR0E/8QDTCW+CAgQFrRov1fdPVcb8GpW/J6L0Oa1OqllPu+wrRMAyLccR3971BouPRvzvGEWTR4r2sHM63yYnTxVzHVAdrYyWHcs79QyC9ICWqkl1OiaBGhILxrH968aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725985896; c=relaxed/simple;
	bh=KuKlPSFBk+6o2cA7opO9wLlxrDIRu2/Eon9+LUTmQ8c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cd92UtdUtLTGa1T/h1OhBvVEgjTvxMavABZe1Cnh4oTEc2xKz4KP+eS8v31t3V+WjVpD+jM2296LyCO1zdC54xOQONmZDr3/7LZLz/eYQ/T5IepWUbWsEnX2mZSvRHvEi/pGsgmFOjFHkgg/I5I4mGNQdWObJM2yLMhD1hs9jLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=vxctVS38; arc=none smtp.client-ip=207.171.190.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1725985895; x=1757521895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=umyhObMpA1DDGyKFrbGuBdzuz/jHr6ecIUxm4GlHskc=;
  b=vxctVS38/4rbtRl6GfW+W4P4w53xJpkOSXpta4LeJFkol9TZQWBd64fK
   sc0n4Xy0wD+CotskhTLU8vE4Kop3cvVgnWy83NIN4zCv/O0KPNYVgLrzC
   ebQfH+iE/XLDsnkO9PDhsl4m3wjKRYxNOHM6AP2840yVI7m1eQgWYP/9T
   Q=;
X-IronPort-AV: E=Sophos;i="6.10,217,1719878400"; 
   d="scan'208";a="367280463"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 16:31:33 +0000
Received: from EX19MTAUEC001.ant.amazon.com [10.0.44.209:40383]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.48.28:2525] with esmtp (Farcaster)
 id f846bd55-b4c7-479e-9859-a7c32f90264a; Tue, 10 Sep 2024 16:31:31 +0000 (UTC)
X-Farcaster-Flow-ID: f846bd55-b4c7-479e-9859-a7c32f90264a
Received: from EX19D008UEA004.ant.amazon.com (10.252.134.191) by
 EX19MTAUEC001.ant.amazon.com (10.252.135.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 10 Sep 2024 16:31:25 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D008UEA004.ant.amazon.com (10.252.134.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 10 Sep 2024 16:31:25 +0000
Received: from ua2d7e1a6107c5b.home (172.19.88.180) by mail-relay.amazon.com
 (10.250.64.254) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Tue, 10 Sep 2024 16:31:21 +0000
From: Patrick Roy <roypat@amazon.co.uk>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <rostedt@goodmis.org>,
	<mhiramat@kernel.org>, <mathieu.desnoyers@efficios.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <quic_eberman@quicinc.com>,
	<dwmw@amazon.com>, <david@redhat.com>, <tabba@google.com>, <rppt@kernel.org>,
	<linux-mm@kvack.org>, <dmatlack@google.com>
CC: Patrick Roy <roypat@amazon.co.uk>, <graf@amazon.com>,
	<jgowans@amazon.com>, <derekmn@amazon.com>, <kalyazin@amazon.com>,
	<xmarcalx@amazon.com>
Subject: [RFC PATCH v2 07/10] kvm: pfncache: invalidate when memory attributes change
Date: Tue, 10 Sep 2024 17:30:33 +0100
Message-ID: <20240910163038.1298452-8-roypat@amazon.co.uk>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910163038.1298452-1-roypat@amazon.co.uk>
References: <20240910163038.1298452-1-roypat@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain

Invalidate gfn_to_pfn_caches when the memory attributes of the gfn it
contains change.

Since gfn_to_pfn_caches are not hooked up to KVM's MMU notifiers, but
rather have to be invalidated right _before_ KVM's MMU notifiers are
triggers, adopt the approach used by
kvm_mmu_notifier_invalidate_range_start for invalidating gpcs inside
kvm_vm_set_mem_attributes.

Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      |  5 +++++
 virt/kvm/kvm_mm.h        | 10 +++++++++
 virt/kvm/pfncache.c      | 45 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 61 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cd28eb34aaeb1..7d36164a2cee5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -840,6 +840,7 @@ struct kvm {
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
 	/* Protected by slots_locks (for writes) and RCU (for reads) */
 	struct xarray mem_attr_array;
+	bool attribute_change_in_progress;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
 };
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 13347fb03d4a9..183f7ce57a428 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2533,6 +2533,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 
 	mutex_lock(&kvm->slots_lock);
 
+
 	/* Nothing to do if the entire range as the desired attributes. */
 	if (kvm_range_has_memory_attributes(kvm, start, end, attributes))
 		goto out_unlock;
@@ -2547,6 +2548,9 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 			goto out_unlock;
 	}
 
+	kvm->attribute_change_in_progress = true;
+	gfn_to_pfn_cache_invalidate_gfns_start(kvm, start, end);
+
 	kvm_handle_gfn_range(kvm, &pre_set_range);
 
 	for (i = start; i < end; i++) {
@@ -2558,6 +2562,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	kvm_handle_gfn_range(kvm, &post_set_range);
 
 out_unlock:
+	kvm->attribute_change_in_progress = false;
 	mutex_unlock(&kvm->slots_lock);
 
 	return r;
diff --git a/virt/kvm/kvm_mm.h b/virt/kvm/kvm_mm.h
index 715f19669d01f..5a53d888e4b18 100644
--- a/virt/kvm/kvm_mm.h
+++ b/virt/kvm/kvm_mm.h
@@ -27,12 +27,22 @@ kvm_pfn_t hva_to_pfn(unsigned long addr, bool atomic, bool interruptible,
 void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
 				       unsigned long start,
 				       unsigned long end);
+
+void gfn_to_pfn_cache_invalidate_gfns_start(struct kvm *kvm,
+					    gfn_t start,
+					    gfn_t end);
 #else
 static inline void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm,
 						     unsigned long start,
 						     unsigned long end)
 {
 }
+
+static inline void gfn_to_pfn_cache_invalidate_gfns_start(struct kvm *kvm,
+							  gfn_t start,
+							  gfn_t end)
+{
+}
 #endif /* HAVE_KVM_PFNCACHE */
 
 #ifdef CONFIG_KVM_PRIVATE_MEM
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index f0039efb9e1e3..6de934a8a153f 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -57,6 +57,43 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 	spin_unlock(&kvm->gpc_lock);
 }
 
+/*
+ * Identical to `gfn_to_pfn_cache_invalidate_start`, except based on gfns
+ * instead of uhvas.
+ */
+void gfn_to_pfn_cache_invalidate_gfns_start(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	struct gfn_to_pfn_cache *gpc;
+
+	spin_lock(&kvm->gpc_lock);
+	list_for_each_entry(gpc, &kvm->gpc_list, list) {
+		read_lock_irq(&gpc->lock);
+
+		/*
+		 * uhva based gpcs must not be used with gmem enabled memslots
+		 */
+		if (kvm_is_error_gpa(gpc->gpa)) {
+			read_unlock_irq(&gpc->lock);
+			continue;
+		}
+
+		if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
+		    gpa_to_gfn(gpc->gpa) >= start && gpa_to_gfn(gpc->gpa) < end) {
+			read_unlock_irq(&gpc->lock);
+
+			write_lock_irq(&gpc->lock);
+			if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
+			    gpa_to_gfn(gpc->gpa) >= start && gpa_to_gfn(gpc->gpa) < end)
+				gpc->valid = false;
+			write_unlock_irq(&gpc->lock);
+			continue;
+		}
+
+		read_unlock_irq(&gpc->lock);
+	}
+	spin_unlock(&kvm->gpc_lock);
+}
+
 static bool kvm_gpc_is_valid_len(gpa_t gpa, unsigned long uhva,
 				 unsigned long len)
 {
@@ -141,6 +178,14 @@ static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long mmu_s
 	if (kvm->mn_active_invalidate_count)
 		return true;
 
+	/*
+	 * Similarly to the above, attribute_change_in_progress is set
+	 * before gfn_to_pfn_cache_invalidate_start is called in
+	 * kvm_vm_set_mem_attributes, and isn't cleared until after
+	 * mmu_invalidate_seq is updated.
+	 */
+	if (kvm->attribute_change_in_progress)
+		return true;
 	/*
 	 * Ensure mn_active_invalidate_count is read before
 	 * mmu_invalidate_seq.  This pairs with the smp_wmb() in
-- 
2.46.0


