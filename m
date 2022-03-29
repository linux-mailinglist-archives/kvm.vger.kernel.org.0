Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B93794EA5A4
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 05:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbiC2DDB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 23:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbiC2DC6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 23:02:58 -0400
Received: from out0-129.mail.aliyun.com (out0-129.mail.aliyun.com [140.205.0.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110DA24372C;
        Mon, 28 Mar 2022 20:01:15 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047199;MF=darcy.sh@antgroup.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---.NF0ngh4_1648522872;
Received: from localhost(mailfrom:darcy.sh@antgroup.com fp:SMTPD_---.NF0ngh4_1648522872)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 29 Mar 2022 11:01:13 +0800
From:   "SU Hang" <darcy.sh@antgroup.com>
To:     seanjc@google.com, kvm@vger.kernel.org
Cc:     "Lai Jiangshan" <jiangshan.ljs@antgroup.com>,
        "SU Hang" <darcy.sh@antgroup.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/2] KVM: x86/mmu: Derive EPT violation RWX bits from EPTE RWX bits
Date:   Tue, 29 Mar 2022 11:01:07 +0800
Message-Id: <20220329030108.97341-3-darcy.sh@antgroup.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20220329030108.97341-1-darcy.sh@antgroup.com>
References: <20220329030108.97341-1-darcy.sh@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Derive the mask of RWX bits reported on EPT violations from the mask of
RWX bits that are shoved into EPT entries; the layout is the same, the
EPT violation bits are simply shifted by three.  Use the new shift and a
slight copy-paste of the mask derivation instead of completely open
coding the same to convert between the EPT entry bits and the exit
qualification when synthesizing a nested EPT Violation.

No functional change intended.

Cc: SU Hang <darcy.sh@antgroup.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/vmx.h     | 7 +------
 arch/x86/kvm/mmu/paging_tmpl.h | 8 +++++++-
 arch/x86/kvm/vmx/vmx.c         | 4 +---
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 3586d4aeaac7..46bc7072f6a2 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -543,17 +543,12 @@ enum vm_entry_failure_code {
 #define EPT_VIOLATION_ACC_READ_BIT	0
 #define EPT_VIOLATION_ACC_WRITE_BIT	1
 #define EPT_VIOLATION_ACC_INSTR_BIT	2
-#define EPT_VIOLATION_READABLE_BIT	3
-#define EPT_VIOLATION_WRITABLE_BIT	4
-#define EPT_VIOLATION_EXECUTABLE_BIT	5
 #define EPT_VIOLATION_GVA_IS_VALID_BIT	7
 #define EPT_VIOLATION_GVA_TRANSLATED_BIT 8
 #define EPT_VIOLATION_ACC_READ		(1 << EPT_VIOLATION_ACC_READ_BIT)
 #define EPT_VIOLATION_ACC_WRITE		(1 << EPT_VIOLATION_ACC_WRITE_BIT)
 #define EPT_VIOLATION_ACC_INSTR		(1 << EPT_VIOLATION_ACC_INSTR_BIT)
-#define EPT_VIOLATION_READABLE		(1 << EPT_VIOLATION_READABLE_BIT)
-#define EPT_VIOLATION_WRITABLE		(1 << EPT_VIOLATION_WRITABLE_BIT)
-#define EPT_VIOLATION_EXECUTABLE	(1 << EPT_VIOLATION_EXECUTABLE_BIT)
+#define EPT_VIOLATION_RWX_MASK		(VMX_EPT_RWX_MASK << EPT_VIOLATION_RWX_SHIFT)
 #define EPT_VIOLATION_GVA_IS_VALID	(1 << EPT_VIOLATION_GVA_IS_VALID_BIT)
 #define EPT_VIOLATION_GVA_TRANSLATED	(1 << EPT_VIOLATION_GVA_TRANSLATED_BIT)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index db594366f60c..a4a9d7f2d3bd 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -531,7 +531,13 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 			vcpu->arch.exit_qualification |= EPT_VIOLATION_ACC_READ;
 		if (fetch_fault)
 			vcpu->arch.exit_qualification |= EPT_VIOLATION_ACC_INSTR;
-		vcpu->arch.exit_qualification |= (pte_access & 0x7) << 3;
+
+		/*
+		 * Note, pte_access holds the raw RWX bits from the EPTE, not
+		 * ACC_*_MASK flags!
+		 */
+		vcpu->arch.exit_qualification |= (pte_access & VMX_EPT_RWX_MASK) <<
+						 EPT_VIOLATION_RWX_SHIFT;
 	}
 #endif
 	walker->fault.address = addr;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5b629acafa69..9c1f6d3dceef 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5410,9 +5410,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	error_code |= (exit_qualification & EPT_VIOLATION_ACC_INSTR)
 		      ? PFERR_FETCH_MASK : 0;
 	/* ept page table entry is present? */
-	error_code |= (exit_qualification &
-		       (EPT_VIOLATION_READABLE | EPT_VIOLATION_WRITABLE |
-			EPT_VIOLATION_EXECUTABLE))
+	error_code |= (exit_qualification & EPT_VIOLATION_RWX_MASK)
 		      ? PFERR_PRESENT_MASK : 0;

 	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?
--
2.32.0.3.g01195cf9f

