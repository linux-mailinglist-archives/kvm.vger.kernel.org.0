Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC61A5AA604
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 04:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbiIBCrK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 22:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbiIBCrJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 22:47:09 -0400
Received: from out0-148.mail.aliyun.com (out0-148.mail.aliyun.com [140.205.0.148])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03D08A7DA;
        Thu,  1 Sep 2022 19:47:06 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047206;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---.P5lHg5l_1662086824;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.P5lHg5l_1662086824)
          by smtp.aliyun-inc.com;
          Fri, 02 Sep 2022 10:47:04 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] KVM: x86: Add missing trace points for RDMSR/WRMSR in emulator path
Date:   Fri, 02 Sep 2022 10:47:01 +0800
Message-Id: <39181a9f777a72d61a4d0bb9f6984ccbd1de2ea3.1661930557.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1661930557.git.houwenlong.hwl@antgroup.com>
References: <cover.1661930557.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/x86.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2596f5736743..1a224e575b0b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7927,9 +7927,12 @@ static int emulator_get_msr_with_filter(struct x86_emulate_ctxt *ctxt,
 		if (kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_RDMSR, 0,
 				       complete_emulated_rdmsr, r))
 			return X86EMUL_IO_NEEDED;
+
+		trace_kvm_msr_read_ex(msr_index);
 		return X86EMUL_PROPAGATE_FAULT;
 	}
 
+	trace_kvm_msr_read(msr_index, *pdata);
 	return X86EMUL_CONTINUE;
 }
 
@@ -7947,9 +7950,12 @@ static int emulator_set_msr_with_filter(struct x86_emulate_ctxt *ctxt,
 		if (kvm_msr_user_space(vcpu, msr_index, KVM_EXIT_X86_WRMSR, data,
 				       complete_emulated_msr_access, r))
 			return X86EMUL_IO_NEEDED;
+
+		trace_kvm_msr_write_ex(msr_index, data);
 		return X86EMUL_PROPAGATE_FAULT;
 	}
 
+	trace_kvm_msr_write(msr_index, data);
 	return X86EMUL_CONTINUE;
 }
 
-- 
2.31.1

