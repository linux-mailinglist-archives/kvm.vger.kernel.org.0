Return-Path: <kvm+bounces-11322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20848875636
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 19:40:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 55D81B22920
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 18:40:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE60312B145;
	Thu,  7 Mar 2024 18:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zzt9n94S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B521350CD
	for <kvm@vger.kernel.org>; Thu,  7 Mar 2024 18:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709836799; cv=none; b=QQCQ82/OP0S7q5PG8pAQ9nOErXJd/SUEvSAxtJFYyMuyt17zHArxZ25GRWKmyOx0WNF6d4fAaZdLSKFfaekBZf1X7btljbadK3JB7NiULMAmJY6ma22zxZKufJJLcb0G/qP6RTh8EZ8lc/MIF8dKqoZzjJkQYmq3wwibH0Rqvko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709836799; c=relaxed/simple;
	bh=EqSTDy+4GtYjv80AJs+xWqwKelAcMKDMphBZFDji5Kg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mHfXZK0emUyc6RWSO4An0CSQQbARtMRLB8g7GJuvR/EXGtjJxOkCmnhHkAqb4JNYXGc0sLcYTlKQYbqtRAg/3hjxGGxq6P0kaLeeMVHqOom+UmU92YRs1gtA6Bm3L9TTNbKqv7P6L594Q/qVn/wA2DydR+UroZuzuKNjx1wCBPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zzt9n94S; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-609fe434210so1573357b3.1
        for <kvm@vger.kernel.org>; Thu, 07 Mar 2024 10:39:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709836796; x=1710441596; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qO5rBnHmkbmFXn5DB+2jWajFJFNZw3APSCtVJIvKtAM=;
        b=Zzt9n94SAXiD4IyLv6socIm+bfzW4ById10tYkLDefP0iWOh/5lhrc+EJ6ckozbapQ
         pdUOSkwGTHuMUdthd1/UiEJnpItEdgUxDvGVuiMQ6uSklemxXuf/Te6weZNbqi2VjA6F
         jGCV0qbUspuGeH3ZJ49WZur4b3CNz5RUniVgx2rG3PLaXEeln//nQAXHPHDnIY6P8u8N
         DN1GxukejPYaObizjVnMwhlu/3GR30tMk/7k5EP3fODOO1lU0CHRRpWNDO9VSK5SULxo
         bUUmhlmKC9XQ9hqrOM7L/UBa9tUqpqiv4Cz5RCxaDHNbUyM6rTMJfetAVWE3JEt7ZrFM
         m5vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709836796; x=1710441596;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qO5rBnHmkbmFXn5DB+2jWajFJFNZw3APSCtVJIvKtAM=;
        b=Z9KY+DbzY+hRb/9xUF+ez27UPj4zcWhIMl68kLSJng64Y/xhevhsNVynXGk9kJ4QWd
         lgKlj6f7GwbUOo6K/cEI28uXfsTllHpZYbreBfHL6sCv8c0w3OsSx5BkVbEYVC3M2VFI
         Z0IleJNMtd/FlI1etQMkqN+j4Gt+iiJUaX4DoyMLm/1rsFDqu1yRO81Z2uCO/dEBhhkD
         ezHjXDGA0VVV8dzHFZ/lye4sBCMqnRYUYeNKFpDEfberuJsjCfHfY1dnqaG20CfcYwUT
         QYCABHavBxTR4xCq4yD4TJ7zZF5adKqjLh1FPwNmLU/CD6LilpN+eFoIIyvngbdHyaqU
         1j6A==
X-Gm-Message-State: AOJu0YyKBJpM+gRsumTTIPtHjkERNa8ZDDvoL8ebEUTckCl7IEjDVMqY
	v3owHwikybPZEzI22nCWOYnOpdx8lEa+At6Brlv6T+WAsvB5795ttYt20oZ//ZLvrEVGpiKQFgZ
	KaS5wTE52JkcmijHFwBnOoIiDf20XWTlrCt3ImHLx8rXd1AgARiyRFWX1RoKN3DJI2XdyHFTHnO
	NE9z3GizbVAK8IXahq46WwyftJtKqmad3xKmLEJhugEKGtpaClucYYEoE=
X-Google-Smtp-Source: AGHT+IGJ9B5u301uhgzy+sZi7ffHqK5cobYQX0gYbfhhvAdIdHlxdpWdV6WN7fdpt0Z4CuJeZP5348K2Ldb0pTRGUg==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a81:5758:0:b0:609:1fd9:f76 with SMTP
 id l85-20020a815758000000b006091fd90f76mr4226573ywb.0.1709836796578; Thu, 07
 Mar 2024 10:39:56 -0800 (PST)
Date: Thu,  7 Mar 2024 18:39:06 +0000
In-Reply-To: <20240307183907.1184775-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240307183907.1184775-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240307183907.1184775-3-coltonlewis@google.com>
Subject: [PATCH v4 2/3] KVM: arm64: selftests: Guarantee interrupts are handled
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Ricardo Koller <ricarkol@google.com>, kvmarm@lists.linux.dev, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Break up the asm instructions poking daifclr and daifset to handle
interrupts. R_RBZYL specifies pending interrupts will be handle after
context synchronization events such as an ISB.

Introduce a function wrapper for the WFI instruction.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 tools/testing/selftests/kvm/aarch64/vgic_irq.c    | 12 ++++++------
 tools/testing/selftests/kvm/include/aarch64/gic.h |  3 +++
 tools/testing/selftests/kvm/lib/aarch64/gic.c     |  5 +++++
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index d3bf584d2cc1..85f182704d79 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -269,13 +269,13 @@ static void guest_inject(struct test_args *args,
 	KVM_INJECT_MULTI(cmd, first_intid, num);
 
 	while (irq_handled < num) {
-		asm volatile("wfi\n"
-			     "msr daifclr, #2\n"
-			     /* handle IRQ */
-			     "msr daifset, #2\n"
-			     : : : "memory");
+		gic_wfi();
+		local_irq_enable();
+		isb();
+		/* handle IRQ */
+		local_irq_disable();
 	}
-	asm volatile("msr daifclr, #2" : : : "memory");
+	local_irq_enable();
 
 	GUEST_ASSERT_EQ(irq_handled, num);
 	for (i = first_intid; i < num + first_intid; i++)
diff --git a/tools/testing/selftests/kvm/include/aarch64/gic.h b/tools/testing/selftests/kvm/include/aarch64/gic.h
index 9043eaef1076..f474714e4cb2 100644
--- a/tools/testing/selftests/kvm/include/aarch64/gic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/gic.h
@@ -47,4 +47,7 @@ void gic_irq_clear_pending(unsigned int intid);
 bool gic_irq_get_pending(unsigned int intid);
 void gic_irq_set_config(unsigned int intid, bool is_edge);
 
+/* Execute a Wait For Interrupt instruction. */
+void gic_wfi(void);
+
 #endif /* SELFTEST_KVM_GIC_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic.c b/tools/testing/selftests/kvm/lib/aarch64/gic.c
index 9d15598d4e34..392e3f581ae0 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/gic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/gic.c
@@ -164,3 +164,8 @@ void gic_irq_set_config(unsigned int intid, bool is_edge)
 	GUEST_ASSERT(gic_common_ops);
 	gic_common_ops->gic_irq_set_config(intid, is_edge);
 }
+
+void gic_wfi(void)
+{
+	asm volatile("wfi");
+}
-- 
2.44.0.278.ge034bb2e1d-goog


