Return-Path: <kvm+bounces-26309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0B5A973D4C
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:33:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B5711F26B9B
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:33:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03E6D1A4AAA;
	Tue, 10 Sep 2024 16:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="L6P1N3zg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52003.amazon.com (smtp-fw-52003.amazon.com [52.119.213.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D241A3BBF;
	Tue, 10 Sep 2024 16:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725985892; cv=none; b=CleV3QRO+YT1194AegwfRizqrnMVWuuiLn2N8/diPrILdOcqDRERaGiW0+TNHY5NbPVzm/UYK5zMg2SChkbau9YXH/Er4NZGR4X24baso8W62u290bBaF4WLc1Li2+5BoowFkX1WVU4C9jUdJpvisD94odcWfeo1HCqz7KosNAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725985892; c=relaxed/simple;
	bh=8fLwxy/sXjJUCG6iZQqh0XVJKhqxL9wQGHAmt38CmPk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mXkj2Yoxc0WUSID/U1JcLNv11R6dcEBJ8jXfeIAsHnf2SiAmpE1r6WnZK4NU2CZcWkS9x6JnTCLC/ZqQaIyfWlFiFlzy7Yr7ZXcHXl3ANJKVxTenDqjytJQ9RKc7jDQuv5HhTrTyeecrwZSzhWYeFnDB+8Gni/qDHQ6SzHMkfxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=L6P1N3zg; arc=none smtp.client-ip=52.119.213.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1725985891; x=1757521891;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=O39OHNSY2jvqQ+6nIWGz3rExj3YlDzBo0CAgdRJUjCQ=;
  b=L6P1N3zgMWEd/s2Vu6hq9O4Ld34W5/HIf2n0JjEnLv5o1x/hrnr7awt5
   1MKTVsaRVUE2XEYbbdpM2+vqCXbI4Jd2u7fmI9qn/S8gAnrNRjmmjZJMY
   bq1nMej7iESpy2ksQGwl1Nb4t1/4IGIzlk4rudmdyYc335eTX/z595tEX
   A=;
X-IronPort-AV: E=Sophos;i="6.10,217,1719878400"; 
   d="scan'208";a="24649840"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52003.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 16:31:26 +0000
Received: from EX19MTAUEC002.ant.amazon.com [10.0.0.204:15768]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.46.235:2525] with esmtp (Farcaster)
 id a66d20fe-467b-4f84-9176-15708e5e7cff; Tue, 10 Sep 2024 16:31:25 +0000 (UTC)
X-Farcaster-Flow-ID: a66d20fe-467b-4f84-9176-15708e5e7cff
Received: from EX19D008UEA004.ant.amazon.com (10.252.134.191) by
 EX19MTAUEC002.ant.amazon.com (10.252.135.253) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 10 Sep 2024 16:31:20 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D008UEA004.ant.amazon.com (10.252.134.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 10 Sep 2024 16:31:19 +0000
Received: from ua2d7e1a6107c5b.home (172.19.88.180) by mail-relay.amazon.com
 (10.250.64.254) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Tue, 10 Sep 2024 16:31:15 +0000
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
Subject: [RFC PATCH v2 06/10] kvm: gmem: add tracepoints for gmem share/unshare
Date: Tue, 10 Sep 2024 17:30:32 +0100
Message-ID: <20240910163038.1298452-7-roypat@amazon.co.uk>
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

Add tracepoints for calls to kvm_gmem_get_folio that cause the returned
folio to be considered "shared" (e.g. accessible by host KVM), and
tracepoint for when KVM is done accessing a gmem pfn
(kvm_gmem_put_shared_pfn).

The above operations can cause folios to be insert/removed into/from the
direct map. We want to be able to make sure that only those gmem folios
that we expect KVM to access are ever reinserted into the direct map,
and that all folios that are temporarily reinserted are also removed
again at a later point. Processing ftrace output is one way to verify
this.

Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
---
 include/trace/events/kvm.h | 43 ++++++++++++++++++++++++++++++++++++++
 virt/kvm/guest_memfd.c     |  7 ++++++-
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 74e40d5d4af42..4a40fd4c22f91 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -489,6 +489,49 @@ TRACE_EVENT(kvm_test_age_hva,
 	TP_printk("mmu notifier test age hva: %#016lx", __entry->hva)
 );
 
+#ifdef CONFIG_KVM_PRIVATE_MEM
+TRACE_EVENT(kvm_gmem_share,
+	TP_PROTO(struct folio *folio, pgoff_t index),
+	TP_ARGS(folio, index),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, sharing_count)
+		__field(kvm_pfn_t, pfn)
+		__field(pgoff_t, index)
+		__field(unsigned long,  npages)
+	),
+
+	TP_fast_assign(
+		__entry->sharing_count = refcount_read(folio_get_private(folio));
+		__entry->pfn = folio_pfn(folio);
+		__entry->index = index;
+		__entry->npages = folio_nr_pages(folio);
+	),
+
+	TP_printk("pfn=0x%llx index=%lu pages=%lu (refcount now %d)",
+	          __entry->pfn, __entry->index, __entry->npages, __entry->sharing_count - 1)
+);
+
+TRACE_EVENT(kvm_gmem_unshare,
+	TP_PROTO(kvm_pfn_t pfn),
+	TP_ARGS(pfn),
+
+	TP_STRUCT__entry(
+		__field(unsigned int, sharing_count)
+		__field(kvm_pfn_t, pfn)
+	),
+
+	TP_fast_assign(
+		__entry->sharing_count = refcount_read(folio_get_private(pfn_folio(pfn)));
+		__entry->pfn = pfn;
+	),
+
+	TP_printk("pfn=0x%llx (refcount now %d)",
+	          __entry->pfn, __entry->sharing_count - 1)
+)
+
+#endif
+
 #endif /* _TRACE_KVM_MAIN_H */
 
 /* This part must be outside protection */
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 6772253497e4d..742eba36d2371 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -7,6 +7,7 @@
 #include <linux/set_memory.h>
 
 #include "kvm_mm.h"
+#include "trace/events/kvm.h"
 
 struct kvm_gmem {
 	struct kvm *kvm;
@@ -204,8 +205,10 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, unsi
 	if (r)
 		goto out_err;
 
-	if (share)
+	if (share) {
 		refcount_inc(folio_get_private(folio));
+		trace_kvm_gmem_share(folio, index);
+	}
 
 out:
 	/*
@@ -759,6 +762,8 @@ int kvm_gmem_put_shared_pfn(kvm_pfn_t pfn) {
 	if (refcount_read(sharing_count) == 1)
 		r = kvm_gmem_folio_set_private(folio);
 
+	trace_kvm_gmem_unshare(pfn);
+
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_put_shared_pfn);
-- 
2.46.0


