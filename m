Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47ECC3B0C23
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhFVSCm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbhFVSCN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:02:13 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F5FC0611FB
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:54 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id t144-20020a3746960000b02903ad9c5e94baso18997564qka.16
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=kQmirOy+CFqTjeIK11GchlgwLFqpy8qC6wsHe7x5/AA=;
        b=BbZKxsWTRk7inBXx75lpGni6nxDEt9V69Z1I82wmBj1CJBLiwZnnQ15qPdWYB1SVmx
         xMTpnaMrP70Hy/PeAhw5CkiwfLW6JHcZxDu9IrNI6uIyykS7A98rsHFirRIQ4p1RYYA0
         2ZsEZmQW+/uXKyTuuGHMGlk7ix6xBKMC0R/Ae88m9zkCnU4Bpjvh6j1B54mo+d8iACG1
         7CMJ5a0058s+16l76A5N2QQmPTPUkUl80KfB9NA6eGfnh4WUEYufhj/jtyPwKZjnKFrU
         XGr891d+dQbNWW3yoi7kCJUpneLv3phrDiakH7Ik3G7qVXZ82Xyf5xo1fSLa4xoKj9TT
         laBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=kQmirOy+CFqTjeIK11GchlgwLFqpy8qC6wsHe7x5/AA=;
        b=t3+Clcbg6D6wq6JQdAKujREpd7w7e9nl+FCb1yqHS//q8PSiIw4g6vEaQNQd6e06mo
         8Yn8GwahkqNbEV8v4KPm9lbycsl0zqun2L19CiAzFHqCYum2YnoWhb9zsAivKtMUTBK3
         D3rLBtqctyI8IAiHD8QzYQBPFiottkKU3/R0lQI6niOYdpG2E0mTIB+w9K73SSqAJBnu
         IMS+2a77cP3nnRajEeHclNEQ6dZkHl7Mmys2Chw9Wf7DTj3x94FU91Udf/EvjHQP9ktg
         kvHgPd5nbdYWI46EC79o8hRcwIgTCZGNOYz3gGbdGtCYurNgIyFuBWxGtQ4MzXiiuX5P
         Qrsw==
X-Gm-Message-State: AOAM533eptLvGD3PKPqBxD+V1z4z+KirRaSldWR043rd8azPA5s89/eC
        wblO7LJLUVt5s+6fPz6UCg55hPwtG2I=
X-Google-Smtp-Source: ABdhPJzcaI2hEhNLBOEWavqTVhbiNePzyQoDyK2+oJIAFALaSPLGw+VmD8l1PRjxtXdd/cBuy0ZTLcHl7IY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:2d55:: with SMTP id s21mr3501239ybe.338.1624384733636;
 Tue, 22 Jun 2021 10:58:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:10 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-26-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 25/54] KVM: x86/mmu: Add helpers to query mmu_role bits
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add helpers via a builder macro for all mmu_role bits that track a CR0,
CR4, or EFER bit.  Digging out the bits manually is not exactly the most
readable code.

Future commits will switch to using mmu_role instead of vCPU state to
configure the MMU, i.e. there are about to be a large number of users.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 21 +++++++++++++++++++++
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7bc5b1a8fca5..be95595b30c7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -206,6 +206,27 @@ BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, la57, X86_CR4_LA57);
 BUILD_MMU_ROLE_REGS_ACCESSOR(efer, nx, EFER_NX);
 BUILD_MMU_ROLE_REGS_ACCESSOR(efer, lma, EFER_LMA);
 
+/*
+ * The MMU itself (with a valid role) is the single source of truth for the
+ * MMU.  Do not use the regs used to build the MMU/role, nor the vCPU.  The
+ * regs don't account for dependencies, e.g. clearing CR4 bits if CR0.PG=1,
+ * and the vCPU may be incorrect/irrelevant.
+ */
+#define BUILD_MMU_ROLE_ACCESSOR(base_or_ext, reg, name)		\
+static inline bool is_##reg##_##name(struct kvm_mmu *mmu)	\
+{								\
+	return !!(mmu->mmu_role. base_or_ext . reg##_##name);	\
+}
+BUILD_MMU_ROLE_ACCESSOR(ext,  cr0, pg);
+BUILD_MMU_ROLE_ACCESSOR(base, cr0, wp);
+BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pse);
+BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pae);
+BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smep);
+BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smap);
+BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pke);
+BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, la57);
+BUILD_MMU_ROLE_ACCESSOR(base, efer, nx);
+
 struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_role_regs regs = {
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index b632606a87d6..5cf36eb96ee2 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -471,7 +471,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 
 error:
 	errcode |= write_fault | user_fault;
-	if (fetch_fault && (mmu->nx || mmu->mmu_role.ext.cr4_smep))
+	if (fetch_fault && (mmu->nx || is_cr4_smep(mmu)))
 		errcode |= PFERR_FETCH_MASK;
 
 	walker->fault.vector = PF_VECTOR;
-- 
2.32.0.288.g62a8d224e6-goog

