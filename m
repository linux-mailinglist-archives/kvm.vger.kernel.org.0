Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567BC4AC50C
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 17:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389441AbiBGQEH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 11:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbiBGP40 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 10:56:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A3602C0401CF
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 07:56:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644249384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qdwpmbef/Bh6XlwaL5pVGukYEI2IsJrzG/O+p5FnU2s=;
        b=DE/BHsSiEucXgigebfg+eeNh1VVPmYVyk0rJSTOOZYWrwdCyWnmSPtWfKuuh3iOLLjTdt2
        we7cOTEbI8neYUIEYMObDrCwv8FcMjk37OY8FhY9H7a/+mLYjpeWQoW6gdygHfPgCaOXjB
        6dl8+8H7NB/HWYH54JrRCpqD2YH8xcA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-oPbGccWgM-qCFCmjnGmEAg-1; Mon, 07 Feb 2022 10:56:21 -0500
X-MC-Unique: oPbGccWgM-qCFCmjnGmEAg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C37231091DA5;
        Mon,  7 Feb 2022 15:56:18 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90B227DE4D;
        Mon,  7 Feb 2022 15:56:11 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Tony Luck <tony.luck@intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        David Airlie <airlied@linux.ie>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH RESEND 09/30] KVM: x86: SVM: move avic definitions from AMD's spec to svm.h
Date:   Mon,  7 Feb 2022 17:54:26 +0200
Message-Id: <20220207155447.840194-10-mlevitsk@redhat.com>
In-Reply-To: <20220207155447.840194-1-mlevitsk@redhat.com>
References: <20220207155447.840194-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

asm/svm.h is the correct place for all values that are defined in
the SVM spec, and that includes AVIC.

Also add some values from the spec that were not defined before
and will be soon useful.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/include/asm/svm.h       | 36 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/avic.c          | 22 +------------------
 arch/x86/kvm/svm/svm.h           | 11 ----------
 4 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 01e2650b95859..552ff8a5ea023 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -476,6 +476,7 @@
 #define MSR_AMD64_ICIBSEXTDCTL		0xc001103c
 #define MSR_AMD64_IBSOPDATA4		0xc001103d
 #define MSR_AMD64_IBS_REG_COUNT_MAX	8 /* includes MSR_AMD64_IBSBRTARGET */
+#define MSR_AMD64_SVM_AVIC_DOORBELL	0xc001011b
 #define MSR_AMD64_VM_PAGE_FLUSH		0xc001011e
 #define MSR_AMD64_SEV_ES_GHCB		0xc0010130
 #define MSR_AMD64_SEV			0xc0010131
diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index b00dbc5fac2b2..bb2fb78523cee 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -220,6 +220,42 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
 #define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT(2)
 
+
+/* AVIC */
+#define AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK	(0xFF)
+#define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
+#define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
+
+#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	(0xFFULL)
+#define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	(0xFFFFFFFFFFULL << 12)
+#define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
+#define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
+#define AVIC_PHYSICAL_ID_TABLE_SIZE_MASK		(0xFF)
+
+#define AVIC_DOORBELL_PHYSICAL_ID_MASK			(0xFF)
+
+#define AVIC_UNACCEL_ACCESS_WRITE_MASK		1
+#define AVIC_UNACCEL_ACCESS_OFFSET_MASK		0xFF0
+#define AVIC_UNACCEL_ACCESS_VECTOR_MASK		0xFFFFFFFF
+
+enum avic_ipi_failure_cause {
+	AVIC_IPI_FAILURE_INVALID_INT_TYPE,
+	AVIC_IPI_FAILURE_TARGET_NOT_RUNNING,
+	AVIC_IPI_FAILURE_INVALID_TARGET,
+	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
+};
+
+
+/*
+ * 0xff is broadcast, so the max index allowed for physical APIC ID
+ * table is 0xfe.  APIC IDs above 0xff are reserved.
+ */
+#define AVIC_MAX_PHYSICAL_ID_COUNT	0xff
+
+#define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
+#define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
+
+
 struct vmcb_seg {
 	u16 selector;
 	u16 attrib;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 99f907ec5aa8f..fabfc337e1c35 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -27,20 +27,6 @@
 #include "irq.h"
 #include "svm.h"
 
-#define SVM_AVIC_DOORBELL	0xc001011b
-
-#define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
-
-/*
- * 0xff is broadcast, so the max index allowed for physical APIC ID
- * table is 0xfe.  APIC IDs above 0xff are reserved.
- */
-#define AVIC_MAX_PHYSICAL_ID_COUNT	255
-
-#define AVIC_UNACCEL_ACCESS_WRITE_MASK		1
-#define AVIC_UNACCEL_ACCESS_OFFSET_MASK		0xFF0
-#define AVIC_UNACCEL_ACCESS_VECTOR_MASK		0xFFFFFFFF
-
 /* AVIC GATAG is encoded using VM and VCPU IDs */
 #define AVIC_VCPU_ID_BITS		8
 #define AVIC_VCPU_ID_MASK		((1 << AVIC_VCPU_ID_BITS) - 1)
@@ -73,12 +59,6 @@ struct amd_svm_iommu_ir {
 	void *data;		/* Storing pointer to struct amd_ir_data */
 };
 
-enum avic_ipi_failure_cause {
-	AVIC_IPI_FAILURE_INVALID_INT_TYPE,
-	AVIC_IPI_FAILURE_TARGET_NOT_RUNNING,
-	AVIC_IPI_FAILURE_INVALID_TARGET,
-	AVIC_IPI_FAILURE_INVALID_BACKING_PAGE,
-};
 
 /* Note:
  * This function is called from IOMMU driver to notify
@@ -702,7 +682,7 @@ int svm_deliver_avic_intr(struct kvm_vcpu *vcpu, int vec)
 		 * one is harmless).
 		 */
 		if (cpu != get_cpu())
-			wrmsrl(SVM_AVIC_DOORBELL, kvm_cpu_get_apicid(cpu));
+			wrmsrl(MSR_AMD64_SVM_AVIC_DOORBELL, kvm_cpu_get_apicid(cpu));
 		put_cpu();
 	} else {
 		/*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 852b12aee03d7..6343558982c73 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -555,17 +555,6 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 
 /* avic.c */
 
-#define AVIC_LOGICAL_ID_ENTRY_GUEST_PHYSICAL_ID_MASK	(0xFF)
-#define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
-#define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
-
-#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	(0xFFULL)
-#define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	(0xFFFFFFFFFFULL << 12)
-#define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
-#define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
-
-#define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
-
 int avic_ga_log_notifier(u32 ga_tag);
 void avic_vm_destroy(struct kvm *kvm);
 int avic_vm_init(struct kvm *kvm);
-- 
2.26.3

