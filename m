Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2CEE7A1319
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 03:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbjIOBuK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 21:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbjIOBuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 21:50:05 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50986271E;
        Thu, 14 Sep 2023 18:50:00 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8CxbetFuANluf4nAA--.9229S3;
        Fri, 15 Sep 2023 09:49:57 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Axndw9uANl+ioGAA--.11927S10;
        Fri, 15 Sep 2023 09:49:56 +0800 (CST)
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
        Xi Ruoyao <xry111@xry111.site>, zhaotianrui@loongson.cn
Subject: [PATCH v21 08/29] LoongArch: KVM: Implement vcpu handle exit interface
Date:   Fri, 15 Sep 2023 09:49:28 +0800
Message-Id: <20230915014949.1222777-9-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
References: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Axndw9uANl+ioGAA--.11927S10
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement vcpu handle exit interface, getting the exit code by ESTAT
register and using kvm exception vector to handle it.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/vcpu.c | 41 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index a510082e9b..bfc2ec1a88 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -104,6 +104,47 @@ static int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+/*
+ * Return 1 for resume guest and "<= 0" for resume host.
+ */
+static int kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
+{
+	unsigned long exst = vcpu->arch.host_estat;
+	u32 intr = exst & 0x1fff; /* ignore NMI */
+	u32 exccode = (exst & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
+	int ret = RESUME_GUEST;
+
+	vcpu->mode = OUTSIDE_GUEST_MODE;
+
+	/* Set a default exit reason */
+	run->exit_reason = KVM_EXIT_UNKNOWN;
+
+	guest_timing_exit_irqoff();
+	guest_state_exit_irqoff();
+	local_irq_enable();
+
+	trace_kvm_exit(vcpu, exccode);
+	if (exccode) {
+		ret = kvm_handle_fault(vcpu, exccode);
+	} else {
+		WARN(!intr, "vm exiting with suspicious irq\n");
+		++vcpu->stat.int_exits;
+	}
+
+	if (ret == RESUME_GUEST)
+		ret = kvm_pre_enter_guest(vcpu);
+
+	if (ret != RESUME_GUEST) {
+		local_irq_disable();
+		return ret;
+	}
+
+	guest_timing_enter_irqoff();
+	guest_state_enter_irqoff();
+	trace_kvm_reenter(vcpu);
+	return RESUME_GUEST;
+}
+
 int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	unsigned long timer_hz;
-- 
2.39.1

