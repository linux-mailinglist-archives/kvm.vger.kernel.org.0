Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE35058BDAA
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241887AbiHGWHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237078AbiHGWFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:05:12 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DB8B7DF;
        Sun,  7 Aug 2022 15:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909783; x=1691445783;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2IKpMD/5mOlSohbGo23im3gthlxB9WFfnDJ1NWi5/PI=;
  b=U4ttQ2OkO8Ljj7iwXr17+YoBaOe5YBrQ76OuHWQLQkhrj7OrBjJto/bE
   LfS9ZY0tR9nEH1thzdBFIefURo3xOb8yAjsyDzvf5AErYP7QK5gCwA8FR
   QXdO8ocpWgALiFaIzCFeGyddU+dgJgtFJjnhUIMVOA9NUT2n+7lXseLNR
   taWjO0hQZ9wPZDmLC8mLZfTLs2Zfr51K0wHnR5aG4AqXIP9tn4ISVUbIG
   bQlIHXfUZwAwhGxwsOUYZ/HfXpwtWVeayyltbel1Tws2n/KSL27yE5YFc
   La3zXw4v/+TPg/QIctaRHQB4UjYlIRIY99YXj+D7Y9pnNfygNt2cZnYxA
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="270240385"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="270240385"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:42 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682715"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:42 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 082/103] KVM: x86: Split core of hypercall emulation to helper function
Date:   Sun,  7 Aug 2022 15:02:07 -0700
Message-Id: <3a91ab66dfef4c23faa13b50e0296630d562e95d.1659854791.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

By necessity, TDX will use a different register ABI for hypercalls.
Break out the core functionality so that it may be reused for TDX.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  4 +++
 arch/x86/kvm/x86.c              | 54 ++++++++++++++++++++-------------
 2 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ef04220527b2..df0b98e09cc9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1995,6 +1995,10 @@ static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
 	kvm_set_or_clear_apicv_inhibit(kvm, reason, false);
 }
 
+unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
+				      unsigned long a0, unsigned long a1,
+				      unsigned long a2, unsigned long a3,
+				      int op_64_bit);
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bc3b657e9795..01a320dd20ab 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9495,26 +9495,15 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
 	return kvm_skip_emulated_instruction(vcpu);
 }
 
-int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
+unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
+				      unsigned long a0, unsigned long a1,
+				      unsigned long a2, unsigned long a3,
+				      int op_64_bit)
 {
-	unsigned long nr, a0, a1, a2, a3, ret;
-	int op_64_bit;
-
-	if (kvm_xen_hypercall_enabled(vcpu->kvm))
-		return kvm_xen_hypercall(vcpu);
-
-	if (kvm_hv_hypercall_enabled(vcpu))
-		return kvm_hv_hypercall(vcpu);
-
-	nr = kvm_rax_read(vcpu);
-	a0 = kvm_rbx_read(vcpu);
-	a1 = kvm_rcx_read(vcpu);
-	a2 = kvm_rdx_read(vcpu);
-	a3 = kvm_rsi_read(vcpu);
+	unsigned long ret;
 
 	trace_kvm_hypercall(nr, a0, a1, a2, a3);
 
-	op_64_bit = is_64_bit_hypercall(vcpu);
 	if (!op_64_bit) {
 		nr &= 0xFFFFFFFF;
 		a0 &= 0xFFFFFFFF;
@@ -9523,11 +9512,6 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		a3 &= 0xFFFFFFFF;
 	}
 
-	if (static_call(kvm_x86_get_cpl)(vcpu) != 0) {
-		ret = -KVM_EPERM;
-		goto out;
-	}
-
 	ret = -KVM_ENOSYS;
 
 	switch (nr) {
@@ -9586,6 +9570,34 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		ret = -KVM_ENOSYS;
 		break;
 	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);
+
+int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
+{
+	unsigned long nr, a0, a1, a2, a3, ret;
+	int op_64_bit;
+
+	if (kvm_xen_hypercall_enabled(vcpu->kvm))
+		return kvm_xen_hypercall(vcpu);
+
+	if (kvm_hv_hypercall_enabled(vcpu))
+		return kvm_hv_hypercall(vcpu);
+
+	nr = kvm_rax_read(vcpu);
+	a0 = kvm_rbx_read(vcpu);
+	a1 = kvm_rcx_read(vcpu);
+	a2 = kvm_rdx_read(vcpu);
+	a3 = kvm_rsi_read(vcpu);
+	op_64_bit = is_64_bit_hypercall(vcpu);
+
+	if (static_call(kvm_x86_get_cpl)(vcpu) != 0) {
+		ret = -KVM_EPERM;
+		goto out;
+	}
+
+	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit);
 out:
 	if (!op_64_bit)
 		ret = (u32)ret;
-- 
2.25.1

