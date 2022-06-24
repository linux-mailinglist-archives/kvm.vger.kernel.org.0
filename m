Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFC4558F23
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 05:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiFXDhU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 23:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiFXDhQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 23:37:16 -0400
Received: from out0-158.mail.aliyun.com (out0-158.mail.aliyun.com [140.205.0.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C1953A72;
        Thu, 23 Jun 2022 20:37:11 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047212;MF=houwenlong.hwl@antgroup.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---.OBfZx4e_1656041828;
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.OBfZx4e_1656041828)
          by smtp.aliyun-inc.com;
          Fri, 24 Jun 2022 11:37:08 +0800
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
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] KVM: x86/mmu: Use 1 as the size of gfn range for tlb flushing in FNAME(invlpg)()
Date:   Fri, 24 Jun 2022 11:37:01 +0800
Message-Id: <52c2dc356b609474d7a92e72710b270861c1c83e.1656039275.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1656039275.git.houwenlong.hwl@antgroup.com>
References: <cover.1656039275.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Only SP with PG_LEVLE_4K level could be unsync, so the size of gfn range
must be 1.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index fa78ee0caffd..fc6d8dcff019 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -938,8 +938,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 			mmu_page_zap_pte(vcpu->kvm, sp, sptep, NULL);
 			if (is_shadow_present_pte(old_spte))
 				kvm_flush_remote_tlbs_with_address(vcpu->kvm,
-					kvm_mmu_page_get_gfn(sp, sptep - sp->spt),
-					KVM_PAGES_PER_HPAGE(sp->role.level));
+					kvm_mmu_page_get_gfn(sp, sptep - sp->spt), 1);
 
 			if (!rmap_can_add(vcpu))
 				break;
-- 
2.31.1

