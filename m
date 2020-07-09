Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A8521A292
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 16:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgGIOyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 10:54:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22022 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727901AbgGIOyN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 10:54:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594306452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=76JYvqYrW4raYFbd8pyvMkZzuFTDK0PC0PfWWPc6TDo=;
        b=aLd29zBjeTzetRgowaXbCv+IryEJEO3gpoOLUFx/N71+KA8/B9S+pPCR8m8CFtnxgW4Za8
        Mz8KQ9UVf0eFBD5/O5Gc0iWXlJfO/Fj0yg1JYKOZrRBBJYVvZmimD0m7m/CNhFc6lnXzq7
        9d5H0BvAsoYnmtQwWJsiLTmALSY1O30=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-AN_T-W8ZOf6czi6LFtRNxA-1; Thu, 09 Jul 2020 10:54:11 -0400
X-MC-Unique: AN_T-W8ZOf6czi6LFtRNxA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEBA419200C8;
        Thu,  9 Jul 2020 14:54:09 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C666E6106A;
        Thu,  9 Jul 2020 14:54:07 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/9] KVM: nSVM: stop dereferencing vcpu->arch.mmu to get the context in kvm_init_shadow{,_npt}_mmu()
Date:   Thu,  9 Jul 2020 16:53:51 +0200
Message-Id: <20200709145358.1560330-3-vkuznets@redhat.com>
In-Reply-To: <20200709145358.1560330-1-vkuznets@redhat.com>
References: <20200709145358.1560330-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now as kvm_init_shadow_npt_mmu() is separated from kvm_init_shadow_mmu()
we always know the MMU context we need to use so there is no need to
dereference vcpu->arch.mmu pointer.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 93f18e5fa8b5..69fa51af8cbf 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4952,11 +4952,10 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu, bool base_only)
 	return role;
 }
 
-static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4,
-				    u32 efer, union kvm_mmu_role new_role)
+static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
+				    u32 cr0, u32 cr4, u32 efer,
+				    union kvm_mmu_role new_role)
 {
-	struct kvm_mmu *context = vcpu->arch.mmu;
-
 	if (!(cr0 & X86_CR0_PG))
 		nonpaging_init_context(vcpu, context);
 	else if (efer & EFER_LMA)
@@ -4972,23 +4971,23 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4,
 
 static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer)
 {
-	struct kvm_mmu *context = vcpu->arch.mmu;
+	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_role new_role =
 		kvm_calc_shadow_mmu_root_page_role(vcpu, false);
 
 	if (new_role.as_u64 != context->mmu_role.as_u64)
-		shadow_mmu_init_context(vcpu, cr0, cr4, efer, new_role);
+		shadow_mmu_init_context(vcpu, context, cr0, cr4, efer, new_role);
 }
 
 void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer,
 			     gpa_t nested_cr3)
 {
-	struct kvm_mmu *context = vcpu->arch.mmu;
+	struct kvm_mmu *context = &vcpu->arch.guest_mmu;
 	union kvm_mmu_role new_role =
 		kvm_calc_shadow_mmu_root_page_role(vcpu, false);
 
 	if (new_role.as_u64 != context->mmu_role.as_u64)
-		shadow_mmu_init_context(vcpu, cr0, cr4, efer, new_role);
+		shadow_mmu_init_context(vcpu, context, cr0, cr4, efer, new_role);
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
 
-- 
2.25.4

