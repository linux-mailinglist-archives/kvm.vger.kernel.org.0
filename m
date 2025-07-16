Return-Path: <kvm+bounces-52579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A6E67B06E65
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 09:01:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C63A51A61AA8
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 07:01:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86DE728937D;
	Wed, 16 Jul 2025 07:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dsYC/tu0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDF153BE
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 07:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752649271; cv=none; b=n987OSq0ANXE8qnXWySXZxwGWI8IBWDaAZg18Mc6QOodh96Uvn6Qkjqr3JgJ8MJBwla/drDzYTWxtmeaEQfm5UhIy7mnFyfDW8LE9Us32C7QZMw5IEHxBvcbPQgOJTwcVbl0LdqL7jCBhbZK8yDgPWYkSgDD+eCbZsN1wmE84tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752649271; c=relaxed/simple;
	bh=gibYJRAEGcG17h7YF4mYBLpDulc5AmLjWzwDgOANDOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZiBWVQLxxiOdjtkEaznxi0pCFuoKrpN8WQCYojUhfO3cMUDICf2DiINn63+Boge767H2scHsNCCSqQjA7G0JNe4ZUd1MxQdSbr3/mK/OAK3F0FeaGUY+jePPviyOJroTK1xZ80qy5d8PvjBHy9Hlo9VHODjsbMOZ2mUSH0eewME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dsYC/tu0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752649269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P3AUeB5zKzLtO+orAl/mtwdxHdQgBluYhKSJJpXA5pc=;
	b=dsYC/tu0kwAVGdI9kdcIuYSizwmv0QEKJk6XDPjVeUxCfk+ZQOCPhZSkwhPa2/BNZs+LvD
	W+9VcjN61wgrrhknjSDY4Sv/8KLTVUhoYO+zfacqpBz2rrPQ+s99aSX0/ZjwBLKl0ekPG4
	hrnr5aY/IAvRqNK5y/429TTuwog9CvY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344--Jjv4GZrPoir1j4mXaPg0w-1; Wed, 16 Jul 2025 03:01:07 -0400
X-MC-Unique: -Jjv4GZrPoir1j4mXaPg0w-1
X-Mimecast-MFC-AGG-ID: -Jjv4GZrPoir1j4mXaPg0w_1752649266
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-451d2037f1eso40272555e9.0
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 00:01:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752649266; x=1753254066;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P3AUeB5zKzLtO+orAl/mtwdxHdQgBluYhKSJJpXA5pc=;
        b=M/pJ0j7Po0+tuNnUCpCo9hXOoXA/fXlOOp19PhFNBCu2K0zck7/HFNOvchvnuq5Df2
         2pU8N39cobdDRGVsdvgOZ36VsCeMRwMNgVxATLSVUNsWDguf0XfdJqUUVzEDKLRoszkN
         txRXjqRLaGZHHFXlHjE0zmpkT0y+54de5DTVKnyJw0AbpTUyF1N799mBfBiE4j8E3xJ4
         JeK/ZAu1ZuZ3/yhH+N2/qwHfu5aT/mtJnIaM3ZYCh34MUbuZPJhTNTu1Z6wPBaWngwpN
         H4hxjCpLWIaa58i0di8s70eQk2FL4k3c55fdgn/33RYK51qHAL9jro9/8JDca1UyDf4f
         5MEw==
X-Forwarded-Encrypted: i=1; AJvYcCU8VYa98QaKkJSazhE4cMSarD14fcJqG9IQRvXdXDeT/gukkKnh99Dy2iVqMdrl4k4WIYc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNf6MAI/c6s0EdKooDsQw7GScxJv5MZ4vAAu9qIou56Bf3nh9A
	R9bDCW0IYMJ+sQGPi3fRiIkGdx9AtgBbOaNsD0fvehzwF135IiPKdlG4QCnjNfl6rbDHYytn3Yq
	9qJWQ/Rvd4QVl6Iv54KE4GjZThezemnNqqKZfavlhm70++0sEeBaUtQ==
X-Gm-Gg: ASbGncsYPBUokkwnnT3a+THSM5hhp2nzDR/8FmnOyesri1on0u58TljEqw80y044czu
	XKnGoczMdYdOujRlxIfZoeXJT/aTDNapscFdc9MC8z0qls+I0yOZjcEfz5s19I6T9jcwc0yIECq
	cS8M12ud0JGkhbO2MZ1AY+F4MK1+Bkz6wMMC5OpbU4UvMs7VvcSAWrYQLfRIXc2vTcg6iCvLHj/
	JjSCK0i7AklLFjnltMJgicpOWHJbjQ8CTEvjmzkuIbFPWclb0jmAbu5vcTqH9a4eX3tORT/NqvC
	o0GpiVpHKBn07GAxR+fMcCLgiTG+TLtT
X-Received: by 2002:a05:600c:8b2f:b0:456:27a4:50ad with SMTP id 5b1f17b1804b1-4562e3a222cmr11904975e9.33.1752649266334;
        Wed, 16 Jul 2025 00:01:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHYSFsbElxZnORXSiqQIoPepQ7xnDr+y5vC+zWHhu4yMUCmvO2Fn7tVx5T9nx+faMjH/PtPcA==
X-Received: by 2002:a05:600c:8b2f:b0:456:27a4:50ad with SMTP id 5b1f17b1804b1-4562e3a222cmr11904415e9.33.1752649265837;
        Wed, 16 Jul 2025 00:01:05 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:150d:fc00:de3:4725:47c6:6809])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4562e802afasm11616785e9.12.2025.07.16.00.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 00:01:05 -0700 (PDT)
Date: Wed, 16 Jul 2025 03:01:01 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Igor Mammedov <imammedo@redhat.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Shiju Jose <shiju.jose@huawei.com>, qemu-arm@nongnu.org,
	qemu-devel@nongnu.org,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Dongjiu Geng <gengdongjiu1@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Shannon Zhao <shannon.zhaosl@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>, Zhao Liu <zhao1.liu@intel.com>,
	kvm@vger.kernel.org, Cleber Rosa <crosa@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Eric Blake <eblake@redhat.com>, John Snow <jsnow@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Markus Armbruster <armbru@redhat.com>,
	Michael Roth <michael.roth@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 (RESEND) 00/20] Change ghes to use HEST-based offsets
 and add support for error inject
Message-ID: <20250716025618-mutt-send-email-mst@kernel.org>
References: <cover.1749741085.git.mchehab+huawei@kernel.org>
 <20250715133423-mutt-send-email-mst@kernel.org>
 <20250716081117.4b89570a@foz.lan>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716081117.4b89570a@foz.lan>

On Wed, Jul 16, 2025 at 08:11:17AM +0200, Mauro Carvalho Chehab wrote:
> Em Tue, 15 Jul 2025 13:36:26 -0400
> "Michael S. Tsirkin" <mst@redhat.com> escreveu:
> 
> > On Thu, Jun 12, 2025 at 05:17:24PM +0200, Mauro Carvalho Chehab wrote:
> > > Hi Michael,
> > > 
> > > This is v10 of the patch series, rebased to apply after release
> > > 10.0. The only difference against v9 is a minor confict resolution.  
> > 
> > Unfortunately, this needs a rebase on top of latest PCIHP
> > changes in my tree.  The changes are non trivial, too.
> > I should have let you know more early, sorry :(
> 
> If you still accept merging it, I can quickly rebase and send you.
> Just let me know about what branch you want the rebase.
> 
> Regards,
> Mauro

Well we are in freeze from yesterday, but if you feel any part of this
can be classified as a bugfix, I can merge that.  You can rebase on my
for_upstream tag.


-- 
MST


