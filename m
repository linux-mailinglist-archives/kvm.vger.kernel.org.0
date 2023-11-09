Return-Path: <kvm+bounces-1340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E83C7E6A1F
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 12:58:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FE271C20E41
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 11:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D0CC1DA20;
	Thu,  9 Nov 2023 11:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KuZBZaMn"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD071DA2C
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 11:58:28 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090C435A5;
	Thu,  9 Nov 2023 03:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699531108; x=1731067108;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dMT+cVNkz5s3pqtS4rilxjvJDXZQPHh7uYPdNVf2Njg=;
  b=KuZBZaMn9IofNbX5ccsxoeiIr5FB1VGqDKVMqO/CbPiMqPLvHWQqmXAT
   hv7JGkRrJ21iZg39rjexzG+vktdJvQTktwxo2JtLq45MDHwqMx82Z4TJB
   mqqWbWuSRu5CNB3zW5nLT55OKlAHAnOspnArTtOrV3IPAOoe+ttKJz0Y/
   czfL6nSoclfn++xXfY/1uBRLpZWXT9Quj+9WCfXfiMsutLZGSgJbd8i6H
   KJo8jjio5Na0hsa5lzBvigTX6T7udQ1hTljtGIU2RqcMWWxkWm303c/6g
   A7x49dh4qYXHsdaKiYu7FYCFptt95iYVNh1/X0aeBu6DgHvSjVBYjDUgo
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="2936781"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="2936781"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:58:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="766977056"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="766977056"
Received: from shadphix-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.83.35])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:58:21 -0800
From: Kai Huang <kai.huang@intel.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: x86@kernel.org,
	dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	peterz@infradead.org,
	tony.luck@intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	rafael@kernel.org,
	david@redhat.com,
	dan.j.williams@intel.com,
	len.brown@intel.com,
	ak@linux.intel.com,
	isaku.yamahata@intel.com,
	ying.huang@intel.com,
	chao.gao@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com,
	nik.borisov@suse.com,
	bagasdotme@gmail.com,
	sagis@google.com,
	imammedo@redhat.com,
	kai.huang@intel.com
Subject: [PATCH v15 21/23] x86/virt/tdx: Handle TDX interaction with ACPI S3 and deeper states
Date: Fri, 10 Nov 2023 00:55:58 +1300
Message-ID: <d316e5dda29bb45e85305077f8f8c6f17a82855e.1699527082.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1699527082.git.kai.huang@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TDX cannot survive from S3 and deeper states.  The hardware resets and
disables TDX completely when platform goes to S3 and deeper.  Both TDX
guests and the TDX module get destroyed permanently.

The kernel uses S3 to support suspend-to-ram, and S4 or deeper states to
support hibernation.  The kernel also maintains TDX states to track
whether it has been initialized and its metadata resource, etc.  After
resuming from S3 or hibernation, these TDX states won't be correct
anymore.

Theoretically, the kernel can do more complicated things like resetting
TDX internal states and TDX module metadata before going to S3 or
deeper, and re-initialize TDX module after resuming, etc, but there is
no way to save/restore TDX guests for now.

Until TDX supports full save and restore of TDX guests, there is no big
value to handle TDX module in suspend and hibernation alone.  To make
things simple, just choose to make TDX mutually exclusive with S3 and
hibernation.

Note the TDX module is initialized at runtime.  To avoid having to deal
with the fuss of determining TDX state at runtime, just choose TDX vs S3
and hibernation at kernel early boot.  It's a bad user experience if the
choice of TDX and S3/hibernation is done at runtime anyway, i.e., the
user can experience being able to do S3/hibernation but later becoming
unable to due to TDX being enabled.

Disable TDX in kernel early boot when hibernation support is available.
Currently there's no mechanism exposed by the hibernation code to allow
other kernel code to disable hibernation once for all.

Disable ACPI S3 when TDX is enabled by the BIOS.  For now the user needs
to disable TDX in the BIOS to use ACPI S3.  A new kernel command line
can be added in the future if there's a need to let user disable TDX
host via kernel command line.

Alternatively, the kernel could disable TDX when ACPI S3 is supported
and request the user to disable S3 to use TDX.  But there's no existing
kernel command line to do that, and BIOS doesn't always have an option
to disable S3.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---

v14 -> v15:
 - Simplify the error message when hibernation_available() returns true
   by removing "Use 'nohibernate' kernel command line part".  Instead,
   explain how to resolve in the Documentation patch. (Rafael)
 - Simplify the comment around hibernation_available(). (Rafael)
 - Also guide acpi_suspend_lowlevel with CONFIG_SUSPEND.

v13 -> v14:
 - New patch

---
 arch/x86/virt/vmx/tdx/tdx.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 53a87034ad59..cc21a0f25bee 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -26,6 +26,8 @@
 #include <linux/sort.h>
 #include <linux/log2.h>
 #include <linux/reboot.h>
+#include <linux/acpi.h>
+#include <linux/suspend.h>
 #include <asm/msr-index.h>
 #include <asm/msr.h>
 #include <asm/page.h>
@@ -1402,6 +1404,15 @@ static int __init tdx_init(void)
 		return -ENODEV;
 	}
 
+	/*
+	 * At this point, hibernation_available() indicates whether or
+	 * not hibernation support has been permanently disabled.
+	 */
+	if (hibernation_available()) {
+		pr_err("initialization failed: Hibernation support is enabled\n");
+		return -ENODEV;
+	}
+
 	err = register_memory_notifier(&tdx_memory_nb);
 	if (err) {
 		pr_err("initialization failed: register_memory_notifier() failed (%d)\n",
@@ -1417,6 +1428,11 @@ static int __init tdx_init(void)
 		return -ENODEV;
 	}
 
+#if defined(CONFIG_ACPI) && defined(CONFIG_SUSPEND)
+	pr_info("Disable ACPI S3. Turn off TDX in the BIOS to use ACPI S3.\n");
+	acpi_suspend_lowlevel = NULL;
+#endif
+
 	/*
 	 * Just use the first TDX KeyID as the 'global KeyID' and
 	 * leave the rest for TDX guests.
-- 
2.41.0


