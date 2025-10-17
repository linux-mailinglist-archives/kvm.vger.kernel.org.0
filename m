Return-Path: <kvm+bounces-60341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 86ABABEA930
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 18:16:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3FE69627ED
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 16:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95B25336EC2;
	Fri, 17 Oct 2025 15:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="mV/oszcd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E7B3328E9
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 15:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716787; cv=none; b=WXWLVWyrwHH81S4u21rky/91vvAEcIgqhMcuSNvKPCxbJwououj3m+wvKgoNsHG/1fqrEbZeCet/QHWPpIT/A4CEKrodnen6YKpHOU8R1o2emm4ym6xngwqbmXgEGYNAw3efkAx4IZvqOcChj3Dbk2v79oCp1wOnHybyPjle5P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716787; c=relaxed/simple;
	bh=VauSt0uAycrcY3nlPmUv8mw69nRyhNX8TjKVsezUOqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmLdA7tiuP5N7hjgsbEeDIMlQ1PRoz+G7lJm/ZKVhwtESlkFhNb+k5FSgyyVm6SaYpJs4Gq1EPDt4PUQz+mLA+21T64nb3VPvi/SfHfxeubqgO9zUNj16wl+5rN3UZG3AxvdMtBVNcY5fkornoZQdlQwmr0bh5hYRr1ucGmN9pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=mV/oszcd; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7a213c3c3f5so2885735b3a.3
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 08:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1760716785; x=1761321585; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7YO6UzdALBp15BcoYG5LkyhqHChXHZ3HPbY8ifkU6tw=;
        b=mV/oszcdRvCHeflMULEB+M2J4ICmGdgavI08r+FYJM9Rd3+9dExZy1jsd4GOVVT/Lu
         Z20+N8az+csEdntFOsoZLtqGN7E7lk1Q0/vknminagqxi8IxZkvRUR6t7OilZnAe2T0S
         sbDwlTnt0fLoQ/I15fDTcJ3mM9lJuyzwZIL53cnVbcQu1Zg+9/s0X52etjGJZSsHVCPP
         MW2ABfe/sqjLiaUejXcWzLBi34K9QlWMmbX7zcJcI99HooCO7TWeg9uPKYcNByCpkX2q
         WJYah2r7PeEQQoPljkpw62k/eokrgiJgLkP1Itj8MG5V8D+EpX78t/Gh5ViGl8GAZ9gB
         XHtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760716785; x=1761321585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7YO6UzdALBp15BcoYG5LkyhqHChXHZ3HPbY8ifkU6tw=;
        b=WckE5UdnW0YwZxvUZ5ZHJjJlCgutL4OB3o0BUPwz2/nIJdyRCL8xp7vjlImeBj31/y
         cfGuALMqcnnwWJBPF/SZXFIWuutISvs2lshPd7HjGVCvgS9jBgZTOez5k8oLoUxhaZ34
         zjretUQlWvb26vkn2hGOb+hBsIRR4ndCF/coi7IjoB3X4Uw9I4f4ZIfTigfQ5SfG5QTu
         DRZCwB/VwtwZgK8lrBTgSCXfkBTz/mr0Fh0MJdiZyrrRNkkjsw8uIy0Tjn7Dd9Jf9RJ/
         72hTHLOxHcRplHlq/SEtKDWCfMNQeanCaLqUf6RTlJ1rcupQy5Y4VNoZL4/csSJ33V8i
         kz3g==
X-Forwarded-Encrypted: i=1; AJvYcCVT/R2fzkGNFpwtrmHcJ74BMDgxr/lILB1TA868yaefNX04pUEhhq1+pDP2pJQCCOBWUK4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7Z0Kfh4c6Dc2uPwBmRebD+TelHy2Do3VXv1TH8waa3jy6jLxS
	91YJMlnN1dA86xNr2qgs9b15hTS6ZOIV3xaLxgaL8XpJj0Yqx/PrwlHUS0ORnwnA3Io=
X-Gm-Gg: ASbGncvurfaiz4gQIVG7zSaodCSzcTw3Ankmpj8yyiWZhwt0Q1TCeqOllHycGqldtGp
	qQ5hS2GmlunLlO4Kh17FzmyqXDmQTEbU1uypnwaoORFBCOJxsrWt8IwOHL8l81YeP4R0+dwKBAr
	e2GGfn4cnKa+oPMwVlmXGw7aOH6vHuGgWubo3XWmleWQzfXrKFj5wJUIAemR7r2QzqFOY4ofn9v
	EaRzgX3REPChji/esI+2u4Y+F/SkfAmvE77k3afkGxpZZe6MX+8KJl6fF57oDeA9FOBWO5ihbkq
	oSCZrpqgxx4f+Ewp/XuPb/sOS76BGDVomJcxGuxaZcsbUsuXFQzxmdBf2mOj5rYjXRvabToaKgL
	t8aoX4nKPmSXtwE3bOa9/fDOl1uqE1l9xc0kqJs4ciltEuS1woUhmG/7Nxt/l2LfQqdulcEP8cP
	+j0Ek2fU20OgQcKeboEXeHmB34EeTl/JwKazBr+IZTdlwK5EWaNiC1kQ==
X-Google-Smtp-Source: AGHT+IGyl9gTUlhqKvf7bWFyXToKYsATj7SdvLFGZ0eSD3zQLgSjQNxd1CMPXeNXJkwX2bLubLMF4Q==
X-Received: by 2002:a05:6a21:9997:b0:334:9e5e:c2c2 with SMTP id adf61e73a8af0-334a84c81famr5765358637.13.1760716785208;
        Fri, 17 Oct 2025 08:59:45 -0700 (PDT)
Received: from localhost.localdomain ([122.171.18.129])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a7669392csm151067a12.18.2025.10.17.08.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 08:59:44 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>,
	Andrew Jones <ajones@ventanamicro.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 2/4] RISC-V: KVM: Add separate source for forwarded SBI extensions
Date: Fri, 17 Oct 2025 21:29:23 +0530
Message-ID: <20251017155925.361560-3-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251017155925.361560-1-apatel@ventanamicro.com>
References: <20251017155925.361560-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a separate source vcpu_sbi_forward.c for SBI extensions
which are entirely forwarded to KVM user-space.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/Makefile           |  1 +
 arch/riscv/kvm/vcpu_sbi_base.c    | 12 ------------
 arch/riscv/kvm/vcpu_sbi_forward.c | 27 +++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_sbi_replace.c |  7 -------
 4 files changed, 28 insertions(+), 19 deletions(-)
 create mode 100644 arch/riscv/kvm/vcpu_sbi_forward.c

diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 07197395750e..3b8afb038b35 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -27,6 +27,7 @@ kvm-y += vcpu_onereg.o
 kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_pmu.o
 kvm-y += vcpu_sbi.o
 kvm-y += vcpu_sbi_base.o
+kvm-y += vcpu_sbi_forward.o
 kvm-y += vcpu_sbi_fwft.o
 kvm-y += vcpu_sbi_hsm.o
 kvm-$(CONFIG_RISCV_PMU_SBI) += vcpu_sbi_pmu.o
diff --git a/arch/riscv/kvm/vcpu_sbi_base.c b/arch/riscv/kvm/vcpu_sbi_base.c
index ca489f2dfbdf..06fdd5f69364 100644
--- a/arch/riscv/kvm/vcpu_sbi_base.c
+++ b/arch/riscv/kvm/vcpu_sbi_base.c
@@ -70,15 +70,3 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base = {
 	.extid_end = SBI_EXT_BASE,
 	.handler = kvm_sbi_ext_base_handler,
 };
-
-const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental = {
-	.extid_start = SBI_EXT_EXPERIMENTAL_START,
-	.extid_end = SBI_EXT_EXPERIMENTAL_END,
-	.handler = kvm_riscv_vcpu_sbi_forward_handler,
-};
-
-const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor = {
-	.extid_start = SBI_EXT_VENDOR_START,
-	.extid_end = SBI_EXT_VENDOR_END,
-	.handler = kvm_riscv_vcpu_sbi_forward_handler,
-};
diff --git a/arch/riscv/kvm/vcpu_sbi_forward.c b/arch/riscv/kvm/vcpu_sbi_forward.c
new file mode 100644
index 000000000000..dbfa70c2c775
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_sbi_forward.c
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2025 Ventana Micro Systems Inc.
+ */
+
+#include <linux/kvm_host.h>
+#include <asm/kvm_vcpu_sbi.h>
+#include <asm/sbi.h>
+
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental = {
+	.extid_start = SBI_EXT_EXPERIMENTAL_START,
+	.extid_end = SBI_EXT_EXPERIMENTAL_END,
+	.handler = kvm_riscv_vcpu_sbi_forward_handler,
+};
+
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor = {
+	.extid_start = SBI_EXT_VENDOR_START,
+	.extid_end = SBI_EXT_VENDOR_END,
+	.handler = kvm_riscv_vcpu_sbi_forward_handler,
+};
+
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_dbcn = {
+	.extid_start = SBI_EXT_DBCN,
+	.extid_end = SBI_EXT_DBCN,
+	.default_disabled = true,
+	.handler = kvm_riscv_vcpu_sbi_forward_handler,
+};
diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index 2c456e26f6ca..506a510b6bff 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -185,10 +185,3 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst = {
 	.extid_end = SBI_EXT_SRST,
 	.handler = kvm_sbi_ext_srst_handler,
 };
-
-const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_dbcn = {
-	.extid_start = SBI_EXT_DBCN,
-	.extid_end = SBI_EXT_DBCN,
-	.default_disabled = true,
-	.handler = kvm_riscv_vcpu_sbi_forward_handler,
-};
-- 
2.43.0


