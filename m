Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE9F5630C3
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 11:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbiGAJza (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 05:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234375AbiGAJz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 05:55:26 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD4D74DC2
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 02:55:25 -0700 (PDT)
Date:   Fri, 1 Jul 2022 11:55:22 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656669323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xqPE4qFeVGQ7qPo+ZSGe9rl8Uk9lAowSEUhTq/yu+4E=;
        b=snfipCAfON16Pl76v8mT/sjwEPcxy/wW/qBn7uUD1km9AjRxOwgsJamfQtOeivPEcWtHcF
        xtTJW441o7JFyx/DI7OxOE61BEcSRXpnYjpdh/zBgPaKo9xc2h+WQeXj1LTPclUyvFFdBW
        zhMlqEa8CBwTDCLkUMIQNBCr8Xg1Hxs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: Re: [kvm-unit-tests PATCH v3 06/27] devicetree: Check if fdt is NULL
 before returning that a DT is available
Message-ID: <20220701095522.v2he6eu2267f737s@kamzik>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <20220630100324.3153655-7-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630100324.3153655-7-nikos.nikoleris@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Nikos,

nit: The summary is a bit long. We could probably drop the "before..."
part.

On Thu, Jun 30, 2022 at 11:03:03AM +0100, Nikos Nikoleris wrote:
> Up until now, for platfroms that support DT, KUT would unconditionally
> use DT to configure the system and the code made the assumption that
> the fdt will always be a valid pointer.
> 
> In Arm systems that support both ACPI and DT, we plat to follow the

s/plat/plan/

> same convension as the Linux kernel. First, we attempt to configure
> the system using the DT. If an FDT was not provided then we attempt to
> configure the system using ACPI.
> 
> As a result, for Arm systems with support for ACPI the fdt pointer can
> be NULL. This change modifies dt_available() to check if the fdt is a
> valid pointer and return if we can use information from the DT.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/devicetree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/devicetree.c b/lib/devicetree.c
> index 78c1f6f..3ff9d16 100644
> --- a/lib/devicetree.c
> +++ b/lib/devicetree.c
> @@ -16,7 +16,7 @@ const void *dt_fdt(void)
>  
>  bool dt_available(void)
>  {
> -	return fdt_check_header(fdt) == 0;
> +	return fdt && fdt_check_header(fdt) == 0;
>  }
>  
>  int dt_get_nr_cells(int fdtnode, u32 *nr_address_cells, u32 *nr_size_cells)
> -- 
> 2.25.1
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew
