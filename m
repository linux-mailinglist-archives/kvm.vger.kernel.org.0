Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C588583A51
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 10:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235183AbiG1IZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 04:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234371AbiG1IZQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 04:25:16 -0400
Received: from out0-155.mail.aliyun.com (out0-155.mail.aliyun.com [140.205.0.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 293B1B4AC;
        Thu, 28 Jul 2022 01:25:09 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047187;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---.OfjlJVP_1658996706;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.OfjlJVP_1658996706)
          by smtp.aliyun-inc.com;
          Thu, 28 Jul 2022 16:25:07 +0800
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
Subject: [PATCH 1/2] KVM: x86: Return emulator error if RDMSR/WRMSR emulation failed
Date:   Thu, 28 Jul 2022 16:25:04 +0800
Message-Id: <a845c3e93b2e94b510abbc26ab4ffc0eb8a8b67a.1658913543.git.houwenlong.hwl@antgroup.com>
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

The return value of emulator_{get|set}_mst_with_filter()
is confused, since msr access error and emulator error
are mixed. Although, KVM_MSR_RET_* doesn't conflict with
X86EMUL_IO_NEEDED at present, it is better to convert
msr access error to emulator error if error value is
needed.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/x86.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5366f884e9a7..8df89b9c212f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7908,11 +7908,12 @@ static int emulator_get_msr_with_filter(struct x86_emulate_ctxt *ctxt,
 	int r;
 
 	r = kvm_get_msr_with_filter(vcpu, msr_index, pdata);
-
-	if (r && kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_RDMSR, 0,
-				    complete_emulated_rdmsr, r)) {
-		/* Bounce to user space */
-		return X86EMUL_IO_NEEDED;
+	if (r) {
+		if (kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_RDMSR, 0,
+				       complete_emulated_rdmsr, r))
+			r = X86EMUL_IO_NEEDED;
+		else
+			r = X86EMUL_UNHANDLEABLE;
 	}
 
 	return r;
@@ -7925,11 +7926,12 @@ static int emulator_set_msr_with_filter(struct x86_emulate_ctxt *ctxt,
 	int r;
 
 	r = kvm_set_msr_with_filter(vcpu, msr_index, data);
-
-	if (r && kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_WRMSR, data,
-				    complete_emulated_msr_access, r)) {
-		/* Bounce to user space */
-		return X86EMUL_IO_NEEDED;
+	if (r > 0) {
+		if (kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_WRMSR, data,
+				       complete_emulated_msr_access, r))
+			r = X86EMUL_IO_NEEDED;
+		else
+			r = X86EMUL_UNHANDLEABLE;
 	}
 
 	return r;
-- 
2.31.1

