Return-Path: <kvm+bounces-19779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FD1E90B130
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 16:13:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9129B28470F
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 14:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 407E51AB352;
	Mon, 17 Jun 2024 13:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i5PghTYI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D191C1AAE00
	for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 13:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718630839; cv=none; b=PDgX1R1mO53iOXVj7DTGopT5Oqb+DByHL9ghTYwxnsoAh0a1Q4OYWsL+SKevtAh6jtCyvnAHTsPZ+vdbVDcY8FweZ0z8WrXizvlagP9l8T8y0h+4VKmx4mTl2t+RfFINu25eFog4mXytv3LuOgyG107X+710JJgZ8Tqxu4Jkxbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718630839; c=relaxed/simple;
	bh=BVnGMwoCZw7PxuD/QNYyTuQeJ5mFD9HFP2ibNF1eTeU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bkgroSqa2r9izTSA6nKGHzGkbSLtNKBvvxJNDtypXvzY0QkWp7CC4ZaYHwBPNhMO5XxN0KWG7xy+kj4pQREdON5pN6siy9ful/Uj1jDnIgCzBeC29Rp8/neIhfJe39rJ6/Ec0NyRFCOOUJ+LyIBK7a/xdH2I3/cj4tb11wZztVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i5PghTYI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718630836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q84CXo0wUI7hBoP/Wd2wSAm0e9Fj0ilpl/ZCzDP0aQQ=;
	b=i5PghTYIepihevBRuItljHPsah5efHB+yZ8gh9KcCj6voyoLE8ubQaTBSmEYmES/NHRoGl
	CQII62CDSwOTiIFHmMW2wU8qPV6Kuz02I2SFJQ6szHLIHZz0ksn0xJqEZmcOIbxVNhHN36
	SbKB1c6QQqm7R23rvhIqcnrdak8XJpI=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-178-EV0x60pyO_GrlTk2IdbUMg-1; Mon, 17 Jun 2024 09:27:15 -0400
X-MC-Unique: EV0x60pyO_GrlTk2IdbUMg-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2ebea1c1124so33720751fa.1
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2024 06:27:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718630834; x=1719235634;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q84CXo0wUI7hBoP/Wd2wSAm0e9Fj0ilpl/ZCzDP0aQQ=;
        b=RY4FXfPYsBy4vXc1R4iqafjcefXLgyhR/CnWOO5ZvXzSebi1e+uUqo60O57aNTuprT
         jiV3/oGQwIU/4zMnLiZv9hXkdOLwDt06vsnGZ1Z2Qey1DXj7zZ7Ymcwx9kuxJDqT5XtS
         4tfMWg/qSEIx4HNWT/JkgwPvP0a0VXmy41n2WQJEPaDWE65+tDXBpx96Q4M7F7lRjpxj
         N4qWdcX33cAshninL9FmeQvcWKeK3KtM2poGLsP4c7Qb5ov03GgYMXiDPBpJZiMnG8vE
         TES80T2qdqlmDRU6xT4dIFmqdL5aFrBrdXRHSjwv4DVDkpG/x/FftLz7Ck0bW7V43oSA
         IiAA==
X-Forwarded-Encrypted: i=1; AJvYcCUQ3vtEouByq5ny9p60I3+uFhg3rWG4GciYN6vLizxEnBeKxdsekPjP/qA2H3zaAwQ90R+pWovoT/1n6t6p15A0LmdA
X-Gm-Message-State: AOJu0YxsV+xgl/QG237iCMOxcpo5RX64vS11KkWbFHx59/zqp0oTAjiQ
	2APuvmI7+A0U8Pa62QxAeXLPEPcYXp4HYlkK4rQmqVDx4PHcrpDjK7PWMtrocnWGI2DzFBQ2yUw
	2Q0P5pC+8cjK83AO137uNuIcuWVMWHx+VZkudsuWqTk8vkoL10Q==
X-Received: by 2002:a05:6512:20c6:b0:52c:881b:73c0 with SMTP id 2adb3069b0e04-52ca6e64378mr6296638e87.17.1718630833651;
        Mon, 17 Jun 2024 06:27:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEpnKGZZT8Zk3aPPgtEsPpln7bsKIoo+bG+Ridg0DdcuVdy5+34CRZh9UkBKQn9c7obciZzKg==
X-Received: by 2002:a05:6512:20c6:b0:52c:881b:73c0 with SMTP id 2adb3069b0e04-52ca6e64378mr6296612e87.17.1718630833121;
        Mon, 17 Jun 2024 06:27:13 -0700 (PDT)
Received: from redhat.com ([2a06:c701:7439:b500:58cc:2220:93ce:7c4a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3607509348esm11832788f8f.17.2024.06.17.06.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 06:27:12 -0700 (PDT)
Date: Mon, 17 Jun 2024 09:27:06 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Jason Wang <jasowang@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg KH <gregkh@linuxfoundation.org>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] vringh: add MODULE_DESCRIPTION()
Message-ID: <20240617092653-mutt-send-email-mst@kernel.org>
References: <20240516-md-vringh-v1-1-31bf37779a5a@quicinc.com>
 <7da04855-13a1-49f9-9336-424a9b6c6ad8@quicinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7da04855-13a1-49f9-9336-424a9b6c6ad8@quicinc.com>

On Sat, Jun 15, 2024 at 02:50:11PM -0700, Jeff Johnson wrote:
> On 5/16/2024 6:57 PM, Jeff Johnson wrote:
> > Fix the allmodconfig 'make w=1' issue:
> > 
> > WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/vhost/vringh.o
> > 
> > Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> > ---
> >  drivers/vhost/vringh.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> > index 7b8fd977f71c..73e153f9b449 100644
> > --- a/drivers/vhost/vringh.c
> > +++ b/drivers/vhost/vringh.c
> > @@ -1614,4 +1614,5 @@ EXPORT_SYMBOL(vringh_need_notify_iotlb);
> >  
> >  #endif
> >  
> > +MODULE_DESCRIPTION("host side of a virtio ring");
> >  MODULE_LICENSE("GPL");
> > 
> > ---
> > base-commit: 7f094f0e3866f83ca705519b1e8f5a7d6ecce232
> > change-id: 20240516-md-vringh-c43803ae0ba4
> > 
> 
> Just following up to see if anything else is needed to pick this up.

I tagged this, will be in the next pull.

Thanks!


