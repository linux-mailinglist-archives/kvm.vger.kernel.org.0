Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6F66AD49C
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 03:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjCGCYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 21:24:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjCGCX6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 21:23:58 -0500
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E217628234;
        Mon,  6 Mar 2023 18:23:53 -0800 (PST)
Received: from loongson.cn (unknown [10.20.42.170])
        by gateway (Coremail) with SMTP id _____8AxEk44oAZkdCkJAA--.12S3;
        Tue, 07 Mar 2023 10:23:52 +0800 (CST)
Received: from [10.20.42.170] (unknown [10.20.42.170])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Dx6r02oAZkU3JNAA--.4220S3;
        Tue, 07 Mar 2023 10:23:51 +0800 (CST)
Message-ID: <221b58cc-81b6-c55a-b1eb-68947cd19c88@loongson.cn>
Date:   Tue, 7 Mar 2023 10:23:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 09/29] LoongArch: KVM: Implement vcpu get, vcpu set
 registers
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
 <20230228070057.3687180-10-zhaotianrui@loongson.cn>
From:   maobibo <maobibo@loongson.cn>
In-Reply-To: <20230228070057.3687180-10-zhaotianrui@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Dx6r02oAZkU3JNAA--.4220S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBjvAXoW3Cw18tFy5Cr4fZryxKFy3Jwb_yoW8GF4fAo
        Z3tw48Cr4fGw12yw47tr12qay8JFyxC3Z7ZFyrZF1F9a9rtFyfXr18AayDZryfWrnxuryU
        Ca1qga4kuaykJ3Z8n29KB7ZKAUJUUUUf529EdanIXcx71UUUUU7KY7ZEXasCq-sGcSsGvf
        J3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnRJU
        UUPab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s
        0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
        Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1l84
        ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr0_Cr1U
        M2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zV
        CFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2
        z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2
        IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E
        4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGw
        C20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48J
        MIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMI
        IF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E
        87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU4SoGDUUUU
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2023/2/28 15:00, Tianrui Zhao 写道:
> Implement loongarch vcpu get registers and set registers operations, it
> is called when user space use the ioctl interface to get or set regs.
> 
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  arch/loongarch/kvm/vcpu.c | 375 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 375 insertions(+)
> 
> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
> index e16b7ca852e3..dce89ace2750 100644
> --- a/arch/loongarch/kvm/vcpu.c
> +++ b/arch/loongarch/kvm/vcpu.c
> @@ -13,6 +13,381 @@
>  #define CREATE_TRACE_POINTS
>  #include "trace.h"
>  
> +int _kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *v, int force)
> +{
> +	struct loongarch_csrs *csr = vcpu->arch.csr;
> +
> +	GET_HW_GCSR(id, LOONGARCH_CSR_CRMD, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_PRMD, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_EUEN, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_MISC, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_ECFG, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_ESTAT, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_ERA, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_BADV, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_BADI, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_EENTRY, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_TLBIDX, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_TLBEHI, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_TLBELO0, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_TLBELO1, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_ASID, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_PGDL, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_PGDH, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_PWCTL0, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_PWCTL1, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_STLBPGSIZE, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_RVACFG, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_CPUID, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_PRCFG1, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_PRCFG2, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_PRCFG3, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_KS0, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_KS1, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_KS2, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_KS3, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_KS4, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_KS5, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_KS6, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_KS7, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_TMID, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_TCFG, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_TVAL, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_CNTC, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_LLBCTL, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_TLBRENTRY, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_TLBRBADV, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_TLBRERA, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_TLBRSAVE, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_TLBRELO0, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_TLBRELO1, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_TLBREHI, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_TLBRPRMD, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_DMWIN0, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_DMWIN1, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_DMWIN2, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_DMWIN3, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_MWPS, v);
> +	GET_HW_GCSR(id, LOONGARCH_CSR_FWPS, v);

#define GET_HW_GCSR(id, csrid, v)                               \
        do {                                                    \
                if (csrid == id) {                              \
                        *v = (long)kvm_read_hw_gcsr(csrid);     \
                        return 0;                               \
                }                                               \
        } while (0)

With expanded macro, this piece of code shows like this:
        if (LOONGARCH_CSR_CRMD == id) {
              *v = (long)kvm_read_hw_gcsr(LOONGARCH_CSR_CRMD);
              return 0;
        }
        if (LOONGARCH_CSR_PRMD == id) {
              *v = (long)kvm_read_hw_gcsr(LOONGARCH_CSR_PRMD);
              return 0;
        }
        if (LOONGARCH_CSR_EUEN == id) {
              *v = (long)kvm_read_hw_gcsr(LOONGARCH_CSR_EUEN);
              return 0;
        }
        ...

It is strange since macro kvm_read_hw_gcsr must be constant variable.
Can we define generic csr reading function like this?
SYM_CODE_START(kvm_csrread)
    ldpcrel t0, 0f
    multi.d a0, a0, CSRFUNC_SIZE
    add.d   t0, t0, a0
    jirl    r0, t0, 0

    csrnum=0
    .rept NR_CSR_NUM
0 :
        csrread  a0, csrnum
        jirl    r0, ra, 0
        /* Ensure that the above is CSRFUNC_ALIGN bytes max */
        .fill 0b + CSRFUNC_SIZE - ., 1, 0xcc
        csrnum = csrnum+1
    .endr
SYM_CODE_END(kvm_csrread)

Wit this function, only one sentence can be used here.
   v = kvm_csrread(id);


Regards
Bibo, mao





> +
> +	GET_SW_GCSR(csr, id, LOONGARCH_CSR_IMPCTL1, v);
> +	GET_SW_GCSR(csr, id, LOONGARCH_CSR_IMPCTL2, v);
> +	GET_SW_GCSR(csr, id, LOONGARCH_CSR_MERRCTL, v);
> +	GET_SW_GCSR(csr, id, LOONGARCH_CSR_MERRINFO1, v);
> +	GET_SW_GCSR(csr, id, LOONGARCH_CSR_MERRINFO2, v);
> +	GET_SW_GCSR(csr, id, LOONGARCH_CSR_MERRENTRY, v);
> +	GET_SW_GCSR(csr, id, LOONGARCH_CSR_MERRERA, v);
> +	GET_SW_GCSR(csr, id, LOONGARCH_CSR_MERRSAVE, v);
> +	GET_SW_GCSR(csr, id, LOONGARCH_CSR_CTAG, v);
> +	GET_SW_GCSR(csr, id, LOONGARCH_CSR_DEBUG, v);
> +	GET_SW_GCSR(csr, id, LOONGARCH_CSR_DERA, v);
> +	GET_SW_GCSR(csr, id, LOONGARCH_CSR_DESAVE, v);
> +
> +	GET_SW_GCSR(csr, id, LOONGARCH_CSR_TINTCLR, v);
> +
> +	if (force && (id < CSR_ALL_SIZE)) {
> +		*v = kvm_read_sw_gcsr(csr, id);
> +		return 0;
> +	}
> +
> +	return -1;
> +}
> +
> +int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *v, int force)
> +{
> +	struct loongarch_csrs *csr = vcpu->arch.csr;
> +	int ret;
> +
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_CRMD, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_PRMD, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_EUEN, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_MISC, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_ECFG, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_ERA, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_BADV, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_BADI, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_EENTRY, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_TLBIDX, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_TLBEHI, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_TLBELO0, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_TLBELO1, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_ASID, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_PGDL, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_PGDH, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_PWCTL0, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_PWCTL1, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_STLBPGSIZE, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_RVACFG, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_CPUID, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_KS0, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_KS1, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_KS2, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_KS3, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_KS4, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_KS5, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_KS6, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_KS7, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_TMID, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_TCFG, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_TVAL, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_CNTC, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_LLBCTL, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_TLBRENTRY, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_TLBRBADV, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_TLBRERA, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_TLBRSAVE, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_TLBRELO0, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_TLBRELO1, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_TLBREHI, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_TLBRPRMD, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_DMWIN0, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_DMWIN1, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_DMWIN2, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_DMWIN3, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_MWPS, v);
> +	SET_HW_GCSR(csr, id, LOONGARCH_CSR_FWPS, v);
> +
> +	SET_SW_GCSR(csr, id, LOONGARCH_CSR_IMPCTL1, v);
> +	SET_SW_GCSR(csr, id, LOONGARCH_CSR_IMPCTL2, v);
> +	SET_SW_GCSR(csr, id, LOONGARCH_CSR_MERRCTL, v);
> +	SET_SW_GCSR(csr, id, LOONGARCH_CSR_MERRINFO1, v);
> +	SET_SW_GCSR(csr, id, LOONGARCH_CSR_MERRINFO2, v);
> +	SET_SW_GCSR(csr, id, LOONGARCH_CSR_MERRENTRY, v);
> +	SET_SW_GCSR(csr, id, LOONGARCH_CSR_MERRERA, v);
> +	SET_SW_GCSR(csr, id, LOONGARCH_CSR_MERRSAVE, v);
> +	SET_SW_GCSR(csr, id, LOONGARCH_CSR_CTAG, v);
> +	SET_SW_GCSR(csr, id, LOONGARCH_CSR_DEBUG, v);
> +	SET_SW_GCSR(csr, id, LOONGARCH_CSR_DERA, v);
> +	SET_SW_GCSR(csr, id, LOONGARCH_CSR_DESAVE, v);
> +	SET_SW_GCSR(csr, id, LOONGARCH_CSR_PRCFG1, v);
> +	SET_SW_GCSR(csr, id, LOONGARCH_CSR_PRCFG2, v);
> +	SET_SW_GCSR(csr, id, LOONGARCH_CSR_PRCFG3, v);
> +
> +	SET_SW_GCSR(csr, id, LOONGARCH_CSR_PGD, v);
> +	SET_SW_GCSR(csr, id, LOONGARCH_CSR_TINTCLR, v);
> +
> +	ret = -1;
> +	switch (id) {
> +	case LOONGARCH_CSR_ESTAT:
> +		write_gcsr_estat(*v);
> +		/* estat IP0~IP7 inject through guestexcept */
> +		write_csr_gintc(((*v) >> 2)  & 0xff);
> +		ret = 0;
> +		break;
> +	default:
> +		if (force && (id < CSR_ALL_SIZE)) {
> +			kvm_set_sw_gcsr(csr, id, *v);
> +			ret = 0;
> +		}
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int _kvm_get_one_reg(struct kvm_vcpu *vcpu,
> +		const struct kvm_one_reg *reg, s64 *v)
> +{
> +	struct loongarch_csrs *csr = vcpu->arch.csr;
> +	int reg_idx, ret;
> +
> +	if ((reg->id & KVM_IOC_CSRID(0)) == KVM_IOC_CSRID(0)) {
> +		reg_idx = KVM_GET_IOC_CSRIDX(reg->id);
> +		ret = _kvm_getcsr(vcpu, reg_idx, v, 0);
> +		if (ret == 0)
> +			return ret;
> +	}
> +
> +	switch (reg->id) {
> +	case KVM_REG_LOONGARCH_COUNTER:
> +		*v = drdtime() + vcpu->kvm->arch.time_offset;
> +		break;
> +	default:
> +		if ((reg->id & KVM_REG_LOONGARCH_MASK) != KVM_REG_LOONGARCH_CSR)
> +			return -EINVAL;
> +
> +		reg_idx = KVM_GET_IOC_CSRIDX(reg->id);
> +		if (reg_idx < CSR_ALL_SIZE)
> +			*v = kvm_read_sw_gcsr(csr, reg_idx);
> +		else
> +			return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int _kvm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> +{
> +	int ret;
> +	s64 v;
> +
> +	ret = _kvm_get_one_reg(vcpu, reg, &v);
> +	if (ret)
> +		return ret;
> +
> +	ret = -EINVAL;
> +	if ((reg->id & KVM_REG_SIZE_MASK) == KVM_REG_SIZE_U64) {
> +		u64 __user *uaddr = (u64 __user *)(long)reg->addr;
> +
> +		ret = put_user(v, uaddr);
> +	} else if ((reg->id & KVM_REG_SIZE_MASK) == KVM_REG_SIZE_U32) {
> +		u32 __user *uaddr = (u32 __user *)(long)reg->addr;
> +		u32 v32 = (u32)v;
> +
> +		ret = put_user(v32, uaddr);
> +	}
> +
> +	return ret;
> +}
> +
> +static int _kvm_set_one_reg(struct kvm_vcpu *vcpu,
> +		const struct kvm_one_reg *reg,
> +		s64 v)
> +{
> +	struct loongarch_csrs *csr = vcpu->arch.csr;
> +	int ret = 0;
> +	unsigned long flags;
> +	u64 val;
> +	int reg_idx;
> +
> +	val = v;
> +	if ((reg->id & KVM_IOC_CSRID(0)) == KVM_IOC_CSRID(0)) {
> +		reg_idx = KVM_GET_IOC_CSRIDX(reg->id);
> +		ret = _kvm_setcsr(vcpu, reg_idx, &val, 0);
> +		if (ret == 0)
> +			return ret;
> +	}
> +
> +	switch (reg->id) {
> +	case KVM_REG_LOONGARCH_COUNTER:
> +		local_irq_save(flags);
> +		/*
> +		 * gftoffset is relative with board, not vcpu
> +		 * only set for the first time for smp system
> +		 */
> +		if (vcpu->vcpu_id == 0)
> +			vcpu->kvm->arch.time_offset = (signed long)(v - drdtime());
> +		write_csr_gcntc((ulong)vcpu->kvm->arch.time_offset);
> +		local_irq_restore(flags);
> +		break;
> +	case KVM_REG_LOONGARCH_VCPU_RESET:
> +		kvm_reset_timer(vcpu);
> +		memset(&vcpu->arch.irq_pending, 0, sizeof(vcpu->arch.irq_pending));
> +		memset(&vcpu->arch.irq_clear, 0, sizeof(vcpu->arch.irq_clear));
> +		break;
> +	default:
> +		if ((reg->id & KVM_REG_LOONGARCH_MASK) != KVM_REG_LOONGARCH_CSR)
> +			return -EINVAL;
> +
> +		reg_idx = KVM_GET_IOC_CSRIDX(reg->id);
> +		if (reg_idx < CSR_ALL_SIZE)
> +			kvm_write_sw_gcsr(csr, reg_idx, v);
> +		else
> +			return -EINVAL;
> +	}
> +	return ret;
> +}
> +
> +static int _kvm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
> +{
> +	s64 v;
> +	int ret;
> +
> +	ret = -EINVAL;
> +	if ((reg->id & KVM_REG_SIZE_MASK) == KVM_REG_SIZE_U64) {
> +		u64 __user *uaddr;
> +
> +		uaddr = (u64 __user *)(long)reg->addr;
> +		ret = get_user(v, uaddr);
> +	} else if ((reg->id & KVM_REG_SIZE_MASK) == KVM_REG_SIZE_U32) {
> +		u32 __user *uaddr;
> +		s32 v32;
> +
> +		uaddr = (u32 __user *)(long)reg->addr;
> +		ret = get_user(v32, uaddr);
> +		v = (s64)v32;
> +	}
> +
> +	if (ret)
> +		return -EFAULT;
> +
> +	return _kvm_set_one_reg(vcpu, reg, v);
> +}
> +
> +int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
> +				  struct kvm_sregs *sregs)
> +{
> +	return -ENOIOCTLCMD;
> +}
> +
> +int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
> +				  struct kvm_sregs *sregs)
> +{
> +	return -ENOIOCTLCMD;
> +}
> +
> +int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
> +{
> +	int i;
> +
> +	vcpu_load(vcpu);
> +
> +	for (i = 0; i < ARRAY_SIZE(vcpu->arch.gprs); i++)
> +		regs->gpr[i] = vcpu->arch.gprs[i];
> +
> +	regs->pc = vcpu->arch.pc;
> +
> +	vcpu_put(vcpu);
> +	return 0;
> +}
> +
> +int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
> +{
> +	int i;
> +
> +	vcpu_load(vcpu);
> +
> +	for (i = 1; i < ARRAY_SIZE(vcpu->arch.gprs); i++)
> +		vcpu->arch.gprs[i] = regs->gpr[i];
> +	vcpu->arch.gprs[0] = 0; /* zero is special, and cannot be set. */
> +	vcpu->arch.pc = regs->pc;
> +
> +	vcpu_put(vcpu);
> +	return 0;
> +}
> +
> +long kvm_arch_vcpu_ioctl(struct file *filp,
> +			 unsigned int ioctl, unsigned long arg)
> +{
> +	struct kvm_vcpu *vcpu = filp->private_data;
> +	void __user *argp = (void __user *)arg;
> +	long r;
> +
> +	vcpu_load(vcpu);
> +
> +	switch (ioctl) {
> +	case KVM_SET_ONE_REG:
> +	case KVM_GET_ONE_REG: {
> +		struct kvm_one_reg reg;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&reg, argp, sizeof(reg)))
> +			break;
> +		if (ioctl == KVM_SET_ONE_REG)
> +			r = _kvm_set_reg(vcpu, &reg);
> +		else
> +			r = _kvm_get_reg(vcpu, &reg);
> +		break;
> +	}
> +	default:
> +		r = -ENOIOCTLCMD;
> +		break;
> +	}
> +
> +	vcpu_put(vcpu);
> +	return r;
> +}
> +
>  int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
>  {
>  	return 0;

