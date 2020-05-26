Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D1F1A8E1A
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 23:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391834AbgDNVy4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 17:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732193AbgDNVyq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 17:54:46 -0400
Received: from mail-ua1-x94a.google.com (mail-ua1-x94a.google.com [IPv6:2607:f8b0:4864:20::94a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B019C061A0C
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 14:47:10 -0700 (PDT)
Received: by mail-ua1-x94a.google.com with SMTP id g12so841802uan.22
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 14:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=IZmFXnLAEGBjvKAtlq8tf/GD5WNVE7Cu3UKUCseMIAA=;
        b=PJxiAuBsMJgNUx3/ZpgI+ihFX8N6d3rUuIl/Ub9+rbZMqDfz8nj0Bhuu3YnaPp5Nlg
         buBai79DSiSeaztIrT0yzARIH+lv4I4qT6YYX/8P25FCFncGPComsa3CoVVSBgMbKgi1
         8EbMHx99Wq/DW8rOxtA6W2RQPk0Jqi3hpYFh94F+vWcm1+Qk+u7/Bf0VgUBu+5EwUwjy
         H838617HRm7pz8btx3jZOYWDTjBMIPAVoM52oPlL8c/TMm1oJ/3FYYpwwGQAGTArkVKg
         Q78OLXsSO3XqXE4k4mn0yDdVbLlGuN1ttCEjaUmnNnlZe/1TyxWC0bmNDi3XlRmYp+/v
         ARGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=IZmFXnLAEGBjvKAtlq8tf/GD5WNVE7Cu3UKUCseMIAA=;
        b=XfrC8IDZBbuiuXqF+ZQq8sRSE/w+hIY+18SgAgVps9r8DTweJxaWoNOcd5gsMtaUtI
         urzNbGo9dH1Oos7jJMga/cCPiZdiFXv6pkMfPOKRgmpFvtzt1uThRw49bDyEfXqMfn0u
         CsBxtZvmzNydIPg+wFbs4Ld3A+PA1/8AsSX08L9H0umGU/UJwpaORAmbMN314txkGYjS
         JL49ASHd1Axfl52G6uf0Cbz2AhCKJHSSl7ghk/o+vWfjbbEk0UCpMqKxvhXlL2iLNdbD
         mv4MwmMG/DEtLLj3RwJntVagDvS6+WBfJVtkTjhqD45mNS/bpj/9VRsLHjNALbYwA1pP
         Uo6A==
X-Gm-Message-State: AGi0PuaTEtTZWuLahHlzFboLfB+GhvQ61CxJQyI17NdlK+id/upi8W2y
        EgxegCzdTUhZb9SDzFvSVNDAXyowb38fBNVu91vUY9eOGwZeKC/elNA08Woq2opVJmTQa+2jtl1
        Jb0UcjtjP81XoF9JLEY1kuoEraUAVCkmEdVDhog7Kfaeo6Sp3Fq0b8lvB2g==
X-Google-Smtp-Source: APiQypJIEr1XTtypyYJ3aCilDKTSScPOJaEl588n1OW/jJ7FGEeRt2qjvJ8CDRGlX/Ee7e8MOcCLwzG7j3E=
X-Received: by 2002:ab0:4e96:: with SMTP id l22mr2130594uah.88.1586900829324;
 Tue, 14 Apr 2020 14:47:09 -0700 (PDT)
Date:   Tue, 14 Apr 2020 21:46:34 +0000
Message-Id: <20200414214634.126508-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [PATCH] kvm: nVMX: reflect MTF VM-exits if injected by L1
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to SDM 26.6.2, it is possible to inject an MTF VM-exit via the
VM-entry interruption-information field regardless of the 'monitor trap
flag' VM-execution control. KVM appropriately copies the VM-entry
interruption-information field from vmcs12 to vmcs02. However, if L1
has not set the 'monitor trap flag' VM-execution control, KVM fails to
reflect the subsequent MTF VM-exit into L1.

Fix this by consulting the VM-entry interruption-information field of
vmcs12 to determine if L1 has injected the MTF VM-exit. If so, reflect
the exit, regardless of the 'monitor trap flag' VM-execution control.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=207177
Fixes: 5f3d45e7f282 ("kvm/x86: add support for MONITOR_TRAP_FLAG")
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 Parent commit: dbef2808af6c5 ("KVM: VMX: fix crash cleanup when KVM wasn't used")
 arch/x86/kvm/vmx/nested.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index cbc9ea2de28f9..a11ffcb917e70 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5533,6 +5533,24 @@ static bool nested_vmx_exit_handled_vmcs_access(struct kvm_vcpu *vcpu,
 	return 1 & (b >> (field & 7));
 }
 
+static bool nested_vmx_exit_handled_mtf(struct kvm_vcpu *vcpu,
+					struct vmcs12 *vmcs12)
+{
+	u32 entry_intr_info = vmcs12->vm_entry_intr_info_field;
+
+	if (nested_cpu_has_mtf(vmcs12))
+		return true;
+
+	/*
+	 * An MTF VM-exit may be injected into the guest by setting the
+	 * interruption-type to 7 (other event) and the vector field to 0. Such
+	 * is the case regardless of the 'monitor trap flag' VM-execution
+	 * control.
+	 */
+	return entry_intr_info == (INTR_INFO_VALID_MASK
+				   | INTR_TYPE_OTHER_EVENT);
+}
+
 /*
  * Return 1 if we should exit from L2 to L1 to handle an exit, or 0 if we
  * should handle it ourselves in L0 (and then continue L2). Only call this
@@ -5633,7 +5651,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 	case EXIT_REASON_MWAIT_INSTRUCTION:
 		return nested_cpu_has(vmcs12, CPU_BASED_MWAIT_EXITING);
 	case EXIT_REASON_MONITOR_TRAP_FLAG:
-		return nested_cpu_has_mtf(vmcs12);
+		return nested_vmx_exit_handled_mtf(vcpu, vmcs12);
 	case EXIT_REASON_MONITOR_INSTRUCTION:
 		return nested_cpu_has(vmcs12, CPU_BASED_MONITOR_EXITING);
 	case EXIT_REASON_PAUSE_INSTRUCTION:
-- 
2.26.0.110.g2183baf09c-goog

