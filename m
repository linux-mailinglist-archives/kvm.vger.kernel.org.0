Return-Path: <kvm+bounces-31821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AAE89C7EC7
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 00:28:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E38602825FF
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 23:28:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46D3A18C92C;
	Wed, 13 Nov 2024 23:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OtYPUXVZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC4C18C01F
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 23:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731540506; cv=none; b=hzfeTlCMA3zVqgtI4v7rb1oWwZOZKtexRvxhxPNqZMBLGWq5vtLjbmMJugmkdAa3gVgDng5NMk8wy2tUzfOoLygfLc1O55IGT0H0cEcTsBtevbDvJBLfxlY9MUaCmcwkGNoGZM+ML1zOeMV8efpJO+y83Svxyy46hTcZcqzmwIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731540506; c=relaxed/simple;
	bh=YjU9s9ZaDbxHYGeaV2C6N8/SfLJnNYOE0SEesrqDb04=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tEFuVKkGhFpY2zu7FsW6vxbmDdCvCUrYzcKMl116DZMq4RrEM+WZzzlDgxpjuIAFu/MgkOiuExcjplQpX7EggTB7KV3eBiWChbbt0D7BgIEv0FmwRO215l0dePe399ulch2wQuWQJOvmyrSw+Id4Bm97cICMVtFwyiMopzMrgWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OtYPUXVZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731540503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CByKMOgU0eVBz2mkNWqRqmAJAX+dEHJdylhbZFnmBaU=;
	b=OtYPUXVZNSXA3hHJYAzRy53gGVd39Iq8Moyk8mAzsfvPFD8Fm0P1ZnXqjWk5/Rxs8vCjGi
	mW8h1aa5Px6HD0GpFts/z5PrlgY68nbMBEiCW90TkoOGSbjgX3Sz6p3bvZQq9kSj+NPVjd
	Vfes/Ia6kykDiJugG+0Rgv7Rtydc6RE=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-wiYk0P-VOqCZ2tZqnvLJ9Q-1; Wed, 13 Nov 2024 18:28:22 -0500
X-MC-Unique: wiYk0P-VOqCZ2tZqnvLJ9Q-1
X-Mimecast-MFC-AGG-ID: wiYk0P-VOqCZ2tZqnvLJ9Q
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a71d04b04cso18345ab.1
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 15:28:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731540502; x=1732145302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CByKMOgU0eVBz2mkNWqRqmAJAX+dEHJdylhbZFnmBaU=;
        b=bB9s9JcYZrpsphkwONrioIJ//GNbTvvszNyXTJDM4Vc2ufqW5eAPW1yOVatYWwe13+
         3hLHUT8RP5zDpm1X+poNEophVTyuKzYG1MwNB4jZqkhth77eN+GwWbLUZeDvK6M5QxyD
         e5LdzZ2Jan9FEMavoO64KYcZ1f5wSFDBGnrOuxdLvJu+6btfHmKYZDzUQb39tZqrogc5
         DPGyFsMO1F62l59E8ZQkeh784xbpfrxFEOeHcVKDAkO7ZiFu3G6v4g3erM2MYQooS2rg
         eNT0emQhpzlI+1p577KWtIH6Kg8KaPbX9VzGd0rtr8XkXx/U/pbu6YQx9cIqmRFoMF6E
         WZ0w==
X-Forwarded-Encrypted: i=1; AJvYcCVC0Jsh4M0pvPU5yTWeARFHE++t+J3hR4J6sRrwfxJ0np7e/dBRxdrvCklM13F/LjWQDCw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh2v6LfzLl73kQXfU5h+1JXqBTvvnO3IklKc/EfFGDPO08FsWU
	0t2WVEN6EuRlCtR8613J08ZGIzkvgDrWIHz6rJseFc4kv32rcGxOj06BFNn7u8BVC0l2ioijQhj
	1C62uLVDSFlDod3lwd0OB916RuD790YCSAAPjJZKrywnONah17Q==
X-Gm-Gg: ASbGncuE2ZsD0NVDMedCuu/IMPj/qNHgRupl9oD2AkdxLEwpUW9GjJCLwjrCEabN946
	+2XCh5//awFg1g3LQBuB5H0+ELgfClfcUC4JFJnsLL24WyDZBFJqaUBBSQEEUGG44GdvrC/hZmA
	UEkt58huXOZO4Sn/+F8gFQbS/X3qa/ZzG4pztzqeBVM7pp8J0l4rMjofOp5cCxx46khZStF/BUi
	xv69BM+Oz/Uw3vlBC60WbbnL4XoSYd+1SK4VsyLM+Zd3iy1c6SzDg==
X-Received: by 2002:a05:6602:1355:b0:82a:249e:bdfd with SMTP id ca18e2360f4ac-83e0336c2d5mr666721839f.3.1731540501878;
        Wed, 13 Nov 2024 15:28:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEQTrkqTWB+qDVFYGCr8R0nJM12ERLnPB/kUAvT+bqN4as4eTVubwQThRFN253QDhFxM2PlMw==
X-Received: by 2002:a05:6602:1355:b0:82a:249e:bdfd with SMTP id ca18e2360f4ac-83e0336c2d5mr666720939f.3.1731540501430;
        Wed, 13 Nov 2024 15:28:21 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4deacf3013dsm1296353173.122.2024.11.13.15.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 15:28:20 -0800 (PST)
Date: Wed, 13 Nov 2024 16:28:19 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
 <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
 <parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
 <joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V4 vfio 5/7] vfio/virtio: Add support for the basic live
 migration functionality
Message-ID: <20241113162819.698fd35a.alex.williamson@redhat.com>
In-Reply-To: <20241113115200.209269-6-yishaih@nvidia.com>
References: <20241113115200.209269-1-yishaih@nvidia.com>
	<20241113115200.209269-6-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 13 Nov 2024 13:51:58 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:
> diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
> new file mode 100644
> index 000000000000..a0ce3ec2c734
> --- /dev/null
> +++ b/drivers/vfio/pci/virtio/migrate.c
...
> +static int virtiovf_add_migration_pages(struct virtiovf_data_buffer *buf,
> +					unsigned int npages)
> +{
> +	unsigned int to_alloc = npages;
> +	struct page **page_list;
> +	unsigned long filled;
> +	unsigned int to_fill;
> +	int ret;
> +	int i;
> +
> +	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
> +	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);

checkpatch spots the following:

WARNING: Prefer kvcalloc over kvzalloc with multiply
#416: FILE: drivers/vfio/pci/virtio/migrate.c:71:
+	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);


With your approval I'll update with the following on commit:

diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
index a0ce3ec2c734..4fdf6ca17a3a 100644
--- a/drivers/vfio/pci/virtio/migrate.c
+++ b/drivers/vfio/pci/virtio/migrate.c
@@ -68,7 +68,7 @@ static int virtiovf_add_migration_pages(struct virtiovf_data_buffer *buf,
 	int i;
 
 	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
-	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);
+	page_list = kvcalloc(to_fill, sizeof(*page_list), GFP_KERNEL_ACCOUNT);
 	if (!page_list)
 		return -ENOMEM;
 
Thanks,
Alex


