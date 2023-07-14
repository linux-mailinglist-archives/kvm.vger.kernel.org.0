Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAC737532F2
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 09:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235339AbjGNHSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 03:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235321AbjGNHS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 03:18:28 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2481B271E;
        Fri, 14 Jul 2023 00:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689319106; x=1720855106;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=039VwauHGCgL1mSJQW9bLXP44yBS4nRZJPzdsRVd4cc=;
  b=UmZkIiTdjpYoxgPlUhOZ3r7gc6A7OFZJYj0d2vr9Out7ctv30/BvILRW
   N+YwePwFCtoL3z/NKnSZMrM3G7iFFL2NvCV/Q8zYNFo2wwauMlOrnuN0u
   28FIoPAYli67O2IssEpQcCY5hXiGvkQnObmV/PNtkXU201bi40XuD3J8m
   9P20+md6b0YchQP2vvXgR9/3+pHrPCRNXoLlVFg/Ifrxe4hhyi+haHzbQ
   nDWvwRvOLSKNTcCeaen4yBxmJNNDxSytNW8PGYKkOan/nOCq3hlTOdc+C
   hFau40q/Rj+v5AcXvV0K4RX6IGafdycEETi038cuPRWgfQLxpddxbJtqh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="350283092"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="350283092"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:17:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="699577183"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="699577183"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:17:56 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        yuan.yao@linux.intel.com, Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v4 03/12] KVM: x86/mmu: Use KVM honors guest MTRRs helper when CR0.CD toggles
Date:   Fri, 14 Jul 2023 14:51:22 +0800
Message-Id: <20230714065122.20315-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230714064656.20147-1-yan.y.zhao@intel.com>
References: <20230714064656.20147-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Zap SPTEs when CR0.CD is toggled if and only if KVM's MMU is honoring
guest MTRRs, which is the only time that KVM incorporates the guest's
CR0.CD into the final memtype.

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9e7186864542..6693daeb5686 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -942,7 +942,7 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
 		kvm_mmu_reset_context(vcpu);
 
 	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
-	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
+	    kvm_mmu_honors_guest_mtrrs(vcpu->kvm) &&
 	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
 		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
 }
-- 
2.17.1

