Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC5B722666
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 14:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbjFEMxh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 08:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbjFEMxf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 08:53:35 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6C0ACCD;
        Mon,  5 Jun 2023 05:53:33 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8DxtfDM2n1kqxcAAA--.240S3;
        Mon, 05 Jun 2023 20:53:32 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxKeXL2n1kmX0AAA--.2481S3;
        Mon, 05 Jun 2023 20:53:31 +0800 (CST)
Message-ID: <2ed84603-f046-202e-dc1c-d6fcfc36662d@loongson.cn>
Date:   Mon, 5 Jun 2023 20:53:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v12 07/31] LoongArch: KVM: Implement vcpu run interface
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
 <20230530015223.147755-8-zhaotianrui@loongson.cn>
From:   "bibo, mao" <maobibo@loongson.cn>
In-Reply-To: <20230530015223.147755-8-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8AxKeXL2n1kmX0AAA--.2481S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxCw15GrWDAF4fXw15Kr47WrX_yoW5Cr48pa
        y8CwnI9rWrJ34xG34fJrs09rs0qrWkKr17Za4xtFW3Jr4qy34Dur48KrWDAFWfA3s5X3WS
        vF1rKF47CFyDt3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPqb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
        AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
        tVWrXwAv7VC2z280aVAFwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwI
        xGrwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
        I48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrV
        AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCI
        c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26ryj6F1UMIIF0xvE2Ix0cI8IcVCY1x0267
        AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Cr0_
        Gr1UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j873
        kUUUUU=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/5/30 09:51, Tianrui Zhao 写道:
> Implement vcpu run interface, handling mmio, iocsr reading fault
> and deliver interrupt, lose fpu before vcpu enter guest.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  arch/loongarch/kvm/vcpu.c | 86 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 86 insertions(+)
> 
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 24b5b00266a1..eca8b96a3e6e 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -17,6 +17,44 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>  	return 0;
>  }
>  
> +/* Returns 1 if the guest TLB may be clobbered */
> +static int _kvm_check_requests(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	int ret = 0;
> +
> +	if (!kvm_request_pending(vcpu))
> +		return 0;
> +
> +	if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu)) {
> +		/* Drop vpid for this vCPU */
> +		vcpu->arch.vpid = 0;
> +		/* This will clobber guest TLB contents too */
> +		ret = 1;
> +	}
> +
> +	return ret;
> +}
can parameter cpu in function _kvm_check_requests be removed since it is not used here?

Regards
Bibo, Mao
> +
> +static void kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
> +{
> +	int cpu;
> +
> +	/*
> +	 * handle vcpu timer, interrupts, check requests and
> +	 * check vmid before vcpu enter guest
> +	 */
> +	kvm_acquire_timer(vcpu);
> +	_kvm_deliver_intr(vcpu);
> +	/* make sure the vcpu mode has been written */
> +	smp_store_mb(vcpu->mode, IN_GUEST_MODE);
> +	cpu = smp_processor_id();
> +	_kvm_check_requests(vcpu, cpu);
> +	_kvm_check_vmid(vcpu, cpu);
> +	vcpu->arch.host_eentry = csr_read64(LOONGARCH_CSR_EENTRY);
> +	/* clear KVM_LARCH_CSR as csr will change when enter guest */
> +	vcpu->arch.aux_inuse &= ~KVM_LARCH_CSR;
> +}
> +
>  int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  {
>  	unsigned long timer_hz;
> @@ -86,3 +124,51 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  			context->last_vcpu = NULL;
>  	}
>  }
> +
> +int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> +{
> +	int r = -EINTR;
> +	struct kvm_run *run = vcpu->run;
> +
> +	vcpu_load(vcpu);
> +
> +	kvm_sigset_activate(vcpu);
> +
> +	if (vcpu->mmio_needed) {
> +		if (!vcpu->mmio_is_write)
> +			_kvm_complete_mmio_read(vcpu, run);
> +		vcpu->mmio_needed = 0;
> +	}
> +
> +	if (run->exit_reason == KVM_EXIT_LOONGARCH_IOCSR) {
> +		if (!run->iocsr_io.is_write)
> +			_kvm_complete_iocsr_read(vcpu, run);
> +	}
> +
> +	/* clear exit_reason */
> +	run->exit_reason = KVM_EXIT_UNKNOWN;
> +	if (run->immediate_exit)
> +		goto out;
> +
> +	lose_fpu(1);
> +
> +	local_irq_disable();
> +	guest_timing_enter_irqoff();
> +
> +	kvm_pre_enter_guest(vcpu);
> +	trace_kvm_enter(vcpu);
> +
> +	guest_state_enter_irqoff();
> +	r = kvm_loongarch_ops->enter_guest(run, vcpu);
> +
> +	/* guest_state_exit_irqoff() already done.  */
> +	trace_kvm_out(vcpu);
> +	guest_timing_exit_irqoff();
> +	local_irq_enable();
> +
> +out:
> +	kvm_sigset_deactivate(vcpu);
> +
> +	vcpu_put(vcpu);
> +	return r;
> +}

