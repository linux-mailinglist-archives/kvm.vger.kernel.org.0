Return-Path: <kvm+bounces-70967-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QJEoCxzmjWms8QAAu9opvQ
	(envelope-from <kvm+bounces-70967-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:39:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A2E4912E52F
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:39:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 149DC316E626
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 14:36:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C359135E52D;
	Thu, 12 Feb 2026 14:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LVNk1ZDj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635B535D5F3;
	Thu, 12 Feb 2026 14:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770906978; cv=none; b=Yt2J3/z7dy0Y+5yL9Bi2Th2YgvxdmH+/CgYEG7yW0tIZ0jW4h+MT1H2HXWUmGAGqk13QT3Z2sWLpAoh6KL6SAh+6J7X+8chQubtU0XrSk3Y3gPfOYQK7pezJyhrU1cWdfpzmutM+PeKw+8H8KnjQwhj3cjM4PqeshpXdxtvPyRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770906978; c=relaxed/simple;
	bh=k2DuuaKpn+DVryFaIKKAVgA5FgWmenrws7RxXEkqSJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ovg6L/RVTdpXDmJZwr14wU06WeNiENlYKliF+XtUk8l0+MaFQ6jSY5ZlBdG96SLHuSJzbLDOm8uuvz9HVJUOYE1c0D7Y6FGymXanDcC+6+Pli4L9B0VMeYB99K3PLTVSbCdW0geLaw9YSoNhJDfeSayLpSH2x7ofHNst198j2O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LVNk1ZDj; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770906976; x=1802442976;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k2DuuaKpn+DVryFaIKKAVgA5FgWmenrws7RxXEkqSJ4=;
  b=LVNk1ZDjPUHJvsJESTofqH/IUFh9taFPxuOEnaCaptG+sR78SY4AlOwz
   t9d/9xaSb/nKCrM8Plimy2WEa4c1NPjVeruDsNdc/jLc/KCotJWYnQ7o8
   b0GKijUwaB+GmeHDfYZGcWNy0UGOlDtfxen0hMsJL0j3iLqc/tm0Ru0Aa
   p3e9ZX+ZOvuXS1+9UD4eVOo6+kQ3vs73ZYMcsPhS+7JPXWkDqXpAjWMZ3
   PTmAEo1iZD1iKMFhhWSYVx3YOAnCZTdBUbrqs3dxLqZteVB0kQzaofXfX
   yCHsKyeF65bt+iQ2ypX+rxDihfkAER6FwZNZRV3vFiOiVmqHAbP2eSeuc
   Q==;
X-CSE-ConnectionGUID: tADJFuT2QVePZSmwUR0umQ==
X-CSE-MsgGUID: 4rEWz0j4RUmYo96v4lhkhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="89662768"
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="89662768"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:36:15 -0800
X-CSE-ConnectionGUID: nhsSAK4dRrCCQixVYJsDwA==
X-CSE-MsgGUID: wVjmomZ7QwanogookcTYlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="211428211"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:36:14 -0800
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org
Cc: reinette.chatre@intel.com,
	ira.weiny@intel.com,
	kai.huang@intel.com,
	dan.j.williams@intel.com,
	yilun.xu@linux.intel.com,
	sagis@google.com,
	vannapurve@google.com,
	paulmck@kernel.org,
	nik.borisov@suse.com,
	zhenzhong.duan@intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com,
	kas@kernel.org,
	dave.hansen@linux.intel.com,
	vishal.l.verma@intel.com,
	binbin.wu@linux.intel.com,
	tony.lindgren@linux.intel.com,
	Chao Gao <chao.gao@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v4 04/24] x86/virt/seamldr: Introduce a wrapper for P-SEAMLDR SEAMCALLs
Date: Thu, 12 Feb 2026 06:35:07 -0800
Message-ID: <20260212143606.534586-5-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212143606.534586-1-chao.gao@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70967-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: A2E4912E52F
X-Rspamd-Action: no action

The TDX architecture uses the "SEAMCALL" instruction to communicate with
SEAM mode software. Right now, the only SEAM mode software that the kernel
communicates with is the TDX module. But, there is actually another
component that runs in SEAM mode but it is separate from the TDX module:
the persistent SEAM loader or "P-SEAMLDR". Right now, the only component
that communicates with it is the BIOS which loads the TDX module itself at
boot. But, to support updating the TDX module, the kernel now needs to be
able to talk to it.

P-SEAMLDR SEAMCALLs differ from TDX Module SEAMCALLs in areas such as
concurrency requirements. Add a P-SEAMLDR wrapper to handle these
differences and prepare for implementing concrete functions.

Note that unlike P-SEAMLDR, there is also a non-persistent SEAM loader
("NP-SEAMLDR"). This is an authenticated code module (ACM) that is not
callable at runtime. Only BIOS launches it to load P-SEAMLDR at boot;
the kernel does not interact with it.

For details of P-SEAMLDR SEAMCALLs, see Intel® Trust Domain CPU
Architectural Extensions, Revision 343754-002, Chapter 2.3 "INSTRUCTION
SET REFERENCE".

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Link: https://cdrdv2.intel.com/v1/dl/getContent/733582 # [1]
---
v4:
 - Give more background about P-SEAMLDR in changelog [Dave]
 - Don't handle P-SEAMLDR's "no_entropy" error [Dave]
 - Assume current VMCS is preserved across P-SEAMLDR calls [Dave]
 - I'm not adding Reviewed-by tags as the code has changed significantly.
v2:
 - don't create a new, inferior framework to save/restore VMCS
 - use human-friendly language, just "current VMCS" rather than
   SDM term "current-VMCS pointer"
 - don't mix guard() with goto
---
 arch/x86/virt/vmx/tdx/Makefile  |  2 +-
 arch/x86/virt/vmx/tdx/seamldr.c | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/virt/vmx/tdx/seamldr.c

diff --git a/arch/x86/virt/vmx/tdx/Makefile b/arch/x86/virt/vmx/tdx/Makefile
index 90da47eb85ee..d1dbc5cc5697 100644
--- a/arch/x86/virt/vmx/tdx/Makefile
+++ b/arch/x86/virt/vmx/tdx/Makefile
@@ -1,2 +1,2 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-y += seamcall.o tdx.o
+obj-y += seamcall.o seamldr.o tdx.o
diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
new file mode 100644
index 000000000000..fb59b3e2aa37
--- /dev/null
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * P-SEAMLDR support for TDX Module management features like runtime updates
+ *
+ * Copyright (C) 2025 Intel Corporation
+ */
+#define pr_fmt(fmt)	"seamldr: " fmt
+
+#include <linux/spinlock.h>
+
+#include "seamcall_internal.h"
+
+/*
+ * Serialize P-SEAMLDR calls since the hardware only allows a single CPU to
+ * interact with P-SEAMLDR simultaneously.
+ */
+static DEFINE_RAW_SPINLOCK(seamldr_lock);
+
+static __maybe_unused int seamldr_call(u64 fn, struct tdx_module_args *args)
+{
+	/*
+	 * Serialize P-SEAMLDR calls and disable interrupts as the calls
+	 * can be made from IRQ context.
+	 */
+	guard(raw_spinlock_irqsave)(&seamldr_lock);
+	return seamcall_prerr(fn, args);
+}
-- 
2.47.3


