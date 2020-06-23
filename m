Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77194205BDE
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 21:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387551AbgFWTf6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 15:35:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:11007 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387505AbgFWTfp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 15:35:45 -0400
IronPort-SDR: iX/RIRyPcRQJQim+jrPafeWR8C/TAVHEn1Hnkayf3zZzwVeQL7jJhePfNYru3h8Rcvz6OaBrS2
 CwEXkxT9mvCA==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="142430980"
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="142430980"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2020 12:35:44 -0700
IronPort-SDR: OOlI9c2EJF66vE1ak8KQJ1mxYF3k9rYe5Kz0ZWgNE/88d7eFDl9xLCxcKTUuja3Gk+TOu9IBBH
 nqyCGnbh/aUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="263428300"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga007.fm.intel.com with ESMTP; 23 Jun 2020 12:35:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] KVM: x86/mmu: Exit to userspace on make_mmu_pages_available() error
Date:   Tue, 23 Jun 2020 12:35:42 -0700
Message-Id: <20200623193542.7554-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200623193542.7554-1-sean.j.christopherson@intel.com>
References: <20200623193542.7554-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Propagate any error returned by make_mmu_pages_available() out to
userspace instead of resuming the guest if the error occurs while
handling a page fault.  Now that zapping the oldest MMU pages skips
active roots, i.e. fails if and only if there are no zappable pages,
there is no chance for a false positive, i.e. no chance of returning a
spurious error to userspace.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 3 ++-
 arch/x86/kvm/mmu/paging_tmpl.h | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4d40b21a67bd..82086d9eecb0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4157,7 +4157,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	spin_lock(&vcpu->kvm->mmu_lock);
 	if (mmu_notifier_retry(vcpu->kvm, mmu_seq))
 		goto out_unlock;
-	if (make_mmu_pages_available(vcpu) < 0)
+	r = make_mmu_pages_available(vcpu);
+	if (r)
 		goto out_unlock;
 	r = __direct_map(vcpu, gpa, write, map_writable, max_level, pfn,
 			 prefault, is_tdp && lpage_disallowed);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 58234bfaca07..a2db6971231d 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -865,7 +865,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 		goto out_unlock;
 
 	kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
-	if (make_mmu_pages_available(vcpu) < 0)
+	r = make_mmu_pages_available(vcpu);
+	if (r)
 		goto out_unlock;
 	r = FNAME(fetch)(vcpu, addr, &walker, write_fault, max_level, pfn,
 			 map_writable, prefault, lpage_disallowed);
-- 
2.26.0

