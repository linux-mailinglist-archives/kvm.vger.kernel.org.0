Return-Path: <kvm+bounces-14604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A56E8A4171
	for <lists+kvm@lfdr.de>; Sun, 14 Apr 2024 11:10:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 717361C20E05
	for <lists+kvm@lfdr.de>; Sun, 14 Apr 2024 09:10:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B94F424211;
	Sun, 14 Apr 2024 09:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cTDvmFLu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A27E21A19
	for <kvm@vger.kernel.org>; Sun, 14 Apr 2024 09:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713085789; cv=none; b=OYGGziUJy1zKdEjMDhidAiC/HvvtfLRtmfFj3heunz8InVGq/vO/pnEa6BJz/w3/wzMDPGtFwbRed87lKHxbkfUthGO6ISwotXKu8Df9zo2gE8IobTGz6iOO7Cd3f0S0fR88m+QQg9GeqyCyX8MOmm41muDN/Qc4izcvydP2rJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713085789; c=relaxed/simple;
	bh=mx81azu7WGqDtDaPoKpPXOlm5ztzVujTkyngWrhVR+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TlAkDseEXn0+gvZIZIt503KEHKaTkM9H5uAiDB++2aGj4Bt55K0Y+MQkOnvze7C8+TqeW1zoC8rovD/XQ1s6ioM4Lvhq8dH3SOPZL6y0Umq0szMi/vSPeMo1eG2SRFwK4AQdMizjVcOBbyKQ/JSpsPkiVx6IwhGbHAqldawnzQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cTDvmFLu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713085785;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KDn9p0oKJIowoxHQ+QZq8N5Xvgpd2J6FJtOvcnaAQTg=;
	b=cTDvmFLucsv6BAwvVTWGcaWjPl7jBhSdEmsipvS2uuXlIf5lYiHgBWwHQn8kQwdS3DUZLo
	SQkvspX7IXon7VqjeWXnL5pnImbG6VzQReMQY+IBpiHBe39OzwHNZyr0jzc0vwThgr5yf9
	MTw+tbfvH/1ZYV27eOfeMcnrmiFOgGA=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-Wrjm_nszNQeAbY6cZieRFw-1; Sun, 14 Apr 2024 05:09:44 -0400
X-MC-Unique: Wrjm_nszNQeAbY6cZieRFw-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2d6ef704b35so18304131fa.2
        for <kvm@vger.kernel.org>; Sun, 14 Apr 2024 02:09:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713085782; x=1713690582;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KDn9p0oKJIowoxHQ+QZq8N5Xvgpd2J6FJtOvcnaAQTg=;
        b=NBQppwaWjKYcG9xL/2xKgkBK6UMSWcXza9P8TojA8kUjscsOiSEo5/SSpVcQRE9b54
         ODGKwutUlyGi4xMp2mBG4SXRKwxQmIteaTnqbAn4NMksSkKMJmK0xrndF4YiZE8bhWxS
         aQvo3qqyEp0VIcVbkMC4eVOEbu8I7WTUpckbVKqDDD9eE9YAsNFbVFKmA2vFPtZOcF6A
         AsM9EDSLtxJ3DsTClaV255oWH2fuIv8eYoQmicV7bEOBeLNM/mGVxiEYCo2awzKLnIY0
         gJZrIkbDSv6U87Ag+gHcVsf9ue5mi3I5LlJ+4DVhPR7KfqlO7zGKOhHsXOPggpoPpAwo
         XK+A==
X-Forwarded-Encrypted: i=1; AJvYcCXidN2iQHiQP13+ZqI+l1SUVLeHuchXMu2YJjbR5g0l5Ovo0so4YGR31Vc5klpMHYzg6t/zhqpEb5cFBvXU0TqxN5ck
X-Gm-Message-State: AOJu0YxJAgpBy9NdzaIlIfzQdmv4RSUH8xfO1ouRmy+y1cJs2dU0QJ9O
	zkjRJfxn/rg4oOlQo6qjXw79OIn3VogpVJ8GN1fYS3efSuC/Xn7DRueW+ySmxlmZqCN4dgQ9043
	kuQKRQ8PnoGyYS24nN8++gt756UVV0V7F2vDAvJGDl53dvU9311OEvdWvuQ==
X-Received: by 2002:a2e:3509:0:b0:2d9:ecc1:6d56 with SMTP id z9-20020a2e3509000000b002d9ecc16d56mr4549906ljz.11.1713085782021;
        Sun, 14 Apr 2024 02:09:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFnvXuyxDizZiI5lyVmq1CswBaXk7vrRoCt8wmpz3FQXQtnkzsP0CH3Qy864TeyyCiCUv5HDg==
X-Received: by 2002:a2e:3509:0:b0:2d9:ecc1:6d56 with SMTP id z9-20020a2e3509000000b002d9ecc16d56mr4549901ljz.11.1713085781463;
        Sun, 14 Apr 2024 02:09:41 -0700 (PDT)
Received: from redhat.com ([31.187.78.68])
        by smtp.gmail.com with ESMTPSA id u2-20020a05600c4d0200b0041668053ca9sm10311768wmp.0.2024.04.14.02.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Apr 2024 02:09:40 -0700 (PDT)
Date: Sun, 14 Apr 2024 05:09:38 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: Remove usage of the deprecated
 ida_simple_xx() API
Message-ID: <20240414050922-mutt-send-email-mst@kernel.org>
References: <bd27d4066f7749997a75cf4111fbf51e11d5898d.1705350942.git.christophe.jaillet@wanadoo.fr>
 <20240414043334-mutt-send-email-mst@kernel.org>
 <a7eceabf-12cb-41ff-8e2b-f3b21d789c17@wanadoo.fr>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a7eceabf-12cb-41ff-8e2b-f3b21d789c17@wanadoo.fr>

On Sun, Apr 14, 2024 at 10:59:06AM +0200, Christophe JAILLET wrote:
> Le 14/04/2024 à 10:35, Michael S. Tsirkin a écrit :
> > On Mon, Jan 15, 2024 at 09:35:50PM +0100, Christophe JAILLET wrote:
> > > ida_alloc() and ida_free() should be preferred to the deprecated
> > > ida_simple_get() and ida_simple_remove().
> > > 
> > > Note that the upper limit of ida_simple_get() is exclusive, buInputt the one of
> > 
> > What's buInputt? But?
> 
> Yes, sorry. It is "but".
> 
> Let me know if I should send a v2, or if it can be fixed when it is applied.
> 
> CJ

Yes it's easier if you do. Thanks!

> > 
> > > ida_alloc_max() is inclusive. So a -1 has been added when needed.
> > > 
> > > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > 
> > 
> > Jason, wanna ack?
> > 
> > > ---
> > >   drivers/vhost/vdpa.c | 6 +++---
> > >   1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > index bc4a51e4638b..849b9d2dd51f 100644
> > > --- a/drivers/vhost/vdpa.c
> > > +++ b/drivers/vhost/vdpa.c
> > > @@ -1534,7 +1534,7 @@ static void vhost_vdpa_release_dev(struct device *device)
> > >   	struct vhost_vdpa *v =
> > >   	       container_of(device, struct vhost_vdpa, dev);
> > > -	ida_simple_remove(&vhost_vdpa_ida, v->minor);
> > > +	ida_free(&vhost_vdpa_ida, v->minor);
> > >   	kfree(v->vqs);
> > >   	kfree(v);
> > >   }
> > > @@ -1557,8 +1557,8 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
> > >   	if (!v)
> > >   		return -ENOMEM;
> > > -	minor = ida_simple_get(&vhost_vdpa_ida, 0,
> > > -			       VHOST_VDPA_DEV_MAX, GFP_KERNEL);
> > > +	minor = ida_alloc_max(&vhost_vdpa_ida, VHOST_VDPA_DEV_MAX - 1,
> > > +			      GFP_KERNEL);
> > >   	if (minor < 0) {
> > >   		kfree(v);
> > >   		return minor;
> > > -- 
> > > 2.43.0
> > 
> > 
> > 


