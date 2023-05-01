Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1226F313A
	for <lists+kvm@lfdr.de>; Mon,  1 May 2023 14:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbjEAMws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 08:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232370AbjEAMwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 08:52:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C745210D5
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 05:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682945521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rIQ9pPPM/f+EbN6lMtqjtA6sCoU4Vt/PMUK/bAqcgww=;
        b=HSzcPG1WLDh9BzwETB+KyZ5AaLPZXUcgswa/beDTkJvOwGvUxOANFBtH++VyqD4xAFZVjA
        +8MaB86B9L/JwOAfpkIhPgm2OGUq4IpT/9NWjEoOqLj1e1dFh1qOmQWPoRMcKoeIUJiJRL
        xFzebxeuCXHP/SVQi5jdxujZQVjOF4I=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-A1WhS4AfMRW4RC1_xWlLfw-1; Mon, 01 May 2023 08:52:00 -0400
X-MC-Unique: A1WhS4AfMRW4RC1_xWlLfw-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-24de4be7c41so358605a91.0
        for <kvm@vger.kernel.org>; Mon, 01 May 2023 05:52:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682945519; x=1685537519;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rIQ9pPPM/f+EbN6lMtqjtA6sCoU4Vt/PMUK/bAqcgww=;
        b=XqpCbdVxjo4BgMlLKD/75zOec0zsHecKcRnLVWyKfteT5vcIY4CPnMQBzcZmcK0PsY
         aAO0HfPcuSQh+Mg3YFIt6HjAXImwgxLqADFK7hDmD4j+5zb4bV0KTwv+ITmorIqDIlHo
         X9s1vrNjdjnGn/MP29xU3h2rBT7F4E2k0iBbIYxZnNBg2pxEn1OZlydDhws3NhOlCDve
         f0Svtt+hINtpnNlHuvyPiQI6H8eLQ6auPxBTk9GKEVTws/PMSWuxrcvg/HgRcrelzfTJ
         U+SY69CrspuPZwQX0cwVVhphwcfz1ajFZ1FlZdgukPTWg4H7DLWM74LCpbTkA0cSqmBX
         1oIg==
X-Gm-Message-State: AC+VfDw9zj+ev50iRFeoIkyaoJHWjpwSK+VaDgBqgVANql25cHmYGQ/k
        KHqf78u1A+Ns9XwP4qfOIxICYk2xulqLJ83HnoujQjrBtfgtLjSmy8lKNBZJORI/1Vd3lbH25tq
        picCEc96jvN5r
X-Received: by 2002:a17:90a:30c:b0:247:a17:9258 with SMTP id 12-20020a17090a030c00b002470a179258mr10091054pje.2.1682945519581;
        Mon, 01 May 2023 05:51:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ48hZ1rBrhT2W2cS5kTBTFoYM9APL2DzC0NN2cZ1HJo0H28evFdjwb4tiOo4Urhdbi54NVVPA==
X-Received: by 2002:a17:90a:30c:b0:247:a17:9258 with SMTP id 12-20020a17090a030c00b002470a179258mr10091043pje.2.1682945519311;
        Mon, 01 May 2023 05:51:59 -0700 (PDT)
Received: from [10.66.61.39] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y62-20020a17090a53c400b0024e14a3dba6sm733975pjh.10.2023.05.01.05.51.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 05:51:59 -0700 (PDT)
Message-ID: <e1f2b750-3714-e822-6fab-911bfccea541@redhat.com>
Date:   Mon, 1 May 2023 20:51:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [kvm-unit-tests PATCH v5 09/29] lib/acpi: Extend the definition
 of the FADT table
Content-Language: en-US
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com,
        Andrew Jones <drjones@redhat.com>
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230428120405.3770496-10-nikos.nikoleris@arm.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230428120405.3770496-10-nikos.nikoleris@arm.com>
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
> This change add more fields in the APCI table FADT to allow for the
> discovery of the PSCI conduit in arm64 systems. The definition for
> FADT is similar to the one in include/acpi/actbl.h in Linux.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   lib/acpi.h   | 33 +++++++++++++++++++++++++++++----
>   lib/acpi.c   |  2 +-
>   x86/s3.c     |  2 +-
>   x86/vmexit.c |  2 +-
>   4 files changed, 32 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/acpi.h b/lib/acpi.h
> index 74ba00ac..b714677e 100644
> --- a/lib/acpi.h
> +++ b/lib/acpi.h
> @@ -62,7 +62,15 @@ struct acpi_table_xsdt {
>   	u64 table_offset_entry[];
>   };
>   
> -struct acpi_table_fadt_rev1 {
> +struct acpi_generic_address {
> +	u8 space_id;		/* Address space where struct or register exists */
> +	u8 bit_width;		/* Size in bits of given register */
> +	u8 bit_offset;		/* Bit offset within the register */
> +	u8 access_width;	/* Minimum Access size (ACPI 3.0) */
> +	u64 address;		/* 64-bit address of struct or register */
> +};
> +
> +struct acpi_table_fadt {
>   	ACPI_TABLE_HEADER_DEF	/* ACPI common table header */
>   	u32 firmware_ctrl;	/* Physical address of FACS */
>   	u32 dsdt;		/* Physical address of DSDT */
> @@ -99,9 +107,26 @@ struct acpi_table_fadt_rev1 {
>   	u8 day_alrm;		/* Index to day-of-month alarm in RTC CMOS RAM */
>   	u8 mon_alrm;		/* Index to month-of-year alarm in RTC CMOS RAM */
>   	u8 century;		/* Index to century in RTC CMOS RAM */
> -	u8 reserved4;		/* Reserved */
> -	u8 reserved4a;		/* Reserved */
> -	u8 reserved4b;		/* Reserved */
> +	u16 boot_flags;		/* IA-PC Boot Architecture Flags (see below for individual flags) */
> +	u8 reserved;		/* Reserved, must be zero */
> +	u32 flags;		/* Miscellaneous flag bits (see below for individual flags) */
> +	struct acpi_generic_address reset_register;	/* 64-bit address of the Reset register */
> +	u8 reset_value;		/* Value to write to the reset_register port to reset the system */
> +	u16 arm_boot_flags;	/* ARM-Specific Boot Flags (see below for individual flags) (ACPI 5.1) */
> +	u8 minor_revision;	/* FADT Minor Revision (ACPI 5.1) */
> +	u64 Xfacs;		/* 64-bit physical address of FACS */
> +	u64 Xdsdt;		/* 64-bit physical address of DSDT */
> +	struct acpi_generic_address xpm1a_event_block;	/* 64-bit Extended Power Mgt 1a Event Reg Blk address */
> +	struct acpi_generic_address xpm1b_event_block;	/* 64-bit Extended Power Mgt 1b Event Reg Blk address */
> +	struct acpi_generic_address xpm1a_control_block;	/* 64-bit Extended Power Mgt 1a Control Reg Blk address */
> +	struct acpi_generic_address xpm1b_control_block;	/* 64-bit Extended Power Mgt 1b Control Reg Blk address */
> +	struct acpi_generic_address xpm2_control_block;	/* 64-bit Extended Power Mgt 2 Control Reg Blk address */
> +	struct acpi_generic_address xpm_timer_block;	/* 64-bit Extended Power Mgt Timer Ctrl Reg Blk address */
> +	struct acpi_generic_address xgpe0_block;	/* 64-bit Extended General Purpose Event 0 Reg Blk address */
> +	struct acpi_generic_address xgpe1_block;	/* 64-bit Extended General Purpose Event 1 Reg Blk address */
> +	struct acpi_generic_address sleep_control;	/* 64-bit Sleep Control register (ACPI 5.0) */
> +	struct acpi_generic_address sleep_status;	/* 64-bit Sleep Status register (ACPI 5.0) */
> +	u64 hypervisor_id;	/* Hypervisor Vendor ID (ACPI 6.0) */
>   };
>   
>   struct acpi_table_facs_rev1 {
> diff --git a/lib/acpi.c b/lib/acpi.c
> index d35f09a6..a197f3dd 100644
> --- a/lib/acpi.c
> +++ b/lib/acpi.c
> @@ -45,7 +45,7 @@ void *find_acpi_table_addr(u32 sig)
>   
>   	/* FACS is special... */
>   	if (sig == FACS_SIGNATURE) {
> -		struct acpi_table_fadt_rev1 *fadt;
> +		struct acpi_table_fadt *fadt;
>   
>   		fadt = find_acpi_table_addr(FACP_SIGNATURE);
>   		if (!fadt)
> diff --git a/x86/s3.c b/x86/s3.c
> index 910c57fb..6f2d6d10 100644
> --- a/x86/s3.c
> +++ b/x86/s3.c
> @@ -30,8 +30,8 @@ extern char resume_start, resume_end;
>   
>   int main(int argc, char **argv)
>   {
> -	struct acpi_table_fadt_rev1 *fadt = find_acpi_table_addr(FACP_SIGNATURE);
>   	struct acpi_table_facs_rev1 *facs = find_acpi_table_addr(FACS_SIGNATURE);
> +	struct acpi_table_fadt *fadt = find_acpi_table_addr(FACP_SIGNATURE);
>   	char *addr, *resume_vec = (void*)0x1000;
>   
>   	assert(facs);
> diff --git a/x86/vmexit.c b/x86/vmexit.c
> index 12234f9e..cc086b86 100644
> --- a/x86/vmexit.c
> +++ b/x86/vmexit.c
> @@ -206,7 +206,7 @@ int pm_tmr_blk;
>   static void inl_pmtimer(void)
>   {
>       if (!pm_tmr_blk) {
> -	struct acpi_table_fadt_rev1 *fadt;
> +	struct acpi_table_fadt *fadt;
>   
>   	fadt = find_acpi_table_addr(FACP_SIGNATURE);
>   	pm_tmr_blk = fadt->pm_tmr_blk;

-- 
Shaoqin

