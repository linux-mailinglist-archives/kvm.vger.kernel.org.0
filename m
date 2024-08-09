Return-Path: <kvm+bounces-23749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 93ACE94D661
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 20:38:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 49D971F21B37
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 18:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71FF015A85E;
	Fri,  9 Aug 2024 18:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UoKQVQMj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277CF1442E8
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 18:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723228699; cv=none; b=VALDcHriH8p9fC7JFfgKSzV1cBM4+YOLEdwTTSTRFPXUZ16mXnAb3d0jdDS7kwkyaW69tHsVVSYGmCEtZZ9Q5mkXd1enmhgFmS/KvVce70iUpVBK9Ybh+hBprIq/qZBdoUva0q38OcadlshoJd2kr5GVNa9Mz0ydrtC8mYqXwTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723228699; c=relaxed/simple;
	bh=z8cWETLfeelpsbjyY0RVg3S8QOFntzeUcxoFKGzI+5Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DrCbMV3wLXGhlsyNeCf5BQnQnAJ9/PAP+9oqMTsMHepDh4B2Y9enCIA0hTsc9/EunRX5gNQQev/7SVa628d7kmw1o2er8Hz5B5Nn26E9n6g0k/0rWnr0w7N4YY4WdSNSWolL0IozcbaDi4ouuKVOPVnjKWv9i/G6LLEyyGUIKHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UoKQVQMj; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e02b5792baaso4361663276.2
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 11:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723228697; x=1723833497; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eKGu5OXwE/hWG2bMxqy/PoB6z3BlOaKV4IBDRrUObAs=;
        b=UoKQVQMjCvKosAsgpsXT/LXAtkG7vUgCLqW2IvdmExbFLiZMTixI5TmO/tE7VAGWpO
         yVOctp6pQKlkRVWc0x6PqxmqeW02IqglUbaotWo8kI0TxXntKXzTKvPMgYX8kTES0FCn
         a5R0jPJIMQYl/D3R0oyOaN+xGM7a8ftz0LGhwjo4p57f4Psoq0Uu8lR8OoH6S+cQAJUD
         LWZRtfxRl5wlFGfYAJH2XWPysd/YffeHo9+7TXi9wOxFcsVp3uQ2aJYZeIxL5ejDEFOJ
         SPU0Ywkd58BWFIph9LJn8Y+lHShQcs1cIYCiLWoabKYfgj05zY8VosKD/41AgIYl8QOB
         Tfpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723228697; x=1723833497;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eKGu5OXwE/hWG2bMxqy/PoB6z3BlOaKV4IBDRrUObAs=;
        b=u7efjxJum8gRbMw9cQ6UKwC2Pqin0fRW+1yZ9yfDm0BZMKvrFLRPdMTYZp9a/cxMYU
         fvBMEiL93bGPWrqabalXxHkGjOr+N8NmLsY+SxLtE/OZZAS19lhfO+8fU9Nf1oPaR4MM
         UxLlzCbOtnQunYox4JMKfpXj7TDjPItE4LVpeR0Ud7tKbjuwTyMF48Xh0KDcKUnM32sS
         mqPw07FG2f7fJ57X16gq8WRE/8sDD3ea3gphJBM+UEeN6Cjy0t8yAHLNNGsZfn022HEC
         mIO0Kjc/be6WZlXe6nywTfH3vWPwdH1BtiWf9pZHuuuMymJcvq3Wiy9NQ9awX5s17u7g
         yxpw==
X-Gm-Message-State: AOJu0YzjaMv8pqUOowH4TcCrmTm4TLMackr75T8KdQ/CGizdedD/vaxJ
	/CjmjWj2d0bezfHVIhOQbIIo21c5Iq6ZPkQqAp4HWZzCnIFAoNgTSt7K0I6gMpBa/8VXrF5dTnm
	+EAOqq+4waUE/2CDvPGrNNMzdA4lf2XQpVFDkCZR4jplYVU1VM4jgkty00OhhflH34o3tlyXREY
	DtJQPv+QxqGrMtGLImtWhgHZMsP6FHkcQnthkVIqsYPtIUfI3gkmJGGek=
X-Google-Smtp-Source: AGHT+IH6o1VN3yBM641/JDVgDhIluIEuwPASTzC6s9TvXRuzgn4u60dgcL8d5jJ+CKLoRta5OwQR2leUR2cDrWqLhQ==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a25:9a86:0:b0:e0e:4537:6e92 with SMTP
 id 3f1490d57ef6-e0eb993b146mr42483276.6.1723228696721; Fri, 09 Aug 2024
 11:38:16 -0700 (PDT)
Date: Fri,  9 Aug 2024 18:38:01 +0000
In-Reply-To: <20240809183802.3572177-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809183802.3572177-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809183802.3572177-2-coltonlewis@google.com>
Subject: [PATCH v5 1/2] KVM: selftests: Ensure pending interrupts are handled
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
2.46.0.76.ge559c4bf1a-goog


