Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B1368FD34
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 03:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbjBIClS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 21:41:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbjBIClL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 21:41:11 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D178629408
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 18:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675910469; x=1707446469;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ivrTT5iq9ABrf1BcEp64RCio7srJu6cXx/1IH1S2JVc=;
  b=WdcLbBRhhOfzCI+kdm/Qse3nKInmhCAsuFurQJ4ionIHlRD2tkoPK7iX
   wC5B30bgFIlR3xdHajkIJHJSvZ45NNoUMMkwI8pckZlEiAniNGF7rMIFU
   TWw3RamxWwb+yTLsD1MBl0WsCXsqtVngK/H1w0hJakRjxNBhX9f+8e4NY
   IaCML9DiIieDkIp5tXVU631rP6zUHWS1g64cVpRpNalXj+B3xmExU58x2
   RfPoKg/zAq/6+MjAYPoYSU1KDFW36DA401OXJmL5OiwKXJW4rzRIDmXMi
   RlEZSvK4kZGDoykYMVtWp7kPwn2eaOKDJ8rTyubHcReEYVPxKBwBxYlxu
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="394586603"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="394586603"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 18:41:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="645094363"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="645094363"
Received: from sqa-gate.sh.intel.com (HELO robert-clx2.tsp.org) ([10.239.48.212])
  by orsmga006.jf.intel.com with ESMTP; 08 Feb 2023 18:40:58 -0800
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, yu.c.zhang@linux.intel.com,
        yuan.yao@linux.intel.com, jingqi.liu@intel.com,
        weijiang.yang@intel.com, chao.gao@intel.com,
        isaku.yamahata@intel.com
Cc:     kirill.shutemov@linux.intel.com, kvm@vger.kernel.org,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: [PATCH v4 2/9] KVM: x86: MMU: Clear CR3 LAM bits when allocate shadow root
Date:   Thu,  9 Feb 2023 10:40:15 +0800
Message-Id: <20230209024022.3371768-3-robert.hu@linux.intel.com>
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

mmu->get_guest_pgd()'s implementation is get_cr3(), clear the LAM bits for
root_pgd, which needs a pure address, plus (possible) PCID info (low 12
bits).

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 835426254e76..1d61dfe37c77 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3698,8 +3698,11 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	gfn_t root_gfn, root_pgd;
 	int quadrant, i, r;
 	hpa_t root;
-
+#ifdef CONFIG_X86_64
+	root_pgd = mmu->get_guest_pgd(vcpu) & ~(X86_CR3_LAM_U48 | X86_CR3_LAM_U57);
+#else
 	root_pgd = mmu->get_guest_pgd(vcpu);
+#endif
 	root_gfn = root_pgd >> PAGE_SHIFT;
 
 	if (mmu_check_root(vcpu, root_gfn))
-- 
2.31.1

