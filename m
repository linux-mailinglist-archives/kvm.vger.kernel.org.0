Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08FA452D3D3
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238718AbiESNV3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237524AbiESNV0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:21:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 00D7913D3A
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652966483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hpom49djhvCnTb6qInWen/ieAQCL5jjwhDfWzOA/1YI=;
        b=B3mmF7nC1LJx304eLE0YA7JEZ3NbGOuGey3HlmkNKoDnKA6gZc9fsLMDan3SF6A34xHlZE
        KME9ux5/2ON2jbd3dIF+Yu+C5jofVIPzAO0XqXjaoFT7eciI3KaVkvtnwp6OTXLquTGm48
        4ivdeObRdJxp5CviJDmwV9QLHrZChqc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-8C3yUru1OKqyUyUTZHkhdQ-1; Thu, 19 May 2022 09:21:22 -0400
X-MC-Unique: 8C3yUru1OKqyUyUTZHkhdQ-1
Received: by mail-wr1-f72.google.com with SMTP id h3-20020adffa83000000b0020e5f0b8090so1554080wrr.19
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:21:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Hpom49djhvCnTb6qInWen/ieAQCL5jjwhDfWzOA/1YI=;
        b=z01b53D31LaveFFgAY/GzdfPt6zOPlFbTfX3o+qVmU51pCB2TG1SuSy43u45NjMmg4
         DLOzblJCpImQj0Ej/VmD7x4vNs7pi6w6/KAdKo0h2XGiCJGjCcjYtw8VBSwik2a7Siwd
         2u1lTtDXB6NONTikjbfysTDhe+OMf/u0kMI78pvLTWXbrmSNTtnE1QPIUgO8k40IKOQv
         FVJGchTMroPc7cKaDBDJ0HQqHVZ3LUlEs7TAEolYZoAWmTFghtd+7vo4n84ITuyYSdHX
         bBhuiDFlAkov2UfvpKSbybbPZIxTFJcdTZDI4DvSiPDF68Hkf0Muy+aBKW8QUW75dJVj
         Rb7g==
X-Gm-Message-State: AOAM533xuar5jUOyHJOChaBv0mfJrFjbBdG5XG8jySfu5QsaEYR7k2XJ
        7ITUVFVCizWebzyFeDkCETOaLREXrjmgo9giRC/GSDUdLC792L9OChhvhMjKTEY9s0Ye7zQEbiC
        ZvQ5R9fKnweki
X-Received: by 2002:a05:600c:58a:b0:396:ec38:3a32 with SMTP id o10-20020a05600c058a00b00396ec383a32mr4335262wmd.17.1652966481236;
        Thu, 19 May 2022 06:21:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyNZ+ITXlkXhJxW6Q5XcQaFta6ZHSrXalQ6c/tAHwf2yreBtyLq555ki1sZF+2io9pSfqLbeQ==
X-Received: by 2002:a05:600c:58a:b0:396:ec38:3a32 with SMTP id o10-20020a05600c058a00b00396ec383a32mr4335242wmd.17.1652966481028;
        Thu, 19 May 2022 06:21:21 -0700 (PDT)
Received: from gator (cst2-173-79.cust.vodafone.cz. [31.30.173.79])
        by smtp.gmail.com with ESMTPSA id c25-20020adfa319000000b0020c6b78eb5asm5161779wrb.68.2022.05.19.06.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 06:21:20 -0700 (PDT)
Date:   Thu, 19 May 2022 15:21:18 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 01/23] lib: Move acpi header and
 implementation to lib
Message-ID: <20220519132118.gwfmclcaeejjnhp3@gator>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-2-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506205605.359830-2-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 09:55:43PM +0100, Nikos Nikoleris wrote:
> This change is in preparation of using ACPI in arm64 systems booting
> with EFI.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  x86/Makefile.common  | 2 +-
>  lib/x86/asm/setup.h  | 2 +-
>  lib/{x86 => }/acpi.h | 4 ++--
>  lib/{x86 => }/acpi.c | 0

I like that diffstat that git-format-patch -M creates when only
moving, but not changing a file. I'd prefer we take the opportunity
to update the file's coding style though and then confirm we didn't
introduce any changes with a whitespace ignoring diff.

>  x86/s3.c             | 2 +-
>  x86/vmexit.c         | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
>  rename lib/{x86 => }/acpi.h (99%)
>  rename lib/{x86 => }/acpi.c (100%)
> 
> diff --git a/x86/Makefile.common b/x86/Makefile.common
> index b903988..4cdba79 100644
> --- a/x86/Makefile.common
> +++ b/x86/Makefile.common
> @@ -2,6 +2,7 @@
>  
>  all: directories test_cases
>  
> +cflatobjs += lib/acpi.o
>  cflatobjs += lib/pci.o
>  cflatobjs += lib/pci-edu.o
>  cflatobjs += lib/alloc.o
> @@ -18,7 +19,6 @@ cflatobjs += lib/x86/apic.o
>  cflatobjs += lib/x86/atomic.o
>  cflatobjs += lib/x86/desc.o
>  cflatobjs += lib/x86/isr.o
> -cflatobjs += lib/x86/acpi.o
>  cflatobjs += lib/x86/stack.o
>  cflatobjs += lib/x86/fault_test.o
>  cflatobjs += lib/x86/delay.o
> diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
> index 24d4fa9..f46462c 100644
> --- a/lib/x86/asm/setup.h
> +++ b/lib/x86/asm/setup.h
> @@ -4,7 +4,7 @@
>  unsigned long setup_tss(u8 *stacktop);
>  
>  #ifdef CONFIG_EFI
> -#include "x86/acpi.h"
> +#include "acpi.h"
>  #include "x86/apic.h"
>  #include "x86/processor.h"
>  #include "x86/smp.h"
> diff --git a/lib/x86/acpi.h b/lib/acpi.h
> similarity index 99%
> rename from lib/x86/acpi.h
> rename to lib/acpi.h
> index 67ba389..1e89840 100644
> --- a/lib/x86/acpi.h
> +++ b/lib/acpi.h
> @@ -1,5 +1,5 @@
> -#ifndef _X86_ACPI_H_
> -#define _X86_ACPI_H_
> +#ifndef _ACPI_H_
> +#define _ACPI_H_
>  
>  #include "libcflat.h"
>  
> diff --git a/lib/x86/acpi.c b/lib/acpi.c
> similarity index 100%
> rename from lib/x86/acpi.c
> rename to lib/acpi.c
> diff --git a/x86/s3.c b/x86/s3.c
> index 6e41d0c..378d37a 100644
> --- a/x86/s3.c
> +++ b/x86/s3.c
> @@ -1,5 +1,5 @@
>  #include "libcflat.h"
> -#include "x86/acpi.h"
> +#include "acpi.h"
>  #include "asm/io.h"
>  
>  static u32* find_resume_vector_addr(void)
> diff --git a/x86/vmexit.c b/x86/vmexit.c
> index 4adec78..2bac049 100644
> --- a/x86/vmexit.c
> +++ b/x86/vmexit.c
> @@ -1,9 +1,9 @@
> +#include "acpi.h"
>  #include "libcflat.h"

I prefer libcflat.h on top.

>  #include "smp.h"
>  #include "pci.h"
>  #include "x86/vm.h"
>  #include "x86/desc.h"
> -#include "x86/acpi.h"
>  #include "x86/apic.h"
>  #include "x86/isr.h"
>  
> -- 
> 2.25.1
> 

Thanks,
drew

