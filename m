Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBA862E500
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 20:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240006AbiKQTK5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 14:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239817AbiKQTKw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 14:10:52 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2301A7EC99;
        Thu, 17 Nov 2022 11:10:50 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1668712247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tjrXRruokzGgz/ctSWFL+NrKW2mSry1KiPurqWuWjbw=;
        b=KMSmtIAleWNtBdFxTUcXaMFRMKiNeD1hOgnvtm06B3BaPAi/j4w3UXgkmcM2wv3FSHdws0
        6U+okwIb3G1Ij9S9coJixNtA0pjd7Vj6CGCyfVkF5jiHTRs1kI1Y9cSvLr1fN8/Qnm52zQ
        Qf5vb9xwZnOKHepuDqNfuo091n4a42pmIyJYnIMVGay6DfmBR8ryAq6c2CWk+yaxZNYr2w
        oNqj2gXyzIwe7bwQ4i2A5KOD5g6LD9+7zRsrzL+4zIR2aHfvh3ezUq3PktfmeB9+ZT1FcY
        cCJS4pRJHuts0p1EwJL2UlBUGoryIIvkuB8QkPKLtNEMaOKZFY9EbpbFdSe4nA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1668712247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tjrXRruokzGgz/ctSWFL+NrKW2mSry1KiPurqWuWjbw=;
        b=azUiBcLzwWUHzJmpxY62eu72/tmadiSpzhidNR9/4S05J10g9dHmXwmkSq3LFZ4qhEBbtm
        DpflEOCjQHao1tCw==
To:     Nipun Gupta <nipun.gupta@amd.com>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, eric.auger@redhat.com,
        alex.williamson@redhat.com, cohuck@redhat.com,
        puneet.gupta@amd.com, song.bao.hua@hisilicon.com,
        mchehab+huawei@kernel.org, maz@kernel.org, f.fainelli@gmail.com,
        jeffrey.l.hugo@gmail.com, saravanak@google.com,
        Michael.Srba@seznam.cz, mani@kernel.org, yishaih@nvidia.com,
        jgg@ziepe.ca, jgg@nvidia.com, robin.murphy@arm.com,
        will@kernel.org, joro@8bytes.org, masahiroy@kernel.org,
        ndesaulniers@google.com, linux-arm-kernel@lists.infradead.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kvm@vger.kernel.org
Cc:     okaya@kernel.org, harpreet.anand@amd.com, nikhil.agarwal@amd.com,
        michal.simek@amd.com, aleksandar.radovanovic@amd.com, git@amd.com,
        Nipun Gupta <nipun.gupta@amd.com>
Subject: Re: [RFC PATCH v4 7/8] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
In-Reply-To: <20221014044049.2557085-8-nipun.gupta@amd.com>
References: <20220803122655.100254-1-nipun.gupta@amd.com>
 <20221014044049.2557085-1-nipun.gupta@amd.com>
 <20221014044049.2557085-8-nipun.gupta@amd.com>
Date:   Thu, 17 Nov 2022 20:10:46 +0100
Message-ID: <87r0y1l7m1.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 14 2022 at 10:10, Nipun Gupta wrote:
> Since CDX devices are not linked to of node they need a
> separate MSI domain for handling device ID to be provided to
> the GIC ITS domain.
>
> This also introduces APIs to alloc and free IRQs for CDX domain.

This is not really much of an explanation.

> +#include "cdx.h"
> +
> +#define REQ_ID_SHIFT	10
> +
> +/*
> + * Convert an msi_desc to a globaly unique identifier (per-device
> + * reqid + msi_desc position in the msi_list).
> + */
> +static irq_hw_number_t cdx_domain_calc_hwirq(struct cdx_device *dev,
> +					     struct msi_desc *desc)
> +{
> +	return (dev->req_id << REQ_ID_SHIFT) | desc->msi_index;
> +}
> +
> +static void cdx_msi_set_desc(msi_alloc_info_t *arg,
> +			     struct msi_desc *desc)
> +{
> +	arg->desc = desc;
> +	arg->hwirq = cdx_domain_calc_hwirq(to_cdx_device(desc->dev), desc);
> +}
> +
> +static void cdx_msi_write_msg(struct irq_data *irq_data,
> +			      struct msi_msg *msg)
> +{
> +	struct msi_desc *msi_desc = irq_data_get_msi_desc(irq_data);
> +	struct cdx_device *cdx_dev = to_cdx_device(msi_desc->dev);
> +	struct cdx_controller_t *cdx = cdx_dev->cdx;
> +	uint64_t addr;
> +	int ret;
> +
> +	addr = ((uint64_t)(msi_desc->msg.address_hi) << 32) |
> +	       msi_desc->msg.address_lo;
> +
> +	ret = cdx->ops.write_msi(cdx, cdx_dev->bus_num, cdx_dev->dev_num,
> +				 msi_desc->msi_index, msi_desc->msg.data,
> +				 addr);
> +	if (ret)
> +		dev_err(&cdx_dev->dev, "Write MSI failed to CDX controller\n");
> +}

So this is yet another variant of platform-MSI which is about to be
kicked from the planet.

Please check:

     https://lore.kernel.org/r/20221111131813.914374272@linutronix.de
     https://lore.kernel.org/r/20221111133158.196269823@linutronix.de

and the ARM/GIC conversion in:

     https://git.kernel.org/pub/scm/linux/kernel/git/tglx/devel.git/log/?h=devmsi-arm

The latter is WIP, but functional.

I'm sure you replace your yet another magic MSI domain which only
provides a device specific MSI write function with the new
infrastructure trivially.

Thanks,

        tglx


