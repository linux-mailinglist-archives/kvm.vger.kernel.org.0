Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A16A56303E
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 11:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235611AbiGAJft (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 05:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234917AbiGAJfr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 05:35:47 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7A07479B
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 02:35:46 -0700 (PDT)
Date:   Fri, 1 Jul 2022 11:35:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656668144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t+Cbc3M8TCt/tDz9gw9vqaK3b23XPH4bNMdNK8MxsqE=;
        b=DuRqcvPEriCRQMbqdQYDXN2pRE1GFhzvF2fUnG8P82CvAv8KixJE3rctHRNS+zz65UQdq/
        ZU7QoPPmCyRcNaZYQ0ChojSaI2g0PrZSRF93e9yHKf0R1uSIxb6ZIn+lgaHTK8WNDOV3jE
        93fD+zliXVWf24wo3F/94PLrD09tArQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: Re: [kvm-unit-tests PATCH v3 03/27] lib: Ensure all struct
 definition for ACPI tables are packed
Message-ID: <20220701093542.cexwhs3ypb6rrfzz@kamzik>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <20220630100324.3153655-4-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630100324.3153655-4-nikos.nikoleris@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 30, 2022 at 11:03:00AM +0100, Nikos Nikoleris wrote:
> All ACPI table definitions are provided with precise definitions of
> field sizes and offsets, make sure that no compiler optimization can
> interfere with the memory layout of the corresponding structs.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/acpi.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/lib/acpi.h b/lib/acpi.h
> index 456e62d..b853a55 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -3,6 +3,12 @@
>  
>  #include "libcflat.h"
>  
> +/*
> + * All tables and structures must be byte-packed to match the ACPI
> + * specification, since the tables are provided by the system BIOS
> + */
> +#pragma pack(1)
> +
>  #define ACPI_SIGNATURE(c1, c2, c3, c4)				\
>  	((c1) | ((c2) << 8) | ((c3) << 16) | ((c4) << 24))
>  
> @@ -106,6 +112,8 @@ struct facs_descriptor_rev1
>  	u8  reserved3 [40];		/* Reserved - must be zero */
>  };
>  
> +#pragma pack(0)
> +
>  void set_efi_rsdp(struct rsdp_descriptor *rsdp);
>  void* find_acpi_table_addr(u32 sig);
>  
> -- 
> 2.25.1
>

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
