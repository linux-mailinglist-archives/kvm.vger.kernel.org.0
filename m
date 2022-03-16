Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC334DB50F
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 16:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353704AbiCPPkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 11:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352451AbiCPPkq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 11:40:46 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 336703204B
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 08:39:32 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB82C1476;
        Wed, 16 Mar 2022 08:39:31 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1A1B3F7D7;
        Wed, 16 Mar 2022 08:39:30 -0700 (PDT)
Date:   Wed, 16 Mar 2022 15:39:55 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Martin Radev <martin.b.radev@gmail.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, andre.przywara@arm.com
Subject: Re: [PATCH kvmtool 5/5] mmio: Sanitize addr and len
Message-ID: <YjIEyxwAPw2c2fdM@monolith.localdoman>
References: <20220303231050.2146621-1-martin.b.radev@gmail.com>
 <20220303231050.2146621-6-martin.b.radev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303231050.2146621-6-martin.b.radev@gmail.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Fri, Mar 04, 2022 at 01:10:50AM +0200, Martin Radev wrote:
> This patch verifies that adding the addr and length arguments
> from an MMIO op do not overflow. This is necessary because the
> arguments are controlled by the VM. The length may be set to
> an arbitrary value by using the rep prefix.
> 
> Signed-off-by: Martin Radev <martin.b.radev@gmail.com>

The patch looks correct to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

> ---
>  mmio.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mmio.c b/mmio.c
> index a6dd3aa..5a114e9 100644
> --- a/mmio.c
> +++ b/mmio.c
> @@ -32,6 +32,10 @@ static struct mmio_mapping *mmio_search(struct rb_root *root, u64 addr, u64 len)
>  {
>  	struct rb_int_node *node;
>  
> +	/* If len is zero or if there's an overflow, the MMIO op is invalid. */
> +	if (addr + len <= addr)
> +		return NULL;
> +
>  	node = rb_int_search_range(root, addr, addr + len);
>  	if (node == NULL)
>  		return NULL;
> -- 
> 2.25.1
> 
