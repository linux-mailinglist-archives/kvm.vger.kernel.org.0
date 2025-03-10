Return-Path: <kvm+bounces-40609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C438A58E25
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 09:29:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A352188BA07
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:29:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADEE222332E;
	Mon, 10 Mar 2025 08:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LHghJ/5Y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D35223324
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741595346; cv=none; b=u9UZ2jGS3Sf5BFb82DALEV0SFFWpUousHTyDQjV51SvM1nSQFdHUY9jo4/yOSIW6DyhXbxWV8j3+Vt3aBVt7gahFvHaQkQBcTjJuZOJaQI3LwUM0zNImSK8qhw+EFaI6L9+2aDktr9SCrSps7QvDlGja30PN44z7axBhQwq6u8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741595346; c=relaxed/simple;
	bh=j8uSbqvmFRElsn1j+HWyIIUi7sQHiMwq1iy6KnIMsR4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p4xXq+MdU6uhO+TqUuqz3/YLGuai79QWr4tEv4fyBZ1AxoMXZ610YFuJLEsmsPk8Yi9jox7d6JjRi73jMquMbQFkvu41ngIQAVKnBgFfrGQMXcsg9V8sWld5l8w3uOU49doJSvI4TZLrFb+6n5j3mvg/S4a/B0WQmqHVYTbtcpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LHghJ/5Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741595344;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oVjbBJxeizQKwyH9IYKCuRHaFa6Vx3kvMheG1OPh2D4=;
	b=LHghJ/5YHR7b/gEoj/v+/nkfGpYfL7wTxTFIjT/RbK17vlKSFWbi2I5pDBOBQagCh/uLS+
	9023chcCZIXMixN6TCJGbkZWaGNqnqVY/gN3KKzXZoPKqFsVg7QAFPETVuI/1A8zyepHdL
	e1YblVw3DLbmJ/bAbMC/ser+OFRW9E4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-tycDYTPXOUGNoXwulK_KtA-1; Mon, 10 Mar 2025 04:29:02 -0400
X-MC-Unique: tycDYTPXOUGNoXwulK_KtA-1
X-Mimecast-MFC-AGG-ID: tycDYTPXOUGNoXwulK_KtA_1741595341
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3912b54611dso2379166f8f.1
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 01:29:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741595341; x=1742200141;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oVjbBJxeizQKwyH9IYKCuRHaFa6Vx3kvMheG1OPh2D4=;
        b=Jxdj0FmB+HbMADfNN9jQV314sOnY/+DiEQUXkh6Yt/AW/aI6JTXLIPATFsI2KTEuf3
         wWegDv2ukZvmjeyvNzBLoQbMedoqvAcH3UC5uuwwpuLjl8d4BZNXEzUe/+UKWoBoIkzm
         Fu3PJNUiK6F7b0s8c4zpP7f+MZsEGMjUJ5jEYkqBbgXFGdbtHcFwCjxW7MOeVIM9mw6G
         M1aWNNKQhujOTEWMId9M4IUia2TQRu06zs5lDJrPOkeD85aNWdrw4/sFvYInudiOCV64
         s3WchgOXQJpe1Zh7elIoEYypKha7Bc8U9ChVE2NrXOSvU7KrYHph/8FjueOPzZ7XEPTD
         MvVQ==
X-Forwarded-Encrypted: i=1; AJvYcCW32dCP4B15I9QGV0XnNVgjI3jrV2NwwGXT3Z54R5coTZ3SSURsINYGCmwBJya9JPzM2JQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjYPhh5NOrFwHhR+38MtOir10WflBaABdm/DbXM1C712quzuaH
	5ZCv9l4KIiqErI9voQcOR6sVQWu7nbAKJ3Ad9n7sDV8rhPXaXLThTEIZQkVb6PNcclj4OM9TkUD
	VjO4SsxrbbwlLEgNHUSc+zQdRa1WyJ21u4/d4jiNIjpQZkEHYoA==
X-Gm-Gg: ASbGncuy9EvLFin6vHv1gJsPUubkL/m49Mh1F5tzBnYKBs9QvGLwzijr9PKG+QdtNbI
	ojXYFf6tzmD72lMLjWN2WEw00ZuVshUrbmzhfBPUufvD8vQDWXAfHW15lWqSC1B3fZKx/QV8lpO
	+6m3aSiWCrEPQ9wFBUsRy8EwZuywqmhXV7EqzguWdTUfxFD8G1xHs9PWLXhifQHDk/qUOEUZUtd
	QSlHkMCg/KzQXlPmAG1N0tdAxXXaLFYc73KjEHyVHcNjJjOPRlCu5hQpGpQdVVyPIpUAt0SUip6
	sie3qoNb5vZJA8rW3qeuAEKDvvMXdzK2nwIDqyNjdiDVi1TrB6jhWPFqYbYmSUY=
X-Received: by 2002:a05:6000:1564:b0:390:e7c1:59c0 with SMTP id ffacd0b85a97d-39132d7b834mr7461709f8f.26.1741595341273;
        Mon, 10 Mar 2025 01:29:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/fGEoXcdfMlt63beLE5rNQAhJ3draZYtFDcErJMWsY/uZoh4ZX9iQIidqn0/hJZ55v0WD7Q==
X-Received: by 2002:a05:6000:1564:b0:390:e7c1:59c0 with SMTP id ffacd0b85a97d-39132d7b834mr7461682f8f.26.1741595340861;
        Mon, 10 Mar 2025 01:29:00 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfb7ae4sm13782577f8f.5.2025.03.10.01.28.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Mar 2025 01:29:00 -0700 (PDT)
Message-ID: <cbaf536a-e182-40c7-9517-803b9035bbc7@redhat.com>
Date: Mon, 10 Mar 2025 09:28:56 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 06/21] system: Declare qemu_[min/max]rampagesize() in
 'system/hostmem.h'
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Yi Liu <yi.l.liu@intel.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Tony Krowiak <akrowiak@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
 Halil Pasic <pasic@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 David Hildenbrand <david@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Tomita Moeko
 <tomitamoeko@gmail.com>, qemu-ppc@nongnu.org,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Eric Farman <farman@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>,
 Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
 Zhenzhong Duan <zhenzhong.duan@intel.com>, qemu-s390x@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 Jason Herne <jjherne@linux.ibm.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Richard Henderson <richard.henderson@linaro.org>
References: <20250308230917.18907-1-philmd@linaro.org>
 <20250308230917.18907-7-philmd@linaro.org>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250308230917.18907-7-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit




On 3/9/25 12:09 AM, Philippe Mathieu-Daudé wrote:
> Both qemu_minrampagesize() and qemu_maxrampagesize() are
> related to host memory backends, having the following call
> stack:
>
>   qemu_minrampagesize()
>      -> find_min_backend_pagesize()
>          -> object_dynamic_cast(obj, TYPE_MEMORY_BACKEND)
>
>   qemu_maxrampagesize()
>      -> find_max_backend_pagesize()
>         -> object_dynamic_cast(obj, TYPE_MEMORY_BACKEND)
>
> Having TYPE_MEMORY_BACKEND defined in "system/hostmem.h":
>
>   include/system/hostmem.h:23:#define TYPE_MEMORY_BACKEND "memory-backend"
>
> Move their prototype declaration to "system/hostmem.h".
>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  include/exec/ram_addr.h    | 3 ---
>  include/system/hostmem.h   | 3 +++
>  hw/ppc/spapr_caps.c        | 1 +
>  hw/s390x/s390-virtio-ccw.c | 1 +
>  hw/vfio/spapr.c            | 1 +
>  5 files changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/include/exec/ram_addr.h b/include/exec/ram_addr.h
> index 94bb3ccbe42..ccc8df561af 100644
> --- a/include/exec/ram_addr.h
> +++ b/include/exec/ram_addr.h
> @@ -101,9 +101,6 @@ static inline unsigned long int ramblock_recv_bitmap_offset(void *host_addr,
>  
>  bool ramblock_is_pmem(RAMBlock *rb);
>  
> -long qemu_minrampagesize(void);
> -long qemu_maxrampagesize(void);
> -
>  /**
>   * qemu_ram_alloc_from_file,
>   * qemu_ram_alloc_from_fd:  Allocate a ram block from the specified backing
> diff --git a/include/system/hostmem.h b/include/system/hostmem.h
> index 5c21ca55c01..62642e602ca 100644
> --- a/include/system/hostmem.h
> +++ b/include/system/hostmem.h
> @@ -93,4 +93,7 @@ bool host_memory_backend_is_mapped(HostMemoryBackend *backend);
>  size_t host_memory_backend_pagesize(HostMemoryBackend *memdev);
>  char *host_memory_backend_get_name(HostMemoryBackend *backend);
>  
> +long qemu_minrampagesize(void);
> +long qemu_maxrampagesize(void);
> +
>  #endif
> diff --git a/hw/ppc/spapr_caps.c b/hw/ppc/spapr_caps.c
> index 904bff87ce1..9e53d0c1fd1 100644
> --- a/hw/ppc/spapr_caps.c
> +++ b/hw/ppc/spapr_caps.c
> @@ -34,6 +34,7 @@
>  #include "kvm_ppc.h"
>  #include "migration/vmstate.h"
>  #include "system/tcg.h"
> +#include "system/hostmem.h"
>  
>  #include "hw/ppc/spapr.h"
>  
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 51ae0c133d8..1261d93b7ce 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -41,6 +41,7 @@
>  #include "hw/s390x/tod.h"
>  #include "system/system.h"
>  #include "system/cpus.h"
> +#include "system/hostmem.h"
>  #include "target/s390x/kvm/pv.h"
>  #include "migration/blocker.h"
>  #include "qapi/visitor.h"
> diff --git a/hw/vfio/spapr.c b/hw/vfio/spapr.c
> index 9b5ad05bb1c..1a5d1611f2c 100644
> --- a/hw/vfio/spapr.c
> +++ b/hw/vfio/spapr.c
> @@ -12,6 +12,7 @@
>  #include <sys/ioctl.h>
>  #include <linux/vfio.h>
>  #include "system/kvm.h"
> +#include "system/hostmem.h"
>  #include "exec/address-spaces.h"
>  
>  #include "hw/vfio/vfio-common.h"


