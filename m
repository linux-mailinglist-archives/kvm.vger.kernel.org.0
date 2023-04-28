Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22ABA6F14A8
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 11:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345919AbjD1JzT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 05:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345879AbjD1JzH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 05:55:07 -0400
Received: from out0-217.mail.aliyun.com (out0-217.mail.aliyun.com [140.205.0.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16226186;
        Fri, 28 Apr 2023 02:54:44 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047198;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---.STCEPkM_1682675599;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.STCEPkM_1682675599)
          by smtp.aliyun-inc.com;
          Fri, 28 Apr 2023 17:53:20 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     linux-kernel@vger.kernel.org
Cc:     "Thomas Garnier" <thgarnie@chromium.org>,
        "Lai Jiangshan" <jiangshan.ljs@antgroup.com>,
        "Kees Cook" <keescook@chromium.org>,
        "Hou Wenlong" <houwenlong.hwl@antgroup.com>,
        "Sean Christopherson" <seanjc@google.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "Dave Hansen" <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <kvm@vger.kernel.org>
Subject: [PATCH RFC 28/43] KVM: x86: Adapt assembly for PIE support
Date:   Fri, 28 Apr 2023 17:51:08 +0800
Message-Id: <ab773255319f4759e938c4e27a6ba2f3ddbae538.1682673543.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1682673542.git.houwenlong.hwl@antgroup.com>
References: <cover.1682673542.git.houwenlong.hwl@antgroup.com>
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

Change the assembly code to use only relative references of symbols for
the kernel to be PIE compatible.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: Thomas Garnier <thgarnie@chromium.org>
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Cc: Kees Cook <keescook@chromium.org>
---
 arch/x86/kvm/svm/vmenter.S | 10 +++++-----
 arch/x86/kvm/vmx/vmenter.S |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 8e8295e774f0..25be1a66c59d 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -270,16 +270,16 @@ SYM_FUNC_START(__svm_vcpu_run)
 	RESTORE_GUEST_SPEC_CTRL_BODY
 	RESTORE_HOST_SPEC_CTRL_BODY
 
-10:	cmpb $0, kvm_rebooting
+10:	cmpb $0, _ASM_RIP(kvm_rebooting)
 	jne 2b
 	ud2
-30:	cmpb $0, kvm_rebooting
+30:	cmpb $0, _ASM_RIP(kvm_rebooting)
 	jne 4b
 	ud2
-50:	cmpb $0, kvm_rebooting
+50:	cmpb $0, _ASM_RIP(kvm_rebooting)
 	jne 6b
 	ud2
-70:	cmpb $0, kvm_rebooting
+70:	cmpb $0, _ASM_RIP(kvm_rebooting)
 	jne 8b
 	ud2
 
@@ -381,7 +381,7 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	RESTORE_GUEST_SPEC_CTRL_BODY
 	RESTORE_HOST_SPEC_CTRL_BODY
 
-3:	cmpb $0, kvm_rebooting
+3:	cmpb $0, _ASM_RIP(kvm_rebooting)
 	jne 2b
 	ud2
 
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 631fd7da2bc3..b7cc3c17736a 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -289,7 +289,7 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
 	RET
 
 .Lfixup:
-	cmpb $0, kvm_rebooting
+	cmpb $0, _ASM_RIP(kvm_rebooting)
 	jne .Lvmfail
 	ud2
 .Lvmfail:
-- 
2.31.1

