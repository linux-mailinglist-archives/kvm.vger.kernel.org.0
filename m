Return-Path: <kvm+bounces-2843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0E757FE835
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 05:16:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE11B1C20C1D
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 04:16:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DECE168C0;
	Thu, 30 Nov 2023 04:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="XTgnV0Pi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465F5D66
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 20:16:47 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-6cdce15f0a3so1318349b3a.1
        for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 20:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701317807; x=1701922607; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=y6aGoq4wfRBMckJevg1vwOCIApJGZHlwnU+/MjsZGfY=;
        b=XTgnV0PiuKDtyL6+coFKCHUEgMEgNhKQIDZB58Yob4GEi9mTfkdfJ9VhMMxNci7ix0
         bNH6DkepgnBXIWolOCw/BDGceiYkzWZWbJ0D7elZqg+ycg+xX8m6bkL/vaU4cgA2FCxS
         QYSjDvtsEFra/labxJNyg7j4msOl5oH6qBq++/AOJfsxkrIgrqsREcUfz0t1S/ThluVa
         TkJs+8NhKEu+sHBlmh0JGRysL+DPzd1vcpU0HBIeKplDO/o1/yTKr2wGeIDgJOHn66VX
         52IwoFiI9h3d8c/VyNBm+HRxO6p9Pm0dQnKTho/oqamvJv+0GDwI8MO2Zx1rcpSDROCC
         pSOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701317807; x=1701922607;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y6aGoq4wfRBMckJevg1vwOCIApJGZHlwnU+/MjsZGfY=;
        b=tRFmtSdcT6qlMNcEc29kKWI8DG3imyN9LqLxsY2zuhF9wUWKhMe19mW+JzNXL3c9Av
         VFmtbmp5m//NGV++l6GBmyeze2MrytXhuOBv7UcV6l6L0khVV02FQXp+SMd+dJ0efIdw
         Kt5Bk5OJCF11z0pndCkee4TfYv4cveNKT6brNlPLJ8z9gRDxkSHTMW1GbIfWJBSo7o2d
         Ih6IJ88SyV0SlHe3HSy/h5X+GgLiTDlGveZYq+SkHMEbllEAEoaMi9jclm5IniGpZKDU
         jD5XE6oIKXVS0TgjnCUllAnDqd9eBJbmEnp3R+iiOu7BGudDy0GBLMu6+BKHvwq4iVrd
         YGCw==
X-Gm-Message-State: AOJu0YwbbXJT8NSYplItDSverBCKaLB0LlI5Tc3BrCfSv71a82zNgRs8
	61aPF8cEIaRSOTDOk73jF7K0qQ==
X-Google-Smtp-Source: AGHT+IHSQ2ILuSbOQgKkF5qVcwSBpaLZePV7ynQrDgiLrrdQHNoOu22QTGvs7K2QqdZEWhsxgu7QFw==
X-Received: by 2002:a05:6a20:7d88:b0:18c:3199:7174 with SMTP id v8-20020a056a207d8800b0018c31997174mr27137856pzj.19.1701317806545;
        Wed, 29 Nov 2023 20:16:46 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([171.76.83.234])
        by smtp.gmail.com with ESMTPSA id q1-20020a656841000000b00577d53c50f7sm196001pgt.75.2023.11.29.20.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 20:16:46 -0800 (PST)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH] riscv: Fix guest poweroff when using PLIC emulation
Date: Thu, 30 Nov 2023 09:46:33 +0530
Message-Id: <20231130041633.78725-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recently due to commit 74af1456dfa0, the virtio device emulation
in KVMTOOL now calls irq__update_msix_route() upon guest poweroff
which results in KVMTOOL crash when Guest uses PLIC emulation in
user space. This is because irq__update_msix_route() expects the
irq_routing table to be available but the KVMTOOL PLIC emulation
does not populate any irq_routing entries.

Fixes: 74af1456dfa0 ("virtio: Cancel and join threads when exiting devices devices")
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/plic.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/riscv/plic.c b/riscv/plic.c
index ab7c574..6bd13ac 100644
--- a/riscv/plic.c
+++ b/riscv/plic.c
@@ -95,6 +95,8 @@
 
 #define REG_SIZE		0x1000000
 
+#define IRQCHIP_PLIC_NR		0
+
 struct plic_state;
 
 struct plic_context {
@@ -500,6 +502,33 @@ static void plic__generate_fdt_node(void *fdt, struct kvm *kvm)
 	free(irq_cells);
 }
 
+static int plic__irq_routing_init(struct kvm *kvm)
+{
+	int r;
+
+	/*
+	 * This describes the default routing that the kernel uses without
+	 * any routing explicitly set up via KVM_SET_GSI_ROUTING. So we
+	 * don't need to commit these setting right now. The first actual
+	 * user (MSI routing) will engage these mappings then.
+	 */
+	for (next_gsi = 0; next_gsi < MAX_DEVICES; next_gsi++) {
+		r = irq__allocate_routing_entry();
+		if (r)
+			return r;
+
+		irq_routing->entries[irq_routing->nr++] =
+			(struct kvm_irq_routing_entry) {
+				.gsi = next_gsi,
+				.type = KVM_IRQ_ROUTING_IRQCHIP,
+				.u.irqchip.irqchip = IRQCHIP_PLIC_NR,
+				.u.irqchip.pin = next_gsi,
+		};
+	}
+
+	return 0;
+}
+
 static int plic__init(struct kvm *kvm)
 {
 	u32 i;
@@ -535,6 +564,9 @@ static int plic__init(struct kvm *kvm)
 	if (ret)
 		return ret;
 
+	/* Setup default IRQ routing */
+	plic__irq_routing_init(kvm);
+
 	plic.ready = true;
 
 	return 0;
-- 
2.34.1


