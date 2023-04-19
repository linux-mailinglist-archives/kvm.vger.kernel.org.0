Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915616E84E1
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbjDSW1Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbjDSW1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:27:01 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22FC7C141
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:25:35 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-63b70f0b320so492666b3a.1
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681943061; x=1684535061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=joeGaZNojBtAEH48oFyXyXsTdXyxZ+syATM0NtCwkJg=;
        b=Hy5Vjaj1GFlfqXFgFU4Wk7wYhL+AdW+GISShF7pbpQzBCAzoyX06mKj9riDONUvoTu
         KJygh5nscsoyPvItPChqrHSXQPxDp5bYRAnKsEvFqcmijRhCw38xeSwetTsF9AvkbUYf
         hVmE7FSAH4Q4wrzRD6pw23VK9AaSnKgovUSlZ9QXs++6xGQZcPVEtNzbYKNpDmb7ydxL
         pihm7AbjTblUz+nkMI32xYxKW27gseqDrV0RGKN4T43bczPSmCXLp3fRh/utmO9YHtoB
         Sey/VFplr9PE2lySTaLRpT3t0lbZnm/yfBcOsJhGI8vtN1zAVWuoZu9OzywwnPC3RL4n
         V1wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681943061; x=1684535061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=joeGaZNojBtAEH48oFyXyXsTdXyxZ+syATM0NtCwkJg=;
        b=hLm9O8wfrozOKZBSrKoBvLYhq9tkCObdF8qX+TjtMTHrEtcmSP2bdDICN9/OLBmVf3
         KCOeE0efq5KwsVn9UyIVycAl6R1UDKJsYL81Ml3aH6ecQsx4nyWZZswpE4tJyurkpp8W
         Qoh5X9/JnOl21wdu0GUkDQEyyqmLcUHDehTx/8dEHzgvyVnbzglLAQvkduMo5/3+9yGG
         TPIlmVFumJFTGwpfsu2Vl/IG7KunWXrysKXgXKSXlUyo+0ZOmZqPfQkgTV+UkuDG8G0O
         c3FUxSCgsevQxj5TKLYJL616rDoLDU17uZqKTHXgo3w1XB5uaKys1p7GB2GyxkhOwcji
         5qFg==
X-Gm-Message-State: AAQBX9cwKSht8pNIQI/XkYKOZ8mAzJthIY+4Gy2dce8BCxC587Tjeguu
        M3fSZvQK3GPSl+B/nrj9soZbdEAHcpoBZfrYJhk=
X-Google-Smtp-Source: AKy350bpDV/yb/MMXonhLvjhCzwnd1ozKuOFojavKdcbbpka5zKY4L/5Rw/zrIiOtje9GuJuXPaRMw==
X-Received: by 2002:a17:902:7891:b0:1a1:bf22:2b6e with SMTP id q17-20020a170902789100b001a1bf222b6emr6634040pll.43.1681943060762;
        Wed, 19 Apr 2023 15:24:20 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id e4-20020a170902744400b001a681fb3e77sm11867810plt.44.2023.04.19.15.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:24:20 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC kvmtool 10/10] riscv: cove: Don't emit interrupt_map for pci devices in fdt.
Date:   Wed, 19 Apr 2023 15:23:50 -0700
Message-Id: <20230419222350.3604274-11-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419222350.3604274-1-atishp@rivosinc.com>
References: <20230419222350.3604274-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Rajnesh Kanwal <rkanwal@rivosinc.com>

CoVE VMs don't support pin based interrupts yet as APLIC isn't
supported.

Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
---
 riscv/fdt.c                  |  2 +-
 riscv/include/kvm/kvm-arch.h |  2 +-
 riscv/pci.c                  | 83 +++++++++++++++++++-----------------
 3 files changed, 46 insertions(+), 41 deletions(-)

diff --git a/riscv/fdt.c b/riscv/fdt.c
index a7d32b3..115ae17 100644
--- a/riscv/fdt.c
+++ b/riscv/fdt.c
@@ -232,7 +232,7 @@ static int setup_fdt(struct kvm *kvm)
 	}
 
 	/* PCI host controller */
-	pci__generate_fdt_nodes(fdt);
+	pci__generate_fdt_nodes(fdt, kvm);
 
 	_FDT(fdt_end_node(fdt));
 
diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
index 08ac54a..9f6967f 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -104,7 +104,7 @@ void aia__create(struct kvm *kvm);
 
 void plic__create(struct kvm *kvm);
 
-void pci__generate_fdt_nodes(void *fdt);
+void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm);
 
 int riscv__add_irqfd(struct kvm *kvm, unsigned int gsi, int trigger_fd,
 		     int resample_fd);
diff --git a/riscv/pci.c b/riscv/pci.c
index 9760ca3..31ea286 100644
--- a/riscv/pci.c
+++ b/riscv/pci.c
@@ -17,7 +17,7 @@ struct of_interrupt_map_entry {
 	u32				irqchip_sense;
 } __attribute__((packed));
 
-void pci__generate_fdt_nodes(void *fdt)
+void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	struct device_header *dev_hdr;
 	struct of_interrupt_map_entry irq_map[OF_PCI_IRQ_MAP_MAX];
@@ -67,51 +67,56 @@ void pci__generate_fdt_nodes(void *fdt)
 	_FDT(fdt_property(fdt, "reg", &cfg_reg_prop, sizeof(cfg_reg_prop)));
 	_FDT(fdt_property(fdt, "ranges", ranges, sizeof(ranges)));
 
-	/* Generate the interrupt map ... */
-	dev_hdr = device__first_dev(DEVICE_BUS_PCI);
-	while (dev_hdr && nentries < ARRAY_SIZE(irq_map)) {
-		struct of_interrupt_map_entry *entry;
-		struct pci_device_header *pci_hdr = dev_hdr->data;
-		u8 dev_num = dev_hdr->dev_num;
-		u8 pin = pci_hdr->irq_pin;
-		u8 irq = pci_hdr->irq_line;
+	/* CoVE VMs do not support pin based interrupts yet as APLIC isn't
+	 * supported.
+	 */
+	if (!kvm->cfg.arch.cove_vm) {
+		/* Generate the interrupt map ... */
+		dev_hdr = device__first_dev(DEVICE_BUS_PCI);
+		while (dev_hdr && nentries < ARRAY_SIZE(irq_map)) {
+			struct of_interrupt_map_entry *entry;
+			struct pci_device_header *pci_hdr = dev_hdr->data;
+			u8 dev_num = dev_hdr->dev_num;
+			u8 pin = pci_hdr->irq_pin;
+			u8 irq = pci_hdr->irq_line;
 
-		entry = ((void *)irq_map) + (nsize * nentries);
-		*entry = (struct of_interrupt_map_entry) {
-			.pci_irq_mask = {
-				.pci_addr = {
-					.hi	= cpu_to_fdt32(of_pci_b_ddddd(dev_num)),
-					.mid	= 0,
-					.lo	= 0,
+			entry = ((void *)irq_map) + (nsize * nentries);
+			*entry = (struct of_interrupt_map_entry) {
+				.pci_irq_mask = {
+					.pci_addr = {
+						.hi	= cpu_to_fdt32(of_pci_b_ddddd(dev_num)),
+						.mid	= 0,
+						.lo	= 0,
+					},
+					.pci_pin	= cpu_to_fdt32(pin),
 				},
-				.pci_pin	= cpu_to_fdt32(pin),
-			},
-			.irqchip_phandle	= cpu_to_fdt32(riscv_irqchip_phandle),
-			.irqchip_line		= cpu_to_fdt32(irq),
-		};
+				.irqchip_phandle	= cpu_to_fdt32(riscv_irqchip_phandle),
+				.irqchip_line		= cpu_to_fdt32(irq),
+			};
 
-		if (riscv_irqchip_line_sensing)
-			entry->irqchip_sense = cpu_to_fdt32(IRQ_TYPE_LEVEL_HIGH);
+			if (riscv_irqchip_line_sensing)
+				entry->irqchip_sense = cpu_to_fdt32(IRQ_TYPE_LEVEL_HIGH);
 
-		nentries++;
-		dev_hdr = device__next_dev(dev_hdr);
-	}
+			nentries++;
+			dev_hdr = device__next_dev(dev_hdr);
+		}
 
-	_FDT(fdt_property(fdt, "interrupt-map", irq_map, nsize * nentries));
+		_FDT(fdt_property(fdt, "interrupt-map", irq_map, nsize * nentries));
 
-	/* ... and the corresponding mask. */
-	if (nentries) {
-		struct of_pci_irq_mask irq_mask = {
-			.pci_addr = {
-				.hi	= cpu_to_fdt32(of_pci_b_ddddd(-1)),
-				.mid	= 0,
-				.lo	= 0,
-			},
-			.pci_pin	= cpu_to_fdt32(7),
-		};
+		/* ... and the corresponding mask. */
+		if (nentries) {
+			struct of_pci_irq_mask irq_mask = {
+				.pci_addr = {
+					.hi	= cpu_to_fdt32(of_pci_b_ddddd(-1)),
+					.mid	= 0,
+					.lo	= 0,
+				},
+				.pci_pin	= cpu_to_fdt32(7),
+			};
 
-		_FDT(fdt_property(fdt, "interrupt-map-mask", &irq_mask,
-				  sizeof(irq_mask)));
+			_FDT(fdt_property(fdt, "interrupt-map-mask", &irq_mask,
+					  sizeof(irq_mask)));
+		}
 	}
 
 	/* Set MSI parent if available */
-- 
2.25.1

