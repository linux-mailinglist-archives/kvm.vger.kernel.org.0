Return-Path: <kvm+bounces-15414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 83B2C8ABAEA
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 12:05:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 10611B2149A
	for <lists+kvm@lfdr.de>; Sat, 20 Apr 2024 10:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4EB117BDA;
	Sat, 20 Apr 2024 10:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Azbt1Y+5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED58FC1C
	for <kvm@vger.kernel.org>; Sat, 20 Apr 2024 10:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713607526; cv=none; b=lqogg1DWwHEseEK7LBe2QOM7OJbuXtdialHny/j45o9XqkdMdDJnLvWkShZZHnrWv3+S9o0t8AfIulFZZPyy7ZiDrn6TVETNk8L4dscfOPqmKdwSnBqk4g332Q6F6/8TtDWgARyUjAvhbA4A/40m6Tm0AZCwRjVH46lrwoFmi2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713607526; c=relaxed/simple;
	bh=UKYeRD8/XiIyAg9qRBsvwBklh4EieGaHp8R88F3ZOck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lC56tywpyA1mHK+hFoETan1+Sm9yvvBFo0KQ9yGavdVfuGcWy66NOqGsfhmozHAOq+CJjMV72+TYTVMzwiyYO9wQAqZ2hg+MKhMIZET0ffdKeRWP3/udG6RZTwfCldte7tdEZXXB8I9enar8EXEYnOZt1TEKk7ZUCtERIIa5XtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Azbt1Y+5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713607523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dupUFX22MvWJlz2LiPNASjX/H+JRFaBqC9DPNGlEAKk=;
	b=Azbt1Y+5Bq3SR0V8qnkiI77kmtGeMvQV6hN/yh9OaYHP0XNn+S8G/mUNVQHWLmfJwgaKZX
	Ck0ULpPrNEl5m5iM5jwQ6xNbyLSo4Vp+QPYIM5iv3pXjWRqKUrTVr3jYJw+8YFABahxBxV
	ksTWwfPGZE8O3d4HZxeFv7PNBNxJIMs=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-ApjJVceDN_-_-3KkyzdEaQ-1; Sat, 20 Apr 2024 06:05:22 -0400
X-MC-Unique: ApjJVceDN_-_-3KkyzdEaQ-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2dd187999a0so3482371fa.1
        for <kvm@vger.kernel.org>; Sat, 20 Apr 2024 03:05:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713607520; x=1714212320;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dupUFX22MvWJlz2LiPNASjX/H+JRFaBqC9DPNGlEAKk=;
        b=LYjEOPIBv0SddyCg1QhiRHj8kY4m9ItsDibBFkmiW8HKMt3wmcOuuQZeOmlscat9rH
         5yd9v4uTpbVYit2WE676kugiYivXZzFCMDyDO+WYSqPNyxBQQ2ZxlKtTofjIEbtpzelA
         EHlhWSrIcm4OC2iPSEX+W4SKiBoXllyFna+uoji5keamDK7Ofo5G19hJHsgWHjPOQOym
         Pyhl+2mDrrOy6yC+aKXBH9lHl1/AL6wLJoH6P2w1WuIaKk3K5j/k5WdzrnsOel8nFBBK
         SLcq2QX+dPBXxjdP6hUKOOC5MJgCtbroMvJ9ZtyUP8C9Q/sSpZSxe9N4u6hY4jxR/FNv
         BL9A==
X-Forwarded-Encrypted: i=1; AJvYcCWrLevxZTcWMUCPR7NRDZBbl6lIR0LT4x6EUqWpQ0lh6H9IKoP3O8ndf7MldGrBhcuZPTEZbJ4V4sl8vn2fEcp4PGJi
X-Gm-Message-State: AOJu0YyywjHILVPz/McL6JqSesvJptkmo9l1APZ49vVVhcTgghRGg9Is
	9VZM16FB+2Qs52407K4JJ6I5HWO8Iu0A4BXKVasShezw/zmtDplJAfUNO8v6bhqlnN99fZvG+Aw
	c4C3YuGzlA2zGU83bFuOT75QausIlEVvYwpvaRkh6lBSn5XDm7A==
X-Received: by 2002:a2e:9798:0:b0:2da:a73:4f29 with SMTP id y24-20020a2e9798000000b002da0a734f29mr3610197lji.30.1713607520477;
        Sat, 20 Apr 2024 03:05:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFYBnMGeF141NDJiiAEbx9ZNUBUqnu1GBz0moT4dPDvrOwYJoOemN0dK9MgDRfLJOyGBx1O+Q==
X-Received: by 2002:a2e:9798:0:b0:2da:a73:4f29 with SMTP id y24-20020a2e9798000000b002da0a734f29mr3610179lji.30.1713607519984;
        Sat, 20 Apr 2024 03:05:19 -0700 (PDT)
Received: from redhat.com ([2a06:c701:7429:3c00:dc4a:cd5:7b1c:f7c2])
        by smtp.gmail.com with ESMTPSA id i13-20020a05600c354d00b00419fba938d8sm973597wmq.27.2024.04.20.03.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Apr 2024 03:05:19 -0700 (PDT)
Date: Sat, 20 Apr 2024 06:05:15 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jeongjun Park <aha310510@gmail.com>
Cc: syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com,
	stefanha@redhat.com, sgarzare@redhat.com, jasowang@redhat.com,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH virt] virt: fix uninit-value in vhost_vsock_dev_open
Message-ID: <20240420060450-mutt-send-email-mst@kernel.org>
References: <000000000000be4e1c06166fdc85@google.com>
 <20240420085750.64274-1-aha310510@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240420085750.64274-1-aha310510@gmail.com>

On Sat, Apr 20, 2024 at 05:57:50PM +0900, Jeongjun Park wrote:
> Change vhost_vsock_dev_open() to use kvzalloc() instead of kvmalloc()
> to avoid uninit state.
> 
> Reported-by: syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com
> Fixes: dcda9b04713c ("mm, tree wide: replace __GFP_REPEAT by __GFP_RETRY_MAYFAIL with more useful semantic")
> Signed-off-by: Jeongjun Park <aha310510@gmail.com>

What value exactly is used uninitialized?

> ---
>  drivers/vhost/vsock.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index ec20ecff85c7..652ef97a444b 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -656,7 +656,7 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
>  	/* This struct is large and allocation could fail, fall back to vmalloc
>  	 * if there is no other way.
>  	 */
> -	vsock = kvmalloc(sizeof(*vsock), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
> +	vsock = kvzalloc(sizeof(*vsock), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>  	if (!vsock)
>  		return -ENOMEM;
>  
> -- 
> 2.34.1


