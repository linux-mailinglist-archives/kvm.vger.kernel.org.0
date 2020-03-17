Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24E911878D4
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 05:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgCQEz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 00:55:26 -0400
Received: from mga04.intel.com ([192.55.52.120]:34106 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726859AbgCQExP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 00:53:15 -0400
IronPort-SDR: iSqhsLFKSBewFCH4yOWqZNRnwd5/S9aJp3XxU05p2T6BLzw5IskpgLL0XPkyKKpjYHmF1jgtgE
 3OegPX1S49jA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 21:53:15 -0700
IronPort-SDR: X7RcKHBgDV7adjmDxpRKw+wRGXUiGZuxUNzpxDDoqJ0q7K8gKE1eukIbcpi1qlkhGcIN6EWMpN
 Qfrm7DjfzExA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="355252771"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2020 21:53:14 -0700
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
Subject: [PATCH v2 12/32] KVM: VMX: Drop redundant capability checks in low level INVVPID helpers
Date:   Mon, 16 Mar 2020 21:52:18 -0700
Message-Id: <20200317045238.30434-13-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200317045238.30434-1-sean.j.christopherson@intel.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the INVVPID capabilities checks from vpid_sync_vcpu_single() and
vpid_sync_vcpu_global() now that all callers ensure the INVVPID variant
is supported.  Note, in some cases the guarantee is provided in concert
with hardware_setup(), which enables VPID if and only if at least of
invvpid_single() or invvpid_global() is supported.

Drop the WARN_ON_ONCE() from vmx_flush_tlb() as vpid_sync_vcpu_single()
will trigger a WARN() on INVVPID failure, i.e. if SINGLE_CONTEXT isn't
supported.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/ops.h | 6 ++----
 arch/x86/kvm/vmx/vmx.h | 1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/ops.h b/arch/x86/kvm/vmx/ops.h
index 39122699cfeb..aa1aab52971a 100644
--- a/arch/x86/kvm/vmx/ops.h
+++ b/arch/x86/kvm/vmx/ops.h
@@ -258,14 +258,12 @@ static inline void vpid_sync_vcpu_single(int vpid)
 	if (vpid == 0)
 		return;
 
-	if (cpu_has_vmx_invvpid_single())
-		__invvpid(VMX_VPID_EXTENT_SINGLE_CONTEXT, vpid, 0);
+	__invvpid(VMX_VPID_EXTENT_SINGLE_CONTEXT, vpid, 0);
 }
 
 static inline void vpid_sync_vcpu_global(void)
 {
-	if (cpu_has_vmx_invvpid_global())
-		__invvpid(VMX_VPID_EXTENT_ALL_CONTEXT, 0, 0);
+	__invvpid(VMX_VPID_EXTENT_ALL_CONTEXT, 0, 0);
 }
 
 static inline void vpid_sync_context(int vpid)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index d6d67b816ebe..3770ae111e6a 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -537,7 +537,6 @@ static inline void vmx_flush_tlb(struct kvm_vcpu *vcpu, bool invalidate_gpa)
 			if (cpu_has_vmx_invvpid_global()) {
 				vpid_sync_vcpu_global();
 			} else {
-				WARN_ON_ONCE(!cpu_has_vmx_invvpid_single());
 				vpid_sync_vcpu_single(vmx->vpid);
 				vpid_sync_vcpu_single(vmx->nested.vpid02);
 			}
-- 
2.24.1

