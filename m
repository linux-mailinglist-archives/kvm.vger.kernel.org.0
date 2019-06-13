Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5324498E
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbfFMRW0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:22:26 -0400
Received: from mga06.intel.com ([134.134.136.31]:56970 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbfFMRWZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:22:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 10:22:24 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by fmsmga001.fm.intel.com with ESMTP; 13 Jun 2019 10:22:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Jiri Palecek <jpalecek@web.de>
Subject: [PATCH] KVM: x86/mmu: Allocate PAE root array when using SVM's 32-bit NPT
Date:   Thu, 13 Jun 2019 10:22:23 -0700
Message-Id: <20190613172223.17119-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SVM's Nested Page Tables (NPT) reuses x86 paging for the host-controlled
page walk.  For 32-bit KVM, this means PAE paging is used even when TDP
is enabled, i.e. the PAE root array needs to be allocated.

Fixes: ee6268ba3a68 ("KVM: x86: Skip pae_root shadow allocation if tdp enabled")
Cc: stable@vger.kernel.org
Reported-by: Jiri Palecek <jpalecek@web.de>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

Jiri, can you please test this patch?  I haven't actually verified this
fixes the bug due to lack of SVM hardware.

 arch/x86/kvm/mmu.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1e9ba81accba..d3c3d5e5ffd4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5602,14 +5602,18 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
 	struct page *page;
 	int i;
 
-	if (tdp_enabled)
-		return 0;
-
 	/*
-	 * When emulating 32-bit mode, cr3 is only 32 bits even on x86_64.
-	 * Therefore we need to allocate shadow page tables in the first
-	 * 4GB of memory, which happens to fit the DMA32 zone.
+	 * When using PAE paging, the four PDPTEs are treated as 'root' pages,
+	 * while the PDP table is a per-vCPU construct that's allocated at MMU
+	 * creation.  When emulating 32-bit mode, cr3 is only 32 bits even on
+	 * x86_64.  Therefore we need to allocate the PDP table in the first
+	 * 4GB of memory, which happens to fit the DMA32 zone.  Except for
+	 * SVM's 32-bit NPT support, TDP paging doesn't use PAE paging and can
+	 * skip allocating the PDP table.
 	 */
+	if (tdp_enabled && kvm_x86_ops->get_tdp_level(vcpu) > PT32E_ROOT_LEVEL)
+		return 0;
+
 	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_DMA32);
 	if (!page)
 		return -ENOMEM;
-- 
2.21.0

