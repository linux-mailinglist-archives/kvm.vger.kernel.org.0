Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF1F6125589
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2019 22:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfLRV4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Dec 2019 16:56:51 -0500
Received: from mga17.intel.com ([192.55.52.151]:6978 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727119AbfLRVzv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Dec 2019 16:55:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 13:55:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="222108172"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 18 Dec 2019 13:55:50 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kurz <groug@kaod.org>
Subject: [PATCH v2 39/45] KVM: MIPS: Move all vcpu init code into kvm_arch_vcpu_create()
Date:   Wed, 18 Dec 2019 13:55:24 -0800
Message-Id: <20191218215530.2280-40-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218215530.2280-1-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fold init() into create() now that the two are called back-to-back by
common KVM code (kvm_vcpu_init() calls kvm_arch_vcpu_init() as its last
action, and kvm_vm_ioctl_create_vcpu() calls kvm_arch_vcpu_create()
immediately thereafter).  Rinse and repeat for kvm_arch_vcpu_uninit()
and kvm_arch_vcpu_destroy().  This paves the way for removing
kvm_arch_vcpu_{un}init() entirely.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/mips/kvm/mips.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 06366e2415a6..879a7cbd5b54 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -294,6 +294,14 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kvm_debug("kvm @ %p: create cpu %d at %p\n",
 		  vcpu->kvm, vcpu->vcpu_id, vcpu);
 
+	err = kvm_mips_callbacks->vcpu_init(vcpu);
+	if (err)
+		return err;
+
+	hrtimer_init(&vcpu->arch.comparecount_timer, CLOCK_MONOTONIC,
+		     HRTIMER_MODE_REL);
+	vcpu->arch.comparecount_timer.function = kvm_mips_comparecount_wakeup;
+
 	/*
 	 * Allocate space for host mode exception handlers that handle
 	 * guest mode exits
@@ -307,7 +315,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	if (!gebase) {
 		err = -ENOMEM;
-		goto out;
+		goto out_uninit_vcpu;
 	}
 	kvm_debug("Allocated %d bytes for KVM Exception Handlers @ %p\n",
 		  ALIGN(size, PAGE_SIZE), gebase);
@@ -397,7 +405,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	kfree(vcpu->arch.kseg0_commpage);
 out_free_gebase:
 	kfree(gebase);
-out:
+out_uninit_vcpu:
+	kvm_mips_callbacks->vcpu_uninit(vcpu);
 	return err;
 }
 
@@ -410,6 +419,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_caches(vcpu);
 	kfree(vcpu->arch.guest_ebase);
 	kfree(vcpu->arch.kseg0_commpage);
+
+	kvm_mips_callbacks->vcpu_uninit(vcpu);
 }
 
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
@@ -1221,21 +1232,12 @@ static enum hrtimer_restart kvm_mips_comparecount_wakeup(struct hrtimer *timer)
 
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 {
-	int err;
-
-	err = kvm_mips_callbacks->vcpu_init(vcpu);
-	if (err)
-		return err;
-
-	hrtimer_init(&vcpu->arch.comparecount_timer, CLOCK_MONOTONIC,
-		     HRTIMER_MODE_REL);
-	vcpu->arch.comparecount_timer.function = kvm_mips_comparecount_wakeup;
 	return 0;
 }
 
 void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
-	kvm_mips_callbacks->vcpu_uninit(vcpu);
+
 }
 
 int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
-- 
2.24.1

