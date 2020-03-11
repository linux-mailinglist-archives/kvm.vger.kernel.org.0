Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 690411810F1
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 07:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgCKGm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 02:42:57 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11223 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726160AbgCKGm5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 02:42:57 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id EC7167B4F0923BCCC96B;
        Wed, 11 Mar 2020 14:42:45 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Wed, 11 Mar 2020
 14:42:39 +0800
Subject: Re: [kvm-unit-tests PATCH v5 05/13] arm/arm64: gicv3: Set the LPI
 config and pending tables
To:     Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>
CC:     <drjones@redhat.com>, <andre.przywara@arm.com>,
        <peter.maydell@linaro.org>, <alexandru.elisei@arm.com>,
        <thuth@redhat.com>
References: <20200310145410.26308-1-eric.auger@redhat.com>
 <20200310145410.26308-6-eric.auger@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <cd3bab7d-a585-b091-621c-0ae712b82b3c@huawei.com>
Date:   Wed, 11 Mar 2020 14:42:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200310145410.26308-6-eric.auger@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2020/3/10 22:54, Eric Auger wrote:
> Allocate the LPI configuration and per re-distributor pending table.
> Set redistributor's PROPBASER and PENDBASER. The LPIs are enabled
> by default in the config table.
> 
> Also introduce a helper routine that allows to set the pending table
> bit for a given LPI.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v4 -> v5:
> - Moved some reformattings previously done in
>    "arm/arm64: ITS: its_enable_defaults", in this patch
> - added assert(!gicv3_redist_base()) in gicv3_lpi_alloc_tables()
> - revert for_each_present_cpu() change
> 
> v2 -> v3:
> - Move the helpers in lib/arm/gic-v3.c and prefix them with "gicv3_"
>    and add _lpi prefix too
> 
> v1 -> v2:
> - remove memory attributes
> ---
>   lib/arm/asm/gic-v3.h | 15 +++++++++++++
>   lib/arm/gic-v3.c     | 53 ++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 68 insertions(+)
> 
> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> index 47df051..064cc68 100644
> --- a/lib/arm/asm/gic-v3.h
> +++ b/lib/arm/asm/gic-v3.h
> @@ -50,6 +50,15 @@
>   #define MPIDR_TO_SGI_AFFINITY(cluster_id, level) \
>   	(MPIDR_AFFINITY_LEVEL(cluster_id, level) << ICC_SGI1R_AFFINITY_## level ## _SHIFT)
>   
> +#define GICR_PROPBASER_IDBITS_MASK	(0x1f)

Again this can be dropped, but not a problem.

> +
> +#define GICR_PENDBASER_PTZ		BIT_ULL(62)
> +
> +#define LPI_PROP_GROUP1			(1 << 1)
> +#define LPI_PROP_ENABLED		(1 << 0)
> +#define LPI_PROP_DEFAULT_PRIO		0xa0
> +#define LPI_PROP_DEFAULT		(LPI_PROP_DEFAULT_PRIO | LPI_PROP_GROUP1 | LPI_PROP_ENABLED)
> +
>   #include <asm/arch_gicv3.h>
>   
>   #ifndef __ASSEMBLY__
> @@ -66,6 +75,8 @@ struct gicv3_data {
>   	void *dist_base;
>   	void *redist_bases[GICV3_NR_REDISTS];
>   	void *redist_base[NR_CPUS];
> +	u8 *lpi_prop;
> +	void *lpi_pend[NR_CPUS];
>   	unsigned int irq_nr;
>   };
>   extern struct gicv3_data gicv3_data;
> @@ -82,6 +93,10 @@ extern void gicv3_write_eoir(u32 irqstat);
>   extern void gicv3_ipi_send_single(int irq, int cpu);
>   extern void gicv3_ipi_send_mask(int irq, const cpumask_t *dest);
>   extern void gicv3_set_redist_base(size_t stride);
> +extern void gicv3_lpi_set_config(int n, u8 val);
> +extern u8 gicv3_lpi_get_config(int n);

These two declarations can be dropped, and I think it's better to
move their macro implementations here (they're now in patch #7).
But also not a problem.

> +extern void gicv3_lpi_set_clr_pending(int rdist, int n, bool set);
> +extern void gicv3_lpi_alloc_tables(void);
>   
>   static inline void gicv3_do_wait_for_rwp(void *base)
>   {
> diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
> index feecb5e..d752bd4 100644
> --- a/lib/arm/gic-v3.c
> +++ b/lib/arm/gic-v3.c
> @@ -5,6 +5,7 @@
>    */
>   #include <asm/gic.h>
>   #include <asm/io.h>
> +#include <alloc_page.h>
>   
>   void gicv3_set_redist_base(size_t stride)
>   {
> @@ -147,3 +148,55 @@ void gicv3_ipi_send_single(int irq, int cpu)
>   	cpumask_set_cpu(cpu, &dest);
>   	gicv3_ipi_send_mask(irq, &dest);
>   }
> +
> +#if defined(__aarch64__)
> +
> +/*
> + * alloc_lpi_tables - Allocate LPI config and pending tables
> + * and set PROPBASER (shared by all rdistributors) and per
> + * redistributor PENDBASER.
> + *
> + * gicv3_set_redist_base() must be called before
> + */
> +void gicv3_lpi_alloc_tables(void)
> +{
> +	unsigned long n = SZ_64K >> PAGE_SHIFT;
> +	unsigned long order = fls(n);
> +	u64 prop_val;
> +	int cpu;
> +
> +	assert(!gicv3_redist_base());

I guess you wanted assert(gicv3_redist_base())? With this confirmed,

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>


Thanks

> +
> +	gicv3_data.lpi_prop = alloc_pages(order);
> +
> +	/* ID bits = 13, ie. up to 14b LPI INTID */
> +	prop_val = (u64)(virt_to_phys(gicv3_data.lpi_prop)) | 13;
> +
> +	for_each_present_cpu(cpu) {
> +		u64 pend_val;
> +		void *ptr;
> +
> +		ptr = gicv3_data.redist_base[cpu];
> +
> +		writeq(prop_val, ptr + GICR_PROPBASER);
> +
> +		gicv3_data.lpi_pend[cpu] = alloc_pages(order);
> +		pend_val = (u64)(virt_to_phys(gicv3_data.lpi_pend[cpu]));
> +		writeq(pend_val, ptr + GICR_PENDBASER);
> +	}
> +}
> +
> +void gicv3_lpi_set_clr_pending(int rdist, int n, bool set)
> +{
> +	u8 *ptr = gicv3_data.lpi_pend[rdist];
> +	u8 mask = 1 << (n % 8), byte;
> +
> +	ptr += (n / 8);
> +	byte = *ptr;
> +	if (set)
> +		byte |=  mask;
> +	else
> +		byte &= ~mask;
> +	*ptr = byte;
> +}
> +#endif /* __aarch64__ */
> 

