Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4446155769
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 13:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgBGMLS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 07:11:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55494 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726674AbgBGMLS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 07:11:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581077476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ha8p3Y8w7TUoTeJEAe0zMDx8bCokWL2pCDEb/sxa6Jc=;
        b=cv6KPEglXafHd/E/7d37iV/XRGT3aV4KSMFByfV5NPgm3L1Q+vDU/mIFq2EaS5YvUem9ju
        SZrAZofoTmxFnjOFkCdiVgSZ1mUvItTs5Sdnr2w1PFq4L+CDdjx/QAND+rn75s3UUBNkHS
        ArgC/glMpe2jFHVuhyhZBx4AXtSiFqs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-On0-zrUEOAaqMZfS-Bg4EA-1; Fri, 07 Feb 2020 07:11:12 -0500
X-MC-Unique: On0-zrUEOAaqMZfS-Bg4EA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 90DF71081FA0;
        Fri,  7 Feb 2020 12:11:10 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 057DE790D8;
        Fri,  7 Feb 2020 12:11:05 +0000 (UTC)
Date:   Fri, 7 Feb 2020 13:11:03 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        peter.maydell@linaro.org, andre.przywara@arm.com, thuth@redhat.com,
        yuzenghui@huawei.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 06/14] arm/arm64: gicv3: Set the LPI
 config and pending tables
Message-ID: <20200207121103.p3vry5cucdaikj6x@kamzik.brq.redhat.com>
References: <20200128103459.19413-1-eric.auger@redhat.com>
 <20200128103459.19413-7-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128103459.19413-7-eric.auger@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 28, 2020 at 11:34:51AM +0100, Eric Auger wrote:
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
> v2 -> v3:
> - Move the helpers in lib/arm/gic-v3.c and prefix them with "gicv3_"
>   and add _lpi prefix too
> 
> v1 -> v2:
> - remove memory attributes
> ---
>  lib/arm/asm/gic-v3.h | 16 +++++++++++
>  lib/arm/gic-v3.c     | 64 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 80 insertions(+)
> 
> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> index ffb2e26..ec2a6f0 100644
> --- a/lib/arm/asm/gic-v3.h
> +++ b/lib/arm/asm/gic-v3.h
> @@ -48,6 +48,16 @@
>  #define MPIDR_TO_SGI_AFFINITY(cluster_id, level) \
>  	(MPIDR_AFFINITY_LEVEL(cluster_id, level) << ICC_SGI1R_AFFINITY_## level ## _SHIFT)
>  
> +#define GICR_PROPBASER_IDBITS_MASK                      (0x1f)
> +
> +#define GICR_PENDBASER_PTZ                              BIT_ULL(62)

Strange indent here, too far and not tabs

> +
> +#define LPI_PROP_GROUP1		(1 << 1)
> +#define LPI_PROP_ENABLED	(1 << 0)
> +#define LPI_PROP_DEFAULT_PRIO   0xa0
> +#define LPI_PROP_DEFAULT	(LPI_PROP_DEFAULT_PRIO | LPI_PROP_GROUP1 | \
> +				 LPI_PROP_ENABLED)
> +
>  #include <asm/arch_gicv3.h>
>  
>  #ifndef __ASSEMBLY__
> @@ -64,6 +74,8 @@ struct gicv3_data {
>  	void *dist_base;
>  	void *redist_bases[GICV3_NR_REDISTS];
>  	void *redist_base[NR_CPUS];
> +	void *lpi_prop;
> +	void *lpi_pend[NR_CPUS];
>  	unsigned int irq_nr;
>  };
>  extern struct gicv3_data gicv3_data;
> @@ -80,6 +92,10 @@ extern void gicv3_write_eoir(u32 irqstat);
>  extern void gicv3_ipi_send_single(int irq, int cpu);
>  extern void gicv3_ipi_send_mask(int irq, const cpumask_t *dest);
>  extern void gicv3_set_redist_base(size_t stride);
> +extern void gicv3_lpi_set_config(int n, u8 val);
> +extern u8 gicv3_lpi_get_config(int n);
> +extern void gicv3_lpi_set_pending_table_bit(int rdist, int n, bool set);
> +extern void gicv3_lpi_alloc_tables(void);
>  
>  static inline void gicv3_do_wait_for_rwp(void *base)
>  {
> diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
> index feecb5e..c33f883 100644
> --- a/lib/arm/gic-v3.c
> +++ b/lib/arm/gic-v3.c
> @@ -5,6 +5,7 @@
>   */
>  #include <asm/gic.h>
>  #include <asm/io.h>
> +#include <alloc_page.h>
>  
>  void gicv3_set_redist_base(size_t stride)
>  {
> @@ -147,3 +148,66 @@ void gicv3_ipi_send_single(int irq, int cpu)
>  	cpumask_set_cpu(cpu, &dest);
>  	gicv3_ipi_send_mask(irq, &dest);
>  }
> +
> +#if defined(__aarch64__)
> +/* alloc_lpi_tables: Allocate LPI config and pending tables */
> +void gicv3_lpi_alloc_tables(void)
> +{
> +	unsigned long n = SZ_64K >> PAGE_SHIFT;
> +	unsigned long order = fls(n);
> +	u64 prop_val;
> +	int cpu;
> +
> +	gicv3_data.lpi_prop = (void *)virt_to_phys(alloc_pages(order));
> +
> +	/* ID bits = 13, ie. up to 14b LPI INTID */
> +	prop_val = (u64)gicv3_data.lpi_prop | 13;
> +
> +	/*
> +	 * Allocate pending tables for each redistributor
> +	 * and set PROPBASER and PENDBASER
> +	 */
> +	for_each_present_cpu(cpu) {
> +		u64 pend_val;
> +		void *ptr;
> +
> +		ptr = gicv3_data.redist_base[cpu];
> +
> +		writeq(prop_val, ptr + GICR_PROPBASER);
> +
> +		gicv3_data.lpi_pend[cpu] = (void *)virt_to_phys(alloc_pages(order));
> +
> +		pend_val = (u64)gicv3_data.lpi_pend[cpu];
> +
> +		writeq(pend_val, ptr + GICR_PENDBASER);

nit: probably don't need all the blank lines

> +	}
> +}
> +
> +void gicv3_lpi_set_config(int n, u8 value)
> +{
> +	u8 *entry = (u8 *)(gicv3_data.lpi_prop + (n - 8192));
> +
> +	*entry = value;
> +}
> +
> +u8 gicv3_lpi_get_config(int n)
> +{
> +	u8 *entry = (u8 *)(gicv3_data.lpi_prop + (n - 8192));
> +
> +	return *entry;
> +}

We probably need a define for the 8192. LPI_ID_BASE? And, like PPI and SPI
maybe we need an LPI(id)? '#define LPI(id) ((id) + LPI_ID_BASE)'?

Also, is lpi_prop an array of u8's? If so, then I'd think we could
declare it as a u8 * in gicv3_data. Then, instead of the above two
functions just do something like

 #define gicv3_lpi_set_config(n, val) ({
     gicv3_data.lpi_prop[n] = (val);
 })
 #define gicv3_lpi_get_config(n) (gicv3_data.lpi_prop[n])

> +
> +void gicv3_lpi_set_pending_table_bit(int rdist, int n, bool set)

These types of functions that can be used both as a setter and clearer
usually have a name like foo_set_clr_bar(). That would make this long
name a bit longer, but do we need the '_table_bit' part of the name?

> +{
> +	u8 *ptr = phys_to_virt((phys_addr_t)gicv3_data.lpi_pend[rdist]);

If lpi_pend is a physical address then why not declare it like that
in gicv3_data, i.e. phys_addr_t lpi_pend[NR_CPUS] ?

> +	u8 mask = 1 << (n % 8), byte;
> +
> +	ptr += (n / 8);
> +	byte = *ptr;

And Zenghui already pointed out that this doesn't look right for
a physical address.

> +	if (set)
> +		byte |=  mask;
> +	else
> +		byte &= ~mask;
> +	*ptr = byte;
> +}
> +#endif /* __aarch64__ */
> -- 
> 2.20.1
> 
>

Thanks,
drew

