Return-Path: <kvm+bounces-3224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DAD0C801BCD
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 10:48:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19DF11C20B36
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 09:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB1A8134C9;
	Sat,  2 Dec 2023 09:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e4OnIPat"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A29E181;
	Sat,  2 Dec 2023 01:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701510471; x=1733046471;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=fHaCSLze+0JkRVgR65Mc5+ZZ7ruPmv2R2QFTSzLWrGg=;
  b=e4OnIPatRMyAfv2tmRqGQ1vaQsxcj35oTePJ234Poi9Vsfz2iDUfRCVk
   Ocn3KhYphXUxKxgyW5ULzwWMQacit7VNtOogJfO3dV2+N9JkD+tATbcu1
   trr5o91Bwx4X0qfkxE+lWNfotXccWJr584lYnmXJIlIoVrEHpchqSaycA
   CuBMTz2Sjsdh73clU4KqY6eLPoBxaGLiNRDsKTcCNo5g/TyXAKa2lxFJ8
   5k8ld7g8VEZ/tnhMeviV/ACW8iahZXgCGZmGFfg2JowxsQWfShYT32jY5
   QuzoOYZxfQflqxNT4TzP6+ZbAc+06KWSla4kqwAh/A9oAVdCyhA+6GmjE
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="6886424"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="6886424"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:47:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10911"; a="746278898"
X-IronPort-AV: E=Sophos;i="6.04,245,1695711600"; 
   d="scan'208";a="746278898"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2023 01:47:47 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: alex.williamson@redhat.com,
	jgg@nvidia.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	kevin.tian@intel.com,
	baolu.lu@linux.intel.com,
	dwmw2@infradead.org,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 08/42] KVM: Add a helper to notify importers that KVM exported TDP is flushed
Date: Sat,  2 Dec 2023 17:18:50 +0800
Message-Id: <20231202091850.13890-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231202091211.13376-1-yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Introduce a helper in KVM TDP FD to notify importers that TDP page tables
are invalidated. This helper will be called by arch code (e.g. VMX specific
code).

Currently, the helper will notify all importers of all KVM exported TDPs.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/linux/kvm_host.h |  3 +++
 virt/kvm/tdp_fd.c        | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b76919eec9b72..a8af95194767f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2366,5 +2366,8 @@ static inline int kvm_arch_fault_exported_tdp(struct kvm_exported_tdp *tdp,
 }
 #endif /* __KVM_HAVE_ARCH_EXPORTED_TDP */
 
+void kvm_tdp_fd_flush_notify(struct kvm *kvm, unsigned long gfn, unsigned long npages);
+
 #endif /* CONFIG_HAVE_KVM_EXPORTED_TDP */
+
 #endif
diff --git a/virt/kvm/tdp_fd.c b/virt/kvm/tdp_fd.c
index 02c9066391ebe..8c16af685a061 100644
--- a/virt/kvm/tdp_fd.c
+++ b/virt/kvm/tdp_fd.c
@@ -304,3 +304,41 @@ void kvm_tdp_fd_put(struct kvm_tdp_fd *tdp_fd)
 	fput(tdp_fd->file);
 }
 EXPORT_SYMBOL_GPL(kvm_tdp_fd_put);
+
+static void kvm_tdp_fd_flush(struct kvm_exported_tdp *tdp, unsigned long gfn,
+			     unsigned long npages)
+{
+#define INVALID_NPAGES (-1UL)
+	bool all = (gfn == 0) && (npages == INVALID_NPAGES);
+	struct kvm_tdp_importer *importer;
+	unsigned long start, size;
+
+	if (all) {
+		start = 0;
+		size = -1UL;
+	} else {
+		start = gfn << PAGE_SHIFT;
+		size = npages << PAGE_SHIFT;
+	}
+
+	spin_lock(&tdp->importer_lock);
+
+	list_for_each_entry(importer, &tdp->importers, node) {
+		if (!importer->ops->invalidate)
+			continue;
+
+		importer->ops->invalidate(importer->data, start, size);
+	}
+	spin_unlock(&tdp->importer_lock);
+}
+
+void kvm_tdp_fd_flush_notify(struct kvm *kvm, unsigned long gfn, unsigned long npages)
+{
+	struct kvm_exported_tdp *tdp;
+
+	spin_lock(&kvm->exported_tdplist_lock);
+	list_for_each_entry(tdp, &kvm->exported_tdp_list, list_node)
+		kvm_tdp_fd_flush(tdp, gfn, npages);
+	spin_unlock(&kvm->exported_tdplist_lock);
+}
+EXPORT_SYMBOL_GPL(kvm_tdp_fd_flush_notify);
-- 
2.17.1


