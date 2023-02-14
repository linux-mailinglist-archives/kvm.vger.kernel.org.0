Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3687F6956E7
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 03:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbjBNC5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 21:57:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbjBNC5A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 21:57:00 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 25FC3199F0;
        Mon, 13 Feb 2023 18:56:57 -0800 (PST)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Ax69l4+OpjrVcAAA--.947S3;
        Tue, 14 Feb 2023 10:56:56 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Axeb1w+OpjmZwyAA--.28802S20;
        Tue, 14 Feb 2023 10:56:56 +0800 (CST)
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH v1 18/24] LoongArch: KVM: Implement handle gspr exception
Date:   Tue, 14 Feb 2023 10:56:42 +0800
Message-Id: <20230214025648.1898508-19-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230214025648.1898508-1-zhaotianrui@loongson.cn>
References: <20230214025648.1898508-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Axeb1w+OpjmZwyAA--.28802S20
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxZrW3CryxKFy3XrWrAF48Crg_yoW5Zr4Upr
        W7Z34Fvr4kJryft3yaqrsYvrn0va18Kry7Xr9xJ343Z3y7tas5Jr40yrZFyF1DGryfZF4x
        Z3W5tF13CF1UAaUanT9S1TB71UUUUjUqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bzAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aV
        CY1x0267AKxVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487
        Mc804VCY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VCjz48v1s
        IEY20_WwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vI
        r41l42xK82IY6x8ErcxFaVAv8VWrMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14
        v26r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
        17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26w1j6s0DMI
        IF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
        CwCI42IY6I8E87Iv67AKxVW8Jr0_Cr1UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJb
        IYCTnIWIevJa73UjIFyTuYvj4RKtC7UUUUU
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement kvm handle gspr exception interface, including emulate the
reading and writing of cpucfg, csr, iocsr resource.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/exit.c | 114 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index a6beb83a0..75c61272b 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -203,3 +203,117 @@ int _kvm_emu_idle(struct kvm_vcpu *vcpu)
 
 	return EMULATE_DONE;
 }
+
+static int _kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
+{
+	enum emulation_result er = EMULATE_DONE;
+	struct kvm_run *run = vcpu->run;
+	larch_inst inst;
+	unsigned long curr_pc;
+	int rd, rj;
+	unsigned int index;
+
+	/*
+	 *  Fetch the instruction.
+	 */
+	inst.word = vcpu->arch.badi;
+	curr_pc = vcpu->arch.pc;
+	update_pc(&vcpu->arch);
+
+	er = EMULATE_FAIL;
+	switch (((inst.word >> 24) & 0xff)) {
+	case 0x0:
+		/* cpucfg GSPR */
+		if (inst.reg2_format.opcode == 0x1B) {
+			rd = inst.reg2_format.rd;
+			rj = inst.reg2_format.rj;
+			++vcpu->stat.cpucfg_exits;
+			index = vcpu->arch.gprs[rj];
+
+			vcpu->arch.gprs[rd] = read_cpucfg(index);
+			/* Nested KVM is not supported */
+			if (index == 2)
+				vcpu->arch.gprs[rd] &= ~CPUCFG2_LVZP;
+			if (index == 6)
+				vcpu->arch.gprs[rd] &= ~CPUCFG6_PMP;
+			er = EMULATE_DONE;
+		}
+		break;
+	case 0x4:
+		/* csr GSPR */
+		er = _kvm_handle_csr(vcpu, inst);
+		break;
+	case 0x6:
+		/* iocsr,cache,idle GSPR */
+		switch (((inst.word >> 22) & 0x3ff)) {
+		case 0x18:
+			/* cache GSPR */
+			er = EMULATE_DONE;
+			trace_kvm_exit(vcpu, KVM_TRACE_EXIT_CACHE);
+			break;
+		case 0x19:
+			/* iocsr/idle GSPR */
+			switch (((inst.word >> 15) & 0x1ffff)) {
+			case 0xc90:
+				/* iocsr GSPR */
+				er = _kvm_emu_iocsr(inst, run, vcpu);
+				break;
+			case 0xc91:
+				/* idle GSPR */
+				er = _kvm_emu_idle(vcpu);
+				break;
+			default:
+				er = EMULATE_FAIL;
+				break;
+			}
+			break;
+		default:
+			er = EMULATE_FAIL;
+			break;
+		}
+		break;
+	default:
+		er = EMULATE_FAIL;
+		break;
+	}
+
+	/* Rollback PC only if emulation was unsuccessful */
+	if (er == EMULATE_FAIL) {
+		kvm_err("[%#lx]%s: unsupported gspr instruction 0x%08x\n",
+			curr_pc, __func__, inst.word);
+
+		kvm_arch_vcpu_dump_regs(vcpu);
+		vcpu->arch.pc = curr_pc;
+	}
+	return er;
+}
+
+/*
+ * Execute cpucfg instruction will tirggerGSPR,
+ * Also the access to unimplemented csrs 0x15
+ * 0x16, 0x50~0x53, 0x80, 0x81, 0x90~0x95, 0x98
+ * 0xc0~0xff, 0x100~0x109, 0x500~0x502,
+ * cache_op, idle_op iocsr ops the same
+ */
+static int _kvm_handle_gspr(struct kvm_vcpu *vcpu)
+{
+	enum emulation_result er = EMULATE_DONE;
+	int ret = RESUME_GUEST;
+
+	er = _kvm_trap_handle_gspr(vcpu);
+
+	if (er == EMULATE_DONE) {
+		ret = RESUME_GUEST;
+	} else if (er == EMULATE_DO_MMIO) {
+		vcpu->run->exit_reason = KVM_EXIT_MMIO;
+		ret = RESUME_HOST;
+	} else if (er == EMULATE_DO_IOCSR) {
+		vcpu->run->exit_reason = KVM_EXIT_LOONGARCH_IOCSR;
+		ret = RESUME_HOST;
+	} else {
+		kvm_err("%s internal error\n", __func__);
+		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		ret = RESUME_HOST;
+	}
+	return ret;
+}
-- 
2.31.1

