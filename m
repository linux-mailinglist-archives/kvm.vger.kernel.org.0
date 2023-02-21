Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FDF69D937
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 04:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232588AbjBUDRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 22:17:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233428AbjBUDRx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 22:17:53 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1370923138;
        Mon, 20 Feb 2023 19:17:46 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.120])
        by gateway (Coremail) with SMTP id _____8AxJDTYN_RjOwgDAA--.782S3;
        Tue, 21 Feb 2023 11:17:44 +0800 (CST)
Received: from [10.20.42.120] (unknown [10.20.42.120])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxg+XWN_Rj6IE3AA--.2108S3;
        Tue, 21 Feb 2023 11:17:43 +0800 (CST)
Subject: Re: [PATCH v2 08/29] LoongArch: KVM: Implement vcpu handle exit
 interface
To:     Paolo Bonzini <pbonzini@redhat.com>
References: <20230220065735.1282809-1-zhaotianrui@loongson.cn>
 <20230220065735.1282809-9-zhaotianrui@loongson.cn>
 <f6bb5bdd-c058-b76e-d743-f83c99ee45f5@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>, maobibo@loongson.cn
From:   Tianrui Zhao <zhaotianrui@loongson.cn>
Message-ID: <f78ebaeb-38a4-26f9-eb8d-716fc6500643@loongson.cn>
Date:   Tue, 21 Feb 2023 11:17:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux mips64; rv:45.0) Gecko/20100101
 Thunderbird/45.4.0
MIME-Version: 1.0
In-Reply-To: <f6bb5bdd-c058-b76e-d743-f83c99ee45f5@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Cxg+XWN_Rj6IE3AA--.2108S3
X-CM-SenderInfo: p2kd03xldq233l6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxKF47tr1DKFWrGFW5Jry7Wrg_yoWxWr18p3
        yvkr429w4kGryxJw1xZrs0vr4jvrZ5Kry7CFy8Wa4ayrsrAwn5A34kKrZ09Fykur1vv3WS
        vF1UKFn8Cw1qya7anT9S1TB71UUUUjDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bqkYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
        x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4UJVWxJr1l
        n4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6x
        ACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E
        87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0V
        AS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCF
        s4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI
        8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41l
        IxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIx
        AIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2
        jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jFApnUUUUU=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023年02月21日 02:45, Paolo Bonzini 写道:
> On 2/20/23 07:57, Tianrui Zhao wrote:
>> + * Return value is in the form (errcode<<2 | RESUME_FLAG_HOST | 
>> RESUME_FLAG_NV)
>
> As far as I can see, RESUME_FLAG_NV does not exist anymore and this is 
> just copied from arch/mips?
>
> You can keep RESUME_HOST/RESUME_GUEST for the individual functions, 
> but here please make it just "1" for resume guest, and "<= 0" for 
> resume host.  This is easy enough to check from assembly and removes 
> the srai by 2.
>
>> +static int _kvm_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu)
>> +{
>> +    unsigned long exst = vcpu->arch.host_estat;
>> +    u32 intr = exst & 0x1fff; /* ignore NMI */
>> +    u32 exccode = (exst & CSR_ESTAT_EXC) >> CSR_ESTAT_EXC_SHIFT;
>> +    u32 __user *opc = (u32 __user *) vcpu->arch.pc;
>> +    int ret = RESUME_GUEST, cpu;
>> +
>> +    vcpu->mode = OUTSIDE_GUEST_MODE;
>> +
>> +    /* Set a default exit reason */
>> +    run->exit_reason = KVM_EXIT_UNKNOWN;
>> +    run->ready_for_interrupt_injection = 1;
>> +
>> +    /*
>> +     * Set the appropriate status bits based on host CPU features,
>> +     * before we hit the scheduler
>> +     */
>
> Stale comment?

I will remove this comment.

Thanks
Tianrui Zhao

>
>> +    local_irq_enable();
>
> Please add guest_state_exit_irqoff() here.

I will add this function here.

Thanks
Tianrui Zhao

>
>> +    kvm_debug("%s: exst: %lx, PC: %p, kvm_run: %p, kvm_vcpu: %p\n",
>> +            __func__, exst, opc, run, vcpu);
>
> Please add the information to the kvm_exit tracepoint (thus also 
> removing variables such as "exst" or "opc" from this function) instead 
> of calling kvm_debug().

Ok, i will fix the kvm exit tracepoint function.

Thanks
Tianrui Zhao

>
>> +    trace_kvm_exit(vcpu, exccode);
>> +    if (exccode) {
>> +        ret = _kvm_handle_fault(vcpu, exccode);
>> +    } else {
>> +        WARN(!intr, "suspicious vm exiting");
>> +        ++vcpu->stat.int_exits;
>> +
>> +        if (need_resched())
>> +            cond_resched();
>
> This "if" is not necessary because there is already a cond_resched() 
> below.

Thanks, I will remove this cond_resched function.

Thanks
Tianrui Zhao

>
>> +        ret = RESUME_GUEST;
>
> This "ret" is not necessary because "ret" is already initialized to 
> RESUME_GUEST above, you can either remove it or remove the initializer.

Ok, i will remove this "ret" .

Thanks
Tianrui Zhao

>
>> +    }
>> +
>> +    cond_resched();
>> +    local_irq_disable();
>
> At this point, ret is either RESUME_GUEST or RESUME_HOST.  So, the 
> "if"s below are either all taken or all not taken, and most of this code:
>
>     kvm_acquire_timer(vcpu);
>     _kvm_deliver_intr(vcpu);
>
>     if (signal_pending(current)) {
>         run->exit_reason = KVM_EXIT_INTR;
>         ret = (-EINTR << 2) | RESUME_HOST;
>         ++vcpu->stat.signal_exits;
>         // no need for a tracepoint here
>         // trace_kvm_exit(vcpu, KVM_TRACE_EXIT_SIGNAL);
>     }
>
>     trace_kvm_reenter(vcpu);
>
>     /*
>      * Make sure the read of VCPU requests in vcpu_reenter()
>      * callback is not reordered ahead of the write to vcpu->mode,
>      * or we could miss a TLB flush request while the requester sees
>      * the VCPU as outside of guest mode and not needing an IPI.
>      */
>     smp_store_mb(vcpu->mode, IN_GUEST_MODE);
>
>     cpu = smp_processor_id();
>     _kvm_check_requests(vcpu, cpu);
>     _kvm_check_vmid(vcpu, cpu);
>     vcpu->arch.host_eentry = csr_read64(LOONGARCH_CSR_EENTRY);
>
>     /*
>      * If FPU are enabled (i.e. the guest's FPU context
>      * is live), restore FCSR0.
>      */
>     if (_kvm_guest_has_fpu(&vcpu->arch) &&
>         read_csr_euen() & (CSR_EUEN_FPEN)) {
>         kvm_restore_fcsr(&vcpu->arch.fpu);
>     }
>
> (all except for the "if (signal_pending(current))" and the final "if") 
> is pretty much duplicated with kvm_arch_vcpu_ioctl_run(); the 
> remaining code can also be done from kvm_arch_vcpu_ioctl_run(), the 
> cost is small.  Please move it to a separate function, for example:
>
> int kvm_pre_enter_guest(struct kvm_vcpu *vcpu)
> {
>     if (signal_pending(current)) {
>         run->exit_reason = KVM_EXIT_INTR;
>         ++vcpu->stat.signal_exits;
>         return -EINTR;
>     }
>
>     kvm_acquire_timer(vcpu);
>     _kvm_deliver_intr(vcpu);
>
>     ...
>
>     if (_kvm_guest_has_fpu(&vcpu->arch) &&
>         read_csr_euen() & (CSR_EUEN_FPEN)) {
>         kvm_restore_fcsr(&vcpu->arch.fpu);
>     }
>     return 1;
> }
>
> Call it from _kvm_handle_exit():
>
>     if (ret == RESUME_HOST)
>         return 0;
>
>     r = kvm_pre_enter_guest(vcpu);
>     if (r > 0) {
>         trace_kvm_reenter(vcpu);
>         guest_state_enter_irqoff();
>     }
>
>     return r;
>
> and from kvm_arch_vcpu_ioctl_run():
>
>     local_irq_disable();
>     guest_timing_enter_irqoff();
>     r = kvm_pre_enter_guest(vcpu);
>     if (r > 0) {
>         trace_kvm_enter(vcpu);
>         /*
>          * This should actually not be a function pointer, but
>          * just for clarity */
>          */
>         guest_state_enter_irqoff();
>         r = vcpu->arch.vcpu_run(run, vcpu);
>         /* guest_state_exit_irqoff() already done.  */
>         trace_kvm_out(vcpu);
>     }
>     guest_timing_exit_irqoff();
>     local_irq_enable();
>
> out:
>     kvm_sigset_deactivate(vcpu);
>
>     vcpu_put(vcpu);
>     return r;
>
> Paolo

Thanks, I will reorganize this code and add the kvm_pre_enter_guest 
function, and
apply it in the vcpu_handle_exit and vcpu_run.

Thanks
Tianrui Zhao

>
>> +    if (ret == RESUME_GUEST)
>> +        kvm_acquire_timer(vcpu);
>> +
>> +    if (!(ret & RESUME_HOST)) {
>> +        _kvm_deliver_intr(vcpu);
>> +        /* Only check for signals if not already exiting to 
>> userspace */
>> +        if (signal_pending(current)) {
>> +            run->exit_reason = KVM_EXIT_INTR;
>> +            ret = (-EINTR << 2) | RESUME_HOST;
>> +            ++vcpu->stat.signal_exits;
>> +            trace_kvm_exit(vcpu, KVM_TRACE_EXIT_SIGNAL);
>> +        }
>> +    }
>> +
>> +    if (ret == RESUME_GUEST) {
>> +        trace_kvm_reenter(vcpu);
>> +
>> +        /*
>> +         * Make sure the read of VCPU requests in vcpu_reenter()
>> +         * callback is not reordered ahead of the write to vcpu->mode,
>> +         * or we could miss a TLB flush request while the requester 
>> sees
>> +         * the VCPU as outside of guest mode and not needing an IPI.
>> +         */
>> +        smp_store_mb(vcpu->mode, IN_GUEST_MODE);
>> +
>> +        cpu = smp_processor_id();
>> +        _kvm_check_requests(vcpu, cpu);
>> +        _kvm_check_vmid(vcpu, cpu);
>> +        vcpu->arch.host_eentry = csr_read64(LOONGARCH_CSR_EENTRY);
>> +
>> +        /*
>> +         * If FPU are enabled (i.e. the guest's FPU context
>> +         * is live), restore FCSR0.
>> +         */
>> +        if (_kvm_guest_has_fpu(&vcpu->arch) &&
>> +            read_csr_euen() & (CSR_EUEN_FPEN)) {
>> +            kvm_restore_fcsr(&vcpu->arch.fpu);
>> +        }
>> +    }
>> +
>> +    return ret;
>> +}
>> +
>>   int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>   {
>>       int i;

