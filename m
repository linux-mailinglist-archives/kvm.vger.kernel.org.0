Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7EA052D46C
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239070AbiESNo1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiESNmo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:42:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C3A73CA70
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652967762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cc6v35h5umjQC0TnVPsA9e8Ju9AJ+4sNLFkL8hlX4lM=;
        b=emr4cSql47O17+LOUEUdwdqWU1O9RqTWhIEMOMVmHsYUPVKfmn1HEhedHTVC86efAHcfeP
        SOYXjK76TW9ksQvCTj9cBOiAtrJ67P2mGpD/wt72xOB14a9DuTS3RRcR/enbhm2gDyXH7O
        aF+Acu64jH9wMzRZJs0gCt4hTN2pW2s=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-ySXRCjAHPViuUMaf66a80w-1; Thu, 19 May 2022 09:42:40 -0400
X-MC-Unique: ySXRCjAHPViuUMaf66a80w-1
Received: by mail-wm1-f72.google.com with SMTP id m26-20020a7bcb9a000000b0039455e871b6so1838810wmi.8
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:42:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cc6v35h5umjQC0TnVPsA9e8Ju9AJ+4sNLFkL8hlX4lM=;
        b=6wYe2Z13NuIthzMEqJ39g7ZlHBUgm4B2f0VQ4Qjuc7lz8LkQRQkm1fQ+romUiAGpRU
         t3RTemZJrV+XqZTM9FP8/3LNeXxL6uc+skg5P9s2rWtdFicaMYdi9S3SPbeZ3dZJPf+s
         uOXe0dD+wY3V8HHxcCWELrSuNdv2XvcnZ1uoly7keXUIdKOzXMXEVZj6BjO3tvkkqqwb
         pSPY5U1zjUS6tP6/adMKoyAYyIGXoCArlAYiALD/wkTuinU3iMECW54fGGRf7bjCJ2I8
         fOlSrlkgum4XLoHxB/my7ETVtL3MvnXHO6q0S0oophTrLEyWJ3vncuSuSwiVxGq+K6SQ
         1m4w==
X-Gm-Message-State: AOAM533UCMgS2pkZ9JXM6JVv+U/KtlJWkDQWFyssLzXiCCdrK9xF4aNx
        ACLu0UTIz16xzZEDjOMBfntccIWiC5nPO+HC8PRiS6YiJ6iL4hiRex6zrcNV2AmcuUdWKUI+lh4
        uIIuL0hJuf8i5
X-Received: by 2002:a05:600c:1c1f:b0:394:6950:2bda with SMTP id j31-20020a05600c1c1f00b0039469502bdamr4477969wms.52.1652967759762;
        Thu, 19 May 2022 06:42:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXUG31Hl0QIY94TSGDFiNH/UduvjVL+8FtbeYhtoE7IuCtr6ZQdM1+BfetQtGi+GBBsvxj3g==
X-Received: by 2002:a05:600c:1c1f:b0:394:6950:2bda with SMTP id j31-20020a05600c1c1f00b0039469502bdamr4477956wms.52.1652967759567;
        Thu, 19 May 2022 06:42:39 -0700 (PDT)
Received: from gator (cst2-173-79.cust.vodafone.cz. [31.30.173.79])
        by smtp.gmail.com with ESMTPSA id i13-20020adfaacd000000b0020cd8f1d25csm4742736wrc.8.2022.05.19.06.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 06:42:39 -0700 (PDT)
Date:   Thu, 19 May 2022 15:42:37 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 04/23] lib: Extend the definition of
 the ACPI table FADT
Message-ID: <20220519134237.jrwug2lqmov43cnd@gator>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-5-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506205605.359830-5-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 09:55:46PM +0100, Nikos Nikoleris wrote:
> This change add more fields in the APCI table FADT to allow for the
> discovery of the PSCI conduit in arm64 systems. The definition for
> FADT is similar to the one in include/acpi/actbl.h in Linux.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/acpi.h   | 35 ++++++++++++++++++++++++++++++-----
>  lib/acpi.c   |  2 +-
>  x86/s3.c     |  2 +-
>  x86/vmexit.c |  2 +-
>  4 files changed, 33 insertions(+), 8 deletions(-)

Looks fine to me, so

Reviewed-by: Andrew Jones <drjones@redhat.com>

but we should get sign-off from x86 people since they've been expecting
fadt to be rev1 all this time and now it's changing.

Thanks,
drew

> 
> diff --git a/lib/acpi.h b/lib/acpi.h
> index d80b983..9f27eb1 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -62,7 +62,15 @@ struct acpi_table_xsdt {
>      u64 table_offset_entry[1];
>  } __attribute__ ((packed));
>  
> -struct fadt_descriptor_rev1
> +struct acpi_generic_address {
> +    u8 space_id;            /* Address space where struct or register exists */
> +    u8 bit_width;           /* Size in bits of given register */
> +    u8 bit_offset;          /* Bit offset within the register */
> +    u8 access_width;        /* Minimum Access size (ACPI 3.0) */
> +    u64 address;            /* 64-bit address of struct or register */
> +} __attribute__ ((packed));
> +
> +struct acpi_table_fadt
>  {
>      ACPI_TABLE_HEADER_DEF     /* ACPI common table header */
>      u32 firmware_ctrl;          /* Physical address of FACS */
> @@ -100,10 +108,27 @@ struct fadt_descriptor_rev1
>      u8  day_alrm;               /* Index to day-of-month alarm in RTC CMOS RAM */
>      u8  mon_alrm;               /* Index to month-of-year alarm in RTC CMOS RAM */
>      u8  century;                /* Index to century in RTC CMOS RAM */
> -    u8  reserved4;              /* Reserved */
> -    u8  reserved4a;             /* Reserved */
> -    u8  reserved4b;             /* Reserved */
> -};
> +    u16 boot_flags;             /* IA-PC Boot Architecture Flags (see below for individual flags) */
> +    u8 reserved;                /* Reserved, must be zero */
> +    u32 flags;                  /* Miscellaneous flag bits (see below for individual flags) */
> +    struct acpi_generic_address reset_register;     /* 64-bit address of the Reset register */
> +    u8 reset_value;             /* Value to write to the reset_register port to reset the system */
> +    u16 arm_boot_flags;         /* ARM-Specific Boot Flags (see below for individual flags) (ACPI 5.1) */
> +    u8 minor_revision;          /* FADT Minor Revision (ACPI 5.1) */
> +    u64 Xfacs;                  /* 64-bit physical address of FACS */
> +    u64 Xdsdt;                  /* 64-bit physical address of DSDT */
> +    struct acpi_generic_address xpm1a_event_block;  /* 64-bit Extended Power Mgt 1a Event Reg Blk address */
> +    struct acpi_generic_address xpm1b_event_block;  /* 64-bit Extended Power Mgt 1b Event Reg Blk address */
> +    struct acpi_generic_address xpm1a_control_block;        /* 64-bit Extended Power Mgt 1a Control Reg Blk address */
> +    struct acpi_generic_address xpm1b_control_block;        /* 64-bit Extended Power Mgt 1b Control Reg Blk address */
> +    struct acpi_generic_address xpm2_control_block; /* 64-bit Extended Power Mgt 2 Control Reg Blk address */
> +    struct acpi_generic_address xpm_timer_block;    /* 64-bit Extended Power Mgt Timer Ctrl Reg Blk address */
> +    struct acpi_generic_address xgpe0_block;        /* 64-bit Extended General Purpose Event 0 Reg Blk address */
> +    struct acpi_generic_address xgpe1_block;        /* 64-bit Extended General Purpose Event 1 Reg Blk address */
> +    struct acpi_generic_address sleep_control;      /* 64-bit Sleep Control register (ACPI 5.0) */
> +    struct acpi_generic_address sleep_status;       /* 64-bit Sleep Status register (ACPI 5.0) */
> +    u64 hypervisor_id;      /* Hypervisor Vendor ID (ACPI 6.0) */
> +}  __attribute__ ((packed));
>  
>  struct facs_descriptor_rev1
>  {
> diff --git a/lib/acpi.c b/lib/acpi.c
> index 9b8700c..e8440ae 100644
> --- a/lib/acpi.c
> +++ b/lib/acpi.c
> @@ -46,7 +46,7 @@ void* find_acpi_table_addr(u32 sig)
>  
>  	/* FACS is special... */
>  	if (sig == FACS_SIGNATURE) {
> -		struct fadt_descriptor_rev1 *fadt;
> +		struct acpi_table_fadt *fadt;
>  
>  		fadt = find_acpi_table_addr(FACP_SIGNATURE);
>  		if (!fadt)
> diff --git a/x86/s3.c b/x86/s3.c
> index 89d69fc..16e79f8 100644
> --- a/x86/s3.c
> +++ b/x86/s3.c
> @@ -30,7 +30,7 @@ extern char resume_start, resume_end;
>  
>  int main(int argc, char **argv)
>  {
> -	struct fadt_descriptor_rev1 *fadt = find_acpi_table_addr(FACP_SIGNATURE);
> +	struct acpi_table_fadt *fadt = find_acpi_table_addr(FACP_SIGNATURE);
>  	struct facs_descriptor_rev1 *facs = find_acpi_table_addr(FACS_SIGNATURE);
>  	char *addr, *resume_vec = (void*)0x1000;
>  
> diff --git a/x86/vmexit.c b/x86/vmexit.c
> index 2bac049..fcc0760 100644
> --- a/x86/vmexit.c
> +++ b/x86/vmexit.c
> @@ -206,7 +206,7 @@ int pm_tmr_blk;
>  static void inl_pmtimer(void)
>  {
>      if (!pm_tmr_blk) {
> -	struct fadt_descriptor_rev1 *fadt;
> +	struct acpi_table_fadt *fadt;
>  
>  	fadt = find_acpi_table_addr(FACP_SIGNATURE);
>  	pm_tmr_blk = fadt->pm_tmr_blk;
> -- 
> 2.25.1
> 

