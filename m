Return-Path: <kvm+bounces-61467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 228DCC1ECCD
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 08:38:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3BE2B189C846
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 07:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7129337BA3;
	Thu, 30 Oct 2025 07:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aBY3Jvjk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FD6223715
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 07:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761809851; cv=none; b=XwMENWAfmyqji9jVgLDixZby2oXCiBsOYTOu7Z8LGENsbSuB8NpLSN5IbJiVvhCE89j/hVtNIsX8UhVDOpZrRLXKDoWlcOrMa/Q3GvwfTmxW+jMSj7xk/LjQaIP1H9QH4Vywrjh3VWw5Ty/s48Q6huIZdA14itNz7UaCivrpQlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761809851; c=relaxed/simple;
	bh=tywEFLJqYmtDHNTAyNpsIcgtHrVkgl0VoirPIFqG+EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjYmluSb9pU29Kcu1olxDwbFkLgJaOOZZXw48BLFDNDjQGI2JJUQBUuCrffsmBVED91Role6mFKqNKPRWjgleIuNFzuFZpLDhCxic69BL+JguYKESfemslMLpeq+eunh9Tgvtw0lrqcJi5h+bUa7GZjnaUsTfW+yI6tQf8kfUSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aBY3Jvjk; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761809850; x=1793345850;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tywEFLJqYmtDHNTAyNpsIcgtHrVkgl0VoirPIFqG+EM=;
  b=aBY3JvjkiIzfduo/zdxKxb0UhxGZZb6l0MYANlu1hDm7UUvb3CwYnBDQ
   60wTR7w35DZ1Pkkd7s1Q8BmHP7/YESfeGWkWUbv7hNgU4sb+CjH+/Y2mj
   GX0aYllxKIRontS4H4cqSXW2QR14IbJbwKve76QMQKTtVj7VnQlRdbRnm
   S3zFTBdWYrmzUgwgDKUeB7gyJse0033G7pdg0tYTeJmTVQ+zWB1PcNxrU
   VhBX2d0Tdt6bmYWZwM8lIZWw4nsG+166a2AXFa/uVeWK5xXGgdBv1Y7mb
   66pGbuK3xlVJ1JcbGrv8G2ITJ1Dq1/YUSP3HUrsasKy06ZCton9a8wtx+
   w==;
X-CSE-ConnectionGUID: fDV4fEAnRPeuQZhO+cyl3w==
X-CSE-MsgGUID: XKX7A3ScTA6dVssqMEFXxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63845617"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63845617"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 00:37:28 -0700
X-CSE-ConnectionGUID: EPZilhOpQ0C6BmmbBkzlow==
X-CSE-MsgGUID: IyhLkLdRTVmd7uV5y3oaCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,266,1754982000"; 
   d="scan'208";a="186229656"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 00:37:27 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com,
	minipli@grsecurity.net,
	Chao Gao <chao.gao@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 1/2] x86/eventinj: Use global asm label for nested NMI IP address verification
Date: Thu, 30 Oct 2025 00:37:22 -0700
Message-ID: <20251030073724.259937-2-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251030073724.259937-1-chao.gao@intel.com>
References: <20251030073724.259937-1-chao.gao@intel.com>
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

Also make 'iret_stack' local to nmi_iret_isr() since it isn't accessed
anywhere else.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
Changes in v2:
 - make 'iret_stack' local to nmi_iret_isr().

 x86/eventinj.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/x86/eventinj.c b/x86/eventinj.c
index 6fbb2d0f..3f28b9b5 100644
--- a/x86/eventinj.c
+++ b/x86/eventinj.c
@@ -126,13 +126,13 @@ static void nmi_isr(struct ex_regs *r)
 	printf("After nested NMI to self\n");
 }
 
-unsigned long *iret_stack;
+extern char ip_after_iret[];
 
 static void nested_nmi_iret_isr(struct ex_regs *r)
 {
 	printf("Nested NMI isr running rip=%lx\n", r->rip);
 
-	if (r->rip == iret_stack[-3])
+	if (r->rip == (unsigned long)ip_after_iret)
 		test_count++;
 }
 
@@ -156,11 +156,11 @@ asm("do_iret:"
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
@@ -170,13 +170,17 @@ asm("do_iret:"
 	"outl %eax, $0xe4 \n\t"		// flush page
 	"1: \n\t"
 	"iret"W" \n\t"
-	"2: xchg %"R "dx, %"R "sp \n\t"	// point to old stack
+	".global ip_after_iret \n\t"
+	"ip_after_iret: \n\t"
+	"xchg %"R "dx, %"R "sp \n\t"	// point to old stack
 	"ret\n\t"
    );
 
 static void nmi_iret_isr(struct ex_regs *r)
 {
 	unsigned long *s = alloc_page();
+	unsigned long *iret_stack;
+
 	test_count++;
 	printf("NMI isr running stack %p\n", s);
 	handle_exception(2, nested_nmi_iret_isr);
-- 
2.47.3


