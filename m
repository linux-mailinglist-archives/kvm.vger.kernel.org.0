Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8359F44A4DC
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 03:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241751AbhKICmM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 21:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241630AbhKICmJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 21:42:09 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C53C061570
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 18:39:24 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id y124-20020a623282000000b0047a09271e49so11968934pfy.16
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 18:39:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ncjLEDYXfGn2mZ4JYj7zy7HLzUBwrfGKWWDFG4IBv6o=;
        b=Bl8Pm0ozKWM/LDLCA6K2BTKtoz58AP9+G+MiKh3oXnapRhrLqyXijXPDxepDOoJjho
         gwMqsbUylDu4bN1rhqZqClU65UZBpuqXGtMhHeuqy0oEeNQIlAQ7i4Bgo+2/ntB3CqXz
         oHc3ByRBe274NlJR4dyWfNt1jlm0F6efB0XjITVhWdiYm346FIHCozlgDoimpVUrsl/c
         4Ds0Wdc037JHHxU+uPQhzgdnd7c8e/+i+WJFu7NGXwsJ/LJ6qgRFifnbNnHPGZSieJyF
         P39musL3Jv+1mx2at5ycPfjgCGq6NYnKw1zTFnUDtVO74aD1m6LPfNqoq+PfUxVar/vu
         Nd7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ncjLEDYXfGn2mZ4JYj7zy7HLzUBwrfGKWWDFG4IBv6o=;
        b=GIXKoVBZBUfU5rsX1KJ+QDTMDESZ41oyvLRWg7KEBfd/cKbggqzJkrGEUSdFLojde2
         KC/DLlKZUoFxdWMU2U+8X2nXaPmuZPCGp7yKhhvaoOlH5fWfGGG+UeK7FDdy/B1+9efb
         jx//5FgqgbTdoMrWgseq3Wlp/xIzuPO97U06QPuVOHYSbKn6nao2Uh3BDdp2xtFLAdoC
         rLfjh98XCobT/vnX1jLUE4dBaQLhQP7xJnh6c57smXrAqW9LZi1safQ93rDsoZVRexba
         EKkRBLNVpfcQuu2hEdVWXYT6KDqJJJNvI+49QowE46oIIaaE3/Ogl3JDgsWbIH6Y5uG5
         4U+g==
X-Gm-Message-State: AOAM530pDbPUA05uqgcQQbrjVQ1iNN1jhQryR2tU+7lDbu06WWSbaA3d
        06/pUMx497HYfVbypltXmgNW6qwa7xF5ax6WXQdAtPpJwgxze3hdlOt+9V09JdsLdpUZfUyJBbo
        WqovJV6y1xRPqK6IQlnKZdv5GT/v2TIZAcrm/RaEAtJFoOThfuDx1qTODqhR0V9w=
X-Google-Smtp-Source: ABdhPJx2kMz7ovig+XiKxpSShdq7aHjbFgtxozevvbz4f2HNg2/3JEyOFbLVPit84lmx/ErpG4ZdqScxc4iHTQ==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a62:ea16:0:b0:47b:f3d7:7a9 with SMTP id
 t22-20020a62ea16000000b0047bf3d707a9mr4400254pfh.60.1636425564008; Mon, 08
 Nov 2021 18:39:24 -0800 (PST)
Date:   Mon,  8 Nov 2021 18:38:56 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-8-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 07/17] KVM: selftests: aarch64: abstract the injection
 functions in vgic_irq
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

Build an abstraction around the injection functions, so the preparation
and checking around the actual injection can be shared between tests.
All functions are stored as pointers in arrays of kvm_inject_desc's
which include the pointer and what kind of interrupts they can inject.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 39 +++++++++++++++++--
 1 file changed, 36 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index e13e87427038..f5d76fef22f0 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -57,10 +57,28 @@ struct kvm_inject_args {
 /* Used on the guest side to perform the hypercall. */
 static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t intid);
 
+#define KVM_INJECT(cmd, intid)							\
+	kvm_inject_call(cmd, intid)
+
 /* Used on the host side to get the hypercall info. */
 static void kvm_inject_get_call(struct kvm_vm *vm, struct ucall *uc,
 		struct kvm_inject_args *args);
 
+struct kvm_inject_desc {
+	kvm_inject_cmd cmd;
+	/* can inject PPIs, PPIs, and/or SPIs. */
+	bool sgi, ppi, spi;
+};
+
+static struct kvm_inject_desc inject_edge_fns[] = {
+	/*                                      sgi    ppi    spi */
+	{ KVM_INJECT_EDGE_IRQ_LINE,		false, false, true },
+	{ 0, },
+};
+
+#define for_each_inject_fn(t, f)						\
+	for ((f) = (t); (f)->cmd; (f)++)
+
 /* Shared between the guest main thread and the IRQ handlers. */
 volatile uint64_t irq_handled;
 volatile uint32_t irqnr_received[MAX_SPI + 1];
@@ -120,12 +138,12 @@ do { 										\
 	GUEST_ASSERT(_intid == 0 || _intid == IAR_SPURIOUS);			\
 } while (0)
 
-static void test_kvm_irq_line(uint32_t intid)
+static void guest_inject(uint32_t intid, kvm_inject_cmd cmd)
 {
 	reset_stats();
 
 	asm volatile("msr daifset, #2" : : : "memory");
-	kvm_inject_call(KVM_INJECT_EDGE_IRQ_LINE, intid);
+	KVM_INJECT(cmd, intid);
 
 	while (irq_handled < 1) {
 		asm volatile("wfi\n"
@@ -141,10 +159,23 @@ static void test_kvm_irq_line(uint32_t intid)
 	GUEST_ASSERT_IAR_EMPTY();
 }
 
+static void test_injection(struct kvm_inject_desc *f)
+{
+	if (f->sgi)
+		guest_inject(MIN_SGI, f->cmd);
+
+	if (f->ppi)
+		guest_inject(MIN_PPI, f->cmd);
+
+	if (f->spi)
+		guest_inject(MIN_SPI, f->cmd);
+}
+
 static void guest_code(void)
 {
 	uint32_t i;
 	uint32_t nr_irqs = 64; /* absolute minimum number of IRQs supported. */
+	struct kvm_inject_desc *f;
 
 	gic_init(GIC_V3, 1, dist, redist);
 
@@ -157,7 +188,9 @@ static void guest_code(void)
 
 	local_irq_enable();
 
-	test_kvm_irq_line(MIN_SPI);
+	/* Start the tests. */
+	for_each_inject_fn(inject_edge_fns, f)
+		test_injection(f);
 
 	GUEST_DONE();
 }
-- 
2.34.0.rc0.344.g81b53c2807-goog

