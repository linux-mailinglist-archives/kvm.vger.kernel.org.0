Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C87E4D97BC
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 10:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346661AbiCOJge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 05:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238684AbiCOJgb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 05:36:31 -0400
Received: from out0-153.mail.aliyun.com (out0-153.mail.aliyun.com [140.205.0.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266884BFD2;
        Tue, 15 Mar 2022 02:35:18 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047212;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---.N4z7UFy_1647336913;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.N4z7UFy_1647336913)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 15 Mar 2022 17:35:14 +0800
From:   "Hou Wenlong" <houwenlong.hwl@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Don't rebuild page when the page is synced and no tlb flushing is required
Date:   Tue, 15 Mar 2022 17:35:13 +0800
Message-Id: <0dabeeb789f57b0d793f85d073893063e692032d.1647336064.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before Commit c3e5e415bc1e6 ("KVM: X86: Change kvm_sync_page()
to return true when remote flush is needed"), the return value
of kvm_sync_page() indicates whether the page is synced, and
kvm_mmu_get_page() would rebuild page when the sync fails.
But now, kvm_sync_page() returns false when the page is
synced and no tlb flushing is required, which leads to
rebuild page in kvm_mmu_get_page(). So return the return
value of mmu->sync_page() directly and check it in
kvm_mmu_get_page(). If the sync fails, the page will be
zapped and the invalid_list is not empty, so set flush as
true is accepted in mmu_sync_children().

Fixes: c3e5e415bc1e6 ("KVM: X86: Change kvm_sync_page() to return true when remote flush is needed")
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3b8da8b0745e..8efd165ee27c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1866,17 +1866,14 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])	\
 		if ((_sp)->gfn != (_gfn) || (_sp)->role.direct) {} else
 
-static bool kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			 struct list_head *invalid_list)
 {
 	int ret = vcpu->arch.mmu->sync_page(vcpu, sp);
 
-	if (ret < 0) {
+	if (ret < 0)
 		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
-		return false;
-	}
-
-	return !!ret;
+	return ret;
 }
 
 static bool kvm_mmu_remote_flush_or_zap(struct kvm *kvm,
@@ -2039,6 +2036,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	struct hlist_head *sp_list;
 	unsigned quadrant;
 	struct kvm_mmu_page *sp;
+	int ret;
 	int collisions = 0;
 	LIST_HEAD(invalid_list);
 
@@ -2091,11 +2089,13 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 			 * If the sync fails, the page is zapped.  If so, break
 			 * in order to rebuild it.
 			 */
-			if (!kvm_sync_page(vcpu, sp, &invalid_list))
+			ret = kvm_sync_page(vcpu, sp, &invalid_list);
+			if (ret < 0)
 				break;
 
 			WARN_ON(!list_empty(&invalid_list));
-			kvm_flush_remote_tlbs(vcpu->kvm);
+			if (ret > 0)
+				kvm_flush_remote_tlbs(vcpu->kvm);
 		}
 
 		__clear_sp_write_flooding_count(sp);
-- 
2.31.1

