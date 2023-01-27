Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3292767DC66
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 03:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233772AbjA0CxF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 21:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233640AbjA0Cw6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 21:52:58 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344E719F1E
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 18:52:57 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id mg12so10199962ejc.5
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 18:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=profian-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vFl4aAkNuRJwuV+yijx1mZpq5rU6zcwQKFNa9OgHXqU=;
        b=YVslWkms7rDncNGrn9vFPojszwgWmGX4ezQ62cWyAu0GeGdu1kvf0HfixbbURIFs31
         xQJyzygUqO/JqH93z9MF3fP04u+/xIJnoewATn+ynqUwuXfoSOTBifUMnKH4ckYrvmBg
         EgtJdvhTLf0OyZ78zsOvevf4W0nSnguRzpKOKQEAQEgsZLOHSwSfDdpE/5cpBxIz3fn1
         pWqlBPUALfKnFFz2/rB2GwYgShNW5bzuiVSq12lo0tgRRXw5QzxWq8oqMINV5TWCLcas
         O2uASy/bTBYyX2IZE/Pqb0J6MBo2gwgxUc+6txoDujQLd1ujJqUV3yx1ZehtXXqug/Gf
         h07w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vFl4aAkNuRJwuV+yijx1mZpq5rU6zcwQKFNa9OgHXqU=;
        b=XNWEpfL18m0140DEJyITi+CsWbbXRtXXX+tYKdenXQ0Bu9uIg8/yldDSjRG7+kmtfn
         yDdryKso1DcQ+Efa4EEM79H6n+/pY5C1HqMnC25GufVTPkJLp1M5SvrIf9aYd4d6xUih
         egikDHotc+TmSbH9Uzn71f4P1WweyHrKWNoYsScvRv8AuqJ/EhFaFa5biXcZrCLKGRGk
         bPI5WwXcYgxBhFAIgwJ2M7oLIHjDaGM/gAmLJydAhEkRr33y2zBTENoBcSQXEfig0eV0
         9qbRaiBehLU4kS/Le0F+Bf46MsRM/VMfzaIK1XYnaWuemmgDQwrtb5sp6zgxl3nz1tHS
         gVRA==
X-Gm-Message-State: AFqh2koWNvrTi6srUin3gA08CtrqO7tGBVCJhiBWh8vpX/QIojNlaM3b
        BC1dsnqz3L1q4FKbwsJN84/gnQ==
X-Google-Smtp-Source: AMrXdXvv91GgHf2kgTdvEmRCRlFBjbStcdejhB101pcsENlNYr2Z7S+BA+sypZzvO+c3evXCpcEKiw==
X-Received: by 2002:a17:907:d15:b0:862:e612:effe with SMTP id gn21-20020a1709070d1500b00862e612effemr57022627ejc.14.1674787975611;
        Thu, 26 Jan 2023 18:52:55 -0800 (PST)
Received: from localhost (88-113-101-73.elisa-laajakaista.fi. [88.113.101.73])
        by smtp.gmail.com with ESMTPSA id g14-20020a170906394e00b00779cde476e4sm1446776eje.62.2023.01.26.18.52.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 18:52:55 -0800 (PST)
From:   Jarkko Sakkinen <jarkko@profian.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Harald Hoyer <harald@profian.com>, Tom Dohrmann <erbse.13@gmx.de>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jarkko Sakkinen <jarkko@profian.com>,
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT))
Subject: [PATCH RFC 6/8] KVM: SVM: KVM_SEV_SNP_LAUNCH_RESET_VECTOR
Date:   Fri, 27 Jan 2023 02:52:35 +0000
Message-Id: <20230127025237.269680-7-jarkko@profian.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230127025237.269680-1-jarkko@profian.com>
References: <20230127025237.269680-1-jarkko@profian.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The attestation of the workload includes the CPU state information.

When the workload that was running in the VM exits, the system stores
the state in the special area (VMSA).  When the workload is started again,
it loads the state back.  This is a well-defined process and works.

However, the *initial state* needs to be better defined.  Currently, it is
defined by kernel without userspace knowledge or ability to influence.  As
a result, Enarx does not know the initial state and has to make a guess
whenever there is need to offline digest calculation.  After all, the core
idea of confidential computing that everything can be validated and
verified in order to reach trust.

The variation could come mainly from either sev_features and vintr_ctrl.

Allow to user space to define them when the new KVM_SEV_SNP_RESET_VECTOR
init flag is set but at the same time verify that they are set only to
those values that kernel is aware of.

Link: https://enarx.dev/
Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>
---
 arch/x86/include/asm/svm.h | 15 ++++++----
 arch/x86/kvm/svm/sev.c     | 57 +++++++++++++++++++++++++++++++-------
 arch/x86/kvm/svm/svm.h     |  1 +
 include/uapi/linux/kvm.h   |  5 ++++
 4 files changed, 63 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index e76ad26ba64f..b3b7131a1ce7 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -278,12 +278,17 @@ enum avic_ipi_failure_cause {
 #define AVIC_HPA_MASK	~((0xFFFULL << 52) | 0xFFF)
 #define VMCB_AVIC_APIC_BAR_MASK		0xFFFFFFFFFF000ULL
 
-#define SVM_SEV_FEAT_SNP_ACTIVE			BIT(0)
-#define SVM_SEV_FEAT_RESTRICTED_INJECTION	BIT(3)
-#define SVM_SEV_FEAT_ALTERNATE_INJECTION	BIT(4)
-#define SVM_SEV_FEAT_INT_INJ_MODES		\
-	(SVM_SEV_FEAT_RESTRICTED_INJECTION |	\
+
+#define SVM_SEV_FEAT_SNP_ACTIVE			BIT_ULL(0)
+#define SVM_SEV_FEAT_RESTRICTED_INJECTION	BIT_ULL(3)
+#define SVM_SEV_FEAT_ALTERNATE_INJECTION	BIT_ULL(4)
+#define SVM_SEV_FEAT_INT_INJ_MODES \
+	(SVM_SEV_FEAT_RESTRICTED_INJECTION |\
 	 SVM_SEV_FEAT_ALTERNATE_INJECTION)
+#define SVM_SEV_FEAT_UNSUPPORTED_MASK \
+	~(SVM_SEV_FEAT_SNP_ACTIVE |\
+	  SVM_SEV_FEAT_RESTRICTED_INJECTION |\
+	  SVM_SEV_FEAT_ALTERNATE_INJECTION)
 
 struct vmcb_seg {
 	u16 selector;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 899c78d03c35..5e4666b79689 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -303,6 +303,11 @@ static int verify_snp_init_flags(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	/* Save the supplied flags value */
 	sev->snp_init_flags = params.flags;
 
+	if (params.flags & KVM_SEV_SNP_RESET_VECTOR) {
+		sev->sev_features = params.sev_features;
+		sev->vintr_ctrl = params.vintr_ctrl;
+	}
+
 	/* Return the supported flags value */
 	params.flags = SEV_SNP_SUPPORTED_FLAGS;
 
@@ -785,6 +790,33 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	if (svm->vcpu.guest_debug || (svm->vmcb->save.dr7 & ~DR7_FIXED_1))
 		return -EINVAL;
 
+	/* Validate that the user defined reset vector meets the expectations: */
+	if (sev->snp_init_flags & KVM_SEV_SNP_RESET_VECTOR) {
+		u64 unsupported = sev->sev_features & SVM_SEV_FEAT_UNSUPPORTED_MASK;
+
+		if (sev->sev_features & unsupported) {
+			pr_debug("sev_features: unsupported flags: 0x%016llx\n", unsupported);
+			return -EINVAL;
+		}
+
+		if (!(sev_snp_guest(svm->vcpu.kvm) &&
+		    (sev->sev_features & SVM_SEV_FEAT_SNP_ACTIVE))) {
+			pr_debug("sev_features: SNP_ACTIVE is not set\n");
+			return -EINVAL;
+		}
+
+		if (!((sev->snp_init_flags & KVM_SEV_SNP_RESTRICTED_INJET) &&
+		    (sev->sev_features & SVM_SEV_FEAT_RESTRICTED_INJECTION))) {
+			pr_debug("sev_features: SNP_SEV_FEAT_RESTRICTED_INJECTION is not set\n");
+			return -EINVAL;
+		}
+
+		if (sev->vintr_ctrl) {
+			pr_debug("vintr_ctrl: unsupported flags: 0x%016llx\n", sev->vintr_ctrl);
+			return -EINVAL;
+		}
+	}
+
 	/*
 	 * SEV-ES will use a VMSA that is pointed to by the VMCB, not
 	 * the traditional VMSA that is part of the VMCB. Copy the
@@ -820,18 +852,23 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->xss  = svm->vcpu.arch.ia32_xss;
 	save->dr6  = svm->vcpu.arch.dr6;
 
-	/* Enable the SEV-SNP feature */
-	if (sev_snp_guest(svm->vcpu.kvm))
-		save->sev_features |= SVM_SEV_FEAT_SNP_ACTIVE;
+	if (sev->snp_init_flags & KVM_SEV_SNP_RESET_VECTOR) {
+		save->sev_features = sev->sev_features;
+		save->vintr_ctrl = sev->vintr_ctrl;
+	} else {
+		/* Enable the SEV-SNP feature */
+		if (sev_snp_guest(svm->vcpu.kvm))
+			save->sev_features |= SVM_SEV_FEAT_SNP_ACTIVE;
 
-	if (sev->snp_init_flags & KVM_SEV_SNP_RESTRICTED_INJET)
-		save->sev_features |= SVM_SEV_FEAT_RESTRICTED_INJECTION;
+		if (sev->snp_init_flags & KVM_SEV_SNP_RESTRICTED_INJET)
+			save->sev_features |= SVM_SEV_FEAT_RESTRICTED_INJECTION;
 
-	/*
-	 * Save the VMSA synced SEV features. For now, they are the same for
-	 * all vCPUs, so just save each time.
-	 */
-	sev->sev_features = save->sev_features;
+		/*
+		 * Save the VMSA synced SEV features. For now, they are the same for
+		 * all vCPUs, so just save each time.
+		 */
+		sev->sev_features = save->sev_features;
+	}
 
 	pr_debug("Virtual Machine Save Area (VMSA):\n");
 	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 4dab13084363..5dce17eefd5d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -106,6 +106,7 @@ struct kvm_sev_info {
 	struct mutex guest_req_lock;
 
 	u64 sev_features;	/* Features set at VMSA creation */
+	u64 vintr_ctrl;
 };
 
 struct kvm_svm {
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 48bcc59cf86b..e176d0ec6c54 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -2054,8 +2054,13 @@ struct kvm_sev_receive_update_data {
 /* enable the restricted injection timer */
 #define KVM_SEV_SNP_RESTRICTED_TIMER_INJET   (1 << 1)
 
+/* use the given reset vector for sev_features and vintr_ctrl */
+#define KVM_SEV_SNP_RESET_VECTOR   (1 << 2)
+
 struct kvm_snp_init {
 	__u64 flags;
+	__u64 sev_features;
+	__u64 vintr_ctrl;
 };
 
 struct kvm_sev_snp_launch_start {
-- 
2.38.1

