Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1E844BE38
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 11:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhKJKDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 05:03:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50385 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231180AbhKJKDq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Nov 2021 05:03:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636538459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s0kl1pu5e8AfuwOD4EByN8Bid0Hy0Ge+6FEAJzOlZXk=;
        b=R9Aw1LfSv6Lfd49DGrI0whfIYF9bdi2Of/+iW4WtdLOwepriKhiSIUfZMRdgs3cx7CU7p/
        wQGgRk6gvZHz6qs6lANKocMCGo08tLsJNq1oV5qvvkkyBew7+2/bL12THD7oP6jnCORhHT
        R4hgm6FLE2BqK+8bHbksk8HQP6ZFgKE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-PH1IkTukNJmEqYxRhlid-A-1; Wed, 10 Nov 2021 05:00:55 -0500
X-MC-Unique: PH1IkTukNJmEqYxRhlid-A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34F9B87D541;
        Wed, 10 Nov 2021 10:00:53 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B0DD1037F3B;
        Wed, 10 Nov 2021 10:00:49 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 3/3] KVM: x86/mmu: don't skip mmu initialization when mmu root level changes
Date:   Wed, 10 Nov 2021 12:00:18 +0200
Message-Id: <20211110100018.367426-4-mlevitsk@redhat.com>
In-Reply-To: <20211110100018.367426-1-mlevitsk@redhat.com>
References: <20211110100018.367426-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running mix of 32 and 64 bit guests, it is possible to have mmu
reset with same mmu role but different root level (32 bit vs 64 bit paging)

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 354d2ca92df4d..763867475860f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4745,7 +4745,10 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	union kvm_mmu_role new_role =
 		kvm_calc_tdp_mmu_root_page_role(vcpu, &regs, false);
 
-	if (new_role.as_u64 == context->mmu_role.as_u64)
+	u8 new_root_level = role_regs_to_root_level(&regs);
+
+	if (new_role.as_u64 == context->mmu_role.as_u64 &&
+	    context->root_level == new_root_level)
 		return;
 
 	context->mmu_role.as_u64 = new_role.as_u64;
@@ -4757,7 +4760,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->get_guest_pgd = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
-	context->root_level = role_regs_to_root_level(&regs);
+	context->root_level = new_root_level;
 
 	if (!is_cr0_pg(context))
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -4806,7 +4809,10 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 				    struct kvm_mmu_role_regs *regs,
 				    union kvm_mmu_role new_role)
 {
-	if (new_role.as_u64 == context->mmu_role.as_u64)
+	u8 new_root_level = role_regs_to_root_level(regs);
+
+	if (new_role.as_u64 == context->mmu_role.as_u64 &&
+	    context->root_level == new_root_level)
 		return;
 
 	context->mmu_role.as_u64 = new_role.as_u64;
@@ -4817,8 +4823,8 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 		paging64_init_context(context);
 	else
 		paging32_init_context(context);
-	context->root_level = role_regs_to_root_level(regs);
 
+	context->root_level = new_root_level;
 	reset_guest_paging_metadata(vcpu, context);
 	context->shadow_root_level = new_role.base.level;
 
-- 
2.26.3

