Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4978C44CCDA
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 23:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbhKJWeK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 17:34:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234120AbhKJWd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 17:33:57 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F31C061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:31:08 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id m15-20020a170902bb8f00b0014382b67873so1279492pls.19
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dkTH62+axVdrikmzQkaE0kznpVJj+gZnKCcWL87PylQ=;
        b=mHD54jNcbxYTQavv0t79LapRbwT16TqVnoCpLWulzvkw8VF7/sQOmaNWDyl0SIWwYu
         KWTf+MQgGkOv3h+nnKULdskJO3xwTrT6/IAqsZVOBxhtjiF7imMh4DpXyAOh7mlB/gar
         GG55sxGQu9zohvycDtbFbzUIVXJ74SfcAXYXPBlb0WYqr4AOJov8FhPRxBT/dtJOR3mO
         V5UAoFF1Qh6aWYkf9P20FmWqwuKkf80PKJwPScQwtyEA3cpeCfV7ga/nJiZh+7dLoc1d
         xZf41CTK/VQQpTmqxsMiEwH4kXWgD8Nyrp2gvXKjH0gIgxQ07UryZH1PEshe2iT+A3W2
         W0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dkTH62+axVdrikmzQkaE0kznpVJj+gZnKCcWL87PylQ=;
        b=REx21lNdUkHVUB0Rac5j5PqMpkv9MP5cuzANBEL81D3pOtf+czKvm9lWDwsiCkM3I1
         Fj3k2jBwPsBB4afZHLU4NE9aPRBBezmaRslK/NpWzyGdcO0zTrIOcrmE2RNUeUIyDx7/
         LlS7XEOtRTGYkso5gXS7JPKkDESXGqdagUMwreCnkdu1po7GL0yMtDK4H4wWRlH1hi61
         nJ2/LhnwwLrFKlB+qGcdk/i4pVLaDtannk+sGhrwxwHs6E7qiBs+3M/vg0bL6v0sdoqo
         9FlLMvyAHgmej7uvndKZlvVUp+tfz7AnZBRSOyTnUgn0YXIL1X5ZGQLLC9maXsQ8hBaf
         ujrg==
X-Gm-Message-State: AOAM532qNZ6Cg97HI5YeGw3wjyavr2als7VONs1aW3SGC2MluDIbI/S4
        u8g+8r3/b0/O2Wr4NDpqh8B6/9bklZce
X-Google-Smtp-Source: ABdhPJyMssxC4Jao+H/dnJG0lmW43OOcR8GJJBzIio46unX/DwCuEaTf/pjH/awCAWxkCaqmEXvswBTFX4d/
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6586:7b2f:b259:2011])
 (user=bgardon job=sendgmr) by 2002:a17:90b:1d81:: with SMTP id
 pf1mr2857835pjb.79.1636583467517; Wed, 10 Nov 2021 14:31:07 -0800 (PST)
Date:   Wed, 10 Nov 2021 14:30:07 -0800
In-Reply-To: <20211110223010.1392399-1-bgardon@google.com>
Message-Id: <20211110223010.1392399-17-bgardon@google.com>
Mime-Version: 1.0
References: <20211110223010.1392399-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [RFC 16/19] KVM: x86/mmu: Factor out part of vmx_get_mt_mask which
 does not depend on vcpu
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Factor out the parts of vmx_get_mt_mask which do not depend on the vCPU
argument. This also requires adding some error reporting to the helper
function to say whether it was possible to generate the MT mask without
a vCPU argument. This refactoring will allow the MT mask to be computed
when noncoherent DMA is not enabled on a VM.

No functional change intended.


Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 77f45c005f28..4129614262e8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6984,9 +6984,26 @@ static int __init vmx_check_processor_compat(void)
 	return 0;
 }
 
+static bool vmx_try_get_mt_mask(struct kvm *kvm, gfn_t gfn,
+				bool is_mmio, u64 *mask)
+{
+	if (is_mmio) {
+		*mask =  MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
+		return true;
+	}
+
+	if (!kvm_arch_has_noncoherent_dma(kvm)) {
+		*mask = (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
+		return true;
+	}
+
+	return false;
+}
+
 static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	u8 cache;
+	u64 mask;
 
 	/* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
 	 * memory aliases with conflicting memory types and sometimes MCEs.
@@ -7006,11 +7023,8 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	 * EPT memory type is used to emulate guest CD/MTRR.
 	 */
 
-	if (is_mmio)
-		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
-
-	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
-		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
+	if (vmx_try_get_mt_mask(vcpu->kvm, gfn, is_mmio, &mask))
+		return mask;
 
 	if (kvm_read_cr0(vcpu) & X86_CR0_CD) {
 		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
-- 
2.34.0.rc0.344.g81b53c2807-goog

