Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2D51179CC9
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 01:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388567AbgCEAYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 19:24:25 -0500
Received: from mga03.intel.com ([134.134.136.65]:26857 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388407AbgCEAYZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Mar 2020 19:24:25 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2020 16:24:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,515,1574150400"; 
   d="scan'208";a="352228758"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 04 Mar 2020 16:24:23 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: Fix warning due to implicit truncation on 32-bit KVM
Date:   Wed,  4 Mar 2020 16:24:22 -0800
Message-Id: <20200305002422.20968-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly cast the integer literal to an unsigned long when stuffing a
non-canonical value into the host virtual address during private memslot
deletion.  The explicit cast fixes a warning that gets promoted to an
error when running with KVM's newfangled -Werror setting.

  arch/x86/kvm/x86.c:9739:9: error: large integer implicitly truncated
  to unsigned type [-Werror=overflow]

Fixes: a3e967c0b87d3 ("KVM: Terminate memslot walks via used_slots"
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ba4d476b79ad..fa03f31ab33c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9735,8 +9735,12 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
 		if (!slot || !slot->npages)
 			return 0;
 
-		/* Stuff a non-canonical value to catch use-after-delete. */
-		hva = 0xdeadull << 48;
+		/*
+		 * Stuff a non-canonical value to catch use-after-delete.  This
+		 * ends up being 0 on 32-bit KVM, but there's no better
+		 * alternative.
+		 */
+		hva = (unsigned long)(0xdeadull << 48);
 		old_npages = slot->npages;
 	}
 
-- 
2.24.1

