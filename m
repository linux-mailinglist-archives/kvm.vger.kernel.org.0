Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3681E6F3139
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 14:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbjEAMvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 08:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbjEAMvh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 08:51:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F413D10F7
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 05:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682945446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hmWKjTfPWozKNY5pZlEsns0HcCjw26XANhiIewwyQFg=;
        b=KfGJXqfQTTE5o4nNwMJeWmQoEJVoCMHFIKsF+yCYKe8CdWaNn8FIJdMimFVfATFPNLQOj3
        YQvinoTx1FY41rCzeXmcenlm5rrkrT4R6hdLpAe+vWQEWmaNgNuvIKQuB81GcHujtaBra+
        qBczavGwXSR717qFNXayA0t5FZdIi6w=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161-kRrRLVAZN5q_GkEbUF65AA-1; Mon, 01 May 2023 08:50:41 -0400
X-MC-Unique: kRrRLVAZN5q_GkEbUF65AA-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-63c8d6ba628so597770b3a.1
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 05:50:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682945441; x=1685537441;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hmWKjTfPWozKNY5pZlEsns0HcCjw26XANhiIewwyQFg=;
        b=IPzSjr0/52YE2arIlsXPNgD22OFXRd6GI/jKJtnJnfJPEgAaZwSK+MNnROb8eXh/S8
         AygE1FAddq8usDUH45kcrj/LntHT1Zng03Y+TDPWHKVdEvogB91fGO1Sjc4iAe3KkYdW
         wvsHDtZEZu3TNrSGBHoX68e47euPEal/yBjzVDMpPsyrLAsZDuYPq9k5UL1xXTW+CEk0
         zyZP13OteQI+uFofas+aGEPWxt+zXruAO8uom0ZX9PuGi+9z1SL9vnOK+Ztqo71BkkgC
         e2PpL7kXeHhXN3FDpdec0ncpcrfvepPnFQEu3nqaRBdaHId1361V8UVvtlgbXQK/aTqk
         sH4g==
X-Gm-Message-State: AC+VfDyApdQDcFw9ms5MsFuD5Ws06xrf55SsCgcckGmQchEqd1BvCaku
        Jfq8gD3FV8NJcfYgNPU6VOMhXl7vd1x/Td62zb1nWw9E7vFt6sQogvFbzFAt6luROMd06263ee7
        NSZUfxsfRZ9NY
X-Received: by 2002:a05:6a00:1391:b0:635:4f6:2f38 with SMTP id t17-20020a056a00139100b0063504f62f38mr13612620pfg.2.1682945440804;
        Mon, 01 May 2023 05:50:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6N+vED0Om8+7La0+7ffuM42KXD2f9atEzLTGfkptdleRUX13rQMQJnmeVIx5GtEqhGFFxQsQ==
X-Received: by 2002:a05:6a00:1391:b0:635:4f6:2f38 with SMTP id t17-20020a056a00139100b0063504f62f38mr13612606pfg.2.1682945440563;
        Mon, 01 May 2023 05:50:40 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x3-20020a628603000000b0063d666566d1sm19825093pfd.72.2023.05.01.05.50.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 05:50:40 -0700 (PDT)
Message-ID: <b3f7fd03-b5c3-41f3-149c-ac26a59ce9fe@redhat.com>
Date:   Mon, 1 May 2023 20:50:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v5 08/29] lib/acpi: Add support for the
 XSDT table
Content-Language: en-US
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230428120405.3770496-9-nikos.nikoleris@arm.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230428120405.3770496-9-nikos.nikoleris@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/28/23 20:03, Nikos Nikoleris wrote:
> XSDT provides pointers to other ACPI tables much like RSDT. However,
> contrary to RSDT that provides 32-bit addresses, XSDT provides 64-bit
> pointers. ACPI requires that if XSDT is valid then it takes precedence
> over RSDT.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> [ Alex E: Use flexible array member for XSDT struct ]
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   lib/acpi.h |  6 ++++++
>   lib/acpi.c | 40 ++++++++++++++++++++++++++++++++--------
>   2 files changed, 38 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/acpi.h b/lib/acpi.h
> index 53e41c4b..74ba00ac 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -14,6 +14,7 @@
>   
>   #define RSDP_SIGNATURE ACPI_SIGNATURE('R','S','D','P')
>   #define RSDT_SIGNATURE ACPI_SIGNATURE('R','S','D','T')
> +#define XSDT_SIGNATURE ACPI_SIGNATURE('X','S','D','T')
>   #define FACP_SIGNATURE ACPI_SIGNATURE('F','A','C','P')
>   #define FACS_SIGNATURE ACPI_SIGNATURE('F','A','C','S')
>   
> @@ -56,6 +57,11 @@ struct acpi_table_rsdt_rev1 {
>   	u32 table_offset_entry[];
>   };
>   
> +struct acpi_table_xsdt {
> +	ACPI_TABLE_HEADER_DEF
> +	u64 table_offset_entry[];
> +};
> +
>   struct acpi_table_fadt_rev1 {
>   	ACPI_TABLE_HEADER_DEF	/* ACPI common table header */
>   	u32 firmware_ctrl;	/* Physical address of FACS */
> diff --git a/lib/acpi.c b/lib/acpi.c
> index 166ffd14..d35f09a6 100644
> --- a/lib/acpi.c
> +++ b/lib/acpi.c
> @@ -37,7 +37,8 @@ static struct acpi_table_rsdp *get_rsdp(void)
>   
>   void *find_acpi_table_addr(u32 sig)
>   {
> -	struct acpi_table_rsdt_rev1 *rsdt;
> +	struct acpi_table_rsdt_rev1 *rsdt = NULL;
> +	struct acpi_table_xsdt *xsdt = NULL;
>   	struct acpi_table_rsdp *rsdp;
>   	void *end;
>   	int i;
> @@ -62,18 +63,41 @@ void *find_acpi_table_addr(u32 sig)
>   		return rsdp;
>   
>   	rsdt = (void *)(ulong) rsdp->rsdt_physical_address;
> -	if (!rsdt || rsdt->signature != RSDT_SIGNATURE)
> -		return NULL;
> +	if (rsdt && rsdt->signature != RSDT_SIGNATURE)
> +		rsdt = NULL;
>   
>   	if (sig == RSDT_SIGNATURE)
>   		return rsdt;
>   
> -	end = (void *)rsdt + rsdt->length;
> -	for (i = 0; (void *)&rsdt->table_offset_entry[i] < end; i++) {
> -		struct acpi_table *t = (void *)(ulong) rsdt->table_offset_entry[i];
> +	if (rsdp->revision >= 2) {
> +		xsdt = (void *)rsdp->xsdt_physical_address;
> +		if (xsdt && xsdt->signature != XSDT_SIGNATURE)
> +			xsdt = NULL;
> +	}
>   
> -		if (t && t->signature == sig)
> -			return t;
> +	if (sig == XSDT_SIGNATURE)
> +		return xsdt;
> +
> +	/*
> +	 * When the system implements APCI 2.0 and above and XSDT is valid we
> +	 * have use XSDT to find other ACPI tables, otherwise, we use RSDT.
> +	 */
> +	if (xsdt) {
> +		end = (void *)xsdt + xsdt->length;
> +		for (i = 0; (void *)&xsdt->table_offset_entry[i] < end; i++) {
> +			struct acpi_table *t = (void *)(ulong) xsdt->table_offset_entry[i];
> +
> +			if (t && t->signature == sig)
> +				return t;
> +		}
> +	} else if (rsdt) {
> +		end = (void *)rsdt + rsdt->length;
> +		for (i = 0; (void *)&rsdt->table_offset_entry[i] < end; i++) {
> +			struct acpi_table *t = (void *)(ulong) rsdt->table_offset_entry[i];
> +
> +			if (t && t->signature == sig)
> +				return t;
> +		}
>   	}
>   
>   	return NULL;

-- 
Shaoqin

