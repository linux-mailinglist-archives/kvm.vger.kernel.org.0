Return-Path: <kvm+bounces-1994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D54F87EFFDB
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 14:29:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 65291B20A94
	for <lists+kvm@lfdr.de>; Sat, 18 Nov 2023 13:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CAD918AE6;
	Sat, 18 Nov 2023 13:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="D/soSBSb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2E6131
	for <kvm@vger.kernel.org>; Sat, 18 Nov 2023 05:29:18 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-3594560fa09so11317085ab.0
        for <kvm@vger.kernel.org>; Sat, 18 Nov 2023 05:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1700314157; x=1700918957; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/NWYPou+9ZBKqw7dOdhhBjudGD4+dyE7vHP+Jv0M59g=;
        b=D/soSBSbETwSLD2RYxP7DXtJ0wNXsPSzSZYXM68527iIjn6Q3XaO7EVrs+/2VMWnBs
         jWKtIttlMDKksP99JM+pZfBSa+rbGr8VQInFZAILDLVJGt1NSUheK7HMNbb15EMGEfE2
         Sb88KI5QhQz1HDeMKYlWtriexFNLXsIYtA+my3coK0wKKwEkmyZSBUCWmh8iVk+WR7X+
         yR5GxM7FYuyY3ermR6ZSzJSXolIS1H7Vbo9WbLBN9uHw5PDZNYXwlFqmV+/EBwEoa/P4
         EQPHB2q21rZaSprqDKYShh5LlprrPWs3XKefdseW+H/saFmF3dn5Ig0lZZdJzamGiwdM
         G8iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700314157; x=1700918957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/NWYPou+9ZBKqw7dOdhhBjudGD4+dyE7vHP+Jv0M59g=;
        b=q8OQZI8gFPbgyu5bL66r4Ae5mf6OUIakMeSCgfNgucs4iRnV8u60uje/RWhSs9q4Eg
         tGteBqNrIn3fqZJrjSPFKNidRXQ0SN0elrZmM9TfeWnC8usYEe2gWVbimIAkF0HC1zJn
         9cqHOUwpBhiXFjsofH8dQRS9gI8GD3bAUa2bYEs5xFVAxDuFolwf4WKOtGrt5J2Cko4B
         7D4p2+KrZ6MaWf+L5R7Cex7ySYW7XkgRcf9qGPIHxViW3jnQ/y5rkrhlgMcUiReOPhuG
         v6+/BYq0zfgwow2kPvrwQbp1X0V3tr/YTGlQvyQl8hSHdSEcl1iA8eP61NVeRw+u0gWG
         PqnA==
X-Gm-Message-State: AOJu0YwOTrOA7izyJ/K0xIDwMm8EisjmohpUeB1zQYUxszIMoiP14/fI
	0Ur5WvQnN7eRwrR6UEF3OUKxvQ==
X-Google-Smtp-Source: AGHT+IFwaKKfu1EMSrE+6nd4pbQgshpo1eAw9NrvBH+xl/iU7aOVXAzAoUlQHT6wDOhcQJjLVNDwWw==
X-Received: by 2002:a92:c90f:0:b0:357:677e:50e7 with SMTP id t15-20020a92c90f000000b00357677e50e7mr2340165ilp.27.1700314157273;
        Sat, 18 Nov 2023 05:29:17 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([171.76.80.108])
        by smtp.gmail.com with ESMTPSA id k25-20020a63ba19000000b005b944b20f34sm2627262pgf.85.2023.11.18.05.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Nov 2023 05:29:16 -0800 (PST)
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
Subject: [kvmtool PATCH v3 4/6] riscv: Add IRQFD support for in-kernel AIA irqchip
Date: Sat, 18 Nov 2023 18:58:45 +0530
Message-Id: <20231118132847.758785-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231118132847.758785-1-apatel@ventanamicro.com>
References: <20231118132847.758785-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To use irqfd with in-kernel AIA irqchip, we add custom
irq__add_irqfd and irq__del_irqfd functions. This allows
us to defer actual KVM_IRQFD ioctl() until AIA irqchip
is initialized by KVMTOOL.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 riscv/include/kvm/kvm-arch.h | 11 ++++++
 riscv/irq.c                  | 73 ++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
index 2c954ca..edff1ef 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -98,11 +98,22 @@ extern void (*riscv_irqchip_generate_fdt_node)(void *fdt, struct kvm *kvm);
 extern u32 riscv_irqchip_phandle;
 extern u32 riscv_irqchip_msi_phandle;
 extern bool riscv_irqchip_line_sensing;
+extern bool riscv_irqchip_irqfd_ready;
 
 void plic__create(struct kvm *kvm);
 
 void pci__generate_fdt_nodes(void *fdt);
 
+int riscv__add_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd,
+		     int resample_fd);
+
+void riscv__del_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd);
+
+#define irq__add_irqfd riscv__add_irqfd
+#define irq__del_irqfd riscv__del_irqfd
+
+int riscv__setup_irqfd_lines(struct kvm *kvm);
+
 void riscv__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type);
 
 void riscv__irqchip_create(struct kvm *kvm);
diff --git a/riscv/irq.c b/riscv/irq.c
index 043b681..b99a055 100644
--- a/riscv/irq.c
+++ b/riscv/irq.c
@@ -12,6 +12,7 @@ void (*riscv_irqchip_generate_fdt_node)(void *fdt, struct kvm *kvm) = NULL;
 u32 riscv_irqchip_phandle = PHANDLE_RESERVED;
 u32 riscv_irqchip_msi_phandle = PHANDLE_RESERVED;
 bool riscv_irqchip_line_sensing;
+bool riscv_irqchip_irqfd_ready;
 
 void kvm__irq_line(struct kvm *kvm, int irq, int level)
 {
@@ -46,6 +47,78 @@ void kvm__irq_trigger(struct kvm *kvm, int irq)
 	}
 }
 
+struct riscv_irqfd_line {
+	unsigned int		gsi;
+	int			trigger_fd;
+	int			resample_fd;
+	struct list_head	list;
+};
+
+static LIST_HEAD(irqfd_lines);
+
+int riscv__add_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd,
+		     int resample_fd)
+{
+	struct riscv_irqfd_line *line;
+
+	if (riscv_irqchip_irqfd_ready)
+		return irq__common_add_irqfd(kvm, gsi, trigger_fd,
+					     resample_fd);
+
+	/* Postpone the routing setup until irqchip is initialized */
+	line = malloc(sizeof(*line));
+	if (!line)
+		return -ENOMEM;
+
+	*line = (struct riscv_irqfd_line) {
+		.gsi		= gsi,
+		.trigger_fd	= trigger_fd,
+		.resample_fd	= resample_fd,
+	};
+	list_add(&line->list, &irqfd_lines);
+
+	return 0;
+}
+
+void riscv__del_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd)
+{
+	struct riscv_irqfd_line *line;
+
+	if (riscv_irqchip_irqfd_ready) {
+		irq__common_del_irqfd(kvm, gsi, trigger_fd);
+		return;
+	}
+
+	list_for_each_entry(line, &irqfd_lines, list) {
+		if (line->gsi != gsi)
+			continue;
+
+		list_del(&line->list);
+		free(line);
+		break;
+	}
+}
+
+int riscv__setup_irqfd_lines(struct kvm *kvm)
+{
+	int ret;
+	struct riscv_irqfd_line *line, *tmp;
+
+	list_for_each_entry_safe(line, tmp, &irqfd_lines, list) {
+		ret = irq__common_add_irqfd(kvm, line->gsi, line->trigger_fd,
+					    line->resample_fd);
+		if (ret < 0) {
+			pr_err("Failed to register IRQFD");
+			return ret;
+		}
+
+		list_del(&line->list);
+		free(line);
+	}
+
+	return 0;
+}
+
 void riscv__generate_irq_prop(void *fdt, u8 irq, enum irq_type irq_type)
 {
 	u32 prop[2], size;
-- 
2.34.1


