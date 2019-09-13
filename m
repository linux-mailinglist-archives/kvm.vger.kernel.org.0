Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A184B174E
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 04:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbfIMCqb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 22:46:31 -0400
Received: from mga07.intel.com ([134.134.136.100]:58608 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727387AbfIMCqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 22:46:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 19:46:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="176159528"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 12 Sep 2019 19:46:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Harvey <jamespharvey20@gmail.com>,
        Alex Willamson <alex.williamson@redhat.com>
Subject: [PATCH 09/11] KVM: x86/mmu: Revert "KVM: x86/mmu: Remove is_obsolete() call"
Date:   Thu, 12 Sep 2019 19:46:10 -0700
Message-Id: <20190913024612.28392-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190913024612.28392-1-sean.j.christopherson@intel.com>
References: <20190913024612.28392-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the fast invalidate mechanism has been reintroduced, restore
the performance tweaks for fast invalidation that existed prior to its
removal.

Paraphrasing the original changelog (commit 5ff0568374ed2 was itself a
partial revert):

  Don't force reloading the remote mmu when zapping an obsolete page, as
  a MMU_RELOAD request has already been issued by kvm_mmu_zap_all_fast()
  immediately after incrementing mmu_valid_gen, i.e. after marking pages
  obsolete.

This reverts commit 5ff0568374ed2e585376a3832857ade5daccd381.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 84d916674529..bce19918ca5a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2752,7 +2752,12 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 	} else {
 		list_move(&sp->link, &kvm->arch.active_mmu_pages);
 
-		if (!sp->role.invalid)
+		/*
+		 * Obsolete pages cannot be used on any vCPUs, see the comment
+		 * in kvm_mmu_zap_all_fast().  Note, is_obsolete_sp() also
+		 * treats invalid shadow pages as being obsolete.
+		 */
+		if (!is_obsolete_sp(kvm, sp))
 			kvm_reload_remote_mmus(kvm);
 	}
 
-- 
2.22.0

