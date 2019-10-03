Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D77B7CB15B
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 23:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388735AbfJCVkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 17:40:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:52653 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387926AbfJCVi7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 17:38:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2019 14:38:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,253,1566889200"; 
   d="scan'208";a="186051615"
Received: from linksys13920.jf.intel.com (HELO rpedgeco-DESK5.jf.intel.com) ([10.54.75.11])
  by orsmga008.jf.intel.com with ESMTP; 03 Oct 2019 14:38:57 -0700
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org, luto@kernel.org, peterz@infradead.org,
        dave.hansen@intel.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, keescook@chromium.org
Cc:     kristen@linux.intel.com, deneen.t.dock@intel.com,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [RFC PATCH 01/13] kvm: Enable MTRR to work with GFNs with perm bits
Date:   Thu,  3 Oct 2019 14:23:48 -0700
Message-Id: <20191003212400.31130-2-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mask gfn by maxphyaddr in kvm_mtrr_get_guest_memory_type so that the
guests view of gfn is used when high bits of the physical memory are
used as extra permissions bits. This supports the KVM XO feature.

TODO: Since MTRR is emulated using EPT permissions, the XO version of
the gpa range will not inherrit the MTRR type with this implementation.
There shouldn't be any legacy use of KVM XO, but hypothetically it could
interfere with the uncacheable MTRR type.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kvm/mtrr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 25ce3edd1872..da38f3b83e51 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -621,6 +621,14 @@ u8 kvm_mtrr_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn)
 	const int wt_wb_mask = (1 << MTRR_TYPE_WRBACK)
 			       | (1 << MTRR_TYPE_WRTHROUGH);
 
+	/*
+	 * Handle situations where gfn bits are used as permissions bits by
+	 * masking KVMs view of the gfn with the guests physical address bits
+	 * in order to match the guests view of physical address. For normal
+	 * situations this will have no effect.
+	 */
+	gfn &= (1ULL << (cpuid_maxphyaddr(vcpu) - PAGE_SHIFT));
+
 	start = gfn_to_gpa(gfn);
 	end = start + PAGE_SIZE;
 
-- 
2.17.1

