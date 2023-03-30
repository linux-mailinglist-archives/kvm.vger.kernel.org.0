Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023E16D04D9
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 14:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbjC3MgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 08:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbjC3MgF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 08:36:05 -0400
Received: from out0-196.mail.aliyun.com (out0-196.mail.aliyun.com [140.205.0.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3867D7EC0;
        Thu, 30 Mar 2023 05:36:04 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R221e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047199;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---.S3-w4rS_1680179757;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.S3-w4rS_1680179757)
          by smtp.aliyun-inc.com;
          Thu, 30 Mar 2023 20:35:58 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: x86: Detect KVM_CPUID_FEATURES base before KVM PV feature CPUID updating
Date:   Thu, 30 Mar 2023 20:35:54 +0800
Message-Id: <712ea6c3db34d5b488888648c1eb2db655eaa5b9.1680179693.git.houwenlong.hwl@antgroup.com>
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

KVM_CPUID_FEATURES is detected after CPUID updating in kvm_set_cpuid(),
then 'vcpu->arch.kvm_cpuid_base' is NULL and KVM PV feature CPUID
updating wouldn't work. So detect it early before CPUID updating in
kvm_set_cpuid().

Fixes: ee3a5f9e3d9b ("KVM: x86: Do runtime CPUID update before updating vcpu->arch.cpuid_entries")
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/cpuid.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index af92d3422c79..0c8658fdb6c1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -176,15 +176,15 @@ static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2
 	return 0;
 }
 
-static struct kvm_hypervisor_cpuid kvm_get_hypervisor_cpuid(struct kvm_vcpu *vcpu,
-							    const char *sig)
+static struct kvm_hypervisor_cpuid __kvm_get_hypervisor_cpuid(struct kvm_cpuid_entry2 *entries,
+							      int nent, const char *sig)
 {
 	struct kvm_hypervisor_cpuid cpuid = {};
 	struct kvm_cpuid_entry2 *entry;
 	u32 base;
 
 	for_each_possible_hypervisor_cpuid_base(base) {
-		entry = kvm_find_cpuid_entry(vcpu, base);
+		entry = cpuid_entry2_find(entries, nent, base, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
 
 		if (entry) {
 			u32 signature[3];
@@ -202,6 +202,14 @@ static struct kvm_hypervisor_cpuid kvm_get_hypervisor_cpuid(struct kvm_vcpu *vcp
 	}
 
 	return cpuid;
+
+}
+
+static struct kvm_hypervisor_cpuid kvm_get_hypervisor_cpuid(struct kvm_vcpu *vcpu,
+							    const char *sig)
+{
+	return __kvm_get_hypervisor_cpuid(vcpu->arch.cpuid_entries,
+					  vcpu->arch.cpuid_nent, sig);
 }
 
 static struct kvm_cpuid_entry2 *__kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcpu,
@@ -406,9 +414,12 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
                         int nent)
 {
 	int r;
+	struct kvm_hypervisor_cpuid kvm_cpuid;
 
 	__kvm_update_cpuid_runtime(vcpu, e2, nent);
-	kvm_update_pv_cpuid(vcpu, e2, nent);
+	kvm_cpuid = __kvm_get_hypervisor_cpuid(e2, nent, KVM_SIGNATURE);
+	if (kvm_cpuid.base)
+		kvm_update_pv_cpuid(vcpu, e2, nent);
 
 	/*
 	 * KVM does not correctly handle changing guest CPUID after KVM_RUN, as
@@ -444,7 +455,7 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	vcpu->arch.cpuid_entries = e2;
 	vcpu->arch.cpuid_nent = nent;
 
-	vcpu->arch.kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
+	vcpu->arch.kvm_cpuid = kvm_cpuid;
 	vcpu->arch.xen.cpuid = kvm_get_hypervisor_cpuid(vcpu, XEN_SIGNATURE);
 	kvm_vcpu_after_set_cpuid(vcpu);
 
-- 
2.31.1

