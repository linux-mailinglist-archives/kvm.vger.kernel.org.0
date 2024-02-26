Return-Path: <kvm+bounces-9854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 41AA2867478
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 13:12:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD30F1F24169
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 12:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01F2C604C1;
	Mon, 26 Feb 2024 12:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gWSUm9AT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0F460279
	for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 12:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708949535; cv=none; b=H05LdNA7sMb21EgnS0kWG5tPL4GcyUlYHVMdDsOpRmS/2p/ZKlezYQcA6Z37Z2b/CvciWjy8l7I3U5cvVNMdMfu4xYycZQ1fSnB32Rfblsu5J5o9KePuS0bNiGzusVkL8PnniUkb/H+7wAEERq1n6qzF+5vxpeIjqyfQ4jT2ppU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708949535; c=relaxed/simple;
	bh=e0N6/2zQUM1QOqkgabnyahS6/9h1qmMEkf5qlHoAwkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o8zZ3JNftL3ki0A2+0UysHzUcy9tN4Doqib9BI3Q2w3wK63uyp+1azy4bN9dTnxVUXhfotE/6AvoQG/IBAGj77ubfqWEehYz0IxIJD/KamQx7bxXMYFAgZrmbq5iByXuxgeg9n5n+ntz4rOO+p4H3uRrU56aWiE4T82J46Ch/qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gWSUm9AT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708949532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lVX2aIqulG7pb2ZKAY6wEN/hr8j5RuJ02O3KYwJHnAk=;
	b=gWSUm9AT5UCgVZbInrct6QYaZaJCsjSd5nz8Kmdzoy6Zfiqzub4BKPhs8srSMHI4eGfi9S
	SdYu8UZ2nwoUkSKS7ADJP7Dt1HQvtA3PNR5eSLGs1cLDClMYaz+9irpBLeRT6ShIuxfS1o
	N5e+T1GOnfqeu0dOq+DXb4zAbKewMsI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-322-0A6laitoM5i5AqUjGF5vnw-1; Mon, 26 Feb 2024 07:12:10 -0500
X-MC-Unique: 0A6laitoM5i5AqUjGF5vnw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-33d51bb9353so1740957f8f.2
        for <kvm@vger.kernel.org>; Mon, 26 Feb 2024 04:12:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708949529; x=1709554329;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lVX2aIqulG7pb2ZKAY6wEN/hr8j5RuJ02O3KYwJHnAk=;
        b=Tl5MT50EjWWQaIxxI7eSWKTKaVqDJ1hJ8ge3d83iQUu1PioLHHmQ8Od32PzwfB9plV
         /5e7pOS98x7Y8grXcurmzJ2/AzPg+ecVBpOVGqA/1pEXZIdVZG/A5bs06+05GNbeenaw
         AwAnGJ+HRojoPr8KO1UxikymEQr8MUSGbLjPbiAqUBfC9Tb52Zrijbq5ypien4K06Cun
         T4Vuq75YFkLUo1gjsAOLYTT/1cGl/gm+lUOCVu8vJhM39NaXP8rmHwrXXFW2UO9hgm4y
         /6Un5ca6OcFzFL6seKgagEEU3EUyhP4I6cngFNDG2BYnKd8N9+L48cR4616/goMy8Xg9
         138g==
X-Forwarded-Encrypted: i=1; AJvYcCWITtn8Ts6nlthGRqL4/4oeOE8UX2F2/5fFUinRuiLq7Hl7uy4Gk81Yh5hcnLm1QcCCKE4/bw0bflY8vPAmFFQxKq95
X-Gm-Message-State: AOJu0YwXbp0EnSaPIv028vJ+yg6wcNAXMqc4pDBe4qyVFgNjs3VUVqtw
	Bgm5VSUJNgo5Ji6ciljzqjhn45cy4bb4AtYybWMRo8QaY4ImDMrdqlGluNtTTYMe9igN2l+GDyH
	K0WvtOBgkORlsPUOf0t6FjRErewOBaAdfeCMHBpk+vWHVGY7HaQ==
X-Received: by 2002:a05:6000:1961:b0:33d:7ea3:5b90 with SMTP id da1-20020a056000196100b0033d7ea35b90mr5099360wrb.65.1708949529662;
        Mon, 26 Feb 2024 04:12:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEf07k3zYsXuRGP5oY8KvF8nVh4PymH1C6S7+HQTQO4YjooNJ90xav4OKE27dfDSxc5oKl0bw==
X-Received: by 2002:a05:6000:1961:b0:33d:7ea3:5b90 with SMTP id da1-20020a056000196100b0033d7ea35b90mr5099329wrb.65.1708949529347;
        Mon, 26 Feb 2024 04:12:09 -0800 (PST)
Received: from redhat.com ([109.253.193.52])
        by smtp.gmail.com with ESMTPSA id t20-20020adfa2d4000000b0033de1e1bddcsm1414633wra.26.2024.02.26.04.12.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 04:12:08 -0800 (PST)
Date: Mon, 26 Feb 2024 07:12:01 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux.dev, Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Vadim Pasternak <vadimp@nvidia.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	linux-um@lists.infradead.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
	kvm@vger.kernel.org, bpf@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH vhost v2 19/19] virtio_net: sq support premapped mode
Message-ID: <20240226071010-mutt-send-email-mst@kernel.org>
References: <20240223082726.52915-1-xuanzhuo@linux.alibaba.com>
 <20240223082726.52915-20-xuanzhuo@linux.alibaba.com>
 <20240225032330-mutt-send-email-mst@kernel.org>
 <1708946440.799724-1-xuanzhuo@linux.alibaba.com>
 <20240226063120-mutt-send-email-mst@kernel.org>
 <1708947209.1148863-1-xuanzhuo@linux.alibaba.com>
 <20240226063532-mutt-send-email-mst@kernel.org>
 <1708947549.7906592-2-xuanzhuo@linux.alibaba.com>
 <20240226065709-mutt-send-email-mst@kernel.org>
 <1708949183.5224328-4-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1708949183.5224328-4-xuanzhuo@linux.alibaba.com>

On Mon, Feb 26, 2024 at 08:06:23PM +0800, Xuan Zhuo wrote:
> On Mon, 26 Feb 2024 06:57:17 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Mon, Feb 26, 2024 at 07:39:09PM +0800, Xuan Zhuo wrote:
> > > On Mon, 26 Feb 2024 06:36:53 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > On Mon, Feb 26, 2024 at 07:33:29PM +0800, Xuan Zhuo wrote:
> > > > > > what is dma_map_direct? can't find it in the tree.
> > > > >
> > > > > YES.
> > > > >
> > > > >
> > > > > diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
> > > > > index 58db8fd70471..5a8f7a927aa1 100644
> > > > > --- a/kernel/dma/mapping.c
> > > > > +++ b/kernel/dma/mapping.c
> > > > > @@ -144,6 +144,18 @@ static inline bool dma_map_direct(struct device *dev,
> > > > >         return dma_go_direct(dev, *dev->dma_mask, ops);
> > > > >  }
> > > > >
> > > > > +bool dma_is_direct(struct device *dev)
> > > > > +{
> > > > > +       if (!dma_map_direct(dev, ops))
> > > > > +               return false;
> > > > > +
> > > > > +       if (is_swiotlb_force_bounce(dev))
> > > > > +               return false;
> > > > > +
> > > > > +       return true;
> > > > > +}
> > > > > +EXPORT_SYMBOL(dma_unmap_page_attrs);
> > > > > +
> > > > >
> > > > > Thanks.
> > > >
> > > >
> > > > where is it? linux-next?
> > >
> > >
> > > I see it in the vhost branch kernel/dma/mapping.c.
> > >
> > > Maybe you miss it.
> > >
> > > Thanks.
> > >
> >
> > which hash?
> 
> fd0b29af02bb75acc94eb08c06e2c10cbce2ea67


Thanks. Now I see it donnu what was wrong with me.


> >
> > > >
> > > > --
> > > > MST
> > > >
> >


