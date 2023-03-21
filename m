Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32966C28E7
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 04:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjCUD6r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 23:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjCUD5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 23:57:48 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 863C9392AA;
        Mon, 20 Mar 2023 20:57:10 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Dx_5cUKxlkADcPAA--.22809S3;
        Tue, 21 Mar 2023 11:57:09 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxD78EKxlkQB4IAA--.33942S28;
        Tue, 21 Mar 2023 11:57:07 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn,
        Xi Ruoyao <xry111@xry111.site>
Subject: [PATCH v4 26/29] LoongArch: KVM: Implement kvm exception vector
Date:   Tue, 21 Mar 2023 11:56:48 +0800
Message-Id: <20230321035651.598505-27-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230321035651.598505-1-zhaotianrui@loongson.cn>
References: <20230321035651.598505-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxD78EKxlkQB4IAA--.33942S28
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7Kw15tF1UurWUKF17uF4UJwb_yoW8ZFW8pF
        yfA34Yyr48W342ya4akw1vgF13AayxKr17WrW7G345uw4jqryrtrWkK397JF43KryrZF1x
        JFZ8tFn8uF4UG37anT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bx8Fc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aV
        CY1x0267AKxVWxJr0_GcWln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l
        57IF6xkI12xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaV
        Av8VWrMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWU
        AVWUtwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26rWl4I8I3I0E4IkC6x0Yz7
        v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
        jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
        x0cI8IcVAFwI0_tr0E3s1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF
        04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4UJVWxJr1lIxAIcVC2z280aV
        CY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0zR9iSdUUUUU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement kvm exception vector, using _kvm_fault_tables array to save
the handle function pointer and it is used when vcpu handle exit.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/exit.c | 48 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index fc2152e09..1f95189f6 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -651,3 +651,51 @@ static int _kvm_handle_fpu_disabled(struct kvm_vcpu *vcpu)
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
+	kvm_err("Exccode: %d PC=%#lx inst=0x%08x BadVaddr=%#lx estat=%#llx\n",
+			exccode, vcpu->arch.pc, inst, badv, read_gcsr_estat());
+	kvm_arch_vcpu_dump_regs(vcpu);
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+
+	return RESUME_HOST;
+}
+
+static exit_handle_fn _kvm_fault_tables[EXCCODE_INT_START] = {
+	[EXCCODE_TLBL]		= _kvm_handle_read_fault,
+	[EXCCODE_TLBI]		= _kvm_handle_read_fault,
+	[EXCCODE_TLBNR]		= _kvm_handle_read_fault,
+	[EXCCODE_TLBNX]		= _kvm_handle_read_fault,
+	[EXCCODE_TLBS]		= _kvm_handle_write_fault,
+	[EXCCODE_TLBM]		= _kvm_handle_write_fault,
+	[EXCCODE_FPDIS]		= _kvm_handle_fpu_disabled,
+	[EXCCODE_GSPR]		= _kvm_handle_gspr,
+};
+
+int _kvm_handle_fault(struct kvm_vcpu *vcpu, int fault)
+{
+	return _kvm_fault_tables[fault](vcpu);
+}
+
+void _kvm_init_fault(void)
+{
+	int i;
+
+	for (i = 0; i < EXCCODE_INT_START; i++)
+		if (!_kvm_fault_tables[i])
+			_kvm_fault_tables[i] = _kvm_fault_ni;
+}
-- 
2.31.1

