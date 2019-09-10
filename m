Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0ACAE88B
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 12:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732641AbfIJKm1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 06:42:27 -0400
Received: from mga04.intel.com ([192.55.52.120]:64085 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729219AbfIJKm0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 06:42:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 03:42:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="196512157"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.44])
  by orsmga002.jf.intel.com with ESMTP; 10 Sep 2019 03:42:24 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
Subject: [PATCH v2 2/2] KVM: CPUID: Put maxphyaddr updating together with virtual address width checking
Date:   Tue, 10 Sep 2019 18:27:42 +0800
Message-Id: <20190910102742.47729-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190910102742.47729-1-xiaoyao.li@intel.com>
References: <20190910102742.47729-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since both of maxphyaddr updating and virtual address width checking
need to query the cpuid leaf 0x80000008. We can put them together.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/cpuid.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 67fa44ab87af..fd0a66079001 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -118,6 +118,7 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
 	/*
+	 * Update physical address width and check virtual address width.
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
 	 * canonical address checks; exit if it is ever changed.
 	 */
@@ -127,7 +128,10 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 
 		if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
 			return -EINVAL;
+
+		vcpu->arch.maxphyaddr = best->eax & 0xff;
 	}
+	vcpu->arch.maxphyaddr = 36;
 
 	best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
 	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
@@ -144,8 +148,6 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	/* Update physical-address width */
-	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
 	kvm_mmu_reset_context(vcpu);
 
 	kvm_pmu_refresh(vcpu);
-- 
2.19.1

