Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 146B718DA64
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgCTVbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:31:14 -0400
Received: from mga04.intel.com ([192.55.52.120]:59224 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727229AbgCTV2u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:28:50 -0400
IronPort-SDR: Gppo1ytxkjacjiTjAjoqw8ul8kAl85N2DSN1kQj+mPerY9kG+kjsetxWlLxFLgbp95afE6cVCa
 5vIivvj/rNwQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:28:48 -0700
IronPort-SDR: PHaEuMOD1su58ecGI78AobGnSJ59cUR1Bx8C3se7yaCcDGg/fbUX3B+LGNO2eAed3KT2LfhP2B
 woAIpLuHZZyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224440"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:28:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v3 11/37] KVM: VMX: Handle INVVPID fallback logic in vpid_sync_vcpu_addr()
Date:   Fri, 20 Mar 2020 14:28:07 -0700
Message-Id: <20200320212833.3507-12-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Directly invoke vpid_sync_context() to do a global INVVPID when the
individual address variant is not supported instead of deferring such
behavior to the caller.  This allows for additional consolidation of
code as the logic is basically identical to the emulation of the
individual address variant in handle_invvpid().

No functional change intended.

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/ops.h | 12 +++++-------
 arch/x86/kvm/vmx/vmx.c |  3 +--
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/ops.h b/arch/x86/kvm/vmx/ops.h
index dd7ab61bfcc1..39122699cfeb 100644
--- a/arch/x86/kvm/vmx/ops.h
+++ b/arch/x86/kvm/vmx/ops.h
@@ -276,17 +276,15 @@ static inline void vpid_sync_context(int vpid)
 		vpid_sync_vcpu_global();
 }
 
-static inline bool vpid_sync_vcpu_addr(int vpid, gva_t addr)
+static inline void vpid_sync_vcpu_addr(int vpid, gva_t addr)
 {
 	if (vpid == 0)
-		return true;
+		return;
 
-	if (cpu_has_vmx_invvpid_individual_addr()) {
+	if (cpu_has_vmx_invvpid_individual_addr())
 		__invvpid(VMX_VPID_EXTENT_INDIVIDUAL_ADDR, vpid, addr);
-		return true;
-	}
-
-	return false;
+	else
+		vpid_sync_context(vpid);
 }
 
 static inline void ept_sync_global(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ba49323a89d8..ba24bbda2c12 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2853,8 +2853,7 @@ static void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
 {
 	int vpid = to_vmx(vcpu)->vpid;
 
-	if (!vpid_sync_vcpu_addr(vpid, addr))
-		vpid_sync_context(vpid);
+	vpid_sync_vcpu_addr(vpid, addr);
 
 	/*
 	 * If VPIDs are not supported or enabled, then the above is a no-op.
-- 
2.24.1

