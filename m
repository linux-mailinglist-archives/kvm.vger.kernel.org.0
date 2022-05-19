Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAE452DAFC
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 19:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240091AbiESROX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 13:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiESROU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 13:14:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0E2473EF38
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 10:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652980458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5vhY7zAU47ivGeEy+q6iMxJvsFOBtgwESvKH+qpK4tg=;
        b=QNWiKOatF8fiRKAoMdOzNcH/lwxo1rOpcCyQ7UuFFUJy0tuJZEjUoirOa64Eu6iN6Gg3/Y
        Vfhj/MR0i2GRgOj29V7DIoCyGCVfVn98iqsuk2BOkm5AoajZQQU89uI7IvuiIDzweqXHT+
        jfHYN1lKl/iBgwfdE191Iy/aiHXsMr4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-Azs0p6xaNOiJ7QV0wf-eeg-1; Thu, 19 May 2022 13:14:16 -0400
X-MC-Unique: Azs0p6xaNOiJ7QV0wf-eeg-1
Received: by mail-wm1-f69.google.com with SMTP id m186-20020a1c26c3000000b003943e12185dso2270465wmm.7
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 10:14:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=5vhY7zAU47ivGeEy+q6iMxJvsFOBtgwESvKH+qpK4tg=;
        b=5MxaYXPl6pmzWXftzATQ+ffXGNb6Kv/YJ7QlBAenIJfQV4L+osQfsUDySVjfehIccm
         dBKd/FPz5evKs31qWE8UuTnbObni0X3opaTHLBfcorkRAUeoMz9yvs1/UdBnVKXCcOa9
         /ieffnLdySIPQ48RBYBibHC4iEe5ExO8xMImOTbG0OkHt0VSaSIvg+jWkzSYZjpSQVQf
         oKyq2Y0LfGDlcQ78266QzaPDFmDB+eTS7ycRxvXVDhfoThRehUhK0DYav8L4x8slQ2I0
         ins2C6omh0pNe2BkzSpS6ZKGtbURTXz6tGGHvEqBZom+KNqFmtuoyV/1FMBjkupTpg07
         atMQ==
X-Gm-Message-State: AOAM532wTE7+EWMxqVJmAJr3zSUt8UnjE9tE4Sx029dws1opBWXHk5ST
        RKWSl2bsyGjWBEd2YrYbiT1NICd5/e0KcTl1JwZSGf98YbRVV95OAOaJ1XjELietp0/qsNj6OwT
        00cEeE9beoEzx
X-Received: by 2002:adf:ebce:0:b0:20d:7859:494d with SMTP id v14-20020adfebce000000b0020d7859494dmr4926438wrn.590.1652980455489;
        Thu, 19 May 2022 10:14:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzag5R0wP3bOteANJSFQ1Z8vZx7zLE8j178mJx6qwy1S2H741jIK64Om54yDrVmtivNF3rGrg==
X-Received: by 2002:adf:ebce:0:b0:20d:7859:494d with SMTP id v14-20020adfebce000000b0020d7859494dmr4926420wrn.590.1652980455224;
        Thu, 19 May 2022 10:14:15 -0700 (PDT)
Received: from gator (cst2-173-79.cust.vodafone.cz. [31.30.173.79])
        by smtp.gmail.com with ESMTPSA id i30-20020adfaade000000b0020d0b60000csm159906wrc.20.2022.05.19.10.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 10:14:14 -0700 (PDT)
Date:   Thu, 19 May 2022 19:14:12 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 02/23] lib: Ensure all struct
 definition for ACPI tables are packed
Message-ID: <20220519171412.hy3awn56ivfn7d3c@gator>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-3-nikos.nikoleris@arm.com>
 <20220519131746.cpiiq5ndfvip4asq@gator>
 <be60c5e6-8313-6547-49d2-ab0700cabd89@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <be60c5e6-8313-6547-49d2-ab0700cabd89@arm.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 19, 2022 at 04:52:04PM +0100, Nikos Nikoleris wrote:
> Hi Drew,
> 
> On 19/05/2022 14:17, Andrew Jones wrote:
> > On Fri, May 06, 2022 at 09:55:44PM +0100, Nikos Nikoleris wrote:
> > > All ACPI table definitions are provided with precise definitions of
> > > field sizes and offsets, make sure that no compiler optimization can
> > > interfere with the memory layout of the corresponding structs.
> > 
> > That seems like a reasonable thing to do. I'm wondering why Linux doesn't
> > appear to do it. I see u-boot does, but not for all tables, which also
> > makes me scratch my head... I see this patch packs every struct except
> > rsdp_descriptor. Is there a reason it was left out?
> > 
> 
> Thanks for the review!
> 
> Linux uses the following:
> 
> /*
>  * All tables must be byte-packed to match the ACPI specification, since
>  * the tables are provided by the system BIOS.
>  */
> #pragma pack(1)
> 
> 
> ...
> 
> 
> /* Reset to default packing */
> 
> #pragma pack()

Ah, that makes sense.

> 
> 
> Happy to switch to #pragma, if we prefer this style.
> 
> I missed rsdp_descriptor, it should be packed will fix in v3.

Maybe we should switch to the #pragma to avoid the verbosity and missing
structures? (I don't have a strong opinion...)

> 
> 
> > Another comment below
> > 
> > > 
> > > Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> > > ---
> > >   lib/acpi.h | 11 ++++++++---
> > >   x86/s3.c   | 16 ++++------------
> > >   2 files changed, 12 insertions(+), 15 deletions(-)
> > > 
> > > diff --git a/lib/acpi.h b/lib/acpi.h
> > > index 1e89840..42a2c16 100644
> > > --- a/lib/acpi.h
> > > +++ b/lib/acpi.h
> > > @@ -3,6 +3,11 @@
> > >   #include "libcflat.h"
> > > +/*
> > > + * All tables and structures must be byte-packed to match the ACPI
> > > + * specification, since the tables are provided by the system BIOS
> > > + */
> > > +
> > >   #define ACPI_SIGNATURE(c1, c2, c3, c4) \
> > >   	((c1) | ((c2) << 8) | ((c3) << 16) | ((c4) << 24))
> > > @@ -44,12 +49,12 @@ struct rsdp_descriptor {        /* Root System Descriptor Pointer */
> > >   struct acpi_table {
> > >       ACPI_TABLE_HEADER_DEF
> > >       char data[0];
> > > -};
> > > +} __attribute__ ((packed));
> > >   struct rsdt_descriptor_rev1 {
> > >       ACPI_TABLE_HEADER_DEF
> > >       u32 table_offset_entry[0];
> > > -};
> > > +} __attribute__ ((packed));
> > >   struct fadt_descriptor_rev1
> > >   {
> > > @@ -104,7 +109,7 @@ struct facs_descriptor_rev1
> > >       u32 S4bios_f        : 1;    /* Indicates if S4BIOS support is present */
> > >       u32 reserved1       : 31;   /* Must be 0 */
> > >       u8  reserved3 [40];         /* Reserved - must be zero */
> > > -};
> > > +} __attribute__ ((packed));
> > >   void set_efi_rsdp(struct rsdp_descriptor *rsdp);
> > >   void* find_acpi_table_addr(u32 sig);
> > > diff --git a/x86/s3.c b/x86/s3.c
> > 
> > The changes below in this file are unrelated, so they should be in a
> > separate patch. However, I'm also curious why they're needed. I see
> > that find_acpi_table_addr() can return NULL, so it doesn't seem like
> > we should be removing the check, but instead changing the check to
> > an assert.
> > 
> 
> These changes are necessary to appease gcc after requiring struct
> facs_descriptor_rev1 to be packed.
> 
> > > index 378d37a..89d69fc 100644
> > > --- a/x86/s3.c
> > > +++ b/x86/s3.c
> > > @@ -2,15 +2,6 @@
> > >   #include "acpi.h"
> > >   #include "asm/io.h"
> > > -static u32* find_resume_vector_addr(void)
> > > -{
> > > -    struct facs_descriptor_rev1 *facs = find_acpi_table_addr(FACS_SIGNATURE);
> > > -    if (!facs)
> > > -        return 0;
> > > -    printf("FACS is at %p\n", facs);
> > > -    return &facs->firmware_waking_vector;
> 
> This statement in particular results to a gcc warning. We can't get a
> reference to member of a packed struct.
> 
> "taking address of packed member of ‘struct facs_descriptor_rev1’ may result
> in an unaligned pointer value"
> 
> What I could do is move the x86/* changes in a separate patch in preparation
> of this one that packs all structs in <acpi.h>

Yes, please. Also please add an assert(facs) or 'if (!facs) exit()' to
preserve that NULL check (although it doesn't look like the original code
cared about the return being NULL anyway...)

Thanks,
drew

> 
> Thanks,
> 
> Nikos
> 
> > > -}
> > > -
> > >   #define RTC_SECONDS_ALARM       1
> > >   #define RTC_MINUTES_ALARM       3
> > >   #define RTC_HOURS_ALARM         5
> > > @@ -40,12 +31,13 @@ extern char resume_start, resume_end;
> > >   int main(int argc, char **argv)
> > >   {
> > >   	struct fadt_descriptor_rev1 *fadt = find_acpi_table_addr(FACP_SIGNATURE);
> > > -	volatile u32 *resume_vector_ptr = find_resume_vector_addr();
> > > +	struct facs_descriptor_rev1 *facs = find_acpi_table_addr(FACS_SIGNATURE);
> > >   	char *addr, *resume_vec = (void*)0x1000;
> > > -	*resume_vector_ptr = (u32)(ulong)resume_vec;
> > > +	facs->firmware_waking_vector = (u32)(ulong)resume_vec;
> > > -	printf("resume vector addr is %p\n", resume_vector_ptr);
> > > +	printf("FACS is at %p\n", facs);
> > > +	printf("resume vector addr is %p\n", &facs->firmware_waking_vector);
> > >   	for (addr = &resume_start; addr < &resume_end; addr++)
> > >   		*resume_vec++ = *addr;
> > >   	printf("copy resume code from %p\n", &resume_start);
> > > -- 
> > > 2.25.1
> > > 
> > 
> > Thanks,
> > drew
> > 
> 

