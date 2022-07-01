Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B595630B2
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 11:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbiGAJty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 05:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbiGAJtv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 05:49:51 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D9F71BE3
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 02:49:50 -0700 (PDT)
Date:   Fri, 1 Jul 2022 11:49:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656668988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=csqGZKej0tlETwO6g4He6qw0+Z9FHimuGs/jEfic504=;
        b=TFkM+oY9RwuX6X/QqmefBI+H8Dm65fX/KPq+yONV7lxJrlK4E3KOtqBIdU9uHd3jmY58mN
        v2qDHGK4XXdYzpsZroTxksvcPUfuG4yOi+elDxFKVQPQIprY9uNhFpifyIiP4FgwWLHzca
        d7VRXsG3YVbmPk1LpppWkSwNaxKoe4k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: Re: [kvm-unit-tests PATCH v3 04/27] lib: Add support for the XSDT
 ACPI table
Message-ID: <20220701094947.yte4r6hvlgojgg4q@kamzik>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <20220630100324.3153655-5-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630100324.3153655-5-nikos.nikoleris@arm.com>
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

On Thu, Jun 30, 2022 at 11:03:01AM +0100, Nikos Nikoleris wrote:
> XSDT provides pointers to other ACPI tables much like RSDT. However,
> contrary to RSDT that provides 32-bit addresses, XSDT provides 64-bit
> pointers. ACPI requires that if XSDT is valid then it takes precedence
> over RSDT.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/acpi.h |  6 ++++++
>  lib/acpi.c | 37 +++++++++++++++++++++++++++++++------
>  2 files changed, 37 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/acpi.h b/lib/acpi.h
> index b853a55..c5f0aa5 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -14,6 +14,7 @@
>  
>  #define RSDP_SIGNATURE ACPI_SIGNATURE('R','S','D','P')
>  #define RSDT_SIGNATURE ACPI_SIGNATURE('R','S','D','T')
> +#define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
>  #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
>  #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
>  
> @@ -57,6 +58,11 @@ struct rsdt_descriptor_rev1 {
>  	u32 table_offset_entry[1];
>  };
>  
> +struct acpi_table_xsdt {
> +	ACPI_TABLE_HEADER_DEF
> +	u64 table_offset_entry[1];
> +};
> +
>  struct fadt_descriptor_rev1
>  {
>  	ACPI_TABLE_HEADER_DEF	/* ACPI common table header */
> diff --git a/lib/acpi.c b/lib/acpi.c
> index b7fd923..240a922 100644
> --- a/lib/acpi.c
> +++ b/lib/acpi.c
> @@ -40,6 +40,7 @@ void *find_acpi_table_addr(u32 sig)
>  {
>  	struct rsdp_descriptor *rsdp;
>  	struct rsdt_descriptor_rev1 *rsdt;
> +	struct acpi_table_xsdt *xsdt = NULL;
>  	void *end;
>  	int i;
>  
> @@ -64,17 +65,41 @@ void *find_acpi_table_addr(u32 sig)
>  
>  	rsdt = (void *)(ulong)rsdp->rsdt_physical_address;
>  	if (!rsdt || rsdt->signature != RSDT_SIGNATURE)
> -		return NULL;
> +		rsdt = NULL;

Now that we set rsdt to NULL in the body of this if, the
condition may look a bit better as

  (rsdt && rsdt->signature != RSDT_SIGNATURE)

>  
>  	if (sig == RSDT_SIGNATURE)
>  		return rsdt;
>  
> -	end = (void *)rsdt + rsdt->length;
> -	for (i = 0; (void *)&rsdt->table_offset_entry[i] < end; i++) {
> -		struct acpi_table *t = (void *)(ulong)rsdt->table_offset_entry[i];
> -		if (t && t->signature == sig) {
> -			return t;
> +	/*
> +	 * When the system implements APCI 2.0 and above and XSDT is
> +	 * valid we have use XSDT to find other ACPI tables,
                        ^ to

> +	 * otherwise, we use RSDT.
> +	 */
> +	if (rsdp->revision == 2)
> +		xsdt = (void *)(ulong)rsdp->xsdt_physical_address;

The (ulong) cast shouldn't be necessary

maybe add a blank line here

> +	if (!xsdt || xsdt->signature != XSDT_SIGNATURE)

Same comment as above

> +		xsdt = NULL;
> +
> +	if (sig == XSDT_SIGNATURE)
> +		return xsdt;
> +
> +	if (xsdt) {
> +		end = (void *)(ulong)xsdt + xsdt->length;

The (ulong) cast shouldn't be necessary.

> +		for (i = 0; (void *)&xsdt->table_offset_entry[i] < end; i++) {
> +			struct acpi_table *t = (void *)xsdt->table_offset_entry[i];
> +
> +			if (t && t->signature == sig)
> +				return t;
> +		}
> +	} else if (rsdt) {
> +		end = (void *)rsdt + rsdt->length;
> +		for (i = 0; (void *)&rsdt->table_offset_entry[i] < end; i++) {
> +			struct acpi_table *t = (void *)(ulong)rsdt->table_offset_entry[i];
> +
> +			if (t && t->signature == sig)
> +				return t;
>  		}
>  	}
> +
>  	return NULL;
>  }
> -- 
> 2.25.1
>

Besides the nits

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks,
drew
