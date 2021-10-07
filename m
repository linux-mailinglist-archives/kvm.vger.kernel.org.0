Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FDB42594D
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 19:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240739AbhJGRYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 13:24:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25686 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241298AbhJGRYh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 13:24:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633627362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y2c+YGN6wU3B+050Do8UhDaOlKhi7UqTcLqGXK6cv28=;
        b=fBUusiZbIWtkEzOu8TawoH+VY94wygJjbDR3W9Fg79gyP8IhKGVOlfNT0MxoHl8ZnxrYVt
        vonqdLwbuFcax+As0sLJAzGsq8oZ36gohzwhdg/4+QCMNltmExomsFa5FbzQSwAIYt64FJ
        Uh0m9OUMO/ArUp9UAG4n5g9VlmOMEvo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-GNv7_fndOhO1hu2bGOvdcg-1; Thu, 07 Oct 2021 13:22:38 -0400
X-MC-Unique: GNv7_fndOhO1hu2bGOvdcg-1
Received: by mail-wr1-f72.google.com with SMTP id c2-20020adfa302000000b0015e4260febdso5232418wrb.20
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 10:22:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=y2c+YGN6wU3B+050Do8UhDaOlKhi7UqTcLqGXK6cv28=;
        b=j/hyEaS++xTCoRouXkCSwly9cCg5LgPLS/mb4na94vRLqkfS0nhS5cdYAFKUsQtu40
         kr5uF45z2oBTfY8+e+A4z/SDEkLFHcttJxn0LqEYHOE6pKyNAFFhxDnpB3IUjYxkXsuu
         ak56Nou2DWBlENmSvuzhz5V9asuw6Ney/tZpNVXVdglgu6FXigYn0Fr84T5GcUDnlali
         beGy44SY7B/E/fQixtjIRtWcTi11udvPebHO9Js70Pw+wVXV2kIsGwknRLjQO6xCrs54
         jefb+fNJOpFw3hzXywRPo9pkEKvPi669qIZQVQ8na21gieifwIsH9bex/cThTdahWOzs
         ZOBA==
X-Gm-Message-State: AOAM530HAESMhxwLkdmywezYf9OqHXJiUaupMt6ifKh9yk7/UB3JYwqn
        xwzG0o9/idQUKszNjOeM5J3zbnifPT8JSnuXsuHqp9HrywhHaiMWOt1xmOMuWthdXPqiO4fv+Es
        XQqqfBe6N+Cnr
X-Received: by 2002:a1c:9892:: with SMTP id a140mr5988945wme.187.1633627357302;
        Thu, 07 Oct 2021 10:22:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3Y9mAKHjCv2YKJWmeW2zQEasbnHiNok9T+WfiQrpReSdPvc4ydF10Uql1MwWxw6bYFDjz3A==
X-Received: by 2002:a1c:9892:: with SMTP id a140mr5988927wme.187.1633627357125;
        Thu, 07 Oct 2021 10:22:37 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id h17sm229723wrx.55.2021.10.07.10.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 10:22:36 -0700 (PDT)
Date:   Thu, 7 Oct 2021 18:22:34 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Eric Blake <eblake@redhat.com>,
        "Daniel P . Berrange" <berrange@redhat.com>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sergio Lopez <slp@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>
Subject: Re: [PATCH v4 16/23] target/i386/sev: Remove stubs by using code
 elision
Message-ID: <YV8s2r+lNyP/sX7u@work-vm>
References: <20211007161716.453984-1-philmd@redhat.com>
 <20211007161716.453984-17-philmd@redhat.com>
 <YV8pS2D8e14qmFBq@work-vm>
 <6080fa16-66aa-570e-93c8-09be2ced9431@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6080fa16-66aa-570e-93c8-09be2ced9431@redhat.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Philippe Mathieu-Daudé (philmd@redhat.com) wrote:
> On 10/7/21 19:07, Dr. David Alan Gilbert wrote:
> > * Philippe Mathieu-Daudé (philmd@redhat.com) wrote:
> >> Only declare sev_enabled() and sev_es_enabled() when CONFIG_SEV is
> >> set, to allow the compiler to elide unused code. Remove unnecessary
> >> stubs.
> >>
> >> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> > 
> > What makes it allowed to *rely* on the compiler eliding calls?
> 
> I am not aware of a particular requirement on the compiler for code
> elision, however we already use this syntax:
> 
> $ git grep -A4 'ifdef CONFIG_' include/sysemu/
> ...
> include/sysemu/tcg.h:11:#ifdef CONFIG_TCG
> include/sysemu/tcg.h-12-extern bool tcg_allowed;
> include/sysemu/tcg.h-13-#define tcg_enabled() (tcg_allowed)
> include/sysemu/tcg.h-14-#else
> include/sysemu/tcg.h-15-#define tcg_enabled() 0

So that I'm fine with, the bit I'm more worried about is the bit where
inside the if () we call functions (like sev_get_cbit_position )  which
we know the compiler will elide; I'm sure any sane compiler will,
but.....

Looking at your example, in cpu.c there's still places that ifdef around
areas with tcg_enabled.

Dave

> ...
> 
> Cc'ing Richard/Eric/Daniel who have more experience with compiler
> features in case they can enlighten me here.
> 
> >> ---
> >>  target/i386/sev.h       | 14 ++++++++++++--
> >>  target/i386/cpu.c       | 13 +++++++------
> >>  target/i386/sev-stub.c  | 41 -----------------------------------------
> >>  target/i386/meson.build |  2 +-
> >>  4 files changed, 20 insertions(+), 50 deletions(-)
> >>  delete mode 100644 target/i386/sev-stub.c
> >>
> >> diff --git a/target/i386/sev.h b/target/i386/sev.h
> >> index c96072bf78d..d9548e3e642 100644
> >> --- a/target/i386/sev.h
> >> +++ b/target/i386/sev.h
> >> @@ -14,6 +14,10 @@
> >>  #ifndef QEMU_SEV_I386_H
> >>  #define QEMU_SEV_I386_H
> >>  
> >> +#ifndef CONFIG_USER_ONLY
> >> +#include CONFIG_DEVICES /* CONFIG_SEV */
> >> +#endif
> >> +
> >>  #include "exec/confidential-guest-support.h"
> >>  #include "qapi/qapi-types-misc-target.h"
> >>  
> >> @@ -35,8 +39,14 @@ typedef struct SevKernelLoaderContext {
> >>      size_t cmdline_size;
> >>  } SevKernelLoaderContext;
> >>  
> >> -bool sev_enabled(void);
> >> -extern bool sev_es_enabled(void);
> >> +#ifdef CONFIG_SEV
> >> + bool sev_enabled(void);
> >> +bool sev_es_enabled(void);
> >> +#else
> >> +#define sev_enabled() 0
> >> +#define sev_es_enabled() 0
> >> +#endif
> >> +
> >>  extern SevInfo *sev_get_info(void);
> >>  extern uint32_t sev_get_cbit_position(void);
> >>  extern uint32_t sev_get_reduced_phys_bits(void);
> >> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> >> index 8289dc87bd5..fc3ed80ef1e 100644
> >> --- a/target/i386/cpu.c
> >> +++ b/target/i386/cpu.c
> >> @@ -5764,12 +5764,13 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
> >>          *edx = 0;
> >>          break;
> >>      case 0x8000001F:
> >> -        *eax = sev_enabled() ? 0x2 : 0;
> >> -        *eax |= sev_es_enabled() ? 0x8 : 0;
> >> -        *ebx = sev_get_cbit_position();
> >> -        *ebx |= sev_get_reduced_phys_bits() << 6;
> >> -        *ecx = 0;
> >> -        *edx = 0;
> >> +        *eax = *ebx = *ecx = *edx = 0;
> >> +        if (sev_enabled()) {
> >> +            *eax = 0x2;
> >> +            *eax |= sev_es_enabled() ? 0x8 : 0;
> >> +            *ebx = sev_get_cbit_position();
> >> +            *ebx |= sev_get_reduced_phys_bits() << 6;
> >> +        }
> >>          break;
> >>      default:
> >>          /* reserved values: zero */
> >> diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
> >> deleted file mode 100644
> >> index 7e8b6f9a259..00000000000
> >> --- a/target/i386/sev-stub.c
> >> +++ /dev/null
> >> @@ -1,41 +0,0 @@
> >> -/*
> >> - * QEMU SEV stub
> >> - *
> >> - * Copyright Advanced Micro Devices 2018
> >> - *
> >> - * Authors:
> >> - *      Brijesh Singh <brijesh.singh@amd.com>
> >> - *
> >> - * This work is licensed under the terms of the GNU GPL, version 2 or later.
> >> - * See the COPYING file in the top-level directory.
> >> - *
> >> - */
> >> -
> >> -#include "qemu/osdep.h"
> >> -#include "qapi/error.h"
> >> -#include "sev.h"
> >> -
> >> -bool sev_enabled(void)
> >> -{
> >> -    return false;
> >> -}
> >> -
> >> -uint32_t sev_get_cbit_position(void)
> >> -{
> >> -    return 0;
> >> -}
> >> -
> >> -uint32_t sev_get_reduced_phys_bits(void)
> >> -{
> >> -    return 0;
> >> -}
> >> -
> >> -bool sev_es_enabled(void)
> >> -{
> >> -    return false;
> >> -}
> >> -
> >> -bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
> >> -{
> >> -    g_assert_not_reached();
> >> -}
> >> diff --git a/target/i386/meson.build b/target/i386/meson.build
> >> index a4f45c3ec1d..ae38dc95635 100644
> >> --- a/target/i386/meson.build
> >> +++ b/target/i386/meson.build
> >> @@ -6,7 +6,7 @@
> >>    'xsave_helper.c',
> >>    'cpu-dump.c',
> >>  ))
> >> -i386_ss.add(when: 'CONFIG_SEV', if_true: files('host-cpu.c'), if_false: files('sev-stub.c'))
> >> +i386_ss.add(when: 'CONFIG_SEV', if_true: files('host-cpu.c'))
> >>  
> >>  # x86 cpu type
> >>  i386_ss.add(when: 'CONFIG_KVM', if_true: files('host-cpu.c'))
> >> -- 
> >> 2.31.1
> >>
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

