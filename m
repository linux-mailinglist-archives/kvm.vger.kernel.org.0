Return-Path: <kvm+bounces-59528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 08349BBE25C
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 15:12:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C18431890868
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 13:13:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DBAA29ACC5;
	Mon,  6 Oct 2025 13:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XjrA3kAV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E31C287268
	for <kvm@vger.kernel.org>; Mon,  6 Oct 2025 13:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759756365; cv=none; b=COtddJagdMw6wb1/BW9QzraN5QbKMaa5+FfQAdWv0JiYWKMWXVQZCvp/YB0eUpa7s5CQ6dnXareo4/6vLu57qPkPivqmRpNJpjo26liYZv7qrG1JR89eY6hrGhxU7G8Pm8dJbHRSbdnqgCH51ONUXELHzi0f0ksQZK5kaUAPAAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759756365; c=relaxed/simple;
	bh=yskX3JgtVUUTAxM0KztumOdDh/LhzGguzkHwtIBnXWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EqWI4ft30eTCrHoFis5QESSpXNxEPhIZgLlXJVahG07npurYsC6k3XSkeLbcNO4loGA9045gP9CDG7F8OUGd0DblHI8BoTpkYQrk0vGdwQK7wEBDy//9m6qdUEgX8QqGwh5DCc9IO4brdYTC92AIvT4CokjYF9n/UgOvwIt6O+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XjrA3kAV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759756363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bZX5X7NZc+e0nNEzSVMGJer7k1nFPtWQz0KM+RWSTz4=;
	b=XjrA3kAVH1QITmq0Y4MmudbhSOESxK5Dyh3yKjzzVkzht77UEtpTruS4MiCz2nTVWD5MG6
	DZaHxL0dixRUwNijeGS9EpMaAnrYJlXVMlm/5jQ7s+BYDv7DTZLyQWHJfQJ+X0AdNxxLDk
	KG0eFPTb1l3sqirqxLZoReP1gfQBsMo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-426-Y5geIkDxMKGVm4epg2xpAw-1; Mon, 06 Oct 2025 09:12:40 -0400
X-MC-Unique: Y5geIkDxMKGVm4epg2xpAw-1
X-Mimecast-MFC-AGG-ID: Y5geIkDxMKGVm4epg2xpAw_1759756360
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e4cc8ed76so20126875e9.1
        for <kvm@vger.kernel.org>; Mon, 06 Oct 2025 06:12:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759756359; x=1760361159;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bZX5X7NZc+e0nNEzSVMGJer7k1nFPtWQz0KM+RWSTz4=;
        b=KnUTItng4O/q9zS996+9InRfeit5fChcAGODElxHoe8Ilyf5CWylrcIwLhTE3rsMwT
         ETtvPP+ZY2APwntcGrj4iARrw0mkpZPewJFyt8AkyBw7mavOdrohG8mipFsd4dB2HRws
         xlJgWqELV6It9zHthGZ3pXR19gJOwllnjrVtF7mbe5I4lEijl1ez68HnW9h9OMIJGjfr
         p2SxCAZhXodhhu+xzVrm6khlJW9q1zBTFnS7HdGJJNV3D1kO28Jy2jNDGUx0j/NJZHR/
         KLTzM05TnIZptUzBdlZfNrKvcXX56DIhHGD0BeeLsjl6LL3apmE8BiGIYhFIxEzIp1xk
         v9wQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrKhuahezX4eo2nVTJwmb2+LtFyl0M1eyIcxQnr6r/xWxRkrkXWdqe2SpUuQdKVqXTDoE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdOYsyQCu4MNQ3ZKqnHkXLbWOsfUgdx78APsrOBvq/RrTMLz7j
	uX+xxa6r2J64dj1eaS8eg6G9gpMTBKO/TxWh3AaOP33mGH0NOWTM/Gtmc8pEYX8gynU9np44u4Z
	oWJIx3o2SOrDtipR7Pb7hKofuUCp8NNb136ByOKuYtjD+YwQjXQeGsg==
X-Gm-Gg: ASbGncuM4irMuF05/SVSgxMuF0Uf27lZ1I3HdJkV1KCYT8QqedxZgQKTTBKVFqeQZR3
	hn763U0V6iXO+Xn8foTSGEQEaDISk9uUx7L0wr4Ju0tmxNc1bhD3tzZUzqkSyVz7oCsMXvfI95m
	jNOk/UzJLrmGsH5uKIa2In+em06wpWNZF1Q2VkMhKb8uarlFIWxPlwLbYNO4aiWwdgu7CskHZjv
	6xUEoK4FctdFnAy0sCRLwLjPDFTS1bNVBcYcicY4LwLFLn+i/VfZuIKIjsCuJv712piA2MRUyDm
	gaqygq7MtVA4JNERG3jgqiNjKI9M6rupKsihhDQ=
X-Received: by 2002:a05:600d:13:b0:46e:41e6:28c7 with SMTP id 5b1f17b1804b1-46e714acf6amr68095545e9.8.1759756359393;
        Mon, 06 Oct 2025 06:12:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2qtW3lG+TMWoe50L45Fy1tpw8PbsSTr5Yr+/xRjZfuwDK3WBPkcZEhGMwJ1550s57H0s02w==
X-Received: by 2002:a05:600d:13:b0:46e:41e6:28c7 with SMTP id 5b1f17b1804b1-46e714acf6amr68095195e9.8.1759756358900;
        Mon, 06 Oct 2025 06:12:38 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1518:6900:b69a:73e1:9698:9cd3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8e9719sm21219952f8f.31.2025.10.06.06.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 06:12:38 -0700 (PDT)
Date: Mon, 6 Oct 2025 09:12:34 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Nicholas Piggin <npiggin@gmail.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>, qemu-arm@nongnu.org,
	Jagannathan Raman <jag.raman@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	=?iso-8859-1?Q?C=E9dric?= Le Goater <clg@redhat.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Peter Maydell <peter.maydell@linaro.org>, qemu-ppc@nongnu.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, qemu-s390x@nongnu.org,
	Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH 06/25] hw: Remove unnecessary 'system/ram_addr.h' header
Message-ID: <20251006091227-mutt-send-email-mst@kernel.org>
References: <20251001082127.65741-1-philmd@linaro.org>
 <20251001082127.65741-7-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251001082127.65741-7-philmd@linaro.org>

On Wed, Oct 01, 2025 at 10:21:06AM +0200, Philippe Mathieu-Daudé wrote:
> None of these files require definition exposed by "system/ram_addr.h",
> remove its inclusion.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  hw/ppc/spapr.c                    | 1 -
>  hw/ppc/spapr_caps.c               | 1 -
>  hw/ppc/spapr_pci.c                | 1 -
>  hw/remote/memory.c                | 1 -
>  hw/remote/proxy-memory-listener.c | 1 -
>  hw/s390x/s390-virtio-ccw.c        | 1 -
>  hw/vfio/spapr.c                   | 1 -
>  hw/virtio/virtio-mem.c            | 1 -
>  8 files changed, 8 deletions(-)
> 
> diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
> index eb22333404d..15d09ef9618 100644
> --- a/hw/ppc/spapr.c
> +++ b/hw/ppc/spapr.c
> @@ -77,7 +77,6 @@
>  #include "hw/virtio/virtio-scsi.h"
>  #include "hw/virtio/vhost-scsi-common.h"
>  
> -#include "system/ram_addr.h"
>  #include "system/confidential-guest-support.h"
>  #include "hw/usb.h"
>  #include "qemu/config-file.h"
> diff --git a/hw/ppc/spapr_caps.c b/hw/ppc/spapr_caps.c
> index f2f5722d8ad..0f94c192fd4 100644
> --- a/hw/ppc/spapr_caps.c
> +++ b/hw/ppc/spapr_caps.c
> @@ -27,7 +27,6 @@
>  #include "qapi/error.h"
>  #include "qapi/visitor.h"
>  #include "system/hw_accel.h"
> -#include "system/ram_addr.h"
>  #include "target/ppc/cpu.h"
>  #include "target/ppc/mmu-hash64.h"
>  #include "cpu-models.h"
> diff --git a/hw/ppc/spapr_pci.c b/hw/ppc/spapr_pci.c
> index 1ac1185825e..f9095552e86 100644
> --- a/hw/ppc/spapr_pci.c
> +++ b/hw/ppc/spapr_pci.c
> @@ -34,7 +34,6 @@
>  #include "hw/pci/pci_host.h"
>  #include "hw/ppc/spapr.h"
>  #include "hw/pci-host/spapr.h"
> -#include "system/ram_addr.h"
>  #include <libfdt.h>
>  #include "trace.h"
>  #include "qemu/error-report.h"
> diff --git a/hw/remote/memory.c b/hw/remote/memory.c
> index 00193a552fa..8195aa5fb83 100644
> --- a/hw/remote/memory.c
> +++ b/hw/remote/memory.c
> @@ -11,7 +11,6 @@
>  #include "qemu/osdep.h"
>  
>  #include "hw/remote/memory.h"
> -#include "system/ram_addr.h"
>  #include "qapi/error.h"
>  
>  static void remote_sysmem_reset(void)
> diff --git a/hw/remote/proxy-memory-listener.c b/hw/remote/proxy-memory-listener.c
> index 30ac74961dd..e1a52d24f0b 100644
> --- a/hw/remote/proxy-memory-listener.c
> +++ b/hw/remote/proxy-memory-listener.c
> @@ -12,7 +12,6 @@
>  #include "qemu/range.h"
>  #include "system/memory.h"
>  #include "exec/cpu-common.h"
> -#include "system/ram_addr.h"
>  #include "qapi/error.h"
>  #include "qemu/error-report.h"
>  #include "hw/remote/mpqemu-link.h"
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index d0c6e80cb05..ad2c48188a8 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -13,7 +13,6 @@
>  
>  #include "qemu/osdep.h"
>  #include "qapi/error.h"
> -#include "system/ram_addr.h"
>  #include "system/confidential-guest-support.h"
>  #include "hw/boards.h"
>  #include "hw/s390x/sclp.h"
> diff --git a/hw/vfio/spapr.c b/hw/vfio/spapr.c
> index 8d9d68da4ec..0f23681a3f9 100644
> --- a/hw/vfio/spapr.c
> +++ b/hw/vfio/spapr.c
> @@ -17,7 +17,6 @@
>  
>  #include "hw/vfio/vfio-container-legacy.h"
>  #include "hw/hw.h"
> -#include "system/ram_addr.h"
>  #include "qemu/error-report.h"
>  #include "qapi/error.h"
>  #include "trace.h"
> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index 1de2d3de521..15ba6799f22 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -25,7 +25,6 @@
>  #include "hw/virtio/virtio-mem.h"
>  #include "qapi/error.h"
>  #include "qapi/visitor.h"
> -#include "system/ram_addr.h"
>  #include "migration/misc.h"
>  #include "hw/boards.h"
>  #include "hw/qdev-properties.h"
> -- 
> 2.51.0


