Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096F92F3610
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 17:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405133AbhALQoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 11:44:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58575 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404757AbhALQop (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 11:44:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610469798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cUfX5tPPc+C3c7Lgk0v7v3G8sS4ZlOVoH2iXbMC54qA=;
        b=IgvQ/RhDAx4nZ2U63nV6c4cpTk5M0WoF/f7OC4/ZxYSz5zEUnUjP8/A8pNyuABhPpmVPV6
        17nJMO7sQmI1DrhNa4tOxQ/VctmhJzfK+qcXHp4lk5dgALyCnBN8+6WZ6+ug12BzW2ApHn
        X2JITXVjhj/pVfL9+6Mm72q77n6DwY0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-ZZU7-pfrMxutDmJqzVfc-Q-1; Tue, 12 Jan 2021 11:43:17 -0500
X-MC-Unique: ZZU7-pfrMxutDmJqzVfc-Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2374801AC3;
        Tue, 12 Jan 2021 16:43:15 +0000 (UTC)
Received: from virtlab710.virt.lab.eng.bos.redhat.com (virtlab710.virt.lab.eng.bos.redhat.com [10.19.152.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F2C95C1B4;
        Tue, 12 Jan 2021 16:43:15 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     vkuznets@redhat.com, wei.huang2@amd.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 2/2] KVM: nSVM: Track the ASID generation of the vmcb vmrun through the vmcb
Date:   Tue, 12 Jan 2021 11:43:13 -0500
Message-Id: <20210112164313.4204-3-cavery@redhat.com>
In-Reply-To: <20210112164313.4204-1-cavery@redhat.com>
References: <20210112164313.4204-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch moves the asid_generation from the vcpu to the vmcb
in order to track the ASID generation that was active the last
time the vmcb was run. If sd->asid_generation changes between
two runs, the old ASID is invalid and must be changed.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 21 +++++++--------------
 arch/x86/kvm/svm/svm.h |  2 +-
 2 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5b6998ff7aa1..73e63f7a0acf 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1214,7 +1214,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 		save->cr3 = 0;
 		save->cr4 = 0;
 	}
-	svm->asid_generation = 0;
+	svm->current_vmcb->asid_generation = 0;
 	svm->asid = 0;
 
 	svm->nested.vmcb12_gpa = 0;
@@ -1296,13 +1296,6 @@ void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
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
@@ -1347,7 +1340,6 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
-	svm->asid_generation = 0;
 	init_vmcb(svm);
 
 	svm_init_osvw(vcpu);
@@ -1784,7 +1776,7 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
 		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 	}
 
-	svm->asid_generation = sd->asid_generation;
+	svm->current_vmcb->asid_generation = sd->asid_generation;
 	svm->asid = sd->next_asid++;
 }
 
@@ -3179,11 +3171,12 @@ static void pre_svm_run(struct vcpu_svm *svm)
 
 	/*
 	* If the previous vmrun of the vmcb occurred on
-	* a different physical cpu then we must mark the vmcb dirty.
+	* a different physical cpu then we must mark the vmcb dirty,
+	* update the asid_generation, and assign a new asid.
 	*/
 
         if (unlikely(svm->current_vmcb->cpu != svm->vcpu.cpu)) {
-		svm->asid_generation = 0;
+		svm->current_vmcb->asid_generation = 0;
 		vmcb_mark_all_dirty(svm->vmcb);
 		svm->current_vmcb->cpu = svm->vcpu.cpu;
         }
@@ -3192,7 +3185,7 @@ static void pre_svm_run(struct vcpu_svm *svm)
 		return pre_sev_run(svm, svm->vcpu.cpu);
 
 	/* FIXME: handle wraparound of asid_generation */
-	if (svm->asid_generation != sd->asid_generation)
+	if (svm->current_vmcb->asid_generation != sd->asid_generation)
 		new_asid(svm, sd);
 }
 
@@ -3399,7 +3392,7 @@ void svm_flush_tlb(struct kvm_vcpu *vcpu)
 	if (static_cpu_has(X86_FEATURE_FLUSHBYASID))
 		svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
 	else
-		svm->asid_generation--;
+		svm->current_vmcb->asid_generation--;
 }
 
 static void svm_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t gva)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 05baee934d03..edcfc2a4e77e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -86,6 +86,7 @@ struct kvm_vmcb_info {
 	struct vmcb *ptr;
 	unsigned long pa;
 	int cpu;
+	uint64_t asid_generation;
 };
 
 struct svm_nested_state {
@@ -115,7 +116,6 @@ struct vcpu_svm {
 	struct kvm_vmcb_info *current_vmcb;
 	struct svm_cpu_data *svm_data;
 	u32 asid;
-	uint64_t asid_generation;
 	uint64_t sysenter_esp;
 	uint64_t sysenter_eip;
 	uint64_t tsc_aux;
-- 
2.20.1

