Return-Path: <kvm+bounces-21478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A45592F66E
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 09:46:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F033F1F23A38
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 07:46:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D04D2BE68;
	Fri, 12 Jul 2024 07:46:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9AA341C79;
	Fri, 12 Jul 2024 07:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720770393; cv=none; b=d7RAk8xYRtfPBTxkc1RxLCrLIStiyX1eZrKPazBmNyeO5vC0gbpbccMBjxtAEexl2/ul3vMRjTSvblxHt3dOgBjw3TV32vABeFH6xlW6q3ncPd+tagmXyO8cFPVUxr1KSgP9JDQyI8843fUrOiB5CkAO8fJ/Mp9MrkE7s4YBBrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720770393; c=relaxed/simple;
	bh=6Hj4PVIPSSQRE82n9CWOaxzHwyxDKWPcCy7AUmYlUsg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=WbYkoHTavBZ/LBhyjiNt6s/pr9KLl7314y5uheIKKkVyMrB/Um0zNDcN4QoNrd4drsRaPtIM8XY7IJvyaS03gmkxexQ1J6TL30ARTkKKt9Nv1Q7oiQQ9g2VyKv2fwZhe9Tv4lTCcjpwpP7mn0sjwRVziNLEEX/8Sk5v/Eg3PK5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxvfBT35BmQpkDAA--.10622S3;
	Fri, 12 Jul 2024 15:46:27 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Cx68ZP35BmjZJFAA--.27077S3;
	Fri, 12 Jul 2024 15:46:26 +0800 (CST)
Subject: Re: [PATCH 03/11] LoongArch: KVM: Add IPI read and write function
To: Xianglai Li <lixianglai@loongson.cn>, linux-kernel@vger.kernel.org
Cc: Min Zhou <zhoumin@loongson.cn>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
 WANG Xuerui <kernel@xen0n.name>
References: <20240705023854.1005258-1-lixianglai@loongson.cn>
 <20240705023854.1005258-4-lixianglai@loongson.cn>
From: maobibo <maobibo@loongson.cn>
Message-ID: <59fa32f7-b1e2-20e8-9c02-f628727a6d15@loongson.cn>
Date: Fri, 12 Jul 2024 15:46:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240705023854.1005258-4-lixianglai@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Cx68ZP35BmjZJFAA--.27077S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Cw18CF1fXw15XF47KrWDZFc_yoWDur17pF
	yUZws3urW8tFWxWwnrJan09Fn8Kw4vgr1av343GaySyF4jq3s0yF4vkrWDZa98Wa48ZF4I
	v3Z0kw4Dua1qy3cCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv
	67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jY
	SoJUUUUU=



On 2024/7/5 上午10:38, Xianglai Li wrote:
> Implementation of IPI interrupt controller address
> space read and write function simulation.
> 
> Signed-off-by: Min Zhou <zhoumin@loongson.cn>
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
> ---
> Cc: Bibo Mao <maobibo@loongson.cn>
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: kvm@vger.kernel.org
> Cc: loongarch@lists.linux.dev
> Cc: Min Zhou <zhoumin@loongson.cn>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: Xianglai li <lixianglai@loongson.cn>
> 
>   arch/loongarch/include/asm/kvm_host.h |   2 +
>   arch/loongarch/include/asm/kvm_ipi.h  |  16 ++
>   arch/loongarch/kvm/intc/ipi.c         | 287 +++++++++++++++++++++++++-
>   3 files changed, 303 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
> index 4f6ccc688c1b..b28487975336 100644
> --- a/arch/loongarch/include/asm/kvm_host.h
> +++ b/arch/loongarch/include/asm/kvm_host.h
> @@ -41,6 +41,8 @@ struct kvm_vm_stat {
>   	struct kvm_vm_stat_generic generic;
>   	u64 pages;
>   	u64 hugepages;
> +	u64 ipi_read_exits;
> +	u64 ipi_write_exits;
>   };
>   
>   struct kvm_vcpu_stat {
> diff --git a/arch/loongarch/include/asm/kvm_ipi.h b/arch/loongarch/include/asm/kvm_ipi.h
> index 875a93008802..729dfc1e3f40 100644
> --- a/arch/loongarch/include/asm/kvm_ipi.h
> +++ b/arch/loongarch/include/asm/kvm_ipi.h
> @@ -29,8 +29,24 @@ struct ipi_state {
>   #define SMP_MAILBOX			0x1000
>   #define KVM_IOCSR_IPI_ADDR_SIZE		0x48
>   
> +#define CORE_STATUS_OFF			0x000
> +#define CORE_EN_OFF			0x004
> +#define CORE_SET_OFF			0x008
> +#define CORE_CLEAR_OFF			0x00c
> +#define CORE_BUF_20			0x020
> +#define CORE_BUF_28			0x028
> +#define CORE_BUF_30			0x030
> +#define CORE_BUF_38			0x038
> +#define IOCSR_IPI_SEND			0x040
> +
> +#define IOCSR_MAIL_SEND			0x048
> +#define IOCSR_ANY_SEND			0x158
> +
>   #define MAIL_SEND_ADDR			(SMP_MAILBOX + IOCSR_MAIL_SEND)
>   #define KVM_IOCSR_MAIL_ADDR_SIZE	0x118
>   
> +#define MAIL_SEND_OFFSET		0
> +#define ANY_SEND_OFFSET			(IOCSR_ANY_SEND - IOCSR_MAIL_SEND)
> +
>   int kvm_loongarch_register_ipi_device(void);
>   #endif
> diff --git a/arch/loongarch/kvm/intc/ipi.c b/arch/loongarch/kvm/intc/ipi.c
> index a9dc0aaec502..815858671005 100644
> --- a/arch/loongarch/kvm/intc/ipi.c
> +++ b/arch/loongarch/kvm/intc/ipi.c
> @@ -7,24 +7,307 @@
>   #include <asm/kvm_ipi.h>
>   #include <asm/kvm_vcpu.h>
>   
> +static void ipi_send(struct kvm *kvm, uint64_t data)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_interrupt irq;
> +	int cpu, action, status;
> +
> +	cpu = ((data & 0xffffffff) >> 16) & 0x3ff;
> +	vcpu = kvm_get_vcpu_by_cpuid(kvm, cpu);
> +	if (unlikely(vcpu == NULL)) {
> +		kvm_err("%s: invalid target cpu: %d\n", __func__, cpu);
> +		return;
> +	}
> +
> +	action = 1 << (data & 0x1f);
> +
> +	spin_lock(&vcpu->arch.ipi_state.lock);
> +	status = vcpu->arch.ipi_state.status;
> +	vcpu->arch.ipi_state.status |= action;
How about move spin_unlock(&vcpu->arch.ipi_state.lock) here?
Put it before kvm_vcpu_ioctl_interrupt(). > +	if (status == 0) {
> +		irq.irq = LARCH_INT_IPI;
> +		kvm_vcpu_ioctl_interrupt(vcpu, &irq);
> +	}
> +	spin_unlock(&vcpu->arch.ipi_state.lock);
> +}
> +
> +static void ipi_clear(struct kvm_vcpu *vcpu, uint64_t data)
> +{
> +	struct kvm_interrupt irq;
> +
> +	spin_lock(&vcpu->arch.ipi_state.lock);
> +	vcpu->arch.ipi_state.status &= ~data;
> +	if (!vcpu->arch.ipi_state.status) {
> +		irq.irq = -LARCH_INT_IPI;
> +		kvm_vcpu_ioctl_interrupt(vcpu, &irq);
> +	}
> +	spin_unlock(&vcpu->arch.ipi_state.lock);
Ditto, put spin_unlock() ahead of kvm_vcpu_ioctl_interrupt().

> +}
> +
> +static uint64_t read_mailbox(struct kvm_vcpu *vcpu, int offset, int len)
> +{
> +	void *pbuf;
> +	uint64_t ret = 0;
> +
> +	spin_lock(&vcpu->arch.ipi_state.lock);
> +	pbuf = (void *)vcpu->arch.ipi_state.buf + (offset - 0x20);
> +	if (len == 1)
> +		ret = *(unsigned char *)pbuf;
> +	else if (len == 2)
> +		ret = *(unsigned short *)pbuf;
> +	else if (len == 4)
> +		ret = *(unsigned int *)pbuf;
> +	else if (len == 8)
> +		ret = *(unsigned long *)pbuf;
> +	else
> +		kvm_err("%s: unknown data len: %d\n", __func__, len);
> +	spin_unlock(&vcpu->arch.ipi_state.lock);
kvm_err() had better put outside of spin_unlock.
> +
> +	return ret;
> +}
> +
> +static void write_mailbox(struct kvm_vcpu *vcpu, int offset,
> +			uint64_t data, int len)
> +{
> +	void *pbuf;
> +
> +	spin_lock(&vcpu->arch.ipi_state.lock);
> +	pbuf = (void *)vcpu->arch.ipi_state.buf + (offset - 0x20);
> +	if (len == 1)
> +		*(unsigned char *)pbuf = (unsigned char)data;
> +	else if (len == 2)
> +		*(unsigned short *)pbuf = (unsigned short)data;
> +	else if (len == 4)
> +		*(unsigned int *)pbuf = (unsigned int)data;
> +	else if (len == 8)
> +		*(unsigned long *)pbuf = (unsigned long)data;
> +	else
> +		kvm_err("%s: unknown data len: %d\n", __func__, len);
> +	spin_unlock(&vcpu->arch.ipi_state.lock);
Ditto, kvm_err() had better put outside of spin_unlock.
> +}
> +
> +static int loongarch_ipi_writel(struct kvm_vcpu *vcpu, gpa_t addr,
> +				int len, const void *val)
> +{
> +	uint64_t data;
> +	uint32_t offset;
> +	int ret = 0;
> +
> +	data = *(uint64_t *)val;
> +
> +	offset = (uint32_t)(addr & 0xff);
> +	WARN_ON_ONCE(offset & (len - 1));
> +
> +	switch (offset) {
> +	case CORE_STATUS_OFF:
> +		kvm_err("CORE_SET_OFF Can't be write\n");
> +		ret = -EINVAL;
> +		break;
> +	case CORE_EN_OFF:
> +		spin_lock(&vcpu->arch.ipi_state.lock);
> +		vcpu->arch.ipi_state.en = data;
> +		spin_unlock(&vcpu->arch.ipi_state.lock);
> +		break;
> +	case IOCSR_IPI_SEND:
> +		ipi_send(vcpu->kvm, data);
> +		break;
> +	case CORE_SET_OFF:
> +		kvm_info("CORE_SET_OFF simulation is required\n");
kvm_info is not necessary here.

Regards
Bibo Mao
> +		ret = -EINVAL;
> +		break;
> +	case CORE_CLEAR_OFF:
> +		/* Just clear the status of the current vcpu */
> +		ipi_clear(vcpu, data);
> +		break;
> +	case CORE_BUF_20 ... CORE_BUF_38 + 7:
> +		if (offset + len > CORE_BUF_38 + 8) {
> +			kvm_err("%s: invalid offset or len: offset = %d, len = %d\n",
> +				__func__, offset, len);
> +			ret = -EINVAL;
> +			break;
> +		}
> +		write_mailbox(vcpu, offset, data, len);
> +		break;
> +	default:
> +		kvm_err("%s: unknown addr: %llx\n", __func__, addr);
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int loongarch_ipi_readl(struct kvm_vcpu *vcpu, gpa_t addr,
> +				int len, void *val)
> +{
> +	uint32_t offset;
> +	uint64_t res = 0;
> +	int ret = 0;
> +
> +	offset = (uint32_t)(addr & 0xff);
> +	WARN_ON_ONCE(offset & (len - 1));
> +
> +	switch (offset) {
> +	case CORE_STATUS_OFF:
> +		spin_lock(&vcpu->arch.ipi_state.lock);
> +		res = vcpu->arch.ipi_state.status;
> +		spin_unlock(&vcpu->arch.ipi_state.lock);
> +		break;
> +	case CORE_EN_OFF:
> +		spin_lock(&vcpu->arch.ipi_state.lock);
> +		res = vcpu->arch.ipi_state.en;
> +		spin_unlock(&vcpu->arch.ipi_state.lock);
> +		break;
> +	case CORE_SET_OFF:
> +		res = 0;
> +		break;
> +	case CORE_CLEAR_OFF:
> +		res = 0;
> +		break;
> +	case CORE_BUF_20 ... CORE_BUF_38 + 7:
> +		if (offset + len > CORE_BUF_38 + 8) {
> +			kvm_err("%s: invalid offset or len: offset = %d, len = %d\n",
> +				__func__, offset, len);
> +			ret = -EINVAL;
> +			break;
> +		}
> +		res = read_mailbox(vcpu, offset, len);
> +		break;
> +	default:
> +		kvm_err("%s: unknown addr: %llx\n", __func__, addr);
> +		ret = -EINVAL;
> +		break;
> +	}
> +
> +	*(uint64_t *)val = res;
> +
> +	return ret;
> +}
> +
>   static int kvm_loongarch_ipi_write(struct kvm_vcpu *vcpu,
>   			struct kvm_io_device *dev,
>   			gpa_t addr, int len, const void *val)
>   {
> -	return 0;
> +	struct loongarch_ipi *ipi;
> +	int ret;
> +
> +	ipi = vcpu->kvm->arch.ipi;
> +	if (!ipi) {
> +		kvm_err("%s: ipi irqchip not valid!\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	ipi->kvm->stat.ipi_write_exits++;
> +	ret = loongarch_ipi_writel(vcpu, addr, len, val);
> +
> +	return ret;
>   }
>   
>   static int kvm_loongarch_ipi_read(struct kvm_vcpu *vcpu,
>   			struct kvm_io_device *dev,
>   			gpa_t addr, int len, void *val)
>   {
> -	return 0;
> +	struct loongarch_ipi *ipi;
> +	int ret;
> +
> +	ipi = vcpu->kvm->arch.ipi;
> +	if (!ipi) {
> +		kvm_err("%s: ipi irqchip not valid!\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	ipi->kvm->stat.ipi_read_exits++;
> +	ret = loongarch_ipi_readl(vcpu, addr, len, val);
> +
> +	return ret;
> +}
> +
> +static void send_ipi_data(struct kvm_vcpu *vcpu, gpa_t addr, uint64_t data)
> +{
> +	int i;
> +	uint32_t val = 0, mask = 0;
> +	/*
> +	 * Bit 27-30 is mask for byte writing.
> +	 * If the mask is 0, we need not to do anything.
> +	 */
> +	if ((data >> 27) & 0xf) {
> +		/* Read the old val */
> +		kvm_io_bus_read(vcpu, KVM_IOCSR_BUS, addr, sizeof(val), &val);
> +
> +		/* Construct the mask by scanning the bit 27-30 */
> +		for (i = 0; i < 4; i++) {
> +			if (data & (0x1 << (27 + i)))
> +				mask |= (0xff << (i * 8));
> +		}
> +	/* Save the old part of val */
> +		val &= mask;
> +	}
> +
> +	val |= ((uint32_t)(data >> 32) & ~mask);
> +	kvm_io_bus_write(vcpu, KVM_IOCSR_BUS, addr, sizeof(val), &val);
> +}
> +
> +static void mail_send(struct kvm *kvm, uint64_t data)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int cpu, mailbox;
> +	int offset;
> +
> +	cpu = ((data & 0xffffffff) >> 16) & 0x3ff;
> +	vcpu = kvm_get_vcpu_by_cpuid(kvm, cpu);
> +	if (unlikely(vcpu == NULL)) {
> +		kvm_err("%s: invalid target cpu: %d\n", __func__, cpu);
> +		return;
> +	}
> +
> +	mailbox = ((data & 0xffffffff) >> 2) & 0x7;
> +	offset = SMP_MAILBOX + CORE_BUF_20 + mailbox * 4;
> +	send_ipi_data(vcpu, offset, data);
> +}
> +
> +static void any_send(struct kvm *kvm, uint64_t data)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int cpu, offset;
> +
> +	cpu = ((data & 0xffffffff) >> 16) & 0x3ff;
> +	vcpu = kvm_get_vcpu_by_cpuid(kvm, cpu);
> +	if (unlikely(vcpu == NULL)) {
> +		kvm_err("%s: invalid target cpu: %d\n", __func__, cpu);
> +		return;
> +	}
> +
> +	offset = data & 0xffff;
> +	send_ipi_data(vcpu, offset, data);
>   }
>   
>   static int kvm_loongarch_mail_write(struct kvm_vcpu *vcpu,
>   			struct kvm_io_device *dev,
>   			gpa_t addr, int len, const void *val)
>   {
> +	struct loongarch_ipi *ipi;
> +
> +	ipi = vcpu->kvm->arch.ipi;
> +	if (!ipi) {
> +		kvm_err("%s: ipi irqchip not valid!\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	addr &= 0xfff;
> +	addr -= IOCSR_MAIL_SEND;
> +
> +	switch (addr) {
> +	case MAIL_SEND_OFFSET:
> +		mail_send(vcpu->kvm, *(uint64_t *)val);
> +		break;
> +	case ANY_SEND_OFFSET:
> +		any_send(vcpu->kvm, *(uint64_t *)val);
> +		break;
> +	default:
> +		break;
> +	}
> +
>   	return 0;
>   }
>   
> 


