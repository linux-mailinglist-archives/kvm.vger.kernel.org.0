Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0884EA5A3
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 05:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbiC2DDA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 23:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiC2DC5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 23:02:57 -0400
Received: from out0-138.mail.aliyun.com (out0-138.mail.aliyun.com [140.205.0.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADE4243151;
        Mon, 28 Mar 2022 20:01:14 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R771e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047198;MF=darcy.sh@antgroup.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---.NF075Bn_1648522871;
Received: from localhost(mailfrom:darcy.sh@antgroup.com fp:SMTPD_---.NF075Bn_1648522871)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 29 Mar 2022 11:01:11 +0800
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
Subject: [PATCH v2 1/2] KVM: VMX:  replace 0x180 with EPT_VIOLATION_* definition
Date:   Tue, 29 Mar 2022 11:01:06 +0800
Message-Id: <20220329030108.97341-2-darcy.sh@antgroup.com>
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

Using self-expressing macro definition EPT_VIOLATION_GVA_VALIDATION
and EPT_VIOLATION_GVA_TRANSLATED instead of 0x180
in FNAME(walk_addr_generic)().

Signed-off-by: SU Hang <darcy.sh@antgroup.com>
---
 arch/x86/include/asm/vmx.h     | 2 ++
 arch/x86/kvm/mmu/paging_tmpl.h | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 0ffaa3156a4e..3586d4aeaac7 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -546,6 +546,7 @@ enum vm_entry_failure_code {
 #define EPT_VIOLATION_READABLE_BIT	3
 #define EPT_VIOLATION_WRITABLE_BIT	4
 #define EPT_VIOLATION_EXECUTABLE_BIT	5
+#define EPT_VIOLATION_GVA_IS_VALID_BIT	7
 #define EPT_VIOLATION_GVA_TRANSLATED_BIT 8
 #define EPT_VIOLATION_ACC_READ		(1 << EPT_VIOLATION_ACC_READ_BIT)
 #define EPT_VIOLATION_ACC_WRITE		(1 << EPT_VIOLATION_ACC_WRITE_BIT)
@@ -553,6 +554,7 @@ enum vm_entry_failure_code {
 #define EPT_VIOLATION_READABLE		(1 << EPT_VIOLATION_READABLE_BIT)
 #define EPT_VIOLATION_WRITABLE		(1 << EPT_VIOLATION_WRITABLE_BIT)
 #define EPT_VIOLATION_EXECUTABLE	(1 << EPT_VIOLATION_EXECUTABLE_BIT)
+#define EPT_VIOLATION_GVA_IS_VALID	(1 << EPT_VIOLATION_GVA_IS_VALID_BIT)
 #define EPT_VIOLATION_GVA_TRANSLATED	(1 << EPT_VIOLATION_GVA_TRANSLATED_BIT)
 
 /*
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 95367f5ca998..db594366f60c 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -523,7 +523,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	 * The other bits are set to 0.
 	 */
 	if (!(errcode & PFERR_RSVD_MASK)) {
-		vcpu->arch.exit_qualification &= 0x180;
+		vcpu->arch.exit_qualification &= (EPT_VIOLATION_GVA_IS_VALID |
+						  EPT_VIOLATION_GVA_TRANSLATED);
 		if (write_fault)
 			vcpu->arch.exit_qualification |= EPT_VIOLATION_ACC_WRITE;
 		if (user_fault)
-- 
2.32.0.3.g01195cf9f

