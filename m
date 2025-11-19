Return-Path: <kvm+bounces-63705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 79951C6EA5D
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 14:01:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 112EE3879F0
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 12:53:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6981335FF5B;
	Wed, 19 Nov 2025 12:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KradryzT";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="C7C/e5Ox"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A246C35BDD8
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 12:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763556545; cv=none; b=mrIc9ql0TSbNLM9720P0CXDSj2k7yNl4GBX4PG95IoMplGw1RtysFBJqfysebgk5cYZQ/MJuBT+OGm788Ui8XYd0gVsRy8kdgmLZknzkZk7nKrjI+ig+WEZHqHq5SKdHI1JMFn+8/NKREwJ+D/MIp3pIjIjtsMQNU2fWrXjCSsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763556545; c=relaxed/simple;
	bh=UZNBewuvwkPWj+bu4O3n8vX8SbsHsZYXgD064ZW+wME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kQWsxXkdRjmJcF38QglPeZkCkKicTrkarolGUGW1dflWf1rxj9L9qr58rTEr/FUf4zcDptmlmHm+uod3BXwnYMhMhmjLG6FQNijHVRfNMitY/0K/UpASjpcWgGpMfrzB/lOB/b8MyrpXaf6dm9Moz2rJ/Sm8/Hx0rrEzRAvligA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KradryzT; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=C7C/e5Ox; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763556542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=efzFAXa6AqvKlr68xmTUgqr7OrHhr6l1HfrVAauk7zk=;
	b=KradryzT1JclhNBYuLSTQbp7vIH5GMuuuDTl0KbJW0JHWADNnbz4PWA4vkaWrnQfAonL4K
	HzmkFZoJcJopV+mNtM48NtBYA+GFsPzYVxoZoA855dgK/5v3gsa6mf4tcgfbVAFD57y5z4
	+U7ZNVH5SwwPqoQua2aNnyH4Q7SUEN0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-346-SFPKIcTjNkeEVw65Hxyqlw-1; Wed, 19 Nov 2025 07:48:59 -0500
X-MC-Unique: SFPKIcTjNkeEVw65Hxyqlw-1
X-Mimecast-MFC-AGG-ID: SFPKIcTjNkeEVw65Hxyqlw_1763556538
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47754e6bddbso47816565e9.3
        for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 04:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763556538; x=1764161338; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=efzFAXa6AqvKlr68xmTUgqr7OrHhr6l1HfrVAauk7zk=;
        b=C7C/e5OxFboNzS8m1t5dKea5dZs0Nqemx5VNAyS4V2udOfYctUTj2De0vzprMRklfA
         n3w1Mgd3TzD+NnHKap47yfCXshuADswNZhBjdS5qSODybS5FAOpg6k9f31+v9Mog2g9A
         YHqc3dmZuEZ0SSZocHliCffdTUluxvJ+/3rHUi6olkh/k4BhILq29ruCCEphYB4ChMtz
         ftlIA1IXwMgRJoIWAWH8U6pK8wcgkcZGxdr2uZfmWFIs/zfWGAWckGcvF5U1dYqmLryG
         UQoarNVJZbwkOtckDW5yHCMhPJXb9OCo1yUfjTj3TvrtncLybSNM9tNlI4NdGpBUnSjD
         +OpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763556538; x=1764161338;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=efzFAXa6AqvKlr68xmTUgqr7OrHhr6l1HfrVAauk7zk=;
        b=lKUfgTHld8KeILo5iaGnUYfch62B723ZOMTMVRbkdScV+YQ2U7uyNYF43shY9RGT6m
         bzP1hBCAlxHNXKrQzpDOqcJXH89hb0VWSGeIJjJpiVJRfjyczlVGvbT8jVAaUtAPZgRN
         FSmpMW9zJaXXAqxPmuIYXLXIgDJ48Jz3la62fVhzoLYl2+XqwoWSaPz5LW0s9l2IlDpC
         MfmrnNLv1zM58R4RFjef+/DIVe+lOXbx6Gx7hvRkoPYxJwrG1ifPgOlinnPfpwGK/DPS
         CU+Ya4hLLEakhsuJMMGcBrGejW4/UPsvByYZwrDn1Z5WLxTyWJ0tvxGNbtYB123cYWmn
         5fzw==
X-Forwarded-Encrypted: i=1; AJvYcCWc3EUXN10GCuqGNtvci5lyvzXioukIMak9P8FIF8D/3SPKYVwc4C2CGYL1216KdZpetUc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCakQTEmfyDWN0inzdpFZgWyrwh9fm717mhnYDYIz64jKtcK8t
	z9muyQkaLSRvUT6Y9ChK4XurONu1exCE2P44cpruogeUurjYFpvnKkCSGnyTtEkjYcWQZOfSGYN
	GJA0rdIPm00VcYfb04C3Il3+KO5tmqpm5YfVF9YSbxJoBxmeh8219Zg==
X-Gm-Gg: ASbGncsuqW455hBIIf2tGTprjLqKmNe/YpsBuetapEniNnBG9ELRWPZi4p5l6WZ9Ly5
	xOgfxoTgNyjDGaxSwe04d0X8SG8z/495vVaZhqSesWsZFXQPTJAOB6V1oIK1HnKV56J2UunPvcE
	/1l0gBkHapm4l7JuawzD3WHN+dxCTzRmrGWyHox5w+LbLu6bLOUXfJs0e3buUa3wTwqPt2XILr/
	H0bOfbSUVkkyeAd0XpFpt9aOQckLdLrx3OgQ0fkb6v/EQPkI8fPsgQAzcSKNFwicRM9ns6m7o1o
	7952Yp2zm4BnRwFNiv/c5U++Xxqb4ENZjQGkQP7LUDn+kFDrwvoo594Jo1FutALKpVHFhUkA+cP
	KMZWGtcwZmWzHhlCfHyZ/vPcicO9V1A==
X-Received: by 2002:a05:600c:45c4:b0:477:7658:572a with SMTP id 5b1f17b1804b1-4778fea84d9mr173008155e9.20.1763556537869;
        Wed, 19 Nov 2025 04:48:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF3vS0uApFcgFVlL2gt/R9GTQH3kJDQoD3RSC3xgY4lk5mLnK8+RM+7y+ofmIidRok8jpEiHw==
X-Received: by 2002:a05:600c:45c4:b0:477:7658:572a with SMTP id 5b1f17b1804b1-4778fea84d9mr173007825e9.20.1763556537409;
        Wed, 19 Nov 2025 04:48:57 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477a9e19875sm38753245e9.16.2025.11.19.04.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 04:48:56 -0800 (PST)
Date: Wed, 19 Nov 2025 07:48:53 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Mike Christie <michael.christie@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>
Subject: Re: [PATCH v5 2/2] vhost: switch to arrays of feature bits
Message-ID: <20251119074746-mutt-send-email-mst@kernel.org>
References: <cover.1763535083.git.mst@redhat.com>
 <fbf51913a243558ddfee96d129d37d570fa23946.1763535083.git.mst@redhat.com>
 <4204ed4b-0da1-407f-84e0-e23e2ce65fc7@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4204ed4b-0da1-407f-84e0-e23e2ce65fc7@redhat.com>

On Wed, Nov 19, 2025 at 12:04:12PM +0100, Paolo Abeni wrote:
> On 11/19/25 7:55 AM, Michael S. Tsirkin wrote:
> > @@ -1720,6 +1720,7 @@ static long vhost_net_set_owner(struct vhost_net *n)
> >  static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
> >  			    unsigned long arg)
> >  {
> > +	const DEFINE_VHOST_FEATURES_ARRAY(features_array, vhost_net_features);
> 
> I'm sorry for the late feedback, I was drowning in other stuff.
> 
> I have just a couple of non blocking suggestions, feel free to ignore.


Oh this is really nice.
I did exactly this and the diff is smaller while the compiler
was smart enough to figure it out and the generated code is the same.

Thanks!


> I think that if you rename `vhost_net_features` as
> `vhost_net_features_bits` and `features_array` as `vhost_net_features`
> the diffstat could be smaller and possibly clearer.
> 
> >  	u64 all_features[VIRTIO_FEATURES_U64S];
> >  	struct vhost_net *n = f->private_data;
> >  	void __user *argp = (void __user *)arg;
> > @@ -1734,14 +1735,14 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
> >  			return -EFAULT;
> >  		return vhost_net_set_backend(n, backend.index, backend.fd);
> >  	case VHOST_GET_FEATURES:
> > -		features = vhost_net_features[0];
> > +		features = VHOST_FEATURES_U64(vhost_net_features, 0);
> 
> Here and below you could use directly:
> 
> 		features = features_array[0];
> 
> if you apply the rename mentioned above, this chunk and the following 3
> should not be needed.
> 
> [...]> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> > index 42c955a5b211..af727fccfe40 100644
> > --- a/drivers/vhost/test.c
> > +++ b/drivers/vhost/test.c
> > @@ -308,6 +308,12 @@ static long vhost_test_set_backend(struct vhost_test *n, unsigned index, int fd)
> >  	return r;
> >  }
> >  
> > +static const int vhost_test_features[] = {
> > +	VHOST_FEATURES
> > +};
> > +
> > +#define VHOST_TEST_FEATURES VHOST_FEATURES_U64(vhost_test_features, 0)
> 
> If you rename `VHOST_FEATURES` to `VHOST_FEATURES_BITS` and
> `VHOST_TEST_FEATURES` to `VHOST_FEATURES`, the following two chunks
> should not be needed.
> 
> Thanks,
> 
> Paolo


