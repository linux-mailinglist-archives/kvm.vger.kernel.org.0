Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE85853C1DC
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239977AbiFCAoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239980AbiFCAoC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:44:02 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DEDE344DC
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:43:55 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id s10-20020a170902a50a00b00162359521c9so3453032plq.23
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=W6JhbVFxQhSfE2oBmj3ibrg8WXfAqBzUMGf+K0KJSzY=;
        b=prAe5vYIf3Ry91F9BTSC4Sd5C/CPcper7nauQlMhi1YFeseisjaYWVDEQksfhROoVR
         ihvo7pWzfSdGp7qpuJoXU+XtTspJ7ARmvznENmWoFexKH5VVomCLmmTYY+C5maCkCBLO
         LxrptDoNrymn+w3FpKDcmuK8yXZOFVhvUz/btcOtjJy/1OtMrg+kJ+i0CR++W7AO28U4
         2wx1V5XhiJGW+Ha3EzHyKeIPgDd7r2fQFTpdwq2fgZT6bizTwa2dY/gJ78SfHvTeis91
         8aXrWREpvxAlz4cOh0+7slwzWbJ2ILgZSwXeFftB/SzgKIMDz9jzoT7WMu1Mex+BqimI
         dZ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=W6JhbVFxQhSfE2oBmj3ibrg8WXfAqBzUMGf+K0KJSzY=;
        b=T24JgVe6LHCq+pK4WPaeqGD0jdm5ekEBleg+DQOWzZrNZ1jYE/wKy5DjKsEYTBYvBQ
         pDgUW3KALProaZgyEfrR12c4VZJAURCK8eYkwEsx+VZx7RM9PYAo4rgluyKWFkzNzOcr
         2IF7Yq0SxMD6dXoBePjMxPQUjCR5yTw+I6CfKV/M+6d6USV9aroy/3UZYv4Ysr3UQTZ7
         QfHp91qyAhnJ0CY9QuKJfJmCBpQDzHAizcPjYMBst75hZ6rHYB0Dp6A0x0klq44RDAnP
         V7YaIsxKGndgy1JzRQRZXSrCaZy0ZsIn4wunke3wHa/xZzmyvy4tx9ueppX9yEAyOLDk
         FGSw==
X-Gm-Message-State: AOAM532icCfi5K596u+AlNsc6AdO7ff5wZlN7HsmubhqwnkBoBvzJMun
        KY6v0XaEsVfkOUZItXElL1bszPym1I4=
X-Google-Smtp-Source: ABdhPJy4R6SNgApFtMJwx9+DiK1sNArMQg6zi0NCIKm8DjGGIdUOCOEiug7CU4QSS/xoMS7JgvJlAYW2vvk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:ce8a:b0:161:8622:891e with SMTP id
 f10-20020a170902ce8a00b001618622891emr7451724plg.41.1654217034580; Thu, 02
 Jun 2022 17:43:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:41:17 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-11-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 010/144] KVM: sefltests: Use vcpu_ioctl() and
 __vcpu_ioctl() helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the recently introduced vCPU-specific ioctl() helpers instead of
open coding calls to ioctl() just to pretty print the ioctl name.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 142 ++++++---
 .../selftests/kvm/include/x86_64/processor.h  |  28 +-
 .../selftests/kvm/kvm_binary_stats_test.c     |   6 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 286 +-----------------
 .../selftests/kvm/lib/x86_64/processor.c      | 112 +------
 5 files changed, 135 insertions(+), 439 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 314d971c1f06..4f18f03c537f 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -105,8 +105,6 @@ int open_kvm_dev_path_or_exit(void);
 int kvm_check_cap(long cap);
 int vm_check_cap(struct kvm_vm *vm, long cap);
 int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
-int vcpu_enable_cap(struct kvm_vm *vm, uint32_t vcpu_id,
-		    struct kvm_enable_cap *cap);
 void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size);
 const char *vm_guest_mode_string(uint32_t i);
 
@@ -212,13 +210,112 @@ void vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
 int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
 int vcpu_get_fd(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid);
-void vcpu_set_guest_debug(struct kvm_vm *vm, uint32_t vcpuid,
-			  struct kvm_guest_debug *debug);
-void vcpu_set_mp_state(struct kvm_vm *vm, uint32_t vcpuid,
-		       struct kvm_mp_state *mp_state);
 struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vm *vm, uint32_t vcpuid);
-void vcpu_regs_get(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_regs *regs);
-void vcpu_regs_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_regs *regs);
+
+static inline void vcpu_enable_cap(struct kvm_vm *vm, uint32_t vcpu_id,
+				   struct kvm_enable_cap *cap)
+{
+	vcpu_ioctl(vm, vcpu_id, KVM_ENABLE_CAP, cap);
+}
+
+static inline void vcpu_set_guest_debug(struct kvm_vm *vm, uint32_t vcpuid,
+					struct kvm_guest_debug *debug)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_SET_GUEST_DEBUG, debug);
+}
+
+static inline void vcpu_set_mp_state(struct kvm_vm *vm, uint32_t vcpuid,
+				     struct kvm_mp_state *mp_state)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_SET_MP_STATE, mp_state);
+}
+
+static inline void vcpu_regs_get(struct kvm_vm *vm, uint32_t vcpuid,
+				 struct kvm_regs *regs)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_GET_REGS, regs);
+}
+
+static inline void vcpu_regs_set(struct kvm_vm *vm, uint32_t vcpuid,
+				 struct kvm_regs *regs)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_SET_REGS, regs);
+}
+static inline void vcpu_sregs_get(struct kvm_vm *vm, uint32_t vcpuid,
+				  struct kvm_sregs *sregs)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_GET_SREGS, sregs);
+
+}
+static inline void vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
+				  struct kvm_sregs *sregs)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_SET_SREGS, sregs);
+}
+static inline int _vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
+				  struct kvm_sregs *sregs)
+{
+	return __vcpu_ioctl(vm, vcpuid, KVM_SET_SREGS, sregs);
+}
+static inline void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid,
+				struct kvm_fpu *fpu)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_GET_FPU, fpu);
+}
+static inline void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid,
+				struct kvm_fpu *fpu)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_SET_FPU, fpu);
+}
+static inline void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid,
+				struct kvm_one_reg *reg)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, reg);
+}
+static inline void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid,
+				struct kvm_one_reg *reg)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, reg);
+}
+#ifdef __KVM_HAVE_VCPU_EVENTS
+static inline void vcpu_events_get(struct kvm_vm *vm, uint32_t vcpuid,
+				   struct kvm_vcpu_events *events)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_GET_VCPU_EVENTS, events);
+}
+static inline void vcpu_events_set(struct kvm_vm *vm, uint32_t vcpuid,
+				   struct kvm_vcpu_events *events)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_SET_VCPU_EVENTS, events);
+}
+#endif
+#ifdef __x86_64__
+static inline void vcpu_nested_state_get(struct kvm_vm *vm, uint32_t vcpuid,
+					 struct kvm_nested_state *state)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_GET_NESTED_STATE, state);
+}
+static inline int __vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
+					  struct kvm_nested_state *state)
+{
+	return __vcpu_ioctl(vm, vcpuid, KVM_SET_NESTED_STATE, state);
+}
+
+static inline void vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
+					 struct kvm_nested_state *state)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_SET_NESTED_STATE, state);
+}
+#endif
+static inline int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid)
+{
+	int fd = __vcpu_ioctl(vm, vcpuid, KVM_GET_STATS_FD, NULL);
+
+	TEST_ASSERT(fd >= 0, KVM_IOCTL_ERROR(KVM_GET_STATS_FD, fd));
+	return fd;
+}
+
+void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid);
 
 /*
  * VM VCPU Args Set
@@ -240,34 +337,6 @@ void vcpu_regs_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_regs *regs);
  */
 void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...);
 
-void vcpu_sregs_get(struct kvm_vm *vm, uint32_t vcpuid,
-		    struct kvm_sregs *sregs);
-void vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
-		    struct kvm_sregs *sregs);
-int _vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid,
-		    struct kvm_sregs *sregs);
-void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid,
-		  struct kvm_fpu *fpu);
-void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid,
-		  struct kvm_fpu *fpu);
-void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
-void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
-#ifdef __KVM_HAVE_VCPU_EVENTS
-void vcpu_events_get(struct kvm_vm *vm, uint32_t vcpuid,
-		     struct kvm_vcpu_events *events);
-void vcpu_events_set(struct kvm_vm *vm, uint32_t vcpuid,
-		     struct kvm_vcpu_events *events);
-#endif
-#ifdef __x86_64__
-void vcpu_nested_state_get(struct kvm_vm *vm, uint32_t vcpuid,
-			   struct kvm_nested_state *state);
-int __vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
-			    struct kvm_nested_state *state);
-void vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
-			   struct kvm_nested_state *state);
-#endif
-void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid);
-
 int _kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr);
 int kvm_device_check_attr(int dev_fd, uint32_t group, uint64_t attr);
 int _kvm_create_device(struct kvm_vm *vm, uint64_t type, bool test, int *fd);
@@ -406,7 +475,6 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
 
 int vm_get_stats_fd(struct kvm_vm *vm);
-int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
 
 uint32_t guest_get_vcpuid(void);
 
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 4fd870f37b9e..6fbbe28a0f39 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -430,12 +430,19 @@ void kvm_x86_state_cleanup(struct kvm_x86_state *state);
 struct kvm_msr_list *kvm_get_msr_index_list(void);
 uint64_t kvm_get_feature_msr(uint64_t msr_index);
 struct kvm_cpuid2 *kvm_get_supported_cpuid(void);
-
 struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
-int __vcpu_set_cpuid(struct kvm_vm *vm, uint32_t vcpuid,
-		     struct kvm_cpuid2 *cpuid);
-void vcpu_set_cpuid(struct kvm_vm *vm, uint32_t vcpuid,
-		    struct kvm_cpuid2 *cpuid);
+
+static inline int __vcpu_set_cpuid(struct kvm_vm *vm, uint32_t vcpuid,
+				   struct kvm_cpuid2 *cpuid)
+{
+	return __vcpu_ioctl(vm, vcpuid, KVM_SET_CPUID2, cpuid);
+}
+
+static inline void vcpu_set_cpuid(struct kvm_vm *vm, uint32_t vcpuid,
+				  struct kvm_cpuid2 *cpuid)
+{
+	vcpu_ioctl(vm, vcpuid, KVM_SET_CPUID2, cpuid);
+}
 
 struct kvm_cpuid_entry2 *
 kvm_get_supported_cpuid_index(uint32_t function, uint32_t index);
@@ -449,8 +456,15 @@ kvm_get_supported_cpuid_entry(uint32_t function)
 uint64_t vcpu_get_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index);
 int _vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
 		  uint64_t msr_value);
-void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
-	  	  uint64_t msr_value);
+
+static inline void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid,
+				uint64_t msr_index, uint64_t msr_value)
+{
+	int r = _vcpu_set_msr(vm, vcpuid, msr_index, msr_value);
+
+	TEST_ASSERT(r == 1, KVM_IOCTL_ERROR(KVM_SET_MSRS, r));
+}
+
 
 uint32_t kvm_get_cpuid_max_basic(void);
 uint32_t kvm_get_cpuid_max_extended(void);
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index 4b149b383678..bab8b49b52da 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -178,11 +178,7 @@ static void vm_stats_test(struct kvm_vm *vm)
 
 static void vcpu_stats_test(struct kvm_vm *vm, int vcpu_id)
 {
-	int stats_fd;
-
-	/* Get fd for VCPU stats */
-	stats_fd = vcpu_get_stats_fd(vm, vcpu_id);
-	TEST_ASSERT(stats_fd >= 0, "Get VCPU stats fd");
+	int stats_fd = vcpu_get_stats_fd(vm, vcpu_id);
 
 	stats_test(stats_fd);
 	close(stats_fd);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 7b339f98070b..7ac4516d764c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -135,34 +135,6 @@ int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap)
 	return ret;
 }
 
-/* VCPU Enable Capability
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vcpu_id - VCPU
- *   cap - Capability
- *
- * Output Args: None
- *
- * Return: On success, 0. On failure a TEST_ASSERT failure is produced.
- *
- * Enables a capability (KVM_CAP_*) on the VCPU.
- */
-int vcpu_enable_cap(struct kvm_vm *vm, uint32_t vcpu_id,
-		    struct kvm_enable_cap *cap)
-{
-	struct vcpu *vcpu = vcpu_find(vm, vcpu_id);
-	int r;
-
-	TEST_ASSERT(vcpu, "cannot find vcpu %d", vcpu_id);
-
-	r = ioctl(vcpu->fd, KVM_ENABLE_CAP, cap);
-	TEST_ASSERT(!r, "KVM_ENABLE_CAP vCPU ioctl failed,\n"
-			"  rc: %i, errno: %i", r, errno);
-
-	return r;
-}
-
 void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
 {
 	struct kvm_enable_cap cap = { 0 };
@@ -1619,8 +1591,8 @@ struct kvm_run *vcpu_state(struct kvm_vm *vm, uint32_t vcpuid)
 void vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
 {
 	int ret = _vcpu_run(vm, vcpuid);
-	TEST_ASSERT(ret == 0, "KVM_RUN IOCTL failed, "
-		"rc: %i errno: %i", ret, errno);
+
+	TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_RUN, ret));
 }
 
 int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
@@ -1663,43 +1635,6 @@ void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid)
 		    ret, errno);
 }
 
-void vcpu_set_guest_debug(struct kvm_vm *vm, uint32_t vcpuid,
-			  struct kvm_guest_debug *debug)
-{
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-	int ret = ioctl(vcpu->fd, KVM_SET_GUEST_DEBUG, debug);
-
-	TEST_ASSERT(ret == 0, "KVM_SET_GUEST_DEBUG failed: %d", ret);
-}
-
-/*
- * VM VCPU Set MP State
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vcpuid - VCPU ID
- *   mp_state - mp_state to be set
- *
- * Output Args: None
- *
- * Return: None
- *
- * Sets the MP state of the VCPU given by vcpuid, to the state given
- * by mp_state.
- */
-void vcpu_set_mp_state(struct kvm_vm *vm, uint32_t vcpuid,
-		       struct kvm_mp_state *mp_state)
-{
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-	int ret;
-
-	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
-
-	ret = ioctl(vcpu->fd, KVM_SET_MP_STATE, mp_state);
-	TEST_ASSERT(ret == 0, "KVM_SET_MP_STATE IOCTL failed, "
-		"rc: %i errno: %i", ret, errno);
-}
-
 /*
  * VM VCPU Get Reg List
  *
@@ -1729,216 +1664,6 @@ struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vm *vm, uint32_t vcpuid)
 	return reg_list;
 }
 
-/*
- * VM VCPU Regs Get
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vcpuid - VCPU ID
- *
- * Output Args:
- *   regs - current state of VCPU regs
- *
- * Return: None
- *
- * Obtains the current register state for the VCPU specified by vcpuid
- * and stores it at the location given by regs.
- */
-void vcpu_regs_get(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_regs *regs)
-{
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-	int ret;
-
-	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
-
-	ret = ioctl(vcpu->fd, KVM_GET_REGS, regs);
-	TEST_ASSERT(ret == 0, "KVM_GET_REGS failed, rc: %i errno: %i",
-		ret, errno);
-}
-
-/*
- * VM VCPU Regs Set
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vcpuid - VCPU ID
- *   regs - Values to set VCPU regs to
- *
- * Output Args: None
- *
- * Return: None
- *
- * Sets the regs of the VCPU specified by vcpuid to the values
- * given by regs.
- */
-void vcpu_regs_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_regs *regs)
-{
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-	int ret;
-
-	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
-
-	ret = ioctl(vcpu->fd, KVM_SET_REGS, regs);
-	TEST_ASSERT(ret == 0, "KVM_SET_REGS failed, rc: %i errno: %i",
-		ret, errno);
-}
-
-#ifdef __KVM_HAVE_VCPU_EVENTS
-void vcpu_events_get(struct kvm_vm *vm, uint32_t vcpuid,
-		     struct kvm_vcpu_events *events)
-{
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-	int ret;
-
-	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
-
-	ret = ioctl(vcpu->fd, KVM_GET_VCPU_EVENTS, events);
-	TEST_ASSERT(ret == 0, "KVM_GET_VCPU_EVENTS, failed, rc: %i errno: %i",
-		ret, errno);
-}
-
-void vcpu_events_set(struct kvm_vm *vm, uint32_t vcpuid,
-		     struct kvm_vcpu_events *events)
-{
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-	int ret;
-
-	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
-
-	ret = ioctl(vcpu->fd, KVM_SET_VCPU_EVENTS, events);
-	TEST_ASSERT(ret == 0, "KVM_SET_VCPU_EVENTS, failed, rc: %i errno: %i",
-		ret, errno);
-}
-#endif
-
-#ifdef __x86_64__
-void vcpu_nested_state_get(struct kvm_vm *vm, uint32_t vcpuid,
-			   struct kvm_nested_state *state)
-{
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-	int ret;
-
-	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
-
-	ret = ioctl(vcpu->fd, KVM_GET_NESTED_STATE, state);
-	TEST_ASSERT(ret == 0,
-		"KVM_SET_NESTED_STATE failed, ret: %i errno: %i",
-		ret, errno);
-}
-
-int __vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
-			    struct kvm_nested_state *state)
-{
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-
-	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
-
-	return ioctl(vcpu->fd, KVM_SET_NESTED_STATE, state);
-}
-
-void vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
-			   struct kvm_nested_state *state)
-{
-	int ret = __vcpu_nested_state_set(vm, vcpuid, state);
-
-	TEST_ASSERT(!ret, "KVM_SET_NESTED_STATE failed, ret: %i errno: %i", ret, errno);
-}
-#endif
-
-/*
- * VM VCPU System Regs Get
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vcpuid - VCPU ID
- *
- * Output Args:
- *   sregs - current state of VCPU system regs
- *
- * Return: None
- *
- * Obtains the current system register state for the VCPU specified by
- * vcpuid and stores it at the location given by sregs.
- */
-void vcpu_sregs_get(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_sregs *sregs)
-{
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-	int ret;
-
-	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
-
-	ret = ioctl(vcpu->fd, KVM_GET_SREGS, sregs);
-	TEST_ASSERT(ret == 0, "KVM_GET_SREGS failed, rc: %i errno: %i",
-		ret, errno);
-}
-
-/*
- * VM VCPU System Regs Set
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vcpuid - VCPU ID
- *   sregs - Values to set VCPU system regs to
- *
- * Output Args: None
- *
- * Return: None
- *
- * Sets the system regs of the VCPU specified by vcpuid to the values
- * given by sregs.
- */
-void vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_sregs *sregs)
-{
-	int ret = _vcpu_sregs_set(vm, vcpuid, sregs);
-	TEST_ASSERT(ret == 0, "KVM_SET_SREGS IOCTL failed, "
-		"rc: %i errno: %i", ret, errno);
-}
-
-int _vcpu_sregs_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_sregs *sregs)
-{
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-
-	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
-
-	return ioctl(vcpu->fd, KVM_SET_SREGS, sregs);
-}
-
-void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
-{
-	int ret;
-
-	ret = __vcpu_ioctl(vm, vcpuid, KVM_GET_FPU, fpu);
-	TEST_ASSERT(ret == 0, "KVM_GET_FPU failed, rc: %i errno: %i (%s)",
-		    ret, errno, strerror(errno));
-}
-
-void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
-{
-	int ret;
-
-	ret = __vcpu_ioctl(vm, vcpuid, KVM_SET_FPU, fpu);
-	TEST_ASSERT(ret == 0, "KVM_SET_FPU failed, rc: %i errno: %i (%s)",
-		    ret, errno, strerror(errno));
-}
-
-void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
-{
-	int ret;
-
-	ret = __vcpu_ioctl(vm, vcpuid, KVM_GET_ONE_REG, reg);
-	TEST_ASSERT(ret == 0, "KVM_GET_ONE_REG failed, rc: %i errno: %i (%s)",
-		    ret, errno, strerror(errno));
-}
-
-void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
-{
-	int ret;
-
-	ret = __vcpu_ioctl(vm, vcpuid, KVM_SET_ONE_REG, reg);
-	TEST_ASSERT(ret == 0, "KVM_SET_ONE_REG failed, rc: %i errno: %i (%s)",
-		    ret, errno, strerror(errno));
-}
-
 int __vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid,
 		 unsigned long cmd, void *arg)
 {
@@ -2534,10 +2259,3 @@ int vm_get_stats_fd(struct kvm_vm *vm)
 {
 	return ioctl(vm->fd, KVM_GET_STATS_FD, NULL);
 }
-
-int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid)
-{
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-
-	return ioctl(vcpu->fd, KVM_GET_STATS_FD, NULL);
-}
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 33ea5e9955d9..27c40b5ab01d 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -803,18 +803,15 @@ uint64_t kvm_get_feature_msr(uint64_t msr_index)
  */
 struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vm *vm, uint32_t vcpuid)
 {
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
 	struct kvm_cpuid2 *cpuid;
 	int max_ent;
 	int rc = -1;
 
-	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
-
 	cpuid = allocate_kvm_cpuid2();
 	max_ent = cpuid->nent;
 
 	for (cpuid->nent = 1; cpuid->nent <= max_ent; cpuid->nent++) {
-		rc = ioctl(vcpu->fd, KVM_GET_CPUID2, cpuid);
+		rc = __vcpu_ioctl(vm, vcpuid, KVM_GET_CPUID2, cpuid);
 		if (!rc)
 			break;
 
@@ -823,9 +820,7 @@ struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vm *vm, uint32_t vcpuid)
 			    rc, errno);
 	}
 
-	TEST_ASSERT(rc == 0, "KVM_GET_CPUID2 failed, rc: %i errno: %i",
-		    rc, errno);
-
+	TEST_ASSERT(!rc, KVM_IOCTL_ERROR(KVM_GET_CPUID2, rc));
 	return cpuid;
 }
 
@@ -863,132 +858,37 @@ kvm_get_supported_cpuid_index(uint32_t function, uint32_t index)
 	return entry;
 }
 
-
-int __vcpu_set_cpuid(struct kvm_vm *vm, uint32_t vcpuid,
-		     struct kvm_cpuid2 *cpuid)
-{
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
-
-	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
-
-	return ioctl(vcpu->fd, KVM_SET_CPUID2, cpuid);
-}
-
-/*
- * VM VCPU CPUID Set
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vcpuid - VCPU id
- *   cpuid - The CPUID values to set.
- *
- * Output Args: None
- *
- * Return: void
- *
- * Set the VCPU's CPUID.
- */
-void vcpu_set_cpuid(struct kvm_vm *vm,
-		uint32_t vcpuid, struct kvm_cpuid2 *cpuid)
-{
-	int rc;
-
-	rc = __vcpu_set_cpuid(vm, vcpuid, cpuid);
-	TEST_ASSERT(rc == 0, "KVM_SET_CPUID2 failed, rc: %i errno: %i",
-		    rc, errno);
-
-}
-
-/*
- * VCPU Get MSR
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vcpuid - VCPU ID
- *   msr_index - Index of MSR
- *
- * Output Args: None
- *
- * Return: On success, value of the MSR. On failure a TEST_ASSERT is produced.
- *
- * Get value of MSR for VCPU.
- */
 uint64_t vcpu_get_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index)
 {
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
 	struct {
 		struct kvm_msrs header;
 		struct kvm_msr_entry entry;
 	} buffer = {};
 	int r;
 
-	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
 	buffer.header.nmsrs = 1;
 	buffer.entry.index = msr_index;
-	r = ioctl(vcpu->fd, KVM_GET_MSRS, &buffer.header);
-	TEST_ASSERT(r == 1, "KVM_GET_MSRS IOCTL failed,\n"
-		"  rc: %i errno: %i", r, errno);
+
+	r = __vcpu_ioctl(vm, vcpuid, KVM_GET_MSRS, &buffer.header);
+	TEST_ASSERT(r == 1, KVM_IOCTL_ERROR(KVM_GET_MSRS, r));
 
 	return buffer.entry.data;
 }
 
-/*
- * _VCPU Set MSR
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vcpuid - VCPU ID
- *   msr_index - Index of MSR
- *   msr_value - New value of MSR
- *
- * Output Args: None
- *
- * Return: The result of KVM_SET_MSRS.
- *
- * Sets the value of an MSR for the given VCPU.
- */
 int _vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
 		  uint64_t msr_value)
 {
-	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
 	struct {
 		struct kvm_msrs header;
 		struct kvm_msr_entry entry;
 	} buffer = {};
-	int r;
 
-	TEST_ASSERT(vcpu != NULL, "vcpu not found, vcpuid: %u", vcpuid);
 	memset(&buffer, 0, sizeof(buffer));
 	buffer.header.nmsrs = 1;
 	buffer.entry.index = msr_index;
 	buffer.entry.data = msr_value;
-	r = ioctl(vcpu->fd, KVM_SET_MSRS, &buffer.header);
-	return r;
-}
 
-/*
- * VCPU Set MSR
- *
- * Input Args:
- *   vm - Virtual Machine
- *   vcpuid - VCPU ID
- *   msr_index - Index of MSR
- *   msr_value - New value of MSR
- *
- * Output Args: None
- *
- * Return: On success, nothing. On failure a TEST_ASSERT is produced.
- *
- * Set value of MSR for VCPU.
- */
-void vcpu_set_msr(struct kvm_vm *vm, uint32_t vcpuid, uint64_t msr_index,
-	uint64_t msr_value)
-{
-	int r;
-
-	r = _vcpu_set_msr(vm, vcpuid, msr_index, msr_value);
-	TEST_ASSERT(r == 1, "KVM_SET_MSRS IOCTL failed,\n"
-		"  rc: %i errno: %i", r, errno);
+	return __vcpu_ioctl(vm, vcpuid, KVM_SET_MSRS, &buffer.header);
 }
 
 void vcpu_args_set(struct kvm_vm *vm, uint32_t vcpuid, unsigned int num, ...)
-- 
2.36.1.255.ge46751e96f-goog

