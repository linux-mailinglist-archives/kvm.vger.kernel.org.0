Return-Path: <kvm+bounces-26306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD4D3973D42
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B370282755
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 958281A2C12;
	Tue, 10 Sep 2024 16:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="v0ugoCKA"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD361A00F4;
	Tue, 10 Sep 2024 16:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725985869; cv=none; b=GoMfbKpb1ayihZUZk2c5L/cc0c5NedW87MbUo8e+AboHN989uMap4o2GZqL8Z6hrjEWA9PGV3fkSveFyG/2uke5DQe0zL/SIne/K2bfgm082R4hPmEQVtchsT0PfMscpB5Mor/5WKNctGbSIm4sOdstd9JL3Gs5uTQ8TZgU04gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725985869; c=relaxed/simple;
	bh=skUzRcCSPy9WgItUAh3+swWfjgUWXocwpc0g2Acwcq4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TL83mF++Io7T82EkaLdCaKShbUtMrJzHOmRx/uWnxgqtiq/mO9TBtaPWaAKUG3MlGbcE0RzOKKQvr2PmQRMiEhcZwvtZQUggL+aLk96M8zGyc76AoRGgZNYhSZMUKxIjnyx7h5gapar0sy+4PwLbR92grRrrFtZAiSyA6+DNi88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=v0ugoCKA; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1725985868; x=1757521868;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OSB6/wHaKh12iBDoF1XKstABhzcwNvqjtvF5UFffeGQ=;
  b=v0ugoCKAYz3H3AUhu7tLrSyiIPgVnhlzaT4HtAkiL3SpYf0U35n2yM+1
   ibIu5HSNAPzYTqZuuaMOC37soH0KrKo5NzgzRDK7E+bf8uOKJAeSxmaue
   RWKsVEmXPdhWPclqFGy0eCGMpj2/4/nErQbzNgrMHWPS1CvNKPA7yo7T0
   Q=;
X-IronPort-AV: E=Sophos;i="6.10,217,1719878400"; 
   d="scan'208";a="679397384"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 16:31:05 +0000
Received: from EX19MTAUEA002.ant.amazon.com [10.0.29.78:10984]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.46.235:2525] with esmtp (Farcaster)
 id 37b8be63-b91b-41ff-9b88-4b6db0d84ee2; Tue, 10 Sep 2024 16:31:04 +0000 (UTC)
X-Farcaster-Flow-ID: 37b8be63-b91b-41ff-9b88-4b6db0d84ee2
Received: from EX19D008UEA002.ant.amazon.com (10.252.134.125) by
 EX19MTAUEA002.ant.amazon.com (10.252.134.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 10 Sep 2024 16:30:57 +0000
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19D008UEA002.ant.amazon.com (10.252.134.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 10 Sep 2024 16:30:57 +0000
Received: from ua2d7e1a6107c5b.home (172.19.88.180) by mail-relay.amazon.com
 (10.250.64.254) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34 via Frontend
 Transport; Tue, 10 Sep 2024 16:30:52 +0000
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
Subject: [RFC PATCH v2 02/10] kvm: gmem: Add KVM_GMEM_GET_PFN_SHARED
Date: Tue, 10 Sep 2024 17:30:28 +0100
Message-ID: <20240910163038.1298452-3-roypat@amazon.co.uk>
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

If `KVM_GMEM_NO_DIRECT_MAP` is set, all gmem folios are removed from the
direct map immediately after allocation. Add a flag to
kvm_gmem_grab_folio to overwrite this behavior, and expose it via
`kvm_gmem_get_pfn`. Only allow this flag to be set if KVM can actually
access gmem (currently only if the vm type is KVM_X86_SW_PROTECTED_VM).

KVM_GMEM_GET_PFN_SHARED defers the direct map removal for newly
allocated folios until kvm_gmem_put_shared_pfn is called. For existing
folios, the direct map entry is temporarily restored until
kvm_gmem_put_shared_pfn is called.

The folio lock must be held the entire time the folio is present in the
direct map, to prevent races with concurrent calls
kvm_gmem_folio_set_private that might remove direct map entries while
the folios are being accessed by KVM. As this is currently not possible
(kvm_gmem_get_pfn always unlocks the folio), the next patch will
introduce a KVM_GMEM_GET_PFN_LOCKED flag.

Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
---
 arch/x86/kvm/mmu/mmu.c   |  2 +-
 include/linux/kvm_host.h | 12 +++++++++--
 virt/kvm/guest_memfd.c   | 46 +++++++++++++++++++++++++++++++---------
 3 files changed, 47 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 901be9e420a4c..cb2f111f2cce0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4349,7 +4349,7 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 	}
 
 	r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
-			     &max_order);
+			     &max_order, 0);
 	if (r) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return r;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 689e8be873a75..8a2975674de4b 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2432,17 +2432,25 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 }
 #endif /* CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES */
 
+#define KVM_GMEM_GET_PFN_SHARED         BIT(0)
+#define KVM_GMEM_GET_PFN_PREPARE        BIT(31)  /* internal */
+
 #ifdef CONFIG_KVM_PRIVATE_MEM
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
+		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order, unsigned long flags);
+int kvm_gmem_put_shared_pfn(kvm_pfn_t pfn);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
-				   kvm_pfn_t *pfn, int *max_order)
+				   kvm_pfn_t *pfn, int *max_order, int flags)
 {
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
 }
+static inline int kvm_gmem_put_shared_pfn(kvm_pfn_t pfn)
+{
+	return -EIO;
+}
 #endif /* CONFIG_KVM_PRIVATE_MEM */
 
 #ifdef CONFIG_HAVE_KVM_GMEM_PREPARE
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 2ed27992206f3..492b04f4e5c18 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -55,6 +55,11 @@ static bool kvm_gmem_test_no_direct_map(struct inode *inode)
 	return ((unsigned long)inode->i_private & KVM_GMEM_NO_DIRECT_MAP) == KVM_GMEM_NO_DIRECT_MAP;
 }
 
+static bool kvm_gmem_test_accessible(struct kvm *kvm)
+{
+	return kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM;
+}
+
 static int kvm_gmem_folio_set_private(struct folio *folio)
 {
 	unsigned long start, npages, i;
@@ -110,10 +115,11 @@ static int kvm_gmem_folio_clear_private(struct folio *folio)
 	return r;
 }
 
-static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool prepare)
+static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, unsigned long flags)
 {
 	int r;
 	struct folio *folio;
+	bool share = flags & KVM_GMEM_GET_PFN_SHARED;
 
 	/* TODO: Support huge pages. */
 	folio = filemap_grab_folio(inode->i_mapping, index);
@@ -139,7 +145,7 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool
 		folio_mark_uptodate(folio);
 	}
 
-	if (prepare) {
+	if (flags & KVM_GMEM_GET_PFN_PREPARE) {
 		r = kvm_gmem_prepare_folio(inode, index, folio);
 		if (r < 0)
 			goto out_err;
@@ -148,12 +154,15 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, bool
 	if (!kvm_gmem_test_no_direct_map(inode))
 		goto out;
 
-	if (!folio_test_private(folio)) {
+	if (folio_test_private(folio) && share) {
+		r = kvm_gmem_folio_clear_private(folio);
+	} else if (!folio_test_private(folio) && !share) {
 		r = kvm_gmem_folio_set_private(folio);
-		if (r)
-			goto out_err;
 	}
 
+	if (r)
+		goto out_err;
+
 out:
 	/*
 	 * Ignore accessed, referenced, and dirty flags.  The memory is
@@ -264,7 +273,7 @@ static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 			break;
 		}
 
-		folio = kvm_gmem_get_folio(inode, index, true);
+		folio = kvm_gmem_get_folio(inode, index, KVM_GMEM_GET_PFN_PREPARE);
 		if (IS_ERR(folio)) {
 			r = PTR_ERR(folio);
 			break;
@@ -624,7 +633,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
 }
 
 static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
-		       gfn_t gfn, kvm_pfn_t *pfn, int *max_order, bool prepare)
+		       gfn_t gfn, kvm_pfn_t *pfn, int *max_order, unsigned long flags)
 {
 	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
 	struct kvm_gmem *gmem = file->private_data;
@@ -643,7 +652,7 @@ static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 		return -EIO;
 	}
 
-	folio = kvm_gmem_get_folio(file_inode(file), index, prepare);
+	folio = kvm_gmem_get_folio(file_inode(file), index, flags);
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
 
@@ -667,20 +676,37 @@ static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
 }
 
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
+		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order, unsigned long flags)
 {
 	struct file *file = kvm_gmem_get_file(slot);
 	int r;
+	int valid_flags = KVM_GMEM_GET_PFN_SHARED;
+
+	if ((flags & valid_flags) != flags)
+		return -EINVAL;
+
+	if ((flags & KVM_GMEM_GET_PFN_SHARED) && !kvm_gmem_test_accessible(kvm))
+		return -EPERM;
 
 	if (!file)
 		return -EFAULT;
 
-	r = __kvm_gmem_get_pfn(file, slot, gfn, pfn, max_order, true);
+	r = __kvm_gmem_get_pfn(file, slot, gfn, pfn, max_order, flags | KVM_GMEM_GET_PFN_PREPARE);
 	fput(file);
 	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
 
+int kvm_gmem_put_shared_pfn(kvm_pfn_t pfn) {
+	struct folio *folio = pfn_folio(pfn);
+
+	if (!kvm_gmem_test_no_direct_map(folio_inode(folio)))
+		return 0;
+
+	return kvm_gmem_folio_set_private(folio);
+}
+EXPORT_SYMBOL_GPL(kvm_gmem_put_shared_pfn);
+
 long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque)
 {
-- 
2.46.0


