Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15F7454389
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 10:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234963AbhKQJXn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 04:23:43 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:38972 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231256AbhKQJXl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Nov 2021 04:23:41 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=houwenlong93@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Ux1fBIC_1637140841;
Received: from localhost(mailfrom:houwenlong93@linux.alibaba.com fp:SMTPD_---0Ux1fBIC_1637140841)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 17 Nov 2021 17:20:41 +0800
From:   Hou Wenlong <houwenlong93@linux.alibaba.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86/mmu: Skip tlb flush if it has been done in zap_gfn_range()
Date:   Wed, 17 Nov 2021 17:20:39 +0800
Message-Id: <5e16546e228877a4d974f8c0e448a93d52c7a5a9.1637140154.git.houwenlong93@linux.alibaba.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the parameter flush is set, zap_gfn_range() would flush remote tlb
when yield, then tlb flush is not needed outside. So use the return
value of zap_gfn_range() directly instead of OR on it in
kvm_unmap_gfn_range() and kvm_tdp_mmu_unmap_gfn_range().

Fixes: 3039bcc744980 ("KVM: Move x86's MMU notifier memslot walkers to generic code")
Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
---
 arch/x86/kvm/mmu/mmu.c     | 2 +-
 arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 354d2ca92df4..d57319e596a9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1582,7 +1582,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 		flush = kvm_handle_gfn_range(kvm, range, kvm_unmap_rmapp);
 
 	if (is_tdp_mmu_enabled(kvm))
-		flush |= kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
+		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
 
 	return flush;
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7c5dd83e52de..9d03f5b127dc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1034,8 +1034,8 @@ bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 	struct kvm_mmu_page *root;
 
 	for_each_tdp_mmu_root(kvm, root, range->slot->as_id)
-		flush |= zap_gfn_range(kvm, root, range->start, range->end,
-				       range->may_block, flush, false);
+		flush = zap_gfn_range(kvm, root, range->start, range->end,
+				      range->may_block, flush, false);
 
 	return flush;
 }
-- 
2.31.1

