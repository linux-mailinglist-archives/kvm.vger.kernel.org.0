Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A705E6AD459
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 03:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjCGCD5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 21:03:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjCGCDz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 21:03:55 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 56ADF39CD7;
        Mon,  6 Mar 2023 18:03:51 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8AxJEyGmwZkEicJAA--.11657S3;
        Tue, 07 Mar 2023 10:03:50 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Cxnb6EmwZk3mxNAA--.8949S3;
        Tue, 07 Mar 2023 10:03:48 +0800 (CST)
Message-ID: <8c1042bb-6103-a248-2cd5-19c55ec8d83d@loongson.cn>
Date:   Tue, 7 Mar 2023 10:03:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 14/29] LoongArch: KVM: Implement vcpu load and vcpu put
 operations
Content-Language: en-US
To:     Tianrui Zhao <zhaotianrui@loongson.cn>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Huacai Chen <chenhuacai@kernel.org>,
        WANG Xuerui <kernel@xen0n.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Mark Brown <broonie@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Xi Ruoyao <xry111@xry111.site>
References: <20230228070057.3687180-1-zhaotianrui@loongson.cn>
 <20230228070057.3687180-15-zhaotianrui@loongson.cn>
From:   maobibo <maobibo@loongson.cn>
In-Reply-To: <20230228070057.3687180-15-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Cxnb6EmwZk3mxNAA--.8949S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjvJXoWxKF4ftw48Cr4xXry7AFyxKrg_yoWfWry3pr
        1qgayxurWUt3ZrtF15ArsFvr15WF4Sy34rXr17JrW2qrn8Zr95Aa1IyFy7AFyFq3WxXFyI
        ywn8CrZa9r4ktw7anT9S1TB71UUUUjDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bqkYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84
        ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr0_Cr1U
        M2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zV
        CFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2
        z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2
        IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E
        4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGw
        C20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48J
        MIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMI
        IF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E
        87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j5o7tUUUUU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/2/28 15:00, Tianrui Zhao 写道:
> Implement loongarch vcpu load and vcpu put operations, including
> load csr value into hardware and save csr value into vcpu structure.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  arch/loongarch/kvm/vcpu.c | 192 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 192 insertions(+)
> 
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index 615f68d082f8..14c89208936f 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -771,6 +771,198 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +static int _kvm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	struct kvm_context *context;
> +	struct loongarch_csrs *csr = vcpu->arch.csr;
> +	bool migrated, all;
> +
> +	/*
> +	 * Have we migrated to a different CPU?
> +	 * If so, any old guest TLB state may be stale.
> +	 */
> +	migrated = (vcpu->arch.last_sched_cpu != cpu);
> +
> +	/*
> +	 * Was this the last VCPU to run on this CPU?
> +	 * If not, any old guest state from this VCPU will have been clobbered.
> +	 */
> +	context = per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
> +	all = migrated || (context->last_vcpu != vcpu);
> +	context->last_vcpu = vcpu;
> +
> +	/*
> +	 * Restore timer state regardless
> +	 */
> +	kvm_restore_timer(vcpu);
> +
> +	/* Control guest page CCA attribute */
> +	change_csr_gcfg(CSR_GCFG_MATC_MASK, CSR_GCFG_MATC_ROOT);
> +	/* Don't bother restoring registers multiple times unless necessary */
> +	if (!all)
> +		return 0;
> +
> +	write_csr_gcntc((ulong)vcpu->kvm->arch.time_offset);
> +	/*
> +	 * Restore guest CSR registers
> +	 */
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_CRMD);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_PRMD);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_EUEN);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_MISC);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ECFG);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ERA);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_BADV);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_BADI);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_EENTRY);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBIDX);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBEHI);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBELO0);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBELO1);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ASID);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_PGDL);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_PGDH);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_PWCTL0);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_PWCTL1);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_STLBPGSIZE);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_RVACFG);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_CPUID);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_KS0);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_KS1);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_KS2);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_KS3);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_KS4);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_KS5);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_KS6);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_KS7);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TMID);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_CNTC);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBRENTRY);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBRBADV);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBRERA);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBRSAVE);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBRELO0);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBRELO1);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBREHI);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_TLBRPRMD);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_DMWIN0);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_DMWIN1);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_DMWIN2);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_DMWIN3);
> +	kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_LLBCTL);
> +
> +	/* restore Root.Guestexcept from unused Guest guestexcept register */
> +	write_csr_gintc(csr->csrs[LOONGARCH_CSR_GINTC]);
> +
> +	/*
> +	 * We should clear linked load bit to break interrupted atomics. This
> +	 * prevents a SC on the next VCPU from succeeding by matching a LL on
> +	 * the previous VCPU.
> +	 */
> +	if (vcpu->kvm->created_vcpus > 1)
> +		set_gcsr_llbctl(CSR_LLBCTL_WCLLB);
> +
> +	return 0;
> +}
> +
> +void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	vcpu->cpu = cpu;
> +	if (vcpu->arch.last_sched_cpu != cpu) {
> +		kvm_debug("[%d->%d]KVM VCPU[%d] switch\n",
> +				vcpu->arch.last_sched_cpu, cpu, vcpu->vcpu_id);
> +		/*
> +		 * Migrate the timer interrupt to the current CPU so that it
> +		 * always interrupts the guest and synchronously triggers a
> +		 * guest timer interrupt.
> +		 */
> +		kvm_migrate_count(vcpu);
> +	}
> +
> +	/* restore guest state to registers */
> +	_kvm_vcpu_load(vcpu, cpu);
> +	local_irq_restore(flags);
> +}
> +
> +static int _kvm_vcpu_put(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	struct loongarch_csrs *csr = vcpu->arch.csr;
> +
> +	kvm_lose_fpu(vcpu);
Hi Tianrui,

Can we add KVM_LARCH_CSR bit in vcpu->arch.aux_inuse similiar with
KVM_LARCH_FPU? It means that sw csr is consistent with hw csr registers.

And clear this bit when returning to guest, set this bit in this function
_kvm_vcpu_put. If it is true, we need not copy to sw csr from hw, and for
SET_ONE_REG function, both sw/hw csr register will be set.


Regards
Bibo, Mao

> +
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_CRMD);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_PRMD);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_EUEN);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_MISC);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ECFG);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ERA);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_BADV);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_BADI);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_EENTRY);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBIDX);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBEHI);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBELO0);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBELO1);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ASID);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_PGDL);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_PGDH);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_PGD);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_PWCTL0);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_PWCTL1);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_STLBPGSIZE);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_RVACFG);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_CPUID);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_PRCFG1);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_PRCFG2);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_PRCFG3);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_KS0);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_KS1);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_KS2);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_KS3);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_KS4);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_KS5);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_KS6);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_KS7);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TMID);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_CNTC);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_LLBCTL);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBRENTRY);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBRBADV);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBRERA);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBRSAVE);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBRELO0);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBRELO1);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBREHI);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_TLBRPRMD);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN0);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN1);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN2);
> +	kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN3);
> +
> +	/* save Root.Guestexcept in unused Guest guestexcept register */
> +	kvm_save_timer(vcpu);
> +	csr->csrs[LOONGARCH_CSR_GINTC] = read_csr_gintc();
> +	return 0;
> +}
> +
> +void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long flags;
> +	int cpu;
> +
> +	local_irq_save(flags);
> +	cpu = smp_processor_id();
> +	vcpu->arch.last_sched_cpu = cpu;
> +	vcpu->cpu = -1;
> +
> +	/* save guest state in registers */
> +	_kvm_vcpu_put(vcpu, cpu);
> +	local_irq_restore(flags);
> +}
> +
>  int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  {
>  	int r = -EINTR;

