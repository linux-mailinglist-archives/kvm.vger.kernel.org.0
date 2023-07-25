Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D31761D50
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 17:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232460AbjGYPZG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 11:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbjGYPZE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 11:25:04 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7192E19A0
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 08:25:01 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-55c85b4b06bso2791381a12.2
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 08:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690298700; x=1690903500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KmV7pFH2le45W0zYvv375dH/RbXk4UJgWsqV9AR30r4=;
        b=opirc2Sx26XhjyrDHGYOlKWZRfBGnJ64gJULDLRZBEqOOf9kcXuLlUH2O6PlWD5fxZ
         OuvLZCff3HHTGskc6gpY1LMGbcHnw2FfAKG40+RpewXFkEy4ZaZFlH/7MjB3RbsdMzZr
         /HE7jLk8PobNTz6dUVkNVJgZnzR2zOxsps3NSEYHUand9kMK0OuwOccjOy5SyJ/r+mFN
         U2F7YrHYlfVNyUuwviu767IyQ++nS+1fjO6exRkkp2n9tUB87eu9Rkm7R1I8PW/vGM5l
         1se55TSkMiPJmvfk97yFgJCwNvF8If97cm3eMBggKRSW9RLrGcfSf0xuDQ0KjnWNBpQP
         UjUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690298700; x=1690903500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KmV7pFH2le45W0zYvv375dH/RbXk4UJgWsqV9AR30r4=;
        b=b2VxZV+bUy6T2wwW+ZZNRGHgw5I6c+vf4gSuWinqdUd4+NqF7VEbSoCULUNqK+VVb7
         iap5WNAoKcBwvfIss+AZkiA3AK6nnSKFpEinT/j2y9d2uFUVe5q3Ll11+fzdmfYE9nBW
         pcNKekBS4Tl//6shi77pUo173kY9Frm2vAaBFnDwc0IliKPDNrX2uay83iuubn1V3O9P
         3O31MLSGDeZcknr/089cewStzPVwM3T/0tj8fncJaB0u1BOIc+p2Aj/nKOJKHr37g1xi
         09m1cg8GymmnRQd0YhVgLlYQytGTCdZyxve2zMB8/2dhXAsEIeYiJkuU8I9fxrOJmx1T
         VfxQ==
X-Gm-Message-State: ABy/qLYs2BqF7JyoNjByu3+KAh9M9lvISxpNFopGMnbM+m/8FHtAAtc7
        MIQ4735k8rpODSxyMEXdDX7HOg==
X-Google-Smtp-Source: APBJJlEZBz76mCDZTOajbTxYmEh+/YhGYOu3toN8Yi9ExPtP+pw4wrvb5P93yRM9Bx0OmAY66KnKbw==
X-Received: by 2002:a17:90a:e398:b0:263:59a7:8799 with SMTP id b24-20020a17090ae39800b0026359a78799mr7951525pjz.22.1690298700222;
        Tue, 25 Jul 2023 08:25:00 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id g11-20020a17090adb0b00b002683fd66663sm980372pjv.22.2023.07.25.08.24.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 08:24:59 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH 4/6] riscv: Add IRQFD support for in-kernel AIA irqchip
Date:   Tue, 25 Jul 2023 20:54:28 +0530
Message-Id: <20230725152430.3351564-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230725152430.3351564-1-apatel@ventanamicro.com>
References: <20230725152430.3351564-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To use irqfd with in-kernel AIA irqchip, we add custom
irq__add_irqfd and irq__del_irqfd functions. This allows
us to defer actual KVM_IRQFD ioctl() until AIA irqchip
is initialized by KVMTOOL.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/include/kvm/kvm-arch.h | 11 ++++++
 riscv/irq.c                  | 73 ++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
index cd37fc6..1a8af6a 100644
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
index b608a2f..e6c0939 100644
--- a/riscv/irq.c
+++ b/riscv/irq.c
@@ -12,6 +12,7 @@ void (*riscv_irqchip_generate_fdt_node)(void *fdt, struct kvm *kvm) = NULL;
 u32 riscv_irqchip_phandle = PHANDLE_RESERVED;
 u32 riscv_irqchip_msi_phandle = PHANDLE_RESERVED;
 bool riscv_irqchip_line_sensing = false;
+bool riscv_irqchip_irqfd_ready = false;
 
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
+	/* Postpone the routing setup until we have a distributor */
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

