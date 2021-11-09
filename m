Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A6E44A4DE
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 03:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241797AbhKICmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 21:42:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241555AbhKICmL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 21:42:11 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227DCC061764
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 18:39:26 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id u10-20020a170902e80a00b001421d86afc4so7280492plg.9
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 18:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=T/U2YZ0Dx5Q+ABkERIkOVQhmFwsBS+/GEeXojMLJ6pM=;
        b=I9J44Tlj1l6UKaQ512FvPEzcX1DdGwiz58SWeR+hdVcMW2kTX45ThPl1NP6G3YkSSt
         RzLiXAjoBnLW1ZE2M2dz2sGGmToLOxHF5C4ZN1awF2Dyt1EEoelXsL7P8NYCsjkejH/k
         FAtj8Zj5iWIHfoTIPzEh6lbXozLXbezmh5WFayZnOdaK/SQXvVdVBpwN0fCcmXD1scvb
         Qb7YvoezFgijKnE8C33RITHSDvk70+mTZyff6dxhO+sKFXeO1Ld/ByXOxp6paFfNLVtC
         3KRS7LOAuqVG+GnxgDzQtcVhbett80WMnoidKPgDHvbgX6YSN3OAU1H7+GHzssfC9pYk
         rfdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=T/U2YZ0Dx5Q+ABkERIkOVQhmFwsBS+/GEeXojMLJ6pM=;
        b=bvYpgfW9e3AsiCwqcoH0eZVVfJaTAK7Cv5KNqPzMDjFxDTsf9sBuQF81+kGavSAnC5
         vH7dnGeoeZvbjYmOiE7K63kgZZ9C48vJy0HxPKAbY4RL5SBCSVkEKxZd+miV6lOTHQ7d
         IawFYM4jlhF3tTR5HW4CrdTNP7A4FsRuWXtAwftnbFQALI3S6oYKmt1zWrhbIsfjGiDb
         ocxifUnvpvg9KAWIVJhz/P3YEh0T3lNtIFOoJoeOMsvpGlEyXnbWSkUT5EIyIcneEpR0
         tewm/PplkueObKRrSS5jvPzoBnjblb9vcZvudA/dFT21XyY6m+jWQeTJiETZotW/dYo0
         p7ow==
X-Gm-Message-State: AOAM530hObRMz3oKpY2oysuN0nwu/iM0Mq8bb60rhEq5MCMVW02TCDP2
        GgNgoAcL259LQdv3a/eT1aX3k+4z/8yL5w1Arjl3VGu5RaGWoTKhhBXWy2+1UGH5jT8BAnz18IP
        HZvYRMaSTI/WxcrfzfDBrXbUfi49vEK8KIz2HtI3ZWuA+3GcS+ow0ZzRVQ+/dpP8=
X-Google-Smtp-Source: ABdhPJwo5kDWZp3jsZeKBNmmEeBsUziLE7T5cLkpXYrOwjklN8hbYdHReieIXQbhBJdxHHGG9LZhGj4w72n6sg==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:4ace:: with SMTP id
 mh14mr3347384pjb.164.1636425565565; Mon, 08 Nov 2021 18:39:25 -0800 (PST)
Date:   Mon,  8 Nov 2021 18:38:57 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-9-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 08/17] KVM: selftests: aarch64: cmdline arg to set number of
 IRQs in vgic_irq test
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the ability to specify the number of vIRQs exposed by KVM (arg
defaults to 64). Then extend the KVM_IRQ_LINE test by injecting all
available SPIs at once (specified by the nr-irqs arg). As a bonus,
inject all SGIs at once as well.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/arch_timer.c        |   2 +-
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 149 ++++++++++++++----
 .../selftests/kvm/include/aarch64/vgic.h      |   2 +-
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |   9 +-
 4 files changed, 127 insertions(+), 35 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index bf6a45b0b8dc..9ad38bd360a4 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -382,7 +382,7 @@ static struct kvm_vm *test_vm_create(void)
 
 	ucall_init(vm, NULL);
 	test_init_timer_irq(vm);
-	vgic_v3_setup(vm, nr_vcpus, GICD_BASE_GPA, GICR_BASE_GPA);
+	vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
 
 	/* Make all the test's cmdline args visible to the guest */
 	sync_global_to_guest(vm, test_args);
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index f5d76fef22f0..0b89a29dfe79 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -23,6 +23,14 @@
 #define GICR_BASE_GPA		0x080A0000ULL
 #define VCPU_ID			0
 
+/*
+ * Stores the user specified args; it's passed to the guest and to every test
+ * function.
+ */
+struct test_args {
+	uint32_t nr_irqs; /* number of KVM supported IRQs. */
+};
+
 /*
  * KVM implements 32 priority levels:
  * 0x00 (highest priority) - 0xF8 (lowest priority), in steps of 8
@@ -51,14 +59,18 @@ typedef enum {
 
 struct kvm_inject_args {
 	kvm_inject_cmd cmd;
-	uint32_t intid;
+	uint32_t first_intid;
+	uint32_t num;
 };
 
 /* Used on the guest side to perform the hypercall. */
-static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t intid);
+static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t first_intid, uint32_t num);
 
 #define KVM_INJECT(cmd, intid)							\
-	kvm_inject_call(cmd, intid)
+	kvm_inject_call(cmd, intid, 1)
+
+#define KVM_INJECT_MULTI(cmd, intid, num)					\
+	kvm_inject_call(cmd, intid, num)
 
 /* Used on the host side to get the hypercall info. */
 static void kvm_inject_get_call(struct kvm_vm *vm, struct ucall *uc,
@@ -122,11 +134,12 @@ static void guest_irq_handler(struct ex_regs *regs)
 	GUEST_ASSERT(!gic_irq_get_pending(intid));
 }
 
-static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t intid)
+static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t first_intid, uint32_t num)
 {
 	struct kvm_inject_args args = {
 		.cmd = cmd,
-		.intid = intid,
+		.first_intid = first_intid,
+		.num = num,
 	};
 	GUEST_SYNC(&args);
 }
@@ -138,14 +151,30 @@ do { 										\
 	GUEST_ASSERT(_intid == 0 || _intid == IAR_SPURIOUS);			\
 } while (0)
 
-static void guest_inject(uint32_t intid, kvm_inject_cmd cmd)
+static void reset_priorities(struct test_args *args)
+{
+	int i;
+
+	for (i = 0; i < args->nr_irqs; i++)
+		gic_set_priority(i, IRQ_DEFAULT_PRIO_REG);
+}
+
+static void guest_inject(struct test_args *args,
+		uint32_t first_intid, uint32_t num,
+		kvm_inject_cmd cmd)
 {
+	uint32_t i;
+
 	reset_stats();
 
+	/* Cycle over all priorities to make things more interesting. */
+	for (i = first_intid; i < num + first_intid; i++)
+		gic_set_priority(i, (i % (KVM_NUM_PRIOS - 1)) << 3);
+
 	asm volatile("msr daifset, #2" : : : "memory");
-	KVM_INJECT(cmd, intid);
+	KVM_INJECT_MULTI(cmd, first_intid, num);
 
-	while (irq_handled < 1) {
+	while (irq_handled < num) {
 		asm volatile("wfi\n"
 			     "msr daifclr, #2\n"
 			     /* handle IRQ */
@@ -154,57 +183,72 @@ static void guest_inject(uint32_t intid, kvm_inject_cmd cmd)
 	}
 	asm volatile("msr daifclr, #2" : : : "memory");
 
-	GUEST_ASSERT_EQ(irq_handled, 1);
-	GUEST_ASSERT_EQ(irqnr_received[intid], 1);
+	GUEST_ASSERT_EQ(irq_handled, num);
+	for (i = first_intid; i < num + first_intid; i++)
+		GUEST_ASSERT_EQ(irqnr_received[i], 1);
 	GUEST_ASSERT_IAR_EMPTY();
+
+	reset_priorities(args);
 }
 
-static void test_injection(struct kvm_inject_desc *f)
+static void test_injection(struct test_args *args, struct kvm_inject_desc *f)
 {
-	if (f->sgi)
-		guest_inject(MIN_SGI, f->cmd);
+	uint32_t nr_irqs = args->nr_irqs;
+
+	if (f->sgi) {
+		guest_inject(args, MIN_SGI, 1, f->cmd);
+		guest_inject(args, 0, 16, f->cmd);
+	}
 
 	if (f->ppi)
-		guest_inject(MIN_PPI, f->cmd);
+		guest_inject(args, MIN_PPI, 1, f->cmd);
 
-	if (f->spi)
-		guest_inject(MIN_SPI, f->cmd);
+	if (f->spi) {
+		guest_inject(args, MIN_SPI, 1, f->cmd);
+		guest_inject(args, nr_irqs - 1, 1, f->cmd);
+		guest_inject(args, MIN_SPI, nr_irqs - MIN_SPI, f->cmd);
+	}
 }
 
-static void guest_code(void)
+static void guest_code(struct test_args args)
 {
-	uint32_t i;
-	uint32_t nr_irqs = 64; /* absolute minimum number of IRQs supported. */
+	uint32_t i, nr_irqs = args.nr_irqs;
 	struct kvm_inject_desc *f;
 
 	gic_init(GIC_V3, 1, dist, redist);
 
-	for (i = 0; i < nr_irqs; i++) {
+	for (i = 0; i < nr_irqs; i++)
 		gic_irq_enable(i);
-		gic_set_priority(i, IRQ_DEFAULT_PRIO_REG);
-	}
 
+	reset_priorities(&args);
 	gic_set_priority_mask(CPU_PRIO_MASK);
 
 	local_irq_enable();
 
 	/* Start the tests. */
 	for_each_inject_fn(inject_edge_fns, f)
-		test_injection(f);
+		test_injection(&args, f);
 
 	GUEST_DONE();
 }
 
 static void run_guest_cmd(struct kvm_vm *vm, int gic_fd,
-		struct kvm_inject_args *inject_args)
+		struct kvm_inject_args *inject_args,
+		struct test_args *test_args)
 {
 	kvm_inject_cmd cmd = inject_args->cmd;
-	uint32_t intid = inject_args->intid;
+	uint32_t intid = inject_args->first_intid;
+	uint32_t num = inject_args->num;
+	uint32_t i;
+
+	assert(intid < UINT_MAX - num);
 
 	switch (cmd) {
 	case KVM_INJECT_EDGE_IRQ_LINE:
-		kvm_arm_irq_line(vm, intid, 1);
-		kvm_arm_irq_line(vm, intid, 0);
+		for (i = intid; i < intid + num; i++)
+			kvm_arm_irq_line(vm, i, 1);
+		for (i = intid; i < intid + num; i++)
+			kvm_arm_irq_line(vm, i, 0);
 		break;
 	default:
 		break;
@@ -222,21 +266,35 @@ static void kvm_inject_get_call(struct kvm_vm *vm, struct ucall *uc,
 	memcpy(args, kvm_args_hva, sizeof(struct kvm_inject_args));
 }
 
+static void print_args(struct test_args *args)
+{
+	printf("nr-irqs=%d\n", args->nr_irqs);
+}
 
-static void test_vgic(void)
+static void test_vgic(uint32_t nr_irqs)
 {
 	struct ucall uc;
 	int gic_fd;
 	struct kvm_vm *vm;
 	struct kvm_inject_args inject_args;
 
+	struct test_args args = {
+		.nr_irqs = nr_irqs,
+	};
+
+	print_args(&args);
+
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 	ucall_init(vm, NULL);
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
 
-	gic_fd = vgic_v3_setup(vm, 1, GICD_BASE_GPA, GICR_BASE_GPA);
+	/* Setup the guest args page (so it gets the args). */
+	vcpu_args_set(vm, 0, 1, args);
+
+	gic_fd = vgic_v3_setup(vm, 1, nr_irqs,
+			GICD_BASE_GPA, GICR_BASE_GPA);
 
 	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT,
 			guest_irq_handler);
@@ -247,7 +305,7 @@ static void test_vgic(void)
 		switch (get_ucall(vm, VCPU_ID, &uc)) {
 		case UCALL_SYNC:
 			kvm_inject_get_call(vm, &uc, &inject_args);
-			run_guest_cmd(vm, gic_fd, &inject_args);
+			run_guest_cmd(vm, gic_fd, &inject_args, &args);
 			break;
 		case UCALL_ABORT:
 			TEST_FAIL("%s at %s:%ld\n\tvalues: %#lx, %#lx",
@@ -266,12 +324,39 @@ static void test_vgic(void)
 	kvm_vm_free(vm);
 }
 
-int main(int ac, char **av)
+static void help(const char *name)
 {
+	printf(
+	"\n"
+	"usage: %s [-n num_irqs]\n", name);
+	printf(" -n: specify the number of IRQs to configure the vgic with.\n");
+	puts("");
+	exit(1);
+}
+
+int main(int argc, char **argv)
+{
+	uint32_t nr_irqs = 64;
+	int opt;
+
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	test_vgic();
+	while ((opt = getopt(argc, argv, "hg:n:")) != -1) {
+		switch (opt) {
+		case 'n':
+			nr_irqs = atoi(optarg);
+			if (nr_irqs > 1024 || nr_irqs % 32)
+				help(argv[0]);
+			break;
+		case 'h':
+		default:
+			help(argv[0]);
+			break;
+		}
+	}
+
+	test_vgic(nr_irqs);
 
 	return 0;
 }
diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
index ec8744bb2d4b..ce6f0383c1a1 100644
--- a/tools/testing/selftests/kvm/include/aarch64/vgic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
@@ -14,7 +14,7 @@
 	((uint64_t)(flags) << 12) | \
 	index)
 
-int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus,
+int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
 		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa);
 
 #define VGIC_MAX_RESERVED	1023
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index a1f1f6c8e2e0..84206d7c92b4 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -31,7 +31,7 @@
  * redistributor regions of the guest. Since it depends on the number of
  * vCPUs for the VM, it must be called after all the vCPUs have been created.
  */
-int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus,
+int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
 		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa)
 {
 	int gic_fd;
@@ -53,6 +53,13 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus,
 
 	/* Distributor setup */
 	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+
+	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+			0, &nr_irqs, true);
+
+	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+
 	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 			KVM_VGIC_V3_ADDR_TYPE_DIST, &gicd_base_gpa, true);
 	nr_gic_pages = vm_calc_num_guest_pages(vm->mode, KVM_VGIC_V3_DIST_SIZE);
-- 
2.34.0.rc0.344.g81b53c2807-goog

