Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBA7297A79
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 05:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759315AbgJXDMI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 23:12:08 -0400
Received: from mga06.intel.com ([134.134.136.31]:38867 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759309AbgJXDMH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Oct 2020 23:12:07 -0400
IronPort-SDR: D5OXP6KpamIb9aVNOSFKkZTTJQT7tLUkUDHFFUhlJuDOi3uzpsPSYjD3vlYiti0N+VOhBuitJp
 /2r60hwkENaA==
X-IronPort-AV: E=McAfee;i="6000,8403,9783"; a="229389569"
X-IronPort-AV: E=Sophos;i="5.77,410,1596524400"; 
   d="scan'208";a="229389569"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2020 20:11:59 -0700
IronPort-SDR: bIZ2xj+aw96+Sk1yGTWgbb5Ogmaor9oKaSj9duSyedbvH1saqltNxrA9rOPpS3/YmqrJibpRFZ
 nKVX7ZkXQj6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,410,1596524400"; 
   d="scan'208";a="354637310"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga002.fm.intel.com with ESMTP; 23 Oct 2020 20:11:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>
Subject: [PATCH] KVM: x86/mmu: Avoid modulo operator on 64-bit value to fix i386 build
Date:   Fri, 23 Oct 2020 20:11:50 -0700
Message-Id: <20201024031150.9318-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace a modulo operator with the more common pattern for computing the
gfn "offset" of a huge page to fix an i386 build error.

  arch/x86/kvm/mmu/tdp_mmu.c:212: undefined reference to `__umoddi3'

Fixes: 2f2fad0897cb ("kvm: x86/mmu: Add functions to handle changed TDP SPTEs")
Reported-by: Daniel Díaz <daniel.diaz@linaro.org>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

Linus, do you want to take this directly so that it's in rc1?  I don't
know whether Paolo will be checking mail before then.

 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e246d71b8ea2..27e381c9da6c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -209,7 +209,7 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 
 	WARN_ON(level > PT64_ROOT_MAX_LEVEL);
 	WARN_ON(level < PG_LEVEL_4K);
-	WARN_ON(gfn % KVM_PAGES_PER_HPAGE(level));
+	WARN_ON(gfn & (KVM_PAGES_PER_HPAGE(level) - 1));
 
 	/*
 	 * If this warning were to trigger it would indicate that there was a
-- 
2.28.0

