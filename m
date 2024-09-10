Return-Path: <kvm+bounces-26308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 72969973D48
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:32:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 959AC1C24D40
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 408281A38F4;
	Tue, 10 Sep 2024 16:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="WzG2bs3o"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D6B16C684;
	Tue, 10 Sep 2024 16:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725985886; cv=none; b=KgxiejjSa9kz9zBH/DDUe4itqGK+7eLcgfkUzZzpvl453E8Af5zF7g2i9U81lccVVugqOeN/a+g7teMJpg4UOvcsRxW2+ZHJQoQ6PAniYiOQTEPuq4m3ysE+iMs8OPGnjrZmj4ylOY+GYbtZg6kI/oc+PTBQqt7siv8tmfNK3QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725985886; c=relaxed/simple;
	bh=wEvphmOWMZdu1sRx5FSK/ZuJYcq8ehXHEFENxlCUHAQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lBJ4K+X66b7MSVhfHjHEcCIdXIfkBEQQLMC8fzRLBJECcQqv5bsDdcG9RuuV/jkt+6pLvbeuiSwS5tem67gw0nUENZaQVtbByKbBpaUlmVuI1/EcXd/Vs+Wk24gt/RCxjI3qVQ/CrBN+xk8cF3rqZ4loGQH5zqXdcdXv2suuYVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=WzG2bs3o; arc=none smtp.client-ip=99.78.197.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1725985884; x=1757521884;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YAD9FwaD5CpRjHhI+oh6kuxBv4yx2jFRf65FGqhbrxU=;
  b=WzG2bs3oDGvTBivf2Tn/jJZvqQycr94wlVv2bWbnnRVojGA16ZYJUB+M
   S6odfKQPQo+vxuajw4pAgPBEMgKc+sAdUoc8CwzVP93H7VUaQWNBnf1Nu
   ZYEkF2iIxzYS0OF3q1NRv7kZzycOouMW3Iw6ynVBkbaQ9WIPiv813uEGC
   A=;
X-IronPort-AV: E=Sophos;i="6.10,217,1719878400"; 
   d="scan'208";a="124612986"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 16:31:23 +0000
Received: from EX19MTAUEA001.ant.amazon.com [10.0.29.78:42006]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.30.239:2525] with esmtp (Farcaster)
 id 0e99c686-f4d2-458c-998e-c58de7385fd9; Tue, 10 Sep 2024 16:31:22 +0000 (UTC)
X-Farcaster-Flow-ID: 0e99c686-f4d2-458c-998e-c58de7385fd9
Received: from EX19D008UEA004.ant.amazon.com (10.252.134.191) by
 EX19MTAUEA001.ant.amazon.com (10.252.134.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 10 Sep 2024 16:31:14 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D008UEA004.ant.amazon.com (10.252.134.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 10 Sep 2024 16:31:14 +0000
Received: from ua2d7e1a6107c5b.home (172.19.88.180) by mail-relay.amazon.com
 (10.250.64.254) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Tue, 10 Sep 2024 16:31:09 +0000
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
Subject: [RFC PATCH v2 05/10] kvm: gmem: Refcount internal accesses to gmem
Date: Tue, 10 Sep 2024 17:30:31 +0100
Message-ID: <20240910163038.1298452-6-roypat@amazon.co.uk>
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

Currently, if KVM_GMEM_NO_DIRECT_MAP is set and KVM wants to
internally access a gmem folio, KVM needs to reinsert the folio into the
direct map, and hold the folio lock until KVM is done using the folio
(and the folio is removed from the direct map again).

This means that long-term reinsertion into the direct map, and
concurrent accesses to the same gmem folio are currently impossible.
These are needed however for data structures of paravirtual devices,
such as kvm-clock, which are shared between guest and host via guest
memory pages (and multiple vCPUs can put their kvm-clock data into the
same guest page).

Thus, introduce the concept of a "sharing refcount", which gets
incremented on every call to kvm_gmem_get_pfn with
KVM_GMEM_GET_PFN_SHARED set. Direct map manipulations are only done when
the first refcount is grabbed (direct map entries are restored), or when
the last reference goes away (direct map entries are removed). While
holding a sharing reference, the folio lock may be dropped, as the
refcounting ensures that the direct map entry will not be removed as
long as at least one reference is held. However, whoever is holding a
reference will need to listen and respond to gmem invalidation events
(such as the page being in the process of being fallocated away).

Since refcount_t does not play nicely with references dropping to 0 and
later being raised again (it will WARN), we use a refcount of 1 to mean
"no sharing references held anywhere, folio not in direct map".

Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
---
 virt/kvm/guest_memfd.c | 61 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 58 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index f637abc6045ba..6772253497e4d 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -60,10 +60,37 @@ static bool kvm_gmem_test_accessible(struct kvm *kvm)
 	return kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM;
 }
 
+static int kvm_gmem_init_sharing_count(struct folio *folio)
+{
+	refcount_t *sharing_count = kmalloc(sizeof(*sharing_count), GFP_KERNEL);
+
+	if (!sharing_count)
+		return -ENOMEM;
+
+	/*
+	 * we need to use sharing_count == 1 to mean "no sharing", because
+	 * dropping a refcount_t to 0 and later incrementing it again would
+	 * result in a WARN.
+	 */
+	refcount_set(sharing_count, 1);
+	folio_change_private(folio, (void *)sharing_count);
+
+	return 0;
+}
+
 static int kvm_gmem_folio_set_private(struct folio *folio)
 {
 	unsigned long start, npages, i;
 	int r;
+	unsigned int sharing_refcount = refcount_read(folio_get_private(folio));
+
+	/*
+	 * We must only remove direct map entries after the last internal
+	 * reference has gone away, e.g. after the refcount dropped back
+	 * to 1.
+	 */
+	WARN_ONCE(sharing_refcount != 1, "%d unexpected sharing_refcounts pfn=%lx",
+		  sharing_refcount - 1, folio_pfn(folio));
 
 	start = (unsigned long) folio_address(folio);
 	npages = folio_nr_pages(folio);
@@ -97,6 +124,15 @@ static int kvm_gmem_folio_clear_private(struct folio *folio)
 {
 	unsigned long npages, i;
 	int r = 0;
+	unsigned int sharing_refcount = refcount_read(folio_get_private(folio));
+
+	/*
+	 * We must restore direct map entries on acquiring the first "sharing
+	 * reference". The refcount is lifted _after_ the call to
+	 * kvm_gmem_folio_clear_private, so it will still be 1 here.
+	 */
+	WARN_ONCE(sharing_refcount != 1, "%d unexpected sharing_refcounts pfn=%lx",
+		  sharing_refcount - 1, folio_pfn(folio));
 
 	npages = folio_nr_pages(folio);
 
@@ -156,13 +192,21 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, unsi
 
 	if (folio_test_private(folio) && share) {
 		r = kvm_gmem_folio_clear_private(folio);
-	} else if (!folio_test_private(folio) && !share) {
-		r = kvm_gmem_folio_set_private(folio);
+	} else if (!folio_test_private(folio)) {
+		r = kvm_gmem_init_sharing_count(folio);
+		if (r)
+			goto out_err;
+
+		if (!share)
+			r = kvm_gmem_folio_set_private(folio);
 	}
 
 	if (r)
 		goto out_err;
 
+	if (share)
+		refcount_inc(folio_get_private(folio));
+
 out:
 	/*
 	 * Ignore accessed, referenced, and dirty flags.  The memory is
@@ -429,7 +473,10 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
 static void kvm_gmem_invalidate_folio(struct folio *folio, size_t start, size_t end)
 {
 	if (start == 0 && end == folio_size(folio)) {
+		refcount_t *sharing_count = folio_get_private(folio);
+
 		kvm_gmem_folio_clear_private(folio);
+		kfree(sharing_count);
 	}
 }
 
@@ -699,12 +746,20 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
 
 int kvm_gmem_put_shared_pfn(kvm_pfn_t pfn) {
+	int r = 0;
 	struct folio *folio = pfn_folio(pfn);
+	refcount_t *sharing_count;
 
 	if (!kvm_gmem_test_no_direct_map(folio_inode(folio)))
 		return 0;
 
-	return kvm_gmem_folio_set_private(folio);
+	sharing_count = folio_get_private(folio);
+	refcount_dec(sharing_count);
+
+	if (refcount_read(sharing_count) == 1)
+		r = kvm_gmem_folio_set_private(folio);
+
+	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_put_shared_pfn);
 
-- 
2.46.0


