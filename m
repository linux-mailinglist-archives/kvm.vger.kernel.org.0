Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7427234F1
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 04:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbjFFCCw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 22:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbjFFCCv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 22:02:51 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E273D114;
        Mon,  5 Jun 2023 19:02:49 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.86])
        by gateway (Coremail) with SMTP id _____8DxG+vIk35k+FQAAA--.259S3;
        Tue, 06 Jun 2023 10:02:48 +0800 (CST)
Received: from [10.20.42.86] (unknown [10.20.42.86])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8BxNeTHk35kXJwBAA--.7117S3;
        Tue, 06 Jun 2023 10:02:48 +0800 (CST)
Subject: Re: [PATCH v12 07/31] LoongArch: KVM: Implement vcpu run interface
To:     "bibo, mao" <maobibo@loongson.cn>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20230530015223.147755-1-zhaotianrui@loongson.cn>
 <20230530015223.147755-8-zhaotianrui@loongson.cn>
 <2ed84603-f046-202e-dc1c-d6fcfc36662d@loongson.cn>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Xi Ruoyao <xry111@xry111.site>
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <41ffdfef-d88f-4c57-8707-a5d041531651@loongson.cn>
Date:   Tue, 6 Jun 2023 10:02:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <2ed84603-f046-202e-dc1c-d6fcfc36662d@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8BxNeTHk35kXJwBAA--.7117S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoWxCw1UWrW3WrW8KrW7Wry7XFc_yoW5uryUpF
        WkCan09w4rJryxG34aqrs0grs0qrZ5Kr12vFyxtFW3Ar1qk34kCr48KrZrCFyxA34fu3WS
        vF1rtry7C3WDtrgCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
        xVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
        AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
        tVWrXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
        8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
        r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67
        AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
        rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14
        v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU4Xo7DU
        UUU
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年06月05日 20:53, bibo, mao 写道:
>
> 在 2023/5/30 09:51, Tianrui Zhao 写道:
>> Implement vcpu run interface, handling mmio, iocsr reading fault
>> and deliver interrupt, lose fpu before vcpu enter guest.
>>
>> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
>> ---
>>   arch/loongarch/kvm/vcpu.c | 86 +++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 86 insertions(+)
>>
>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>> index 24b5b00266a1..eca8b96a3e6e 100644
>> --- a/arch/loongarch/kvm/vcpu.c
>> +++ b/arch/loongarch/kvm/vcpu.c
>> @@ -17,6 +17,44 @@ int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>>   	return 0;
>>   }
>>   
>> +/* Returns 1 if the guest TLB may be clobbered */
>> +static int _kvm_check_requests(struct kvm_vcpu *vcpu, int cpu)
>> +{
>> +	int ret = 0;
>> +
>> +	if (!kvm_request_pending(vcpu))
>> +		return 0;
>> +
>> +	if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu)) {
>> +		/* Drop vpid for this vCPU */
>> +		vcpu->arch.vpid = 0;
>> +		/* This will clobber guest TLB contents too */
>> +		ret = 1;
>> +	}
>> +
>> +	return ret;
>> +}
> can parameter cpu in function _kvm_check_requests be removed since it is not used here?
>
> Regards
> Bibo, Mao
Thanks, I will remove the 'cpu' parameter.

Thanks
Tianrui Zhao
>> +
>> +static void kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
>> +{
>> +	int cpu;
>> +
>> +	/*
>> +	 * handle vcpu timer, interrupts, check requests and
>> +	 * check vmid before vcpu enter guest
>> +	 */
>> +	kvm_acquire_timer(vcpu);
>> +	_kvm_deliver_intr(vcpu);
>> +	/* make sure the vcpu mode has been written */
>> +	smp_store_mb(vcpu->mode, IN_GUEST_MODE);
>> +	cpu = smp_processor_id();
>> +	_kvm_check_requests(vcpu, cpu);
>> +	_kvm_check_vmid(vcpu, cpu);
>> +	vcpu->arch.host_eentry = csr_read64(LOONGARCH_CSR_EENTRY);
>> +	/* clear KVM_LARCH_CSR as csr will change when enter guest */
>> +	vcpu->arch.aux_inuse &= ~KVM_LARCH_CSR;
>> +}
>> +
>>   int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>   {
>>   	unsigned long timer_hz;
>> @@ -86,3 +124,51 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>>   			context->last_vcpu = NULL;
>>   	}
>>   }
>> +
>> +int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>> +{
>> +	int r = -EINTR;
>> +	struct kvm_run *run = vcpu->run;
>> +
>> +	vcpu_load(vcpu);
>> +
>> +	kvm_sigset_activate(vcpu);
>> +
>> +	if (vcpu->mmio_needed) {
>> +		if (!vcpu->mmio_is_write)
>> +			_kvm_complete_mmio_read(vcpu, run);
>> +		vcpu->mmio_needed = 0;
>> +	}
>> +
>> +	if (run->exit_reason == KVM_EXIT_LOONGARCH_IOCSR) {
>> +		if (!run->iocsr_io.is_write)
>> +			_kvm_complete_iocsr_read(vcpu, run);
>> +	}
>> +
>> +	/* clear exit_reason */
>> +	run->exit_reason = KVM_EXIT_UNKNOWN;
>> +	if (run->immediate_exit)
>> +		goto out;
>> +
>> +	lose_fpu(1);
>> +
>> +	local_irq_disable();
>> +	guest_timing_enter_irqoff();
>> +
>> +	kvm_pre_enter_guest(vcpu);
>> +	trace_kvm_enter(vcpu);
>> +
>> +	guest_state_enter_irqoff();
>> +	r = kvm_loongarch_ops->enter_guest(run, vcpu);
>> +
>> +	/* guest_state_exit_irqoff() already done.  */
>> +	trace_kvm_out(vcpu);
>> +	guest_timing_exit_irqoff();
>> +	local_irq_enable();
>> +
>> +out:
>> +	kvm_sigset_deactivate(vcpu);
>> +
>> +	vcpu_put(vcpu);
>> +	return r;
>> +}

