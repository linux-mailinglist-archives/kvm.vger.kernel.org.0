Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD657226C3
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 15:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbjFENDR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 09:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjFENDQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 09:03:16 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8338AC7;
        Mon,  5 Jun 2023 06:03:13 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8DxufEQ3X1kmBgAAA--.602S3;
        Mon, 05 Jun 2023 21:03:12 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxhuQP3X1khIAAAA--.2284S3;
        Mon, 05 Jun 2023 21:03:11 +0800 (CST)
Message-ID: <d28f48e3-95d2-111f-e938-348d68402a57@loongson.cn>
Date:   Mon, 5 Jun 2023 21:03:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v12 08/31] LoongArch: KVM: Implement vcpu handle exit
 interface
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
 <20230530015223.147755-9-zhaotianrui@loongson.cn>
From:   "bibo, mao" <maobibo@loongson.cn>
In-Reply-To: <20230530015223.147755-9-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxhuQP3X1khIAAAA--.2284S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7tFy7ZFyDKw1UtFyfKFW8Zrc_yoW8uFyfpr
        WkCrn8urWrGry7Gwnxtw4qqrs0qr97Kw1xur9rX3yxArsFyas5Jr1kKrZIyF45G3sYqF1I
        vF1rGwn09F4qy3XCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPqb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
        AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
        tVWrXwAv7VC2z280aVAFwI0_Cr0_Gr1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwI
        xGrwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAK
        I48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrV
        AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCI
        c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY1x0267
        AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Cr0_
        Gr1UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j19a
        9UUUUU=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/5/30 09:52, Tianrui Zhao 写道:
> Implement vcpu handle exit interface, getting the exit code by ESTAT
> register and using kvm exception vector to handle it.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  arch/loongarch/kvm/vcpu.c | 46 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index eca8b96a3e6e..ddea480fa5b0 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -55,6 +55,52 @@ static void kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
>  	vcpu->arch.aux_inuse &= ~KVM_LARCH_CSR;
>  }
>  
> +/*
> + * Return 1 for resume guest and "<= 0" for resume host.
> + */
> +static int _kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
> +{
> +	unsigned long exst = vcpu->arch.host_estat;
> +	u32 intr = exst & 0x1fff; /* ignore NMI */
> +	u32 exccode = (exst & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
> +	int ret = RESUME_GUEST;
> +
> +	vcpu->mode = OUTSIDE_GUEST_MODE;
> +
> +	/* Set a default exit reason */
> +	run->exit_reason = KVM_EXIT_UNKNOWN;
> +	run->ready_for_interrupt_injection = 1;
Is ready_for_interrupt_injection used in qemu or kvm for LoongArch?

> +
> +	local_irq_enable();
> +	guest_state_exit_irqoff();
> +
> +	trace_kvm_exit(vcpu, exccode);
> +	if (exccode) {
> +		ret = _kvm_handle_fault(vcpu, exccode);
> +	} else {
> +		WARN(!intr, "suspicious vm exiting");
how about comments like this?
  WARN(!intr, "vm exiting with suspicious irq \n") 

Regards
Bibo, Mao
> +		++vcpu->stat.int_exits;
> +	}
> +
> +	cond_resched();
> +	local_irq_disable();
> +
> +	if (ret == RESUME_HOST)
> +		return ret;
> +
> +	/* Only check for signals if not already exiting to userspace */
> +	if (signal_pending(current)) {
> +		vcpu->run->exit_reason = KVM_EXIT_INTR;
> +		++vcpu->stat.signal_exits;
> +		return -EINTR;
> +	}
> +
> +	kvm_pre_enter_guest(vcpu);
> +	trace_kvm_reenter(vcpu);
> +	guest_state_enter_irqoff();
> +	return RESUME_GUEST;
> +}
> +
>  int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  {
>  	unsigned long timer_hz;

