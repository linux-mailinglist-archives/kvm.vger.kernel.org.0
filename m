Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A061E32DEED
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 02:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhCEBLs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 20:11:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbhCEBLp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 20:11:45 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24073C061762
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 17:11:42 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id j4so631055ybt.23
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 17:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=GwLtnjUHvhPN+SdKpQLX9+PZpDkmPsCXyyolIntRT8Q=;
        b=YTBApRYdKmN5TNo2/zDb8jt3g5J1OBP5RrcLnOmgvYROgZ4nw8D8iOcoMM+/fowvvH
         5drldgzi8cHBpIZBd4LVlVyaxh4Pp8juYwQcp8n6dgBmujr7WNRlSFBkBW94xJbrMZog
         TaMVEIvM/KOUmFeBjCjNQn4vLefwOERlwzVEBiVccgYHiPzUc3k41wddWXP5FlDoiI4z
         l94BaTRP4ri/jZ7z68m0OEI9j2WcIMjYRLdpEojOzOcqweXDVAI7vVN/JTcmgpk7ly6/
         ry34aQMWAi98LSrjjvuO2YWMuJvuF6LtU8mS5Uj+5yAUU695Fb4NzGlNfxwizElDYcsa
         kRCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=GwLtnjUHvhPN+SdKpQLX9+PZpDkmPsCXyyolIntRT8Q=;
        b=nMRlCiIKL1rBRpGBt3Qx19mL/6D2UHz55IUBxsL6oNHKoU8CtORe4SW4lMh4HPvOx3
         j3p24wKVoEas0hoTAZAVnMSNgYEcs2pBWjyRl96NH43umO9AoTYLpVnh1GkjRCISpKwD
         pGhwXPl4fIdEwiBruAW7/D6P0QYa2wc9h9Bd26khPNcx6xjYOrP2M2PS5fre4uTkKWLQ
         2GUIsuDu3o657AQfri7/wx2YObnN6ySOH6us1YN8bsGg+SGWoQlveuY6UZhOYz3dmZ7c
         Mg3MnsxdATBR3EuhMdrZq/oHqvtwWEHENlmctebU+J4ZzwWlJLIzmjzg9I8fwoKWLwXK
         7KRQ==
X-Gm-Message-State: AOAM533NPmQjJiUa+/PsraujCjVkP50WhkbY0y9NWuFOpA4wubmLLWLP
        /tv7kLasy1kZXOAsDcVWzTHmnLNHlCM=
X-Google-Smtp-Source: ABdhPJwhGY3VsDk0phWFsY+dbxEMztlaHmwM2ag+WGOvqjCSG0YIdrtM0Q+LclZIX/JU85vbBBawg175iE4=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a25:d6d5:: with SMTP id n204mr10136397ybg.22.1614906701379;
 Thu, 04 Mar 2021 17:11:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Mar 2021 17:10:59 -0800
In-Reply-To: <20210305011101.3597423-1-seanjc@google.com>
Message-Id: <20210305011101.3597423-16-seanjc@google.com>
Mime-Version: 1.0
References: <20210305011101.3597423-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v2 15/17] KVM: x86/mmu: Unexport MMU load/unload functions
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unexport the MMU load and unload helpers now that they are no longer
used (incorrectly) in vendor code.

Opportunistically move the kvm_mmu_sync_roots() declaration into mmu.h,
it should not be exposed to vendor code.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ---
 arch/x86/kvm/mmu.h              | 4 ++++
 arch/x86/kvm/mmu/mmu.c          | 2 --
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6db60ea8ee5b..2da6c9f5935a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1592,9 +1592,6 @@ void kvm_update_dr7(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn);
 void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
-int kvm_mmu_load(struct kvm_vcpu *vcpu);
-void kvm_mmu_unload(struct kvm_vcpu *vcpu);
-void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu);
 void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			ulong roots_to_free);
 gpa_t translate_nested_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 72b0f66073dc..67e8c7c7a6ce 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -74,6 +74,10 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu);
 int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 				u64 fault_address, char *insn, int insn_len);
 
+int kvm_mmu_load(struct kvm_vcpu *vcpu);
+void kvm_mmu_unload(struct kvm_vcpu *vcpu);
+void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu);
+
 static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
 {
 	if (likely(vcpu->arch.mmu->root_hpa != INVALID_PAGE))
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index fa1aca21f6eb..4f66ca0f5f68 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4859,7 +4859,6 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 out:
 	return r;
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_load);
 
 void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 {
@@ -4868,7 +4867,6 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
 	WARN_ON(VALID_PAGE(vcpu->arch.guest_mmu.root_hpa));
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_unload);
 
 static bool need_remote_flush(u64 old, u64 new)
 {
-- 
2.30.1.766.gb4fecdf3b7-goog

