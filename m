Return-Path: <kvm+bounces-47824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 28B26AC5AFB
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 21:53:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFC391BA7726
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 19:53:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 593BE201113;
	Tue, 27 May 2025 19:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NDUAGRn3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D742DCBF0
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 19:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748375580; cv=none; b=b4oVeHtglILxuDMsfAX1PZ8m28j1ud9op9rpwqqXeuu7hp/qu7XNiJNWvXBuOOhi1JUZTFp8X9ifUEz/FHJMAUSXDzIHir9hCjRjKP1MICqfi4sEztoMjDo7E+fr0U0Yii1WfBqd58dC+ZaMTDPzLVzdE9brWfrdbhs3tVk/sus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748375580; c=relaxed/simple;
	bh=wfzeSjnOBYwtdi+NXoz1WKe00UzyiBoHRf4/F/o8/KQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K9LecUkCYtKuVuk9WPvN5bFV0DuegNJhhoyxYSOktwfMt2K+ohCWZt3ZkyU+7ayv+/lYCrWtF1TBjrFfkIFa4O2kAfgPcCDp/w9pRSy55Ib2LwvXS95t6LtzFcEUogT2N3nONpOq9Z3m3MoUTQTPhVu0CF+Enyc21lONqFmu0M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NDUAGRn3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748375577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B23w+mJte2hrlc+HDv7vWttucz96qnGXmWVqDZu9hNY=;
	b=NDUAGRn31e/1bJ3xBmzME3wcI67dAHAutB22C/gYfjSp4CC+Gzt12fhlC1yuuwXnI9XQtX
	pQ90BX+HmQCiBDYOR0cen2fqapqrAOiBCDN4E7RRqP+TmDhbuZkfUI8putN89CWjZUriBl
	hesHirsv1hMU2Fk0fv/abJuUQ1eYyco=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-KxV8Mj6hMM6SpYtbYilxAw-1; Tue, 27 May 2025 15:52:56 -0400
X-MC-Unique: KxV8Mj6hMM6SpYtbYilxAw-1
X-Mimecast-MFC-AGG-ID: KxV8Mj6hMM6SpYtbYilxAw_1748375575
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3dd77a1db0bso6169405ab.0
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 12:52:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748375575; x=1748980375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B23w+mJte2hrlc+HDv7vWttucz96qnGXmWVqDZu9hNY=;
        b=FkZ4YJoysHTk6/9I13zOX8kehD6gacR6S126HDf7QqN6TT6fbYUw6FOc1OkVh18hoV
         Uie8/kz8D9IV6KDzzSa/xsTbu5lg6uj91AKgFRoCc2xqTOZ2+XA92qv2GJKHfJw82fBl
         1cqA/IylTZxzSX5d2/EWXie0XOUs9E6S1IfOAjgXkjzfqD6BJ6bvIMff4zRTS3Y7YWh/
         GO8VQ/muW6XrWzt4aK/vSaf7z0zOJ9uAAIKmyv9JuZeRv855DjlBD/UA/KIvcugc2aZ/
         sshfTOD7LYecIPn1fIZUxYZvzdMriXIHUt/HT8sVXoq46H9N2r6Rk538hKSPNhtBVx4B
         gemQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1qmQQVdVE1pOuI0iYQEk07oKDW70vNI5AxQVrH+oZ1uuIMwbFgqTbqZdDj1gEy2tBjxs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5GSw555JmZh7rgNx0qEA7ntFTJpNlNOvOw6bq9KiR6om5jcEh
	m3zJVSUqlO5Qr65xyriL8f9hU7i6mvO7nZZLcdIiWoPLjFi1L9OeNOzYQfvufiYGuL9KwLn1uVl
	27fp5PMj+xgEsWcvrh1gFT4gB8Qx284Qt66QwszXIlhvxK0n+IHFcwA==
X-Gm-Gg: ASbGncug23ooUV81bLCkt7lJvqdCZIGISdHCJUZ0hBMfco6hx0E9QkwkgLzN1AHAdPO
	lefL8SnzFD0an4+C/GtYM77NuJ9PClvHQym/5dis1dCKoSDI7nyY4OLrQ36Hrg1thNW3xNRgGza
	PRtHDOZuQ5Bzw6phdMpobJuNaMJQKihH7E4zaRvkxNdoCtq7z8oCUfbLvful1pLyLaeGA1kBAzR
	flybqaXzKfH3ubwpwoZfECzjGZBQjzJWZIoi8gUqAnfqV9QTaf3KuOjkQ5ecl0yKXG7pkeRu0zo
	3YgdIsrj4TFjdJ4=
X-Received: by 2002:a05:6602:1592:b0:85e:5cbc:115 with SMTP id ca18e2360f4ac-86cbb7c12a6mr408932039f.1.1748375575350;
        Tue, 27 May 2025 12:52:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFwLNJ6eHdjPMMmyY13xYb6/ka7gGKjM7dod1+4Ss+jcvL7ApAlSOoRyr0utVN0EwkffA5hMg==
X-Received: by 2002:a05:6602:1592:b0:85e:5cbc:115 with SMTP id ca18e2360f4ac-86cbb7c12a6mr408931539f.1.1748375575011;
        Tue, 27 May 2025 12:52:55 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdba684ad9sm17771173.82.2025.05.27.12.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 May 2025 12:52:54 -0700 (PDT)
Date: Tue, 27 May 2025 13:52:52 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: David Hildenbrand <david@redhat.com>, lizhe.67@bytedance.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, muchun.song@linux.dev
Subject: Re: [PATCH v3] vfio/type1: optimize vfio_pin_pages_remote() for
 huge folio
Message-ID: <20250527135252.7a7cfe21.alex.williamson@redhat.com>
In-Reply-To: <20250526201955.GI12328@ziepe.ca>
References: <20250520070020.6181-1-lizhe.67@bytedance.com>
	<3f51d180-becd-4c0d-a156-7ead8a40975b@redhat.com>
	<20250520162125.772d003f.alex.williamson@redhat.com>
	<ff914260-6482-41a5-81f4-9f3069e335da@redhat.com>
	<20250521105512.4d43640a.alex.williamson@redhat.com>
	<20250526201955.GI12328@ziepe.ca>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 26 May 2025 17:19:55 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Wed, May 21, 2025 at 10:55:12AM -0600, Alex Williamson wrote:
> 
> > This optimization does rely on an assumption of consecutive _pages_ in
> > the array returned from GUP.  If we cannot assume the next array index
> > is the next page from the same folio (which afaict we have no basis to
> > do), we cannot use the folio as the basis for any optimization.  
> 
> Right! I was wondering why this code was messing with folios, it
> really can't learn anything from folios. The only advantage to folios
> is during unpinning where we can batch the atomics for all the folio
> sub pages, which the core mm helpers are doing.

I *think* all we're gaining is that comparing page pointers is
slightly more lightweight than iterating page_to_pfn() and that we can
skip checking whether we've crossed an inflection in pages considered
reserved within a folio.  I'm curious to see to what extent this
optimization is still worthwhile.

> Which brings me back to my first remark - this is all solved in
> iommufd, in a much better way :( I continue to think we should just
> leave this type1 stuff as-is upstream and encourage people to move
> forward.
> 
> Lots of CSPs are running iommufd now. There is a commonly used OOT
> patch to add the insecure P2P support like VFIO. I know lots of folks
> have backported iommufd.. No idea about libvirt, but you can run it in
> compatibility mode and then you don't need to change libvirt.

For distributions that don't have an upstream first policy, sure, they
can patch whatever they like.  I can't recommend that solution though.

Otherwise the problem with compatibility mode is that it's a compile
time choice.  A single kernel binary cannot interchangeably provide
either P2P DMA with legacy vfio or better IOMMUFD improvements without
P2P DMA.  If libvirt had IOMMUFD support, XML could specify the
interface on a per-device bases, and maybe even allow opt-in to a
system-wide policy choice.  Thanks,

Alex


