Return-Path: <kvm+bounces-68987-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EE6zKteNc2l0xAAAu9opvQ
	(envelope-from <kvm+bounces-68987-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:03:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D32E7770C
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:03:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 23D5C3020280
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:01:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31E8E356A01;
	Fri, 23 Jan 2026 15:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fcdfEeNR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9FE929E116;
	Fri, 23 Jan 2026 15:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769180430; cv=none; b=FwDEFWXtX5oyEsi1WF3AFa3cP9VYMDa0xZl2gE+/JGqUAS/lSv9BbkzCP+fA6mB/cVdMXy600m0XL+FQ4zWWKG/Dd2i4lGRBgWe+XNbogFR1jqZ/vCvgP+AaFKDPzFUxyBwSmoQ6sS4KnYviM9ogcxJtdHm0eigbyHpDJUZ4bg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769180430; c=relaxed/simple;
	bh=FbJoGMrz+I/JDICtR2MC+0hc/OWifhsA5zpFGgiABbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAw/B1Q4YtibHZyaT48bX4sE3J8PlSQAI5jWZ5v0yNS65S+xHmiF2Rw++wo+lb/fi+13OdKnBPB4fwAERS2t+ilQ4xRM8BVxnXKrrRTyTYBZXQe1e9GmwH5MG2gUvdOw2ZuiqkMWbKX0tTnUCvRS1xr0AJ1KEbyMi7ibo4hEH1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fcdfEeNR; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769180426; x=1800716426;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FbJoGMrz+I/JDICtR2MC+0hc/OWifhsA5zpFGgiABbw=;
  b=fcdfEeNRkBntCo4IH5879Lf1XH8CK3+SSYXt/uRdXX2c6WVowc8grY5r
   NBUhsQVJeFBr+hPEaYmr2Y6IAR6WGxPhwQvB9kSuVPCC5IQDM3+EBv+OX
   h3iBOvAzeOCl8SzdKU2Kvyqdcvmbu+blnMbpBXD2LlbjbeL3EeRBrYB0/
   QK9j3wTKKRMyc+cZsOpQDpHz1p8eqTRnzedpAooKWOzUjd5Rkek2WjUON
   Rat0Lm3alkYPq2wN9JeN1GceTS7jhHpecqs1BIBxWXbGl29sg8NZoCqkc
   bSSO9JlDtL9VAMgG6F7sQxzOeUDRW8M/ppvSa2XSAn+E4mgH6y2C1bAID
   w==;
X-CSE-ConnectionGUID: 3oQe7o/cSjKtnTrOE/+NGw==
X-CSE-MsgGUID: KeGEol1rRY+h2cq/h45PHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="70334413"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70334413"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:14 -0800
X-CSE-ConnectionGUID: nZVRL8jsQzSjk9zcZxoLhg==
X-CSE-MsgGUID: S2Oub1MUSvebzDIkmmd40g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="237697125"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:14 -0800
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
	Chao Gao <chao.gao@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3 11/26] x86/virt/seamldr: Block TDX Module updates if any CPU is offline
Date: Fri, 23 Jan 2026 06:55:19 -0800
Message-ID: <20260123145645.90444-12-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260123145645.90444-1-chao.gao@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[24];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68987-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4D32E7770C
X-Rspamd-Action: no action

P-SEAMLDR requires every CPU to call the SEAMLDR.INSTALL SEAMCALL during
updates.  So, every CPU should be online.

Check if all CPUs are online and abort the update if any CPU is offline at
the very beginning. Without this check, P-SEAMLDR will report failure at a
later phase where the old TDX module is gone and TDs have to be killed.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/virt/vmx/tdx/seamldr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index af7a6621e5e0..88388aa0fb5f 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -6,6 +6,8 @@
  */
 #define pr_fmt(fmt)	"seamldr: " fmt
 
+#include <linux/cpuhplock.h>
+#include <linux/cpumask.h>
 #include <linux/irqflags.h>
 #include <linux/mm.h>
 #include <linux/types.h>
@@ -84,6 +86,12 @@ int seamldr_install_module(const u8 *data, u32 size)
 	if (!is_vmalloc_addr(data))
 		return -EINVAL;
 
+	guard(cpus_read_lock)();
+	if (!cpumask_equal(cpu_online_mask, cpu_present_mask)) {
+		pr_err("Cannot update TDX module if any CPU is offline\n");
+		return -EBUSY;
+	}
+
 	/* TODO: Update TDX Module here */
 	return 0;
 }
-- 
2.47.3


