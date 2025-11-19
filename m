Return-Path: <kvm+bounces-63704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id E515CC6E8A0
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 13:44:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B6E5A3889AD
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 12:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A12C835E549;
	Wed, 19 Nov 2025 12:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y0j+n6mo";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="OpFj9bVR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14E4357A5D
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 12:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763555708; cv=none; b=EaxeaaMnX5IwNDrZyfqQBofeazCIr7urK+S8kQdX8XiIb6QQojxgMxQb3S5iMrkQK/bjNcKKQtuHL1b/TdFFSmP1X1AbAlVaQ192R2wesoanXbqvaTaYwFUXP8drDV2OUnejhQ2hA4le/72SuNFoXWJL/bXd74ZDKvDPmYzmLxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763555708; c=relaxed/simple;
	bh=EPmrUepgE1rgeLfHqD5slhvdiL6tMO9t2cr77eQyKts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nYtvKDNpdQDU1NDWhLUun5dqRPJHIhQOPGqllTRcK6abUCDOY8f3/xVQiXiV7HHWq7G6CvuY1HXScGNq3Chs2hzs5YKQsrzV1wNgEkLKNl9fShM281eGwe9eaFOvBNHnp0y+JlhWo7xVzQOnljz87hHF6VRKFwN6kxX6iIAEtTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y0j+n6mo; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=OpFj9bVR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763555705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cX3V/Maq1P62aubbfEZMkx/73yOAMpSFaKpbQ5l618w=;
	b=Y0j+n6moUkptffLGrnn3nt9m9vC8WA7dualthxVUXZ2ce6gZa3mCVM8Ylm00/1OIflUbvw
	vpDBv0uWVxDIFp4zjnSAFY9DCff/A37cxuhliFPyR76CxiEZSFGAswruk6AHBx8qrjp38d
	ZKNLFT6llztvKboDuOiOHXiueGnSWOk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-27-WGI3QwN1OJ28vLUvujTXMA-1; Wed, 19 Nov 2025 07:35:03 -0500
X-MC-Unique: WGI3QwN1OJ28vLUvujTXMA-1
X-Mimecast-MFC-AGG-ID: WGI3QwN1OJ28vLUvujTXMA_1763555702
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-429c76c8a1bso4029149f8f.0
        for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 04:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763555701; x=1764160501; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cX3V/Maq1P62aubbfEZMkx/73yOAMpSFaKpbQ5l618w=;
        b=OpFj9bVR2mnYp80kl8qp0X6YeSVRM2dAHTCcC1DsYOSQ2eyerDU+3vcQ5IjDq7wyup
         hUTOfNO8BCEusKNg5gqh4iopxldMu1KqiboKz89gT0luKEOfn6odTAMAjlXbhXqZS3RO
         pK0neFXyiZ/MUOhi0CPj5KMl+LZ10VfX4oayFir4/a3gOXd7eHB7QZlsRKhlPMcpGBXE
         UVMYUHIUZVH844kPNz+mZOXVk+ARphTnI+ISsnIQm4O7Jsdc8afWCElJWhLOhjBP3gPy
         NYko7Ezka0T/FTcjMqB+D+BRI50On2hFvn3quwTx/7rirQo2IoCzmJ+sekm+rm2GDaVB
         xiTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763555701; x=1764160501;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cX3V/Maq1P62aubbfEZMkx/73yOAMpSFaKpbQ5l618w=;
        b=H4skrbdOH8w3YzmO6PWaWMsoCmg2Btuwlw/kfqaH3OJZl2M8vAiP1T+uJN4tb7F5Xz
         mdPeoUZg+NXL6fOGENf3k7omXTXBzz7xkY/jX+zZpZfrzCTFEx9ZW4ztTid9u9coQcBb
         lOoDtmAHxEnMo6GuHGbMLuTZjW03Ez4pewm5dbsSvEXVCaestPisj5XFq8/9UVVyDx91
         VNqMnAPt58nBfLBgaRQ1eLvf+7dN9DUcK0tQQOXLIkLqtZdcYA7FyZ3x0VytBN3gmzrQ
         ySO9qXMzXVgprLM0yEs1KrklZ0ON/Mp9IL6aaxcUtWH6GhJ2TfFo0rzw0TumlHltZPe/
         +yBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWinavKIeYyzaZciIEr/GR5lXwr/AieKC3ww9jMVmieOpsUlUzsp3BprvH61Z9sq7d0o34=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1lJAPfShp9ZfVUrJ8cAiCdfCU+z6nPPCpPMeV2AsTfZoyQKvF
	vZ3MqxKEzIPoh3cfEzoLEr2EGxlIW7kXg9Z8W/iazzshGAa1BgPDaYunii+y5mgnUAv3fA3l9w1
	6sLIOcyQfo2DBYaRi1cQEbe1NOJAVZTwXxJhqnQzw3zivaDTcfeG1mQ==
X-Gm-Gg: ASbGncvI49sY0GFC9TQ7qrUQxSq+T2ZO1AKYOmv23secJiTvtmPY8p+kocWrnghvsI1
	JD1379dJdaWUMHj/5TYT/k6j99/cdJkiR0Bpk6nLj2dnE6LPyu10oSf6V26b3X0KC50Q1+AYNaB
	0Wwc1b0wUQNs6ktHN1Tv17o4MXI2XSdimbjrzlYaJ3OtjbVdX4jzPz3PiWDBgpBPtWbIrp7tzRC
	slbRKBJXdSk0e5K8UnHc/8uZu3bQtV9WP8NJfPiRyjo8coiv5wvQwJqVmWRgfQZj236l+f7LI1a
	AEEINZWkwJKuT/GISOyVZGEw5ivv47W6aNA5qgKcrZVpffnakf060A/pWDfrbjGxhZlf3yXa09x
	4DykC2kXSUjgUdD2nQEEQ7ht/HOCBTg==
X-Received: by 2002:a05:6000:2c05:b0:42b:4177:7135 with SMTP id ffacd0b85a97d-42b593721efmr18718644f8f.41.1763555701525;
        Wed, 19 Nov 2025 04:35:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFZDtCaU9W4jbuIEbB8KCRjqHZi966/jHceca8fTLxnbGRC0wWJ1uQzXqWj/dl06f43gIEXkg==
X-Received: by 2002:a05:6000:2c05:b0:42b:4177:7135 with SMTP id ffacd0b85a97d-42b593721efmr18718600f8f.41.1763555701078;
        Wed, 19 Nov 2025 04:35:01 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53f174afsm36933997f8f.33.2025.11.19.04.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 04:35:00 -0800 (PST)
Date: Wed, 19 Nov 2025 07:34:57 -0500
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
Message-ID: <20251119073155-mutt-send-email-mst@kernel.org>
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
> 
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


Ah. Good point.


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
> `VHOST_TEST_FEATURES` to `VHOST_FEATURES`,

This one I don't want to do, people tend to copy/paste code
and this is not what devices should be doing.

> the following two chunks
> should not be needed.
> 
> Thanks,
> 
> Paolo


