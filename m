Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F932F4CD4
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 15:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbhAMOMJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 09:12:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55443 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726516AbhAMOMJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 09:12:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610547042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WaidgZkyTvdrv+AF9aZT36Vvz2XSjBnUVdbpe+zfNhA=;
        b=J6DPrHjCqLrVusLnzlaY5i293kJLYPsY2yFDABUNl2QoVd2GVXZ4rwjsyYBZ14sWbUtfHy
        KfbAQXiw3lKD2A1zNnakuQrAz8KVR8xmygD+ca1vuahfsBLgPqTyMTIFc2E7ZZmmBBO26V
        Vaq7uxkvqOMVsxZ8BWqs8cGp8QOL90w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-4IbZQ51aMKmfC-gxcbX5Pw-1; Wed, 13 Jan 2021 09:10:40 -0500
X-MC-Unique: 4IbZQ51aMKmfC-gxcbX5Pw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF8DC83DC6E;
        Wed, 13 Jan 2021 14:10:21 +0000 (UTC)
Received: from virtlab710.virt.lab.eng.bos.redhat.com (virtlab710.virt.lab.eng.bos.redhat.com [10.19.152.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 478E460BF1;
        Wed, 13 Jan 2021 14:10:21 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     vkuznets@redhat.com, wei.huang2@amd.com
Subject: [PATCH v2 2/2] KVM: nSVM: Track the ASID generation of the vmcb vmrun through the vmcb
Date:   Wed, 13 Jan 2021 09:10:19 -0500
Message-Id: <20210113141019.5127-3-cavery@redhat.com>
In-Reply-To: <20210113141019.5127-1-cavery@redhat.com>
References: <20210113141019.5127-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
index be41b7ebfcea..e9326d3f6583 100644
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
@@ -1291,13 +1291,6 @@ void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb)
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
@@ -1342,7 +1335,6 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
-	svm->asid_generation = 0;
 	init_vmcb(svm);
 
 	svm_init_osvw(vcpu);
@@ -1779,7 +1771,7 @@ static void new_asid(struct vcpu_svm *svm, struct svm_cpu_data *sd)
 		vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
 	}
 
-	svm->asid_generation = sd->asid_generation;
+	svm->current_vmcb->asid_generation = sd->asid_generation;
 	svm->asid = sd->next_asid++;
 }
 
@@ -3174,11 +3166,12 @@ static void pre_svm_run(struct vcpu_svm *svm)
 
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
@@ -3187,7 +3180,7 @@ static void pre_svm_run(struct vcpu_svm *svm)
 		return pre_sev_run(svm, svm->vcpu.cpu);
 
 	/* FIXME: handle wraparound of asid_generation */
-	if (svm->asid_generation != sd->asid_generation)
+	if (svm->current_vmcb->asid_generation != sd->asid_generation)
 		new_asid(svm, sd);
 }
 
@@ -3394,7 +3387,7 @@ void svm_flush_tlb(struct kvm_vcpu *vcpu)
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

