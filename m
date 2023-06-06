Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAA07234AD
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 03:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233884AbjFFBnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 21:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbjFFBnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 21:43:03 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63DC0E8;
        Mon,  5 Jun 2023 18:43:02 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8AxhfAlj35kF04AAA--.916S3;
        Tue, 06 Jun 2023 09:43:01 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Ax6OQkj35kB5YBAA--.7263S3;
        Tue, 06 Jun 2023 09:43:00 +0800 (CST)
Message-ID: <f143968f-0c37-6cc6-f7ec-eed96be868a3@loongson.cn>
Date:   Tue, 6 Jun 2023 09:43:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v12 26/31] LoongArch: KVM: Implement kvm exception vector
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
 <20230530015223.147755-27-zhaotianrui@loongson.cn>
From:   "bibo, mao" <maobibo@loongson.cn>
In-Reply-To: <20230530015223.147755-27-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Ax6OQkj35kB5YBAA--.7263S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7tFy3AFy8Gw17Zw4kCFW5XFc_yoW8tr4DpF
        yfCwnIkr48W3W2vFyak3WqgrnxCayxKr17urs7G343uw4qqryrt3ykK397tF45KrWkZF1x
        Za4DJr15uF4UG3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPGb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
        wI0_Gr1j6F4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
        xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
        ZF0_GryDMcIj6I8E87Iv67AKxVWxJVW8Jr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcV
        AKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij
        64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4
        xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
        MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Ar0_tr1lIxAIcVC0I7IYx2IY6xkF7I
        0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
        Cr0_Gr1UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvj
        xUxNeODUUUU
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
> Implement kvm exception vector, using _kvm_fault_tables array to save
> the handle function pointer and it is used when vcpu handle exit.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  arch/loongarch/kvm/exit.c | 48 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
> 
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> index 10f9922a7e76..625045fc95c8 100644
> --- a/arch/loongarch/kvm/exit.c
> +++ b/arch/loongarch/kvm/exit.c
> @@ -657,3 +657,51 @@ static int _kvm_handle_fpu_disabled(struct kvm_vcpu *vcpu)
>  	kvm_own_fpu(vcpu);
>  	return RESUME_GUEST;
>  }
> +
> +/*
> + * Loongarch KVM callback handling for not implemented guest exiting
> + */
> +static int _kvm_fault_ni(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long estat, badv;
> +	unsigned int exccode, inst;
> +
> +	/*
> +	 *  Fetch the instruction.
> +	 */
> +	badv = vcpu->arch.badv;
> +	estat = vcpu->arch.host_estat;
> +	exccode = (estat & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
> +	inst = vcpu->arch.badi;
> +	kvm_err("Exccode: %d PC=%#lx inst=0x%08x BadVaddr=%#lx estat=%#lx\n",
> +			exccode, vcpu->arch.pc, inst, badv, read_gcsr_estat());
> +	kvm_arch_vcpu_dump_regs(vcpu);
> +	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +
> +	return RESUME_HOST;
> +}
> +
> +static exit_handle_fn _kvm_fault_tables[EXCCODE_INT_START] = {
> +	[EXCCODE_TLBL]		= _kvm_handle_read_fault,
> +	[EXCCODE_TLBI]		= _kvm_handle_read_fault,
> +	[EXCCODE_TLBNR]		= _kvm_handle_read_fault,
> +	[EXCCODE_TLBNX]		= _kvm_handle_read_fault,
> +	[EXCCODE_TLBS]		= _kvm_handle_write_fault,
> +	[EXCCODE_TLBM]		= _kvm_handle_write_fault,
> +	[EXCCODE_FPDIS]		= _kvm_handle_fpu_disabled,
> +	[EXCCODE_GSPR]		= _kvm_handle_gspr,
> +};
> +
> +int _kvm_handle_fault(struct kvm_vcpu *vcpu, int fault)
> +{
> +	return _kvm_fault_tables[fault](vcpu);
> +}
> +
> +void _kvm_init_fault(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < EXCCODE_INT_START; i++)
> +		if (!_kvm_fault_tables[i])
> +			_kvm_fault_tables[i] = _kvm_fault_ni;
> +}

