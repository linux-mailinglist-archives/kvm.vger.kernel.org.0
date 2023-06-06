Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8490723492
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 03:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233706AbjFFBf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 21:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjFFBf0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 21:35:26 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C9048F;
        Mon,  5 Jun 2023 18:35:23 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8AxSPFajX5kv0kAAA--.1158S3;
        Tue, 06 Jun 2023 09:35:22 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8BxNeRZjX5kYo8BAA--.6894S3;
        Tue, 06 Jun 2023 09:35:21 +0800 (CST)
Message-ID: <4831764b-c53a-188f-cdd2-6764c76fc627@loongson.cn>
Date:   Tue, 6 Jun 2023 09:35:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v12 20/31] LoongArch: KVM: Implement handle csr excption
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
 <20230530015223.147755-21-zhaotianrui@loongson.cn>
From:   "bibo, mao" <maobibo@loongson.cn>
In-Reply-To: <20230530015223.147755-21-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8BxNeRZjX5kYo8BAA--.6894S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxZFW3JrW8Zw15Wry5Xw1fGrX_yoW5tr1rpa
        4kA3WrCrW0qw17t34ftFnavFn8JrZ7Gw17XFy2q345Z3Zrtrn5GFWvgryDXrWDGFZ5XF4I
        qay5trs5Cr4qyagCm3ZEXasCq-sJn29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUP2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
        6r4j6r4UJwAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
        Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jw0_
        WrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
        CYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48J
        MxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        W8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1l
        IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8KNt3UUUU
        U==
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/5/30 09:52, Tianrui Zhao 写道:
> Implement kvm handle LoongArch vcpu exit caused by reading and
> writing csr. Using csr structure to emulate the registers.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  arch/loongarch/kvm/exit.c | 98 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 98 insertions(+)
>  create mode 100644 arch/loongarch/kvm/exit.c
> 
> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
> new file mode 100644
> index 000000000000..508cbce31aa5
> --- /dev/null
> +++ b/arch/loongarch/kvm/exit.c
> @@ -0,0 +1,98 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2020-2023 Loongson Technology Corporation Limited
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <linux/preempt.h>
> +#include <linux/vmalloc.h>
> +#include <asm/fpu.h>
> +#include <asm/inst.h>
> +#include <asm/time.h>
> +#include <asm/tlb.h>
> +#include <asm/loongarch.h>
> +#include <asm/numa.h>
> +#include <asm/kvm_vcpu.h>
> +#include <asm/kvm_csr.h>
> +#include <linux/kvm_host.h>
> +#include <asm/mmzone.h>
> +#include "trace.h"
> +
> +static unsigned long _kvm_emu_read_csr(struct kvm_vcpu *vcpu, int csrid)
> +{
> +	struct loongarch_csrs *csr = vcpu->arch.csr;
> +	unsigned long val = 0;
> +
> +	if (csrid < 4096 && (get_gcsr_flag(csrid) & SW_GCSR))
> +		val = kvm_read_sw_gcsr(csr, csrid);
> +	else
> +		pr_warn_once("Unsupport csrread 0x%x with pc %lx\n",
> +			csrid, vcpu->arch.pc);
> +	return val;
> +}
can 4096 be replace with macro, or be wrapped in function get_gcsr_flag and add GCSR_VALID flag?
> +
> +static void _kvm_emu_write_csr(struct kvm_vcpu *vcpu, int csrid,
> +	unsigned long val)
> +{
> +	struct loongarch_csrs *csr = vcpu->arch.csr;
> +
> +	if (csrid < 4096 && (get_gcsr_flag(csrid) & SW_GCSR))
> +		kvm_write_sw_gcsr(csr, csrid, val);
> +	else
> +		pr_warn_once("Unsupport csrwrite 0x%x with pc %lx\n",
> +				csrid, vcpu->arch.pc);
> +}
ditto 

> +
> +static void _kvm_emu_xchg_csr(struct kvm_vcpu *vcpu, int csrid,
> +	unsigned long csr_mask, unsigned long val)
> +{
> +	struct loongarch_csrs *csr = vcpu->arch.csr;
> +
> +	if (csrid < 4096 && (get_gcsr_flag(csrid) & SW_GCSR)) {
> +		unsigned long orig;
> +
> +		orig = kvm_read_sw_gcsr(csr, csrid);
> +		orig &= ~csr_mask;
> +		orig |= val & csr_mask;
> +		kvm_write_sw_gcsr(csr, csrid, orig);
> +	} else
> +		pr_warn_once("Unsupport csrxchg 0x%x with pc %lx\n",
> +				csrid, vcpu->arch.pc);
> +}
ditto

Regards
Bibo, Mao
> +
> +static int _kvm_handle_csr(struct kvm_vcpu *vcpu, larch_inst inst)
> +{
> +	unsigned int rd, rj, csrid;
> +	unsigned long csr_mask;
> +	unsigned long val = 0;
> +
> +	/*
> +	 * CSR value mask imm
> +	 * rj = 0 means csrrd
> +	 * rj = 1 means csrwr
> +	 * rj != 0,1 means csrxchg
> +	 */
> +	rd = inst.reg2csr_format.rd;
> +	rj = inst.reg2csr_format.rj;
> +	csrid = inst.reg2csr_format.csr;
> +
> +	/* Process CSR ops */
> +	if (rj == 0) {
> +		/* process csrrd */
> +		val = _kvm_emu_read_csr(vcpu, csrid);
> +		vcpu->arch.gprs[rd] = val;
> +	} else if (rj == 1) {
> +		/* process csrwr */
> +		val = vcpu->arch.gprs[rd];
> +		_kvm_emu_write_csr(vcpu, csrid, val);
> +	} else {
> +		/* process csrxchg */
> +		val = vcpu->arch.gprs[rd];
> +		csr_mask = vcpu->arch.gprs[rj];
> +		_kvm_emu_xchg_csr(vcpu, csrid, csr_mask, val);
> +	}
> +
> +	return EMULATE_DONE;
> +}

