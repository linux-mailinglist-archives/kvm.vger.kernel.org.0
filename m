Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2CB723496
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 03:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbjFFBg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 21:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbjFFBg0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 21:36:26 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A841F123;
        Mon,  5 Jun 2023 18:36:18 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8AxyvGRjX5k5EkAAA--.1199S3;
        Tue, 06 Jun 2023 09:36:17 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxVeSQjX5kVZEBAA--.6848S3;
        Tue, 06 Jun 2023 09:36:16 +0800 (CST)
Message-ID: <4cb50392-59df-cc0f-4356-ad95027dd67b@loongson.cn>
Date:   Tue, 6 Jun 2023 09:36:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v12 21/31] LoongArch: KVM: Implement handle iocsr
 exception
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
 <20230530015223.147755-22-zhaotianrui@loongson.cn>
From:   "bibo, mao" <maobibo@loongson.cn>
In-Reply-To: <20230530015223.147755-22-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxVeSQjX5kVZEBAA--.6848S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxZFW3JrWfJw4rZw1rAw1xXrc_yoWrXFyDpa
        1Durn7KrW8Gw1ftrsxJFs7WrnIva1kGry7ZF9xXw48urWjya4DJr40krnFvFs5K3sxGr4I
        9r1fAryxuF1qyFcCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVW8JVW8Jr1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
        xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q
        6rW5McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
        1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxG
        rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jz5lbUUU
        UU=
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
> Implement kvm handle vcpu iocsr exception, setting the iocsr info into
> vcpu_run and return to user space to handle it.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  arch/loongarch/include/asm/inst.h | 16 ++++++
>  arch/loongarch/kvm/exit.c         | 92 +++++++++++++++++++++++++++++++
>  2 files changed, 108 insertions(+)
> 
> diff --git a/arch/loongarch/include/asm/inst.h b/arch/loongarch/include/asm/inst.h
> index b09887ffcd15..db5857796432 100644
> --- a/arch/loongarch/include/asm/inst.h
> +++ b/arch/loongarch/include/asm/inst.h
> @@ -56,6 +56,14 @@ enum reg2_op {
>  	revbd_op	= 0x0f,
>  	revh2w_op	= 0x10,
>  	revhd_op	= 0x11,
> +	iocsrrdb_op     = 0x19200,
> +	iocsrrdh_op     = 0x19201,
> +	iocsrrdw_op     = 0x19202,
> +	iocsrrdd_op     = 0x19203,
> +	iocsrwrb_op     = 0x19204,
> +	iocsrwrh_op     = 0x19205,
> +	iocsrwrw_op     = 0x19206,
> +	iocsrwrd_op     = 0x19207,
>  };
>  
>  enum reg2i5_op {
> @@ -298,6 +306,13 @@ struct reg3sa2_format {
>  	unsigned int opcode : 15;
>  };
>  
> +struct reg2csr_format {
> +	unsigned int rd : 5;
> +	unsigned int rj : 5;
> +	unsigned int csr : 14;
> +	unsigned int opcode : 8;
> +};
> +
>  union loongarch_instruction {
>  	unsigned int word;
>  	struct reg0i15_format	reg0i15_format;
> @@ -313,6 +328,7 @@ union loongarch_instruction {
>  	struct reg2bstrd_format	reg2bstrd_format;
>  	struct reg3_format	reg3_format;
>  	struct reg3sa2_format	reg3sa2_format;
> +	struct reg2csr_format   reg2csr_format;
>  };
>  
>  #define LOONGARCH_INSN_SIZE	sizeof(union loongarch_instruction)
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index 508cbce31aa5..bd33fe0c6424 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -96,3 +96,95 @@ static int _kvm_handle_csr(struct kvm_vcpu *vcpu, larch_inst inst)
>  
>  	return EMULATE_DONE;
>  }
> +
> +int _kvm_emu_iocsr(larch_inst inst, struct kvm_run *run, struct kvm_vcpu *vcpu)
> +{
> +	u32 rd, rj, opcode;
> +	u32 addr;
> +	unsigned long val;
> +	int ret;
> +
> +	/*
> +	 * Each IOCSR with different opcode
> +	 */
> +	rd = inst.reg2_format.rd;
> +	rj = inst.reg2_format.rj;
> +	opcode = inst.reg2_format.opcode;
> +	addr = vcpu->arch.gprs[rj];
> +	ret = EMULATE_DO_IOCSR;
> +	run->iocsr_io.phys_addr = addr;
> +	run->iocsr_io.is_write = 0;
> +
> +	/* LoongArch is Little endian */
> +	switch (opcode) {
> +	case iocsrrdb_op:
> +		run->iocsr_io.len = 1;
> +		break;
> +	case iocsrrdh_op:
> +		run->iocsr_io.len = 2;
> +		break;
> +	case iocsrrdw_op:
> +		run->iocsr_io.len = 4;
> +		break;
> +	case iocsrrdd_op:
> +		run->iocsr_io.len = 8;
> +		break;
> +	case iocsrwrb_op:
> +		run->iocsr_io.len = 1;
> +		run->iocsr_io.is_write = 1;
> +		break;
> +	case iocsrwrh_op:
> +		run->iocsr_io.len = 2;
> +		run->iocsr_io.is_write = 1;
> +		break;
> +	case iocsrwrw_op:
> +		run->iocsr_io.len = 4;
> +		run->iocsr_io.is_write = 1;
> +		break;
> +	case iocsrwrd_op:
> +		run->iocsr_io.len = 8;
> +		run->iocsr_io.is_write = 1;
> +		break;
> +	default:
> +		ret = EMULATE_FAIL;
> +		break;
> +	}
> +
> +	if (ret == EMULATE_DO_IOCSR) {
> +		if (run->iocsr_io.is_write) {
> +			val = vcpu->arch.gprs[rd];
> +			memcpy(run->iocsr_io.data, &val, run->iocsr_io.len);
> +		}
> +		vcpu->arch.io_gpr = rd;
> +	}
> +
> +	return ret;
> +}
> +
> +int _kvm_complete_iocsr_read(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +{
> +	unsigned long *gpr = &vcpu->arch.gprs[vcpu->arch.io_gpr];
> +	enum emulation_result er = EMULATE_DONE;
> +
> +	switch (run->iocsr_io.len) {
> +	case 8:
> +		*gpr = *(s64 *)run->iocsr_io.data;
> +		break;
> +	case 4:
> +		*gpr = *(int *)run->iocsr_io.data;
> +		break;
> +	case 2:
> +		*gpr = *(short *)run->iocsr_io.data;
> +		break;
> +	case 1:
> +		*gpr = *(char *) run->iocsr_io.data;
> +		break;
> +	default:
> +		kvm_err("Bad IOCSR length: %d,addr is 0x%lx",
> +				run->iocsr_io.len, vcpu->arch.badv);
> +		er = EMULATE_FAIL;
> +		break;
> +	}
> +
> +	return er;
> +}

