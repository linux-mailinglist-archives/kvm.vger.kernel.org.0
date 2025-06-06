Return-Path: <kvm+bounces-48692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 943C9AD0A85
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 01:57:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F3DEE189802A
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 23:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAEF0242D77;
	Fri,  6 Jun 2025 23:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E1cEbPcX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E7A241693
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 23:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749254215; cv=none; b=JUPmUKgPWXWvL48U88PhlfcP4iDx9IFJv5jPn4LZkb19IbKJlM/DW2qkmYeQVkjB+2ehM2mjwH9L1ateH03H+843kBLSLB6KYKTT9CnHOTIbSZ1YhHTLE2dffhOSeaCREpwXT0CQw3Wff9ztmsYI0rir7I/+P0Rh+C4Ra3ybzz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749254215; c=relaxed/simple;
	bh=tDZJ8MdVpbFF98N3E0urgkWbnwg6TPPRxGQmM7S5sCM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rw2LJCQebc++8g1FtFjmroVfRNvY8ntkBWRjeA36vI7AN5a9YIF4owsIakO/TR0IVeddUclZRNfZznMuKI9nt0+92iQgAS+xPUENnsyNL+DR4aWBOfHaQTXtg9w+qXSytcqWPSkhusphh8aD7zoAIhJYARxGagr5V105YiCcXWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E1cEbPcX; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vipinsh.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7462aff55bfso2346017b3a.2
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 16:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749254212; x=1749859012; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qu1B0vc7yWbsW+rKAINzGAVsuBa1AMOLkrNMvFT9P3s=;
        b=E1cEbPcXFuTjHorKJZP1rHnAEAtfBhDN5gMOVuSIoJ1mjyPf7rIpPeDFpNFtVFUSai
         XHpKr/H9/VYavfp1RtUQcK0heaXyu7ob2rRsGtWn/xu93kOJP/bn5UiVehn2owztfKW3
         T0eWNMyPTRyeXUovu0iYnPGiI2FKotHXGZ25BQYLTNd+M51abUWriT0qeDgShee4TJR3
         sn7rVKz/NQGiDJF5X8vdTKGzq6IUIrhDCwIqkL2KWOuOyxthB6dzQ9ZFAS4Zhy2YKzCE
         A7ZbOpv9ZzNe6AXor9JymWYBFlKJu09amQ/LFwIoEg0kULY0fjPv8IDP8MdTtbL8dTF5
         5bjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749254212; x=1749859012;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qu1B0vc7yWbsW+rKAINzGAVsuBa1AMOLkrNMvFT9P3s=;
        b=d2k7efWg6ErZ7t+WKureUxN6y4iYAACoBHlO80/DNV1UYFNb322pM7H3pqzGMVvn3/
         DiNF0mo56sj7tzs1ho6cRku2kD7zXdl8DhbO5kF2nYfWShIhe1gJLGriTjNd86t/CFTw
         WY7JT42HW8/NbPhPUgp/4fYpbHqVY8pRmlZslzIo/qgKlgDlhXwsmDUBAtpCYdVHcLWa
         f51AeAChgrxOMiJBDRqXY9+d0Z0cjmZxmu1xLpwZ0t5k9XJWVKmdmikH6b1ayEDlbjO7
         2yEAR55j4NKmReX0AGkwT7oYsD/Gm9z4ssrHoDx2hac9gtFeoa4shK9Lly5f4TQDoLnd
         R/og==
X-Gm-Message-State: AOJu0YzpBNepRhInxW3Lb/PQpf57ICeOopKQIpuu1pbYfdi1/FzgA3f0
	WoYHY3ITiuOX5r2CnI6J3coXmzCiTd88gVQ79RFUFOGC2sdQ9dUZve4+5/zKOtWYOiIcq+MCWcf
	XkS9GgRDow2oMGM2XGwOfAm21//c1FC0s6dOUYSp4RRPVjTfDTUpzuJ/ClhF5mmAewlQYbnQGrM
	IiiNHby69laTF6u8oBKKqm3IaMNS+TShx34YrRBw==
X-Google-Smtp-Source: AGHT+IE9Z9v/BE8RbJx8HxWBNlBZkwC9QUKC5wtM41pIlGUzD9tGi9yGCVQWA834njnwpPNlSWj8ZpkvvF9W
X-Received: from pfbhw18.prod.google.com ([2002:a05:6a00:8912:b0:748:8e9:968e])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:69b:b0:21a:de8e:5cc3
 with SMTP id adf61e73a8af0-21ee24cbf1bmr6832335637.4.1749254211881; Fri, 06
 Jun 2025 16:56:51 -0700 (PDT)
Date: Fri,  6 Jun 2025 16:56:17 -0700
In-Reply-To: <20250606235619.1841595-1-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250606235619.1841595-1-vipinsh@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250606235619.1841595-14-vipinsh@google.com>
Subject: [PATCH v2 13/15] KVM: selftests: Add arm64 auto generated test files
 for KVM Selftests Runner
From: Vipin Sharma <vipinsh@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org
Cc: seanjc@google.com, pbonzini@redhat.com, anup@brainfault.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	maz@kernel.org, oliver.upton@linux.dev, dmatlack@google.com, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"

Add auto generated test files for ARM platform.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/kvm/tests/arch_timer/default.test        | 1 +
 .../selftests/kvm/tests/arm64/aarch32_id_regs/default.test       | 1 +
 .../selftests/kvm/tests/arm64/arch_timer_edge_cases/default.test | 1 +
 .../selftests/kvm/tests/arm64/debug-exceptions/default.test      | 1 +
 tools/testing/selftests/kvm/tests/arm64/hypercalls/default.test  | 1 +
 tools/testing/selftests/kvm/tests/arm64/mmio_abort/default.test  | 1 +
 tools/testing/selftests/kvm/tests/arm64/no-vgic-v3/default.test  | 1 +
 .../selftests/kvm/tests/arm64/page_fault_test/default.test       | 1 +
 tools/testing/selftests/kvm/tests/arm64/psci_test/default.test   | 1 +
 tools/testing/selftests/kvm/tests/arm64/set_id_regs/default.test | 1 +
 .../testing/selftests/kvm/tests/arm64/smccc_filter/default.test  | 1 +
 .../selftests/kvm/tests/arm64/vcpu_width_config/default.test     | 1 +
 tools/testing/selftests/kvm/tests/arm64/vgic_init/default.test   | 1 +
 tools/testing/selftests/kvm/tests/arm64/vgic_irq/default.test    | 1 +
 .../selftests/kvm/tests/arm64/vgic_lpi_stress/default.test       | 1 +
 .../selftests/kvm/tests/arm64/vpmu_counter_access/default.test   | 1 +
 tools/testing/selftests/kvm/tests/get-reg-list/default.test      | 1 +
 17 files changed, 17 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/tests/arch_timer/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/aarch32_id_regs/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/arch_timer_edge_cases/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/debug-exceptions/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/hypercalls/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/mmio_abort/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/no-vgic-v3/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/page_fault_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/psci_test/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/set_id_regs/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/smccc_filter/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/vcpu_width_config/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/vgic_init/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/vgic_irq/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/vgic_lpi_stress/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/arm64/vpmu_counter_access/default.test
 create mode 100644 tools/testing/selftests/kvm/tests/get-reg-list/default.test

diff --git a/tools/testing/selftests/kvm/tests/arch_timer/default.test b/tools/testing/selftests/kvm/tests/arch_timer/default.test
new file mode 100644
index 000000000000..97cac72515e2
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arch_timer/default.test
@@ -0,0 +1 @@
+arch_timer
diff --git a/tools/testing/selftests/kvm/tests/arm64/aarch32_id_regs/default.test b/tools/testing/selftests/kvm/tests/arm64/aarch32_id_regs/default.test
new file mode 100644
index 000000000000..e9dc42eacb27
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/aarch32_id_regs/default.test
@@ -0,0 +1 @@
+arm64/aarch32_id_regs
diff --git a/tools/testing/selftests/kvm/tests/arm64/arch_timer_edge_cases/default.test b/tools/testing/selftests/kvm/tests/arm64/arch_timer_edge_cases/default.test
new file mode 100644
index 000000000000..ebc7f45fab7e
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/arch_timer_edge_cases/default.test
@@ -0,0 +1 @@
+arm64/arch_timer_edge_cases
diff --git a/tools/testing/selftests/kvm/tests/arm64/debug-exceptions/default.test b/tools/testing/selftests/kvm/tests/arm64/debug-exceptions/default.test
new file mode 100644
index 000000000000..dc427a64e1cd
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/debug-exceptions/default.test
@@ -0,0 +1 @@
+arm64/debug-exceptions
diff --git a/tools/testing/selftests/kvm/tests/arm64/hypercalls/default.test b/tools/testing/selftests/kvm/tests/arm64/hypercalls/default.test
new file mode 100644
index 000000000000..628731a70178
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/hypercalls/default.test
@@ -0,0 +1 @@
+arm64/hypercalls
diff --git a/tools/testing/selftests/kvm/tests/arm64/mmio_abort/default.test b/tools/testing/selftests/kvm/tests/arm64/mmio_abort/default.test
new file mode 100644
index 000000000000..94e2aef05572
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/mmio_abort/default.test
@@ -0,0 +1 @@
+arm64/mmio_abort
diff --git a/tools/testing/selftests/kvm/tests/arm64/no-vgic-v3/default.test b/tools/testing/selftests/kvm/tests/arm64/no-vgic-v3/default.test
new file mode 100644
index 000000000000..5fa28e3d6f9c
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/no-vgic-v3/default.test
@@ -0,0 +1 @@
+arm64/no-vgic-v3
diff --git a/tools/testing/selftests/kvm/tests/arm64/page_fault_test/default.test b/tools/testing/selftests/kvm/tests/arm64/page_fault_test/default.test
new file mode 100644
index 000000000000..dbf95af263d8
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/page_fault_test/default.test
@@ -0,0 +1 @@
+arm64/page_fault_test
diff --git a/tools/testing/selftests/kvm/tests/arm64/psci_test/default.test b/tools/testing/selftests/kvm/tests/arm64/psci_test/default.test
new file mode 100644
index 000000000000..1cbe0cee5277
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/psci_test/default.test
@@ -0,0 +1 @@
+arm64/psci_test
diff --git a/tools/testing/selftests/kvm/tests/arm64/set_id_regs/default.test b/tools/testing/selftests/kvm/tests/arm64/set_id_regs/default.test
new file mode 100644
index 000000000000..e305642fda26
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/set_id_regs/default.test
@@ -0,0 +1 @@
+arm64/set_id_regs
diff --git a/tools/testing/selftests/kvm/tests/arm64/smccc_filter/default.test b/tools/testing/selftests/kvm/tests/arm64/smccc_filter/default.test
new file mode 100644
index 000000000000..98dd986522a1
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/smccc_filter/default.test
@@ -0,0 +1 @@
+arm64/smccc_filter
diff --git a/tools/testing/selftests/kvm/tests/arm64/vcpu_width_config/default.test b/tools/testing/selftests/kvm/tests/arm64/vcpu_width_config/default.test
new file mode 100644
index 000000000000..d00fd74341ac
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/vcpu_width_config/default.test
@@ -0,0 +1 @@
+arm64/vcpu_width_config
diff --git a/tools/testing/selftests/kvm/tests/arm64/vgic_init/default.test b/tools/testing/selftests/kvm/tests/arm64/vgic_init/default.test
new file mode 100644
index 000000000000..7835ba6157b5
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/vgic_init/default.test
@@ -0,0 +1 @@
+arm64/vgic_init
diff --git a/tools/testing/selftests/kvm/tests/arm64/vgic_irq/default.test b/tools/testing/selftests/kvm/tests/arm64/vgic_irq/default.test
new file mode 100644
index 000000000000..387612d50530
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/vgic_irq/default.test
@@ -0,0 +1 @@
+arm64/vgic_irq
diff --git a/tools/testing/selftests/kvm/tests/arm64/vgic_lpi_stress/default.test b/tools/testing/selftests/kvm/tests/arm64/vgic_lpi_stress/default.test
new file mode 100644
index 000000000000..c31424bc5a88
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/vgic_lpi_stress/default.test
@@ -0,0 +1 @@
+arm64/vgic_lpi_stress
diff --git a/tools/testing/selftests/kvm/tests/arm64/vpmu_counter_access/default.test b/tools/testing/selftests/kvm/tests/arm64/vpmu_counter_access/default.test
new file mode 100644
index 000000000000..505743df541f
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/arm64/vpmu_counter_access/default.test
@@ -0,0 +1 @@
+arm64/vpmu_counter_access
diff --git a/tools/testing/selftests/kvm/tests/get-reg-list/default.test b/tools/testing/selftests/kvm/tests/get-reg-list/default.test
new file mode 100644
index 000000000000..07b9427b9f83
--- /dev/null
+++ b/tools/testing/selftests/kvm/tests/get-reg-list/default.test
@@ -0,0 +1 @@
+get-reg-list
-- 
2.50.0.rc0.604.gd4ff7b7c86-goog


