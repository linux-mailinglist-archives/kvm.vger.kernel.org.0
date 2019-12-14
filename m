Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D918A11EF3E
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 01:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfLNAeL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 19:34:11 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:45892 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfLNAeL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 19:34:11 -0500
Received: by mail-pj1-f73.google.com with SMTP id f62so640368pjg.12
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 16:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=zK9Y4nx0Rj/ARKOrR+GneC6HR8RpVxfAwxr1k/suMxQ=;
        b=dGlbP5YJCTlQwkz63/EM/Xh64ZL03NpqjvX4hLy0TyEAL1uzjNi0qhjL9/ZAzpYuSW
         uvs2j5rmZetl8F7/qNmL62ho2BCQKbUjK68bbhcomU7u/4gfypDF1Mo/mIYGu71weaLJ
         8nmWzaJUnt5TdKncGrefEoNuAGR3ezD1EeOc9ofzmSAlnXNvWQIXaTxRHnyADkoxsCPv
         plVvl/9/7RURTAZrxkSQrEHPKtJP8qBc06MCOatg5CNdEyWC3v3k0eckOkErOlO0Zhpy
         kTwxlNrqugvyjkXglZ4ZOlWeURaIcRjvMvxqhPDD9i95ZaqQ9IJ/kLIVan4OhvKjzVWh
         cjDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=zK9Y4nx0Rj/ARKOrR+GneC6HR8RpVxfAwxr1k/suMxQ=;
        b=laqk1lCTrP+gRv7uz0iSfno+0cLqaK4pDeTdyWF/rjtZPATS5qbroWbvttHkN++JmD
         Qs0y4jFNeRfcTg1NigYf9s99Dj1QSSAoIJQQinIoFsdQ9rQtIo31D+Vd1oAeLuNxYyhk
         M4pqmuDU0NwuV/9NiP17LtKhrsWwHx5AdVlRJr4FZA4mcNBdeixmfGLuCeZD+0SMiJvB
         azfHQKtxl+hY7+ohEPuuVIoNhFb2AUAK/SAYY2ploCLwX2PNVdg7RZpVSLzlQe4v/jRe
         9BQrGunXp2aIXi3dXspOlByOEyzuPQ6OsJfEnyGUl3ZV7TEU0jZGInEyqHMjZQ9abWvN
         dTTQ==
X-Gm-Message-State: APjAAAW9aq2Zutu93c33ndsB8qqnNXdKLMqRf/Jg3N5HY8o19aiA0cvb
        wJZxtaImtezPaqJcWPNRnw9ooomcrCqG9ao+jtLVUgFQIvRUyVSSSx857FXHEBy5RjOfmTbfrnp
        2daHdY2ROB/kz+qkKyhoB0+KPy+q9q099BStjjqUaoweB0Q1lKbpyqKgK2Q==
X-Google-Smtp-Source: APXvYqwvK+qjeL33M1SlGRaGvZbj7HIQN/w09HixIxWeFsSObMPL1SVMYciHFve4t597E/WLHS9zdvPPvrE=
X-Received: by 2002:a65:6842:: with SMTP id q2mr2676955pgt.345.1576283649114;
 Fri, 13 Dec 2019 16:34:09 -0800 (PST)
Date:   Fri, 13 Dec 2019 16:33:58 -0800
Message-Id: <20191214003358.169496-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH] KVM: nVMX: WARN on failure to set IA32_PERF_GLOBAL_CTRL
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Oliver Upton <oupton@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Writes to MSR_CORE_PERF_GLOBAL_CONTROL should never fail if the VM-exit
and VM-entry controls are exposed to L1. Promote the checks to perform a
full WARN if kvm_set_msr() fails and remove the now unused macro
SET_MSR_OR_WARN().

Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4aea7d304beb..fb502c62ee94 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -28,16 +28,6 @@ module_param(nested_early_check, bool, S_IRUGO);
 	failed;								\
 })
 
-#define SET_MSR_OR_WARN(vcpu, idx, data)				\
-({									\
-	bool failed = kvm_set_msr(vcpu, idx, data);			\
-	if (failed)							\
-		pr_warn_ratelimited(					\
-				"%s cannot write MSR (0x%x, 0x%llx)\n",	\
-				__func__, idx, data);			\
-	failed;								\
-})
-
 /*
  * Hyper-V requires all of these, so mark them as supported even though
  * they are just treated the same as all-context.
@@ -2550,8 +2540,8 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		vcpu->arch.walk_mmu->inject_page_fault = vmx_inject_page_fault_nested;
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
-	    SET_MSR_OR_WARN(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
-			    vmcs12->guest_ia32_perf_global_ctrl))
+	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
+				     vmcs12->guest_ia32_perf_global_ctrl)))
 		return -EINVAL;
 
 	kvm_rsp_write(vcpu, vmcs12->guest_rsp);
@@ -3999,8 +3989,8 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 		vcpu->arch.pat = vmcs12->host_ia32_pat;
 	}
 	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
-		SET_MSR_OR_WARN(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
-				vmcs12->host_ia32_perf_global_ctrl);
+		WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
+					 vmcs12->host_ia32_perf_global_ctrl));
 
 	/* Set L1 segment info according to Intel SDM
 	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
-- 
2.24.1.735.g03f4e72817-goog

