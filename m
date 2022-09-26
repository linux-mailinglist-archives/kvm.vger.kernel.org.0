Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF175EAB7C
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 17:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236773AbiIZPpt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 11:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235935AbiIZPpE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 11:45:04 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0751D6CF75;
        Mon, 26 Sep 2022 07:30:08 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id x1-20020a17090ab00100b001fda21bbc90so12594273pjq.3;
        Mon, 26 Sep 2022 07:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=VhCuR+Im+PJHXqYafbxciFezmnJNkbv5MhMQLvCtj7I=;
        b=PrcOEVA9JOBD0PxlTA3P+Iyn486RZkGfTXpvMVdCoIJ57HGZ3CURc4wYpm61J24jve
         DFSKYFxP0BkNEJPT439d0vITLt2JNQ5DavIbLa4LUqi54MGMjuCulDJEI5SngU3K5l1K
         feca+Lf7SPbA+nN7qtFI1O2cZG1u7PxhYtuIlkqBslIolVlvEv3I6Sj0XAWyUGbV9sSu
         EB5QQFlRkx1eHyFBMke6w5ObQAoAeYJxCt9BAvhlmnl6Z9zNlFci8pQ/9os45sQYy9pJ
         gEhZsQ1YawXzYrdI9JyjHpVAnAq/g9q1NobnaZ1wsUKTFsMDL0RDdq/nGreX1r+fvG6E
         wtQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=VhCuR+Im+PJHXqYafbxciFezmnJNkbv5MhMQLvCtj7I=;
        b=Ju3cLRo2d4pE9Ufbgd7h9vJl1oggtuvg7ruz0PqaZMHessZ4H1xrm7bJ0W5D9ybQBX
         B1xXpyNwP8ui+dmeE1ZMhHGe3cHOcWJbBl5H5Lyy6yz7Ixngr21lU6cAaKsX9aVoQMiJ
         qGml0NQCgfD1XgAf8jmXvmIMVC79GfRk/PBCk+dGfeKloRWIsdEGTqISX1eORZOI+tPc
         xAvJPKZ74xo03sUT7LgUmEMc3H/vF9f/CWzArTWixsVxWz4Cvh5KEQo5ugBjcgBRu4MB
         i3e+HAL8A92Yc/gPbFutFlbLLIlnnraYcUWuHytPcevcGnbv424yy4JqF3CyoJmwViAp
         5rtg==
X-Gm-Message-State: ACrzQf3vph6RLQWc7INTrKJ+XM9UTVb2D13RdHWP+UvjbgeQuNYSEMNv
        eyx0Wk5WCjoaUhsg5VpjB3BiGGcqyxvKtg==
X-Google-Smtp-Source: AMsMyM7q3SuE0lwODcOm5tVOZoKN9yoPxoReoDUFmMwiRORDI7cd5/p0l/nIcGjYIGcUUCpiZVhsJA==
X-Received: by 2002:a17:902:c40b:b0:178:e34:efa9 with SMTP id k11-20020a170902c40b00b001780e34efa9mr21576833plk.10.1664202607459;
        Mon, 26 Sep 2022 07:30:07 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id f15-20020aa7968f000000b00543a098a6ffsm12218733pfk.212.2022.09.26.07.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 07:30:07 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH RFC 2/3] KVM + perf: Passing vector into generic perf_handle_guest_intr()
Date:   Mon, 26 Sep 2022 22:29:37 +0800
Message-Id: <20220926142938.89608-3-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926142938.89608-1-likexu@tencent.com>
References: <20220926142938.89608-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

To reuse the interrupt callback function registered by KVM in perf, add
incoming parameter to distinguish the context of the caller, which is
currently only supported in the case of GUEST_INTEL_PT.

No functional change intended.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/events/intel/bts.c     | 1 +
 arch/x86/events/intel/core.c    | 2 +-
 arch/x86/include/asm/kvm_host.h | 7 ++++++-
 arch/x86/kvm/vmx/vmx.c          | 7 +++++--
 include/linux/kvm_host.h        | 2 +-
 include/linux/perf_event.h      | 8 ++++----
 virt/kvm/kvm_main.c             | 2 +-
 7 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/x86/events/intel/bts.c b/arch/x86/events/intel/bts.c
index 974e917e65b2..ffdcde5b97b1 100644
--- a/arch/x86/events/intel/bts.c
+++ b/arch/x86/events/intel/bts.c
@@ -14,6 +14,7 @@
 #include <linux/debugfs.h>
 #include <linux/device.h>
 #include <linux/coredump.h>
+#include <linux/kvm_host.h>
 
 #include <linux/sizes.h>
 #include <asm/perf_event.h>
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 48e313265a15..a7b5237d5a4e 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -2962,7 +2962,7 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
 	 */
 	if (__test_and_clear_bit(GLOBAL_STATUS_TRACE_TOPAPMI_BIT, (unsigned long *)&status)) {
 		handled++;
-		if (!perf_handle_guest_intr())
+		if (!perf_handle_guest_intr(GUEST_INTEL_PT))
 			intel_pt_interrupt();
 	}
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8cf472a4ca06..166a77a61f2d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1661,12 +1661,17 @@ struct kvm_x86_nested_ops {
 	uint16_t (*get_evmcs_version)(struct kvm_vcpu *vcpu);
 };
 
+enum {
+	GUEST_INTEL_PT = 0,
+	GUEST_INVALID
+};
+
 struct kvm_x86_init_ops {
 	int (*cpu_has_kvm_support)(void);
 	int (*disabled_by_bios)(void);
 	int (*check_processor_compatibility)(void);
 	int (*hardware_setup)(void);
-	unsigned int (*handle_intr)(void);
+	unsigned int (*handle_intr)(unsigned int vector);
 
 	struct kvm_x86_ops *runtime_ops;
 	struct kvm_pmu_ops *pmu_ops;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a1856b11467d..3622323d57c2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8146,7 +8146,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 };
 
-static unsigned int vmx_handle_intel_pt_intr(void)
+static unsigned int vmx_handle_guest_intr(unsigned int vector)
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
@@ -8154,6 +8154,9 @@ static unsigned int vmx_handle_intel_pt_intr(void)
 	if (!vcpu || !kvm_handling_nmi_from_guest(vcpu))
 		return 0;
 
+	if (vector >= GUEST_INVALID)
+		return 0;
+
 	kvm_make_request(KVM_REQ_PMI, vcpu);
 	__set_bit(MSR_CORE_PERF_GLOBAL_OVF_CTRL_TRACE_TOPA_PMI_BIT,
 		  (unsigned long *)&vcpu->arch.pmu.global_status);
@@ -8374,7 +8377,7 @@ static __init int hardware_setup(void)
 	if (!enable_ept || !enable_pmu || !cpu_has_vmx_intel_pt())
 		pt_mode = PT_MODE_SYSTEM;
 	if (pt_mode == PT_MODE_HOST_GUEST)
-		vmx_init_ops.handle_intr = vmx_handle_intel_pt_intr;
+		vmx_init_ops.handle_intr = vmx_handle_guest_intr;
 	else
 		vmx_init_ops.handle_intr = NULL;
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f4519d3689e1..91f3752906c5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1555,7 +1555,7 @@ static inline bool kvm_arch_intc_initialized(struct kvm *kvm)
 #ifdef CONFIG_GUEST_PERF_EVENTS
 unsigned long kvm_arch_vcpu_get_ip(struct kvm_vcpu *vcpu);
 
-void kvm_register_perf_callbacks(unsigned int (*pt_intr_handler)(void));
+void kvm_register_perf_callbacks(unsigned int (*handler)(unsigned int flag));
 void kvm_unregister_perf_callbacks(void);
 #else
 static inline void kvm_register_perf_callbacks(void *ign) {}
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6149a977bbd0..a8937d06ff7c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -32,7 +32,7 @@
 struct perf_guest_info_callbacks {
 	unsigned int			(*state)(void);
 	unsigned long			(*get_ip)(void);
-	unsigned int			(*handle_intr)(void);
+	unsigned int			(*handle_intr)(unsigned int flag);
 };
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
@@ -1278,9 +1278,9 @@ static inline unsigned long perf_guest_get_ip(void)
 	return static_call(__perf_guest_get_ip)();
 }
 
-static inline unsigned int perf_handle_guest_intr(void)
+static inline unsigned int perf_handle_guest_intr(unsigned int vector)
 {
-	return static_call(__perf_handle_guest_intr)();
+	return static_call(__perf_handle_guest_intr)(vector);
 }
 
 extern void perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs);
@@ -1288,7 +1288,7 @@ extern void perf_unregister_guest_info_callbacks(struct perf_guest_info_callback
 #else
 static inline unsigned int perf_guest_state(void)		 { return 0; }
 static inline unsigned long perf_guest_get_ip(void)		 { return 0; }
-static inline unsigned int perf_handle_guest_intr(void) { return 0; }
+static inline unsigned int perf_handle_guest_intr(unsigned int vector) { return 0; }
 #endif /* CONFIG_GUEST_PERF_EVENTS */
 
 extern void perf_event_exec(void);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8190af3a12fa..cc46f13bd133 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5788,7 +5788,7 @@ static struct perf_guest_info_callbacks kvm_guest_cbs = {
 	.handle_intr	= NULL,
 };
 
-void kvm_register_perf_callbacks(unsigned int (*handler)(void))
+void kvm_register_perf_callbacks(unsigned int (*handler)(unsigned int vector))
 {
 	kvm_guest_cbs.handle_intr = handler;
 	perf_register_guest_info_callbacks(&kvm_guest_cbs);
-- 
2.37.3

