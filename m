Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70AE03B0C2D
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbhFVSDQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232706AbhFVSCg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:02:36 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2758C061766
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:01 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 81-20020a370e540000b02903aacdbd70b7so18999528qko.23
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WD1PUUCS0E0fqZnmiW5pgM2pcHJQB0j4sfxQ6vSu2X8=;
        b=msNw20zEOEfFa4rUJbgL0jOo80hIc/3AGuZkEJcGTPnLShD8m8NYuBWxycxe9dISAI
         N85x9BbF3b00KhCMAxjQbuKO4vIttqHroup3f/bcorfbWGHTnpkyWjbWAa30YkYsI0LB
         +I1MrRED9mqFZogCfsc+eg21SAvfFanai5VSVR3CMxp6faYslAs7zmuGQ3sy3I2I/0Z6
         UFumlFjSn1xJXQLd45isXA9mVlNt+FqCS6BhuxJsipapsyLnEGGVqPQKpc1pKWPOOCfg
         0qDy1oflQTXgJ/2c+RIvtY/96cQqFC9e8aPIJe9nz1bqHYqtKv7O5EwUyMThFC8/ANxE
         k80Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WD1PUUCS0E0fqZnmiW5pgM2pcHJQB0j4sfxQ6vSu2X8=;
        b=lEq5YP+VdxZ4OtABtf6CHzu3BsB9oIxsS21CgEO7VAnS6wWfiS2eb49nbsGOfNr4nk
         qNEmU05vJBgcIGbQ5l78Sba7BO08la19obfcdpid+y+5BBJoA3KRbJ/KqY8R1k4RMFSk
         YKw9Px9UdfcHGw1Hg6fdN02tipDHluLijasIK6ZrHxOVlPhLQlZ4B75xk/3gcjPTLKy8
         oKT7blPx3DBF55rvmIH2LVY+2kkBgfC6Pj0TazhAKaUC5Waw0UFNv5L0E4xEE7/RWHFG
         ea00tPDSLUr1xiPh7Z8cQSdgU2uEM/y/UYYyyWc60pmlolLt3txEplBKNzLayis2Yr0w
         kdxA==
X-Gm-Message-State: AOAM530kkrjPy0wBQAINviqokbKNzTNWV+IpVjZkVJ/Q4jTs12i4ndX5
        lvUk2vILwoUiOia4KlIRVmu5CS5VNaw=
X-Google-Smtp-Source: ABdhPJyQ51G5VCltsOz0DYJbYLD+M/qdiVghcwbWYbL4VDK2bewQ4uRMWlKa+yHqiVZsRPQtMaAS3jfo6M0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:d44c:: with SMTP id m73mr6338166ybf.513.1624384740841;
 Tue, 22 Jun 2021 10:59:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:13 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-29-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 28/54] KVM: x86/mmu: Always Set new mmu_role immediately after
 checking old role
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

Refactor shadow MMU initialization to immediately set its new mmu_role
after verifying it differs from the old role, and so that all flavors
of MMU initialization share the same check-and-set pattern.  Immediately
setting the role will allow future commits to use mmu_role to configure
the MMU without consuming stale state.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 31662283dac7..337a3e571db6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4714,6 +4714,11 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 				    struct kvm_mmu_role_regs *regs,
 				    union kvm_mmu_role new_role)
 {
+	if (new_role.as_u64 == context->mmu_role.as_u64)
+		return;
+
+	context->mmu_role.as_u64 = new_role.as_u64;
+
 	if (!____is_cr0_pg(regs))
 		nonpaging_init_context(vcpu, context);
 	else if (____is_efer_lma(regs))
@@ -4731,7 +4736,6 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 	}
 	context->shadow_root_level = new_role.base.level;
 
-	context->mmu_role.as_u64 = new_role.as_u64;
 	reset_shadow_zero_bits_mask(vcpu, context);
 }
 
@@ -4742,8 +4746,7 @@ static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
 	union kvm_mmu_role new_role =
 		kvm_calc_shadow_mmu_root_page_role(vcpu, regs, false);
 
-	if (new_role.as_u64 != context->mmu_role.as_u64)
-		shadow_mmu_init_context(vcpu, context, regs, new_role);
+	shadow_mmu_init_context(vcpu, context, regs, new_role);
 }
 
 static union kvm_mmu_role
@@ -4774,8 +4777,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 
 	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base);
 
-	if (new_role.as_u64 != context->mmu_role.as_u64)
-		shadow_mmu_init_context(vcpu, context, &regs, new_role);
+	shadow_mmu_init_context(vcpu, context, &regs, new_role);
 
 	/*
 	 * Redo the shadow bits, the reset done by shadow_mmu_init_context()
@@ -4823,6 +4825,8 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 	if (new_role.as_u64 == context->mmu_role.as_u64)
 		return;
 
+	context->mmu_role.as_u64 = new_role.as_u64;
+
 	context->shadow_root_level = level;
 
 	context->nx = true;
@@ -4833,7 +4837,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 	context->invlpg = ept_invlpg;
 	context->root_level = level;
 	context->direct_map = false;
-	context->mmu_role.as_u64 = new_role.as_u64;
 
 	update_permission_bitmask(vcpu, context, true);
 	update_pkru_bitmask(vcpu, context, true);
-- 
2.32.0.288.g62a8d224e6-goog

