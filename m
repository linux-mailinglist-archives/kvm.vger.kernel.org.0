Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57641BB311
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 02:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgD1Ay3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 20:54:29 -0400
Received: from mga05.intel.com ([192.55.52.43]:42479 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726263AbgD1AyY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 20:54:24 -0400
IronPort-SDR: oCAsUTRmUMUoMcFnSAKILf8quvrTiuz0fQNeL04Qf3vxggU3hK+RMNNLUrVk4nwCJ8mJDo5uBq
 sJ6asStPOqyg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 17:54:23 -0700
IronPort-SDR: N1WUVVOvJKgblEUFWbyztygjrYuAyG4M1zEXAKuYoY+LYOYKqHyY+dodY+nMCZV9BI0/ayf61m
 QrPGwJ4ZIp1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,325,1583222400"; 
   d="scan'208";a="260920807"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 27 Apr 2020 17:54:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Barret Rhoden <brho@google.com>
Subject: [PATCH 1/3] KVM: x86/mmu: Tweak PSE hugepage handling to avoid 2M vs 4M conundrum
Date:   Mon, 27 Apr 2020 17:54:20 -0700
Message-Id: <20200428005422.4235-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200428005422.4235-1-sean.j.christopherson@intel.com>
References: <20200428005422.4235-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Change the PSE hugepage handling in walk_addr_generic() to fire on any
page level greater than PT_PAGE_TABLE_LEVEL, a.k.a. PG_LEVEL_4K.  PSE
paging only has two levels, so "== 2" and "> 1" are functionally the
seam, i.e. this is a nop.

A future patch will drop KVM's PT_*_LEVEL enums in favor of the kernel's
PG_LEVEL_* enums, at which point "walker->level == PG_LEVEL_2M" is
semantically incorrect (though still functionally ok).

No functional change intended.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index efec7d27b8c5..ca39bd315f70 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -436,7 +436,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	gfn = gpte_to_gfn_lvl(pte, walker->level);
 	gfn += (addr & PT_LVL_OFFSET_MASK(walker->level)) >> PAGE_SHIFT;
 
-	if (PTTYPE == 32 && walker->level == PT_DIRECTORY_LEVEL && is_cpuid_PSE36())
+	if (PTTYPE == 32 && walker->level > PT_PAGE_TABLE_LEVEL && is_cpuid_PSE36())
 		gfn += pse36_gfn_delta(pte);
 
 	real_gpa = mmu->translate_gpa(vcpu, gfn_to_gpa(gfn), access, &walker->fault);
-- 
2.26.0

