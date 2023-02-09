Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CACB868FD37
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 03:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbjBIClW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 21:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbjBIClM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 21:41:12 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E721C5BF
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 18:41:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675910471; x=1707446471;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hSS8qlvHJNmTg8dlxHlmoL35DJ5B+VWmPQ/iTpNa8Nw=;
  b=jV2HmObpQVwr7eED237doVfzFyS5YsTUnN6RIH5Kne9QXFy6r1dF0Di6
   zfyMl1RSIAIo0GkImTNUIBAt1/uQ6T9TWYp/54vuGi6K/Dsya0n+/m/FG
   FZyuSm887EIt9ELOflxP4VoyjDYazLW5cgDwdSh8OB6jfiHI2SyEuft+B
   EHtMfIpniyeAEdTaBKrZvlVTRBzydEcgHUdWVo+l6j6jliKphN1ofRYnF
   bx00xiIYavPhFImRVacr59HHqSpAYo04PuJXP+/wQc/29A641jlJvP47U
   sGq+5G0L45HfRmVUW+wtjv4oazlHUeClJacO40BR/LS97kjVfwoKlGqCN
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="394586627"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="394586627"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 18:41:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="645094400"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="645094400"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga006.jf.intel.com with ESMTP; 08 Feb 2023 18:41:04 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com
Cc:     kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v4 4/9] KVM: x86: MMU: Integrate LAM bits when build guest CR3
Date:   Thu,  9 Feb 2023 10:40:17 +0800
Message-Id: <20230209024022.3371768-5-robert.hu@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230209024022.3371768-1-robert.hu@linux.intel.com>
References: <20230209024022.3371768-1-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When calc the new CR3 value, take LAM bits in.

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Reviewed-by: Jingqi Liu <jingqi.liu@intel.com>
---
 arch/x86/kvm/mmu.h     | 5 +++++
 arch/x86/kvm/vmx/vmx.c | 3 ++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 6bdaacb6faa0..866f2b7cb509 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -142,6 +142,11 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
 	return kvm_get_pcid(vcpu, kvm_read_cr3(vcpu));
 }
 
+static inline u64 kvm_get_active_lam(struct kvm_vcpu *vcpu)
+{
+	return kvm_read_cr3(vcpu) & (X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
+}
+
 static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 {
 	u64 root_hpa = vcpu->arch.mmu->root.hpa;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fe5615fd8295..66edd091f145 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3289,7 +3289,8 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			update_guest_cr3 = false;
 		vmx_ept_load_pdptrs(vcpu);
 	} else {
-		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu);
+		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu) |
+			    kvm_get_active_lam(vcpu);
 	}
 
 	if (update_guest_cr3)
-- 
2.31.1

