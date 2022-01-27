Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1438049D8CF
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 04:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233589AbiA0DJI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 22:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbiA0DJG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 22:09:06 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51C0C06161C
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 19:09:06 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id p5-20020a170902bd0500b00148cb2d29ecso814998pls.4
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 19:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lqWGfh2BJMERTwHvF+7RFLuQxcilmmI6PUG6asomKXE=;
        b=U/7s/RD/eWobrbk6Ldg3LkBFZ1PgmOUJlVBFTuh99tKfbEgEQWP4jPoq38c0nptkxy
         7t3su/tNuMcY5Ot+znpjZd4STvjf9VIezzUO40l2zRyqnyagTjuHvItXTkUPgxcIazGp
         xswQhIsvCV0mfnifIKbouhGkN0Xs8TfHfCi3OVkvw2HwaSjDkcV4GhLTH1YWsaLnkkKq
         xGmYWxZS/YfymhudibefhxEqrAertW+N5r68/tsC9VBmOqPEgjPyXe5ayTBTlnlowM7X
         xt8sOOFma55MRiH85uByCVjk6fqnNf/PWzqS0t8yHV5LLtgwMU31t47Wa+m5j64VTDM9
         SdMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lqWGfh2BJMERTwHvF+7RFLuQxcilmmI6PUG6asomKXE=;
        b=pKW1/g1VRxIX/2zJvr8a/+d4TdwiFMTv+8tAD6RCQqSHYuPOYKm3zkiUktCMA+kVs6
         qzdcbwx7+uNsTo1Iee+pbr0AZn01cHKnCazeUudyeTNjXQXNwJ5qshKysz0JMKpmIgdH
         fCQzVbFGcHYQabdWxNa8XmUbmOyat6g2Im0YG1SuqTCvZtOkoSqCBweJnbGa9yZPbRli
         0/Nk5qjZVJkuAyS/CIxEcq7OPkIyUhMZ4Q2JM0lM4AgERQAR1Dh/etVSpoYAr6lvd7SS
         YF2gAajBIMss0kvQOUZCx1xypb6uZs6uSXtfQSUoOddvQP6QdFWevYB0LuuRyJ7rxXat
         G5Lg==
X-Gm-Message-State: AOAM531dKOxBSWU0V98Sn/MOEF2r2UpPUjTu9Ewa0MayJ/k2gGxMfwvb
        GOT2mJGWk75ssNSiUxtI/b95ecZhqj1yDqC5XunJQYLdyUPdAAkEEpPvp00YnNHSBxcnTzezi7D
        ZhsTj1PCE6QlQGy2lGoTx5/4E43yGJk5gACpLeWnA7SlLq2R2bHbVie7S3WaUa0c=
X-Google-Smtp-Source: ABdhPJx5gWsEp7INU7scxngnVF9QetFYhYL4j1t6IkPIGmvXy8Dl4Zych8ub9e0y2Xeaod39U96Ah8zx+33LvA==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:903:1250:: with SMTP id
 u16mr1663963plh.126.1643252946183; Wed, 26 Jan 2022 19:09:06 -0800 (PST)
Date:   Wed, 26 Jan 2022 19:08:55 -0800
In-Reply-To: <20220127030858.3269036-1-ricarkol@google.com>
Message-Id: <20220127030858.3269036-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220127030858.3269036-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 2/5] kvm: selftests: aarch64: pass vgic_irq guest args as a pointer
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        oupton@google.com, reijiw@google.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest in vgic_irq gets its arguments in a struct. This struct used
to fit nicely in a single register so vcpu_args_set() was able to pass
it by value by setting x0 with it. Unfortunately, this args struct grew
after some commits and some guest args became random (specically
kvm_supports_irqfd).

Fix this by passing the guest args as a pointer (after allocating some
guest memory for it).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reported-by: Reiji Watanabe <reijiw@google.com>
Cc: Andrew Jones <drjones@redhat.com>
---
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 29 ++++++++++---------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index e6c7d7f8fbd1..b701eb80128d 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -472,10 +472,10 @@ static void test_restore_active(struct test_args *args, struct kvm_inject_desc *
 		guest_restore_active(args, MIN_SPI, 4, f->cmd);
 }
 
-static void guest_code(struct test_args args)
+static void guest_code(struct test_args *args)
 {
-	uint32_t i, nr_irqs = args.nr_irqs;
-	bool level_sensitive = args.level_sensitive;
+	uint32_t i, nr_irqs = args->nr_irqs;
+	bool level_sensitive = args->level_sensitive;
 	struct kvm_inject_desc *f, *inject_fns;
 
 	gic_init(GIC_V3, 1, dist, redist);
@@ -484,11 +484,11 @@ static void guest_code(struct test_args args)
 		gic_irq_enable(i);
 
 	for (i = MIN_SPI; i < nr_irqs; i++)
-		gic_irq_set_config(i, !args.level_sensitive);
+		gic_irq_set_config(i, !level_sensitive);
 
-	gic_set_eoi_split(args.eoi_split);
+	gic_set_eoi_split(args->eoi_split);
 
-	reset_priorities(&args);
+	reset_priorities(args);
 	gic_set_priority_mask(CPU_PRIO_MASK);
 
 	inject_fns  = level_sensitive ? inject_level_fns
@@ -497,17 +497,17 @@ static void guest_code(struct test_args args)
 	local_irq_enable();
 
 	/* Start the tests. */
-	for_each_supported_inject_fn(&args, inject_fns, f) {
-		test_injection(&args, f);
-		test_preemption(&args, f);
-		test_injection_failure(&args, f);
+	for_each_supported_inject_fn(args, inject_fns, f) {
+		test_injection(args, f);
+		test_preemption(args, f);
+		test_injection_failure(args, f);
 	}
 
 	/* Restore the active state of IRQs. This would happen when live
 	 * migrating IRQs in the middle of being handled.
 	 */
-	for_each_supported_activate_fn(&args, set_active_fns, f)
-		test_restore_active(&args, f);
+	for_each_supported_activate_fn(args, set_active_fns, f)
+		test_restore_active(args, f);
 
 	GUEST_DONE();
 }
@@ -739,6 +739,7 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 	int gic_fd;
 	struct kvm_vm *vm;
 	struct kvm_inject_args inject_args;
+	vm_vaddr_t args_gva;
 
 	struct test_args args = {
 		.nr_irqs = nr_irqs,
@@ -757,7 +758,9 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
 
 	/* Setup the guest args page (so it gets the args). */
-	vcpu_args_set(vm, 0, 1, args);
+	args_gva = vm_vaddr_alloc_page(vm);
+	memcpy(addr_gva2hva(vm, args_gva), &args, sizeof(args));
+	vcpu_args_set(vm, 0, 1, args_gva);
 
 	gic_fd = vgic_v3_setup(vm, 1, nr_irqs,
 			GICD_BASE_GPA, GICR_BASE_GPA);
-- 
2.35.0.rc0.227.g00780c9af4-goog

