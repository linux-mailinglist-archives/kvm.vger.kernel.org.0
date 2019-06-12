Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34D3F42D24
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 19:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437118AbfFLRL6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 13:11:58 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:49815 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbfFLRL5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 13:11:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1560359517; x=1591895517;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y0y2fCtE+zaOH2XT3643VHxhFHXbECws0ZTrhMzBQQU=;
  b=T1+M/fEJAofcbX7d4d2xJiXxoxc2bfBBTqATNmcJiX0+868WyIzqcaFX
   vfkzJ3/fHzIrF9ZBoa+N2KCJZ6rG9MEFonNJLfkEFYFwXWUC1ikCWar+T
   etfw52zh5mRgCh42rihGWFPb9bAMeEN0jVCT9J3ohqw6tVMTKb5hcZ7Mh
   w=;
X-IronPort-AV: E=Sophos;i="5.62,366,1554768000"; 
   d="scan'208";a="805048839"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 12 Jun 2019 17:11:56 +0000
Received: from ua08cfdeba6fe59dc80a8.ant.amazon.com (pdx2-ws-svc-lb17-vlan3.amazon.com [10.247.140.70])
        by email-inbound-relay-2b-c7131dcf.us-west-2.amazon.com (Postfix) with ESMTPS id 45AE6A256D;
        Wed, 12 Jun 2019 17:11:56 +0000 (UTC)
Received: from ua08cfdeba6fe59dc80a8.ant.amazon.com (ua08cfdeba6fe59dc80a8.ant.amazon.com [127.0.0.1])
        by ua08cfdeba6fe59dc80a8.ant.amazon.com (8.15.2/8.15.2/Debian-3) with ESMTP id x5CHBsGK018632;
        Wed, 12 Jun 2019 19:11:54 +0200
Received: (from mhillenb@localhost)
        by ua08cfdeba6fe59dc80a8.ant.amazon.com (8.15.2/8.15.2/Submit) id x5CHBr1J018630;
        Wed, 12 Jun 2019 19:11:53 +0200
From:   Marius Hillenbrand <mhillenb@amazon.de>
To:     kvm@vger.kernel.org
Cc:     Marius Hillenbrand <mhillenb@amazon.de>,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-mm@kvack.org, Alexander Graf <graf@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Julian Stecklina <jsteckli@amazon.de>
Subject: [RFC 08/10] kvm, vmx: move register clearing out of assembly path
Date:   Wed, 12 Jun 2019 19:08:40 +0200
Message-Id: <20190612170834.14855-9-mhillenb@amazon.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190612170834.14855-1-mhillenb@amazon.de>
References: <20190612170834.14855-1-mhillenb@amazon.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Julian Stecklina <jsteckli@amazon.de>

Split the security related register clearing out of the large inline
assembly VM entry path. This results in two slightly less complicated
inline assembly statements, where it is clearer what each one does.

Signed-off-by: Julian Stecklina <jsteckli@amazon.de>
[rebased to 4.20; note that the purpose of this patch is to make the
changes in the next commit more readable. we will drop this patch when
rebasing to 5.x, since major refactoring of KVM makes it redundant.]
Signed-off-by: Marius Hillenbrand <mhillenb@amazon.de>
Cc: Alexander Graf <graf@amazon.de>
Cc: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/vmx.c | 46 +++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 16a383635b59..0fe9a4ab8268 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -11582,24 +11582,7 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		"mov %%r13, %c[r13](%0) \n\t"
 		"mov %%r14, %c[r14](%0) \n\t"
 		"mov %%r15, %c[r15](%0) \n\t"
-		/*
-		* Clear host registers marked as clobbered to prevent
-		* speculative use.
-		*/
-		"xor %%r8d,  %%r8d \n\t"
-		"xor %%r9d,  %%r9d \n\t"
-		"xor %%r10d, %%r10d \n\t"
-		"xor %%r11d, %%r11d \n\t"
-		"xor %%r12d, %%r12d \n\t"
-		"xor %%r13d, %%r13d \n\t"
-		"xor %%r14d, %%r14d \n\t"
-		"xor %%r15d, %%r15d \n\t"
 #endif
-
-		"xor %%eax, %%eax \n\t"
-		"xor %%ebx, %%ebx \n\t"
-		"xor %%esi, %%esi \n\t"
-		"xor %%edi, %%edi \n\t"
 		"pop  %%" _ASM_BP "; pop  %%" _ASM_DX " \n\t"
 		".pushsection .rodata \n\t"
 		".global vmx_return \n\t"
@@ -11636,6 +11619,35 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 #endif
 	      );
 
+	/*
+         * Explicitly clear (in addition to marking them as clobbered) all GPRs
+         * that have not been loaded with host state to prevent speculatively
+         * using the guest's values.
+         */
+	asm volatile (
+		"xor %%eax, %%eax \n\t"
+		"xor %%ebx, %%ebx \n\t"
+		"xor %%esi, %%esi \n\t"
+		"xor %%edi, %%edi \n\t"
+#ifdef CONFIG_X86_64
+		"xor %%r8d,  %%r8d \n\t"
+		"xor %%r9d,  %%r9d \n\t"
+		"xor %%r10d, %%r10d \n\t"
+		"xor %%r11d, %%r11d \n\t"
+		"xor %%r12d, %%r12d \n\t"
+		"xor %%r13d, %%r13d \n\t"
+		"xor %%r14d, %%r14d \n\t"
+		"xor %%r15d, %%r15d \n\t"
+#endif
+		::: "cc"
+#ifdef CONFIG_X86_64
+		 , "rax", "rbx", "rsi", "rdi"
+		 , "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15"
+#else
+		 , "eax", "ebx", "esi", "edi"
+#endif
+		);
+
 	/*
 	 * We do not use IBRS in the kernel. If this vCPU has used the
 	 * SPEC_CTRL MSR it may have left it on; save the value and
-- 
2.21.0

