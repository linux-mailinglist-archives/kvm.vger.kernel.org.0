Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33EAA729486
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 11:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240324AbjFIJPu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 05:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241517AbjFIJO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 05:14:57 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9AD985B85;
        Fri,  9 Jun 2023 02:10:59 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Dxi+oZ7IJkjv0AAA--.2946S3;
        Fri, 09 Jun 2023 17:08:41 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxFOQQ7IJkzHQKAA--.31790S19;
        Fri, 09 Jun 2023 17:08:40 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn,
        tangyouling@loongson.cn
Subject: [PATCH v13 17/30] LoongArch: KVM: Implement virtual machine tlb operations
Date:   Fri,  9 Jun 2023 17:08:19 +0800
Message-Id: <20230609090832.2131037-18-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230609090832.2131037-1-zhaotianrui@loongson.cn>
References: <20230609090832.2131037-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxFOQQ7IJkzHQKAA--.31790S19
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement LoongArch virtual machine tlb operations such as flush tlb by
specific gpa parameter and flush all of the virt machines tlb.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/tlb.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 arch/loongarch/kvm/tlb.c

diff --git a/arch/loongarch/kvm/tlb.c b/arch/loongarch/kvm/tlb.c
new file mode 100644
index 000000000000..3475b76492ad
--- /dev/null
+++ b/arch/loongarch/kvm/tlb.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
+ */
+
+#include <linux/kvm_host.h>
+#include <asm/tlb.h>
+#include <asm/kvm_csr.h>
+
+int kvm_flush_tlb_gpa(struct kvm_vcpu *vcpu, unsigned long gpa)
+{
+	preempt_disable();
+	gpa &= (PAGE_MASK << 1);
+	invtlb(INVTLB_GID_ADDR, read_csr_gstat() & CSR_GSTAT_GID, gpa);
+	preempt_enable();
+	return 0;
+}
+
+/**
+ * kvm_flush_tlb_all() - Flush all root TLB entries for
+ * guests.
+ *
+ * Invalidate all entries including GVA-->GPA and GPA-->HPA mappings.
+ */
+void kvm_flush_tlb_all(void)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	invtlb_all(INVTLB_ALLGID, 0, 0);
+	local_irq_restore(flags);
+}
-- 
2.39.1

