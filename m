Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101D0301138
	for <lists+kvm@lfdr.de>; Sat, 23 Jan 2021 00:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbhAVXya (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 18:54:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbhAVXwd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 18:52:33 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EA9C061797
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 15:51:03 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id j24so5025618qvg.8
        for <kvm@vger.kernel.org>; Fri, 22 Jan 2021 15:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=vis1EBkMtVJzC1inZD1OMmTzA1+2z+PuDDfmwsUE9QI=;
        b=gDr4O4h28mPFdd+ZZdK1XAb3VtFI+oGGvNONZW582anW+VjJLm42e5NuH5SNAM45xb
         Pj9GLYb/xlP/Vj9f2Jw2ONUaJ+4JQERAh/7T5+vz2zNiqxY/sALKVM5CusVcxFyDT3/y
         LJqUEbg/n90iEGiuD4cUAkLqG8fOTCMWnb4Nx7XcJeoETZNF1ccdqT20ry6bo0sfAyFa
         ElKDo1nIx3dOtuq5aoATXw7LhDKeDTz99ZtBAfBk/vkkzvWcv9qiT2Gyo9uqkehBZ/ek
         SxYt0lbmaFMdPNVN8UlOKNfhL3e2sIy1dqSR/vuX8D1fh0Gsa4yUItxzKpNhJrDJEP3R
         0SMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=vis1EBkMtVJzC1inZD1OMmTzA1+2z+PuDDfmwsUE9QI=;
        b=AvUYWJKihryrQNj7DdHzuHHqkcF/HhU3uCK82BY5mZDSNXJ4wsgAeQwnSvoCZE/SVS
         ZWS7nFyP3cTgWqtz1jAA7KYlL8TllNnJ0a9l3S93jNKR6Ek1kxeQS7trcKVBf0APirVy
         frjljhgLkyh1Ejdg3gP+O9vu1gidKVnbDtrO4t9Fja3n8+F1tUV9vt47si5ULTnKEovG
         fhVFAochOvAkYmVxJsydyrqvZYa6ZR7Gs6mFRzT1M7THm+2TpkJzf3fuORpvHlsSBQIG
         nya8PvWWnMpB6N8ihbi1yJSxAxPV//HMmRE/BGDYhj4SEq8QxSuCl7ccv8qVqarcg0FD
         Z6Ng==
X-Gm-Message-State: AOAM532Rs/pAQaNkf+r0Mc75fNkpuvec9irYGHJVX/G4oHcfcUOvXEpS
        x9JksAM4CsZkYCTBc8dtpjv/EuBJGao=
X-Google-Smtp-Source: ABdhPJzBBbroBZ04dz4g477SZCi+wa0A1PU9Lb5Y7vFKnW6C2/fcCrXdQgs559dhJ2QuE1HbvLewaiGMCPI=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:ad4:4ae2:: with SMTP id cp2mr7070738qvb.50.1611359462829;
 Fri, 22 Jan 2021 15:51:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 22 Jan 2021 15:50:48 -0800
In-Reply-To: <20210122235049.3107620-1-seanjc@google.com>
Message-Id: <20210122235049.3107620-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210122235049.3107620-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
Subject: [PATCH 2/3] KVM: x86: Revert "KVM: x86: Mark GPRs dirty when written"
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Revert the dirty/available tracking of GPRs now that KVM copies the GPRs
to the GHCB on any post-VMGEXIT VMRUN, even if a GPR is not dirty.  Per
commit de3cd117ed2f ("KVM: x86: Omit caching logic for always-available
GPRs"), tracking for GPRs noticeably impacts KVM's code footprint.

This reverts commit 1c04d8c986567c27c56c05205dceadc92efb14ff.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/kvm_cache_regs.h | 51 +++++++++++++++++------------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index f15bc16de07c..a889563ad02d 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -9,31 +9,6 @@
 	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
 	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD | X86_CR4_FSGSBASE)
 
-static inline bool kvm_register_is_available(struct kvm_vcpu *vcpu,
-					     enum kvm_reg reg)
-{
-	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
-}
-
-static inline bool kvm_register_is_dirty(struct kvm_vcpu *vcpu,
-					 enum kvm_reg reg)
-{
-	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
-}
-
-static inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
-					       enum kvm_reg reg)
-{
-	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
-}
-
-static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
-					   enum kvm_reg reg)
-{
-	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
-	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
-}
-
 #define BUILD_KVM_GPR_ACCESSORS(lname, uname)				      \
 static __always_inline unsigned long kvm_##lname##_read(struct kvm_vcpu *vcpu)\
 {									      \
@@ -43,7 +18,6 @@ static __always_inline void kvm_##lname##_write(struct kvm_vcpu *vcpu,	      \
 						unsigned long val)	      \
 {									      \
 	vcpu->arch.regs[VCPU_REGS_##uname] = val;			      \
-	kvm_register_mark_dirty(vcpu, VCPU_REGS_##uname);		      \
 }
 BUILD_KVM_GPR_ACCESSORS(rax, RAX)
 BUILD_KVM_GPR_ACCESSORS(rbx, RBX)
@@ -63,6 +37,31 @@ BUILD_KVM_GPR_ACCESSORS(r14, R14)
 BUILD_KVM_GPR_ACCESSORS(r15, R15)
 #endif
 
+static inline bool kvm_register_is_available(struct kvm_vcpu *vcpu,
+					     enum kvm_reg reg)
+{
+	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
+}
+
+static inline bool kvm_register_is_dirty(struct kvm_vcpu *vcpu,
+					 enum kvm_reg reg)
+{
+	return test_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
+}
+
+static inline void kvm_register_mark_available(struct kvm_vcpu *vcpu,
+					       enum kvm_reg reg)
+{
+	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
+}
+
+static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
+					   enum kvm_reg reg)
+{
+	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
+	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
+}
+
 static inline unsigned long kvm_register_read(struct kvm_vcpu *vcpu, int reg)
 {
 	if (WARN_ON_ONCE((unsigned int)reg >= NR_VCPU_REGS))
-- 
2.30.0.280.ga3ce27912f-goog

