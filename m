Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE31425CA4
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 21:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241640AbhJGTxt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 15:53:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24699 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241268AbhJGTxs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 15:53:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633636313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rSJdnQLBRJZqIYEQXaJkFdiNc92DNWtdQnJhG+HrODQ=;
        b=AeJmiweUz++zP05g2aLKvEtoz4mOzMRdkDNk45zUxvmaZWqtiK2Xh9Ic1/sbErk31xbiQB
        dFPmXEDW8ow3Bk/Qlij3toWdusEVv8uas2YdPAgMYiqvSXUrOWFhj86+7Ysc2kUouU5GNX
        wfiiRRzwfITFCGfPBiwYhoC0fyNgSSI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-8-O3j7ivNHG0-_TYdbmp9A-1; Thu, 07 Oct 2021 15:51:51 -0400
X-MC-Unique: 8-O3j7ivNHG0-_TYdbmp9A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 231E21922964;
        Thu,  7 Oct 2021 19:51:50 +0000 (UTC)
Received: from redhat.com (ovpn-113-216.phx2.redhat.com [10.3.113.216])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1124210016FF;
        Thu,  7 Oct 2021 19:51:12 +0000 (UTC)
Date:   Thu, 7 Oct 2021 14:51:10 -0500
From:   Eric Blake <eblake@redhat.com>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Brijesh Singh <brijesh.singh@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v4 16/23] target/i386/sev: Remove stubs by using code
 elision
Message-ID: <20211007195110.tmsawi5vt3vnoo6t@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
 <20211007161716.453984-17-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211007161716.453984-17-philmd@redhat.com>
User-Agent: NeoMutt/20210205-818-e2615c
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 07, 2021 at 06:17:09PM +0200, Philippe Mathieu-Daudé wrote:
> Only declare sev_enabled() and sev_es_enabled() when CONFIG_SEV is
> set, to allow the compiler to elide unused code. Remove unnecessary
> stubs.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
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

Is that leading space on the sev_enabled() line intentional?

> +#define sev_enabled() 0
> +#define sev_es_enabled() 0
> +#endif
> +

This allows an optimizing compiler to elide code, but does not require
that the elision worked. The real test is whether there is a link
error when functions that are only called inside what we hope is
elided have no stub.

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

As long as this compiles in all of our configurations, then the
compiler really has elided the calls and we can get rid of the stub.
But that's merely because we're relying on our particular gcc or clang
compiler behavior, and NOT because it is standardized behavior.  On
the other hand, I doubt either compiler would break this assumption,
as it is probably used in lots of places, even if it is not portable.

Since you asked for my opinion, I'm okay giving:

Reviewed-by: Eric Blake <eblake@redhat.com>

-- 
Eric Blake, Principal Software Engineer
Red Hat, Inc.           +1-919-301-3266
Virtualization:  qemu.org | libvirt.org

