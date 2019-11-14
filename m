Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26FDFFB8E4
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 20:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfKMTaf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 14:30:35 -0500
Received: from mga06.intel.com ([134.134.136.31]:58143 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbfKMTaf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 14:30:35 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Nov 2019 11:30:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,301,1569308400"; 
   d="scan'208";a="214379277"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 13 Nov 2019 11:30:33 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Take slots_lock when using kvm_mmu_zap_all_fast()
Date:   Wed, 13 Nov 2019 11:30:32 -0800
Message-Id: <20191113193032.12912-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Acquire the per-VM slots_lock when zapping all shadow pages as part of
toggling nx_huge_pages.  The fast zap algorithm relies on exclusivity
(via slots_lock) to identify obsolete vs. valid shadow pages, e.g. it
uses a single bit for its generation number.  Holding slots_lock also
obviates the need to acquire a read lock on the VM's srcu.

Failing to take slots_lock when toggling nx_huge_pages allows multiple
instances of kvm_mmu_zap_all_fast() to run concurrently, as the other
user, KVM_SET_USER_MEMORY_REGION, does not take the global kvm_lock.
Concurrent fast zap instances causes obsolete shadow pages to be
incorrectly identified as valid due to the single bit generation number
wrapping, which results in stale shadow pages being left in KVM's MMU
and leads to all sorts of undesirable behavior.

The bug is easily confirmed by running with CONFIG_PROVE_LOCKING and
toggling nx_huge_pages via its module param.

Note, the fast zap algorithm could use a 64-bit generation instead of
relying on exclusivity for correctness, but all callers except the
recently added set_nx_huge_pages() need to hold slots_lock anyways.
Given that toggling nx_huge_pages is by no means a fast path, force it
to conform to the current approach instead of reworking the algorithm to
support concurrent calls.

Fixes: b8e8c8303ff28 ("kvm: mmu: ITLB_MULTIHIT mitigation")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index cf718fa23dff..2ce9da58611e 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -6285,14 +6285,13 @@ static int set_nx_huge_pages(const char *val, const struct kernel_param *kp)
 
 	if (new_val != old_val) {
 		struct kvm *kvm;
-		int idx;
 
 		mutex_lock(&kvm_lock);
 
 		list_for_each_entry(kvm, &vm_list, vm_list) {
-			idx = srcu_read_lock(&kvm->srcu);
+			mutex_lock(&kvm->slots_lock);
 			kvm_mmu_zap_all_fast(kvm);
-			srcu_read_unlock(&kvm->srcu, idx);
+			mutex_unlock(&kvm->slots_lock);
 
 			wake_up_process(kvm->arch.nx_lpage_recovery_thread);
 		}
-- 
2.24.0

