Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B45E722718
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 15:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbjFENN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 09:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbjFENNZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 09:13:25 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A5819A1;
        Mon,  5 Jun 2023 06:13:22 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8Bx1vBx331ktBkAAA--.303S3;
        Mon, 05 Jun 2023 21:13:21 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxKeVw331k7YMAAA--.2616S3;
        Mon, 05 Jun 2023 21:13:20 +0800 (CST)
Message-ID: <c09e67e5-b35c-eb31-7606-557e6816721e@loongson.cn>
Date:   Mon, 5 Jun 2023 21:13:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v12 11/31] LoongArch: KVM: Implement fpu related
 operations for vcpu
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
 <20230530015223.147755-12-zhaotianrui@loongson.cn>
From:   "bibo, mao" <maobibo@loongson.cn>
In-Reply-To: <20230530015223.147755-12-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8AxKeVw331k7YMAAA--.2616S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7tFy7Ww48try3Ww4xKrWrXrc_yoW8tFy3pF
        W8Cwn5Z3yrWF1xK34aqr1j9rnIvr4kKr1xXFy7GryfArnFyryYvF4vkrZruFWkJwn5AF92
        gF1fGF4UCa4kA3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUQFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
        wI0_Gr1j6F4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
        xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
        Wrv_ZF1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcV
        AKI48JM4x0Y40E4IxF1VCIxcxG6Fyj6r4UJwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0E
        n4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbc
        kI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_
        JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26F
        1j6w1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG
        6r1j6r1xMIIF0xvEx4A2jsIE14v26r4UJVWxJr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr
        0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07bOSdkUUUUU=
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
> Implement LoongArch fpu related interface for vcpu, such as get fpu, set
> fpu, own fpu and lose fpu, etc.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  arch/loongarch/kvm/vcpu.c | 60 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 60 insertions(+)
> 
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 5a88f815c412..60213f7f7bac 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -244,6 +244,66 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  	return r;
>  }
>  
> +int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
> +{
> +	int i = 0;
> +
> +	/* no need vcpu_load and vcpu_put */
> +	fpu->fcsr = vcpu->arch.fpu.fcsr;
> +	fpu->fcc = vcpu->arch.fpu.fcc;
> +	for (i = 0; i < NUM_FPU_REGS; i++)
> +		memcpy(&fpu->fpr[i], &vcpu->arch.fpu.fpr[i], FPU_REG_WIDTH / 64);
> +
> +	return 0;
> +}
> +
> +int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
> +{
> +	int i = 0;
> +
> +	/* no need vcpu_load and vcpu_put */
> +	vcpu->arch.fpu.fcsr = fpu->fcsr;
> +	vcpu->arch.fpu.fcc = fpu->fcc;
> +	for (i = 0; i < NUM_FPU_REGS; i++)
> +		memcpy(&vcpu->arch.fpu.fpr[i], &fpu->fpr[i], FPU_REG_WIDTH / 64);
> +
> +	return 0;
> +}
> +
> +/* Enable FPU for guest and restore context */
> +void kvm_own_fpu(struct kvm_vcpu *vcpu)
> +{
> +	preempt_disable();
> +
> +	/*
> +	 * Enable FPU for guest
> +	 */
> +	set_csr_euen(CSR_EUEN_FPEN);
> +
> +	kvm_restore_fpu(&vcpu->arch.fpu);
> +	vcpu->arch.aux_inuse |= KVM_LARCH_FPU;
> +	trace_kvm_aux(vcpu, KVM_TRACE_AUX_RESTORE, KVM_TRACE_AUX_FPU);
> +
> +	preempt_enable();
> +}
> +
> +/* Save and disable FPU */
> +void kvm_lose_fpu(struct kvm_vcpu *vcpu)
> +{
> +	preempt_disable();
> +
> +	if (vcpu->arch.aux_inuse & KVM_LARCH_FPU) {
> +		kvm_save_fpu(&vcpu->arch.fpu);
> +		vcpu->arch.aux_inuse &= ~KVM_LARCH_FPU;
> +		trace_kvm_aux(vcpu, KVM_TRACE_AUX_SAVE, KVM_TRACE_AUX_FPU);
> +
> +		/* Disable FPU */
> +		clear_csr_euen(CSR_EUEN_FPEN);
> +	}
> +
> +	preempt_enable();
> +}
> +
>  int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>  {
>  	return 0;

