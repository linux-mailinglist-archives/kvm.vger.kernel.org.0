Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17BC673E1BA
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 16:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjFZOPH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 10:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbjFZOOj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 10:14:39 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048392136;
        Mon, 26 Jun 2023 07:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687788854; x=1719324854;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0Ki7Z26euf8kOefnzsmE9r5pIZDZOVNrEdzPzosdKV8=;
  b=TDS1PXNQnMhvBxbuf+z787MPjPgRQXXpPvjgaJFXHdHKf9s5O++AE4Wa
   +0iCMHJThmtn1bSwaZScyPhTXurcDOt2S+sGON3lBYMq4WmwBQo/ZX4Kh
   1ZCV6xREz6TuaSU5UIWwNgBnprNBjFz+TZsbub6JhvbSk8+Xwjriqpr2q
   PtEp3cYcVZ4sO1/AAzxlqDEGKzEEiFmZc6SnhVaj90GaYtlm26Xco1Va2
   4fNePkwZ98o5pcgn45dCEntcxW7yXzgGv7S57W0LGmDy5NimaNoyJILx+
   REPKr8xqbhfNiueQI9RAYM0sSTexaosPMz63rQ+sgnIxJLUL7qjwkiCU/
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="346033662"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="346033662"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 07:14:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10753"; a="890292303"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="890292303"
Received: from smithau-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.213.179.223])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 07:14:06 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, x86@kernel.org, dave.hansen@intel.com,
        kirill.shutemov@linux.intel.com, tony.luck@intel.com,
        peterz@infradead.org, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, david@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, ashok.raj@intel.com,
        reinette.chatre@intel.com, len.brown@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, ying.huang@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, nik.borisov@suse.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com,
        kai.huang@intel.com
Subject: [PATCH v12 06/22] x86/virt/tdx: Handle SEAMCALL running out of entropy error
Date:   Tue, 27 Jun 2023 02:12:36 +1200
Message-Id: <b5bf58246659572bd68d46b14e90e9e5b37f7f93.1687784645.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1687784645.git.kai.huang@intel.com>
References: <cover.1687784645.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some SEAMCALLs use the RDRAND hardware and can fail for the same reasons
as RDRAND.  Use the kernel RDRAND retry logic for them.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---

v11 -> v12:
 - Added tags from Dave/Kirill/David.
 - Improved changelog (Dave).
 - Slight code improvement (David)
   - Initialize retry directly when declaring it.
   - Simplify comment around mimic rdrand_long().

v10 -> v11:
 - New patch

---
 arch/x86/virt/vmx/tdx/tdx.c | 16 ++++++++++++++--
 arch/x86/virt/vmx/tdx/tdx.h | 17 +++++++++++++++++
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index f8233cba5931..141d12376c4d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -15,6 +15,7 @@
 #include <linux/smp.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
+#include <asm/archrandom.h>
 #include <asm/tdx.h>
 #include "tdx.h"
 
@@ -32,12 +33,23 @@ static int __always_unused seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
 				    u64 *seamcall_ret,
 				    struct tdx_module_output *out)
 {
+	int cpu, retry = RDRAND_RETRY_LOOPS;
 	u64 sret;
-	int cpu;
 
 	/* Need a stable CPU id for printing error message */
 	cpu = get_cpu();
-	sret = __seamcall(fn, rcx, rdx, r8, r9, out);
+
+	/*
+	 * Certain SEAMCALL leaf functions may return error due to
+	 * running out of entropy, in which case the SEAMCALL should
+	 * be retried.  Handle this in SEAMCALL common function.
+	 *
+	 * Mimic rdrand_long() retry behavior.
+	 */
+	do {
+		sret = __seamcall(fn, rcx, rdx, r8, r9, out);
+	} while (sret == TDX_RND_NO_ENTROPY && --retry);
+
 	put_cpu();
 
 	/* Save SEAMCALL return code if the caller wants it */
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 48ad1a1ba737..55dbb1b8c971 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -4,6 +4,23 @@
 
 #include <linux/types.h>
 
+/*
+ * This file contains both macros and data structures defined by the TDX
+ * architecture and Linux defined software data structures and functions.
+ * The two should not be mixed together for better readability.  The
+ * architectural definitions come first.
+ */
+
+/*
+ * TDX SEAMCALL error codes
+ */
+#define TDX_RND_NO_ENTROPY	0x8000020300000000ULL
+
+/*
+ * Do not put any hardware-defined TDX structure representations below
+ * this comment!
+ */
+
 struct tdx_module_output;
 u64 __seamcall(u64 fn, u64 rcx, u64 rdx, u64 r8, u64 r9,
 	       struct tdx_module_output *out);
-- 
2.40.1

