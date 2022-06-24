Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72339558F27
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 05:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbiFXDhR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 23:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiFXDhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 23:37:12 -0400
Received: from out0-150.mail.aliyun.com (out0-150.mail.aliyun.com [140.205.0.150])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF9C53A6F;
        Thu, 23 Jun 2022 20:37:07 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047208;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---.OBhfXaM_1656041822;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.OBhfXaM_1656041822)
          by smtp.aliyun-inc.com;
          Fri, 24 Jun 2022 11:37:03 +0800
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
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] KVM: x86/mmu: Fix wrong gfn range of tlb flushing in validate_direct_spte()
Date:   Fri, 24 Jun 2022 11:36:57 +0800
Message-Id: <66dec44acfd5f4c47451c7f4be516edb8fb326a2.1656039275.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1656039275.git.houwenlong.hwl@antgroup.com>
References: <cover.1656039275.git.houwenlong.hwl@antgroup.com>
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

The spte pointing to the children SP is dropped, so the whole gfn range
covered by the children SP should be flushed.

Fixes: c3134ce240eed ("KVM: Replace old tlb flush function with new one to flush a specified range.")
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 79c6a821ea0d..b8a1f5b46b9d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2333,7 +2333,8 @@ static void validate_direct_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 			return;
 
 		drop_parent_pte(child, sptep);
-		kvm_flush_remote_tlbs_with_address(vcpu->kvm, child->gfn, 1);
+		kvm_flush_remote_tlbs_with_address(vcpu->kvm, child->gfn,
+				KVM_PAGES_PER_HPAGE(child->role.level + 1));
 	}
 }
 
-- 
2.31.1

