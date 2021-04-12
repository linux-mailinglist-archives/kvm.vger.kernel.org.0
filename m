Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 711C135B93B
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 06:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhDLEWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 00:22:12 -0400
Received: from mga07.intel.com ([134.134.136.100]:53368 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229865AbhDLEWM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Apr 2021 00:22:12 -0400
IronPort-SDR: OivJrluwVec8F0ZSL8xH0bhXcNQnliwHZGgRTXuiwdddxh5aUqyeyISw2yPt8owCFjO/tZfFbu
 cns8a1bpmZAQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9951"; a="258083739"
X-IronPort-AV: E=Sophos;i="5.82,214,1613462400"; 
   d="scan'208";a="258083739"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2021 21:21:54 -0700
IronPort-SDR: /1PtQ6lEtz+xxvmcOCDOQDRSMQuDhdXF6/1T50uOup//IaOOCEK9xP2KV5G3/Gf+7tb4nPOTmy
 Ts5N/gtzoE9g==
X-IronPort-AV: E=Sophos;i="5.82,214,1613462400"; 
   d="scan'208";a="521030346"
Received: from rutujajo-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.194.203])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2021 21:21:51 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, bp@alien8.de,
        jarkko@kernel.org, dave.hansen@intel.com, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        Kai Huang <kai.huang@intel.com>
Subject: [PATCH v5 01/11] KVM: x86: Export kvm_mmu_gva_to_gpa_{read,write}() for SGX (VMX)
Date:   Mon, 12 Apr 2021 16:21:33 +1200
Message-Id: <02f37708321bcdfaa2f9d41c8478affa6e84b04d.1618196135.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1618196135.git.kai.huang@intel.com>
References: <cover.1618196135.git.kai.huang@intel.com>
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
index 16fb39503296..b9600540508e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6007,6 +6007,7 @@ gpa_t kvm_mmu_gva_to_gpa_read(struct kvm_vcpu *vcpu, gva_t gva,
 	u32 access = (static_call(kvm_x86_get_cpl)(vcpu) == 3) ? PFERR_USER_MASK : 0;
 	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_gva_to_gpa_read);
 
  gpa_t kvm_mmu_gva_to_gpa_fetch(struct kvm_vcpu *vcpu, gva_t gva,
 				struct x86_exception *exception)
@@ -6023,6 +6024,7 @@ gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcpu, gva_t gva,
 	access |= PFERR_WRITE_MASK;
 	return vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, access, exception);
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_gva_to_gpa_write);
 
 /* uses this to access any guest's mapped memory without checking CPL */
 gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
-- 
2.30.2

