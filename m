Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAE02369E06
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244551AbhDXAuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244358AbhDXAsh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:48:37 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CBFC06135C
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:35 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id s143-20020a3745950000b029028274263008so15786968qka.9
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=6E3V7dLtDnT6jSCZRct8iCP/xNw6ab9zCOnAN/OMqYU=;
        b=ZC/juWTzgPj3AcF9d+wyZqpPFeBLvHw4FDrSGn7bhpRpEcDqLIziz4xu657jnfnqMX
         HCdhIRnqRJtgDS14/dqjE66dfy6QwP409nw+08HpkekQWt7se+uUsZTRkyCN+ykrpX++
         SgFaNKrEuUn7v/p/6+LFAGDafeIpgSMtb8CC8sDnkxTruy2sIVcGa3GY2jkyewF70Sft
         hv+9ncYGeLJnDD9DrQRDltD+OMERbLMxRSlObX+2RWuo4pTnxf9YFpANQKGPk+SVCvM7
         OincD5gPJ/9M2MpwT8wvifTgayci5MjW9X5rQgf3zzqA9yHg2nSERMSWF7WkXunxTEBz
         HGMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=6E3V7dLtDnT6jSCZRct8iCP/xNw6ab9zCOnAN/OMqYU=;
        b=KvRkKMRArG7AclpN560BR/1lVQUtD/WWAPLHNAxxWLYrUHPp8BeFCQXGIpeIMbLeLF
         gUWqeXItl5M25u/Lj/O4eKQfiHxnrtXhucOtRqo+QDO6zTtNwCJJzKwSCOD8SdGmwssP
         t8n1F7wg38KP5LdGHLDLSNAK1Gbn0ROTPdOyFGp8KpfmRs4CsU0V0V+wMccDr6wxB285
         QWqoqoSc/Q6t3LhFKBhPhQlEP1Lu1x2dFUcTJmymEJHt8Ql6D28SHPpFJFvA/g7sXKDs
         8E2ofjjuFsm6nsWZI6VrU6FDViiGIA9gJDIIRbySn4bxf5ka3vnHWOioqv8O/ZzZQUrq
         Y5Dg==
X-Gm-Message-State: AOAM532jHw0LbCADHXj57ogtNB4HVT6hH1xD+Z+ZywHDktbgjx4nz7Lb
        qr9JDRVrTyldd2axuD6C7Sc7G51c/TI=
X-Google-Smtp-Source: ABdhPJzGjVcWS5kWnrD4TQlNWKFu4tcBa7CTHMtb6IkBzS3H8pChLv9vqQHCRA9Hi0cnJGdo35D7XFM6eSo=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:ad4:4f84:: with SMTP id em4mr7384577qvb.26.1619225255197;
 Fri, 23 Apr 2021 17:47:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:18 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-17-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 16/43] KVM: VMX: Stuff vcpu->arch.apic_base directly at vCPU RESET
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

Write vcpu->arch.apic_base directly instead of bouncing through
kvm_set_apic_base().  This is a glorified nop, and is a step towards
cleaning up the mess that is local APIC creation.

When using an in-kernel APIC, kvm_create_lapic() explicitly sets
vcpu->arch.apic_base to MSR_IA32_APICBASE_ENABLE to avoid its own
kvm_lapic_set_base() call in kvm_lapic_reset() from triggering state
changes.  That call during RESET exists purely to set apic->base_address
to the default base value.  As a result, by the time VMX gets control,
the only missing piece is the BSP bit being set for the reset BSP.

For a userspace APIC, there are no side effects to process (for the APIC).

In both cases, the call to kvm_update_cpuid_runtime() is a nop because
the vCPU hasn't yet been exposed to userspace, i.e. there can't be any
CPUID entries.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 856aa44b17d5..fa14e9a74b96 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4490,7 +4490,6 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	struct msr_data apic_base_msr;
 	u32 eax, dummy;
 	u64 cr0;
 
@@ -4511,12 +4510,10 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_set_cr8(vcpu, 0);
 
 	if (!init_event) {
-		apic_base_msr.data = APIC_DEFAULT_PHYS_BASE |
-				     MSR_IA32_APICBASE_ENABLE;
+		vcpu->arch.apic_base = APIC_DEFAULT_PHYS_BASE |
+				       MSR_IA32_APICBASE_ENABLE;
 		if (kvm_vcpu_is_reset_bsp(vcpu))
-			apic_base_msr.data |= MSR_IA32_APICBASE_BSP;
-		apic_base_msr.host_initiated = true;
-		kvm_set_apic_base(vcpu, &apic_base_msr);
+			vcpu->arch.apic_base |= MSR_IA32_APICBASE_BSP;
 	}
 
 	vmx_segment_cache_clear(vmx);
-- 
2.31.1.498.g6c1eba8ee3d-goog

