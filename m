Return-Path: <kvm+bounces-4416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D32C812570
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 03:47:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36D171C2150D
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 02:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FCAF1378;
	Thu, 14 Dec 2023 02:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="CtpZW+yf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20DE0F4
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 18:47:35 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id d75a77b69052e-4259295ca72so50009051cf.1
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 18:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1702522054; x=1703126854; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sLym5Gc0MfszdRLPykujrkvWzHKTsOdv87aqMVbJcZE=;
        b=CtpZW+yfFmmldMBNhlbaLH+UqNvskT+bCvTO/4T3yCTZHcGRZYj1i54/6BHcZxEqJc
         aGR2wEDsLId9s0qfioq4oRslrKaMVLXTEwwbijbZFYkOUweXR2hIngkRGoeph1j7uhGb
         yPXXn/UEAlblTSLRON+HKWlI769TUilzwvf5hJdso4ggGFQ1S1Cz4FAhvilhlJJ0ps9b
         8EY41g+UrExAwfNK78+T68Ki1EWFT3yqHA46FisuMtgn95jHMgkECgwI6z3GS2oKM6Ek
         42cD+q0F5jJYE0+I/FJUo76MAFx+0kD8jSw+BjSc/A+BI95IZQ42DCYsaF8e/EqJkhHW
         3idg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702522054; x=1703126854;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sLym5Gc0MfszdRLPykujrkvWzHKTsOdv87aqMVbJcZE=;
        b=XO6IXovAAh7fod/afH6b9fLK4AM6OSWFpPuOf4dOKn1hI57/xQYHiG6rFsA2dl0E4C
         DhYMAdxZtpMDPbGSX2IlXejRUDLePe9N7IFI0h3A1IMeFQAEksMy7CiSbpk94edQDrKH
         EyXVnbeNH375U8nmv40p8f2r4iM22k3bkciYUodYlb78/jKq2GW12bvd83ySdmWrVSH0
         +LreMxwLRFvIBbe0fNeZXRonXfcXI+BmMh95GqaXS9ccc4sbp6A8gvO4YllHUuoawvku
         MBvZyY45Y/G5Ltxk2Cu6jCv8hJ8nK3h9F4vrf7NzRqBLjhY59rZB8yWXY7QRVC1ahrl+
         yetQ==
X-Gm-Message-State: AOJu0Yw2QdRL2X3fQ/wKY+h+RgfEoPjsk9mc0NvpyVrPtsW5WRWySvMq
	0x+FyHfsQ2coZu8ge+6Ar5YUpA==
X-Google-Smtp-Source: AGHT+IGSYInxhET4tbJoX6IZB5Ibc+UY+fKm4fU+fM1gek+LhRpmFkRDuIWe4shEdWu5gr3DwGZmpA==
X-Received: by 2002:a05:622a:490:b0:425:4043:763a with SMTP id p16-20020a05622a049000b004254043763amr12929180qtx.98.1702522054204;
        Wed, 13 Dec 2023 18:47:34 -0800 (PST)
Received: from vinp3lin.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id fh3-20020a05622a588300b00425b356b919sm4240208qtb.55.2023.12.13.18.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 18:47:33 -0800 (PST)
From: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
To: Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Mel Gorman <mgorman@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Joel Fernandes <joel@joelfernandes.org>
Subject: [RFC PATCH 1/8] kvm: x86: MSR for setting up scheduler info shared memory
Date: Wed, 13 Dec 2023 21:47:18 -0500
Message-ID: <20231214024727.3503870-2-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231214024727.3503870-1-vineeth@bitbyteword.org>
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement a kvm MSR that guest uses to provide the GPA of shared memory
for communicating the scheduling information between host and guest.

wrmsr(0) disables the feature. wrmsr(valid_gpa) enables the feature and
uses the gpa for further communication.

Also add a new cpuid feature flag for the host to advertise the feature
to the guest.

Co-developed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
---
 arch/x86/include/asm/kvm_host.h      | 25 ++++++++++++
 arch/x86/include/uapi/asm/kvm_para.h | 24 +++++++++++
 arch/x86/kvm/Kconfig                 | 12 ++++++
 arch/x86/kvm/cpuid.c                 |  2 +
 arch/x86/kvm/x86.c                   | 61 ++++++++++++++++++++++++++++
 include/linux/kvm_host.h             |  5 +++
 6 files changed, 129 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f72b30d2238a..f89ba1f07d88 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -987,6 +987,18 @@ struct kvm_vcpu_arch {
 	/* Protected Guests */
 	bool guest_state_protected;
 
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+	/*
+	 * MSR to setup a shared memory for scheduling
+	 * information sharing between host and guest.
+	 */
+	struct {
+		enum kvm_vcpu_boost_state boost_status;
+		u64 msr_val;
+		struct gfn_to_hva_cache data;
+	} pv_sched;
+#endif
+
 	/*
 	 * Set when PDPTS were loaded directly by the userspace without
 	 * reading the guest memory
@@ -2217,4 +2229,17 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
  */
 #define KVM_EXIT_HYPERCALL_MBZ		GENMASK_ULL(31, 1)
 
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+static inline bool kvm_arch_vcpu_pv_sched_enabled(struct kvm_vcpu_arch *arch)
+{
+	return arch->pv_sched.msr_val;
+}
+
+static inline void kvm_arch_vcpu_set_boost_status(struct kvm_vcpu_arch *arch,
+		enum kvm_vcpu_boost_state boost_status)
+{
+	arch->pv_sched.boost_status = boost_status;
+}
+#endif
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 6e64b27b2c1e..6b1dea07a563 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -36,6 +36,7 @@
 #define KVM_FEATURE_MSI_EXT_DEST_ID	15
 #define KVM_FEATURE_HC_MAP_GPA_RANGE	16
 #define KVM_FEATURE_MIGRATION_CONTROL	17
+#define KVM_FEATURE_PV_SCHED		18
 
 #define KVM_HINTS_REALTIME      0
 
@@ -58,6 +59,7 @@
 #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
 #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
 #define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
+#define MSR_KVM_PV_SCHED	0x4b564da0
 
 struct kvm_steal_time {
 	__u64 steal;
@@ -150,4 +152,26 @@ struct kvm_vcpu_pv_apf_data {
 #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
 #define KVM_PV_EOI_DISABLED 0x0
 
+/*
+ * VCPU boost state shared between the host and guest.
+ */
+enum kvm_vcpu_boost_state {
+	/* Priority boosting feature disabled in host */
+	VCPU_BOOST_DISABLED = 0,
+	/*
+	 * vcpu is not explicitly boosted by the host.
+	 * (Default priority when the guest started)
+	 */
+	VCPU_BOOST_NORMAL,
+	/* vcpu is boosted by the host */
+	VCPU_BOOST_BOOSTED
+};
+
+/*
+ * Structure passed in via MSR_KVM_PV_SCHED
+ */
+struct pv_sched_data {
+	__u64 boost_status;
+};
+
 #endif /* _UAPI_ASM_X86_KVM_PARA_H */
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 89ca7f4c1464..dbcba73fb508 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -141,4 +141,16 @@ config KVM_XEN
 config KVM_EXTERNAL_WRITE_TRACKING
 	bool
 
+config PARAVIRT_SCHED_KVM
+	bool "Enable paravirt scheduling capability for kvm"
+	depends on KVM
+	help
+	  Paravirtualized scheduling facilitates the exchange of scheduling
+	  related information between the host and guest through shared memory,
+	  enhancing the efficiency of vCPU thread scheduling by the hypervisor.
+	  An illustrative use case involves dynamically boosting the priority of
+	  a vCPU thread when the guest is executing a latency-sensitive workload
+	  on that specific vCPU.
+	  This config enables paravirt scheduling in the kvm hypervisor.
+
 endif # VIRTUALIZATION
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7bdc66abfc92..960ef6e869f2 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1113,6 +1113,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			     (1 << KVM_FEATURE_POLL_CONTROL) |
 			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
 			     (1 << KVM_FEATURE_ASYNC_PF_INT);
+		if (IS_ENABLED(CONFIG_PARAVIRT_SCHED_KVM))
+			entry->eax |= (1 << KVM_FEATURE_PV_SCHED);
 
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7bcf1a76a6ab..0f475b50ac83 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3879,6 +3879,33 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		break;
 
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+	case MSR_KVM_PV_SCHED:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_SCHED))
+			return 1;
+
+		if (!(data & KVM_MSR_ENABLED))
+			break;
+
+		if (!(data & ~KVM_MSR_ENABLED)) {
+			/*
+			 * Disable the feature
+			 */
+			vcpu->arch.pv_sched.msr_val = 0;
+			kvm_set_vcpu_boosted(vcpu, false);
+		} if (!kvm_gfn_to_hva_cache_init(vcpu->kvm,
+				&vcpu->arch.pv_sched.data, data & ~KVM_MSR_ENABLED,
+				sizeof(struct pv_sched_data))) {
+			vcpu->arch.pv_sched.msr_val = data;
+			kvm_set_vcpu_boosted(vcpu, false);
+		} else {
+			pr_warn("MSR_KVM_PV_SCHED: kvm:%p, vcpu:%p, "
+				"msr value: %llx, kvm_gfn_to_hva_cache_init failed!\n",
+				vcpu->kvm, vcpu, data & ~KVM_MSR_ENABLED);
+		}
+		break;
+#endif
+
 	case MSR_KVM_POLL_CONTROL:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_POLL_CONTROL))
 			return 1;
@@ -4239,6 +4266,11 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		msr_info->data = vcpu->arch.pv_eoi.msr_val;
 		break;
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+	case MSR_KVM_PV_SCHED:
+		msr_info->data = vcpu->arch.pv_sched.msr_val;
+		break;
+#endif
 	case MSR_KVM_POLL_CONTROL:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_POLL_CONTROL))
 			return 1;
@@ -9820,6 +9852,29 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
 	return kvm_skip_emulated_instruction(vcpu);
 }
 
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+static void record_vcpu_boost_status(struct kvm_vcpu *vcpu)
+{
+	u64 val = vcpu->arch.pv_sched.boost_status;
+
+	if (!kvm_arch_vcpu_pv_sched_enabled(&vcpu->arch))
+		return;
+
+	pagefault_disable();
+	kvm_write_guest_offset_cached(vcpu->kvm, &vcpu->arch.pv_sched.data,
+		&val, offsetof(struct pv_sched_data, boost_status), sizeof(u64));
+	pagefault_enable();
+}
+
+void kvm_set_vcpu_boosted(struct kvm_vcpu *vcpu, bool boosted)
+{
+	kvm_arch_vcpu_set_boost_status(&vcpu->arch,
+			boosted ? VCPU_BOOST_BOOSTED : VCPU_BOOST_NORMAL);
+
+	kvm_make_request(KVM_REQ_VCPU_BOOST_UPDATE, vcpu);
+}
+#endif
+
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 {
 	unsigned long nr, a0, a1, a2, a3, ret;
@@ -10593,6 +10648,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		}
 		if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu))
 			record_steal_time(vcpu);
+
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+		if (kvm_check_request(KVM_REQ_VCPU_BOOST_UPDATE, vcpu))
+			record_vcpu_boost_status(vcpu);
+#endif
+
 #ifdef CONFIG_KVM_SMM
 		if (kvm_check_request(KVM_REQ_SMI, vcpu))
 			process_smi(vcpu);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9d3ac7720da9..a74aeea55347 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -167,6 +167,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_VM_DEAD			(1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_UNBLOCK			2
 #define KVM_REQ_DIRTY_RING_SOFT_FULL	3
+#define KVM_REQ_VCPU_BOOST_UPDATE	6
 #define KVM_REQUEST_ARCH_BASE		8
 
 /*
@@ -2287,4 +2288,8 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
 /* Max number of entries allowed for each kvm dirty ring */
 #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
 
+#ifdef CONFIG_PARAVIRT_SCHED_KVM
+void kvm_set_vcpu_boosted(struct kvm_vcpu *vcpu, bool boosted);
+#endif
+
 #endif
-- 
2.43.0


