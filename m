Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1366E7BF607
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442957AbjJJIfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442910AbjJJIfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:35:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF68E97;
        Tue, 10 Oct 2023 01:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696926935; x=1728462935;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mLhP+/UTxZsFYw+hdN7w9M/CFhBlJ75IonjuoNuiyMg=;
  b=AepkpjWUuHBO8nzkRSSp42FRTvdQYq5YuTaufHqduPJdyFtcI8Qgc8e+
   SIPkSM2dksG6HeSZUWfBaKwAC/FplAXwTtHjg7bcRIvcz3lmtVQQNM7Xp
   uQkG1cGQple2CYdkKya2lsIek+quecTR2TgjLymJwnUEqsRoIVpfMgNVv
   Q501NhCFNLTIPSl8WXcFssiXDZmAQxOKaLgQtUqF5ReOx2SvhIlRyDgkj
   XlpFigzFo+VSgOB4MjRiKiM9KEp/ixZo9wusahVgskHN0osdfRf0mRO5x
   O1N2g2z8E/azkU7dW2WVy+YdX1oDJjV1TgsaEXlSGh5oLPr3G2Six7a1Z
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="363689804"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="363689804"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="1084687189"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="1084687189"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:34 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Chao Peng <chao.p.peng@linux.intel.com>
Subject: [PATCH 05/12] mm/fadvise: Add flags to inject hwpoison for posix_fadvise()
Date:   Tue, 10 Oct 2023 01:35:13 -0700
Message-Id: <8bdfcbdc1b04baba70c25d7f5c3394c6d73f2ff4.1696926843.git.isaku.yamahata@intel.com>
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
check by calling do_machine_check().  To test the KVM machine check path,
KVM wants to poison memory based on file descriptor and its offset.  The
current memory poisoning is based on the physical address,
/sys/kernel/debug/hwpoison/{corrupt-pfn, unpoison-pfn}, or the virtual
address, MADV_HWPOISON and MADV_UNPOISON.

Add new flags FADV_HWPOISON, and FADV_UNPOISON to
posix_fadvise() by following MADV_HWPOISON and MADV_UNPOISON.  9893e49d64a4
("HWPOISON: Add madvise() based injector for hardware poisoned pages v4")

The possible options would be
- Add FADV flags for memory poison.  This patch.
- introduce IOCTL specific to KVM guest memfd
- introduce debugfs entries for KVM guest memfd
  /sys/kernel/debug/kvm/<pid>-<vm-fd>/guest-memfd<fd>/hwpoison/
  {corrupt-offset, unoison-offset}.
  This options follows /sys/kernel/debug/hwpoison/{corrupt-pfn, unpoison-pfn}

[1] https://lore.kernel.org/all/20230914015531.1419405-1-seanjc@google.com/
    KVM guest_memfd() and per-page attributes
    https://lore.kernel.org/all/20230921203331.3746712-1-seanjc@google.com/
    [PATCH 00/13] KVM: guest_memfd fixes

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/uapi/linux/fadvise.h |  4 +++
 mm/fadvise.c                 | 58 +++++++++++++++++++++++++++++++++++-
 2 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/fadvise.h b/include/uapi/linux/fadvise.h
index 0862b87434c2..3699b4b0adcd 100644
--- a/include/uapi/linux/fadvise.h
+++ b/include/uapi/linux/fadvise.h
@@ -19,4 +19,8 @@
 #define POSIX_FADV_NOREUSE	5 /* Data will be accessed once.  */
 #endif
 
+/* Same to MADV_HWPOISON and MADV_SOFT_OFFLINE */
+#define FADV_HWPOISON		100	/* poison a page for testing */
+#define FADV_SOFT_OFFLINE	101	/* soft offline page for testing */
+
 #endif	/* FADVISE_H_INCLUDED */
diff --git a/mm/fadvise.c b/mm/fadvise.c
index 6c39d42f16dc..1f028a6e1d90 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -18,11 +18,62 @@
 #include <linux/writeback.h>
 #include <linux/syscalls.h>
 #include <linux/swap.h>
+#include <linux/hugetlb.h>
 
 #include <asm/unistd.h>
 
 #include "internal.h"
 
+static int fadvise_inject_error(struct file *file, struct address_space *mapping,
+				loff_t offset, off_t endbyte, int advice)
+{
+	pgoff_t start_index, end_index, index, next;
+	struct folio *folio;
+	unsigned int shift;
+	unsigned long pfn;
+	int ret;
+
+	if (!IS_ENABLED(CONFIG_MEMORY_FAILURE))
+		return -EOPNOTSUPP;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (is_file_hugepages(file))
+		shift = huge_page_shift(hstate_file(file));
+	else
+		shift = PAGE_SHIFT;
+	start_index = offset >> shift;
+	end_index = endbyte >> shift;
+
+	index = start_index;
+	while (index <= end_index) {
+		folio = filemap_get_folio(mapping, index);
+		if (IS_ERR(folio))
+			return PTR_ERR(folio);
+
+		next = folio_next_index(folio);
+		pfn = folio_pfn(folio);
+		if (advice == FADV_SOFT_OFFLINE) {
+			pr_info("Soft offlining pfn %#lx at file index %#lx\n",
+				pfn, index);
+			ret = soft_offline_page(pfn, MF_COUNT_INCREASED);
+		} else {
+			pr_info("Injecting memory failure for pfn %#lx at file index %#lx\n",
+				pfn, index);
+			ret = memory_failure(pfn, MF_COUNT_INCREASED | MF_SW_SIMULATED);
+			if (ret == -EOPNOTSUPP)
+				ret = 0;
+		}
+
+		if (ret)
+			return ret;
+		index = next;
+	}
+
+	return 0;
+}
+
 /*
  * POSIX_FADV_WILLNEED could set PG_Referenced, and POSIX_FADV_NOREUSE could
  * deactivate the pages and clear PG_Referenced.
@@ -57,11 +108,13 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 		case POSIX_FADV_NOREUSE:
 		case POSIX_FADV_DONTNEED:
 			/* no bad return value, but ignore advice */
+			return 0;
+		case FADV_HWPOISON:
+		case FADV_SOFT_OFFLINE:
 			break;
 		default:
 			return -EINVAL;
 		}
-		return 0;
 	}
 
 	/*
@@ -170,6 +223,9 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 			}
 		}
 		break;
+	case FADV_HWPOISON:
+	case FADV_SOFT_OFFLINE:
+		return fadvise_inject_error(file, mapping, offset, endbyte, advice);
 	default:
 		return -EINVAL;
 	}
-- 
2.25.1

