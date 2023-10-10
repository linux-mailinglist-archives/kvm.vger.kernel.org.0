Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644907BF60F
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442927AbjJJIfx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442909AbjJJIfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:35:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3ABB4;
        Tue, 10 Oct 2023 01:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696926936; x=1728462936;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=utIbATgtjnZQ7rhJBP1bPFT2h4Ptx/Bd1cAqmmuMA8c=;
  b=JmcuFyA+Yojclci3aEbuTnnJS+pEihRba9w3+47Nbe8EJ0EoUsrgm3hI
   04qrAtXBGMTkZX+TjuLA+xFvwgCrrb6qZ1gvyfPcnibBZbUXZB39ktoWD
   uwWXMMZ9FTMzIgkbi2z8m7ZQ3Q+Tr2A5nce2zBaFc8JdDpMhkl1mcnNfi
   V6YRNl/7DvBCxiwWFAZTMZO3XdEpMTps7R2/hqZyxqXdqJKgWZf+TMMyI
   jl4I7JWRIgEnRhC8Io9T0XOIh956/iZwOJRulBqlIzUIy5OWYb68GqcnR
   t5JveOpmEwNdclm14+joV+TjXbf9a8Oap4UQNbUsFoM7vg0lG19DoqrR3
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="363689812"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="363689812"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="1084687193"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="1084687193"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:34 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Chao Peng <chao.p.peng@linux.intel.com>
Subject: [PATCH 06/12] mm/fadvise: Add FADV_MCE_INJECT flag for posix_fadvise()
Date:   Tue, 10 Oct 2023 01:35:14 -0700
Message-Id: <a276a2f2d4028dc8897441965ec00cecbd82086c.1696926843.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1696926843.git.isaku.yamahata@intel.com>
References: <cover.1696926843.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

For VM-based confidential computing (AMD SEV-SNP and Intel TDX), the KVM
guest memfd effort [1] is ongoing.  It allows KVM guests to use file
descriptors and their offset as protected guest memory without user-space
virtual address mapping.

Intel TDX uses machine checks to notify the host OS/VMM that the TDX guest
consumed corrupted memory.  The KVM/x86 handles machine checks for guest
vcpu specially.  It sets up the guest so that vcpu exits from running on
machine check, checks the exit reason, and manually raises the machine
check by calling do_machine_check().

To test the KVM machine check path, KVM wants to inject an x86 machine
check based on the file descriptor and offset.  Add a new flag
FADV_MCE_INJECT for posix_fadvise() to tell the x86 MCE injector the
physical address. The x86 MCE injector can be kernel-builtin or kernel
module.  CONFIG_X86_MCE_INJECT=y, m, or n.  Because we don't want
posix_fadvise() to depend on the x86 MCE injector, add notifier for it to
register.  And the x86 MCE injector will register to the notifier chain.

The possible options would be
- Add FADV flags for memory poison.  This patch.
- Introduce a new IOCTL specific to KVM guest memfd
- Introduce debugfs entries for KVM guest memfd like
  /sys/kernel/debug/kvm/<pid>-<vm-fd>/guest-memfd<fd>/hwpoison/
  {corrupt-offset, unoison-offset}.
  This options follows /sys/kernel/debug/hwpoison/
  {corrupt-pfn, unpoison-pfn}

[1] https://lore.kernel.org/all/20230914015531.1419405-1-seanjc@google.com/
    KVM guest_memfd() and per-page attributes
    https://lore.kernel.org/all/20230921203331.3746712-1-seanjc@google.com/
    [PATCH 00/13] KVM: guest_memfd fixes

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/linux/fs.h           |  8 +++++
 include/uapi/linux/fadvise.h |  1 +
 mm/fadvise.c                 | 62 ++++++++++++++++++++++++++++++++++++
 3 files changed, 71 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index b528f063e8ff..c458f1e86245 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3377,5 +3377,13 @@ extern int vfs_fadvise(struct file *file, loff_t offset, loff_t len,
 		       int advice);
 extern int generic_fadvise(struct file *file, loff_t offset, loff_t len,
 			   int advice);
+#ifdef CONFIG_X86_MCE_INJECT
+void fadvise_register_mce_injector_chain(struct notifier_block *nb);
+void fadvise_unregister_mce_injector_chain(struct notifier_block *nb);
+#else
+static inline void fadvise_register_mce_injector_chain(struct notifier_block *nb) {}
+static inline void fadvise_unregister_mce_injector_chain(struct notifier_block *nb) {}
+#endif
+
 
 #endif /* _LINUX_FS_H */
diff --git a/include/uapi/linux/fadvise.h b/include/uapi/linux/fadvise.h
index 3699b4b0adcd..90e1b5a94f37 100644
--- a/include/uapi/linux/fadvise.h
+++ b/include/uapi/linux/fadvise.h
@@ -22,5 +22,6 @@
 /* Same to MADV_HWPOISON and MADV_SOFT_OFFLINE */
 #define FADV_HWPOISON		100	/* poison a page for testing */
 #define FADV_SOFT_OFFLINE	101	/* soft offline page for testing */
+#define FADV_MCE_INJECT		102
 
 #endif	/* FADVISE_H_INCLUDED */
diff --git a/mm/fadvise.c b/mm/fadvise.c
index 1f028a6e1d90..8168d08f7455 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -74,6 +74,65 @@ static int fadvise_inject_error(struct file *file, struct address_space *mapping
 	return 0;
 }
 
+#ifdef CONFIG_X86_MCE_INJECT
+static BLOCKING_NOTIFIER_HEAD(mce_injector_chain);
+
+void fadvise_register_mce_injector_chain(struct notifier_block *nb)
+{
+	blocking_notifier_chain_register(&mce_injector_chain, nb);
+}
+EXPORT_SYMBOL_GPL(fadvise_register_mce_injector_chain);
+
+void fadvise_unregister_mce_injector_chain(struct notifier_block *nb)
+{
+	blocking_notifier_chain_unregister(&mce_injector_chain, nb);
+}
+EXPORT_SYMBOL_GPL(fadvise_unregister_mce_injector_chain);
+
+static void fadvise_call_mce_injector_chain(unsigned long physaddr)
+{
+	blocking_notifier_call_chain(&mce_injector_chain, physaddr, NULL);
+}
+#else
+static void fadvise_call_mce_injector_chain(unsigned long physaddr)
+{
+}
+#endif
+
+static int fadvise_inject_mce(struct file *file, struct address_space *mapping,
+			      loff_t offset)
+{
+	unsigned long page_mask, physaddr;
+	struct folio *folio;
+	pgoff_t index;
+
+	if (!IS_ENABLED(CONFIG_X86_MCE_INJECT))
+		return -EOPNOTSUPP;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (is_file_hugepages(file)) {
+		index = offset >> huge_page_shift(hstate_file(file));
+		page_mask = huge_page_mask(hstate_file(file));
+	} else {
+		index = offset >> PAGE_SHIFT;
+		page_mask = PAGE_MASK;
+	}
+
+	folio = filemap_get_folio(mapping, index);
+	if (IS_ERR(folio))
+		return PTR_ERR(folio);
+
+	physaddr = (folio_pfn(folio) << PAGE_SHIFT) | (offset & ~page_mask);
+	folio_put(folio);
+
+	pr_info("Injecting mce for address %#lx at file offset %#llx\n",
+		physaddr, offset);
+	fadvise_call_mce_injector_chain(physaddr);
+	return 0;
+}
+
 /*
  * POSIX_FADV_WILLNEED could set PG_Referenced, and POSIX_FADV_NOREUSE could
  * deactivate the pages and clear PG_Referenced.
@@ -111,6 +170,7 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 			return 0;
 		case FADV_HWPOISON:
 		case FADV_SOFT_OFFLINE:
+		case FADV_MCE_INJECT:
 			break;
 		default:
 			return -EINVAL;
@@ -226,6 +286,8 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 	case FADV_HWPOISON:
 	case FADV_SOFT_OFFLINE:
 		return fadvise_inject_error(file, mapping, offset, endbyte, advice);
+	case FADV_MCE_INJECT:
+		return fadvise_inject_mce(file, mapping, offset);
 	default:
 		return -EINVAL;
 	}
-- 
2.25.1

