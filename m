Return-Path: <kvm+bounces-59401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EF23BB3401
	for <lists+kvm@lfdr.de>; Thu, 02 Oct 2025 10:43:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0B6DA4E1708
	for <lists+kvm@lfdr.de>; Thu,  2 Oct 2025 08:43:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E75F22F1FFE;
	Thu,  2 Oct 2025 08:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ls0kbL7m"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FEF2EDD52
	for <kvm@vger.kernel.org>; Thu,  2 Oct 2025 08:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759394422; cv=none; b=l7X2RCcnk/Nmdz1Uu/PIpkseTyzPxhvOKYGxwScVzYbs+ZZdubooIX6LVbwRXxzIIJZ1YzXOeX6fiQahgsUiXXD1WgkHzlFzdgbopl4GOyQtCFK4C5+0e/XO/TGG0R7aRWUUNw5Tv1mb6V4wFAaOjaY/RTuSSJFgKlAI1+GDWyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759394422; c=relaxed/simple;
	bh=/S0N1tUyB0YsBxl7zcszmQ6Ajflanlq7Q8T3R7PPE64=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RqLqz6QsBjox19nIvYfMgdypZBuE5BoGRmE2OcLEOZ63BaEMOLqD2CDsF4XT0lsHMWhyhtG2aY0P8r4mtwOAOW2kIwAGnAGhW7z5tovRh9ecQMx+/pV1LqljlPZ9C/niLqVjKw2ZFp3FyiVpNn0/fSutpxDndvtV0PrOTa8GLds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ls0kbL7m; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759394419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KX6hnvxeCCnZ6hRDH05OcsAuyPKcD7C8RI3OIDmvJjc=;
	b=Ls0kbL7mX42E0PmYk3yT+wWtGpY+efjoO0WK2KEzR91bYlIrjP6c+n2tliFupS2elSWDe+
	1SJvSGpdns6nZyYjtapryQTAX0j+HscJwwYw5s60rpqUsq/05xj63D63so6VcViBIoUBND
	9yKe/8r766rs5J3y4kOaVDTImPUds5I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-IaQ8CKa5MBSsrJvC2LAHDQ-1; Thu, 02 Oct 2025 04:40:17 -0400
X-MC-Unique: IaQ8CKa5MBSsrJvC2LAHDQ-1
X-Mimecast-MFC-AGG-ID: IaQ8CKa5MBSsrJvC2LAHDQ_1759394417
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e509374dcso3129545e9.1
        for <kvm@vger.kernel.org>; Thu, 02 Oct 2025 01:40:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759394417; x=1759999217;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KX6hnvxeCCnZ6hRDH05OcsAuyPKcD7C8RI3OIDmvJjc=;
        b=IK8iHaQykkEoNAWj3LOF0N9iPlmTDDcVl7CNytGAxZfTim9f2UY3sVU6Q7EpkqSgWJ
         EVD826lUYsqe6XH+SmYNyhPh5f8GVqCFAPzzwLeUS+NMWoL1whYooOa9zm4BQ/8tzTbG
         agViuTvOgsgG1t8on6ycqrQraWDOqs7wm5udIp7y3Bkg8LOpH1we166/+1vxvcD0QFpp
         Gpn1qH9VxVEobP1nCd8E2C2LJ3scBlBmKmOfMB5GLXh+94p7K39ZjRvw6X60yHkYZkdh
         aZRi+sFPLY8sDeeLtUQDcuovJlfctnzJM2VhrGurG+C0Ld7oFneCBBRvuiu8K/iS8tLE
         j9mA==
X-Forwarded-Encrypted: i=1; AJvYcCUNv20H7BMVaK5biWSb5ijBkxZV58h7CRlCX9o4/lbHoGp33oSTiUZhR4GZRDOOa0+HAUs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPU8TQ3Nsyit/+Z+yPZGKlxZYyUmImfhv2WwRIZaHId3Hr0wIN
	sL+IcCTjsraXJMuq2Hz9CcpYMuZbIS4KuINiSXiIlq1KpUzoblQ4bwyZKSKlLs+eAsrB4YyIUhs
	BlFZh3IrM3Ym+NtzVrYbDRSFBGGll/M/1uOTiJ/P8Zj4hjRSKrRFfog==
X-Gm-Gg: ASbGncs6mZSZJFslzRqmYxdYPQha4/ysQEA+jK7zJWPbxHtEglFYkMPsHL4ZOM9wjC6
	GEKrv5/vDy63ZvP3PsIHSSV3P8Datzb+zz0d0pBRq6gxqYIJLUNBmAwDvFR9WJXvShiQyM+uSW8
	p8UwUGvnA6GxM65GqVnttd6qXAbc2JpT8zov+CKgpsEbH9uf3rvDSLxWums8nwmLtSdMxD3TuEA
	cxwWFkBgr5UOX1k0n6wqjQGTjzjk02jQQNbYnLkgFO3Lxf6kUkpIN0mCMuuhh6Fuep2q6Hy8tWR
	PSg55a2BeUren5dEU3IXcedLB8fXv228SowROCp4ewjxLhXgTtMOBy/anyEPXKcnqR0X0O0EATs
	d48ixBF1y
X-Received: by 2002:a05:600c:8409:b0:46e:3c29:ce9d with SMTP id 5b1f17b1804b1-46e638352e4mr32046835e9.32.1759394416463;
        Thu, 02 Oct 2025 01:40:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEtxHXgYBGXB2JTLZZGo2ktNkOy9ap+Noum+ElY79GzzWjdkFzY8dnbpI0zUJwf1WnJ9gH34g==
X-Received: by 2002:a05:600c:8409:b0:46e:3c29:ce9d with SMTP id 5b1f17b1804b1-46e638352e4mr32046395e9.32.1759394415902;
        Thu, 02 Oct 2025 01:40:15 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:576b:abc6:6396:ed4a? ([2a01:e0a:280:24f0:576b:abc6:6396:ed4a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e61a18b76sm73145385e9.18.2025.10.02.01.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Oct 2025 01:40:15 -0700 (PDT)
Message-ID: <fa94f9ae-8448-425d-b911-4c998d265651@redhat.com>
Date: Thu, 2 Oct 2025 10:40:14 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 18/18] system/physmem: Extract API out of
 'system/ram_addr.h' header
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Jagannathan Raman <jag.raman@oracle.com>, qemu-ppc@nongnu.org,
 Ilya Leoshkevich <iii@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 Jason Herne <jjherne@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
 kvm@vger.kernel.org, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Halil Pasic <pasic@linux.ibm.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Elena Ufimtseva <elena.ufimtseva@oracle.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, Fabiano Rosas <farosas@suse.de>,
 Eric Farman <farman@linux.ibm.com>, qemu-arm@nongnu.org,
 qemu-s390x@nongnu.org, David Hildenbrand <david@redhat.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>
References: <20251001175448.18933-1-philmd@linaro.org>
 <20251001175448.18933-19-philmd@linaro.org>
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Content-Language: en-US, fr
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20251001175448.18933-19-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/1/25 19:54, Philippe Mathieu-Daudé wrote:
> Very few files use the Physical Memory API. Declare its
> methods in their own header: "system/physmem.h".
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
>   MAINTAINERS                 |  1 +
>   include/system/physmem.h    | 54 +++++++++++++++++++++++++++++++++++++
>   include/system/ram_addr.h   | 40 ---------------------------
>   accel/kvm/kvm-all.c         |  2 +-
>   accel/tcg/cputlb.c          |  1 +
>   hw/vfio/container-legacy.c  |  2 +-
>   hw/vfio/container.c         |  1 +
>   hw/vfio/listener.c          |  1 -
>   migration/ram.c             |  1 +
>   system/memory.c             |  1 +
>   system/physmem.c            |  1 +
>   target/arm/tcg/mte_helper.c |  2 +-
>   12 files changed, 63 insertions(+), 44 deletions(-)
>   create mode 100644 include/system/physmem.h

for vfio,


Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.


> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 406cef88f0c..9632eb7b440 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3213,6 +3213,7 @@ S: Supported
>   F: include/system/ioport.h
>   F: include/exec/memop.h
>   F: include/system/memory.h
> +F: include/system/physmem.h
>   F: include/system/ram_addr.h
>   F: include/system/ramblock.h
>   F: include/system/memory_mapping.h
> diff --git a/include/system/physmem.h b/include/system/physmem.h
> new file mode 100644
> index 00000000000..879f6eae38b
> --- /dev/null
> +++ b/include/system/physmem.h
> @@ -0,0 +1,54 @@
> +/*
> + * QEMU physical memory interfaces (target independent).
> + *
> + *  Copyright (c) 2003 Fabrice Bellard
> + *
> + * SPDX-License-Identifier: GPL-2.0-or-later
> + */
> +#ifndef QEMU_SYSTEM_PHYSMEM_H
> +#define QEMU_SYSTEM_PHYSMEM_H
> +
> +#include "exec/hwaddr.h"
> +#include "exec/ramlist.h"
> +
> +#define DIRTY_CLIENTS_ALL     ((1 << DIRTY_MEMORY_NUM) - 1)
> +#define DIRTY_CLIENTS_NOCODE  (DIRTY_CLIENTS_ALL & ~(1 << DIRTY_MEMORY_CODE))
> +
> +bool physical_memory_get_dirty_flag(ram_addr_t addr, unsigned client);
> +
> +bool physical_memory_is_clean(ram_addr_t addr);
> +
> +uint8_t physical_memory_range_includes_clean(ram_addr_t start,
> +                                             ram_addr_t length,
> +                                             uint8_t mask);
> +
> +void physical_memory_set_dirty_flag(ram_addr_t addr, unsigned client);
> +
> +void physical_memory_set_dirty_range(ram_addr_t start, ram_addr_t length,
> +                                     uint8_t mask);
> +
> +/*
> + * Contrary to physical_memory_sync_dirty_bitmap() this function returns
> + * the number of dirty pages in @bitmap passed as argument. On the other hand,
> + * physical_memory_sync_dirty_bitmap() returns newly dirtied pages that
> + * weren't set in the global migration bitmap.
> + */
> +uint64_t physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
> +                                            ram_addr_t start,
> +                                            ram_addr_t pages);
> +
> +void physical_memory_dirty_bits_cleared(ram_addr_t start, ram_addr_t length);
> +
> +bool physical_memory_test_and_clear_dirty(ram_addr_t start,
> +                                          ram_addr_t length,
> +                                          unsigned client);
> +
> +DirtyBitmapSnapshot *
> +physical_memory_snapshot_and_clear_dirty(MemoryRegion *mr, hwaddr offset,
> +                                         hwaddr length, unsigned client);
> +
> +bool physical_memory_snapshot_get_dirty(DirtyBitmapSnapshot *snap,
> +                                        ram_addr_t start,
> +                                        ram_addr_t length);
> +
> +#endif
> diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
> index 3894a84fb9c..683485980ce 100644
> --- a/include/system/ram_addr.h
> +++ b/include/system/ram_addr.h
> @@ -19,7 +19,6 @@
>   #ifndef SYSTEM_RAM_ADDR_H
>   #define SYSTEM_RAM_ADDR_H
>   
> -#include "exec/ramlist.h"
>   #include "system/ramblock.h"
>   #include "exec/target_page.h"
>   #include "exec/hwaddr.h"
> @@ -133,43 +132,4 @@ static inline void qemu_ram_block_writeback(RAMBlock *block)
>       qemu_ram_msync(block, 0, block->used_length);
>   }
>   
> -#define DIRTY_CLIENTS_ALL     ((1 << DIRTY_MEMORY_NUM) - 1)
> -#define DIRTY_CLIENTS_NOCODE  (DIRTY_CLIENTS_ALL & ~(1 << DIRTY_MEMORY_CODE))
> -
> -bool physical_memory_get_dirty_flag(ram_addr_t addr, unsigned client);
> -
> -bool physical_memory_is_clean(ram_addr_t addr);
> -
> -uint8_t physical_memory_range_includes_clean(ram_addr_t start,
> -                                                 ram_addr_t length,
> -                                                 uint8_t mask);
> -
> -void physical_memory_set_dirty_flag(ram_addr_t addr, unsigned client);
> -
> -void physical_memory_set_dirty_range(ram_addr_t start, ram_addr_t length,
> -                                         uint8_t mask);
> -
> -/*
> - * Contrary to physical_memory_sync_dirty_bitmap() this function returns
> - * the number of dirty pages in @bitmap passed as argument. On the other hand,
> - * physical_memory_sync_dirty_bitmap() returns newly dirtied pages that
> - * weren't set in the global migration bitmap.
> - */
> -uint64_t physical_memory_set_dirty_lebitmap(unsigned long *bitmap,
> -                                                ram_addr_t start,
> -                                                ram_addr_t pages);
> -
> -void physical_memory_dirty_bits_cleared(ram_addr_t start, ram_addr_t length);
> -
> -bool physical_memory_test_and_clear_dirty(ram_addr_t start,
> -                                              ram_addr_t length,
> -                                              unsigned client);
> -
> -DirtyBitmapSnapshot *physical_memory_snapshot_and_clear_dirty
> -    (MemoryRegion *mr, hwaddr offset, hwaddr length, unsigned client);
> -
> -bool physical_memory_snapshot_get_dirty(DirtyBitmapSnapshot *snap,
> -                                            ram_addr_t start,
> -                                            ram_addr_t length);
> -
>   #endif
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index a7ece7db964..58802f7c3cc 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -32,13 +32,13 @@
>   #include "system/runstate.h"
>   #include "system/cpus.h"
>   #include "system/accel-blocker.h"
> +#include "system/physmem.h"
>   #include "system/ramblock.h"
>   #include "accel/accel-ops.h"
>   #include "qemu/bswap.h"
>   #include "exec/tswap.h"
>   #include "exec/target_page.h"
>   #include "system/memory.h"
> -#include "system/ram_addr.h"
>   #include "qemu/event_notifier.h"
>   #include "qemu/main-loop.h"
>   #include "trace.h"
> diff --git a/accel/tcg/cputlb.c b/accel/tcg/cputlb.c
> index a721235dea6..7214d41cb5d 100644
> --- a/accel/tcg/cputlb.c
> +++ b/accel/tcg/cputlb.c
> @@ -25,6 +25,7 @@
>   #include "accel/tcg/probe.h"
>   #include "exec/page-protection.h"
>   #include "system/memory.h"
> +#include "system/physmem.h"
>   #include "accel/tcg/cpu-ldst-common.h"
>   #include "accel/tcg/cpu-mmu-index.h"
>   #include "exec/cputlb.h"
> diff --git a/hw/vfio/container-legacy.c b/hw/vfio/container-legacy.c
> index eb9911eaeaf..755a407f3e7 100644
> --- a/hw/vfio/container-legacy.c
> +++ b/hw/vfio/container-legacy.c
> @@ -25,7 +25,7 @@
>   #include "hw/vfio/vfio-device.h"
>   #include "system/address-spaces.h"
>   #include "system/memory.h"
> -#include "system/ram_addr.h"
> +#include "system/physmem.h"
>   #include "qemu/error-report.h"
>   #include "qemu/range.h"
>   #include "system/reset.h"
> diff --git a/hw/vfio/container.c b/hw/vfio/container.c
> index 3fb19a1c8ad..9ddec300e35 100644
> --- a/hw/vfio/container.c
> +++ b/hw/vfio/container.c
> @@ -20,6 +20,7 @@
>   #include "qemu/error-report.h"
>   #include "hw/vfio/vfio-container.h"
>   #include "hw/vfio/vfio-device.h" /* vfio_device_reset_handler */
> +#include "system/physmem.h"
>   #include "system/reset.h"
>   #include "vfio-helpers.h"
>   
> diff --git a/hw/vfio/listener.c b/hw/vfio/listener.c
> index b5cefc9395c..c6bb58f5209 100644
> --- a/hw/vfio/listener.c
> +++ b/hw/vfio/listener.c
> @@ -30,7 +30,6 @@
>   #include "hw/vfio/pci.h"
>   #include "system/address-spaces.h"
>   #include "system/memory.h"
> -#include "system/ram_addr.h"
>   #include "hw/hw.h"
>   #include "qemu/error-report.h"
>   #include "qemu/main-loop.h"
> diff --git a/migration/ram.c b/migration/ram.c
> index d09591c0600..12122dda685 100644
> --- a/migration/ram.c
> +++ b/migration/ram.c
> @@ -53,6 +53,7 @@
>   #include "qemu/rcu_queue.h"
>   #include "migration/colo.h"
>   #include "system/cpu-throttle.h"
> +#include "system/physmem.h"
>   #include "system/ramblock.h"
>   #include "savevm.h"
>   #include "qemu/iov.h"
> diff --git a/system/memory.c b/system/memory.c
> index dd045da60c0..80656c69568 100644
> --- a/system/memory.c
> +++ b/system/memory.c
> @@ -25,6 +25,7 @@
>   #include "qemu/target-info.h"
>   #include "qom/object.h"
>   #include "trace.h"
> +#include "system/physmem.h"
>   #include "system/ram_addr.h"
>   #include "system/kvm.h"
>   #include "system/runstate.h"
> diff --git a/system/physmem.c b/system/physmem.c
> index 1a075da2bdd..ec3d8027e86 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -43,6 +43,7 @@
>   #include "system/kvm.h"
>   #include "system/tcg.h"
>   #include "system/qtest.h"
> +#include "system/physmem.h"
>   #include "system/ramblock.h"
>   #include "qemu/timer.h"
>   #include "qemu/config-file.h"
> diff --git a/target/arm/tcg/mte_helper.c b/target/arm/tcg/mte_helper.c
> index 077ff4b2b2c..b96c953f809 100644
> --- a/target/arm/tcg/mte_helper.c
> +++ b/target/arm/tcg/mte_helper.c
> @@ -27,7 +27,7 @@
>   #include "user/cpu_loop.h"
>   #include "user/page-protection.h"
>   #else
> -#include "system/ram_addr.h"
> +#include "system/physmem.h"
>   #endif
>   #include "accel/tcg/cpu-ldst.h"
>   #include "accel/tcg/probe.h"


