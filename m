Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A94369E38
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244646AbhDXAzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244653AbhDXAyR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:54:17 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEDDC061756
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:22 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id q5-20020a05620a0c85b02902e004d74d8cso15763858qki.16
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=zLhT1Olw4w4A/z5QqS68fw+vGniyRMY+4zsyez+hxb8=;
        b=X/6DdF5y6jftvjVQXXyHqgICC6xuwcEmdwIrGhWdI/3AA4IADr9ArY/5Jq5XZ1oAbh
         8ixRUMsqk+4xeYynvXcrkDb/B7vOYJ8NT8LbkbswduKbml2KNWufSoE4F5+dhO9tgo+4
         eEnW+bD9DdCzvHbuoWRej9KL9UubtQnnmdTqkXDPVnZdJ0ExfO3inh1btsCY8JPmFdss
         /Br/Yx/m3eSEniFgzGCeQjGfy0EVCzsQoGTby5iGu9Gq7LyXI5YEKxJBa7FFYbiE45lE
         C4xmu9fk9NSLHc3st2IBYkyRxnuVdD5vu4ipAlWJ7to5vKrsQ/A3XZDOjxjHsILaSUdl
         eFBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=zLhT1Olw4w4A/z5QqS68fw+vGniyRMY+4zsyez+hxb8=;
        b=M29kO/0buHhY4XZOdkFgPVkwi/lpYhrf3kN59F9+lfwo4uU2ndQBM9t3Bho2jntan+
         e6pMCMTsBylW2GdvQ/9peenemHdqKmB51rJWj36ZDSMC8MvOBBAqHRYsVmWPRZ8cdeU1
         Bg/nxfnyZrRx0I0BmtKlowa8REIyZR5FzI9iLf+UOfcfZ2lCMdG3J0xNIdT2oV79JVM1
         Loqleek4v3sh1Ip8crjjxxeOtr7eqISyYSE4bS2VucCqRTXLW9ur4PU4yUWCBlnuBkNv
         g2EPFGxDrJ3rimgD/WVN88fr7jj8+AFkusWPTByQAAiDyYSugprG1UTKF75KMS65Xr/M
         S4Gg==
X-Gm-Message-State: AOAM532JXW6fdEHFLTWIBHL2F8UbLwZLK+d1SdJE23//W814KhuOcOAT
        PfoPRfbI/TINyuGJ0CEDr9FXj1PN7DY=
X-Google-Smtp-Source: ABdhPJxREhJpQW8HpLyftkLk1ST20DVpT+NSBMDlbnY/lcznsryFA5sIGYAngsDKucwdsBX/xRGDO9Tn/8U=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a0c:ec4b:: with SMTP id n11mr7248572qvq.6.1619225302028;
 Fri, 23 Apr 2021 17:48:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:39 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-38-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 37/43] KVM: nVMX: Remove obsolete MSR bitmap refresh at nested transitions
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

Drop unnecessary MSR bitmap updates during nested transitions, as L1's
APIC_BASE MSR is not modified by the standard VM-Enter/VM-Exit flows,
and L2's MSR bitmap is managed separately.  In the unlikely event that L1
is pathological and loads APIC_BASE via the VM-Exit load list, KVM will
handle updating the bitmap in its normal WRMSR flows.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 6 ------
 arch/x86/kvm/vmx/vmx.c    | 2 +-
 arch/x86/kvm/vmx/vmx.h    | 1 -
 3 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f811bb7f2dc3..9dcdf158a405 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4283,9 +4283,6 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	kvm_set_dr(vcpu, 7, 0x400);
 	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
 
-	if (cpu_has_vmx_msr_bitmap())
-		vmx_update_msr_bitmap(vcpu);
-
 	if (nested_vmx_load_msr(vcpu, vmcs12->vm_exit_msr_load_addr,
 				vmcs12->vm_exit_msr_load_count))
 		nested_vmx_abort(vcpu, VMX_ABORT_LOAD_HOST_MSR_FAIL);
@@ -4364,9 +4361,6 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 
 	kvm_mmu_reset_context(vcpu);
 
-	if (cpu_has_vmx_msr_bitmap())
-		vmx_update_msr_bitmap(vcpu);
-
 	/*
 	 * This nasty bit of open coding is a compromise between blindly
 	 * loading L1's MSRs using the exit load lists (incorrect emulation
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index acfb87f30979..45a013631f63 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3984,7 +3984,7 @@ static void vmx_update_msr_bitmap_x2apic(struct kvm_vcpu *vcpu, u8 mode)
 	}
 }
 
-void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu)
+static void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u8 mode = vmx_msr_bitmap_mode(vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 1283ad0e592d..e46df3253a21 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -380,7 +380,6 @@ void __vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
 u64 construct_eptp(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 
 void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
-void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu);
 bool vmx_nmi_blocked(struct kvm_vcpu *vcpu);
 bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu);
 bool vmx_get_nmi_mask(struct kvm_vcpu *vcpu);
-- 
2.31.1.498.g6c1eba8ee3d-goog

