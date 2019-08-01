Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61F827E45C
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 22:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732878AbfHAUfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 16:35:37 -0400
Received: from mga05.intel.com ([192.55.52.43]:47474 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbfHAUfZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 16:35:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Aug 2019 13:35:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,335,1559545200"; 
   d="scan'208";a="191701853"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 01 Aug 2019 13:35:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] KVM: x86: Rename access permissions cache member in struct kvm_vcpu_arch
Date:   Thu,  1 Aug 2019 13:35:21 -0700
Message-Id: <20190801203523.5536-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190801203523.5536-1-sean.j.christopherson@intel.com>
References: <20190801203523.5536-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename "access" to "mmio_access" to match the other MMIO cache members
and to make it more obvious that it's tracking the access permissions
for the MMIO cache.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 Documentation/virtual/kvm/mmu.txt | 4 ++--
 arch/x86/include/asm/kvm_host.h   | 2 +-
 arch/x86/kvm/x86.c                | 2 +-
 arch/x86/kvm/x86.h                | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
index 2efe0efc516e..4ade0df93552 100644
--- a/Documentation/virtual/kvm/mmu.txt
+++ b/Documentation/virtual/kvm/mmu.txt
@@ -294,7 +294,7 @@ Handling a page fault is performed as follows:
    - walk shadow page table
    - check for valid generation number in the spte (see "Fast invalidation of
      MMIO sptes" below)
-   - cache the information to vcpu->arch.mmio_gva, vcpu->arch.access and
+   - cache the information to vcpu->arch.mmio_gva, vcpu->arch.mmio_access and
      vcpu->arch.mmio_gfn, and call the emulator
  - If both P bit and R/W bit of error code are set, this could possibly
    be handled as a "fast page fault" (fixed without taking the MMU lock).  See
@@ -304,7 +304,7 @@ Handling a page fault is performed as follows:
    - if permissions are insufficient, reflect the fault back to the guest
  - determine the host page
    - if this is an mmio request, there is no host page; cache the info to
-     vcpu->arch.mmio_gva, vcpu->arch.access and vcpu->arch.mmio_gfn
+     vcpu->arch.mmio_gva, vcpu->arch.mmio_access and vcpu->arch.mmio_gfn
  - walk the shadow page table to find the spte for the translation,
    instantiating missing intermediate page tables as necessary
    - If this is an mmio request, cache the mmio info to the spte and set some
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e74f0711eaaf..2d931d208f29 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -715,7 +715,7 @@ struct kvm_vcpu_arch {
 
 	/* Cache MMIO info */
 	u64 mmio_gva;
-	unsigned access;
+	unsigned mmio_access;
 	gfn_t mmio_gfn;
 	u64 mmio_gen;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 01e18caac825..85c374e4d622 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5370,7 +5370,7 @@ static int vcpu_mmio_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
 	 */
 	if (vcpu_match_mmio_gva(vcpu, gva)
 	    && !permission_fault(vcpu, vcpu->arch.walk_mmu,
-				 vcpu->arch.access, 0, access)) {
+				 vcpu->arch.mmio_access, 0, access)) {
 		*gpa = vcpu->arch.mmio_gfn << PAGE_SHIFT |
 					(gva & (PAGE_SIZE - 1));
 		trace_vcpu_match_mmio(gva, *gpa, write, false);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 6594020c0691..b5274e2a53cf 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -196,7 +196,7 @@ static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
 	 * actually a nGPA.
 	 */
 	vcpu->arch.mmio_gva = mmu_is_nested(vcpu) ? 0 : gva & PAGE_MASK;
-	vcpu->arch.access = access;
+	vcpu->arch.mmio_access = access;
 	vcpu->arch.mmio_gfn = gfn;
 	vcpu->arch.mmio_gen = gen;
 }
-- 
2.22.0

