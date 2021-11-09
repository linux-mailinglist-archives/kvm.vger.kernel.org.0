Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C30C44A4E4
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 03:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241882AbhKICmT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 21:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241802AbhKICmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 21:42:16 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D01FC061570
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 18:39:31 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id j3-20020a628003000000b004811bc66186so11991536pfd.5
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 18:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gm/CRNjGjObMWonwa5W/nHZic3GC4NyZisHGpLvhyc8=;
        b=jg7R31HslzvC6WTkqWsMFWssSX7fbPtphmW/TRdpNjnirQ3H99s7xKyNOZ84ofrMcA
         QpzHH9Cnji7GWRlIXp5JGEXTzog5Ltq+nEEdlmq3pH52nHBYgbImdsAhud0GiRPcxIrp
         GQ6kMjr+G4MAaUcouPEpkQjVe+psk0N6A2x7FVfiPL2Vsz3dH1+q1PeS0Rzby9GAj8UQ
         OFkP6t6z9bLLEY/KiwlpXBSVlnFku9LBL/hnuXBFaA3/MF2CRRxgBfXhYDmKzT1GS510
         TSUzPjuVYH6j4ad9bPukukVLRzpAM8BtvsTIltCKPNBzh7kk0ECuiTKO8OweVkj57dou
         D3uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gm/CRNjGjObMWonwa5W/nHZic3GC4NyZisHGpLvhyc8=;
        b=Vnw7Nxp+qJHvEwD4cB9DBad6qB70lCUzuOxqXVIH5Q3jl5Fo7daYhPZl962WwkXLda
         qM/uoYIBCcQW1SBE0/H2J9yfwpIs7qnrpUi2RZMbnFW936eOhgS0DgKM73rcnunptjVF
         bYMjzr3M433jx8nS9/WbTlTXZmJVRoYEg0DyJZo0j7OFwh2KCcD/HIF4nDhFv/lXdJ8v
         Y1r8FZChdxfqquwFxVtsan14OP28/whMlMpu0qYCIbrGfqzuYBtySSYFZ9wlqzw3PFtD
         ucJJLpdaHWVpfUI4V7sksnBYma77z2gucvfBYn4O6VuVgVjMNE1dpnbcb4ptVopLanzj
         q45A==
X-Gm-Message-State: AOAM530p6rxNpv7RqBL6UgmRDcrCC9/QPj2MKke9DXWSmb5kAHMyK+UW
        T6D+CEs3KqKv6rIBxEtnoFWrUs9wwiuxfqNU3pJhQG5D+xi293Zd0ltRk5M3Xas9LLcYIcnfOcI
        p9f3FTXGRuj8DYvGrfgq1uu3/AzeeVFWfa45a9SfEp/EpPe6nsFMzFgIXWMXBizA=
X-Google-Smtp-Source: ABdhPJzhJP7M/gay4oj9KOwF1d5OYBITCKFBVyKsSkoXq9DGjtvLfZlQXywp8op82b7ujQciv32QjtD4lcLrIw==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:e806:b0:142:830:eaa4 with SMTP id
 u6-20020a170902e80600b001420830eaa4mr3808196plg.16.1636425570433; Mon, 08 Nov
 2021 18:39:30 -0800 (PST)
Date:   Mon,  8 Nov 2021 18:39:00 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-12-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 11/17] KVM: selftests: aarch64: level-sensitive interrupts
 tests in vgic_irq
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

Add a cmdline arg for using level-sensitive interrupts (vs the default
edge-triggered). Then move the handler into a generic handler function
that takes the type of interrupt (level vs. edge) as an arg.  When
handling line-sensitive interrupts it sets the line to low after
acknowledging the IRQ.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 118 +++++++++++++-----
 1 file changed, 86 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index b9080aa75a14..a20d225367a1 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -30,6 +30,7 @@
 struct test_args {
 	uint32_t nr_irqs; /* number of KVM supported IRQs. */
 	bool eoi_split; /* 1 is eoir+dir, 0 is eoir only */
+	bool level_sensitive; /* 1 is level, 0 is edge */
 };
 
 /*
@@ -57,27 +58,31 @@ static void *redist = (void *)GICR_BASE_GPA;
 
 typedef enum {
 	KVM_INJECT_EDGE_IRQ_LINE = 1,
+	KVM_SET_IRQ_LINE,
+	KVM_SET_IRQ_LINE_HIGH,
 } kvm_inject_cmd;
 
 struct kvm_inject_args {
 	kvm_inject_cmd cmd;
 	uint32_t first_intid;
 	uint32_t num;
+	int level;
 };
 
 /* Used on the guest side to perform the hypercall. */
-static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t first_intid, uint32_t num);
-
-#define KVM_INJECT(cmd, intid)							\
-	kvm_inject_call(cmd, intid, 1)
-
-#define KVM_INJECT_MULTI(cmd, intid, num)					\
-	kvm_inject_call(cmd, intid, num)
+static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t first_intid,
+			uint32_t num, int level);
 
 /* Used on the host side to get the hypercall info. */
 static void kvm_inject_get_call(struct kvm_vm *vm, struct ucall *uc,
 		struct kvm_inject_args *args);
 
+#define KVM_INJECT(cmd, intid)							\
+	kvm_inject_call(cmd, intid, 1, -1 /* not used */)
+
+#define KVM_INJECT_MULTI(cmd, intid, num)					\
+	kvm_inject_call(cmd, intid, num, -1 /* not used */)
+
 struct kvm_inject_desc {
 	kvm_inject_cmd cmd;
 	/* can inject PPIs, PPIs, and/or SPIs. */
@@ -90,6 +95,12 @@ static struct kvm_inject_desc inject_edge_fns[] = {
 	{ 0, },
 };
 
+static struct kvm_inject_desc inject_level_fns[] = {
+	/*                                      sgi    ppi    spi */
+	{ KVM_SET_IRQ_LINE_HIGH,		false, true,  true },
+	{ 0, },
+};
+
 #define for_each_inject_fn(t, f)						\
 	for ((f) = (t); (f)->cmd; (f)++)
 
@@ -114,7 +125,9 @@ static uint64_t gic_read_ap1r0(void)
 	return reg;
 }
 
-static void guest_irq_generic_handler(bool eoi_split)
+static void guest_set_irq_line(uint32_t intid, uint32_t level);
+
+static void guest_irq_generic_handler(bool eoi_split, bool level_sensitive)
 {
 	uint32_t intid = gic_get_and_ack_irq();
 
@@ -123,7 +136,11 @@ static void guest_irq_generic_handler(bool eoi_split)
 
 	GUEST_ASSERT(gic_irq_get_active(intid));
 
-	GUEST_ASSERT(!gic_irq_get_pending(intid));
+	if (!level_sensitive)
+		GUEST_ASSERT(!gic_irq_get_pending(intid));
+
+	if (level_sensitive)
+		guest_set_irq_line(intid, 0);
 
 	GUEST_ASSERT(intid < MAX_SPI);
 	irqnr_received[intid] += 1;
@@ -138,12 +155,14 @@ static void guest_irq_generic_handler(bool eoi_split)
 	GUEST_ASSERT(!gic_irq_get_pending(intid));
 }
 
-static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t first_intid, uint32_t num)
+static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t first_intid,
+			uint32_t num, int level)
 {
 	struct kvm_inject_args args = {
 		.cmd = cmd,
 		.first_intid = first_intid,
 		.num = num,
+		.level = level,
 	};
 	GUEST_SYNC(&args);
 }
@@ -158,19 +177,21 @@ do { 										\
 #define CAT_HELPER(a, b) a ## b
 #define CAT(a, b) CAT_HELPER(a, b)
 #define PREFIX guest_irq_handler_
-#define GUEST_IRQ_HANDLER_NAME(split) CAT(PREFIX, split)
-#define GENERATE_GUEST_IRQ_HANDLER(split)					\
-static void CAT(PREFIX, split)(struct ex_regs *regs)				\
+#define GUEST_IRQ_HANDLER_NAME(split, lev) CAT(PREFIX, CAT(split, lev))
+#define GENERATE_GUEST_IRQ_HANDLER(split, lev)					\
+static void CAT(PREFIX, CAT(split, lev))(struct ex_regs *regs)			\
 {										\
-	guest_irq_generic_handler(split);					\
+	guest_irq_generic_handler(split, lev);					\
 }
 
-GENERATE_GUEST_IRQ_HANDLER(0);
-GENERATE_GUEST_IRQ_HANDLER(1);
+GENERATE_GUEST_IRQ_HANDLER(0, 0);
+GENERATE_GUEST_IRQ_HANDLER(0, 1);
+GENERATE_GUEST_IRQ_HANDLER(1, 0);
+GENERATE_GUEST_IRQ_HANDLER(1, 1);
 
-static void (*guest_irq_handlers[2])(struct ex_regs *) = {
-	GUEST_IRQ_HANDLER_NAME(0),
-	GUEST_IRQ_HANDLER_NAME(1),
+static void (*guest_irq_handlers[2][2])(struct ex_regs *) = {
+	{GUEST_IRQ_HANDLER_NAME(0, 0), GUEST_IRQ_HANDLER_NAME(0, 1),},
+	{GUEST_IRQ_HANDLER_NAME(1, 0), GUEST_IRQ_HANDLER_NAME(1, 1),},
 };
 
 static void reset_priorities(struct test_args *args)
@@ -181,6 +202,11 @@ static void reset_priorities(struct test_args *args)
 		gic_set_priority(i, IRQ_DEFAULT_PRIO_REG);
 }
 
+static void guest_set_irq_line(uint32_t intid, uint32_t level)
+{
+	kvm_inject_call(KVM_SET_IRQ_LINE, intid, 1, level);
+}
+
 static void guest_inject(struct test_args *args,
 		uint32_t first_intid, uint32_t num,
 		kvm_inject_cmd cmd)
@@ -257,10 +283,12 @@ static void test_inject_preemption(struct test_args *args,
 	for (i = 0; i < num; i++) {
 		uint32_t tmp;
 		intid = i + first_intid;
-		kvm_inject_call(cmd, intid, 1);
+		KVM_INJECT(cmd, intid);
 		/* Each successive IRQ will preempt the previous one. */
 		tmp = wait_for_and_activate_irq();
 		GUEST_ASSERT_EQ(tmp, intid);
+		if (args->level_sensitive)
+			guest_set_irq_line(intid, 0);
 	}
 
 	/* finish handling the IRQs starting with the highest priority one. */
@@ -321,22 +349,29 @@ static void test_preemption(struct test_args *args, struct kvm_inject_desc *f)
 static void guest_code(struct test_args args)
 {
 	uint32_t i, nr_irqs = args.nr_irqs;
-	struct kvm_inject_desc *f;
+	bool level_sensitive = args.level_sensitive;
+	struct kvm_inject_desc *f, *inject_fns;
 
 	gic_init(GIC_V3, 1, dist, redist);
 
 	for (i = 0; i < nr_irqs; i++)
 		gic_irq_enable(i);
 
+	for (i = MIN_SPI; i < nr_irqs; i++)
+		gic_irq_set_config(i, !args.level_sensitive);
+
 	gic_set_eoi_split(args.eoi_split);
 
 	reset_priorities(&args);
 	gic_set_priority_mask(CPU_PRIO_MASK);
 
+	inject_fns  = level_sensitive ? inject_level_fns
+				      : inject_edge_fns;
+
 	local_irq_enable();
 
 	/* Start the tests. */
-	for_each_inject_fn(inject_edge_fns, f) {
+	for_each_inject_fn(inject_fns, f) {
 		test_injection(&args, f);
 		test_preemption(&args, f);
 	}
@@ -351,6 +386,7 @@ static void run_guest_cmd(struct kvm_vm *vm, int gic_fd,
 	kvm_inject_cmd cmd = inject_args->cmd;
 	uint32_t intid = inject_args->first_intid;
 	uint32_t num = inject_args->num;
+	int level = inject_args->level;
 	uint32_t i;
 
 	assert(intid < UINT_MAX - num);
@@ -362,6 +398,14 @@ static void run_guest_cmd(struct kvm_vm *vm, int gic_fd,
 		for (i = intid; i < intid + num; i++)
 			kvm_arm_irq_line(vm, i, 0);
 		break;
+	case KVM_SET_IRQ_LINE:
+		for (i = intid; i < intid + num; i++)
+			kvm_arm_irq_line(vm, i, level);
+		break;
+	case KVM_SET_IRQ_LINE_HIGH:
+		for (i = intid; i < intid + num; i++)
+			kvm_arm_irq_line(vm, i, 1);
+		break;
 	default:
 		break;
 	}
@@ -380,11 +424,12 @@ static void kvm_inject_get_call(struct kvm_vm *vm, struct ucall *uc,
 
 static void print_args(struct test_args *args)
 {
-	printf("nr-irqs=%d eoi-split=%d\n",
-			args->nr_irqs, args->eoi_split);
+	printf("nr-irqs=%d level-sensitive=%d eoi-split=%d\n",
+			args->nr_irqs, args->level_sensitive,
+			args->eoi_split);
 }
 
-static void test_vgic(uint32_t nr_irqs, bool eoi_split)
+static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 {
 	struct ucall uc;
 	int gic_fd;
@@ -393,6 +438,7 @@ static void test_vgic(uint32_t nr_irqs, bool eoi_split)
 
 	struct test_args args = {
 		.nr_irqs = nr_irqs,
+		.level_sensitive = level_sensitive,
 		.eoi_split = eoi_split,
 	};
 
@@ -411,7 +457,7 @@ static void test_vgic(uint32_t nr_irqs, bool eoi_split)
 			GICD_BASE_GPA, GICR_BASE_GPA);
 
 	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT,
-			guest_irq_handlers[args.eoi_split]);
+		guest_irq_handlers[args.eoi_split][args.level_sensitive]);
 
 	while (1) {
 		vcpu_run(vm, VCPU_ID);
@@ -442,11 +488,12 @@ static void help(const char *name)
 {
 	printf(
 	"\n"
-	"usage: %s [-n num_irqs] [-e eoi_split]\n", name);
-	printf(" -n: specify the number of IRQs to configure the vgic with. "
+	"usage: %s [-n num_irqs] [-e eoi_split] [-l level_sensitive]\n", name);
+	printf(" -n: specify number of IRQs to setup the vgic with. "
 		"It has to be a multiple of 32 and between 64 and 1024.\n");
 	printf(" -e: if 1 then EOI is split into a write to DIR on top "
 		"of writing EOI.\n");
+	printf(" -l: specify whether the IRQs are level-sensitive (1) or not (0).");
 	puts("");
 	exit(1);
 }
@@ -455,13 +502,14 @@ int main(int argc, char **argv)
 {
 	uint32_t nr_irqs = 64;
 	bool default_args = true;
+	bool level_sensitive = false;
 	int opt;
 	bool eoi_split = false;
 
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	while ((opt = getopt(argc, argv, "hn:e:")) != -1) {
+	while ((opt = getopt(argc, argv, "hn:e:l:")) != -1) {
 		switch (opt) {
 		case 'n':
 			nr_irqs = atoi(optarg);
@@ -472,6 +520,10 @@ int main(int argc, char **argv)
 			eoi_split = (bool)atoi(optarg);
 			default_args = false;
 			break;
+		case 'l':
+			level_sensitive = (bool)atoi(optarg);
+			default_args = false;
+			break;
 		case 'h':
 		default:
 			help(argv[0]);
@@ -483,10 +535,12 @@ int main(int argc, char **argv)
 	 * combinations.
 	 */
 	if (default_args) {
-		test_vgic(nr_irqs, false /* eoi_split */);
-		test_vgic(nr_irqs, true /* eoi_split */);
+		test_vgic(nr_irqs, false /* level */, false /* eoi_split */);
+		test_vgic(nr_irqs, false /* level */, true /* eoi_split */);
+		test_vgic(nr_irqs, true /* level */, false /* eoi_split */);
+		test_vgic(nr_irqs, true /* level */, true /* eoi_split */);
 	} else {
-		test_vgic(nr_irqs, eoi_split);
+		test_vgic(nr_irqs, level_sensitive, eoi_split);
 	}
 
 	return 0;
-- 
2.34.0.rc0.344.g81b53c2807-goog

