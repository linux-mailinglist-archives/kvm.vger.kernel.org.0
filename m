Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C6D75A67C
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 08:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbjGTG3w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 02:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbjGTG3U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 02:29:20 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7CC9C272D;
        Wed, 19 Jul 2023 23:28:33 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8BxyeoG1Lhk9Y0HAA--.9951S3;
        Thu, 20 Jul 2023 14:28:22 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxvM7907hkHU81AA--.16059S28;
        Thu, 20 Jul 2023 14:28:22 +0800 (CST)
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
Subject: [PATCH v17 26/30] LoongArch: KVM: Implement kvm exception vector
Date:   Thu, 20 Jul 2023 14:28:09 +0800
Message-Id: <20230720062813.4126751-27-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230720062813.4126751-1-zhaotianrui@loongson.cn>
References: <20230720062813.4126751-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxvM7907hkHU81AA--.16059S28
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement kvm exception vector, using _kvm_fault_tables array to save
the handle function pointer and it is used when vcpu handle exit.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/exit.c | 46 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 17e94ecec140..b49b99888424 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -657,3 +657,49 @@ static int _kvm_handle_fpu_disabled(struct kvm_vcpu *vcpu)
 	kvm_own_fpu(vcpu);
 	return RESUME_GUEST;
 }
+
+/*
+ * Loongarch KVM callback handling for not implemented guest exiting
+ */
+static int _kvm_fault_ni(struct kvm_vcpu *vcpu)
+{
+	unsigned long estat, badv;
+	unsigned int exccode, inst;
+
+	/*
+	 *  Fetch the instruction.
+	 */
+	badv = vcpu->arch.badv;
+	estat = vcpu->arch.host_estat;
+	exccode = (estat & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
+	inst = vcpu->arch.badi;
+	kvm_err("Exccode: %d PC=%#lx inst=0x%08x BadVaddr=%#lx estat=%#lx\n",
+			exccode, vcpu->arch.pc, inst, badv, read_gcsr_estat());
+	kvm_arch_vcpu_dump_regs(vcpu);
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+
+	return RESUME_HOST;
+}
+
+static exit_handle_fn _kvm_fault_tables[EXCCODE_INT_START] = {
+	[EXCCODE_TLBL]			= _kvm_handle_read_fault,
+	[EXCCODE_TLBI]			= _kvm_handle_read_fault,
+	[EXCCODE_TLBS]			= _kvm_handle_write_fault,
+	[EXCCODE_TLBM]			= _kvm_handle_write_fault,
+	[EXCCODE_FPDIS]			= _kvm_handle_fpu_disabled,
+	[EXCCODE_GSPR]			= _kvm_handle_gspr,
+};
+
+void _kvm_init_fault(void)
+{
+	int i;
+
+	for (i = 0; i < EXCCODE_INT_START; i++)
+		if (!_kvm_fault_tables[i])
+			_kvm_fault_tables[i] = _kvm_fault_ni;
+}
+
+int _kvm_handle_fault(struct kvm_vcpu *vcpu, int fault)
+{
+	return _kvm_fault_tables[fault](vcpu);
+}
-- 
2.39.1

