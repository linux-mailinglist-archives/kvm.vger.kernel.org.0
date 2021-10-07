Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414554258EA
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 19:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242991AbhJGRJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 13:09:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50978 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243008AbhJGRJZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 13:09:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633626450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vOgstVP39uHiVDCQR89rxdsZ+CifSHj0dsIBU9buRTQ=;
        b=FJoSqka7d5ewF8oqsQjpbe+GEX5djrdM+nu2IwZ98tL30sRrDAZRrIX+jkHOoTW6vmjg/7
        IZfFyp++FFKB7cR+KYdIg4M3sK3ewoBt5/BubrBCMZdx0EgfuSGH0Ozc31ZoWvLY5aDydf
        8y7ECSt9clow/Y5eY8yiIBmGibBpjqA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-k1LSDWMoPTSACxITZpAgtw-1; Thu, 07 Oct 2021 13:07:27 -0400
X-MC-Unique: k1LSDWMoPTSACxITZpAgtw-1
Received: by mail-wr1-f71.google.com with SMTP id r16-20020adfb1d0000000b00160bf8972ceso5220153wra.13
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 10:07:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=vOgstVP39uHiVDCQR89rxdsZ+CifSHj0dsIBU9buRTQ=;
        b=B0AcxQlD29In87Tp+wtOC/EHpCRVnWugSezfb/CWRDoXJSj37rl1XRGq0xrrk/T4f7
         U4QN/xdvggWf+/XxvMLiwMvqUCEwzYg7DoLdiRdBW48ctUrUFCrOFF+QYdYhpa0/sgzU
         F7EaFOarwvOuS7dfLfALveJj1KPOm2nYmef/MYTbOaT4nSdA2rcDOQ6VvGr9BBXatfOH
         bnrq9j6BZEo4apSY6RncNHBvEVcM2WF3HtjvV0vlmDxIkoUN4Z/4a2/gzwpFdwhq7Kei
         D4dt2YAKaZsVfpoHlMWTqqA/lERNFFzJ39PMntO+LwJQeMi4mhi/HwThYm3Adqbzl1QI
         Gv8g==
X-Gm-Message-State: AOAM533/53T2IZTvz1RUBH3wYlTInJ8WKvW6WSTTxI1Mfe5mov2vlhSs
        Opm9BriZqVJDMTmU3Pouy5wbzbYiQwqrBqlOPDCnIZtn57wFihKsBd+YV2A7aG+0CMpYpagPsIW
        oDmBJIMj5N19W
X-Received: by 2002:a7b:c938:: with SMTP id h24mr1926238wml.41.1633626446521;
        Thu, 07 Oct 2021 10:07:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzWSShfdNN8yjaqlu9CM3I5d6ybN282swEBN8GRzgPQr9NREZ3fM9Dj+K7NhC3x2wqV8P3ZjQ==
X-Received: by 2002:a7b:c938:: with SMTP id h24mr1926216wml.41.1633626446354;
        Thu, 07 Oct 2021 10:07:26 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id e1sm212129wru.26.2021.10.07.10.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 10:07:25 -0700 (PDT)
Date:   Thu, 7 Oct 2021 18:07:23 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sergio Lopez <slp@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>
Subject: Re: [PATCH v4 16/23] target/i386/sev: Remove stubs by using code
 elision
Message-ID: <YV8pS2D8e14qmFBq@work-vm>
References: <20211007161716.453984-1-philmd@redhat.com>
 <20211007161716.453984-17-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211007161716.453984-17-philmd@redhat.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Philippe Mathieu-Daudé (philmd@redhat.com) wrote:
> Only declare sev_enabled() and sev_es_enabled() when CONFIG_SEV is
> set, to allow the compiler to elide unused code. Remove unnecessary
> stubs.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>

What makes it allowed to *rely* on the compiler eliding calls?

Dave

> ---
>  target/i386/sev.h       | 14 ++++++++++++--
>  target/i386/cpu.c       | 13 +++++++------
>  target/i386/sev-stub.c  | 41 -----------------------------------------
>  target/i386/meson.build |  2 +-
>  4 files changed, 20 insertions(+), 50 deletions(-)
>  delete mode 100644 target/i386/sev-stub.c
> 
> diff --git a/target/i386/sev.h b/target/i386/sev.h
> index c96072bf78d..d9548e3e642 100644
> --- a/target/i386/sev.h
> +++ b/target/i386/sev.h
> @@ -14,6 +14,10 @@
>  #ifndef QEMU_SEV_I386_H
>  #define QEMU_SEV_I386_H
>  
> +#ifndef CONFIG_USER_ONLY
> +#include CONFIG_DEVICES /* CONFIG_SEV */
> +#endif
> +
>  #include "exec/confidential-guest-support.h"
>  #include "qapi/qapi-types-misc-target.h"
>  
> @@ -35,8 +39,14 @@ typedef struct SevKernelLoaderContext {
>      size_t cmdline_size;
>  } SevKernelLoaderContext;
>  
> -bool sev_enabled(void);
> -extern bool sev_es_enabled(void);
> +#ifdef CONFIG_SEV
> + bool sev_enabled(void);
> +bool sev_es_enabled(void);
> +#else
> +#define sev_enabled() 0
> +#define sev_es_enabled() 0
> +#endif
> +
>  extern SevInfo *sev_get_info(void);
>  extern uint32_t sev_get_cbit_position(void);
>  extern uint32_t sev_get_reduced_phys_bits(void);
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 8289dc87bd5..fc3ed80ef1e 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -5764,12 +5764,13 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
>          *edx = 0;
>          break;
>      case 0x8000001F:
> -        *eax = sev_enabled() ? 0x2 : 0;
> -        *eax |= sev_es_enabled() ? 0x8 : 0;
> -        *ebx = sev_get_cbit_position();
> -        *ebx |= sev_get_reduced_phys_bits() << 6;
> -        *ecx = 0;
> -        *edx = 0;
> +        *eax = *ebx = *ecx = *edx = 0;
> +        if (sev_enabled()) {
> +            *eax = 0x2;
> +            *eax |= sev_es_enabled() ? 0x8 : 0;
> +            *ebx = sev_get_cbit_position();
> +            *ebx |= sev_get_reduced_phys_bits() << 6;
> +        }
>          break;
>      default:
>          /* reserved values: zero */
> diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
> deleted file mode 100644
> index 7e8b6f9a259..00000000000
> --- a/target/i386/sev-stub.c
> +++ /dev/null
> @@ -1,41 +0,0 @@
> -/*
> - * QEMU SEV stub
> - *
> - * Copyright Advanced Micro Devices 2018
> - *
> - * Authors:
> - *      Brijesh Singh <brijesh.singh@amd.com>
> - *
> - * This work is licensed under the terms of the GNU GPL, version 2 or later.
> - * See the COPYING file in the top-level directory.
> - *
> - */
> -
> -#include "qemu/osdep.h"
> -#include "qapi/error.h"
> -#include "sev.h"
> -
> -bool sev_enabled(void)
> -{
> -    return false;
> -}
> -
> -uint32_t sev_get_cbit_position(void)
> -{
> -    return 0;
> -}
> -
> -uint32_t sev_get_reduced_phys_bits(void)
> -{
> -    return 0;
> -}
> -
> -bool sev_es_enabled(void)
> -{
> -    return false;
> -}
> -
> -bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
> -{
> -    g_assert_not_reached();
> -}
> diff --git a/target/i386/meson.build b/target/i386/meson.build
> index a4f45c3ec1d..ae38dc95635 100644
> --- a/target/i386/meson.build
> +++ b/target/i386/meson.build
> @@ -6,7 +6,7 @@
>    'xsave_helper.c',
>    'cpu-dump.c',
>  ))
> -i386_ss.add(when: 'CONFIG_SEV', if_true: files('host-cpu.c'), if_false: files('sev-stub.c'))
> +i386_ss.add(when: 'CONFIG_SEV', if_true: files('host-cpu.c'))
>  
>  # x86 cpu type
>  i386_ss.add(when: 'CONFIG_KVM', if_true: files('host-cpu.c'))
> -- 
> 2.31.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

