Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0B0155D00
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 18:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbgBGRiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 12:38:18 -0500
Received: from mga06.intel.com ([134.134.136.31]:53093 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726897AbgBGRhv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 12:37:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 09:37:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,414,1574150400"; 
   d="scan'208";a="346067532"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 07 Feb 2020 09:37:49 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/7] KVM: x86/mmu: Fix struct guest_walker arrays for 5-level paging
Date:   Fri,  7 Feb 2020 09:37:42 -0800
Message-Id: <20200207173747.6243-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200207173747.6243-1-sean.j.christopherson@intel.com>
References: <20200207173747.6243-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define PT_MAX_FULL_LEVELS as PT64_ROOT_MAX_LEVEL, i.e. 5, to fix shadow
paging for 5-level guest page tables.  PT_MAX_FULL_LEVELS is used to
size the arrays that track guest pages table information, i.e. using a
"max levels" of 4 causes KVM to access garbage beyond the end of an
array when querying state for level 5 entries.  E.g. FNAME(gpte_changed)
will read garbage and most likely return %true for a level 5 entry,
soft-hanging the guest because FNAME(fetch) will restart the guest
instead of creating SPTEs because it thinks the guest PTE has changed.

Note, KVM doesn't yet support 5-level nested EPT, so PT_MAX_FULL_LEVELS
gets to stay "4" for the PTTYPE_EPT case.

Fixes: 855feb673640 ("KVM: MMU: Add 5 level EPT & Shadow page table support.")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 4e1ef0473663..e4c8a4cbf407 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -33,7 +33,7 @@
 	#define PT_GUEST_ACCESSED_SHIFT PT_ACCESSED_SHIFT
 	#define PT_HAVE_ACCESSED_DIRTY(mmu) true
 	#ifdef CONFIG_X86_64
-	#define PT_MAX_FULL_LEVELS 4
+	#define PT_MAX_FULL_LEVELS PT64_ROOT_MAX_LEVEL
 	#define CMPXCHG cmpxchg
 	#else
 	#define CMPXCHG cmpxchg64
-- 
2.24.1

