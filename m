Return-Path: <kvm+bounces-24930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A77195D4C5
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 19:59:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 14DBAB219AC
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 17:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 717CE191F62;
	Fri, 23 Aug 2024 17:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iBOUO4y2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4331019047C
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 17:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724435928; cv=none; b=M6HUcUmwo2qQLd28wJtlgIr1qh7BtToXbh8jzVOSMLLpUneizCADHX0e/LREVCpMV5wxy0Ulqru/89deHA3phjzML47x0LT05di9c30pI4rOQeHP9xICDK86Tv4YPPZE77i7nmux3OlC5FPcu6af2v6DY+QEm2gk+Yv8MmrE0VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724435928; c=relaxed/simple;
	bh=TC8Ix36/fGXMyqHLZyB5PpiW2Dfl6b3geb+DTkbFUsA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=htWaf5KwMkLqgj5MqRw0Kj3XyXiY7k//fnDBVkqmQ6sIKHVxqIMSpstJKgB04yqUUlIIwvaWjjQWwhRI73C7XlFg8OF8d3gYd0ihkyCtLUn9sru1y9kSCp76qZKXmXaLNTfsZwXAL9r3NzWbJWwZkztPB85iE/FHExxRpycBVtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iBOUO4y2; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc691f1f83aso1342050276.1
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 10:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724435926; x=1725040726; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zLv13f/DBEqm51hY6VfaGMHBiQ0T7a5MTFlVVUYHQ7E=;
        b=iBOUO4y2/keAs6P+Nbn7kYdhjIRYKr+rgMYY0EqEZi1mYZDIrf/mMCw8KlHPO09IBy
         5UqXNsddhhiSouYJ74M9pQogyMTRhPkavsrYOjGveUDR6TYrGGyngg36lMDYnCILybol
         UAOEDV0u9QoUh2H3vwzNoJpRIrYTzkapqKu4hp50vNRKamaHXPl0ojy6Gp3PtTkodiKx
         XIzBq4ho9fMgLv8Yiyprvo1GnbdvuaRtHtxHoFlQvf3CSbl2enmusjnNtAb/jCkl8/Rh
         gb5XTfw9AsjxQ1PylKJkp1RK/5YRv2qSuFZAQ125+tLUPJToKqDdpqACDpo5oRUwJyhb
         KNpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724435926; x=1725040726;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zLv13f/DBEqm51hY6VfaGMHBiQ0T7a5MTFlVVUYHQ7E=;
        b=GwFLcKyelkgrZVeMZ3GllDE1cY3G6Z+LcAxsSLmozx7kDSLUsAcU+G2G7OtVgKilhK
         8XiL2opp0b0YOsYigi3spE9QfWT6tySqj4/NEIVQAQ76Muq0lMbEtWQCpoFXFcqKWHfz
         j9U6faj09sELzhJdn1ITmGlY1m+wi9VQfTEOqCDYLjcdmrm9/JmVGbEG65/+gkVKszIU
         o4w8YYWD2m42TEfu2P3N7LjOE9axaMLLpcrbWkB+5hC186PlVVvoN0/VbKvpLL+Ganb8
         ljWk3nKPrXvoSw8XMCeCsRYdr1EdxEtu8JJ4YpwqFayQ1CEexDjYhIAvbbUDm7yyCW2b
         rR9A==
X-Gm-Message-State: AOJu0Yze6I8yHm6Z1n9YQbNGrSK3OAIwkiaSf3lthU7bbRGDiePHkdhb
	rxrinFec3Ycc//P9X2OcjYaByHhS7ZD6zIeFVsq0NLF6/g8Q+viPy5h/hT2WquelINgJ9p7CBYT
	RRitS2Iw/AR+n9wm/pTaOJ5i/nbC+xOfCaf/E7JBourdC1lRNrnh/hLuIanz2Zo7auzm96L425G
	jY1CmoFUXtijuVR0p+rs4Rotsirpuq+8j7+2dDLiAyuV4NEfq+HWHZi0o=
X-Google-Smtp-Source: AGHT+IHgfE3XWfOJ0gaXcFJcDYaCkx3ejXevtjofbCecDoxYmblyUxbaaB4DAMf8FQgWwZ8JiJyOc45ebtxhMsItjw==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:bf92:0:b0:e16:67b0:2de3 with SMTP
 id 3f1490d57ef6-e17a7aa7edfmr54278276.5.1724435925659; Fri, 23 Aug 2024
 10:58:45 -0700 (PDT)
Date: Fri, 23 Aug 2024 17:58:35 +0000
In-Reply-To: <20240823175836.2798235-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240823175836.2798235-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240823175836.2798235-2-coltonlewis@google.com>
Subject: [PATCH v6 1/2] KVM: selftests: Ensure pending interrupts are handled
 in arch_timer test
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Break up the asm instructions poking daifclr and daifset to handle
interrupts. R_RBZYL specifies pending interrupts will be handle after
context synchronization events such as an ISB.

Introduce a function wrapper for the WFI instruction.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/aarch64/vgic_irq.c        | 11 +++++------
 .../testing/selftests/kvm/include/aarch64/processor.h |  3 +++
 tools/testing/selftests/kvm/lib/aarch64/processor.c   |  6 ++++++
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index a51dbd2a5f84..f4ac28d53747 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -269,13 +269,12 @@ static void guest_inject(struct test_args *args,
 	KVM_INJECT_MULTI(cmd, first_intid, num);
 
 	while (irq_handled < num) {
-		asm volatile("wfi\n"
-			     "msr daifclr, #2\n"
-			     /* handle IRQ */
-			     "msr daifset, #2\n"
-			     : : : "memory");
+		wfi();
+		local_irq_enable();
+		isb(); /* handle IRQ */
+		local_irq_disable();
 	}
-	asm volatile("msr daifclr, #2" : : : "memory");
+	local_irq_enable();
 
 	GUEST_ASSERT_EQ(irq_handled, num);
 	for (i = first_intid; i < num + first_intid; i++)
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 9b20a355d81a..de977d131082 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -243,4 +243,7 @@ void smccc_smc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
 	       uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5,
 	       uint64_t arg6, struct arm_smccc_res *res);
 
+/* Execute a Wait For Interrupt instruction. */
+void wfi(void);
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 0ac7cc89f38c..fe4dc3693112 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -639,3 +639,9 @@ void vm_vaddr_populate_bitmap(struct kvm_vm *vm)
 	sparsebit_set_num(vm->vpages_valid, 0,
 			  (1ULL << vm->va_bits) >> vm->page_shift);
 }
+
+/* Helper to call wfi instruction. */
+void wfi(void)
+{
+	asm volatile("wfi");
+}
-- 
2.46.0.295.g3b9ea8a38a-goog


