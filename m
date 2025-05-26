Return-Path: <kvm+bounces-47730-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EE35AC445B
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 22:20:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AE823BBCC5
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 20:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 550372405F8;
	Mon, 26 May 2025 20:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="EWSfJNH2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194B5202C3E
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 20:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748290800; cv=none; b=TdVEwjlVpiaIPOwAhsajSIbUuSk+5DRNPKKHVQZfgYMwZtbCLdZuYlBNgslF9/hRpqylgo46LqJQ3774g2c/fcJXedrEY9cOe3IEZ6eJ7IIMAlGiNJU2gM7PwIu+aVcBOLb5YoRBcuo7y3wrpgYnaPKITGfIZRtlsE+fFndpaeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748290800; c=relaxed/simple;
	bh=o5gQ5x0CBQ2LeBkPQqD92Vnk0YT48zi3/abof9Kr7J8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uVoPYoBD4Es7vZf6sUHYrr6NT0LuxDwoF/7BcOY5V6ck2hI0xUXOljk/IUknaqUHvNxaxxQWME7GynKgW+69XGiSzGOxhPVVtm2FL2jzP08FTQyXbTHAupzggXzjsDEAgpDZEQiRcpXDbz5h1lIzM8IqdDbJWg9cDeiwK7u5MXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=EWSfJNH2; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6f8b2682d61so35271826d6.0
        for <kvm@vger.kernel.org>; Mon, 26 May 2025 13:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1748290797; x=1748895597; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hLps+JNcyParOfDXS9JzFuLbkraKablpTP/PpVjY8aw=;
        b=EWSfJNH2OS7eXS5AadrkMnsUFh4lfgsS+45mZ83t54Fzu6KNdTFO6TCrrx5XVwMA8r
         uatDdgZ2wRrNfxzXezYm8lCtBF92o5BzvjNoMEh7s0kziKRX5YUh28B5qmDzXSP68Dlg
         1xlAjsuEbpaxgnPX4CCItTarHTgRu3VlpBAeWtTkOiWMEvEUDpp2iacOXFOCf7QWTtGT
         8qa8Lcw9KioNrV+LTz8fRLz1OeHF9Q6hLYb+ScKLVc431nu1oQ2VHfg977Tbw6QD8Tn+
         Pn+4qsNY/0KUQ0ZPf2iqHq2wUj7hWXU/rYkEit12XeodDJ5TV6hLtFjWNw5vyUvGvfFA
         v8ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748290797; x=1748895597;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hLps+JNcyParOfDXS9JzFuLbkraKablpTP/PpVjY8aw=;
        b=BhRmNPtH3rSEEwAyVb5vd2W3K5alkb9JVdJ5QsNQ4WKjDc7uKAutSJn+zEmtDgOnhg
         GJ1gx7LBD8eDx8QVRjEMKZckzUJl8qDIRB1DDgJy2tqNsmigYx9j3PAAtCx+WKRRUqb6
         63GZkUjiUAAruFr1AHFi4MLWKJke6dfL7KAwps9KB6pRqJ0X10K0NaDIh5rTAgKWy20Y
         wUjQNE27vvNO335D9PwGJM7uwU+OsfSbiSH5baW927p7Prp4JPNbRAoG5n3d3WZQJp2v
         p2PawcERev64Yw5pskIiS5UeMLun+fNRM1ApAA+NYuNGUZO4D6rzn9IHunb46m5dwKGs
         wu0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXqgek2KxZPexuzUdOkpIxsB9h/79msjp9Az2hjueay9LqXa7rcUfCAjqdLCB/bvC1BqtI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5NvCmClyWT/avlBYk0ij0Y4ZbSuLbXWuNmOpAlxf91cxPWDnU
	zFDrBTV5tHutxW4gLbsNOfnXyIu+qhltbAz71aSP751DiOmIlbHHdCpAlTR6LemDiEs=
X-Gm-Gg: ASbGncubsFJUuCpLfoIQ49eiKv/tx2lXCD7ctvpO7AgFxO+97c/zJPG+z6iBHR3q6n7
	k58M7boRwETYwuPPVF1FJli86eWYTvzRaDJrXI93k8lDreQKTK2Sj7AzwexHTPeJZ7JD6bJdioa
	7/FX8EjmcVajRjGFqtffk70dcW96m8lWKt3dTcSld0KBIs9QD8tj4wbcWbKT7s4nlq34K3ZGHir
	vfKFGyyDs8Il02n9VmqRFz75iG2ZKD8d9aqWzGKoFtL6zmdemadK+KzNpt81C05B1+2liOwB0e6
	3Jg8rWCFXiUNoJHnHM8zlNuGNcLXNwuTZYD43+gDre+L4Y7lpBJVbsILTuppc4pLuLcI1im4o64
	KNkCpkyHv7wmSMVUFLwr0Uh7/ZWY=
X-Google-Smtp-Source: AGHT+IGgTwiyg5eiY7T72449r0+RVPoXtu68z9yqpkDUhC5jnCxOtecB9Azj5gEYa//3ikcBXT1glg==
X-Received: by 2002:a05:6214:f09:b0:6fa:a5bf:2595 with SMTP id 6a1803df08f44-6faa5bf281dmr99808036d6.16.1748290796961;
        Mon, 26 May 2025 13:19:56 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fa9a3dbd2asm45191276d6.48.2025.05.26.13.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 13:19:56 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uJeId-00000000UuV-48LG;
	Mon, 26 May 2025 17:19:55 -0300
Date: Mon, 26 May 2025 17:19:55 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, lizhe.67@bytedance.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	muchun.song@linux.dev
Subject: Re: [PATCH v3] vfio/type1: optimize vfio_pin_pages_remote() for huge
 folio
Message-ID: <20250526201955.GI12328@ziepe.ca>
References: <20250520070020.6181-1-lizhe.67@bytedance.com>
 <3f51d180-becd-4c0d-a156-7ead8a40975b@redhat.com>
 <20250520162125.772d003f.alex.williamson@redhat.com>
 <ff914260-6482-41a5-81f4-9f3069e335da@redhat.com>
 <20250521105512.4d43640a.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250521105512.4d43640a.alex.williamson@redhat.com>

On Wed, May 21, 2025 at 10:55:12AM -0600, Alex Williamson wrote:

> This optimization does rely on an assumption of consecutive _pages_ in
> the array returned from GUP.  If we cannot assume the next array index
> is the next page from the same folio (which afaict we have no basis to
> do), we cannot use the folio as the basis for any optimization.

Right! I was wondering why this code was messing with folios, it
really can't learn anything from folios. The only advantage to folios
is during unpinning where we can batch the atomics for all the folio
sub pages, which the core mm helpers are doing.

Which brings me back to my first remark - this is all solved in
iommufd, in a much better way :( I continue to think we should just
leave this type1 stuff as-is upstream and encourage people to move
forward.

Lots of CSPs are running iommufd now. There is a commonly used OOT
patch to add the insecure P2P support like VFIO. I know lots of folks
have backported iommufd.. No idea about libvirt, but you can run it in
compatibility mode and then you don't need to change libvirt.

Jason

