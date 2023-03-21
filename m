Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B46E6C28E5
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 04:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjCUD6o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 23:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjCUD5s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 23:57:48 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F51539291;
        Mon, 20 Mar 2023 20:57:09 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8Axz_8TKxlk7DYPAA--.22761S3;
        Tue, 21 Mar 2023 11:57:07 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxD78EKxlkQB4IAA--.33942S26;
        Tue, 21 Mar 2023 11:57:06 +0800 (CST)
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
Subject: [PATCH v4 24/29] LoongArch: KVM: Implement handle mmio exception
Date:   Tue, 21 Mar 2023 11:56:46 +0800
Message-Id: <20230321035651.598505-25-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230321035651.598505-1-zhaotianrui@loongson.cn>
References: <20230321035651.598505-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxD78EKxlkQB4IAA--.33942S26
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoW3JFWfZF48Cr4Utry5Kr1kAFb_yoW3GF18pr
        WUC34jvrsaqryYy3srKrs5Xr1a9F48GrsrJrZ7t39Fgr17tFy5Ar4v9rW2vFW3CrWF9a1x
        Z3Z3JF47uF1UAa7anT9S1TB71UUUUjJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
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

Implement handle mmio exception, setting the mmio info into vcpu_run and
return to user space to handle it.

Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/exit.c | 308 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 308 insertions(+)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index 1e24a1867..8a5d39285 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -203,6 +203,265 @@ int _kvm_emu_idle(struct kvm_vcpu *vcpu)
 	return EMULATE_DONE;
 }
 
+int _kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst)
+{
+	struct kvm_run *run = vcpu->run;
+	unsigned int rd, op8, opcode;
+	unsigned long rd_val = 0;
+	void *data = run->mmio.data;
+	unsigned long curr_pc;
+	int ret;
+
+	/*
+	 * Update PC and hold onto current PC in case there is
+	 * an error and we want to rollback the PC
+	 */
+	curr_pc = vcpu->arch.pc;
+	update_pc(&vcpu->arch);
+
+	op8 = (inst.word >> 24) & 0xff;
+	run->mmio.phys_addr = vcpu->arch.badv;
+	ret = EMULATE_DO_MMIO;
+	if (op8 < 0x28) {
+		/* stptrw/d process */
+		rd = inst.reg2i14_format.rd;
+		opcode = inst.reg2i14_format.opcode;
+
+		switch (opcode) {
+		case stptrd_op:
+			run->mmio.len = 8;
+			*(unsigned long *)data = vcpu->arch.gprs[rd];
+			break;
+		case stptrw_op:
+			run->mmio.len = 4;
+			*(unsigned int *)data = vcpu->arch.gprs[rd];
+			break;
+		default:
+			ret = EMULATE_FAIL;
+			break;
+		}
+	} else if (op8 < 0x30) {
+		/* st.b/h/w/d  process */
+		rd = inst.reg2i12_format.rd;
+		opcode = inst.reg2i12_format.opcode;
+		rd_val = vcpu->arch.gprs[rd];
+
+		switch (opcode) {
+		case std_op:
+			run->mmio.len = 8;
+			*(unsigned long *)data = rd_val;
+			break;
+		case stw_op:
+			run->mmio.len = 4;
+			*(unsigned int *)data = rd_val;
+			break;
+		case sth_op:
+			run->mmio.len = 2;
+			*(unsigned short *)data = rd_val;
+			break;
+		case stb_op:
+			run->mmio.len = 1;
+			*(unsigned char *)data = rd_val;
+			break;
+		default:
+			ret = EMULATE_FAIL;
+			break;
+		}
+	} else if (op8 == 0x38) {
+		/* stxb/h/w/d process */
+		rd = inst.reg3_format.rd;
+		opcode = inst.reg3_format.opcode;
+
+		switch (opcode) {
+		case stxb_op:
+			run->mmio.len = 1;
+			*(unsigned char *)data = vcpu->arch.gprs[rd];
+			break;
+		case stxh_op:
+			run->mmio.len = 2;
+			*(unsigned short *)data = vcpu->arch.gprs[rd];
+			break;
+		case stxw_op:
+			run->mmio.len = 4;
+			*(unsigned int *)data = vcpu->arch.gprs[rd];
+			break;
+		case stxd_op:
+			run->mmio.len = 8;
+			*(unsigned long *)data = vcpu->arch.gprs[rd];
+			break;
+		default:
+			ret = EMULATE_FAIL;
+			break;
+		}
+	} else
+		ret = EMULATE_FAIL;
+
+	if (ret == EMULATE_DO_MMIO) {
+		run->mmio.is_write = 1;
+		vcpu->mmio_needed = 1;
+		vcpu->mmio_is_write = 1;
+	} else {
+		vcpu->arch.pc = curr_pc;
+		kvm_err("Write not supporded inst=0x%08x @%lx BadVaddr:%#lx\n",
+			inst.word, vcpu->arch.pc, vcpu->arch.badv);
+		kvm_arch_vcpu_dump_regs(vcpu);
+		/* Rollback PC if emulation was unsuccessful */
+	}
+
+	return ret;
+}
+
+int _kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst)
+{
+	unsigned int op8, opcode, rd;
+	struct kvm_run *run = vcpu->run;
+	int ret;
+
+	run->mmio.phys_addr = vcpu->arch.badv;
+	vcpu->mmio_needed = 2;	/* signed */
+	op8 = (inst.word >> 24) & 0xff;
+	ret = EMULATE_DO_MMIO;
+
+	if (op8 < 0x28) {
+		/* ldptr.w/d process */
+		rd = inst.reg2i14_format.rd;
+		opcode = inst.reg2i14_format.opcode;
+
+		switch (opcode) {
+		case ldptrd_op:
+			run->mmio.len = 8;
+			break;
+		case ldptrw_op:
+			run->mmio.len = 4;
+			break;
+		default:
+			break;
+		}
+	} else if (op8 < 0x2f) {
+		/* ld.b/h/w/d, ld.bu/hu/wu process */
+		rd = inst.reg2i12_format.rd;
+		opcode = inst.reg2i12_format.opcode;
+
+		switch (opcode) {
+		case ldd_op:
+			run->mmio.len = 8;
+			break;
+		case ldwu_op:
+			vcpu->mmio_needed = 1;	/* unsigned */
+			run->mmio.len = 4;
+			break;
+		case ldw_op:
+			run->mmio.len = 4;
+			break;
+		case ldhu_op:
+			vcpu->mmio_needed = 1;	/* unsigned */
+			run->mmio.len = 2;
+			break;
+		case ldh_op:
+			run->mmio.len = 2;
+			break;
+		case ldbu_op:
+			vcpu->mmio_needed = 1;	/* unsigned */
+			run->mmio.len = 1;
+			break;
+		case ldb_op:
+			run->mmio.len = 1;
+			break;
+		default:
+			ret = EMULATE_FAIL;
+			break;
+		}
+	} else if (op8 == 0x38) {
+		/* ldxb/h/w/d, ldxb/h/wu, ldgtb/h/w/d, ldleb/h/w/d process */
+		rd = inst.reg3_format.rd;
+		opcode = inst.reg3_format.opcode;
+
+		switch (opcode) {
+		case ldxb_op:
+			run->mmio.len = 1;
+			break;
+		case ldxbu_op:
+			run->mmio.len = 1;
+			vcpu->mmio_needed = 1;	/* unsigned */
+			break;
+		case ldxh_op:
+			run->mmio.len = 2;
+			break;
+		case ldxhu_op:
+			run->mmio.len = 2;
+			vcpu->mmio_needed = 1;	/* unsigned */
+			break;
+		case ldxw_op:
+			run->mmio.len = 4;
+			break;
+		case ldxwu_op:
+			run->mmio.len = 4;
+			vcpu->mmio_needed = 1;	/* unsigned */
+			break;
+		case ldxd_op:
+			run->mmio.len = 8;
+			break;
+		default:
+			ret = EMULATE_FAIL;
+			break;
+		}
+	} else
+		ret = EMULATE_FAIL;
+
+	if (ret == EMULATE_DO_MMIO) {
+		/* Set for _kvm_complete_mmio_read use */
+		vcpu->arch.io_gpr = rd;
+		run->mmio.is_write = 0;
+		vcpu->mmio_is_write = 0;
+	} else {
+		kvm_err("Load not supporded inst=0x%08x @%lx BadVaddr:%#lx\n",
+			inst.word, vcpu->arch.pc, vcpu->arch.badv);
+		kvm_arch_vcpu_dump_regs(vcpu);
+		vcpu->mmio_needed = 0;
+	}
+	return ret;
+}
+
+int _kvm_complete_mmio_read(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	unsigned long *gpr = &vcpu->arch.gprs[vcpu->arch.io_gpr];
+	enum emulation_result er = EMULATE_DONE;
+
+	/* update with new PC */
+	update_pc(&vcpu->arch);
+	switch (run->mmio.len) {
+	case 8:
+		*gpr = *(s64 *)run->mmio.data;
+		break;
+	case 4:
+		if (vcpu->mmio_needed == 2)
+			*gpr = *(int *)run->mmio.data;
+		else
+			*gpr = *(unsigned int *)run->mmio.data;
+		break;
+	case 2:
+		if (vcpu->mmio_needed == 2)
+			*gpr = *(short *) run->mmio.data;
+		else
+			*gpr = *(unsigned short *)run->mmio.data;
+
+		break;
+	case 1:
+		if (vcpu->mmio_needed == 2)
+			*gpr = *(char *) run->mmio.data;
+		else
+			*gpr = *(unsigned char *) run->mmio.data;
+		break;
+	default:
+		kvm_err("Bad MMIO length: %d,addr is 0x%lx",
+				run->mmio.len, vcpu->arch.badv);
+		er = EMULATE_FAIL;
+		break;
+	}
+
+	return er;
+}
+
 static int _kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
 {
 	enum emulation_result er = EMULATE_DONE;
@@ -317,3 +576,52 @@ static int _kvm_handle_gspr(struct kvm_vcpu *vcpu)
 	}
 	return ret;
 }
+
+static int _kvm_handle_mmu_fault(struct kvm_vcpu *vcpu, bool write)
+{
+	struct kvm_run *run = vcpu->run;
+	unsigned long badv = vcpu->arch.badv;
+	larch_inst inst;
+	enum emulation_result er = EMULATE_DONE;
+	int ret;
+
+	ret = kvm_handle_mm_fault(vcpu, badv, write);
+	if (ret) {
+		/* Treat as MMIO */
+		inst.word = vcpu->arch.badi;
+		if (write) {
+			er = _kvm_emu_mmio_write(vcpu, inst);
+		} else {
+			/* A code fetch fault doesn't count as an MMIO */
+			if (kvm_is_ifetch_fault(&vcpu->arch)) {
+				kvm_err("%s ifetch error addr:%lx\n", __func__, badv);
+				run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+				return RESUME_HOST;
+			}
+
+			er = _kvm_emu_mmio_read(vcpu, inst);
+		}
+	}
+
+	if (er == EMULATE_DONE) {
+		ret = RESUME_GUEST;
+	} else if (er == EMULATE_DO_MMIO) {
+		run->exit_reason = KVM_EXIT_MMIO;
+		ret = RESUME_HOST;
+	} else {
+		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+		ret = RESUME_HOST;
+	}
+
+	return ret;
+}
+
+static int _kvm_handle_write_fault(struct kvm_vcpu *vcpu)
+{
+	return _kvm_handle_mmu_fault(vcpu, true);
+}
+
+static int _kvm_handle_read_fault(struct kvm_vcpu *vcpu)
+{
+	return _kvm_handle_mmu_fault(vcpu, false);
+}
-- 
2.31.1

