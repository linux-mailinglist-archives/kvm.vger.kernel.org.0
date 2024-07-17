Return-Path: <kvm+bounces-21793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 244D7934418
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 23:45:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF5B9282F98
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 21:45:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA31D188CC1;
	Wed, 17 Jul 2024 21:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HRM06IAv"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FE1188CA8
	for <kvm@vger.kernel.org>; Wed, 17 Jul 2024 21:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721252672; cv=none; b=mudfR4qQ1wyLJrfIovQxT+sPFlriRynwjmJf7iMiXUf2SzCiWtfukVyZFeusSditaqAVVANrEK+aUhDlAOIH1fw3liGmFSOS8B2lqv/qz9dHU3/DNxHmEyGiGJ9DlBKt/Tiw1uBoi3FAmDIIZ5UCOtf151KTLDRtD2L+SEcbb7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721252672; c=relaxed/simple;
	bh=nm1sn8H+UwA2gzDfCfCPgna/4ZDRkMbtFZ/jJS2k4dY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L9wwebJ1qvpiBHqzRclS6ZUmCU/7z+zN+135N1szMgp88c491G7zNvzxMDuZQ/CybBoQUYpdF0y7NCL6/qbh9MOEtwhOR7WyjGXzoTO9m713c1A6eoGzzYj0g3mORWBcxM6K7s5s9cltgJuJGArUXeF3TsYpnOziDWKaj43Biy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HRM06IAv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721252670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+wjxz20iy8G2qBsoFEZ2vcnJOu/C66k+kPs/38ZB7V8=;
	b=HRM06IAv+K4caEO/Jfu3J0KLvy1sma7fZuNJ/eiSLLdW+Z7kLdsml0JnutnNAbLXeTJUwf
	Lv6QdRo0eO+0EJzlgJ92FLHrx+ao+YLBqmGswXFkA53vnBe2R233DmtclLRFWoHPTv5qfP
	cn4MUS64L9vl+kavou9gA+/+Blg7630=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-0ehJ_mhwOtG96-Hpbads1w-1; Wed, 17 Jul 2024 17:44:28 -0400
X-MC-Unique: 0ehJ_mhwOtG96-Hpbads1w-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7fc9fc043eeso15405539f.3
        for <kvm@vger.kernel.org>; Wed, 17 Jul 2024 14:44:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721252668; x=1721857468;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+wjxz20iy8G2qBsoFEZ2vcnJOu/C66k+kPs/38ZB7V8=;
        b=fv3PSzED6dNK3tcti/uyPCKMmV8y7ei0WuxU8yQ2cElp4RokX5UKEKffdugW5Jg9Iq
         yZiSRWRc5GkIeDi8u08XigKfutLyrPLzFSZRjMiq2dZFuaTBMKQ2f0/joedYWYxSzyv2
         G7K+4rOc6DA0BbXhpPZpD9nZEIjjgp59b1is7WVPI2T57KjdVc2A42GRdqqVlkyhhXfp
         c7IXWJgPouirgkSyjY6BXLqd/qTVP28iaTusvSotHFE9FLAmOn9NZs3KT9tHunqk2KZL
         zd6kUjgKo4BH6nK0iB8fd12i543NRatq4xk83b7N2jiMFPvROI3gMizEiSx1Y347NMcr
         hQSA==
X-Forwarded-Encrypted: i=1; AJvYcCV9NYmYBaLw6uiivj8dbvLFwLTAFnb04oH0zFbhFruQ2Vdzxy43WAdRKR0h4sheBeCiAsHwve7uxfrGE9zyflZ3Q+JZ
X-Gm-Message-State: AOJu0YwyC3O5FkFO+jSCQhCCbcy2i9N/3iCGXxawwJJonSzt9TroViXU
	Een+6MIKrvTacuY0EUBbkFp8uugF+fJjNDG6oQEv+WgTGmfaVn9oP9JBgY+nnumZnLYLSEzHMbF
	6zn/epdI+VLWIOhhicpxqR30Bi3tonfCERInNqgDbdUMlfVg4cA==
X-Received: by 2002:a05:6602:2c92:b0:7f6:20d2:7a96 with SMTP id ca18e2360f4ac-81711e18b30mr344228239f.14.1721252668207;
        Wed, 17 Jul 2024 14:44:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEg3w+Houb1Be8pF3Zf31Isom/zcA7zD4gXvl4BNJsg1iNrkpkV/hEYMiAVNuTjdPIuOyIyVA==
X-Received: by 2002:a05:6602:2c92:b0:7f6:20d2:7a96 with SMTP id ca18e2360f4ac-81711e18b30mr344226539f.14.1721252667843;
        Wed, 17 Jul 2024 14:44:27 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c210ff4c3bsm961063173.171.2024.07.17.14.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jul 2024 14:44:27 -0700 (PDT)
Date: Wed, 17 Jul 2024 15:44:25 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: stable@vger.kernel.org, Ankit Agrawal <ankita@nvidia.com>, Eric Auger
 <eric.auger@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian
 <kevin.tian@intel.com>, Kunwu Chan <chentao@kylinos.cn>, Leah Rumancik
 <leah.rumancik@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, Stefan
 Hajnoczi <stefanha@redhat.com>, Yi Liu <yi.l.liu@intel.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.9 0/3] Backport VFIO refactor to fix fork ordering bug
Message-ID: <20240717154425.43437eea.alex.williamson@redhat.com>
In-Reply-To: <20240717213339.1921530-1-axelrasmussen@google.com>
References: <20240717213339.1921530-1-axelrasmussen@google.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 17 Jul 2024 14:33:36 -0700
Axel Rasmussen <axelrasmussen@google.com> wrote:

> 35e351780fa9 ("fork: defer linking file vma until vma is fully initialized")
> switched the ordering of vm_ops->open() and copy_page_range() on fork. This is a
> bug for VFIO, because it causes two problems:
> 
> 1. Because open() is called before copy_page_range(), the range can conceivably
>    have unmapped 'holes' in it. This causes the code underneath untrack_pfn() to
>    WARN.
> 
> 2. More seriously, open() is trying to guarantee that the entire range is
>    zapped, so any future accesses in the child will result in the VFIO fault
>    handler being called. Because we copy_page_range() *after* open() (and
>    therefore after zapping), this guarantee is violatd.
> 
> We can't revert 35e351780fa9, because it fixes a real bug for hugetlbfs. The fix
> is also not as simple as just reodering open() and copy_page_range(), as Miaohe
> points out in [1]. So, although these patches are kind of large for stable, just
> backport this refactoring which completely sidesteps the issue.
> 
> Note that patch 2 is the key one here which fixes the issue. Patch 1 is a
> prerequisite required for patch 2 to build / work. This would almost be enough,
> but we might see significantly regressed performance. Patch 3 fixes that up,
> putting performance back on par with what it was before.
> 
> Note [1] also has a more full discussion justifying taking these backports.
> 
> [1]: https://lore.kernel.org/all/20240702042948.2629267-1-leah.rumancik@gmail.com/T/
> 
> Alex Williamson (3):
>   vfio: Create vfio_fs_type with inode per device
>   vfio/pci: Use unmap_mapping_range()
>   vfio/pci: Insert full vma on mmap'd MMIO fault
> 
>  drivers/vfio/device_cdev.c       |   7 +
>  drivers/vfio/group.c             |   7 +
>  drivers/vfio/pci/vfio_pci_core.c | 271 ++++++++-----------------------
>  drivers/vfio/vfio_main.c         |  44 +++++
>  include/linux/vfio.h             |   1 +
>  include/linux/vfio_pci_core.h    |   2 -
>  6 files changed, 125 insertions(+), 207 deletions(-)
> 
> --
> 2.45.2.993.g49e7a77208-goog
> 

LGTM

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

Thanks,
Alex


