Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E722F583A52
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 10:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbiG1IZV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 04:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234026AbiG1IZQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 04:25:16 -0400
Received: from out0-157.mail.aliyun.com (out0-157.mail.aliyun.com [140.205.0.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5A9E0E2;
        Thu, 28 Jul 2022 01:25:11 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047188;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---.OfjlJW9_1658996707;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.OfjlJW9_1658996707)
          by smtp.aliyun-inc.com;
          Thu, 28 Jul 2022 16:25:08 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: x86: Add missing trace points for RDMSR/WRMSR in emulator path
Date:   Thu, 28 Jul 2022 16:25:05 +0800
Message-Id: <f7d395b60eb7e6dcc149ba39d86f9296bd81b0ac.1658913543.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1658913543.git.houwenlong.hwl@antgroup.com>
References: <cover.1658913543.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the RDMSR/WRMSR emulation uses a sepearte emualtor interface,
the trace points for RDMSR/WRMSR can be added in emulator path like
normal path.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/x86.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8df89b9c212f..6e45b20ce9a4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7908,12 +7908,16 @@ static int emulator_get_msr_with_filter(struct x86_emulate_ctxt *ctxt,
 	int r;
 
 	r = kvm_get_msr_with_filter(vcpu, msr_index, pdata);
-	if (r) {
+	if (!r) {
+		trace_kvm_msr_read(msr_index, *pdata);
+	} else {
 		if (kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_RDMSR, 0,
-				       complete_emulated_rdmsr, r))
+				       complete_emulated_rdmsr, r)) {
 			r = X86EMUL_IO_NEEDED;
-		else
+		} else {
+			trace_kvm_msr_read_ex(msr_index);
 			r = X86EMUL_UNHANDLEABLE;
+		}
 	}
 
 	return r;
@@ -7926,12 +7930,16 @@ static int emulator_set_msr_with_filter(struct x86_emulate_ctxt *ctxt,
 	int r;
 
 	r = kvm_set_msr_with_filter(vcpu, msr_index, data);
-	if (r > 0) {
+	if (!r) {
+		trace_kvm_msr_write(msr_index, data);
+	} else if (r > 0) {
 		if (kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_WRMSR, data,
-				       complete_emulated_msr_access, r))
+				       complete_emulated_msr_access, r)) {
 			r = X86EMUL_IO_NEEDED;
-		else
+		} else {
+			trace_kvm_msr_write_ex(msr_index, data);
 			r = X86EMUL_UNHANDLEABLE;
+		}
 	}
 
 	return r;
-- 
2.31.1

