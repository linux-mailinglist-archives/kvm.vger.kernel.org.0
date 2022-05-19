Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F39F52D3BE
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237616AbiESNRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbiESNRw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:17:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A6ACC6E72
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652966271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=01BESG2uCPhimnx8DReFdy0DlJ4QMHpS2L9Swc0yo2k=;
        b=boDYFWb8lTL0Ny1Z8dYqXH6dSpwTphsw8woBscD/t3BD1zsIWWPRN6/i0G/Q71I8jaKhmR
        Xjjh5NCirqjNLaeUFTciCCJP7nDrrwZU6dnW5C0gupGagRc+7GAUH77ujGBokgUokp6dEb
        ayMWSg01qBqfcsidPFTuWK0WN98SNgk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-332-HQq70FNoOb-2TD1PcpF7pA-1; Thu, 19 May 2022 09:17:49 -0400
X-MC-Unique: HQq70FNoOb-2TD1PcpF7pA-1
Received: by mail-wm1-f72.google.com with SMTP id o24-20020a05600c379800b003943412e81dso1821349wmr.6
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:17:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=01BESG2uCPhimnx8DReFdy0DlJ4QMHpS2L9Swc0yo2k=;
        b=AMiZ00Ng+NNJZUYWqQh8x94T0sTHQ3LzNRSYM7UqZEfT/YwRBkXKFnd6sSBLS2Mi+p
         I4Nzu6N3GmkCnR93DTBQSlhR7i4OIOp8NtH+ZOPhmZcgAF8af5s6SJxxylAbzFfY4uVi
         TUtiSH57El8W4ej9U0gATUVtQCfUjEuqfk9fywu2W9OnnZp+y1Z96II7H7ZYTypuRVri
         NVObD2tY8PyH8tJ0t2SlGTPssTd+C1W2UEiluo25yr54TfoWaGTzr7Q4aHjZt1KMbbZr
         W4Hr9BLcIzwVF/jFjRAlncRvl8299w9Keg6tU4QqVPLu9DidPIclfdsXLUbcOqzpO+D5
         69Sw==
X-Gm-Message-State: AOAM531MilRSfnws0YoyjaQAH+816MjQBnXb+mO0/3fL8RmB8yGkBSQm
        9hfIZCE2Dii6K/UGKteJlWQ3bwDIT4IhSIcmUYFPjMP0nPo/DtW/NJ8/OxKpHzs/OCkly4ClT2/
        p6eHAv+KULNzr
X-Received: by 2002:a5d:4948:0:b0:20e:58f8:f4ce with SMTP id r8-20020a5d4948000000b0020e58f8f4cemr4144303wrs.229.1652966268810;
        Thu, 19 May 2022 06:17:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzea54GleR3V8gSV3Typ5KTVqofFeLNxh+4IfZYorS9h5xtqSlWrcvi9a9DdP7tSlEVd/mz5g==
X-Received: by 2002:a5d:4948:0:b0:20e:58f8:f4ce with SMTP id r8-20020a5d4948000000b0020e58f8f4cemr4144290wrs.229.1652966268599;
        Thu, 19 May 2022 06:17:48 -0700 (PDT)
Received: from gator (cst2-173-79.cust.vodafone.cz. [31.30.173.79])
        by smtp.gmail.com with ESMTPSA id n10-20020a5d6b8a000000b0020c5253d8dfsm4747514wrx.43.2022.05.19.06.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 06:17:48 -0700 (PDT)
Date:   Thu, 19 May 2022 15:17:46 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 02/23] lib: Ensure all struct
 definition for ACPI tables are packed
Message-ID: <20220519131746.cpiiq5ndfvip4asq@gator>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-3-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506205605.359830-3-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 09:55:44PM +0100, Nikos Nikoleris wrote:
> All ACPI table definitions are provided with precise definitions of
> field sizes and offsets, make sure that no compiler optimization can
> interfere with the memory layout of the corresponding structs.

That seems like a reasonable thing to do. I'm wondering why Linux doesn't
appear to do it. I see u-boot does, but not for all tables, which also
makes me scratch my head... I see this patch packs every struct except
rsdp_descriptor. Is there a reason it was left out?

Another comment below

> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/acpi.h | 11 ++++++++---
>  x86/s3.c   | 16 ++++------------
>  2 files changed, 12 insertions(+), 15 deletions(-)
> 
> diff --git a/lib/acpi.h b/lib/acpi.h
> index 1e89840..42a2c16 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -3,6 +3,11 @@
>  
>  #include "libcflat.h"
>  
> +/*
> + * All tables and structures must be byte-packed to match the ACPI
> + * specification, since the tables are provided by the system BIOS
> + */
> +
>  #define ACPI_SIGNATURE(c1, c2, c3, c4) \
>  	((c1) | ((c2) << 8) | ((c3) << 16) | ((c4) << 24))
>  
> @@ -44,12 +49,12 @@ struct rsdp_descriptor {        /* Root System Descriptor Pointer */
>  struct acpi_table {
>      ACPI_TABLE_HEADER_DEF
>      char data[0];
> -};
> +} __attribute__ ((packed));
>  
>  struct rsdt_descriptor_rev1 {
>      ACPI_TABLE_HEADER_DEF
>      u32 table_offset_entry[0];
> -};
> +} __attribute__ ((packed));
>  
>  struct fadt_descriptor_rev1
>  {
> @@ -104,7 +109,7 @@ struct facs_descriptor_rev1
>      u32 S4bios_f        : 1;    /* Indicates if S4BIOS support is present */
>      u32 reserved1       : 31;   /* Must be 0 */
>      u8  reserved3 [40];         /* Reserved - must be zero */
> -};
> +} __attribute__ ((packed));
>  
>  void set_efi_rsdp(struct rsdp_descriptor *rsdp);
>  void* find_acpi_table_addr(u32 sig);
> diff --git a/x86/s3.c b/x86/s3.c

The changes below in this file are unrelated, so they should be in a
separate patch. However, I'm also curious why they're needed. I see
that find_acpi_table_addr() can return NULL, so it doesn't seem like
we should be removing the check, but instead changing the check to
an assert.

> index 378d37a..89d69fc 100644
> --- a/x86/s3.c
> +++ b/x86/s3.c
> @@ -2,15 +2,6 @@
>  #include "acpi.h"
>  #include "asm/io.h"
>  
> -static u32* find_resume_vector_addr(void)
> -{
> -    struct facs_descriptor_rev1 *facs = find_acpi_table_addr(FACS_SIGNATURE);
> -    if (!facs)
> -        return 0;
> -    printf("FACS is at %p\n", facs);
> -    return &facs->firmware_waking_vector;
> -}
> -
>  #define RTC_SECONDS_ALARM       1
>  #define RTC_MINUTES_ALARM       3
>  #define RTC_HOURS_ALARM         5
> @@ -40,12 +31,13 @@ extern char resume_start, resume_end;
>  int main(int argc, char **argv)
>  {
>  	struct fadt_descriptor_rev1 *fadt = find_acpi_table_addr(FACP_SIGNATURE);
> -	volatile u32 *resume_vector_ptr = find_resume_vector_addr();
> +	struct facs_descriptor_rev1 *facs = find_acpi_table_addr(FACS_SIGNATURE);
>  	char *addr, *resume_vec = (void*)0x1000;
>  
> -	*resume_vector_ptr = (u32)(ulong)resume_vec;
> +	facs->firmware_waking_vector = (u32)(ulong)resume_vec;
>  
> -	printf("resume vector addr is %p\n", resume_vector_ptr);
> +	printf("FACS is at %p\n", facs);
> +	printf("resume vector addr is %p\n", &facs->firmware_waking_vector);
>  	for (addr = &resume_start; addr < &resume_end; addr++)
>  		*resume_vec++ = *addr;
>  	printf("copy resume code from %p\n", &resume_start);
> -- 
> 2.25.1
> 

Thanks,
drew

