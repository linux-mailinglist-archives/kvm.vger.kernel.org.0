Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2A16E84F8
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbjDSWaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbjDSW3h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:29:37 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE31B9778
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:28:26 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id 46e09a7af769-6a60630574aso295039a34.1
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681943251; x=1684535251;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a40XLfKnT38y+rtkL3pdG8Ux1IFfCO6rS0FTBqpEPf0=;
        b=gOe3tlEuMP9Kdiuoo9Fwp5YpqQIznnT58Xka0jTIADKKug+AJObIdvVjyw20Co58Gc
         67dIb9pE33Zju/jaYu4dI3j/GBljc1wjRO5cGGuKvtdDBtUSctcDceG27oZudXAX8gJl
         MrvS6pAiI+6y3B0OSvtwkCM6ibv3Ex9na1q3Be7gVS1BgqaOWv/MMSt3XS/hFel1S1Us
         2Co6jRHVd0pgDBR64870dBjwokJ8jhNTu/9WRgKVUqc1XrEgWPOC2ja3WAfuCsbndIYI
         ZgCGq0f9wDBngl57wQk3QvCegDgDvLuQyMzYJ3urTKf4OC4L9XB8PQl1Ap73RRSSGcnb
         gyOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681943251; x=1684535251;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a40XLfKnT38y+rtkL3pdG8Ux1IFfCO6rS0FTBqpEPf0=;
        b=Vwv5h4Bq2tBRjYQ1lYblTwilwEUWUZu8eOmVlFC4Cnq7MoeSf3Yg3OHKT/iZfS5M2H
         joCdbYNQlfvczi+gXuOQwPDtaF2tcw7mn8/u4bh2A8zXRtBiGUl+cVllDFF2RCi7IJy0
         gfVzlQiafDFsdcRKlh/824vLEunbSkgLpJmi5azk1LIBO8R6vJWamRAXmkyKYLtTMq0v
         aOqKNATvxL35h0wBHXiqADi7v2KIf7nM7QQbqNazNlCVgPhQpxuJf+RPNVXSnefRpz8s
         F/cIHMSwWPAgzEnrBCumiIuFFFOId3NjE+Ji86VKztVio3z0c0JoA/amNhhvGHkopCFg
         GwKw==
X-Gm-Message-State: AAQBX9dLTVsZSp/Wom4fWl2EhxYy9+UwY5F3UuWnOtyefQ5ACcAcKy8F
        usBe8JljGJk3hb03q0JYL7aEBneKUu6QRbTw+LM=
X-Google-Smtp-Source: AKy350YLjqHMzW16SB61ZrKO34D3/TlmDW2rBvoLEyn4qa6+KyWVGCYv7MHLqblqPruYYQP5o2V7iQ==
X-Received: by 2002:a17:902:ea0e:b0:1a1:ee8c:eef5 with SMTP id s14-20020a170902ea0e00b001a1ee8ceef5mr7846112plg.7.1681942742761;
        Wed, 19 Apr 2023 15:19:02 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:19:02 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Atish Patra <atishp@rivosinc.com>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC 42/48] RISC-V: Allow host to inject any ext interrupt id to a CoVE guest.
Date:   Wed, 19 Apr 2023 15:17:10 -0700
Message-Id: <20230419221716.3603068-43-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419221716.3603068-1-atishp@rivosinc.com>
References: <20230419221716.3603068-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Rajnesh Kanwal <rkanwal@rivosinc.com>

Ideally, host must not inject any external interrupt until explicitly
allowed by the guest. This should be done per interrupt id but currently
adding allow-all call in init_IRQ. In future, it will be modified
to allow specific interrupts only.

Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kernel/irq.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/riscv/kernel/irq.c b/arch/riscv/kernel/irq.c
index eb9a68a..b5e0fd8 100644
--- a/arch/riscv/kernel/irq.c
+++ b/arch/riscv/kernel/irq.c
@@ -11,6 +11,8 @@
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <asm/sbi.h>
+#include <asm/covg_sbi.h>
+#include <asm/cove.h>
 
 static struct fwnode_handle *(*__get_intc_node)(void);
 
@@ -36,8 +38,18 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 
 void __init init_IRQ(void)
 {
+	int ret;
+
 	irqchip_init();
 	if (!handle_arch_irq)
 		panic("No interrupt controller found.");
 	sbi_ipi_init();
+
+	if (is_cove_guest()) {
+		/* FIXME: For now just allow all interrupts. */
+		ret = sbi_covg_allow_all_external_interrupt();
+
+		if (ret)
+			pr_err("Failed to allow external interrupts.\n");
+	}
 }
-- 
2.25.1

