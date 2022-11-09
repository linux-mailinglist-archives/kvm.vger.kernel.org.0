Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09BAF622E6F
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 15:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbiKIOxI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 09:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbiKIOxE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 09:53:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB5E1260D
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 06:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668005521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v7KekBuVbdaP/slMay7nDZlONr+EZdVeul1Pazjhqh4=;
        b=Arqmb/iunuICv/rtXTzjUNVZsp3rRIq9QJzpA+D5WmjZWhRZOkywUPMmBxoPuciMebTcVo
        fSDGzrJd0TWvSaxYhW7GBUSaoJHLyuqWX+yen90lSR+KUfOAO2NOStvAbzFI8EiDmvI4ad
        41+nruDaIZ0GDxDwHj+AmBsamI5r9jM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-fPQcFIf7Msyp74x4LmfT6g-1; Wed, 09 Nov 2022 09:51:59 -0500
X-MC-Unique: fPQcFIf7Msyp74x4LmfT6g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 17C7C2815215;
        Wed,  9 Nov 2022 14:51:59 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E36ED140EBF5;
        Wed,  9 Nov 2022 14:51:58 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     thomas.lendacky@amd.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 07/11] KVM: SVM: do not allocate struct svm_cpu_data dynamically
Date:   Wed,  9 Nov 2022 09:51:52 -0500
Message-Id: <20221109145156.84714-8-pbonzini@redhat.com>
In-Reply-To: <20221109145156.84714-1-pbonzini@redhat.com>
References: <20221109145156.84714-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The svm_data percpu variable is a pointer, but it is allocated when
KVM is loaded (via svm_hardware_setup), not at hardware_enable time.
Just allocate room for it statically, that is more efficient and
does not waste any memory compared to the status quo.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c |  4 ++--
 arch/x86/kvm/svm/svm.c | 41 +++++++++++++++--------------------------
 arch/x86/kvm/svm/svm.h |  2 +-
 3 files changed, 18 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 28064060413a..9b66ee34e264 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -196,7 +196,7 @@ static void sev_asid_free(struct kvm_sev_info *sev)
 	__set_bit(sev->asid, sev_reclaim_asid_bitmap);
 
 	for_each_possible_cpu(cpu) {
-		sd = per_cpu(svm_data, cpu);
+		sd = per_cpu_ptr(&svm_data, cpu);
 		sd->sev_vmcbs[sev->asid] = NULL;
 	}
 
@@ -2600,7 +2600,7 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 
 void pre_sev_run(struct vcpu_svm *svm, int cpu)
 {
-	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
 	int asid = sev_get_asid(svm->vcpu.kvm);
 
 	/* Assign the asid allocated with this SEV guest */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0f873b298931..48274c93d78b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -245,7 +245,7 @@ struct kvm_ldttss_desc {
 	u32 zero1;
 } __attribute__((packed));
 
-DEFINE_PER_CPU(struct svm_cpu_data *, svm_data);
+DEFINE_PER_CPU(struct svm_cpu_data, svm_data);
 
 /*
  * Only MSR_TSC_AUX is switched via the user return hook.  EFER is switched via
@@ -581,12 +581,7 @@ static int svm_hardware_enable(void)
 		pr_err("%s: err EOPNOTSUPP on %d\n", __func__, me);
 		return -EINVAL;
 	}
-	sd = per_cpu(svm_data, me);
-	if (!sd) {
-		pr_err("%s: svm_data is NULL on %d\n", __func__, me);
-		return -EINVAL;
-	}
-
+	sd = per_cpu_ptr(&svm_data, me);
 	sd->asid_generation = 1;
 	sd->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
 	sd->next_asid = sd->max_asid + 1;
@@ -646,41 +641,35 @@ static int svm_hardware_enable(void)
 
 static void svm_cpu_uninit(int cpu)
 {
-	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
 
-	if (!sd)
+	if (!sd->save_area)
 		return;
 
-	per_cpu(svm_data, cpu) = NULL;
 	kfree(sd->sev_vmcbs);
 	__free_page(sd->save_area);
-	kfree(sd);
+	sd->save_area = NULL;
 }
 
 static int svm_cpu_init(int cpu)
 {
-	struct svm_cpu_data *sd;
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
 	int ret = -ENOMEM;
 
-	sd = kzalloc(sizeof(struct svm_cpu_data), GFP_KERNEL);
-	if (!sd)
-		return ret;
+	memset(sd, 0, sizeof(struct svm_cpu_data));
 	sd->save_area = alloc_page(GFP_KERNEL | __GFP_ZERO);
 	if (!sd->save_area)
-		goto free_cpu_data;
+		return ret;
 
 	ret = sev_cpu_init(sd);
 	if (ret)
 		goto free_save_area;
 
-	per_cpu(svm_data, cpu) = sd;
-
 	return 0;
 
 free_save_area:
 	__free_page(sd->save_area);
-free_cpu_data:
-	kfree(sd);
+	sd->save_area = NULL;
 	return ret;
 
 }
@@ -1424,7 +1413,7 @@ static void svm_clear_current_vmcb(struct vmcb *vmcb)
 	int i;
 
 	for_each_online_cpu(i)
-		cmpxchg(&per_cpu(svm_data, i)->current_vmcb, vmcb, NULL);
+		cmpxchg(per_cpu_ptr(&svm_data.current_vmcb, i), vmcb, NULL);
 }
 
 static void svm_vcpu_free(struct kvm_vcpu *vcpu)
@@ -1449,7 +1438,7 @@ static void svm_vcpu_free(struct kvm_vcpu *vcpu)
 static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
 
 	if (sev_es_guest(vcpu->kvm))
 		sev_es_unmap_ghcb(svm);
@@ -1486,7 +1475,7 @@ static void svm_prepare_host_switch(struct kvm_vcpu *vcpu)
 static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct svm_cpu_data *sd = per_cpu(svm_data, cpu);
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
 
 	if (sd->current_vmcb != svm->vmcb) {
 		sd->current_vmcb = svm->vmcb;
@@ -3442,7 +3431,7 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 static void reload_tss(struct kvm_vcpu *vcpu)
 {
-	struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
 
 	sd->tss_desc->type = 9; /* available 32/64-bit TSS */
 	load_TR_desc();
@@ -3450,7 +3439,7 @@ static void reload_tss(struct kvm_vcpu *vcpu)
 
 static void pre_svm_run(struct kvm_vcpu *vcpu)
 {
-	struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
+	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	/*
@@ -3919,7 +3908,7 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	if (sev_es_guest(vcpu->kvm)) {
 		__svm_sev_es_vcpu_run(svm);
 	} else {
-		struct svm_cpu_data *sd = per_cpu(svm_data, vcpu->cpu);
+		struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
 
 		/*
 		 * Use a single vmcb (vmcb01 because it's always valid) for
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 7540db9902a6..2af6a71126c1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -293,7 +293,7 @@ struct svm_cpu_data {
 	struct vmcb **sev_vmcbs;
 };
 
-DECLARE_PER_CPU(struct svm_cpu_data *, svm_data);
+DECLARE_PER_CPU(struct svm_cpu_data, svm_data);
 
 void recalc_intercepts(struct vcpu_svm *svm);
 
-- 
2.31.1


