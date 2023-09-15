Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7998D7A1344
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 03:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbjIOBvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 21:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbjIOBuv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 21:50:51 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6AB3D35B3;
        Thu, 14 Sep 2023 18:50:15 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8AxDOtMuANlYv8nAA--.6212S3;
        Fri, 15 Sep 2023 09:50:04 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Axndw9uANl+ioGAA--.11927S25;
        Fri, 15 Sep 2023 09:50:02 +0800 (CST)
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
Subject: [PATCH v21 23/29] LoongArch: KVM: Implement handle mmio exception
Date:   Fri, 15 Sep 2023 09:49:43 +0800
Message-Id: <20230915014949.1222777-24-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
References: <20230915014949.1222777-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Axndw9uANl+ioGAA--.11927S25
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement handle mmio exception, setting the mmio info into vcpu_run and
return to user space to handle it.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/exit.c | 307 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 307 insertions(+)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index a86586cdfc..004b91055a 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -220,6 +220,265 @@ int kvm_emu_idle(struct kvm_vcpu *vcpu)
 	return EMULATE_DONE;
 }
 
+int kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst)
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
+int kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst)
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
+		/* Set for kvm_complete_mmio_read use */
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
+int kvm_complete_mmio_read(struct kvm_vcpu *vcpu, struct kvm_run *run)
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
 static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
 {
 	enum emulation_result er = EMULATE_DONE;
@@ -331,3 +590,51 @@ static int kvm_handle_gspr(struct kvm_vcpu *vcpu)
 	}
 	return ret;
 }
+
+static int kvm_handle_mmu_fault(struct kvm_vcpu *vcpu, bool write)
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
+			er = kvm_emu_mmio_write(vcpu, inst);
+		} else {
+			/* A code fetch fault doesn't count as an MMIO */
+			if (kvm_is_ifetch_fault(&vcpu->arch)) {
+				kvm_queue_exception(vcpu, EXCCODE_ADE, EXSUBCODE_ADEF);
+				return RESUME_GUEST;
+			}
+
+			er = kvm_emu_mmio_read(vcpu, inst);
+		}
+	}
+
+	if (er == EMULATE_DONE) {
+		ret = RESUME_GUEST;
+	} else if (er == EMULATE_DO_MMIO) {
+		run->exit_reason = KVM_EXIT_MMIO;
+		ret = RESUME_HOST;
+	} else {
+		kvm_queue_exception(vcpu, EXCCODE_ADE, EXSUBCODE_ADEM);
+		ret = RESUME_GUEST;
+	}
+
+	return ret;
+}
+
+static int kvm_handle_write_fault(struct kvm_vcpu *vcpu)
+{
+	return kvm_handle_mmu_fault(vcpu, true);
+}
+
+static int kvm_handle_read_fault(struct kvm_vcpu *vcpu)
+{
+	return kvm_handle_mmu_fault(vcpu, false);
+}
-- 
2.39.1

