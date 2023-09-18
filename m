Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0077A4A52
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 14:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242045AbjIRM6o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 08:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242051AbjIRM63 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 08:58:29 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C2FB5
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 05:57:58 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 98e67ed59e1d1-2746889aa89so2875907a91.2
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 05:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1695041877; x=1695646677; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KmV7pFH2le45W0zYvv375dH/RbXk4UJgWsqV9AR30r4=;
        b=hTCazwzVoahn2X0x3d/SyEdBxYmQ8PwTkvjIoAEQvXTL4/j9RfG93b74ORx9tiihmN
         haUVBdUHciWQcPXk44vFLN2aQOT1aGjqs3lxLnewqGiNLM0/yd+tGBXkD0u8O42pLAbl
         DXmiaDpuWPnzTbzzufbACF/I1gFROMookbYYe6P/sQc5KQy1CaQ7rVJMxzejOSfh7ENF
         xt+4bLk0hW5vksHWOw1DKg88b9lNYWo0XN3rBamWEDBbPQ1ukKlmVpAJf6kxXsvjErIH
         XE/dnOZ1fDkRPcxPgtPWgZzmloeBCfErXNJpRwEY4uJawo197D+VBroP0iwyDyMPWznz
         Jzmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695041877; x=1695646677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KmV7pFH2le45W0zYvv375dH/RbXk4UJgWsqV9AR30r4=;
        b=Ec+OcXC71PGHrXjbBIgYN+wPeg81Toz+01Gik9uKUSpfPNRuxf1p9VRtHG+6kg7hFI
         kGybv5qQSw23ArHVZTxuBPn1xGrjFvfwmZx93z4mbeAdHJGAXMKq6wY9PY1cp4NFWKIt
         uYhdhCunbfiXQ17Y3vYyotSNcqLwKleLreafIp9IKBTtJ18ZiOUFIE5Qsygiu/n7xJKu
         3l0kZ/HcOu5CSHlZDK4q/vC+DX+RDGpkf6XHE8cEm2b1DHYyZDOx3g7SwdpCD1bw/Yz4
         YsYh+YE5QHbZG27UnoLTpPQrAKDuf5VS/ragTkbD5aoKvOUln1YQzFKJpKzrn1iMXwEV
         jANw==
X-Gm-Message-State: AOJu0Yw0K7+pxuO7EjnB0YiBFnWxth9m9dpXtox6OwzJ84tA+7xQp37A
        gQOp+lCfYvXoOySpgBOUM5nnLg==
X-Google-Smtp-Source: AGHT+IGk5MLNwpZLVgU9h70BeFqJrUTPz77WqQwnhySO1434i+eEDZ7iweVm7kE13EJVa9X9VFV84Q==
X-Received: by 2002:a17:90a:c0f:b0:271:80f2:52bd with SMTP id 15-20020a17090a0c0f00b0027180f252bdmr5748565pjs.35.1695041877380;
        Mon, 18 Sep 2023 05:57:57 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id n14-20020a17090ac68e00b002680b2d2ab6sm8890237pjt.19.2023.09.18.05.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 05:57:56 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v2 4/6] riscv: Add IRQFD support for in-kernel AIA irqchip
Date:   Mon, 18 Sep 2023 18:27:28 +0530
Message-Id: <20230918125730.1371985-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230918125730.1371985-1-apatel@ventanamicro.com>
References: <20230918125730.1371985-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

