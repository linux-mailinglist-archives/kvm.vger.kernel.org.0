Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E2A6D04D5
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 14:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjC3MgD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 08:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbjC3MgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 08:36:01 -0400
Received: from out0-193.mail.aliyun.com (out0-193.mail.aliyun.com [140.205.0.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C65768A;
        Thu, 30 Mar 2023 05:36:00 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047212;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---.S30ISig_1680179756;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.S30ISig_1680179756)
          by smtp.aliyun-inc.com;
          Thu, 30 Mar 2023 20:35:57 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: x86: Don't update KVM PV feature CPUID during vCPU running
Date:   Thu, 30 Mar 2023 20:35:53 +0800
Message-Id: <9fbf5b4022d67157d6305bc1811f36d9096c26fc.1680179693.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <9227068821b275ac547eb2ede09ec65d2281fe07.1680179693.git.houwenlong.hwl@antgroup.com>
References: <9227068821b275ac547eb2ede09ec65d2281fe07.1680179693.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

__kvm_update_cpuid_runtime() may be called during vCPU running and KVM
PV feature CPUID is updated too. But the cached KVM PV feature bitmap is
not updated. Actually, KVM PV feature CPUID shouldn't be updated,
otherwise, KVM PV feature would be broken in guest. Currently, only
KVM_FEATURE_PV_UNHALT is updated, and it's impossible after disallow
disable HLT exits. However, KVM PV feature CPUID should be updated only
in KVM_SET_CPUID{,2} ioctl.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/cpuid.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6972e0be60fa..af92d3422c79 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -222,6 +222,17 @@ static struct kvm_cpuid_entry2 *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcp
 					     vcpu->arch.cpuid_nent);
 }
 
+static void kvm_update_pv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *entries,
+				int nent)
+{
+	struct kvm_cpuid_entry2 *best;
+
+	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
+	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
+		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
+		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
+}
+
 void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best = kvm_find_kvm_cpuid_features(vcpu);
@@ -280,11 +291,6 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
-	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
-	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
-		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
-		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
-
 	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
 		best = cpuid_entry2_find(entries, nent, 0x1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
 		if (best)
@@ -402,6 +408,7 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	int r;
 
 	__kvm_update_cpuid_runtime(vcpu, e2, nent);
+	kvm_update_pv_cpuid(vcpu, e2, nent);
 
 	/*
 	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
-- 
2.31.1

