Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15280234CE0
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 23:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgGaVX3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 17:23:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:50227 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728950AbgGaVX3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 17:23:29 -0400
IronPort-SDR: 0hVkYU3aPNT2LRzsPdvexGqZ08NSnATDz7OEIW0jTQXlCdoQE7brbjJH9j5y6RpmW6Gt2gzq3B
 4L27yS7wOWlQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="151075131"
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="151075131"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 14:23:27 -0700
IronPort-SDR: FxnBvKfSaMOxsQS0SIA0SbI2MiRb3HdU0ywlypcOM9y16r0V9SdDurFsfBCMmQCZrv+sZbBylU
 f8JMTscKh5AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="331191308"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga007.jf.intel.com with ESMTP; 31 Jul 2020 14:23:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        eric van tassell <Eric.VanTassell@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [RFC PATCH 5/8] KVM: SVM: Use the KVM MMU SPTE pinning hooks to pin pages on demand
Date:   Fri, 31 Jul 2020 14:23:20 -0700
Message-Id: <20200731212323.21746-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200731212323.21746-1-sean.j.christopherson@intel.com>
References: <20200731212323.21746-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cc: eric van tassell <Eric.VanTassell@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm/sev.c | 24 ++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  3 +++
 arch/x86/kvm/svm/svm.h |  3 +++
 3 files changed, 30 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f7f1f4ecf08e3..f640b8beb443e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1193,3 +1193,27 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 	svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
 	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 }
+
+bool sev_pin_spte(struct kvm_vcpu *vcpu, gfn_t gfn, int level, kvm_pfn_t pfn)
+{
+	if (!sev_guest(vcpu->kvm))
+		return false;
+
+	get_page(pfn_to_page(pfn));
+
+	/*
+	 * Flush any cached lines of the page being added since "ownership" of
+	 * it will be transferred from the host to an encrypted guest.
+	 */
+	clflush_cache_range(__va(pfn << PAGE_SHIFT), page_level_size(level));
+
+	return true;
+}
+
+void sev_drop_pinned_spte(struct kvm *kvm, gfn_t gfn, int level, kvm_pfn_t pfn)
+{
+	if (WARN_ON_ONCE(!sev_guest(kvm)))
+		return;
+
+	put_page(pfn_to_page(pfn));
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0ae20af3a1677..a9f7515b4eff3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4150,6 +4150,9 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.need_emulation_on_page_fault = svm_need_emulation_on_page_fault,
 
 	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
+
+	.pin_spte = sev_pin_spte,
+	.drop_pinned_spte = sev_drop_pinned_spte,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a798e17317094..3060e3e529cbc 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -489,4 +489,7 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu);
 int __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
 
+bool sev_pin_spte(struct kvm_vcpu *vcpu, gfn_t gfn, int level, kvm_pfn_t pfn);
+void sev_drop_pinned_spte(struct kvm *kvm, gfn_t gfn, int level, kvm_pfn_t pfn);
+
 #endif
-- 
2.28.0

