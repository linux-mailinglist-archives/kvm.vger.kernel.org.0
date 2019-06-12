Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4004642D22
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 19:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409054AbfFLRLr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 13:11:47 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:53939 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406363AbfFLRLr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 13:11:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1560359506; x=1591895506;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BCwbtGWRrYM8rpdyPautZ9rurvQMH3lCItd7cCuySww=;
  b=ZpUE5n3n9rssRyVx4xgubcPZn8v32YgoRu+51EvPH4HMG/TYGqvq6Pr8
   8jPSQz+j5cL8ty6MRVHWKMz8E424fqQv9jyZh95q18xhw7hkLlyjGeLaJ
   e1LuCmIga9v0FUFhcdmBNNWMegxATh6bEw8gbENE6zYQUHF6hwsyi7n8G
   8=;
X-IronPort-AV: E=Sophos;i="5.62,366,1554768000"; 
   d="scan'208";a="770066910"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-87a10be6.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 12 Jun 2019 17:11:44 +0000
Received: from ua08cfdeba6fe59dc80a8.ant.amazon.com (pdx2-ws-svc-lb17-vlan3.amazon.com [10.247.140.70])
        by email-inbound-relay-2c-87a10be6.us-west-2.amazon.com (Postfix) with ESMTPS id 4A3B9A2424;
        Wed, 12 Jun 2019 17:11:43 +0000 (UTC)
Received: from ua08cfdeba6fe59dc80a8.ant.amazon.com (ua08cfdeba6fe59dc80a8.ant.amazon.com [127.0.0.1])
        by ua08cfdeba6fe59dc80a8.ant.amazon.com (8.15.2/8.15.2/Debian-3) with ESMTP id x5CHBftS018553;
        Wed, 12 Jun 2019 19:11:41 +0200
Received: (from mhillenb@localhost)
        by ua08cfdeba6fe59dc80a8.ant.amazon.com (8.15.2/8.15.2/Submit) id x5CHBexi018552;
        Wed, 12 Jun 2019 19:11:40 +0200
From:   Marius Hillenbrand <mhillenb@amazon.de>
To:     kvm@vger.kernel.org
Cc:     Marius Hillenbrand <mhillenb@amazon.de>,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-mm@kvack.org, Alexander Graf <graf@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Julian Stecklina <jsteckli@amazon.de>
Subject: [RFC 07/10] kvm, vmx: move CR2 context switch out of assembly path
Date:   Wed, 12 Jun 2019 19:08:38 +0200
Message-Id: <20190612170834.14855-8-mhillenb@amazon.de>
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

The VM entry/exit path is a giant inline assembly statement. Simplify it
by doing CR2 context switching in plain C. Move CR2 restore behind IBRS
clearing, so we reduce the amount of code we execute with IBRS on.

Using {read,write}_cr2() means KVM will use pv_mmu_ops instead of open
coding native_{read,write}_cr2(). The CR2 code has been done in
assembly since KVM's genesis[1], which predates the addition of the
paravirt ops[2], i.e. KVM isn't deliberately avoiding the paravirt
ops.

[1] Commit 6aa8b732ca01 ("[PATCH] kvm: userspace interface")
[2] Commit d3561b7fa0fb ("[PATCH] paravirt: header and stubs for paravirtualisation")

Signed-off-by: Julian Stecklina <jsteckli@amazon.de>
[rebased; note that this patch mainly improves the readability of
subsequent patches; we will drop it when rebasing to 5.x, since major
refactoring of KVM makes this patch redundant.]
Signed-off-by: Marius Hillenbrand <mhillenb@amazon.de>
Cc: Alexander Graf <graf@amazon.de>
Cc: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/vmx.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 6f59a6ad7835..16a383635b59 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -11513,6 +11513,9 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	evmcs_rsp = static_branch_unlikely(&enable_evmcs) ?
 		(unsigned long)&current_evmcs->host_rsp : 0;
 
+	if (read_cr2() != vcpu->arch.cr2)
+		write_cr2(vcpu->arch.cr2);
+
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
 		vmx_l1d_flush(vcpu);
 
@@ -11532,13 +11535,6 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		"2: \n\t"
 		__ex("vmwrite %%" _ASM_SP ", %%" _ASM_DX) "\n\t"
 		"1: \n\t"
-		/* Reload cr2 if changed */
-		"mov %c[cr2](%0), %%" _ASM_AX " \n\t"
-		"mov %%cr2, %%" _ASM_DX " \n\t"
-		"cmp %%" _ASM_AX ", %%" _ASM_DX " \n\t"
-		"je 3f \n\t"
-		"mov %%" _ASM_AX", %%cr2 \n\t"
-		"3: \n\t"
 		/* Check if vmlaunch of vmresume is needed */
 		"cmpl $0, %c[launched](%0) \n\t"
 		/* Load guest registers.  Don't clobber flags. */
@@ -11599,8 +11595,6 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		"xor %%r14d, %%r14d \n\t"
 		"xor %%r15d, %%r15d \n\t"
 #endif
-		"mov %%cr2, %%" _ASM_AX "   \n\t"
-		"mov %%" _ASM_AX ", %c[cr2](%0) \n\t"
 
 		"xor %%eax, %%eax \n\t"
 		"xor %%ebx, %%ebx \n\t"
@@ -11632,7 +11626,6 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		[r14]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_R14])),
 		[r15]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_R15])),
 #endif
-		[cr2]"i"(offsetof(struct vcpu_vmx, vcpu.arch.cr2)),
 		[wordsize]"i"(sizeof(ulong))
 	      : "cc", "memory"
 #ifdef CONFIG_X86_64
@@ -11666,6 +11659,8 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	/* Eliminate branch target predictions from guest mode */
 	vmexit_fill_RSB();
 
+	vcpu->arch.cr2 = read_cr2();
+
 	/* All fields are clean at this point */
 	if (static_branch_unlikely(&enable_evmcs))
 		current_evmcs->hv_clean_fields |=
-- 
2.21.0

