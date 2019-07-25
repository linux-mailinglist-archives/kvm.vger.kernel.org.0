Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B09474F41
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 15:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbfGYNZL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 09:25:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19865 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726653AbfGYNZL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 09:25:11 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AFFF730805C4;
        Thu, 25 Jul 2019 13:25:10 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1AFDB60BEC;
        Thu, 25 Jul 2019 13:25:08 +0000 (UTC)
Date:   Thu, 25 Jul 2019 15:25:06 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <marc.zyngier@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvm-unit-tests v4] arm: Add PL031 test
Message-ID: <20190725132506.2m4gkrsfcl422ztz@kamzik.brq.redhat.com>
References: <20190725130949.27436-1-graf@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725130949.27436-1-graf@amazon.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 25 Jul 2019 13:25:10 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 25, 2019 at 03:09:49PM +0200, Alexander Graf wrote:
> This patch adds a unit test for the PL031 RTC that is used in the virt machine.
> It just pokes basic functionality. I've mostly written it to familiarize myself
> with the device, but I suppose having the test around does not hurt, as it also
> exercises the GIC SPI interrupt path.
> 
> Signed-off-by: Alexander Graf <graf@amazon.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> 
> ---
> 
> v1 -> v2:
> 
>   - Use FDT to find base, irq and existence
>   - Put isb after timer read
>   - Use dist_base for gicv3
> 
> v2 -> v3
> 
>   - Enable compilation on 32bit ARM target
>   - Use ioremap
> 
> v3 -> v4:
> 
>   - Use dt_pbus_translate_node()
>   - Make irq_triggered volatile
> ---
>  arm/Makefile.common |   1 +
>  arm/pl031.c         | 260 ++++++++++++++++++++++++++++++++++++++++++++
>  lib/arm/asm/gic.h   |   1 +
>  3 files changed, 262 insertions(+)
>  create mode 100644 arm/pl031.c

Thanks for the new version. I have a new nit (below), but my r-b stands
with or without making another change.

[...]

> +static int rtc_fdt_init(void)
> +{
> +	const struct fdt_property *prop;
> +	const void *fdt = dt_fdt();
> +	struct dt_pbus_reg base;
> +	int node, len;
> +	u32 *data;
> +
> +	node = fdt_node_offset_by_compatible(fdt, -1, "arm,pl031");
> +	if (node < 0)
> +		return -1;
> +
> +	prop = fdt_get_property(fdt, node, "interrupts", &len);
> +	assert(prop && len == (3 * sizeof(u32)));
> +	data = (u32 *)prop->data;
> +	assert(data[0] == 0); /* SPI */
> +	pl031_irq = SPI(fdt32_to_cpu(data[1]));
> +
> +	assert(!dt_pbus_translate_node(node, 0, &base));

We prefer to do something like

 ret = dt_pbus_translate_node(node, 0, &base);
 assert(!ret);

than the above, just in case we ever compiled with assert() defined as a
no-op. But the probability of doing that is pretty close to zero.

> +	pl031 = ioremap(base.addr, base.size);
> +
> +	return 0;
> +}

Thanks,
drew
