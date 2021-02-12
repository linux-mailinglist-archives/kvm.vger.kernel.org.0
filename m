Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8529319DB9
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 12:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhBLL6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 06:58:00 -0500
Received: from foss.arm.com ([217.140.110.172]:35832 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231177AbhBLL47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 06:56:59 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6401B113E;
        Fri, 12 Feb 2021 03:56:07 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A3203F719;
        Fri, 12 Feb 2021 03:56:06 -0800 (PST)
Subject: Re: [PATCH kvmtool 10/21] hw/rtc: Refactor trap handlers
To:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-11-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <cc9f2ae6-5a4d-c4d8-59d5-40d9cb770831@arm.com>
Date:   Fri, 12 Feb 2021 11:56:19 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20201210142908.169597-11-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 12/10/20 2:28 PM, Andre Przywara wrote:
> With the planned retirement of the special ioport emulation code, we
> need to provide emulation functions compatible with the MMIO prototype.
>
> Merge the two different trap handlers into one function, checking for
> read/write and data/index register inside.
> Adjust the trap handlers to use that new function, and provide shims to
> implement the old ioport interface, for now.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  hw/rtc.c | 70 ++++++++++++++++++++++++++++----------------------------
>  1 file changed, 35 insertions(+), 35 deletions(-)
>
> diff --git a/hw/rtc.c b/hw/rtc.c
> index 5483879f..664d4cb0 100644
> --- a/hw/rtc.c
> +++ b/hw/rtc.c
> @@ -42,11 +42,37 @@ static inline unsigned char bin2bcd(unsigned val)
>  	return ((val / 10) << 4) + val % 10;
>  }
>  
> -static bool cmos_ram_data_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> +static void cmos_ram_io(struct kvm_cpu *vcpu, u64 addr, u8 *data,
> +			u32 len, u8 is_write, void *ptr)
>  {
>  	struct tm *tm;
>  	time_t ti;
>  
> +	if (is_write) {
> +		if (addr == 0x70) {	/* index register */
> +			u8 value = ioport__read8(data);
> +
> +			vcpu->kvm->nmi_disabled	= value & (1UL << 7);
> +			rtc.cmos_idx		= value & ~(1UL << 7);
> +
> +			return;
> +		}
> +
> +		switch (rtc.cmos_idx) {
> +		case RTC_REG_C:
> +		case RTC_REG_D:
> +			/* Read-only */
> +			break;
> +		default:
> +			rtc.cmos_data[rtc.cmos_idx] = ioport__read8(data);
> +			break;
> +		}
> +		return;
> +	}
> +
> +	if (addr == 0x70)
> +		return;
> +
>  	time(&ti);
>  
>  	tm = gmtime(&ti);
> @@ -92,42 +118,23 @@ static bool cmos_ram_data_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 po
>  		ioport__write8(data, rtc.cmos_data[rtc.cmos_idx]);
>  		break;
>  	}
> -
> -	return true;
>  }
>  
> -static bool cmos_ram_data_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> +static bool cmos_ram_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
>  {
> -	switch (rtc.cmos_idx) {
> -	case RTC_REG_C:
> -	case RTC_REG_D:
> -		/* Read-only */
> -		break;
> -	default:
> -		rtc.cmos_data[rtc.cmos_idx] = ioport__read8(data);
> -		break;
> -	}
> -
> +	cmos_ram_io(vcpu, port, data, size, false, NULL);
>  	return true;
>  }
>  
> -static struct ioport_operations cmos_ram_data_ioport_ops = {
> -	.io_out		= cmos_ram_data_out,
> -	.io_in		= cmos_ram_data_in,
> -};
> -
> -static bool cmos_ram_index_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
> +static bool cmos_ram_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void *data, int size)
>  {
> -	u8 value = ioport__read8(data);
> -
> -	vcpu->kvm->nmi_disabled	= value & (1UL << 7);
> -	rtc.cmos_idx		= value & ~(1UL << 7);
> -
> +	cmos_ram_io(vcpu, port, data, size, true, NULL);
>  	return true;
>  }
>  
> -static struct ioport_operations cmos_ram_index_ioport_ops = {
> -	.io_out		= cmos_ram_index_out,
> +static struct ioport_operations cmos_ram_ioport_ops = {
> +	.io_out		= cmos_ram_out,
> +	.io_in		= cmos_ram_in,
>  };
>  
>  #ifdef CONFIG_HAS_LIBFDT
> @@ -162,21 +169,15 @@ int rtc__init(struct kvm *kvm)
>  		return r;
>  
>  	/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
> -	r = ioport__register(kvm, 0x0070, &cmos_ram_index_ioport_ops, 1, NULL);
> +	r = ioport__register(kvm, 0x0070, &cmos_ram_ioport_ops, 2, NULL);
>  	if (r < 0)
>  		goto out_device;
>  
> -	r = ioport__register(kvm, 0x0071, &cmos_ram_data_ioport_ops, 1, NULL);
> -	if (r < 0)
> -		goto out_ioport;
> -
>  	/* Set the VRT bit in Register D to indicate valid RAM and time */
>  	rtc.cmos_data[RTC_REG_D] = RTC_REG_D_VRT;
>  
>  	return r;
>  
> -out_ioport:
> -	ioport__unregister(kvm, 0x0070);
>  out_device:
>  	device__unregister(&rtc_dev_hdr);
>  
> @@ -188,7 +189,6 @@ int rtc__exit(struct kvm *kvm)
>  {
>  	/* PORT 0070-007F - CMOS RAM/RTC (REAL TIME CLOCK) */
>  	ioport__unregister(kvm, 0x0070);
> -	ioport__unregister(kvm, 0x0071);
>  
>  	return 0;
>  }

The behaviour is preserved with this patch, and it compiles, so:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
