Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52577225EE
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 14:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbjFEMdp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 08:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbjFEMda (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 08:33:30 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F53610C6;
        Mon,  5 Jun 2023 05:32:45 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8DxavKz1X1kkRUAAA--.461S3;
        Mon, 05 Jun 2023 20:31:47 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Bx+OSz1X1kSncAAA--.2249S3;
        Mon, 05 Jun 2023 20:31:47 +0800 (CST)
Message-ID: <1bf2bf7f-bc52-4971-3dd3-06bfa85f9275@loongson.cn>
Date:   Mon, 5 Jun 2023 20:31:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v12 04/31] LoongArch: KVM: Implement VM related functions
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
 <20230530015223.147755-5-zhaotianrui@loongson.cn>
From:   "bibo, mao" <maobibo@loongson.cn>
In-Reply-To: <20230530015223.147755-5-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Bx+OSz1X1kSncAAA--.2249S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxXFyfKr1UKr48urWUur1kCrX_yoW5Xry5pF
        4UAan5Kr4rJwn7tr1fJ34q9w1ak393Wr18u342vry5GFs8trn5GFWFyrW5AFZ5J34ruFyx
        X3WavwnI9ayrt3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
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
        rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Xr0_Ar1lIxAIcVC0I7IYx2IY6xkF7I0E14
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

Reviewed-by: Bibo, Mao <maobibo@loongson.cn>

在 2023/5/30 09:51, Tianrui Zhao 写道:
> Implement LoongArch VM operations: Init and destroy vm interface,
> allocating memory page to save the vm pgd when init vm. Implement
> vm check extension, such as getting vcpu number info, memory slots
> info, and fpu info. And implement vm status description.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  arch/loongarch/kvm/vm.c | 78 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 78 insertions(+)
>  create mode 100644 arch/loongarch/kvm/vm.c
> 
> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
> new file mode 100644
> index 000000000000..43688a04ab78
> --- /dev/null
> +++ b/arch/loongarch/kvm/vm.c
> @@ -0,0 +1,78 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
> + */
> +
> +#include <linux/kvm_host.h>
> +
> +#define KVM_LOONGARCH_VERSION 1
> +
> +const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
> +	KVM_GENERIC_VM_STATS(),
> +};
> +
> +const struct kvm_stats_header kvm_vm_stats_header = {
> +	.name_size = KVM_STATS_NAME_SIZE,
> +	.num_desc = ARRAY_SIZE(kvm_vm_stats_desc),
> +	.id_offset =  sizeof(struct kvm_stats_header),
> +	.desc_offset = sizeof(struct kvm_stats_header) + KVM_STATS_NAME_SIZE,
> +	.data_offset = sizeof(struct kvm_stats_header) + KVM_STATS_NAME_SIZE +
> +					sizeof(kvm_vm_stats_desc),
> +};
> +
> +int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> +{
> +	/* Allocate page table to map GPA -> RPA */
> +	kvm->arch.gpa_mm.pgd = kvm_pgd_alloc();
> +	if (!kvm->arch.gpa_mm.pgd)
> +		return -ENOMEM;
> +
> +	kvm_init_vmcs(kvm);
> +	kvm->arch.gpa_size = BIT(cpu_vabits - 1);
> +	return 0;
> +}
> +
> +void kvm_arch_destroy_vm(struct kvm *kvm)
> +{
> +	kvm_destroy_vcpus(kvm);
> +	_kvm_destroy_mm(kvm);
> +}
> +
> +int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> +{
> +	int r;
> +
> +	switch (ext) {
> +	case KVM_CAP_ONE_REG:
> +	case KVM_CAP_ENABLE_CAP:
> +	case KVM_CAP_READONLY_MEM:
> +	case KVM_CAP_SYNC_MMU:
> +	case KVM_CAP_IMMEDIATE_EXIT:
> +	case KVM_CAP_IOEVENTFD:
> +	case KVM_CAP_MP_STATE:
> +		r = 1;
> +		break;
> +	case KVM_CAP_NR_VCPUS:
> +		r = num_online_cpus();
> +		break;
> +	case KVM_CAP_MAX_VCPUS:
> +		r = KVM_MAX_VCPUS;
> +		break;
> +	case KVM_CAP_MAX_VCPU_ID:
> +		r = KVM_MAX_VCPU_IDS;
> +		break;
> +	case KVM_CAP_NR_MEMSLOTS:
> +		r = KVM_USER_MEM_SLOTS;
> +		break;
> +	default:
> +		r = 0;
> +		break;
> +	}
> +
> +	return r;
> +}
> +
> +int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
> +{
> +	return -ENOIOCTLCMD;
> +}

