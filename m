Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20E11A8EBF
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 00:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633620AbgDNWsI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 18:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729551AbgDNWsH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 18:48:07 -0400
Received: from mail-vk1-xa49.google.com (mail-vk1-xa49.google.com [IPv6:2607:f8b0:4864:20::a49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA36C061A0C
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 15:48:05 -0700 (PDT)
Received: by mail-vk1-xa49.google.com with SMTP id c139so892215vke.5
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 15:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=O140dz1UM5P9qq9rzXqnDmO1pLCKTxlVE6xQq25XpnA=;
        b=dV6tEKoK/TbFqoV0FugtBkLa5SUTVSPbeaUZgSTk77Cb92gAz+B2KjYl4dwQ3yeB6D
         4JnZyJLBFfWj8KHWnXzvomTV5p5Yhgi85TQZtb7gtk0XnsrzTd5UNbwi+WBgzQ8I1cdn
         ddliptXti2uhpdn8woxWAqXncCW2gm77tSMeyrFCpvV64E+O1QMdc3Ldo2UUqqWs8dbN
         LWtgCaO3y9D6qqxoyM5kdu/xhUAu3i4oCn2LYkEQdLAKXfSJXITy/FCqqmqp86IDjBAS
         xKfOy00vsGpdWGwYkjb24USYHoDrv9GykgXCqJwMh7dGOiS/r4Wd8ugyUEZLilYJRcf5
         mFug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=O140dz1UM5P9qq9rzXqnDmO1pLCKTxlVE6xQq25XpnA=;
        b=Sc+rknkxfCUltDaxiULJBFwlZ2SxHmRwsq/JrTXgm9ICUjlIEF3z1umz5BUJJUxWQJ
         4UOMidhkpEg8NLHFC1/51Bov9IZQmFcPEz5Z5qwAIcERomVg583FDx6pXU7LtU7KKace
         Nt+Pm8S3LQvpFO/o0ZY/+Y8O2OqNolhD9MiE7IrQldg2nI928wRKQv5GMnDGhCmd/vv+
         mbg2HTosP0l85bujFOEWJitAltBoGgWTINA1Op1uYR9btLUcKmSzO6tesZiLGPuKPMwh
         KihJ5zVBpcuc2gL3K899jL2R/BolKGsU1VMaZCIIryhpSHDgwtrlraxW2sZYzgiGmW87
         59vQ==
X-Gm-Message-State: AGi0PuZvJMAQVbZsI6d2wtvF1LsVA01if/OC4a1/A+nc2hDX04eFxxu1
        sW8BbaDCqZUQjwUoi8Yuf4LJeEad1/Nb0TKRZ9eqpQ+iohr9EcCbU1SWxBE9/awC1rqIe95UQMd
        gb0eewpTQlG4cQdaBkaREjFlXh5Tv6U2m91ZdsvgD+EWKvmsMl73kM7U90Q==
X-Google-Smtp-Source: APiQypIkMMqQAECOPkW/5WX4ViVLxfT7fkabSUggSOVD3Hy+iHpPaMwoyJ8YQWdXoene1XGtNX+CrAqoJug=
X-Received: by 2002:ac5:c3ce:: with SMTP id t14mr7320325vkk.60.1586904484376;
 Tue, 14 Apr 2020 15:48:04 -0700 (PDT)
Date:   Tue, 14 Apr 2020 22:47:45 +0000
Message-Id: <20200414224746.240324-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [PATCH v2] kvm: nVMX: reflect MTF VM-exits if injected by L1
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

Fixes: 5f3d45e7f282 ("kvm/x86: add support for MONITOR_TRAP_FLAG")
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 Parent commit: dbef2808af6c5 ("KVM: VMX: fix crash cleanup when KVM wasn't used")

 v1 => v2:
 - removed unused 'struct kvm_vcpu *vcpu' from the signature of helper
   function

 arch/x86/kvm/vmx/nested.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index cbc9ea2de28f9..0d1400fa1e224 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5533,6 +5533,23 @@ static bool nested_vmx_exit_handled_vmcs_access(struct kvm_vcpu *vcpu,
 	return 1 & (b >> (field & 7));
 }
 
+static bool nested_vmx_exit_handled_mtf(struct vmcs12 *vmcs12)
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
@@ -5633,7 +5650,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 	case EXIT_REASON_MWAIT_INSTRUCTION:
 		return nested_cpu_has(vmcs12, CPU_BASED_MWAIT_EXITING);
 	case EXIT_REASON_MONITOR_TRAP_FLAG:
-		return nested_cpu_has_mtf(vmcs12);
+		return nested_vmx_exit_handled_mtf(vmcs12);
 	case EXIT_REASON_MONITOR_INSTRUCTION:
 		return nested_cpu_has(vmcs12, CPU_BASED_MONITOR_EXITING);
 	case EXIT_REASON_PAUSE_INSTRUCTION:
-- 
2.26.0.110.g2183baf09c-goog

