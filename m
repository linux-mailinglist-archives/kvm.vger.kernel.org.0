Return-Path: <kvm+bounces-4678-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B3AB816716
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 08:11:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B46701F21CBA
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 07:11:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 919F910959;
	Mon, 18 Dec 2023 07:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RdpKSOSF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE7710944
	for <kvm@vger.kernel.org>; Mon, 18 Dec 2023 07:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702883448; x=1734419448;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SOMBezozK1ofJO9JQ3PfOXzV9qPGJa/V/DMqE1mQkas=;
  b=RdpKSOSFK0d10dyiuBicSFXA61uZSjvA9GCh75oQEINsENHG+irbLz0Q
   XTnYYPOKBl+6x8FYL7bmajoPde1jjOOPphiCE3SMdG7oE7Q5t1hzcENYk
   7ge8HwXmwIzJnA2qALAbTZTN3ZiHsdM7gij8cf78JrCt7KhPt09olXka0
   Ffshqtnn9AMOanw+HBzSzqWZulFSEIP1Nothezy83hleAes8u4/OASRp+
   73JHEyyKvXWvUnmbn8H8BA6RTuIQGdC5PmlVehGi2NAFUc+Hr72LaJWK9
   2hOp8Wj9wzIpVQDVuBjkCY+r6ZvcZoRjMrgo6aHwTDyWgfzaaTlZq+gdH
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="2667952"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="2667952"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2023 23:10:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="1106824745"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="1106824745"
Received: from pc.sh.intel.com ([10.238.200.75])
  by fmsmga005.fm.intel.com with ESMTP; 17 Dec 2023 23:10:43 -0800
From: Qian Wen <qian.wen@intel.com>
To: kvm@vger.kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	alexandru.elisei@arm.com,
	yu.c.zhang@intel.com,
	zhenzhong.duan@intel.com,
	isaku.yamahata@intel.com,
	chenyi.qiang@intel.com,
	ricarkol@google.com,
	qian.wen@intel.com
Subject: [kvm-unit-tests RFC v2 12/18] x86 TDX: Add a formal IPI handler
Date: Mon, 18 Dec 2023 15:22:41 +0800
Message-Id: <20231218072247.2573516-13-qian.wen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231218072247.2573516-1-qian.wen@intel.com>
References: <20231218072247.2573516-1-qian.wen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

Current IPI handler may corrupt cpu context, it's not an big issue as
AP only enable interrupt in idle loop.

But in TD-guest, hlt instruction is simulated though tdvmcall in #VE
handler. IPI will corrupt #VE context.

Save and restore cpu context in IPI handler to avoid crash.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Reviewed-by: Yu Zhang <yu.c.zhang@intel.com>
Link: https://lore.kernel.org/r/20220303071907.650203-12-zhenzhong.duan@intel.com
Signed-off-by: Qian Wen <qian.wen@intel.com>
---
 lib/x86/smp.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/lib/x86/smp.c b/lib/x86/smp.c
index 7147cf6b..171c5939 100644
--- a/lib/x86/smp.c
+++ b/lib/x86/smp.c
@@ -60,12 +60,20 @@ static __attribute__((used)) void ipi(void)
 
 asm (
 	 "ipi_entry: \n"
-	 "   call ipi \n"
-#ifndef __x86_64__
-	 "   iret"
-#else
-	 "   iretq"
+#ifdef __x86_64__
+	 "push %r15; push %r14; push %r13; push %r12 \n\t"
+	 "push %r11; push %r10; push %r9; push %r8 \n\t"
 #endif
+	 "push %"R "di; push %"R "si; push %"R "bp; \n\t"
+	 "push %"R "bx; push %"R "dx; push %"R "cx; push %"R "ax \n\t"
+	 "call ipi \n\t"
+	 "pop %"R "ax; pop %"R "cx; pop %"R "dx; pop %"R "bx \n\t"
+	 "pop %"R "bp; pop %"R "si; pop %"R "di \n\t"
+#ifdef __x86_64__
+	 "pop %r8; pop %r9; pop %r10; pop %r11 \n\t"
+	 "pop %r12; pop %r13; pop %r14; pop %r15 \n\t"
+#endif
+	 "iret"W" \n\t"
 	 );
 
 int cpu_count(void)
-- 
2.25.1


