Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93FCD7A2C37
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 02:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238719AbjIPAc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 20:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238738AbjIPAck (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 20:32:40 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDEA10FA
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:32:01 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-577af71a2a8so2530772a12.3
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 17:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1694824321; x=1695429121; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=B1dRB8XO+KspaRMyC7zp9UYo9xj54whk7JRM1+EstQc=;
        b=b2Q8m1ZZ+34ugEzoopce/wVvpJwHju3GZM8AMZM9sfiFIRHsiUc4YnjWTu2lgU1M13
         0ZPaHi67Xz5Q5XfQY8mBegk7faF59l/FgDguEHLxX4HLFdyLB6UNeTbswYJV/NIRVpVC
         FNJiEjVMLd/xexsSsF3ExC9yQQ3IkUDVRnMf/7TG6QfuXDJCZmwbSJX1hX0NlAYKPeoQ
         cspGVS68nnyEMyVSwkZvx/pt0G/45k/GuIWJPwJqmAfSOUyZquCtLOUPU1YlWSlDRn/h
         0A6qh/ZPDSli2T+i025H0KYTRrn7+jzEYGSNazClftofMavBWBaA3uYfpeqYC8yzLpMm
         r0Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694824321; x=1695429121;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B1dRB8XO+KspaRMyC7zp9UYo9xj54whk7JRM1+EstQc=;
        b=cr11B2Ci0fBmadme0V2SrD90KzIrM2MKf+4CwgZ1mOgVym5ApLIQvFswgwxXL8zMQv
         VtSiVpig6Wbg0XhLTQkAOIOui1JchcaOuADERxmlNV/yZyW9zvu4xZ7Mn4CCgBg7AlwL
         ESh+5G3B6p3AUjJGLKmTHuL/68ERE+Gi6S3mnGU3T7ZRFsW+aXDY7/Sr+VY7ZCwaNmWD
         +0MYPQEdchhLOtgGaoIWDWHtBCrrxa3DE9ZhVfjZImgwL+IAYt/4P3ZkyDFfHe/nlUO1
         LIgI57E3nTpyvT9Lyhw+5UXUXAHzQcBkWyQDHlLF7Nr4mD5xv1Hzjrn6ielUDY0XxABv
         3Oeg==
X-Gm-Message-State: AOJu0Yydzoqd+/yxjFNxi934IC2VZGt4DVPLTjlVx5An5C/DgNqNFh5b
        kH1Yw0S0nEv1U0olxVcHGJnCQEmq/Bk=
X-Google-Smtp-Source: AGHT+IEG3geNQyBEinQ/Gc8L0qGg6gjLTemmwswG1GJ9AY1G6CN5uqCE+2kqm1oXbdjIn4d5e6QeKtFd3X4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:7057:0:b0:574:535:60f with SMTP id
 a23-20020a637057000000b005740535060fmr69376pgn.11.1694824320845; Fri, 15 Sep
 2023 17:32:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Sep 2023 17:31:12 -0700
In-Reply-To: <20230916003118.2540661-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230916003118.2540661-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
Message-ID: <20230916003118.2540661-21-seanjc@google.com>
Subject: [PATCH 20/26] perf/x86: KVM: Have perf define a dedicated struct for
 getting guest PEBS data
From:   Sean Christopherson <seanjc@google.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Anish Ghulati <aghulati@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        Andrew Thornton <andrewth@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Have perf define a struct for getting guest PEBS data from KVM instead of
poking into the kvm_pmu structure.  Passing in an entire "struct kvm_pmu"
_as an opaque pointer_ to get at three fields is silly, especially since
one of the fields exists purely to convey information to perf, i.e. isn't
used by KVM.

Perf should also own its APIs, i.e. define what fields/data it needs, not
rely on KVM to throw fields into data structures that effectively hold
KVM-internal state.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/events/core.c            |  5 +++--
 arch/x86/events/intel/core.c      | 18 +++++++++---------
 arch/x86/events/perf_event.h      |  3 ++-
 arch/x86/include/asm/kvm_host.h   |  9 ---------
 arch/x86/include/asm/perf_event.h | 12 ++++++++++--
 arch/x86/kvm/vmx/pmu_intel.c      | 16 +++++++++++++---
 arch/x86/kvm/vmx/vmx.c            | 10 ++++++----
 arch/x86/kvm/vmx/vmx.h            |  2 +-
 8 files changed, 44 insertions(+), 31 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 185f902e5f28..3b015cfcf41d 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -695,9 +695,10 @@ void x86_pmu_disable_all(void)
 	}
 }
 
-struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data)
+struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr,
+						  struct x86_guest_pebs *guest_pebs)
 {
-	return static_call(x86_pmu_guest_get_msrs)(nr, data);
+	return static_call(x86_pmu_guest_get_msrs)(nr, guest_pebs);
 }
 EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
 
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index fa355d3658a6..9b848d7ebaaf 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -14,7 +14,6 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <linux/nmi.h>
-#include <linux/kvm_host.h>
 
 #include <asm/cpufeature.h>
 #include <asm/hardirq.h>
@@ -4053,11 +4052,11 @@ static int intel_pmu_hw_config(struct perf_event *event)
  * when it uses {RD,WR}MSR, which should be handled by the KVM context,
  * specifically in the intel_pmu_{get,set}_msr().
  */
-static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
+static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr,
+							  struct x86_guest_pebs *guest_pebs)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
-	struct kvm_pmu *kvm_pmu = (struct kvm_pmu *)data;
 	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
 	u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
 	int global_ctrl, pebs_enable;
@@ -4090,20 +4089,20 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 		return arr;
 	}
 
-	if (!kvm_pmu || !x86_pmu.pebs_ept)
+	if (!guest_pebs || !x86_pmu.pebs_ept)
 		return arr;
 
 	arr[(*nr)++] = (struct perf_guest_switch_msr){
 		.msr = MSR_IA32_DS_AREA,
 		.host = (unsigned long)cpuc->ds,
-		.guest = kvm_pmu->ds_area,
+		.guest = guest_pebs->ds_area,
 	};
 
 	if (x86_pmu.intel_cap.pebs_baseline) {
 		arr[(*nr)++] = (struct perf_guest_switch_msr){
 			.msr = MSR_PEBS_DATA_CFG,
 			.host = cpuc->active_pebs_data_cfg,
-			.guest = kvm_pmu->pebs_data_cfg,
+			.guest = guest_pebs->data_cfg,
 		};
 	}
 
@@ -4119,8 +4118,8 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 		arr[pebs_enable].guest = 0;
 	} else {
 		/* Disable guest PEBS thoroughly for cross-mapped PEBS counters. */
-		arr[pebs_enable].guest &= ~kvm_pmu->host_cross_mapped_mask;
-		arr[global_ctrl].guest &= ~kvm_pmu->host_cross_mapped_mask;
+		arr[pebs_enable].guest &= ~guest_pebs->cross_mapped_mask;
+		arr[global_ctrl].guest &= ~guest_pebs->cross_mapped_mask;
 		/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
 		arr[global_ctrl].guest |= arr[pebs_enable].guest;
 	}
@@ -4128,7 +4127,8 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 	return arr;
 }
 
-static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr, void *data)
+static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr,
+							 struct x86_guest_pebs *guest_pebs)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index c8ba2be7585d..d805c9007e35 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -920,7 +920,8 @@ struct x86_pmu {
 	/*
 	 * Intel host/guest support (KVM)
 	 */
-	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr, void *data);
+	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr,
+							struct x86_guest_pebs *guest_pebs);
 
 	/*
 	 * Check period value for PERF_EVENT_IOC_PERIOD ioctl.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1a4def36d5bb..29db870dbaae 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -548,15 +548,6 @@ struct kvm_pmu {
 	u64 pebs_data_cfg;
 	u64 pebs_data_cfg_mask;
 
-	/*
-	 * If a guest counter is cross-mapped to host counter with different
-	 * index, its PEBS capability will be temporarily disabled.
-	 *
-	 * The user should make sure that this mask is updated
-	 * after disabling interrupts and before perf_guest_get_msrs();
-	 */
-	u64 host_cross_mapped_mask;
-
 	/*
 	 * The gate to release perf_events not marked in
 	 * pmc_in_use only once in a vcpu time slice.
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 85a9fd5a3ec3..34c2c9a0b02b 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -564,11 +564,19 @@ static inline void perf_events_lapic_init(void)	{ }
 static inline void perf_check_microcode(void) { }
 #endif
 
+struct x86_guest_pebs {
+	u64	ds_area;
+	u64	data_cfg;
+	u64	cross_mapped_mask;
+};
+
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
-extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data);
+extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr,
+							 struct x86_guest_pebs *guest_pebs);
 extern void x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
 #else
-struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data);
+struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr,
+						  struct x86_guest_pebs *guest_pebs);
 static inline void x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
 {
 	memset(lbr, 0, sizeof(*lbr));
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index f2efa0bf7ae8..3b3929871f7e 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -765,11 +765,20 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 		intel_pmu_release_guest_lbr_event(vcpu);
 }
 
-void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
+u64 intel_pmu_get_cross_mapped_mask(struct kvm_pmu *pmu)
 {
-	struct kvm_pmc *pmc = NULL;
+	u64 host_cross_mapped_mask;
+	struct kvm_pmc *pmc;
 	int bit, hw_idx;
 
+	if (!(pmu->pebs_enable & pmu->global_ctrl))
+		return 0;
+
+	/*
+	 * If a guest counter is cross-mapped to host counter with different
+	 * index, its PEBS capability will be temporarily disabled.
+	 */
+	host_cross_mapped_mask = 0;
 	for_each_set_bit(bit, (unsigned long *)&pmu->global_ctrl,
 			 X86_PMC_IDX_MAX) {
 		pmc = intel_pmc_idx_to_pmc(pmu, bit);
@@ -784,8 +793,9 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 		 */
 		hw_idx = pmc->perf_event->hw.idx;
 		if (hw_idx != pmc->idx && hw_idx > -1)
-			pmu->host_cross_mapped_mask |= BIT_ULL(hw_idx);
+			host_cross_mapped_mask |= BIT_ULL(hw_idx);
 	}
+	return host_cross_mapped_mask;
 }
 
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 72e3943f3693..faf0071566ef 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7131,12 +7131,14 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 	struct perf_guest_switch_msr *msrs;
 	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
 
-	pmu->host_cross_mapped_mask = 0;
-	if (pmu->pebs_enable & pmu->global_ctrl)
-		intel_pmu_cross_mapped_check(pmu);
+	struct x86_guest_pebs guest_pebs = {
+		.ds_area = pmu->ds_area,
+		.data_cfg = pmu->pebs_data_cfg,
+		.cross_mapped_mask = intel_pmu_get_cross_mapped_mask(pmu),
+	};
 
 	/* Note, nr_msrs may be garbage if perf_guest_get_msrs() returns NULL. */
-	msrs = perf_guest_get_msrs(&nr_msrs, (void *)pmu);
+	msrs = perf_guest_get_msrs(&nr_msrs, &guest_pebs);
 	if (!msrs)
 		return;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index c2130d2c8e24..476119670d82 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -670,7 +670,7 @@ static inline bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
 	return !!vcpu_to_lbr_records(vcpu)->nr;
 }
 
-void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
+u64 intel_pmu_get_cross_mapped_mask(struct kvm_pmu *pmu);
 int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
 void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu);
 
-- 
2.42.0.459.ge4e396fd5e-goog

