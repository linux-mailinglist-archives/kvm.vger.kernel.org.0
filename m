Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 339A134167C
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 08:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234424AbhCSHYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 03:24:33 -0400
Received: from mga12.intel.com ([192.55.52.136]:44045 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234338AbhCSHYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 03:24:00 -0400
IronPort-SDR: lCPJvSA/xP09BD7mO1STJ+lBRrA5YRZNtmVJQqLglibrD6kloLIdDcT+IB6LZS/w8vepcJY4ld
 ojxoPt4gps/g==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="169143671"
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="169143671"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 00:24:00 -0700
IronPort-SDR: Fcqq+fniPhenlhk5eqgER+QdjlKOr5WDZf7DfRcRQB1wLRNEy5CLFJTsIw1JGn0oI4r9hl6rCx
 Lxbesx+vO4sg==
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="413409809"
Received: from dlmeisen-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.165])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 00:23:55 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, seanjc@google.com, jarkko@kernel.org,
        luto@kernel.org, dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, Kai Huang <kai.huang@intel.com>
Subject: [PATCH v3 15/25] KVM: x86: Export kvm_mmu_gva_to_gpa_{read,write}() for SGX (VMX)
Date:   Fri, 19 Mar 2021 20:23:39 +1300
Message-Id: <2d499bb53ec1811c60497fa15f1ee5830324d189.1616136308.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1616136307.git.kai.huang@intel.com>
References: <cover.1616136307.git.kai.huang@intel.com>
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
index 47e021bdcc94..d2da5abcf395 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5959,6 +5959,7 @@ gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu, gva_t gva,
 	u32 access = (static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0;
 	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_gva_to_gpa_read);
 
  gpa_t kvm_mmu_gva_to_gpa_fetch(struct kvm_vcpu *vcpu, gva_t gva,
 				struct x86_exception *exception)
@@ -5975,6 +5976,7 @@ gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcpu, gva_t gva,
 	access |= PFERR_WRITE_MASK;
 	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_gva_to_gpa_write);
 
 /* uses this to access any guest's mapped memory without checking CPL */
 gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
-- 
2.30.2

