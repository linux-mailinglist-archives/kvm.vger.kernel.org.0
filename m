Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 011DA1555DF
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 11:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgBGKgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 05:36:35 -0500
Received: from mail-pj1-f74.google.com ([209.85.216.74]:53333 "EHLO
        mail-pj1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727289AbgBGKgf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 05:36:35 -0500
Received: by mail-pj1-f74.google.com with SMTP id h6so1052308pju.3
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 02:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=k7kvp2Q+X5KKtfSI8p1ZPpCKg5nn6Yhdzbm1PfKGtkY=;
        b=o25Kgm1kmvf6F3mjEiIhA6Pl4jji6+z1cg7UB4hFy4w8nVJ2tZlS+Pq6zICFwIXm11
         TxHs/MWmO+HlU18zXGwMbTzPdBQKoHvBsCyw0lf8J17+n1gQDOCMCDRrvfKldu5Z4q0m
         uNcyN7jATMxzFMkfNW0KMDup7fB0jAAmxka3pen8ERi1xpBIBoBxApNNRarMCPH2jRxr
         TNsjIR4yPHEFpzC/S7LTF3+SBAsQln+sZ0mVECY3caf1te3/oHFirT9pGic1/yU4RiXz
         KqE0TK6EXg+hm6Ky6F1QzPxJKACrZzKCcSXouJ6jwtch7/001jaOEjMVuO2bFnj5KUqo
         9iNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=k7kvp2Q+X5KKtfSI8p1ZPpCKg5nn6Yhdzbm1PfKGtkY=;
        b=N/ZgP+0MkteY9bdN9pln8qf7PtJk/BWXK/1vTZiLJNTUpVChc1z5GnWGNRxri8AgNE
         zIkH0iqWMUw/LabyMQlodFZn+mjZ8ju45U5YqcmMuGRqPGAGnnCO7bwxHqREkhTgVvf8
         qUeREkndlCPb1+CzISKmdVuN3bNk7CfoBWOqhbRkMG2XU2KG5oBGHmfDNyuSOUG7mhtt
         nrua4tY/WMRTyIZYa8WPccomypsxvWosE29F+um9WJm6iOUWzjnKmYXHXzWny+WHJrl0
         AsooeaRBekCjjK+cU/DtZ/bs4kJMEl8TNnhH31CXbWut0U2l4gMAqnk2Ag+VhDRAmlyW
         DtrA==
X-Gm-Message-State: APjAAAUVcEYR3diAzfLgOv3DgPFFFRKoRkqqH1RLYqiaC4QtF27z0RXA
        t+Memkf9cSBby4Oi2hU41/FtrzHk8WucSHxcIJs5TYrYr0fMcULBm+RkGCMx3tGQeEUl/+6eA4G
        Aa76i00e2toY+hPAlVxj3NuyeJChunLXUpLXJiF0VL4MQQ5gupXuOACAR1g==
X-Google-Smtp-Source: APXvYqwbgewb6DSXLk2Ht/rqknjGlGwBTjE7AjqfGaEEzJcv/T0jPL0snVAg7XB1JDxR6vPX0aegW07hmcg=
X-Received: by 2002:a63:7145:: with SMTP id b5mr8577044pgn.409.1581071792911;
 Fri, 07 Feb 2020 02:36:32 -0800 (PST)
Date:   Fri,  7 Feb 2020 02:36:05 -0800
In-Reply-To: <20200207103608.110305-1-oupton@google.com>
Message-Id: <20200207103608.110305-3-oupton@google.com>
Mime-Version: 1.0
References: <20200207103608.110305-1-oupton@google.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH v3 2/5] KVM: nVMX: Handle pending #DB when injecting INIT VM-exit
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

Fixes: 4b9852f4f389 ("KVM: x86: Fix INIT signal handling in various CPU states")
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 657c2eda357c..1586aaae3a6f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3575,6 +3575,33 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
 	nested_vmx_vmexit(vcpu, EXIT_REASON_EXCEPTION_NMI, intr_info, exit_qual);
 }
 
+/*
+ * Returns true if a debug trap is pending delivery.
+ *
+ * In KVM, debug traps bear an exception payload. As such, the class of a #DB
+ * exception may be inferred from the presence of an exception payload.
+ */
+static inline bool vmx_pending_dbg_trap(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.exception.pending &&
+			vcpu->arch.exception.nr == DB_VECTOR &&
+			vcpu->arch.exception.payload;
+}
+
+/*
+ * Certain VM-exits set the 'pending debug exceptions' field to indicate a
+ * recognized #DB (data or single-step) that has yet to be delivered. Since KVM
+ * represents these debug traps with a payload that is said to be compatible
+ * with the 'pending debug exceptions' field, write the payload to the VMCS
+ * field if a VM-exit is delivered before the debug trap.
+ */
+static void nested_vmx_update_pending_dbg(struct kvm_vcpu *vcpu)
+{
+	if (vmx_pending_dbg_trap(vcpu))
+		vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
+			    vcpu->arch.exception.payload);
+}
+
 static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -3587,6 +3614,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
 		test_bit(KVM_APIC_INIT, &apic->pending_events)) {
 		if (block_nested_events)
 			return -EBUSY;
+		nested_vmx_update_pending_dbg(vcpu);
 		clear_bit(KVM_APIC_INIT, &apic->pending_events);
 		nested_vmx_vmexit(vcpu, EXIT_REASON_INIT_SIGNAL, 0, 0);
 		return 0;
-- 
2.25.0.341.g760bfbb309-goog

