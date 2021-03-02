Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0024132B5A0
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381894AbhCCHS4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:18:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37203 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1835968AbhCBTfX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:35:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rYzsjJj0ITlNfTADG/uyUMxBlzqOxvPjT9+/l0oE1as=;
        b=f6Vlori29ux0vde3mWwZ7f5hZCgvuaEZBIkebC1Q/w94OxyzJwLJrN7rQVDZykCIcVZQwM
        xXkIWiV3QldqqGycd94omKLr9e3fE96cVEyZvOy4AY1ZZwB0vqmV3qTsb24uBXbTMvh5ED
        oxePgXMVo4zuiQgZSTTIx+/90tPNPVU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-rdAOqEvDOKOHC24EI1nVnw-1; Tue, 02 Mar 2021 14:33:47 -0500
X-MC-Unique: rdAOqEvDOKOHC24EI1nVnw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8536C107ACF3;
        Tue,  2 Mar 2021 19:33:46 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0893160BFA;
        Tue,  2 Mar 2021 19:33:45 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, Cathy Avery <cavery@redhat.com>
Subject: [PATCH 03/23] KVM: nSVM: Track the ASID generation of the vmcb vmrun through the vmcb
Date:   Tue,  2 Mar 2021 14:33:23 -0500
Message-Id: <20210302193343.313318-4-pbonzini@redhat.com>
In-Reply-To: <20210302193343.313318-1-pbonzini@redhat.com>
References: <20210302193343.313318-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Cathy Avery <cavery@redhat.com>

This patch moves the asid_generation from the vcpu to the vmcb
in order to track the ASID generation that was active the last
time the vmcb was run. If sd->asid_generation changes between
two runs, the old ASID is invalid and must be changed.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Cathy Avery <cavery@redhat.com>
Message-Id: <20210112164313.4204-3-cavery@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 21 +++++++--------------
 arch/x86/kvm/svm/svm.h |  2 +-
 2 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c35285c926e0..aa1baf646ff0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1227,7 +1227,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 		save->cr3 = 0;
 		save->cr4 = 0;
 	}
-	svm->asid_generation = 0;
+	svm->current_vmcb->asid_generation = 0;
 	svm->asid = 0;
 
 	svm->nested.vmcb12_gpa = 0;
@@ -1309,13 +1309,6 @@ void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
 	svm->vmcb = target_vmcb->ptr;
 	svm->vmcb_pa = target_vmcb->pa;
 
-	/*
-	* Workaround: we don't yet track the ASID generation
-	* that was active the last time target_vmcb was run.
-	*/
-
-	svm->asid_generation = 0;
-
 	/*
 	* Track the physical CPU the target_vmcb is running on
 	* in order to mark the VMCB dirty if the cpu changes at
@@ -1382,7 +1375,6 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 	if (vmsa_page)
 		svm->vmsa = page_address(vmsa_page);
 
-	svm->asid_generation = 0;
 	svm->guest_state_loaded = false;
 
 	svm_switch_vmcb(svm, &svm->vmcb01);
@@ -1864,7 +1856,7 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
 		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 	}
 
-	svm->asid_generation = sd->asid_generation;
+	svm->current_vmcb->asid_generation = sd->asid_generation;
 	svm->asid = sd->next_asid++;
 }
 
@@ -3432,10 +3424,11 @@ static void pre_svm_run(struct vcpu_svm *svm)
 	/*
 	 * If the previous vmrun of the vmcb occurred on
 	 * a different physical cpu then we must mark the vmcb dirty.
-	 */
+	 * and assign a new asid.
+	*/
 
         if (unlikely(svm->current_vmcb->cpu != svm->vcpu.cpu)) {
-		svm->asid_generation = 0;
+		svm->current_vmcb->asid_generation = 0;
 		vmcb_mark_all_dirty(svm->vmcb);
 		svm->current_vmcb->cpu = svm->vcpu.cpu;
         }
@@ -3444,7 +3437,7 @@ static void pre_svm_run(struct vcpu_svm *svm)
 		return pre_sev_run(svm, svm->vcpu.cpu);
 
 	/* FIXME: handle wraparound of asid_generation */
-	if (svm->asid_generation != sd->asid_generation)
+	if (svm->current_vmcb->asid_generation != sd->asid_generation)
 		new_asid(svm, sd);
 }
 
@@ -3668,7 +3661,7 @@ void svm_flush_tlb(struct kvm_vcpu *vcpu)
 	if (static_cpu_has(X86_FEATURE_FLUSHBYASID))
 		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
 	else
-		svm->asid_generation--;
+		svm->current_vmcb->asid_generation--;
 }
 
 static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a37281097751..993155195212 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -85,6 +85,7 @@ struct kvm_vmcb_info {
 	struct vmcb *ptr;
 	unsigned long pa;
 	int cpu;
+	uint64_t asid_generation;
 };
 
 struct svm_nested_state {
@@ -114,7 +115,6 @@ struct vcpu_svm {
 	struct kvm_vmcb_info *current_vmcb;
 	struct svm_cpu_data *svm_data;
 	u32 asid;
-	uint64_t asid_generation;
 	uint64_t sysenter_esp;
 	uint64_t sysenter_eip;
 	uint64_t tsc_aux;
-- 
2.26.2


