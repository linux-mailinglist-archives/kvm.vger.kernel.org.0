Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D9B723461
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 03:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbjFFBNW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 21:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjFFBNV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 21:13:21 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 79CF5F3;
        Mon,  5 Jun 2023 18:13:19 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8CxaPEtiH5kKUgAAA--.1166S3;
        Tue, 06 Jun 2023 09:13:17 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Bx+OQsiH5kKYEBAA--.6897S3;
        Tue, 06 Jun 2023 09:13:16 +0800 (CST)
Message-ID: <cf630105-aa83-730e-2cb5-2e33d364a212@loongson.cn>
Date:   Tue, 6 Jun 2023 09:13:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v12 16/31] LoongArch: KVM: Implement update VM id function
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
 <20230530015223.147755-17-zhaotianrui@loongson.cn>
From:   "bibo, mao" <maobibo@loongson.cn>
In-Reply-To: <20230530015223.147755-17-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Bx+OQsiH5kKYEBAA--.6897S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW7tFy3ur18CrW8Gry3Zr1UurX_yoW8KFyUpF
        WxCwn3Gr4fXr17A3sxtw1FqFn093ykKF12qa47J3WFyr17t3s8CrWkKrWDAFyxJr1rJr1I
        qF1YyF4jkr1DA3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUx529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
        Gr0_Gr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
        kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWU
        twAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
        k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l
        4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxV
        WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
        7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
        1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
        42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jeq2NUUUUU=
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
> Implement kvm check vmid and update vmid, the vmid should be checked before
> vcpu enter guest.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  arch/loongarch/kvm/vmid.c | 64 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)
>  create mode 100644 arch/loongarch/kvm/vmid.c
> 
> diff --git a/arch/loongarch/kvm/vmid.c b/arch/loongarch/kvm/vmid.c
> new file mode 100644
> index 000000000000..6fef81b28a48
> --- /dev/null
> +++ b/arch/loongarch/kvm/vmid.c
> @@ -0,0 +1,64 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
> + */
> +
> +#include <linux/kvm_host.h>
> +#include "trace.h"
> +
> +static void _kvm_update_vpid(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	struct kvm_context *context;
> +	unsigned long vpid;
> +
> +	context = per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
> +	vpid = context->vpid_cache + 1;
> +	if (!(vpid & vpid_mask)) {
> +		/* finish round of 64 bit loop */
> +		if (unlikely(!vpid))
> +			vpid = vpid_mask + 1;
> +
> +		/* vpid 0 reserved for root */
> +		++vpid;
> +
> +		/* start new vpid cycle */
> +		kvm_flush_tlb_all();
> +	}
> +
> +	context->vpid_cache = vpid;
> +	vcpu->arch.vpid = vpid;
> +}
> +
> +void _kvm_check_vmid(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	struct kvm_context *context;
> +	bool migrated;
> +	unsigned long ver, old, vpid;
> +
> +	/*
> +	 * Are we entering guest context on a different CPU to last time?
> +	 * If so, the vCPU's guest TLB state on this CPU may be stale.
> +	 */
> +	context = per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
> +	migrated = (vcpu->arch.last_exec_cpu != cpu);
> +	vcpu->arch.last_exec_cpu = cpu;
> +
> +	/*
> +	 * Check if our vpid is of an older version
> +	 *
> +	 * We also discard the stored vpid if we've executed on
> +	 * another CPU, as the guest mappings may have changed without
> +	 * hypervisor knowledge.
> +	 */
> +	ver = vcpu->arch.vpid & ~vpid_mask;
> +	old = context->vpid_cache  & ~vpid_mask;
> +	if (migrated || (ver != old)) {
> +		_kvm_update_vpid(vcpu, cpu);
> +		trace_kvm_vpid_change(vcpu, vcpu->arch.vpid);
> +	}
> +
> +	/* Restore GSTAT(0x50).vpid */
> +	vpid = (vcpu->arch.vpid & vpid_mask)
> +		<< CSR_GSTAT_GID_SHIFT;
> +	change_csr_gstat(vpid_mask << CSR_GSTAT_GID_SHIFT, vpid);
> +}

