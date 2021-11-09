Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014C244A4ED
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 03:39:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241907AbhKICm0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 21:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241929AbhKICmX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 21:42:23 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F0EC0613B9
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 18:39:37 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id y124-20020a623282000000b0047a09271e49so11969315pfy.16
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 18:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=igtNCs/EdQGdJFkd8S66UsbWC4E3b2XpCSh4teAekRY=;
        b=i0neKE5eIA9O5ihA63SgrJVllahwMqAEv84n9PQafp4I0majIgaxlX1lRfZvQ+2FoR
         QyVP4CWlFmpXrVz0MJbXjL+XiLNgeESeqzmx25UAylf/rQR6VOCcPlG89XgloRKpXKtR
         Ru0D4STMeW1qfxMv+sq6DYdEE/9zM0l0ja13ZOpwq4gzLIqVZQRYMy6ZOjod6u8KQeQw
         nGhUkO9jziaFFKhjDky63H7nCUNFnm/S9elbn0fZO3bTV/z2TZSpuXhR5j5sMAPmwsyX
         x9sB55tWOsIa3Oyz/YBp5VmY2dI3STwUJk0HjAfCVXw8jPxSccxoR0sxxSyJc2SnHxHC
         H+kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=igtNCs/EdQGdJFkd8S66UsbWC4E3b2XpCSh4teAekRY=;
        b=Go+nidFgqjexfMaxHB2lDT0tC16AQzYwYbyH7kANZkvn1m5kMZyOO69+6Q7xWch/7/
         yLv2aa/y/2m/Vth3zuQJ3d2KngnPQiArvgNlHq4+LOGePwonR19+yOokmkaUEuDntA5g
         A8NDsobJSEGS6NZlO2tfZCBZpuYFbgi1QY7quQ5nQ4xybVY23txXVNxG8CPQ669pKija
         5DqwvecTpVQgP2q7xxF1Qvw6QSQ80k6XlOikOkZTLq6ecwPkIErW3h5jGlXj/01A6VJK
         /+kivfMmGUwWrhNccml0yz5mLMB2rScG+O8z292dZQB8e2S+VQhdWuqd+yyCFccctmVK
         LS8g==
X-Gm-Message-State: AOAM532i4ZNns8Lltip/IYJbNqB1v0quhFsnpaHROzHelbtYEwZRlXUq
        xrGT1uGylgS476ou+KKSIrxGEIV++jw2c4UO3Z7VM4fkth4goM26ry3C24Gblg+Mdt1y0ocrpg4
        c7FJHpsVMMB9EkUj2V/4RJqfJb6mBOkIpZEyfu7fn/Ue4LXS2Ttpw+wP1nNsOsIQ=
X-Google-Smtp-Source: ABdhPJwpIp4nej4Ka3+5nbnKShwE7lHQyfASuzjkFE1r2avt/z5DkQiTZ2DJ4QZBJfdyPR07SFtRnf1BQiFExA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:903:1207:b0:13d:b9b1:ead7 with SMTP
 id l7-20020a170903120700b0013db9b1ead7mr3940753plh.63.1636425577086; Mon, 08
 Nov 2021 18:39:37 -0800 (PST)
Date:   Mon,  8 Nov 2021 18:39:04 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-16-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 15/17] KVM: selftests: aarch64: add tests for IRQFD in vgic_irq
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

Add injection tests for the KVM_IRQFD ioctl into vgic_irq.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 101 +++++++++++++++++-
 .../selftests/kvm/include/aarch64/vgic.h      |   2 +
 2 files changed, 102 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 9f1674b3a45c..121113f24ed3 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -10,6 +10,7 @@
 
 #include <asm/kvm.h>
 #include <asm/kvm_para.h>
+#include <sys/eventfd.h>
 #include <linux/sizes.h>
 
 #include "processor.h"
@@ -31,6 +32,8 @@ struct test_args {
 	uint32_t nr_irqs; /* number of KVM supported IRQs. */
 	bool eoi_split; /* 1 is eoir+dir, 0 is eoir only */
 	bool level_sensitive; /* 1 is level, 0 is edge */
+	int kvm_max_routes; /* output of KVM_CAP_IRQ_ROUTING */
+	bool kvm_supports_irqfd; /* output of KVM_CAP_IRQFD */
 };
 
 /*
@@ -61,6 +64,7 @@ typedef enum {
 	KVM_SET_IRQ_LINE,
 	KVM_SET_IRQ_LINE_HIGH,
 	KVM_SET_LEVEL_INFO_HIGH,
+	KVM_INJECT_IRQFD,
 } kvm_inject_cmd;
 
 struct kvm_inject_args {
@@ -100,6 +104,7 @@ struct kvm_inject_desc {
 static struct kvm_inject_desc inject_edge_fns[] = {
 	/*                                      sgi    ppi    spi */
 	{ KVM_INJECT_EDGE_IRQ_LINE,		false, false, true },
+	{ KVM_INJECT_IRQFD,			false, false, true },
 	{ 0, },
 };
 
@@ -107,12 +112,17 @@ static struct kvm_inject_desc inject_level_fns[] = {
 	/*                                      sgi    ppi    spi */
 	{ KVM_SET_IRQ_LINE_HIGH,		false, true,  true },
 	{ KVM_SET_LEVEL_INFO_HIGH,		false, true,  true },
+	{ KVM_INJECT_IRQFD,			false, false, true },
 	{ 0, },
 };
 
 #define for_each_inject_fn(t, f)						\
 	for ((f) = (t); (f)->cmd; (f)++)
 
+#define for_each_supported_inject_fn(args, t, f)				\
+	for_each_inject_fn(t, f)						\
+		if ((args)->kvm_supports_irqfd || (f)->cmd != KVM_INJECT_IRQFD)
+
 /* Shared between the guest main thread and the IRQ handlers. */
 volatile uint64_t irq_handled;
 volatile uint32_t irqnr_received[MAX_SPI + 1];
@@ -403,7 +413,7 @@ static void guest_code(struct test_args args)
 	local_irq_enable();
 
 	/* Start the tests. */
-	for_each_inject_fn(inject_fns, f) {
+	for_each_supported_inject_fn(&args, inject_fns, f) {
 		test_injection(&args, f);
 		test_preemption(&args, f);
 		test_injection_failure(&args, f);
@@ -455,6 +465,88 @@ void kvm_irq_set_level_info_check(int gic_fd, uint32_t intid, int level,
 	}
 }
 
+static void kvm_set_gsi_routing_irqchip_check(struct kvm_vm *vm,
+		uint32_t intid, uint32_t num, uint32_t kvm_max_routes,
+		bool expect_failure)
+{
+	struct kvm_irq_routing *routing;
+	int ret;
+	uint64_t i;
+
+	assert(num <= kvm_max_routes && kvm_max_routes <= KVM_MAX_IRQ_ROUTES);
+
+	routing = kvm_gsi_routing_create();
+	for (i = intid; i < (uint64_t)intid + num; i++)
+		kvm_gsi_routing_irqchip_add(routing, i - MIN_SPI, i - MIN_SPI);
+
+	if (!expect_failure) {
+		kvm_gsi_routing_write(vm, routing);
+	} else {
+		ret = _kvm_gsi_routing_write(vm, routing);
+		/* The kernel only checks for KVM_IRQCHIP_NUM_PINS. */
+		if (intid >= KVM_IRQCHIP_NUM_PINS)
+			TEST_ASSERT(ret != 0 && errno == EINVAL,
+				"Bad intid %u did not cause KVM_SET_GSI_ROUTING "
+				"error: rc: %i errno: %i", intid, ret, errno);
+		else
+			TEST_ASSERT(ret == 0, "KVM_SET_GSI_ROUTING "
+				"for intid %i failed, rc: %i errno: %i",
+				intid, ret, errno);
+	}
+}
+
+static void kvm_routing_and_irqfd_check(struct kvm_vm *vm,
+		uint32_t intid, uint32_t num, uint32_t kvm_max_routes,
+		bool expect_failure)
+{
+	int fd[MAX_SPI];
+	uint64_t val;
+	int ret, f;
+	uint64_t i;
+
+	/*
+	 * There is no way to try injecting an SGI or PPI as the interface
+	 * starts counting from the first SPI (above the private ones), so just
+	 * exit.
+	 */
+	if (INTID_IS_SGI(intid) || INTID_IS_PPI(intid))
+		return;
+
+	kvm_set_gsi_routing_irqchip_check(vm, intid, num,
+			kvm_max_routes, expect_failure);
+
+	/*
+	 * If expect_failure, then just to inject anyway. These
+	 * will silently fail. And in any case, the guest will check
+	 * that no actual interrupt was injected for those cases.
+	 */
+
+	for (f = 0, i = intid; i < (uint64_t)intid + num; i++, f++) {
+		fd[f] = eventfd(0, 0);
+		TEST_ASSERT(fd[f] != -1,
+			"eventfd failed, errno: %i\n", errno);
+	}
+
+	for (f = 0, i = intid; i < (uint64_t)intid + num; i++, f++) {
+		struct kvm_irqfd irqfd = {
+			.fd  = fd[f],
+			.gsi = i - MIN_SPI,
+		};
+		assert(i <= (uint64_t)UINT_MAX);
+		vm_ioctl(vm, KVM_IRQFD, &irqfd);
+	}
+
+	for (f = 0, i = intid; i < (uint64_t)intid + num; i++, f++) {
+		val = 1;
+		ret = write(fd[f], &val, sizeof(uint64_t));
+		TEST_ASSERT(ret == sizeof(uint64_t),
+			"Write to KVM_IRQFD failed with ret: %d\n", ret);
+	}
+
+	for (f = 0, i = intid; i < (uint64_t)intid + num; i++, f++)
+		close(fd[f]);
+}
+
 /* handles the valid case: intid=0xffffffff num=1 */
 #define for_each_intid(first, num, tmp, i)					\
 	for ((tmp) = (i) = (first);						\
@@ -500,6 +592,11 @@ static void run_guest_cmd(struct kvm_vm *vm, int gic_fd,
 			kvm_irq_set_level_info_check(gic_fd, i, 1,
 					expect_failure);
 		break;
+	case KVM_INJECT_IRQFD:
+		kvm_routing_and_irqfd_check(vm, intid, num,
+					test_args->kvm_max_routes,
+					expect_failure);
+		break;
 	default:
 		break;
 	}
@@ -534,6 +631,8 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 		.nr_irqs = nr_irqs,
 		.level_sensitive = level_sensitive,
 		.eoi_split = eoi_split,
+		.kvm_max_routes = kvm_check_cap(KVM_CAP_IRQ_ROUTING),
+		.kvm_supports_irqfd = kvm_check_cap(KVM_CAP_IRQFD),
 	};
 
 	print_args(&args);
diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
index ce6f0383c1a1..4442081221a0 100644
--- a/tools/testing/selftests/kvm/include/aarch64/vgic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
@@ -29,4 +29,6 @@ int _kvm_arm_irq_line(struct kvm_vm *vm, uint32_t intid, int level);
 void kvm_irq_write_ispendr(int gic_fd, uint32_t intid, uint32_t vcpu);
 void kvm_irq_write_isactiver(int gic_fd, uint32_t intid, uint32_t vcpu);
 
+#define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
+
 #endif // SELFTEST_KVM_VGIC_H
-- 
2.34.0.rc0.344.g81b53c2807-goog

