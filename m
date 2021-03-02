Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081A432B58E
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379958AbhCCHSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:18:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581572AbhCBS6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 13:58:53 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9319C061A31
        for <kvm@vger.kernel.org>; Tue,  2 Mar 2021 10:46:18 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id w33so4941906qte.11
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 10:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=YzlwVtABhaf0njzwLJlpB8Ftz/jd7QmttBOqgMTZo3A=;
        b=SeLHzq4Cio/vlmKsRAvq5kQSfdRJlLn2GUI+BOfuisLlBY/irxgPzGRMTMLdHWUzYv
         mP77Z3IyzSj9cPmibnzAFfsUJ72mWaSyRaH7I5JveSFb8ms5iarARutwqjjF3UmIEd0J
         DqMICED+eUvkTFxyB7raHdpfm953g3h3uSu3c+DeZ9ujlOfZnyUIhoZZOvMxQskn/jwY
         yaHIRjOujHbFpog+Fu+GL62qoel2BZHGqJ44cNAZUhjQI9R/XeN6qmC1Godp1LDwWpa7
         QUvud7WWztAvJFKXEA5nmSbaK0JwGCstMOWaWna3hwDbF/LOYXaadLdDrBHiuwELxbhJ
         JaAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=YzlwVtABhaf0njzwLJlpB8Ftz/jd7QmttBOqgMTZo3A=;
        b=qtSXwue9w3ou9ySGTu0eSlgT41JLxL1iIQZWIPIzdXvC82iqfQ7q6sqQRd3CSCJNJ9
         krwPB8pSYrIueCzmw2isqiGxpzZmtc9NC/KThpEOb+K8jLmSOYaR6pz2VtH0brqdipIq
         XQ/OOcVGeZM5kC9bD4E7kFjepBTFGn8NS2rPAS/ayP9uqxs8dq5Myc3MV+nPcRdD6H1H
         qczKzTFs1vX16aEf/KyF5T5xS1B6rlbKRjsxyW/EPWwWa+jnVS8KLQ+x0XTPG24x3fBQ
         2kiyPWDtbPRgPbSxfIlmibDcOTe7lo2+djOeC3bnpY7mGsVC4kPUeLrPlOOd+znjaD3v
         /7Uw==
X-Gm-Message-State: AOAM530zv6K1dmjqCQGyfS3SLwsTsiNSbRorDczS4h7n/0XvAe7tAyQu
        9vfZPyt6Nj5MfFlvg7Wzoqs+w/5WzcQ=
X-Google-Smtp-Source: ABdhPJzq1ZpQne4ImjhHgZA5rgE+d1F20qlPL09XKkXjdXZFxxMHkllbyy3mJ1z0hMVCHHwDEAKxHx4GtV8=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:805d:6324:3372:6183])
 (user=seanjc job=sendgmr) by 2002:a05:6214:2262:: with SMTP id
 gs2mr5093265qvb.32.1614710778040; Tue, 02 Mar 2021 10:46:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  2 Mar 2021 10:45:38 -0800
In-Reply-To: <20210302184540.2829328-1-seanjc@google.com>
Message-Id: <20210302184540.2829328-14-seanjc@google.com>
Mime-Version: 1.0
References: <20210302184540.2829328-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 13/15] KVM: x86/mmu: Unexport MMU load/unload functions
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
index 45fe97b3b25d..86432d6a4092 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4827,7 +4827,6 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 out:
 	return r;
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_load);
 
 void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 {
@@ -4836,7 +4835,6 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
 	WARN_ON(VALID_PAGE(vcpu->arch.guest_mmu.root_hpa));
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_unload);
 
 static bool need_remote_flush(u64 old, u64 new)
 {
-- 
2.30.1.766.gb4fecdf3b7-goog

