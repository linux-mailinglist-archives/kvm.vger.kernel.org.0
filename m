Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCEB7234A5
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 03:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbjFFBlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 21:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbjFFBlL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 21:41:11 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 564B7E8;
        Mon,  5 Jun 2023 18:41:09 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8BxPOuzjn5kDU0AAA--.208S3;
        Tue, 06 Jun 2023 09:41:07 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxVeSxjn5kAJUBAA--.6908S3;
        Tue, 06 Jun 2023 09:41:05 +0800 (CST)
Message-ID: <350aa194-de59-d128-c998-eef9d7424f4e@loongson.cn>
Date:   Tue, 6 Jun 2023 09:41:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v12 24/31] LoongArch: KVM: Implement handle mmio exception
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Xi Ruoyao <xry111@xry111.site>
References: <20230530015223.147755-1-zhaotianrui@loongson.cn>
 <20230530015223.147755-25-zhaotianrui@loongson.cn>
From:   "bibo, mao" <maobibo@loongson.cn>
In-Reply-To: <20230530015223.147755-25-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxVeSxjn5kAJUBAA--.6908S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3AF1Utw4kKF1xXw1xAFykXrc_yoW3CF43pr
        WDCa429rWrtryavwnrJF40gw1qka1kKr47ZryxXrW7Wr4UtF98Ar4vkr42vFWSkr9Y9F4x
        Z3Z3JF17Cr47A3XCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPmb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
        wI0_Gr1j6F4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
        xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
        Wrv_ZF1lYx0Ex4A2jsIE14v26F4j6r4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64
        vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0E
        wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F4
        0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
        IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW7JVWDJwCI42IY6xIIjxv20xvEc7CjxV
        AFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWx
        JVW8Jr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
        22NJUUUUU==
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: Bibo, Mao <maobibo@loongson.cn>

在 2023/5/30 09:52, Tianrui Zhao 写道:
> Implement handle mmio exception, setting the mmio info into vcpu_run and
> return to user space to handle it.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  arch/loongarch/kvm/exit.c | 308 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 308 insertions(+)
> 
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index 26283a9d3c6d..1237ceb06d0c 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -209,6 +209,265 @@ int _kvm_emu_idle(struct kvm_vcpu *vcpu)
>  	return EMULATE_DONE;
>  }
>  
> +int _kvm_emu_mmio_write(struct kvm_vcpu *vcpu, larch_inst inst)
> +{
> +	struct kvm_run *run = vcpu->run;
> +	unsigned int rd, op8, opcode;
> +	unsigned long rd_val = 0;
> +	void *data = run->mmio.data;
> +	unsigned long curr_pc;
> +	int ret;
> +
> +	/*
> +	 * Update PC and hold onto current PC in case there is
> +	 * an error and we want to rollback the PC
> +	 */
> +	curr_pc = vcpu->arch.pc;
> +	update_pc(&vcpu->arch);
> +
> +	op8 = (inst.word >> 24) & 0xff;
> +	run->mmio.phys_addr = vcpu->arch.badv;
> +	ret = EMULATE_DO_MMIO;
> +	if (op8 < 0x28) {
> +		/* stptrw/d process */
> +		rd = inst.reg2i14_format.rd;
> +		opcode = inst.reg2i14_format.opcode;
> +
> +		switch (opcode) {
> +		case stptrd_op:
> +			run->mmio.len = 8;
> +			*(unsigned long *)data = vcpu->arch.gprs[rd];
> +			break;
> +		case stptrw_op:
> +			run->mmio.len = 4;
> +			*(unsigned int *)data = vcpu->arch.gprs[rd];
> +			break;
> +		default:
> +			ret = EMULATE_FAIL;
> +			break;
> +		}
> +	} else if (op8 < 0x30) {
> +		/* st.b/h/w/d  process */
> +		rd = inst.reg2i12_format.rd;
> +		opcode = inst.reg2i12_format.opcode;
> +		rd_val = vcpu->arch.gprs[rd];
> +
> +		switch (opcode) {
> +		case std_op:
> +			run->mmio.len = 8;
> +			*(unsigned long *)data = rd_val;
> +			break;
> +		case stw_op:
> +			run->mmio.len = 4;
> +			*(unsigned int *)data = rd_val;
> +			break;
> +		case sth_op:
> +			run->mmio.len = 2;
> +			*(unsigned short *)data = rd_val;
> +			break;
> +		case stb_op:
> +			run->mmio.len = 1;
> +			*(unsigned char *)data = rd_val;
> +			break;
> +		default:
> +			ret = EMULATE_FAIL;
> +			break;
> +		}
> +	} else if (op8 == 0x38) {
> +		/* stxb/h/w/d process */
> +		rd = inst.reg3_format.rd;
> +		opcode = inst.reg3_format.opcode;
> +
> +		switch (opcode) {
> +		case stxb_op:
> +			run->mmio.len = 1;
> +			*(unsigned char *)data = vcpu->arch.gprs[rd];
> +			break;
> +		case stxh_op:
> +			run->mmio.len = 2;
> +			*(unsigned short *)data = vcpu->arch.gprs[rd];
> +			break;
> +		case stxw_op:
> +			run->mmio.len = 4;
> +			*(unsigned int *)data = vcpu->arch.gprs[rd];
> +			break;
> +		case stxd_op:
> +			run->mmio.len = 8;
> +			*(unsigned long *)data = vcpu->arch.gprs[rd];
> +			break;
> +		default:
> +			ret = EMULATE_FAIL;
> +			break;
> +		}
> +	} else
> +		ret = EMULATE_FAIL;
> +
> +	if (ret == EMULATE_DO_MMIO) {
> +		run->mmio.is_write = 1;
> +		vcpu->mmio_needed = 1;
> +		vcpu->mmio_is_write = 1;
> +	} else {
> +		vcpu->arch.pc = curr_pc;
> +		kvm_err("Write not supporded inst=0x%08x @%lx BadVaddr:%#lx\n",
> +			inst.word, vcpu->arch.pc, vcpu->arch.badv);
> +		kvm_arch_vcpu_dump_regs(vcpu);
> +		/* Rollback PC if emulation was unsuccessful */
> +	}
> +
> +	return ret;
> +}
> +
> +int _kvm_emu_mmio_read(struct kvm_vcpu *vcpu, larch_inst inst)
> +{
> +	unsigned int op8, opcode, rd;
> +	struct kvm_run *run = vcpu->run;
> +	int ret;
> +
> +	run->mmio.phys_addr = vcpu->arch.badv;
> +	vcpu->mmio_needed = 2;	/* signed */
> +	op8 = (inst.word >> 24) & 0xff;
> +	ret = EMULATE_DO_MMIO;
> +
> +	if (op8 < 0x28) {
> +		/* ldptr.w/d process */
> +		rd = inst.reg2i14_format.rd;
> +		opcode = inst.reg2i14_format.opcode;
> +
> +		switch (opcode) {
> +		case ldptrd_op:
> +			run->mmio.len = 8;
> +			break;
> +		case ldptrw_op:
> +			run->mmio.len = 4;
> +			break;
> +		default:
> +			break;
> +		}
> +	} else if (op8 < 0x2f) {
> +		/* ld.b/h/w/d, ld.bu/hu/wu process */
> +		rd = inst.reg2i12_format.rd;
> +		opcode = inst.reg2i12_format.opcode;
> +
> +		switch (opcode) {
> +		case ldd_op:
> +			run->mmio.len = 8;
> +			break;
> +		case ldwu_op:
> +			vcpu->mmio_needed = 1;	/* unsigned */
> +			run->mmio.len = 4;
> +			break;
> +		case ldw_op:
> +			run->mmio.len = 4;
> +			break;
> +		case ldhu_op:
> +			vcpu->mmio_needed = 1;	/* unsigned */
> +			run->mmio.len = 2;
> +			break;
> +		case ldh_op:
> +			run->mmio.len = 2;
> +			break;
> +		case ldbu_op:
> +			vcpu->mmio_needed = 1;	/* unsigned */
> +			run->mmio.len = 1;
> +			break;
> +		case ldb_op:
> +			run->mmio.len = 1;
> +			break;
> +		default:
> +			ret = EMULATE_FAIL;
> +			break;
> +		}
> +	} else if (op8 == 0x38) {
> +		/* ldxb/h/w/d, ldxb/h/wu, ldgtb/h/w/d, ldleb/h/w/d process */
> +		rd = inst.reg3_format.rd;
> +		opcode = inst.reg3_format.opcode;
> +
> +		switch (opcode) {
> +		case ldxb_op:
> +			run->mmio.len = 1;
> +			break;
> +		case ldxbu_op:
> +			run->mmio.len = 1;
> +			vcpu->mmio_needed = 1;	/* unsigned */
> +			break;
> +		case ldxh_op:
> +			run->mmio.len = 2;
> +			break;
> +		case ldxhu_op:
> +			run->mmio.len = 2;
> +			vcpu->mmio_needed = 1;	/* unsigned */
> +			break;
> +		case ldxw_op:
> +			run->mmio.len = 4;
> +			break;
> +		case ldxwu_op:
> +			run->mmio.len = 4;
> +			vcpu->mmio_needed = 1;	/* unsigned */
> +			break;
> +		case ldxd_op:
> +			run->mmio.len = 8;
> +			break;
> +		default:
> +			ret = EMULATE_FAIL;
> +			break;
> +		}
> +	} else
> +		ret = EMULATE_FAIL;
> +
> +	if (ret == EMULATE_DO_MMIO) {
> +		/* Set for _kvm_complete_mmio_read use */
> +		vcpu->arch.io_gpr = rd;
> +		run->mmio.is_write = 0;
> +		vcpu->mmio_is_write = 0;
> +	} else {
> +		kvm_err("Load not supporded inst=0x%08x @%lx BadVaddr:%#lx\n",
> +			inst.word, vcpu->arch.pc, vcpu->arch.badv);
> +		kvm_arch_vcpu_dump_regs(vcpu);
> +		vcpu->mmio_needed = 0;
> +	}
> +	return ret;
> +}
> +
> +int _kvm_complete_mmio_read(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +	unsigned long *gpr = &vcpu->arch.gprs[vcpu->arch.io_gpr];
> +	enum emulation_result er = EMULATE_DONE;
> +
> +	/* update with new PC */
> +	update_pc(&vcpu->arch);
> +	switch (run->mmio.len) {
> +	case 8:
> +		*gpr = *(s64 *)run->mmio.data;
> +		break;
> +	case 4:
> +		if (vcpu->mmio_needed == 2)
> +			*gpr = *(int *)run->mmio.data;
> +		else
> +			*gpr = *(unsigned int *)run->mmio.data;
> +		break;
> +	case 2:
> +		if (vcpu->mmio_needed == 2)
> +			*gpr = *(short *) run->mmio.data;
> +		else
> +			*gpr = *(unsigned short *)run->mmio.data;
> +
> +		break;
> +	case 1:
> +		if (vcpu->mmio_needed == 2)
> +			*gpr = *(char *) run->mmio.data;
> +		else
> +			*gpr = *(unsigned char *) run->mmio.data;
> +		break;
> +	default:
> +		kvm_err("Bad MMIO length: %d,addr is 0x%lx",
> +				run->mmio.len, vcpu->arch.badv);
> +		er = EMULATE_FAIL;
> +		break;
> +	}
> +
> +	return er;
> +}
> +
>  static int _kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
>  {
>  	enum emulation_result er = EMULATE_DONE;
> @@ -323,3 +582,52 @@ static int _kvm_handle_gspr(struct kvm_vcpu *vcpu)
>  	}
>  	return ret;
>  }
> +
> +static int _kvm_handle_mmu_fault(struct kvm_vcpu *vcpu, bool write)
> +{
> +	struct kvm_run *run = vcpu->run;
> +	unsigned long badv = vcpu->arch.badv;
> +	larch_inst inst;
> +	enum emulation_result er = EMULATE_DONE;
> +	int ret;
> +
> +	ret = kvm_handle_mm_fault(vcpu, badv, write);
> +	if (ret) {
> +		/* Treat as MMIO */
> +		inst.word = vcpu->arch.badi;
> +		if (write) {
> +			er = _kvm_emu_mmio_write(vcpu, inst);
> +		} else {
> +			/* A code fetch fault doesn't count as an MMIO */
> +			if (kvm_is_ifetch_fault(&vcpu->arch)) {
> +				kvm_err("%s ifetch error addr:%lx\n", __func__, badv);
> +				run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +				return RESUME_HOST;
> +			}
> +
> +			er = _kvm_emu_mmio_read(vcpu, inst);
> +		}
> +	}
> +
> +	if (er == EMULATE_DONE) {
> +		ret = RESUME_GUEST;
> +	} else if (er == EMULATE_DO_MMIO) {
> +		run->exit_reason = KVM_EXIT_MMIO;
> +		ret = RESUME_HOST;
> +	} else {
> +		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +		ret = RESUME_HOST;
> +	}
> +
> +	return ret;
> +}
> +
> +static int _kvm_handle_write_fault(struct kvm_vcpu *vcpu)
> +{
> +	return _kvm_handle_mmu_fault(vcpu, true);
> +}
> +
> +static int _kvm_handle_read_fault(struct kvm_vcpu *vcpu)
> +{
> +	return _kvm_handle_mmu_fault(vcpu, false);
> +}

