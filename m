Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41D18F82CB
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 23:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfKKWMb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 17:12:31 -0500
Received: from mga03.intel.com ([134.134.136.65]:2932 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbfKKWMa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 17:12:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Nov 2019 14:12:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,294,1569308400"; 
   d="scan'208";a="287302344"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 11 Nov 2019 14:12:29 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Adam Borowski <kilobyte@angband.pl>,
        David Hildenbrand <david@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 2/3] KVM: x86/mmu: Remove superfluous is_error_pfn() check from THP adjust
Date:   Mon, 11 Nov 2019 14:12:28 -0800
Message-Id: <20191111221229.24732-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111221229.24732-1-sean.j.christopherson@intel.com>
References: <20191111221229.24732-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace the is_error_noslot_pfn() check in transparent_hugepage_adjust()
with an is_noslot_pfn() check.  thp_adjust() cannot be reached with an
error pfn as it is always called after handle_abnormal_pfn(), which
aborts the page fault handler if an error pfn is encountered.  Don't
bother future proofing thp_adjust() with a WARN on is_error_pfn(), as
calling thp_adjust() before handle_abnormal_pfn() is impossible for all
intents and purposes, e.g. thp_adjust() relies on being called after
mmu_notifier_retry() and while holding mmu_lock, thus moving it would
essentially require a complete rewrite of KVM's page fault handlers.

No functional change intended.

Reported-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index bf82b1f2e834..c35c6fb2635a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3305,7 +3305,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
 	 * PT_PAGE_TABLE_LEVEL and there would be no adjustment done
 	 * here.
 	 */
-	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
+	if (!is_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
 	    !kvm_is_zone_device_pfn(pfn) && level == PT_PAGE_TABLE_LEVEL &&
 	    PageTransCompoundMap(pfn_to_page(pfn)) &&
 	    !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL)) {
-- 
2.24.0

