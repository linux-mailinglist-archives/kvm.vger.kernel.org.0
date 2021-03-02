Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF1132B570
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356129AbhCCHQG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:16:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32049 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351677AbhCBRiR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 12:38:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614706609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jlIWIZYzHD1EhL2tb//404goYHuWYrN3TLsE76K2ILs=;
        b=X74xOsnTLCto7VVAKE5oIkZaCcJFHxt7akp0/5qrj0nV5cqTGwB2D3tRwZ9Yz1zmgA5L4T
        RyW1Qu0lbkDCbjdM5HvThAsxZ7MmyYtnGx6p/SmccpyQ5m9OQCUoX52oqUSYc7yfqoJDQ4
        Lt4KAwH1XZ/3cyG9ovB8xkUDXXdfcAU=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-EqTJIG6bMHyrS8gm0VWlJA-1; Tue, 02 Mar 2021 12:32:48 -0500
X-MC-Unique: EqTJIG6bMHyrS8gm0VWlJA-1
Received: by mail-qt1-f199.google.com with SMTP id r1so13708470qtu.9
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 09:32:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jlIWIZYzHD1EhL2tb//404goYHuWYrN3TLsE76K2ILs=;
        b=OwTpLhIV5GLtGm65fdUBmFKMx/IYIFUogVcsSkdLWL2TqjNaKm3m4C174eyhjekFpD
         m1yScGiTXCwZbcotga+pSVHoMLWjhfo0nmDhCI+e1Ssr89/JY9dtV6408AJTZSYy5XYL
         cAsnSMSGOx9uWvsVfHT1acFgIbOQVSfzaPkTNkUmOgFY/iTVHtyXGuMRYlTF0LPNHPeK
         pHQ/CY16Wxv2bnTba3KgOeH4SZq/VP9ywyyt52CmQWH9X+Op4DPBv/bqD3VeQyPJGn9B
         rZZgJ7/nMaCEtwZ/bZyE6rMOLvsCCq/sBgn6lEhRfg/jgIrF/hvTLbRS1UFoTgxRhq6V
         riRg==
X-Gm-Message-State: AOAM530EWCUh1Ch1u2//ebo2OYbTySMYca8nbQA6T5aDDErWI6BOp7FX
        lkTfKl03ZPtNk8HxR/j0WBKytBxELi/NBHs143lOLROYFQtT7Ie03A59kLZvKwXL6fXsugCsUjV
        pBiS+taDy84Ro
X-Received: by 2002:a05:620a:791:: with SMTP id 17mr2959826qka.170.1614706367958;
        Tue, 02 Mar 2021 09:32:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzv2aftS50+NpY5Rxj4Em9ob46tG7td8IRzqUVLX4ER2B33/0EUruRU/OkJS/3TfKMcJ1EG3Q==
X-Received: by 2002:a05:620a:791:: with SMTP id 17mr2959801qka.170.1614706367704;
        Tue, 02 Mar 2021 09:32:47 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-25-174-95-95-253.dsl.bell.ca. [174.95.95.253])
        by smtp.gmail.com with ESMTPSA id o79sm5803300qka.116.2021.03.02.09.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 09:32:47 -0800 (PST)
Date:   Tue, 2 Mar 2021 12:32:43 -0500
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Murilo Opsfelder Araujo <muriloo@linux.ibm.com>,
        Greg Kurz <groug@kaod.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Igor Kotrasinski <i.kotrasinsk@partner.samsung.com>,
        Juan Quintela <quintela@redhat.com>,
        Stefan Weil <sw@weilnetz.de>, Thomas Huth <thuth@redhat.com>,
        kvm@vger.kernel.org, qemu-s390x@nongnu.org
Subject: Re: [PATCH v1 7/9] memory: introduce RAM_NORESERVE and wire it up in
 qemu_ram_mmap()
Message-ID: <20210302173243.GM397383@xz-x1>
References: <20210209134939.13083-1-david@redhat.com>
 <20210209134939.13083-8-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210209134939.13083-8-david@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 09, 2021 at 02:49:37PM +0100, David Hildenbrand wrote:
> @@ -899,13 +899,17 @@ int kvm_s390_mem_op_pv(S390CPU *cpu, uint64_t offset, void *hostbuf,
>   * to grow. We also have to use MAP parameters that avoid
>   * read-only mapping of guest pages.
>   */
> -static void *legacy_s390_alloc(size_t size, uint64_t *align, bool shared)
> +static void *legacy_s390_alloc(size_t size, uint64_t *align, bool shared,
> +                               bool noreserve)
>  {
>      static void *mem;
>  
>      if (mem) {
>          /* we only support one allocation, which is enough for initial ram */
>          return NULL;
> +    } else if (noreserve) {
> +        error_report("Skipping reservation of swap space is not supported.");
> +        return NULL

Semicolon missing.

>      }
>  
>      mem = mmap((void *) 0x800000000ULL, size,
> diff --git a/util/mmap-alloc.c b/util/mmap-alloc.c
> index b50dc86a3c..bb99843106 100644
> --- a/util/mmap-alloc.c
> +++ b/util/mmap-alloc.c
> @@ -20,6 +20,7 @@
>  #include "qemu/osdep.h"
>  #include "qemu/mmap-alloc.h"
>  #include "qemu/host-utils.h"
> +#include "qemu/error-report.h"
>  
>  #define HUGETLBFS_MAGIC       0x958458f6
>  
> @@ -174,12 +175,18 @@ void *qemu_ram_mmap(int fd,
>                      size_t align,
>                      bool readonly,
>                      bool shared,
> -                    bool is_pmem)
> +                    bool is_pmem,
> +                    bool noreserve)

Maybe at some point we should use flags too here to cover all bools.

Thanks,

-- 
Peter Xu

