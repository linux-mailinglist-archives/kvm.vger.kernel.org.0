Return-Path: <kvm+bounces-28258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A07099708F
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:08:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9A63CB25B6C
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AAC81E260F;
	Wed,  9 Oct 2024 15:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UyCr+zvf"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAC7193432
	for <kvm@vger.kernel.org>; Wed,  9 Oct 2024 15:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728488757; cv=none; b=ATawrXsfCM5f8WQR6lPBvJXJJRiUsCFHPjibHw04qw4HrzazgqToFhiWSEzVhohmCnKdXuqaFD/5c/gpQHOwwH2NK+ph0mYQZbkAtORBqiIii6uj0zGnK7XvczaBAFTU69qy/XwzI02A8nj3Ont+X8uhCGuaVKzlizQJ2OjqPKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728488757; c=relaxed/simple;
	bh=iEywXAxSzaEkzTZp/UhC/nTEUAmIjuWflmpvLbptg4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aMx3ryU9PcUF0m1Mv7jkkj5CF44mTKMVldMSLVT0a/rowlMonH2LXo/r4BQGCh3DLIT3d8uiityMmGWUpZWeE0uRuPxfoZ3UOwi6syGIg4xc+dRlrH/S3vjlp8a2lRu7+WvNdH+zvUieXqG+GV1MzY0dYegrc+oQZLiRpNkJYuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UyCr+zvf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728488754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PlzQWPOjYSNkzCN9W8sMelrGptif3yHwA7aQv3qQb94=;
	b=UyCr+zvfArnOmZuG5i3pfcIU+tr+IxDeXsv/J187oZeiSetKN5GPym0Ouu4gFMzRfDHLx0
	8u/DVcdbYhZ8C23VQfvXgsLwfXJ8lVjMHALAuW3C3IZ2UJqqCjOugmHMBO4EZ9POl8OaEP
	PWHAqIamkm0C6ueyfT5P7en6+dWfkVw=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-x3s2VDguOvO1rea0-QKaMQ-1; Wed, 09 Oct 2024 11:45:53 -0400
X-MC-Unique: x3s2VDguOvO1rea0-QKaMQ-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3e27a1f6039so5868727b6e.2
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2024 08:45:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728488752; x=1729093552;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PlzQWPOjYSNkzCN9W8sMelrGptif3yHwA7aQv3qQb94=;
        b=biKADajBMdYsxwL2bZoNBOPnRNLQGNkUCI8M+5a0blDBjAFJPZSYb+UXYfMQqZxDfP
         NGJ/NdrHZAzUvRo1OHrY19iE16CjWkmTK9M0yhkEy2JH2SePJMUybFoyGYtPzzn94u/Z
         /He4aZ8Q+qR6SQi6k0eX5fFvYZz5jxAHbYbbn1s4qvjDwh05hW4KgZCYZwEOqWN8YjEf
         LwFzxbGsUhBbnqAP5YjFVqcvMSyV6u/XWmnLNKThs1i+Iu5/m5TFKxR1cCZ5lyOkUK2u
         aBLsB/sp9/AkZV6yPHAZLF18WHgXutRu6oDZGOI6cM7WsoaHNmdir0QYf8JZKLqSVmkr
         Mh4w==
X-Forwarded-Encrypted: i=1; AJvYcCWpSzwzQB4OdbXSuWxev3Mj+lXhwWHHxVIiSDfFwsPRm8Ou8FVm+z0cuf5A5OlWOR+RKEw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfIQFbF8LP09rl0MYNHsKHahpbQEUjvHT1MN51g8B3A3xDur/c
	j7pkLYZTIfZvall58LIFY/8yma62dUNE+0nv3pfazI1kFqFa9wsq58bw7LrXOGEPSFqQvXd5cYb
	g+HZztdpu6UzaUk/HkOioYsURZ7bcp4wSUn+XQs6Hv7mLzjeHbQ==
X-Received: by 2002:a05:6808:151e:b0:3e3:9721:4ced with SMTP id 5614622812f47-3e3e67463e8mr3310053b6e.40.1728488752447;
        Wed, 09 Oct 2024 08:45:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHR8gQvAV8ArRtq51PGblZVCF4q4BulbMX3U3jI9+d4j+KrG2IxEICdXaQ+KderMMs9CVfK3g==
X-Received: by 2002:a05:6808:151e:b0:3e3:9721:4ced with SMTP id 5614622812f47-3e3e67463e8mr3310012b6e.40.1728488752092;
        Wed, 09 Oct 2024 08:45:52 -0700 (PDT)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7e9f6c46a20sm7429373a12.76.2024.10.09.08.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2024 08:45:51 -0700 (PDT)
Date: Wed, 9 Oct 2024 11:45:47 -0400
From: Peter Xu <peterx@redhat.com>
To: William Roche <william.roche@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, pbonzini@redhat.com,
	philmd@linaro.org, marcandre.lureau@redhat.com, berrange@redhat.com,
	thuth@redhat.com, richard.henderson@linaro.org,
	peter.maydell@linaro.org, mtosatti@redhat.com,
	qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	joao.m.martins@oracle.com
Subject: Re: [RFC RESEND 0/6] hugetlbfs largepage RAS project
Message-ID: <ZwalK7Dq_cf-EA_0@x1n>
References: <20240910090747.2741475-1-william.roche@oracle.com>
 <20240910100216.2744078-1-william.roche@oracle.com>
 <ec3337f7-3906-4a1b-b153-e3d5b16685b6@redhat.com>
 <9f9a975e-3a04-4923-b8a5-f1edbed945e6@oracle.com>
 <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <966bf4bf-6928-44a3-b452-d2847d06bb25@oracle.com>
 <0ef808b0-839d-4078-90cb-d3d56c1f4a71@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0ef808b0-839d-4078-90cb-d3d56c1f4a71@oracle.com>

On Thu, Sep 19, 2024 at 06:52:37PM +0200, William Roche wrote:
> Hello David,
> 
> I hope my last week email answered your interrogations about:
>     - retrieving the valid data from the lost hugepage
>     - the need of smaller pages to replace a failed large page
>     - the interaction of memory error and VM migration
>     - the non-symmetrical access to a poisoned memory area after a recovery
>       Qemu would be able to continue to access the still valid data
>       location of the formerly poisoned hugepage, but any other entity
>       mapping the large page would not be allowed to use the location.
> 
> I understand that this last item _is_ some kind of "inconsistency".
> So if I want to make sure that a "shared" memory region (used for vhost-user
> processes, vfio or ivshmem) is not recovered, how can I identify what
> region(s)
> of a guest memory could be used for such a shared location ?
> Is there a way for qemu to identify the memory locations that have been
> shared ?

When there's no vIOMMU I think all guest pages need to be shared.  When
with vIOMMU it depends on what was mapped by the guest drivers, while in
most sane setups they can still always be shared because the guest OS (if
Linux) should normally have iommu=pt speeding up kernel drivers.

> 
> Could you please let me know if there is an entry point I should consider ?

IMHO it'll still be more reasonable that this issue be tackled from the
kernel not userspace, simply because it's a shared problem of all
userspaces rather than QEMU process alone.

When with that the kernel should guarantee consistencies on different
processes accessing these pages properly, so logically all these
complexities should be better done in the kernel once for all.

There's indeed difficulties on providing it in hugetlbfs with mm community,
and this is also not the only effort trying to fix 1G page poisoning with
userspace workarounds, see:

https://lore.kernel.org/r/20240924043924.3562257-1-jiaqiyan@google.com

My gut feeling is either hugetlbfs needs to be fixed (with less hope) or
QEMU in general needs to move over to other file systems on consuming huge
pages.  Poisoning is not the only driven force, but at least we want to
also work out postcopy which has similar goal as David said, on being able
to map hugetlbfs pages differently.

May consider having a look at gmemfd 1G proposal, posted here:

https://lore.kernel.org/r/cover.1726009989.git.ackerleytng@google.com

We probably need that in one way or another for CoCo, and the chance is it
can easily support non-CoCo with the same interface ultimately.  Then 1G
hugetlbfs can be abandoned in QEMU.  It'll also need to tackle the same
challenge here either on page poisoning, or postcopy, with/without QEMU's
specific solution, because QEMU is also not the only userspace hypervisor.

Said that, the initial few small patches seem to be standalone small fixes
which may still be good.  So if you think that's the case you can at least
consider sending them separately without RFC tag.

Thanks,

-- 
Peter Xu


