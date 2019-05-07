Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED43166EC
	for <lists+kvm@lfdr.de>; Tue,  7 May 2019 17:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfEGPgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 May 2019 11:36:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:51040 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbfEGPgd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 May 2019 11:36:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 May 2019 08:36:32 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.181])
  by fmsmga006.fm.intel.com with ESMTP; 07 May 2019 08:36:32 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH 6/7] KVM: nVMX: Add helpers to identify shadowed VMCS fields
Date:   Tue,  7 May 2019 08:36:28 -0700
Message-Id: <20190507153629.3681-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190507153629.3681-1-sean.j.christopherson@intel.com>
References: <20190507153629.3681-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So that future optimizations related to shadowed fields don't need to
define their own switch statement.

Add a BUILD_BUG_ON() to ensure at least one of the types (RW vs RO) is
defined when including vmcs_shadow_fields.h (guess who keeps mistyping
SHADOW_FIELD_RO as SHADOW_FIELD_R0).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c             | 71 +++++++++++++++------------
 arch/x86/kvm/vmx/vmcs_shadow_fields.h |  4 ++
 2 files changed, 44 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 632e7e4324f3..279961a63db2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4415,6 +4415,29 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 	return nested_vmx_succeed(vcpu);
 }
 
+static bool is_shadow_field_rw(unsigned long field)
+{
+	switch (field) {
+#define SHADOW_FIELD_RW(x, y) case x:
+#include "vmcs_shadow_fields.h"
+		return true;
+	default:
+		break;
+	}
+	return false;
+}
+
+static bool is_shadow_field_ro(unsigned long field)
+{
+	switch (field) {
+#define SHADOW_FIELD_RO(x, y) case x:
+#include "vmcs_shadow_fields.h"
+		return true;
+	default:
+		break;
+	}
+	return false;
+}
 
 static int handle_vmwrite(struct kvm_vcpu *vcpu)
 {
@@ -4497,41 +4520,27 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 	vmcs12_write_any(vmcs12, field, offset, field_value);
 
 	/*
-	 * Do not track vmcs12 dirty-state if in guest-mode
-	 * as we actually dirty shadow vmcs12 instead of vmcs12.
+	 * Do not track vmcs12 dirty-state if in guest-mode as we actually
+	 * dirty shadow vmcs12 instead of vmcs12.  Fields that can be updated
+	 * by L1 without a vmexit are always updated in the vmcs02, i.e' don't
+	 * "dirty" vmcs12, all others go down the prepare_vmcs02() slow path.
 	 */
-	if (!is_guest_mode(vcpu)) {
-		switch (field) {
-#define SHADOW_FIELD_RW(x, y) case x:
-#include "vmcs_shadow_fields.h"
-			/*
-			 * The fields that can be updated by L1 without a vmexit are
-			 * always updated in the vmcs02, the others go down the slow
-			 * path of prepare_vmcs02.
-			 */
-			break;
+	if (!is_guest_mode(vcpu) && !is_shadow_field_rw(field)) {
+		/*
+		 * L1 can read these fields without exiting, ensure the
+		 * shadow VMCS is up-to-date.
+		 */
+		if (enable_shadow_vmcs && is_shadow_field_ro(field)) {
+			preempt_disable();
+			vmcs_load(vmx->vmcs01.shadow_vmcs);
 
-#define SHADOW_FIELD_RO(x, y) case x:
-#include "vmcs_shadow_fields.h"
-			/*
-			 * L1 can read these fields without exiting, ensure the
-			 * shadow VMCS is up-to-date.
-			 */
-			if (enable_shadow_vmcs) {
-				preempt_disable();
-				vmcs_load(vmx->vmcs01.shadow_vmcs);
+			__vmcs_writel(field, field_value);
 
-				__vmcs_writel(field, field_value);
-
-				vmcs_clear(vmx->vmcs01.shadow_vmcs);
-				vmcs_load(vmx->loaded_vmcs->vmcs);
-				preempt_enable();
-			}
-			/* fall through */
-		default:
-			vmx->nested.dirty_vmcs12 = true;
-			break;
+			vmcs_clear(vmx->vmcs01.shadow_vmcs);
+			vmcs_load(vmx->loaded_vmcs->vmcs);
+			preempt_enable();
 		}
+		vmx->nested.dirty_vmcs12 = true;
 	}
 
 	return nested_vmx_succeed(vcpu);
diff --git a/arch/x86/kvm/vmx/vmcs_shadow_fields.h b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
index 2cfa19ca158e..4cea018ba285 100644
--- a/arch/x86/kvm/vmx/vmcs_shadow_fields.h
+++ b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
@@ -1,3 +1,7 @@
+#if !defined(SHADOW_FIELD_RO) && !defined(SHADOW_FIELD_RW)
+BUILD_BUG_ON(1)
+#endif
+
 #ifndef SHADOW_FIELD_RO
 #define SHADOW_FIELD_RO(x, y)
 #endif
-- 
2.21.0

