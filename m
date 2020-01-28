Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1BF14B1BB
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 10:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgA1J1e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 04:27:34 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:35447 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgA1J1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 04:27:33 -0500
Received: by mail-pf1-f201.google.com with SMTP id q1so6539900pfg.2
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2020 01:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IHJ86SLN1S+rfmJdnpXkVr/JXWTzVlGoYtPFiC2EzRQ=;
        b=HShU2nYds5BLgnrEtuSkTv7LhPwkCIK0fartLoQDsKIr7bbDzn4nPvt2ZREGdAPx4H
         xeLtNOjjgn/C2Mh/lHskcrwZPLifquUdI28UypQItDJ/9QIqx2ixu0JuaBu0R5NxUF/F
         ViUC4yHnUr1yN1CkoNdVbp+zQlEYjmoOhMhcr9xO5l3gwKq+CnzioGlv+ybNC/PeJ7md
         gPd72QWNeg8kn6EAHTeEZKp0ad6fJw1i741In1NWGsWrAGkIeM2ATQkygIoD+Ajw8v8P
         stqc/zL4JNPyyMrTd+4gYmbnnsYzuXPYt+F95yLGzkQbiXKD1miNiutQsOJkP9wSvEEN
         k0MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IHJ86SLN1S+rfmJdnpXkVr/JXWTzVlGoYtPFiC2EzRQ=;
        b=H0mpGB46bNvUgP9BkpIJn5WjH3qzShL+O/QkmnR0Dv7uid3mUFjSmf96iaW77egik2
         1PF11adhm+xBjQZ6ML9F1aCOuEjKqsdV7iq6wT4yw46zY7zbEv3nNnzGl9+i76YHHuD2
         syU711nlKVW1XijQRqQQQ+1Ams8N/yTLNdL5StCoNmjEYPSfvg8f+FLGt7t0NteBapuo
         E0q130gC182F85JO/I61EMWNo8P7xtb2NSLt/HKrmrf5dZy5xGUzHRFk8wlEIk1wpSxt
         idyEZgxIlfu0B/N9d866aOvQsXCw4s8FCxO0M+ZkYJSkcETIN9ccJCbNKvRQtYnqT5q1
         li5g==
X-Gm-Message-State: APjAAAXIBLfL2ZgBdhwVZdqJx8OgvRHWiw2R+4mFOMiiT0LtCNmkxRc+
        J9EQb+bLcd8FkFwTpyyy1o68H/erG7iW/Tubb86PEWSqQRpDdLgV/S/1s2WFpHIR3alcKCrhXmJ
        qbd6vDECgLcaJZSNAgIo/AdoyLqrd+/HtB7i+P3GhBmcVu2RhtxL07u2EQQ==
X-Google-Smtp-Source: APXvYqx3N4YqPZwVJ1OaHJ0OfL2nhGkNKI5Np+iz9vF2WUbLlIqvIrNJeTcsXINtIESnsYgoJWcZ61ZWUpo=
X-Received: by 2002:a63:1c1d:: with SMTP id c29mr24245332pgc.14.1580203652850;
 Tue, 28 Jan 2020 01:27:32 -0800 (PST)
Date:   Tue, 28 Jan 2020 01:27:12 -0800
In-Reply-To: <20200128092715.69429-1-oupton@google.com>
Message-Id: <20200128092715.69429-3-oupton@google.com>
Mime-Version: 1.0
References: <20200128092715.69429-1-oupton@google.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH v2 2/5] KVM: nVMX: Handle pending #DB when injecting INIT VM-exit
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SDM 27.3.4 states that the 'pending debug exceptions' VMCS field will
be populated if a VM-exit caused by an INIT signal takes priority over a
debug-trap. Emulate this behavior when synthesizing an INIT signal
VM-exit into L1.

Fixes: 558b8d50dbff ("KVM: x86: Fix INIT signal handling in various CPU states")
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 95b3f4306ac2..aba16599ca69 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3572,6 +3572,27 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
 	nested_vmx_vmexit(vcpu, EXIT_REASON_EXCEPTION_NMI, intr_info, exit_qual);
 }
 
+static inline bool nested_vmx_check_pending_dbg(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.exception.nr == DB_VECTOR &&
+			vcpu->arch.exception.pending &&
+			vcpu->arch.exception.has_payload;
+}
+
+/*
+ * If a higher priority VM-exit is delivered before a debug-trap, hardware will
+ * set the 'pending debug exceptions' field appropriately for reinjection on the
+ * next VM-entry.
+ */
+static void nested_vmx_set_pending_dbg(struct kvm_vcpu *vcpu)
+{
+	vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS, vcpu->arch.exception.payload);
+	vcpu->arch.exception.has_payload = false;
+	vcpu->arch.exception.payload = 0;
+	vcpu->arch.exception.pending = false;
+	vcpu->arch.exception.injected = true;
+}
+
 static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -3584,6 +3605,8 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
 		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
 		if (block_nested_events)
 			return -EBUSY;
+		if (nested_vmx_check_pending_dbg(vcpu))
+			nested_vmx_set_pending_dbg(vcpu);
 		clear_bit(KVM_APIC_INIT, &apic->pending_events);
 		nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
 		return 0;
-- 
2.25.0.341.g760bfbb309-goog

