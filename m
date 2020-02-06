Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D380154EAC
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 23:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgBFWIi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 17:08:38 -0500
Received: from mga14.intel.com ([192.55.52.115]:64211 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727717AbgBFWIi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 17:08:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 14:08:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,411,1574150400"; 
   d="scan'208";a="404625085"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 06 Feb 2020 14:08:37 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] KVM: x86/mmu: Fix struct guest_walker arrays for 5-level paging
Date:   Thu,  6 Feb 2020 14:08:31 -0800
Message-Id: <20200206220836.22743-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200206220836.22743-1-sean.j.christopherson@intel.com>
References: <20200206220836.22743-1-sean.j.christopherson@intel.com>
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

Fixes: 855feb673640 ("KVM: MMU: Add 5 level EPT & Shadow page table support.")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 4e1ef0473663..6b15b58f3ecc 100644
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
@@ -66,7 +66,7 @@
 	#define PT_GUEST_ACCESSED_SHIFT 8
 	#define PT_HAVE_ACCESSED_DIRTY(mmu) ((mmu)->ept_ad)
 	#define CMPXCHG cmpxchg64
-	#define PT_MAX_FULL_LEVELS 4
+	#define PT_MAX_FULL_LEVELS PT64_ROOT_MAX_LEVEL
 #else
 	#error Invalid PTTYPE value
 #endif
-- 
2.24.1

