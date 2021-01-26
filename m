Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDEF3042A4
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 16:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392775AbhAZP3i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 10:29:38 -0500
Received: from mga05.intel.com ([192.55.52.43]:12999 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727090AbhAZJdW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 04:33:22 -0500
IronPort-SDR: W7IIWJusAkY4sDT4diAOVRzYY4II83HurFwmIRls4AGX9SrfQpWLgtsq8L7zaPvFPDGe2akV8C
 jyaqsAkttoFA==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="264698014"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="264698014"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 01:32:06 -0800
IronPort-SDR: +4EKa+o4NF1qLqY9SPTdB+vb7OClm/yElxzbQbk/9Gays7ldmAiQjdupThyKv2g3nC2CHyMYhU
 bZ6Gm4OD/x4A==
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="577747855"
Received: from ravivisw-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.124.51])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 01:32:01 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v3 17/27] KVM: x86: Export kvm_mmu_gva_to_gpa_{read,write}() for SGX (VMX)
Date:   Tue, 26 Jan 2021 22:31:38 +1300
Message-Id: <ba48d9929037ef17120044ca1d893ad4360ca1ff.1611634586.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1611634586.git.kai.huang@intel.com>
References: <cover.1611634586.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Export the gva_to_gpa() helpers for use by SGX virtualization when
executing ENCLS[ECREATE] and ENCLS[EINIT] on behalf of the guest.
To execute ECREATE and EINIT, KVM must obtain the GPA of the target
Secure Enclave Control Structure (SECS) in order to get its
corresponding HVA.

Because the SECS must reside in the Enclave Page Cache (EPC), copying
the SECS's data to a host-controlled buffer via existing exported
helpers is not a viable option as the EPC is not readable or writable
by the kernel.

SGX virtualization will also use gva_to_gpa() to obtain HVAs for
non-EPC pages in order to pass user pointers directly to ECREATE and
EINIT, which avoids having to copy pages worth of data into the kernel.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a8969a6dd06..5ca7b181a3ae 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5891,6 +5891,7 @@ gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu, gva_t gva,
 	u32 access = (kvm_x86_ops.get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
 	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_gva_to_gpa_read);
 
  gpa_t kvm_mmu_gva_to_gpa_fetch(struct kvm_vcpu *vcpu, gva_t gva,
 				struct x86_exception *exception)
@@ -5907,6 +5908,7 @@ gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcpu, gva_t gva,
 	access |= PFERR_WRITE_MASK;
 	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_gva_to_gpa_write);
 
 /* uses this to access any guest's mapped memory without checking CPL */
 gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
-- 
2.29.2

