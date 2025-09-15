Return-Path: <kvm+bounces-57582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C99F0B57F9E
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 16:55:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AFA457B1194
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 14:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A8C63431FA;
	Mon, 15 Sep 2025 14:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d646Wcr7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23267342C8E
	for <kvm@vger.kernel.org>; Mon, 15 Sep 2025 14:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757947786; cv=none; b=eGWHSurE96jdhsgAOTtz+BEm6PLW94pGeOMYQZod6rv/oAio2iD0bgEbsNPOhQf//jkSy1+S081uyQ1IQubzzCJ9A+M52AmpST4wzELi74Erx+7wnN7YdNAl4QMC7QqIJYBjXZ6N4SQCt5j4+tftmUxUh2h0BgfgzKqmh7Ues9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757947786; c=relaxed/simple;
	bh=AXSSloKqYzldQCJGN8+3hko3pDGuYYgYDQTDLUNOXcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HGoo0awjJVM9jXrQvNs4lnrnyaA7odBExNVgea0DWUIByCCGkw7Yki5Y1vLROCAIeSgKAnmp2wk1OTEBnDUTooSx/ffmL7E3G13Ilzd/+p0SucZofs1x2qzp3s6jsBPotvSdhbnOTrYS0he88rbexEGTWA+j3OJt1xWDkrMIxPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d646Wcr7; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757947785; x=1789483785;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AXSSloKqYzldQCJGN8+3hko3pDGuYYgYDQTDLUNOXcU=;
  b=d646Wcr701UNCxLCNoUD6NO508YCropTdPn6Y8KaW2sxGBeztMb3sgh9
   F4ZT2GJYpxdgGWIQveP/aABjE1twQXBqUDI9TAEbmuzYAQYUSvDuNp7XJ
   DDVnsW/3qL5TjC7+q4e0W8BREWuV+b/grC88x80vAOoxOCzGo/S6UsONc
   oBfkVom4hGsx5KX+j/+na4gapGQJYuUf55BOyptECQTqudpE8yZn9hxM5
   k7nn9xxJo0ffX0nU1yMMsSMH+bu+kL+1ekQDiXHD9aNdfsQ1sCh3VTgpN
   fcBtLSfk5lpVJa0pfNmjb4ek7l0CBYn6u4XQRU5FOoojd44AOGithug3h
   w==;
X-CSE-ConnectionGUID: eGeTrp/eRamKJ49H1Xlhxg==
X-CSE-MsgGUID: uuMZNR//RlWbRflji/453A==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="59247132"
X-IronPort-AV: E=Sophos;i="6.18,266,1751266800"; 
   d="scan'208";a="59247132"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 07:49:43 -0700
X-CSE-ConnectionGUID: j8eKdQWzTHWIPZYNX6CBJg==
X-CSE-MsgGUID: YTxUZTRVS+my9DI4OPw7BQ==
X-ExtLoop1: 1
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 07:49:43 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	Chao Gao <chao.gao@intel.com>
Subject: [PATCH 1/2] x86/eventinj: Use global asm label for nested NMI IP address verification
Date: Mon, 15 Sep 2025 07:49:35 -0700
Message-ID: <20250915144936.113996-2-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915144936.113996-1-chao.gao@intel.com>
References: <20250915144936.113996-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use a global asm label to get the expected IP address for nested NMI
interception instead of reading a hardcoded offset from the stack.

the NMI test in eventinj.c verifies that a nested NMI occurs immediately at
the return address (IP register) in the IRET frame, as IRET opens the
NMI window. Currently, nested_nmi_iret_isr() reads the return address
using a magic offset (iret_stack[-3]), which is unclear and may break if
more values are pushed to the "iret_stack".

To improve readability, add a global 'ip_after_iret' label for the expected
return address, push it to the IRET frame, and verify it matches the
interrupted address in the nested NMI handler.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 x86/eventinj.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/x86/eventinj.c b/x86/eventinj.c
index 6fbb2d0f..ec8a5ef1 100644
--- a/x86/eventinj.c
+++ b/x86/eventinj.c
@@ -127,12 +127,13 @@ static void nmi_isr(struct ex_regs *r)
 }
 
 unsigned long *iret_stack;
+extern char ip_after_iret[];
 
 static void nested_nmi_iret_isr(struct ex_regs *r)
 {
 	printf("Nested NMI isr running rip=%lx\n", r->rip);
 
-	if (r->rip == iret_stack[-3])
+	if (r->rip == (unsigned long)ip_after_iret)
 		test_count++;
 }
 
@@ -156,11 +157,11 @@ asm("do_iret:"
 	"mov %cs, %ecx \n\t"
 	"push"W" %"R "cx \n\t"
 #ifndef __x86_64__
-	"push"W" $2f \n\t"
+	"push"W" $ip_after_iret \n\t"
 
 	"cmpb $0, no_test_device\n\t"	// see if need to flush
 #else
-	"leaq 2f(%rip), %rbx \n\t"
+	"leaq ip_after_iret(%rip), %rbx \n\t"
 	"pushq %rbx \n\t"
 
 	"mov no_test_device(%rip), %bl \n\t"
@@ -170,7 +171,9 @@ asm("do_iret:"
 	"outl %eax, $0xe4 \n\t"		// flush page
 	"1: \n\t"
 	"iret"W" \n\t"
-	"2: xchg %"R "dx, %"R "sp \n\t"	// point to old stack
+	".global ip_after_iret \n\t"
+	"ip_after_iret: \n\t"
+	"xchg %"R "dx, %"R "sp \n\t"	// point to old stack
 	"ret\n\t"
    );
 
-- 
2.47.3


