Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4841542507
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 08:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbiFHEGo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 00:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234825AbiFHEFB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 00:05:01 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B459D280B38;
        Tue,  7 Jun 2022 18:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654651243; x=1686187243;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XP965/7Bk9hC69Vm9y/5UnoOjQlNM4Qp3cNQ0BDnpE8=;
  b=eUIaB1UNX+L9I6uT7S5Grk5YVBFPUMvyirJ8Am0QbbbnTsWYiDKPc2tA
   OIAcaIbcHEUvqgoe4AOiAOBwHBp3X8a6G2xPaMSAVjRa+zKPTGpv7zghS
   3p+JUhODnBvADLmw1ecw8hX6YNeXwpWgzgHEKKRA/BZEnyezSpWP38kwj
   /aA2fjpU7zemKFk+4xPAx+SksRC8cx5mQaYi4gvgvL9tju0LM2v+lz6Xw
   O73RtpsyDdy9nrtua9ATxRTj0q1oZhcLIBuHOKYqhl2w0iPnQid+HiyQb
   wmcJ2AsZ9f196ok2Ba3mXiyJXlL3ud74C/b6Kgb95fKxLfscn2fKj3V6q
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="259837820"
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="259837820"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 18:20:26 -0700
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="648333474"
Received: from sqa-gate.sh.intel.com (HELO embargo.tsp.org) ([10.239.48.212])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 18:20:24 -0700
From:   Yuan Yao <yuan.yao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kai Huang <kai.huang@intel.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: [PATCH 1/1] KVM: x86/mmu: Set memory encryption "value", not "mask", in shadow PDPTRs
Date:   Wed,  8 Jun 2022 09:20:15 +0800
Message-Id: <20220608012015.19566-1-yuan.yao@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Assign shadow_me_value, not shadow_me_mask, to PAE root entries,
a.k.a. shadow PDPTRs, when host memory encryption is supported.  The
"mask" is the set of all possible memory encryption bits, e.g. MKTME
KeyIDs, whereas "value" holds the actual value that needs to be
stuffed into host page tables.

Using shadow_me_mask results in a failed VM-Entry due to setting
reserved PA bits in the PDPTRs, and ultimately causes an OOPS due to
physical addresses with non-zero MKTME bits sending to_shadow_page()
into the weeds:

set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.
BUG: unable to handle page fault for address: ffd43f00063049e8
PGD 86dfd8067 P4D 0
Oops: 0000 [#1] PREEMPT SMP
RIP: 0010:mmu_free_root_page+0x3c/0x90 [kvm]
 kvm_mmu_free_roots+0xd1/0x200 [kvm]
 __kvm_mmu_unload+0x29/0x70 [kvm]
 kvm_mmu_unload+0x13/0x20 [kvm]
 kvm_arch_destroy_vm+0x8a/0x190 [kvm]
 kvm_put_kvm+0x197/0x2d0 [kvm]
 kvm_vm_release+0x21/0x30 [kvm]
 __fput+0x8e/0x260
 ____fput+0xe/0x10
 task_work_run+0x6f/0xb0
 do_exit+0x327/0xa90
 do_group_exit+0x35/0xa0
 get_signal+0x911/0x930
 arch_do_signal_or_restart+0x37/0x720
 exit_to_user_mode_prepare+0xb2/0x140
 syscall_exit_to_user_mode+0x16/0x30
 do_syscall_64+0x4e/0x90
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: e54f1ff244ac ("KVM: x86/mmu: Add shadow_me_value and repurpose shadow_me_mask")
Signed-off-by: Yuan Yao <yuan.yao@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index efe5a3dca1e0..6bd144f1e60c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3411,7 +3411,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
 					      i << 30, PT32_ROOT_LEVEL, true);
 			mmu->pae_root[i] = root | PT_PRESENT_MASK |
-					   shadow_me_mask;
+					   shadow_me_value;
 		}
 		mmu->root.hpa = __pa(mmu->pae_root);
 	} else {
-- 
2.27.0

