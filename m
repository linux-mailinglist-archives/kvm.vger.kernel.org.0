Return-Path: <kvm+bounces-53754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE5A9B167DA
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 22:56:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2413584CC0
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 20:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EFCA21CC56;
	Wed, 30 Jul 2025 20:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KZsGpuvW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF46E10F1
	for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 20:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753908986; cv=none; b=bmo+cg7lrdgJ3VE10ZPqiZfhB5SNJbBDfw6lUvjgB8TrBBVvYbG3Vu5Gxobz9pYVMxtELoMOlwf06wrFFUAtJ6Z7MkDxMW3gRCzIHpZgr+cW3F2zmwvCAT+9cMNywfLtC3aVtYBHXT04SMWg+Q/AfQnmUo0JnjCaDC0NpDHN49g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753908986; c=relaxed/simple;
	bh=1RiTgh+rTp729fP0HyFkiy+QB1Ho5fTFXxtMbL6veCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BeclzLXUPGDn2F4BOx9dh79lfFHvaQ8nTf6TXX8ApI4pzO79kjdiShwFoc9pV2HZYOsBLYjhU2w8Mfum5IsP+pBQewElVvZfDjAuMrlv8CXHMjj2Uf8bW64mzaGE9+brQwE111I9xGOurdYtvUQ+twzDG6N7KxOmvrZXsDFuN9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KZsGpuvW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753908983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y5ShZ7n03wwuwmSOflEobOlr4/7+D8Iqn53Z9UWW4Cc=;
	b=KZsGpuvWSoa0RHG665BkIdH8YLEtdCWm4XmaIlGPtMMCspKpicOLFv8vErZ2ktfKMVsUoh
	Rjd3B+WBVd8+Xd1nLPVFKW2f6+ZcU6iyPIpu/6RLPHKHueWj20SEdKlPR2xdYZye6avmzX
	Q+dzuSdhg+4X+AXS6lw26L1VSW2nXTY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-3SJpCvZhOfCfWvwvUA9Jyg-1; Wed, 30 Jul 2025 16:56:22 -0400
X-MC-Unique: 3SJpCvZhOfCfWvwvUA9Jyg-1
X-Mimecast-MFC-AGG-ID: 3SJpCvZhOfCfWvwvUA9Jyg_1753908982
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4ab5d2f4f29so3545161cf.1
        for <kvm@vger.kernel.org>; Wed, 30 Jul 2025 13:56:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753908981; x=1754513781;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y5ShZ7n03wwuwmSOflEobOlr4/7+D8Iqn53Z9UWW4Cc=;
        b=VatNm84nbc7UPiUsNEAgaE+IewrDM4i7OyGlkK3+J7rsEvBi+ORwtWDr0NcTNu5fEo
         cFyTeIlVlFfSq6OtOelXP3VKA57MEhFaARZ0fPzErU4P0f+g9fX/WTV939pd12WCX73p
         app4/MkAzyYhfwh5BVDbS1opwtKAoZ3tOWzHHU1PiMg5k/lkVumtVAzrhYyzNMwccjii
         JWj5Dm42yQdt/rBa5IERhYI7S0RvvNqhY/RMX5beVhmuXR6GxdvA1MyXsnTrzTvAHovQ
         Z4aYUan8/RMI1mzaxX7aBIAYqp3YrntvUH490KODdUW+jdBCMxJDObaCWu43xJOS7Yfn
         z7RA==
X-Gm-Message-State: AOJu0YzGkn3xncEiwli1KjVa27NH0+j0n3fDWrANjH6EtGyikkVoSBu/
	0dpKGgJ9ON4s2b7ReqO5pHvRMwT5hkAgz2CoWGqHmciyKn2rvcwfB+hL9n8G+LgosipYSUN41AH
	pBY4olBHB5d5DrE1GdgTMvdter/vokdjfyG//NTnG/7hJ5KeJ/pKxzQ==
X-Gm-Gg: ASbGncse65/zpEBI8uZRmqZ8q17YmomZ6ciktuDponKczFjWun3haLWt61KpabWwRG5
	PBmkEEeLzkbL4R5qy1Ja4zQCtDPCw+1pHrGy+eJNT8YjBIhy4RzAarKe0N7v6XGdSYte2uz4mpq
	30Dl2RiDW92a+2kt3O1S/LDRPj8tu5snk2wC3mIkSIlXvtwRyWRK5zRGQsQcWnBl0j0BMvlq19E
	gAVxMGIGVSPMrMd/WG14IAsCTqI8gUdRoQUX/9dU1ydXJ0vXF7QfxJ1+XaPBwklXNbZFtndOS6t
	9YnlNXqnctx5x42rCPes2Wq6e7i1kxQsdKGAoNv0Nkx9UNxlcyhuSyS6qIk8K54JtfHO932H4VL
	CKf7e+wMvbEbnk+sAClgn2w==
X-Received: by 2002:a05:622a:1a01:b0:4ab:377c:b6be with SMTP id d75a77b69052e-4aedb99f6e9mr67514131cf.22.1753908981475;
        Wed, 30 Jul 2025 13:56:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEtAu3dK6KP1W8+5QfFoT3RKxYzS3jPAS7B5XNWZJrJUfrzY4CTFXAhRQmORe4LYPeBsjxFIw==
X-Received: by 2002:a05:622a:1a01:b0:4ab:377c:b6be with SMTP id d75a77b69052e-4aedb99f6e9mr67513761cf.22.1753908980808;
        Wed, 30 Jul 2025 13:56:20 -0700 (PDT)
Received: from x1.local (bras-base-aurron9134w-grc-11-174-89-135-171.dsl.bell.ca. [174.89.135.171])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4aeeebdc99asm1065221cf.12.2025.07.30.13.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 13:56:20 -0700 (PDT)
Date: Wed, 30 Jul 2025 16:56:18 -0400
From: Peter Xu <peterx@redhat.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 3/5] x86: move USERBASE to 32Mb in
 smap/pku/pks tests
Message-ID: <aIqG8nAB2kaH3Mjg@x1.local>
References: <20250725095429.1691734-1-imammedo@redhat.com>
 <20250725095429.1691734-4-imammedo@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250725095429.1691734-4-imammedo@redhat.com>

On Fri, Jul 25, 2025 at 11:54:27AM +0200, Igor Mammedov wrote:
> If number of CPUs is increased up to 2048, it will push
> available pages above 16Mb range and make smap/pku/pks
> tests fail with 'Could not reserve memory' error.
> 
> Move pages used by tests to 32Mb to fix it.
> 
> Signed-off-by: Igor Mammedov <imammedo@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

> ---
>  x86/pks.c  | 2 +-
>  x86/pku.c  | 2 +-
>  x86/smap.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/x86/pks.c b/x86/pks.c
> index f4d6ac83..9b9519ba 100644
> --- a/x86/pks.c
> +++ b/x86/pks.c
> @@ -6,7 +6,7 @@
>  #include "x86/msr.h"
>  
>  #define PTE_PKEY_BIT     59
> -#define SUPER_BASE        (1 << 23)
> +#define SUPER_BASE        (2 << 24)

Nitpick: maybe 1<<25 would be easier to read.

Below are some random thoughts when reading these tests..

I'm not sure whether I understand them correctly here: all of them so far
depend on the "test" var present in the .bss section, and they all assumed
that the var's physical address (likely together with the whole .bss) will
be under SUPER_BASE after loaded in the VM.

Based on that, there's yet another restriction versus the need to reserve
(SUPER_BASE, SUPER_BASE*2), because the tests want to map the same (0,
SUPER_BASE) memory twice in that virtual address range, so here the tests
do not really need the phys pages in the back but kind of a way to reserve
virtual addresses..

Instead of these tricks, I wonder whether we can do alloc_page() once, then
put the test var on the page allocated.  Then we can build the required
PKU/PKS/SMAP special pgtables on top, mapping to the page allocated.  It
should make sure system changes (like growing num_cpus) never affect it
anymore.

That (even if feasible.. or maybe I missed something) can definitely
involve more changes, so not something to ask for on adding the hpet test /
x2apic support.  Just some pure thoughts when reading it..

Thanks,

-- 
Peter Xu


