Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77C6B16373C
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 00:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbgBRXav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 18:30:51 -0500
Received: from mga04.intel.com ([192.55.52.120]:38638 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727772AbgBRX34 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 18:29:56 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 15:29:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="282936650"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Feb 2020 15:29:55 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 03/13] KVM: x86: Move emulation-only helpers to emulate.c
Date:   Tue, 18 Feb 2020 15:29:43 -0800
Message-Id: <20200218232953.5724-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218232953.5724-1-sean.j.christopherson@intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move ctxt_virt_addr_bits() and emul_is_noncanonical_address() from x86.h
to emulate.c.  This eliminates all references to struct x86_emulate_ctxt
from x86.h, and sets the stage for a future patch to stop including
kvm_emulate.h in asm/kvm_host.h.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/emulate.c | 11 +++++++++++
 arch/x86/kvm/x86.h     | 11 -----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index ddbc61984227..1e394cb190ce 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -673,6 +673,17 @@ static void set_segment_selector(struct x86_emulate_ctxt *ctxt, u16 selector,
 	ctxt->ops->set_segment(ctxt, selector, &desc, base3, seg);
 }
 
+static inline u8 ctxt_virt_addr_bits(struct x86_emulate_ctxt *ctxt)
+{
+	return (ctxt->ops->get_cr(ctxt, 4) & X86_CR4_LA57) ? 57 : 48;
+}
+
+static inline bool emul_is_noncanonical_address(u64 la,
+						struct x86_emulate_ctxt *ctxt)
+{
+	return get_canonical(la, ctxt_virt_addr_bits(ctxt)) != la;
+}
+
 /*
  * x86 defines three classes of vector instructions: explicitly
  * aligned, explicitly unaligned, and the rest, which change behaviour
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 3624665acee4..8409842a25d9 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -149,11 +149,6 @@ static inline u8 vcpu_virt_addr_bits(struct kvm_vcpu *vcpu)
 	return kvm_read_cr4_bits(vcpu, X86_CR4_LA57) ? 57 : 48;
 }
 
-static inline u8 ctxt_virt_addr_bits(struct x86_emulate_ctxt *ctxt)
-{
-	return (ctxt->ops->get_cr(ctxt, 4) & X86_CR4_LA57) ? 57 : 48;
-}
-
 static inline u64 get_canonical(u64 la, u8 vaddr_bits)
 {
 	return ((int64_t)la << (64 - vaddr_bits)) >> (64 - vaddr_bits);
@@ -164,12 +159,6 @@ static inline bool is_noncanonical_address(u64 la, struct kvm_vcpu *vcpu)
 	return get_canonical(la, vcpu_virt_addr_bits(vcpu)) != la;
 }
 
-static inline bool emul_is_noncanonical_address(u64 la,
-						struct x86_emulate_ctxt *ctxt)
-{
-	return get_canonical(la, ctxt_virt_addr_bits(ctxt)) != la;
-}
-
 static inline void vcpu_cache_mmio_info(struct kvm_vcpu *vcpu,
 					gva_t gva, gfn_t gfn, unsigned access)
 {
-- 
2.24.1

