Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1889753C2E2
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234734AbiFCA4W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241445AbiFCAvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:51:06 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D6137AB8
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:56 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id c4-20020a170902c2c400b0015f16fb4a54so3469038pla.22
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=JWFE/jjOXHS1mFvFYygFdMopCxVjk77rB6nYuDplK34=;
        b=aUM4pGmPqNHYIGZyunuBfnVyKE/+oQ1ITUTUXye1SmORNwFqYZX7NHMUBNgzFWdToc
         3E4oWJ4BBNPfvz1wBle+5PXlz1/UNk+8ehuHKSPznbHskPeqSYzkczUgQw82NCaILca7
         g2FXzqxBZYzfgj5yy+4vJ8ymST2txyLXTrOHR+KqGZOHDgvGFUsyV9IGLnWQ44AvMkf0
         0obyQBX1owuDLKvrrHyWj5bWnHij6SgS1pQreu+Tkge7wnGzGjJ7Q4GN9foOlzp5KStn
         SOoeX+tWpZxXp0dA4T2Y/7CgoYMnzkKKFjKSrRyD7QY1EqCA6ekh8kDCC/aQVMJN+/HY
         2hcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=JWFE/jjOXHS1mFvFYygFdMopCxVjk77rB6nYuDplK34=;
        b=u8NDSRlxbb9/BrzFT0Fbggs28qMwotSHTU3BEk0FRRPoYbyxw4rfEk/0jyOKNRD+YI
         d3XW1RvgVzEYkUKbM3/CkFu9DR1Pq0CHBNmNGACfhEWKltSVHtoCGVT2XyP2JllB4LXK
         urdKmpBfOcdSBHd9itq0m09c/gmo3zlcZ2apEQKtZFyxbWn10tDJ8GSa7ahmF9l8WVp7
         y6U1TryR9ZU5m3KJTgbfQmTenv37JsGU1Z/FmeSBNz/QQRjqVaRCDDdx55oMIK6rDpWI
         v5+EXTmflA3d65QlZMqDaOZVTP37DO+ujNVKk9SnekcgQ/Y8Hfdm0KL4ohikQQH3Md/P
         Z5vg==
X-Gm-Message-State: AOAM532Wzvi8XnelyEFVmhtn3AWibfscjgN59E2rcwnrWToh189O3z1l
        KfxGoxtuqawTy/eVCAAYIWKa1eUcR9I=
X-Google-Smtp-Source: ABdhPJxhm+WJm0+KtPscOsIcz90Ey/7Ta5KlCastPuv974OLtLpiVNimkyfuc6Zay1MDTyERZWvWtB+4oe0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:8f86:b0:162:22ff:496b with SMTP id
 z6-20020a1709028f8600b0016222ff496bmr7288600plo.105.1654217275704; Thu, 02
 Jun 2022 17:47:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:31 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-145-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 144/144] KVM: selftests: Sanity check input to ioctls() at
 build time
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

Add a static assert to the KVM/VM/vCPU ioctl() helpers to verify that the
size of the argument provided matches the expected size of the IOCTL.
Because ioctl() ultimately takes a "void *", it's all too easy to pass in
garbage and not detect the error until runtime.  E.g. while working on a
CPUID rework, selftests happily compiled when vcpu_set_cpuid()
unintentionally passed the cpuid() function as the parameter to ioctl()
(a local "cpuid" parameter was removed, but its use was not replaced with
"vcpu->cpuid" as intended).

Tweak a variety of benign issues that aren't compatible with the sanity
check, e.g. passing a non-pointer for ioctls().

Note, static_assert() requires a string on older versions of GCC.  Feed
it an empty string to make the compiler happy.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     | 61 +++++++++++++------
 .../selftests/kvm/lib/aarch64/processor.c     |  2 +-
 tools/testing/selftests/kvm/lib/guest_modes.c |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c    | 29 +--------
 tools/testing/selftests/kvm/s390x/resets.c    |  6 +-
 .../selftests/kvm/x86_64/mmio_warning_test.c  |  2 +-
 .../kvm/x86_64/pmu_event_filter_test.c        |  2 +-
 .../selftests/kvm/x86_64/xen_shinfo_test.c    |  6 +-
 8 files changed, 56 insertions(+), 54 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 04ddab322b6b..0eaf0c9b7612 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -180,29 +180,56 @@ static inline bool kvm_has_cap(long cap)
 #define __KVM_IOCTL_ERROR(_name, _ret)	__KVM_SYSCALL_ERROR(_name, _ret)
 #define KVM_IOCTL_ERROR(_ioctl, _ret) __KVM_IOCTL_ERROR(#_ioctl, _ret)
 
-#define __kvm_ioctl(kvm_fd, cmd, arg) \
-	ioctl(kvm_fd, cmd, arg)
+#define kvm_do_ioctl(fd, cmd, arg)						\
+({										\
+	static_assert(!_IOC_SIZE(cmd) || sizeof(*arg) == _IOC_SIZE(cmd), "");	\
+	ioctl(fd, cmd, arg);							\
+})
 
-static inline void _kvm_ioctl(int kvm_fd, unsigned long cmd, const char *name,
-			      void *arg)
-{
-	int ret = __kvm_ioctl(kvm_fd, cmd, arg);
+#define __kvm_ioctl(kvm_fd, cmd, arg)						\
+	kvm_do_ioctl(kvm_fd, cmd, arg)
 
-	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));
-}
+
+#define _kvm_ioctl(kvm_fd, cmd, name, arg)					\
+({										\
+	int ret = __kvm_ioctl(kvm_fd, cmd, arg);				\
+										\
+	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));			\
+})
 
 #define kvm_ioctl(kvm_fd, cmd, arg) \
 	_kvm_ioctl(kvm_fd, cmd, #cmd, arg)
 
-int __vm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg);
-void _vm_ioctl(struct kvm_vm *vm, unsigned long cmd, const char *name, void *arg);
-#define vm_ioctl(vm, cmd, arg) _vm_ioctl(vm, cmd, #cmd, arg)
-
-int __vcpu_ioctl(struct kvm_vcpu *vcpu, unsigned long cmd,
-		 void *arg);
-void _vcpu_ioctl(struct kvm_vcpu *vcpu, unsigned long cmd,
-		 const char *name, void *arg);
-#define vcpu_ioctl(vcpu, cmd, arg) \
+#define __vm_ioctl(vm, cmd, arg)						\
+({										\
+	static_assert(sizeof(*(vm)) == sizeof(struct kvm_vm), "");		\
+	kvm_do_ioctl((vm)->fd, cmd, arg);					\
+})
+
+#define _vm_ioctl(vcpu, cmd, name, arg)						\
+({										\
+	int ret = __vm_ioctl(vcpu, cmd, arg);					\
+										\
+	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));			\
+})
+
+#define vm_ioctl(vm, cmd, arg)							\
+	_vm_ioctl(vm, cmd, #cmd, arg)
+
+#define __vcpu_ioctl(vcpu, cmd, arg)						\
+({										\
+	static_assert(sizeof(*(vcpu)) == sizeof(struct kvm_vcpu), "");		\
+	kvm_do_ioctl((vcpu)->fd, cmd, arg);					\
+})
+
+#define _vcpu_ioctl(vcpu, cmd, name, arg)					\
+({										\
+	int ret = __vcpu_ioctl(vcpu, cmd, arg);					\
+										\
+	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));			\
+})
+
+#define vcpu_ioctl(vcpu, cmd, arg)						\
 	_vcpu_ioctl(vcpu, cmd, #cmd, arg)
 
 /*
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 6bd27782f00c..6f5551368944 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -472,7 +472,7 @@ void aarch64_get_supported_page_sizes(uint32_t ipa,
 	};
 
 	kvm_fd = open_kvm_dev_path_or_exit();
-	vm_fd = __kvm_ioctl(kvm_fd, KVM_CREATE_VM, ipa);
+	vm_fd = __kvm_ioctl(kvm_fd, KVM_CREATE_VM, (void *)(unsigned long)ipa);
 	TEST_ASSERT(vm_fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VM, vm_fd));
 
 	vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);
diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
index 0be56c63aed6..99a575bbbc52 100644
--- a/tools/testing/selftests/kvm/lib/guest_modes.c
+++ b/tools/testing/selftests/kvm/lib/guest_modes.c
@@ -65,7 +65,7 @@ void guest_modes_append_default(void)
 		struct kvm_s390_vm_cpu_processor info;
 
 		kvm_fd = open_kvm_dev_path_or_exit();
-		vm_fd = __kvm_ioctl(kvm_fd, KVM_CREATE_VM, 0);
+		vm_fd = __kvm_ioctl(kvm_fd, KVM_CREATE_VM, NULL);
 		kvm_device_attr_get(vm_fd, KVM_S390_VM_CPU_MODEL,
 				    KVM_S390_VM_CPU_PROCESSOR, &info);
 		close(vm_fd);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 603a6d529357..f0300767df16 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -72,7 +72,7 @@ unsigned int kvm_check_cap(long cap)
 	int kvm_fd;
 
 	kvm_fd = open_kvm_dev_path_or_exit();
-	ret = __kvm_ioctl(kvm_fd, KVM_CHECK_EXTENSION, cap);
+	ret = __kvm_ioctl(kvm_fd, KVM_CHECK_EXTENSION, (void *)cap);
 	TEST_ASSERT(ret >= 0, KVM_IOCTL_ERROR(KVM_CHECK_EXTENSION, ret));
 
 	close(kvm_fd);
@@ -92,7 +92,7 @@ static void vm_open(struct kvm_vm *vm)
 
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_IMMEDIATE_EXIT));
 
-	vm->fd = __kvm_ioctl(vm->kvm_fd, KVM_CREATE_VM, vm->type);
+	vm->fd = __kvm_ioctl(vm->kvm_fd, KVM_CREATE_VM, (void *)vm->type);
 	TEST_ASSERT(vm->fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_VM, vm->fd));
 }
 
@@ -1449,19 +1449,6 @@ struct kvm_reg_list *vcpu_get_reg_list(struct kvm_vcpu *vcpu)
 	return reg_list;
 }
 
-int __vcpu_ioctl(struct kvm_vcpu *vcpu, unsigned long cmd, void *arg)
-{
-	return ioctl(vcpu->fd, cmd, arg);
-}
-
-void _vcpu_ioctl(struct kvm_vcpu *vcpu, unsigned long cmd, const char *name,
-		 void *arg)
-{
-	int ret = __vcpu_ioctl(vcpu, cmd, arg);
-
-	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));
-}
-
 void *vcpu_map_dirty_ring(struct kvm_vcpu *vcpu)
 {
 	uint32_t page_size = vcpu->vm->page_size;
@@ -1491,18 +1478,6 @@ void *vcpu_map_dirty_ring(struct kvm_vcpu *vcpu)
 	return vcpu->dirty_gfns;
 }
 
-int __vm_ioctl(struct kvm_vm *vm, unsigned long cmd, void *arg)
-{
-	return ioctl(vm->fd, cmd, arg);
-}
-
-void _vm_ioctl(struct kvm_vm *vm, unsigned long cmd, const char *name, void *arg)
-{
-	int ret = __vm_ioctl(vm, cmd, arg);
-
-	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(name, ret));
-}
-
 /*
  * Device Ioctl
  */
diff --git a/tools/testing/selftests/kvm/s390x/resets.c b/tools/testing/selftests/kvm/s390x/resets.c
index 4ba866047401..359fd18f473b 100644
--- a/tools/testing/selftests/kvm/s390x/resets.c
+++ b/tools/testing/selftests/kvm/s390x/resets.c
@@ -224,7 +224,7 @@ static void test_normal(void)
 
 	inject_irq(vcpu);
 
-	vcpu_ioctl(vcpu, KVM_S390_NORMAL_RESET, 0);
+	vcpu_ioctl(vcpu, KVM_S390_NORMAL_RESET, NULL);
 
 	/* must clears */
 	assert_normal(vcpu);
@@ -247,7 +247,7 @@ static void test_initial(void)
 
 	inject_irq(vcpu);
 
-	vcpu_ioctl(vcpu, KVM_S390_INITIAL_RESET, 0);
+	vcpu_ioctl(vcpu, KVM_S390_INITIAL_RESET, NULL);
 
 	/* must clears */
 	assert_normal(vcpu);
@@ -270,7 +270,7 @@ static void test_clear(void)
 
 	inject_irq(vcpu);
 
-	vcpu_ioctl(vcpu, KVM_S390_CLEAR_RESET, 0);
+	vcpu_ioctl(vcpu, KVM_S390_CLEAR_RESET, NULL);
 
 	/* must clears */
 	assert_normal(vcpu);
diff --git a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
index 0e4590afd0e1..fb02581953a3 100644
--- a/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
+++ b/tools/testing/selftests/kvm/x86_64/mmio_warning_test.c
@@ -59,7 +59,7 @@ void test(void)
 
 	kvm = open("/dev/kvm", O_RDWR);
 	TEST_ASSERT(kvm != -1, "failed to open /dev/kvm");
-	kvmvm = __kvm_ioctl(kvm, KVM_CREATE_VM, 0);
+	kvmvm = __kvm_ioctl(kvm, KVM_CREATE_VM, NULL);
 	TEST_ASSERT(kvmvm > 0, KVM_IOCTL_ERROR(KVM_CREATE_VM, kvmvm));
 	kvmcpu = ioctl(kvmvm, KVM_CREATE_VCPU, 0);
 	TEST_ASSERT(kvmcpu != -1, KVM_IOCTL_ERROR(KVM_CREATE_VCPU, kvmcpu));
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index de9ee00d84cf..66930384ef97 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -266,7 +266,7 @@ static void test_without_filter(struct kvm_vcpu *vcpu)
 static uint64_t test_with_filter(struct kvm_vcpu *vcpu,
 				 struct kvm_pmu_event_filter *f)
 {
-	vm_ioctl(vcpu->vm, KVM_SET_PMU_EVENT_FILTER, (void *)f);
+	vm_ioctl(vcpu->vm, KVM_SET_PMU_EVENT_FILTER, f);
 	return run_vcpu_to_sync(vcpu);
 }
 
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index bdcb28186ccc..a4a78637c35a 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -472,7 +472,7 @@ int main(int argc, char *argv[])
 		irq_routes.entries[1].u.xen_evtchn.vcpu = vcpu->id;
 		irq_routes.entries[1].u.xen_evtchn.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
 
-		vm_ioctl(vm, KVM_SET_GSI_ROUTING, &irq_routes);
+		vm_ioctl(vm, KVM_SET_GSI_ROUTING, &irq_routes.info);
 
 		struct kvm_irqfd ifd = { };
 
@@ -716,7 +716,7 @@ int main(int argc, char *argv[])
 				if (verbose)
 					printf("Testing restored oneshot timer\n");
 
-				tmr.u.timer.expires_ns = rs->state_entry_time + 100000000,
+				tmr.u.timer.expires_ns = rs->state_entry_time + 100000000;
 				vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &tmr);
 				evtchn_irq_expected = true;
 				alarm(1);
@@ -743,7 +743,7 @@ int main(int argc, char *argv[])
 				if (verbose)
 					printf("Testing SCHEDOP_poll wake on masked event\n");
 
-				tmr.u.timer.expires_ns = rs->state_entry_time + 100000000,
+				tmr.u.timer.expires_ns = rs->state_entry_time + 100000000;
 				vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &tmr);
 				alarm(1);
 				break;
-- 
2.36.1.255.ge46751e96f-goog

