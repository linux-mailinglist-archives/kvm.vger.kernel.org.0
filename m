Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694A11768BF
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 00:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727571AbgCBX7P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:59:15 -0500
Received: from mga03.intel.com ([134.134.136.65]:17170 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727448AbgCBX52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384820"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:24 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 65/66] KVM: nSVM: Advertise and enable NRIPS for L1 iff nrips is enabled
Date:   Mon,  2 Mar 2020 15:57:08 -0800
Message-Id: <20200302235709.27467-66-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set NRIPS in KVM capabilities if and only if nrips=true, which naturally
incorporates the boot_cpu_has() check, and set nrips_enabled only if the
KVM capability is enabled.

Note, previously KVM would set nrips_enabled based purely on userspace
input, but at worst that would cause KVM to propagate garbage into L1,
i.e. userspace would simply be hosing its VM.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/svm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8e39dcd3160d..32d9c13ec6b9 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1377,7 +1377,7 @@ static __init void svm_set_cpu_caps(void)
 	if (nested) {
 		kvm_cpu_cap_set(X86_FEATURE_SVM);
 
-		if (boot_cpu_has(X86_FEATURE_NRIPS))
+		if (nrips)
 			kvm_cpu_cap_set(X86_FEATURE_NRIPS);
 
 		if (npt_enabled)
@@ -6031,7 +6031,8 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
 				    boot_cpu_has(X86_FEATURE_XSAVES);
 
 	/* Update nrips enabled cache */
-	svm->nrips_enabled = !!guest_cpuid_has(&svm->vcpu, X86_FEATURE_NRIPS);
+	svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
+			     guest_cpuid_has(&svm->vcpu, X86_FEATURE_NRIPS);
 
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
-- 
2.24.1

