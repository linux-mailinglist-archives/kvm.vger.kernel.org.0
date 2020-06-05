Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676181F0283
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 23:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgFEVnt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 17:43:49 -0400
Received: from mga17.intel.com ([192.55.52.151]:49307 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728491AbgFEVjK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 17:39:10 -0400
IronPort-SDR: qXIFE9m/t4XB8u9xTeN+7KQUmdZz1KbjoeV3NJuHQ73pXqJrekjqQ92xHzQSjzUjv22FRBJ8a+
 dAyHAxEbcetg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2020 14:39:08 -0700
IronPort-SDR: XqKHcuabHK74BbG2b4w8feUvlGlhypfvZy/rS1JT1ziK1xvV2rFgi0aW811keyz+zG+1ymHY4P
 o06uuWAI8aXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,477,1583222400"; 
   d="scan'208";a="287860886"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga002.jf.intel.com with ESMTP; 05 Jun 2020 14:39:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Zyngier <maz@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 07/21] KVM: x86/mmu: Topup memory caches after walking GVA->GPA
Date:   Fri,  5 Jun 2020 14:38:39 -0700
Message-Id: <20200605213853.14959-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200605213853.14959-1-sean.j.christopherson@intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Topup memory caches after walking the GVA->GPA translation during a
shadow page fault, there is no need to ensure the caches are full when
walking the GVA.  As of commit f5a1e9f89504f ("KVM: MMU: remove call
to kvm_mmu_pte_write from walk_addr"), the FNAME(walk_addr) flow no
longer add rmaps via kvm_mmu_pte_write().

This avoids allocating memory in the case that the GVA is unmapped in
the guest, and also provides a paper trail of why/when the memory caches
need to be filled.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 38c576495048..3de32122f601 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -791,10 +791,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 
 	pgprintk("%s: addr %lx err %x\n", __func__, addr, error_code);
 
-	r = mmu_topup_memory_caches(vcpu);
-	if (r)
-		return r;
-
 	/*
 	 * If PFEC.RSVD is set, this is a shadow page fault.
 	 * The bit needs to be cleared before walking guest page tables.
@@ -822,6 +818,10 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 		return RET_PF_EMULATE;
 	}
 
+	r = mmu_topup_memory_caches(vcpu);
+	if (r)
+		return r;
+
 	vcpu->arch.write_fault_to_shadow_pgtable = false;
 
 	is_self_change_mapping = FNAME(is_self_change_mapping)(vcpu,
-- 
2.26.0

