Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80969B042D
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 20:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbfIKSul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 14:50:41 -0400
Received: from mga06.intel.com ([134.134.136.31]:39421 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729016AbfIKSul (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 14:50:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Sep 2019 11:50:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="196980870"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga002.jf.intel.com with ESMTP; 11 Sep 2019 11:50:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: [PATCH 03/13] KVM: x86: Allocate memslot resources during prepare_memory_region()
Date:   Wed, 11 Sep 2019 11:50:28 -0700
Message-Id: <20190911185038.24341-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190911185038.24341-1-sean.j.christopherson@intel.com>
References: <20190911185038.24341-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allocate the various metadata structures associated with a memslot
during during kvm_arch_prepare_memory_region(), which paves the way for
removing kvm_arch_create_memslot() altogether.  Moving x86's memory
allocation only changes the order of kernel memory allocations between
x86 and common KVM code.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4cfd786d0b6..72ec6272d7cb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9484,6 +9484,12 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
 
 int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
 			    unsigned long npages)
+{
+	return 0;
+}
+
+static int kvm_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
+			      unsigned long npages)
 {
 	int i;
 
@@ -9561,6 +9567,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				const struct kvm_userspace_memory_region *mem,
 				enum kvm_mr_change change)
 {
+	if (change == KVM_MR_CREATE)
+		return kvm_create_memslot(kvm, memslot,
+					  mem->memory_size >> PAGE_SHIFT);
 	return 0;
 }
 
-- 
2.22.0

