Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D1F447FB7
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239801AbhKHMsi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:48:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239825AbhKHMsV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 07:48:21 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B015DC061746;
        Mon,  8 Nov 2021 04:45:36 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id r28so15053976pga.0;
        Mon, 08 Nov 2021 04:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ds5oAZuKgLL1xXWixp9LhgaW7VT7IJj7unEHWE7U3AA=;
        b=lyKdXi1LAjXqUBVHalP53qi4+ETLcq5PAJ4GFZ1LzlOPGPpqLC5O3NART0Ot2AZf9J
         tPoYgIWjfjsGZ+V4Kej4yrY0cUUdgClfcEsWrqlMdmrfPHMxyNOzQSQsd+lWG9z79vjU
         v8PZWeQmmGfTo6AiZtOzNHgGPNKivghpOfW+PNp0uJ6TKOzdnLdIdxg5qNL5707wAgc+
         Pu7/7FwETwHzFlJXFsCc5j6zK/KEFHTOB4jkrfDjgVwRT5TUaf1BZZJOF/jkYH7ZAliW
         2No7GURKjYhcGSjNrdnaObknT/IqGwR7sMf8I2o13ck+TSPcI/g+zFWRVEiHHs9zkzig
         NRdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ds5oAZuKgLL1xXWixp9LhgaW7VT7IJj7unEHWE7U3AA=;
        b=SSMQnLXjkmYQPimnaIkTS5swpL4IMe20E354VvP81J+fO5gi6r8HWJC8AoAjqm9EgM
         TUYa5t/Utv3+fW2VFaNKIPjQ9rc82PMXLHP5IlzD7QeWlbrM5A9sRitP1iONOJxRO/qH
         YHiHNJr9D5Vd/9o3X67JfCcWahbz0LXFNF6DSLuA5R91U8PKb222h/1jMM3bCDLmi3PN
         lziPDYs9/HHe54ymbmZhFS41YzRGha/LR2BzpmIvPoE69fEOoqvUzR3MSFUXKsbTcMhJ
         bnS3ThxdgDyiIIYYe9JfklKlsmHq+KtG00yE3bb9xRlsEyTb3/lnKe6Z0Tljpp+a/CrR
         /o8g==
X-Gm-Message-State: AOAM532VSPRPZB/UsGvESVw2mDTZPRhDX0IEVvk534CWGQHMiKoDUB7o
        RYM+LUTn9iCWDrlpj5GqVTWWUvlF+Lo=
X-Google-Smtp-Source: ABdhPJy9KW5BcL4gCTCvaGKr1La4X3SLYlC6REo6VDucO+mKTFycxjA50D3cfXvv13u6RDHa+nrOdg==
X-Received: by 2002:a63:3543:: with SMTP id c64mr28825166pga.443.1636375536060;
        Mon, 08 Nov 2021 04:45:36 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id b8sm15424651pfi.103.2021.11.08.04.45.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 04:45:35 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 15/15] KVM: nVMX: Always write vmcs.GUEST_CR3 during nested VM-Exit
Date:   Mon,  8 Nov 2021 20:44:07 +0800
Message-Id: <20211108124407.12187-16-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211108124407.12187-1-jiangshanlai@gmail.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

For VM-Enter, vmcs.GUEST_CR3 and vcpu->arch.cr3 are synced and it is
better to mark VCPU_EXREG_CR3 available rather than dirty to reduce a
redundant vmwrite(GUEST_CR3) in vmx_load_mmu_pgd().

But nested_vmx_load_cr3() is also served for VM-Exit which doesn't
set vmcs.GUEST_CR3.

This patch moves writing to vmcs.GUEST_CR3 into nested_vmx_load_cr3()
for both nested VM-Eneter/Exit and use kvm_register_mark_available().

This patch doesn't cause any extra writing to vmcs.GUEST_CR3 and if
userspace is modifying CR3 with KVM_SET_SREGS later, the dirty info
for VCPU_EXREG_CR3 would be set for next writing to vmcs.GUEST_CR3
and no update will be lost.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/vmx/nested.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index ee5a68c2ea3a..4ddd4b1b0503 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1133,8 +1133,28 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 	if (!nested_ept)
 		kvm_mmu_new_pgd(vcpu, cr3);
 
+	/*
+	 * Immediately write vmcs.GUEST_CR3 when changing vcpu->arch.cr3.
+	 *
+	 * VCPU_EXREG_CR3 is marked available rather than dirty because
+	 * vcpu->arch.cr3 and vmcs.GUEST_CR3 are synced when enable_ept and
+	 * vmcs.GUEST_CR3 is irrelevant to vcpu->arch.cr3 when !enable_ept.
+	 *
+	 * For VM-Enter case, it will be propagated to vmcs12 on nested
+	 * VM-Exit, which can occur without actually running L2 and thus
+	 * without hitting vmx_load_mmu_pgd(), e.g. if L1 is entering L2 with
+	 * vmcs12.GUEST_ACTIVITYSTATE=HLT, in which case KVM will intercept
+	 * the transition to HLT instead of running L2.
+	 *
+	 * For VM-Exit case, it is likely that vmcs.GUEST_CR3 == cr3 here, but
+	 * L1 may set HOST_CR3 to a value other than its CR3 before VM-Entry,
+	 * so we just update it unconditionally.
+	 */
+	if (enable_ept)
+		vmcs_writel(GUEST_CR3, cr3);
+
 	vcpu->arch.cr3 = cr3;
-	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
+	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
 
 	/* Re-initialize the MMU, e.g. to pick up CR4 MMU role changes. */
 	kvm_init_mmu(vcpu);
@@ -2600,16 +2620,6 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 				from_vmentry, entry_failure_code))
 		return -EINVAL;
 
-	/*
-	 * Immediately write vmcs02.GUEST_CR3.  It will be propagated to vmcs12
-	 * on nested VM-Exit, which can occur without actually running L2 and
-	 * thus without hitting vmx_load_mmu_pgd(), e.g. if L1 is entering L2 with
-	 * vmcs12.GUEST_ACTIVITYSTATE=HLT, in which case KVM will intercept the
-	 * transition to HLT instead of running L2.
-	 */
-	if (enable_ept)
-		vmcs_writel(GUEST_CR3, vmcs12->guest_cr3);
-
 	/* Late preparation of GUEST_PDPTRs now that EFER and CRs are set. */
 	if (load_guest_pdptrs_vmcs12 && nested_cpu_has_ept(vmcs12) &&
 	    is_pae_paging(vcpu)) {
-- 
2.19.1.6.gb485710b

