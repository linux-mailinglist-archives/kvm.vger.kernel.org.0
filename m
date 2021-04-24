Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E71369E3F
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244738AbhDXAz5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244178AbhDXAy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:54:28 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F82C061240
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:34 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z8-20020a2566480000b02904e0f6f67f42so26643529ybm.15
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=RNPvYWQZyWoudwJX+eiT9Tudy0ylNLdSxXPRHk/Dbl0=;
        b=gvCmi5O1ZkvTuWybFhyFe2JFoeB2S3lx+dxD9bnbYmI4BtiRAXulvIvRLIb/qhztor
         XYM3ah8EuggNJMBqkEnOL8z5JU/JkV2e/WvUsByF8YMjiUXz5S8gnKAXCrW/d80N83TJ
         0BP/p3Mj205ml68DMUpifOGSSzKtHocxUkiCu9CEMeDxpI9BuX7UDxqCM0GZ2GNzt8e/
         P6EzLZVEZo/hKCEiygpszaZOUJ09Irn1sK9cGRfSqlPPka0isWhzrjORHmp/9fCBgpFU
         Jve999MtScRsD+38Bw7QbC9XSNrL5P45NGUxOAGgy7bc4Q0JFgXkDgNcCWjNPSTkzJDQ
         VMbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=RNPvYWQZyWoudwJX+eiT9Tudy0ylNLdSxXPRHk/Dbl0=;
        b=WFlKr07uh+hpJ+yLXmAvS8MLA4c1leiRoQxTfp2f+KlUGB4aEbwSwWIqr8Fq/L4yEe
         2i57yzGHaTj/baYG+DyQoLPasMbEKxogQLrM53Qu5VgSSxpaZHVdPIVexxKr5vqFT6Jd
         iOziVGF0pVPxLNDZkPfMZgTJJ95c+MlmhFpV91KczvX+h6eMnVpurT2655VCebCsHYEB
         JLZ5+2JGtlc5FsDQ+SVmrkI/+RT2++lAh9W/3GydIqxd+2UZw/bm5kuXnMISyEr8hBfV
         rks5p5QDeb6IJm6gPAYoxNBmwgAnj8doe5gSnxOjCDVX35cr2ktdOr0CuKv7qMHGsI4c
         wQZw==
X-Gm-Message-State: AOAM532z5JLfSj+VBe4vMRizYVH7jSeUvj9PJcpleje65TXxmHGOgtI+
        1q0Sq0TTAHDDwYMZhxRxOkQB2shfaho=
X-Google-Smtp-Source: ABdhPJycBkWcCmvduvpUbK4zX4dHRlAPZHp3qDiadndfD/wpwn3q9fnD6IYaRZyl/4WrKd8UXKNUdK7eOYU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:cfca:: with SMTP id f193mr9202657ybg.44.1619225313306;
 Fri, 23 Apr 2021 17:48:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:44 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-43-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 42/43] KVM: VMX: Drop VMWRITEs to zero fields at vCPU RESET
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't waste time writing zeros via VMWRITE during vCPU RESET, the VMCS
is zero allocated.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 78d17adce7e6..74258ba4832a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4427,13 +4427,6 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	}
 
 	if (kvm_vcpu_apicv_active(&vmx->vcpu)) {
-		vmcs_write64(EOI_EXIT_BITMAP0, 0);
-		vmcs_write64(EOI_EXIT_BITMAP1, 0);
-		vmcs_write64(EOI_EXIT_BITMAP2, 0);
-		vmcs_write64(EOI_EXIT_BITMAP3, 0);
-
-		vmcs_write16(GUEST_INTR_STATUS, 0);
-
 		vmcs_write16(POSTED_INTR_NV, POSTED_INTR_VECTOR);
 		vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->pi_desc)));
 	}
@@ -4444,23 +4437,9 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmx->ple_window_dirty = true;
 	}
 
-	vmcs_write32(PAGE_FAULT_ERROR_CODE_MASK, 0);
-	vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, 0);
-	vmcs_write32(CR3_TARGET_COUNT, 0);           /* 22.2.1 */
-
-	vmcs_write16(HOST_FS_SELECTOR, 0);            /* 22.2.4 */
-	vmcs_write16(HOST_GS_SELECTOR, 0);            /* 22.2.4 */
 	vmx_set_constant_host_state(vmx);
-	vmcs_writel(HOST_FS_BASE, 0); /* 22.2.4 */
-	vmcs_writel(HOST_GS_BASE, 0); /* 22.2.4 */
 
-	if (cpu_has_vmx_vmfunc())
-		vmcs_write64(VM_FUNCTION_CONTROL, 0);
-
-	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 0);
-	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, 0);
 	vmcs_write64(VM_EXIT_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.host.val));
-	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, 0);
 	vmcs_write64(VM_ENTRY_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.guest.val));
 
 	if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT)
@@ -4493,7 +4472,6 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		memset(&vmx->pt_desc, 0, sizeof(vmx->pt_desc));
 		/* Bit[6~0] are forced to 1, writes are ignored. */
 		vmx->pt_desc.guest.output_mask = 0x7F;
-		vmcs_write64(GUEST_IA32_RTIT_CTL, 0);
 	}
 
 	vmx_setup_uret_msrs(vmx);
@@ -4536,13 +4514,6 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmcs_write32(GUEST_LDTR_LIMIT, 0xffff);
 	vmcs_write32(GUEST_LDTR_AR_BYTES, 0x00082);
 
-	if (!init_event) {
-		vmcs_write32(GUEST_SYSENTER_CS, 0);
-		vmcs_writel(GUEST_SYSENTER_ESP, 0);
-		vmcs_writel(GUEST_SYSENTER_EIP, 0);
-		vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
-	}
-
 	vmcs_writel(GUEST_GDTR_BASE, 0);
 	vmcs_write32(GUEST_GDTR_LIMIT, 0xffff);
 
-- 
2.31.1.498.g6c1eba8ee3d-goog

