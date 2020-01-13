Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81CA41397B8
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 18:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgAMRba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 12:31:30 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53118 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727726AbgAMRba (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Jan 2020 12:31:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578936688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GEBUDqgM3gGBMdV6rvvSSOuZuUWDxugabavxa54G2Vg=;
        b=NGegURhWWn0YD9lif458ntfbu3ZcyeOFy8exy7jaxapiwg8POa6uoi5z/ds/1tzz8ZQIGM
        1hVZbkFQ9wY2KrgR+eNOk5CbIn+Vtx0MBKA6//vNlwniWx5JGmytuNieyn6hxYwCwlpMm6
        i1pI5n8z9G3qDI6BRdyKZDFpwoEYbhI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-1XCR-LcoPaekVf8yIqT8Lw-1; Mon, 13 Jan 2020 12:31:24 -0500
X-MC-Unique: 1XCR-LcoPaekVf8yIqT8Lw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 520648024CC;
        Mon, 13 Jan 2020 17:31:21 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0332C10841ED;
        Mon, 13 Jan 2020 17:31:16 +0000 (UTC)
Date:   Mon, 13 Jan 2020 18:31:14 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com,
        peter.maydell@linaro.org, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 07/16] arm/arm64: ITS: Set the LPI
 config and pending tables
Message-ID: <20200113173114.4cjfqebzrfb7iepg@kamzik.brq.redhat.com>
References: <20200110145412.14937-1-eric.auger@redhat.com>
 <20200110145412.14937-8-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110145412.14937-8-eric.auger@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 10, 2020 at 03:54:03PM +0100, Eric Auger wrote:
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
> v1 -> v2:
> - remove memory attributes
> ---
>  lib/arm/asm/gic-v3-its.h |  3 ++
>  lib/arm/asm/gic-v3.h     | 12 ++++++++
>  lib/arm/gic-v3-its.c     | 60 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 75 insertions(+)
> 
> diff --git a/lib/arm/asm/gic-v3-its.h b/lib/arm/asm/gic-v3-its.h
> index 5a4dfe9..2f8b8f1 100644
> --- a/lib/arm/asm/gic-v3-its.h
> +++ b/lib/arm/asm/gic-v3-its.h
> @@ -90,6 +90,9 @@ extern void its_init(void);
>  extern int its_parse_baser(int i, struct its_baser *baser);
>  extern void its_setup_baser(int i, struct its_baser *baser);
>  extern struct its_baser *its_lookup_baser(int type);
> +extern void set_lpi_config(int n, u8 val);
> +extern u8 get_lpi_config(int n);
> +extern void set_pending_table_bit(int rdist, int n, bool set);

Please prefix with 'its' or at least swap the 'lpi' and verb. E.g.
lpi_set_config, its_set_pending_table_bit.


>  
>  #endif /* !__ASSEMBLY__ */
>  #endif /* _ASMARM_GIC_V3_ITS_H_ */
> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> index ffb2e26..90a7304 100644
> --- a/lib/arm/asm/gic-v3.h
> +++ b/lib/arm/asm/gic-v3.h
> @@ -48,6 +48,16 @@
>  #define MPIDR_TO_SGI_AFFINITY(cluster_id, level) \
>  	(MPIDR_AFFINITY_LEVEL(cluster_id, level) << ICC_SGI1R_AFFINITY_## level ## _SHIFT)
>  
> +#define GICR_PROPBASER_IDBITS_MASK                      (0x1f)
> +
> +#define GICR_PENDBASER_PTZ                              BIT_ULL(62)
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
> diff --git a/lib/arm/gic-v3-its.c b/lib/arm/gic-v3-its.c
> index 79946c3..6c97569 100644
> --- a/lib/arm/gic-v3-its.c
> +++ b/lib/arm/gic-v3-its.c
> @@ -117,3 +117,63 @@ void its_setup_baser(int i, struct its_baser *baser)
>  	writeq(val, gicv3_its_base() + GITS_BASER + i * 8);
>  }
>  
> +inline void set_lpi_config(int n, u8 value)
> +{
> +	u8 *entry = (u8 *)(gicv3_data.lpi_prop + (n - 8192));
> +	*entry = value;
> +}
> +
> +inline u8 get_lpi_config(int n)
> +{
> +	u8 *entry = (u8 *)(gicv3_data.lpi_prop + (n - 8192));
> +	return *entry;
> +}

Probably don't need the 'inline', but ok.

> +
> +/* alloc_lpi_tables: Allocate LPI config and pending tables */
> +void alloc_lpi_tables(void);
> +void alloc_lpi_tables(void)

Why not add this to the header (renamed to lpi_alloc_tables)? Or should
this function be static?

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
> +		gicv3_data.lpi_pend[cpu] =
> +			(void *)virt_to_phys(alloc_pages(order));

nit: I think these line brakes on = or worse than going over 80 chars.
And, you don't need to worry about 80 chars anyway. See the README, we
allow 120.

> +
> +		pend_val = (u64)gicv3_data.lpi_pend[cpu];
> +
> +		writeq(pend_val, ptr + GICR_PENDBASER);
> +	}
> +}
> +
> +void set_pending_table_bit(int rdist, int n, bool set)
> +{
> +	u8 *ptr = phys_to_virt((phys_addr_t)gicv3_data.lpi_pend[rdist]);
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
> -- 
> 2.20.1
> 

Thanks,
drew

