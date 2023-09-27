Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCBC7AF910
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 06:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjI0ENR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 00:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjI0EMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 00:12:14 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50109CD2;
        Tue, 26 Sep 2023 20:10:14 -0700 (PDT)
Received: from loongson.cn (unknown [10.2.5.185])
        by gateway (Coremail) with SMTP id _____8BxIvAPnRNlcRctAA--.20170S3;
        Wed, 27 Sep 2023 11:10:07 +0800 (CST)
Received: from localhost.localdomain (unknown [10.2.5.185])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxjd4InRNlhZETAA--.42466S20;
        Wed, 27 Sep 2023 11:10:07 +0800 (CST)
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
        Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH v22 18/25] LoongArch: KVM: Implement handle gspr exception
Date:   Wed, 27 Sep 2023 11:09:52 +0800
Message-Id: <20230927030959.3629941-19-zhaotianrui@loongson.cn>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
References: <20230927030959.3629941-1-zhaotianrui@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Cxjd4InRNlhZETAA--.42466S20
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
        ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
        nUUI43ZEXa7xR_UUUUUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement kvm handle gspr exception interface, including emulate the
reading and writing of cpucfg, csr, iocsr resource.

Reviewed-by: Bibo Mao <maobibo@loongson.cn>
Tested-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
---
 arch/loongarch/kvm/exit.c | 107 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
index d4d7e74f72..33d1b4190a 100644
--- a/arch/loongarch/kvm/exit.c
+++ b/arch/loongarch/kvm/exit.c
@@ -214,3 +214,110 @@ int kvm_emu_idle(struct kvm_vcpu *vcpu)
 
 	return EMULATE_DONE;
 }
+
+static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
+{
+	int rd, rj;
+	unsigned int index;
+	unsigned long curr_pc;
+	larch_inst inst;
+	enum emulation_result er = EMULATE_DONE;
+	struct kvm_run *run = vcpu->run;
+
+	/* Fetch the instruction */
+	inst.word = vcpu->arch.badi;
+	curr_pc = vcpu->arch.pc;
+	update_pc(&vcpu->arch);
+
+	trace_kvm_exit_gspr(vcpu, inst.word);
+	er = EMULATE_FAIL;
+	switch (((inst.word >> 24) & 0xff)) {
+	case 0x0: /* CPUCFG GSPR */
+		if (inst.reg2_format.opcode == 0x1B) {
+			rd = inst.reg2_format.rd;
+			rj = inst.reg2_format.rj;
+			++vcpu->stat.cpucfg_exits;
+			index = vcpu->arch.gprs[rj];
+			er = EMULATE_DONE;
+			/*
+			 * By LoongArch Reference Manual 2.2.10.5
+			 * return value is 0 for undefined cpucfg index
+			 */
+			if (index < KVM_MAX_CPUCFG_REGS)
+				vcpu->arch.gprs[rd] = vcpu->arch.cpucfg[index];
+			else
+				vcpu->arch.gprs[rd] = 0;
+		}
+		break;
+	case 0x4: /* CSR{RD,WR,XCHG} GSPR */
+		er = kvm_handle_csr(vcpu, inst);
+		break;
+	case 0x6: /* Cache, Idle and IOCSR GSPR */
+		switch (((inst.word >> 22) & 0x3ff)) {
+		case 0x18: /* Cache GSPR */
+			er = EMULATE_DONE;
+			trace_kvm_exit_cache(vcpu, KVM_TRACE_EXIT_CACHE);
+			break;
+		case 0x19: /* Idle/IOCSR GSPR */
+			switch (((inst.word >> 15) & 0x1ffff)) {
+			case 0xc90: /* IOCSR GSPR */
+				er = kvm_emu_iocsr(inst, run, vcpu);
+				break;
+			case 0xc91: /* Idle GSPR */
+				er = kvm_emu_idle(vcpu);
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
+
+	return er;
+}
+
+/*
+ * Trigger GSPR:
+ * 1) Execute CPUCFG instruction;
+ * 2) Execute CACOP/IDLE instructions;
+ * 3) Access to unimplemented CSRs/IOCSRs.
+ */
+static int kvm_handle_gspr(struct kvm_vcpu *vcpu)
+{
+	int ret = RESUME_GUEST;
+	enum emulation_result er = EMULATE_DONE;
+
+	er = kvm_trap_handle_gspr(vcpu);
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
+		kvm_queue_exception(vcpu, EXCCODE_INE, 0);
+		ret = RESUME_GUEST;
+	}
+
+	return ret;
+}
-- 
2.39.3

