Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F188230C521
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 17:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbhBBQNJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 11:13:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29475 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235959AbhBBQLr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Feb 2021 11:11:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612282220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sYZzkVHR2ls3xvESHEyOkdDA3MfonApqwRfCSseBrz8=;
        b=TEIG5nGSvINMLGX9FsAbfccw2isTBm7Hhji9uAxq6ExChBCRrNzg5/b1X+Bh7hvGGZjCwh
        4oM7XymLhG0ElJreeKM9hjg+vhG6m0qIupiatm7VwRs9lt8WIuXYIiSeyyXYEPMfMb9F8j
        92Euuv3LvDVUy9Nzwm4xvw60em3xHVE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-Zc6Hv7T2NGaAwYtEqRBMcA-1; Tue, 02 Feb 2021 11:10:16 -0500
X-MC-Unique: Zc6Hv7T2NGaAwYtEqRBMcA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9DF581621;
        Tue,  2 Feb 2021 16:10:15 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F4B25C22B;
        Tue,  2 Feb 2021 16:10:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jbaron@akamai.com
Subject: [PATCH] KVM: move EXIT_FASTPATH_REENTER_GUEST to common code
Date:   Tue,  2 Feb 2021 11:10:14 -0500
Message-Id: <20210202161014.67093-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that KVM is using static calls, calling vmx_vcpu_run and
vmx_sync_pir_to_irr does not incur anymore the cost of a
retpoline.

Therefore there is no need anymore to handle EXIT_FASTPATH_REENTER_GUEST
in vendor code.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 19 +------------------
 arch/x86/kvm/x86.c     | 17 ++++++++++++++---
 arch/x86/kvm/x86.h     |  1 -
 3 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cf0c397dc3eb..2e304ba06d16 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6711,11 +6711,9 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 
 static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
-	fastpath_t exit_fastpath;
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4;
 
-reenter_guest:
 	/* Record the guest's net vcpu time for enforced NMI injections. */
 	if (unlikely(!enable_vnmi &&
 		     vmx->loaded_vmcs->soft_vnmi_blocked))
@@ -6865,22 +6863,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (is_guest_mode(vcpu))
 		return EXIT_FASTPATH_NONE;
 
-	exit_fastpath = vmx_exit_handlers_fastpath(vcpu);
-	if (exit_fastpath == EXIT_FASTPATH_REENTER_GUEST) {
-		if (!kvm_vcpu_exit_request(vcpu)) {
-			/*
-			 * FIXME: this goto should be a loop in vcpu_enter_guest,
-			 * but it would incur the cost of a retpoline for now.
-			 * Revisit once static calls are available.
-			 */
-			if (vcpu->arch.apicv_active)
-				vmx_sync_pir_to_irr(vcpu);
-			goto reenter_guest;
-		}
-		exit_fastpath = EXIT_FASTPATH_EXIT_HANDLED;
-	}
-
-	return exit_fastpath;
+	return vmx_exit_handlers_fastpath(vcpu);
 }
 
 static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 14fb8a138ec3..b5f2d290ef3c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1796,12 +1796,11 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_wrmsr);
 
-bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
+static inline bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
 {
 	return vcpu->mode == EXITING_GUEST_MODE || kvm_request_pending(vcpu) ||
 		xfer_to_guest_mode_work_pending();
 }
-EXPORT_SYMBOL_GPL(kvm_vcpu_exit_request);
 
 /*
  * The fast path for frequent and performance sensitive wrmsr emulation,
@@ -9044,7 +9043,19 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_RELOAD;
 	}
 
-	exit_fastpath = static_call(kvm_x86_run)(vcpu);
+	for (;;) {
+		exit_fastpath = static_call(kvm_x86_run)(vcpu);
+		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
+			break;
+
+                if (unlikely(kvm_vcpu_exit_request(vcpu))) {
+			exit_fastpath = EXIT_FASTPATH_EXIT_HANDLED;
+			break;
+		}
+
+		if (vcpu->arch.apicv_active)
+			static_call(kvm_x86_sync_pir_to_irr)(vcpu);
+        }
 
 	/*
 	 * Do this here before restoring debug registers on the host.  And
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 5f7c224f4bf2..cc652a348acc 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -395,7 +395,6 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 int kvm_spec_ctrl_test_value(u64 value);
 bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
-bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu);
 int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 			      struct x86_exception *e);
 int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva);
-- 
2.26.2

