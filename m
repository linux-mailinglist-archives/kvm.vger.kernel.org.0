Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E2353ED98
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 20:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbiFFSJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 14:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiFFSJE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 14:09:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F2BDBA205A
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 11:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654538943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OV9GEezBo0x4uuJVAwzC4RhABqDVq5710sPw72Fat3k=;
        b=dJ3SIKuCmMFlH4psaEpuApvecQsgz/F3sXznorGx5RYjh8qyzdC9S0BNPnqlX9b3AJvVRA
        V9yL53SEigNtRi0veeO3pKJQfMul9PuEkzXwz+2Jo06R00+tWFRkwiEO5MOjw5aDw7yie2
        zUNi8N8kXFcNOX37jfEGZPLtRHx4khQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-354-QrJ6fz12OiyNIvdRyhveDg-1; Mon, 06 Jun 2022 14:09:01 -0400
X-MC-Unique: QrJ6fz12OiyNIvdRyhveDg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4EEA21D33867;
        Mon,  6 Jun 2022 18:09:01 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAE371121314;
        Mon,  6 Jun 2022 18:08:57 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 7/7] KVM: x86: SVM: there is no need for preempt safe wrappers for avic_vcpu_load/put
Date:   Mon,  6 Jun 2022 21:08:29 +0300
Message-Id: <20220606180829.102503-8-mlevitsk@redhat.com>
In-Reply-To: <20220606180829.102503-1-mlevitsk@redhat.com>
References: <20220606180829.102503-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that these functions are always called with preemption disabled -
remove them.

No functional change intended.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 27 ++++-----------------------
 arch/x86/kvm/svm/svm.c  |  4 ++--
 arch/x86/kvm/svm/svm.h  |  4 ++--
 3 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 5d98ac575dedc..5542d8959e114 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -946,7 +946,7 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 	return ret;
 }
 
-void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	u64 entry;
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
@@ -978,7 +978,7 @@ void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	avic_update_iommu_vcpu_affinity(vcpu, h_physical_id, true);
 }
 
-void __avic_vcpu_put(struct kvm_vcpu *vcpu)
+void avic_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	u64 entry;
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -997,25 +997,6 @@ void __avic_vcpu_put(struct kvm_vcpu *vcpu)
 	WRITE_ONCE(*(svm->avic_physical_id_cache), entry);
 }
 
-static void avic_vcpu_load(struct kvm_vcpu *vcpu)
-{
-	int cpu = get_cpu();
-
-	WARN_ON(cpu != vcpu->cpu);
-
-	__avic_vcpu_load(vcpu, cpu);
-
-	put_cpu();
-}
-
-static void avic_vcpu_put(struct kvm_vcpu *vcpu)
-{
-	preempt_disable();
-
-	__avic_vcpu_put(vcpu);
-
-	preempt_enable();
-}
 
 void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 {
@@ -1042,7 +1023,7 @@ void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 	vmcb_mark_dirty(vmcb, VMCB_AVIC);
 
 	if (activated)
-		avic_vcpu_load(vcpu);
+		avic_vcpu_load(vcpu, vcpu->cpu);
 	else
 		avic_vcpu_put(vcpu);
 
@@ -1075,5 +1056,5 @@ void avic_vcpu_unblocking(struct kvm_vcpu *vcpu)
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
 
-	avic_vcpu_load(vcpu);
+	avic_vcpu_load(vcpu, vcpu->cpu);
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4aea82f668fb1..b909769c73f03 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1439,13 +1439,13 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		indirect_branch_prediction_barrier();
 	}
 	if (kvm_vcpu_apicv_active(vcpu))
-		__avic_vcpu_load(vcpu, cpu);
+		avic_vcpu_load(vcpu, cpu);
 }
 
 static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	if (kvm_vcpu_apicv_active(vcpu))
-		__avic_vcpu_put(vcpu);
+		avic_vcpu_put(vcpu);
 
 	svm_prepare_host_switch(vcpu);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index cd92f43437539..035020d073477 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -614,8 +614,8 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb);
 int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu);
 int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu);
 int avic_init_vcpu(struct vcpu_svm *svm);
-void __avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
-void __avic_vcpu_put(struct kvm_vcpu *vcpu);
+void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
+void avic_vcpu_put(struct kvm_vcpu *vcpu);
 void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu);
 void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
 void avic_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu);
-- 
2.26.3

