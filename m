Return-Path: <kvm+bounces-26304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D8262973D3F
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:31:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 538911F25AC3
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:31:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFB9819FA80;
	Tue, 10 Sep 2024 16:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="raPb7c53"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BADC13B2B8;
	Tue, 10 Sep 2024 16:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725985866; cv=none; b=fczq0UIecb/YHe2f1VbbMnZZ0aRAEPksoMqaPwb7cw3cGq5enjGXY7AtTj21DD2Irx+7xfBX0p+D9chPaftwnJkaL3g0JEFmcQJ1tru9bMpm+k92mWCoXdSrgOJwYhe3Zw+T0UtAsEv9GmZRPvvF6neKVd5GJp4K7o1dPw5Eamw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725985866; c=relaxed/simple;
	bh=O7JPYiXoBuIHGT0WVtgUBICmUu2YOZgdMk9le+zDeiI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wlvog+wKYNPuYcB1EdtypQnOjmnnApRveaVkXyigEeLww7d94qe+0BZ1P+SiYxxv7hdE3pUI4yAyIW3ENyUBoe6dkSWx3ODFdSDeBuZRd2QzHk6ikQxKbuYqtXVYEboA8UGJFuKrWKXzt7nKwzIu1iyTSeElgzRqePw8t/od+Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=raPb7c53; arc=none smtp.client-ip=52.119.213.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1725985865; x=1757521865;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CXxTji2PsKU8ektMXjm+AW02ug0kAumv6veW9lxkEvg=;
  b=raPb7c53rp/oW/quupIhTi0SVN3m8GcvF7/yYdbiNQEaYwsd3TGWdFhR
   sjO0MWbP5090NbsDIgrXvJsF0H2Y0taPRBeQYpidkVH5J9znzNvWibTXF
   TOuUFOn8Vyd1iE+4rEBpYEbf+Om0O/PkYgNR04SGBcEk9VWNdn6sZkg1f
   U=;
X-IronPort-AV: E=Sophos;i="6.10,217,1719878400"; 
   d="scan'208";a="658021874"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 16:31:01 +0000
Received: from EX19MTAUEB001.ant.amazon.com [10.0.44.209:38231]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.48.28:2525] with esmtp (Farcaster)
 id a2b39b4e-e66c-464d-9ecd-b79c04647c96; Tue, 10 Sep 2024 16:31:00 +0000 (UTC)
X-Farcaster-Flow-ID: a2b39b4e-e66c-464d-9ecd-b79c04647c96
Received: from EX19D008UEA003.ant.amazon.com (10.252.134.116) by
 EX19MTAUEB001.ant.amazon.com (10.252.135.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 10 Sep 2024 16:30:52 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D008UEA003.ant.amazon.com (10.252.134.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 10 Sep 2024 16:30:51 +0000
Received: from ua2d7e1a6107c5b.home (172.19.88.180) by mail-relay.amazon.com
 (10.250.64.254) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Tue, 10 Sep 2024 16:30:47 +0000
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
Subject: [RFC PATCH v2 01/10] kvm: gmem: Add option to remove gmem from direct map
Date: Tue, 10 Sep 2024 17:30:27 +0100
Message-ID: <20240910163038.1298452-2-roypat@amazon.co.uk>
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

Add a flag to the KVM_CREATE_GUEST_MEMFD ioctl that causes gmem pfns
to be removed from the host kernel's direct map. Memory is removed
immediately after allocation and preparation of gmem folios (after
preparation, as the prepare callback might expect the direct map entry
to be present). Direct map entries are restored before
kvm_arch_gmem_invalidate is called (as ->invalidate_folio is called
before ->free_folio), for the same reason.

Use the PG_private flag to indicate that a folio is part of gmem with
direct map removal enabled. While in this patch, PG_private does have a
meaning of "folio not in direct map", this will no longer be true in
follow up patches. Gmem folios might get temporarily reinserted into the
direct map, but the PG_private flag needs to remain set, as the folios
will have private data that needs to be freed independently of direct
map status. This is why kvm_gmem_folio_clear_private does not call
folio_clear_private.

kvm_gmem_{set,clear}_folio_private must be called with the folio lock
held.

To ensure that failures in kvm_gmem_{clear,set}_private do not cause
system instability due to leaving holes in the direct map, try to always
restore direct map entries on failure. Pages for which restoration of
direct map entries fails are marked as HWPOISON, to prevent the
kernel from ever touching them again.

Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
---
 include/uapi/linux/kvm.h |  2 +
 virt/kvm/guest_memfd.c   | 96 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 91 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 637efc0551453..81b0f4a236b8c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1564,6 +1564,8 @@ struct kvm_create_guest_memfd {
 	__u64 reserved[6];
 };
 
+#define KVM_GMEM_NO_DIRECT_MAP			(1ULL << 0)
+
 #define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_memory)
 
 struct kvm_pre_fault_memory {
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 1c509c3512614..2ed27992206f3 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -4,6 +4,7 @@
 #include <linux/kvm_host.h>
 #include <linux/pagemap.h>
 #include <linux/anon_inodes.h>
+#include <linux/set_memory.h>
 
 #include "kvm_mm.h"
 
@@ -49,8 +50,69 @@ static int kvm_gmem_prepare_folio(struct inode *inode, pgoff_t index, struct fol
 	return 0;
 }
 
+static bool kvm_gmem_test_no_direct_map(struct inode *inode)
+{
+	return ((unsigned long)inode->i_private & KVM_GMEM_NO_DIRECT_MAP) == KVM_GMEM_NO_DIRECT_MAP;
+}
+
+static int kvm_gmem_folio_set_private(struct folio *folio)
+{
+	unsigned long start, npages, i;
+	int r;
+
+	start = (unsigned long) folio_address(folio);
+	npages = folio_nr_pages(folio);
+
+	for (i = 0; i < npages; ++i) {
+		r = set_direct_map_invalid_noflush(folio_page(folio, i));
+		if (r)
+			goto out_remap;
+	}
+	flush_tlb_kernel_range(start, start + folio_size(folio));
+	folio_set_private(folio);
+	return 0;
+out_remap:
+	for (; i > 0; i--) {
+		struct page *page = folio_page(folio, i - 1);
+
+		if (WARN_ON_ONCE(set_direct_map_default_noflush(page))) {
+			/*
+			 * Random holes in the direct map are bad, let's mark
+			 * these pages as corrupted memory so that the kernel
+			 * avoids ever touching them again.
+			 */
+			folio_set_hwpoison(folio);
+			r = -EHWPOISON;
+		}
+	}
+	return r;
+}
+
+static int kvm_gmem_folio_clear_private(struct folio *folio)
+{
+	unsigned long npages, i;
+	int r = 0;
+
+	npages = folio_nr_pages(folio);
+
+	for (i = 0; i < npages; ++i) {
+		struct page *page = folio_page(folio, i);
+
+		if (WARN_ON_ONCE(set_direct_map_default_noflush(page))) {
+			folio_set_hwpoison(folio);
+			r = -EHWPOISON;
+		}
+	}
+	/*
+	 * no TLB flush here: pages without direct map entries should
+	 * never be in the TLB in the first place.
+	 */
+	return r;
+}
+
 static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool prepare)
 {
+	int r;
 	struct folio *folio;
 
 	/* TODO: Support huge pages. */
@@ -78,19 +140,31 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool
 	}
 
 	if (prepare) {
-		int r =	kvm_gmem_prepare_folio(inode, index, folio);
-		if (r < 0) {
-			folio_unlock(folio);
-			folio_put(folio);
-			return ERR_PTR(r);
-		}
+		r = kvm_gmem_prepare_folio(inode, index, folio);
+		if (r < 0)
+			goto out_err;
 	}
 
+	if (!kvm_gmem_test_no_direct_map(inode))
+		goto out;
+
+	if (!folio_test_private(folio)) {
+		r = kvm_gmem_folio_set_private(folio);
+		if (r)
+			goto out_err;
+	}
+
+out:
 	/*
 	 * Ignore accessed, referenced, and dirty flags.  The memory is
 	 * unevictable and there is no storage to write back to.
 	 */
 	return folio;
+
+out_err:
+	folio_unlock(folio);
+	folio_put(folio);
+	return ERR_PTR(r);
 }
 
 static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
@@ -343,6 +417,13 @@ static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *fol
 	return MF_DELAYED;
 }
 
+static void kvm_gmem_invalidate_folio(struct folio *folio, size_t start, size_t end)
+{
+	if (start == 0 && end == folio_size(folio)) {
+		kvm_gmem_folio_clear_private(folio);
+	}
+}
+
 #ifdef CONFIG_HAVE_KVM_GMEM_INVALIDATE
 static void kvm_gmem_free_folio(struct folio *folio)
 {
@@ -358,6 +439,7 @@ static const struct address_space_operations kvm_gmem_aops = {
 	.dirty_folio = noop_dirty_folio,
 	.migrate_folio	= kvm_gmem_migrate_folio,
 	.error_remove_folio = kvm_gmem_error_folio,
+	.invalidate_folio = kvm_gmem_invalidate_folio,
 #ifdef CONFIG_HAVE_KVM_GMEM_INVALIDATE
 	.free_folio = kvm_gmem_free_folio,
 #endif
@@ -442,7 +524,7 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
 {
 	loff_t size = args->size;
 	u64 flags = args->flags;
-	u64 valid_flags = 0;
+	u64 valid_flags = KVM_GMEM_NO_DIRECT_MAP;
 
 	if (flags & ~valid_flags)
 		return -EINVAL;

base-commit: 332d2c1d713e232e163386c35a3ba0c1b90df83f
-- 
2.46.0


