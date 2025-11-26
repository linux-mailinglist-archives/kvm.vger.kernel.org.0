Return-Path: <kvm+bounces-64616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 486C0C88449
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 07:28:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0316F3B1A0A
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 06:28:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 672F631618E;
	Wed, 26 Nov 2025 06:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OcuGuJyr";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Laspvpj3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4142ED14C
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 06:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764138477; cv=none; b=khlPFui/v4xZpdcyMWWbAk+jrI3um/aUynw0CXQ8uLEj9r9PIk3oRb1VC0oOX2H//QF5fqtEZgejN33YGV78H0+LhXM/2KamGUzNJL/S0J8OZ6MipO6PQIpCw/7sY4J5hlLbxtnbrB2IKZo89EtVZAKwc2ANfIuEbQgOUVGrspY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764138477; c=relaxed/simple;
	bh=6GBox+U71wd52Kw2/PdLyqreoI+ktndyD42jWbX4uFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZOLDJpxoWwFov6XPoJTI/Dmy5OVvmu3dBzlpmH+ZpA7Ab1vpQNL8rbwedL4CRIkh9+LjW0oBVqUt/D5tJzRULwZyEp0UdRcVNOwbYUtGhOO3UJy3zwFm+hvhtx28JBA1cytpkIij31eYC6z+ZVllDv10wjtZoWEuDAwEZWmF+dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OcuGuJyr; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Laspvpj3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764138474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ARxIA8tdQWb99qoXW28PLnSr1NCprmRt1PGWJHnjSzg=;
	b=OcuGuJyr91W1OUNQQkOx7IE8HIxXDAfld9TaMtqqp0Q1zE1ZVtppn3GPSezPPv407B3Sru
	J7h3q7nQ2/1q+IncrqhVkivL91qOT3NcddnFZxOZueJutCUY9xhuskUBDfYMl7ocqh4+T7
	tWFjUvqcISzLLirqEoa6sHaW7N4A320=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-1oWbNqNSPCu6BSVAJZMhog-1; Wed, 26 Nov 2025 01:27:53 -0500
X-MC-Unique: 1oWbNqNSPCu6BSVAJZMhog-1
X-Mimecast-MFC-AGG-ID: 1oWbNqNSPCu6BSVAJZMhog_1764138472
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4788112ec09so10432995e9.3
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 22:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764138472; x=1764743272; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ARxIA8tdQWb99qoXW28PLnSr1NCprmRt1PGWJHnjSzg=;
        b=Laspvpj3X2vQMlf7eONaP0uEp8iI8cEklRxi9rYME1Ke09iAyhQFbFP85DLnUbkjTb
         hYevtAYaQVPBAc271d9zgt64yK6LwKG9I42NrD/sQ3KRFJyiYRiYoifiS05RzMUizjiY
         NeIEdBz96Eksy+9fO+yvK8HhzaRpbyZ0/DGz9oPG7YPXvljKkCZeyQYDb+5yG/7tbhQu
         fPkjBLqEteKvW5UP5eSiAR2q6j66mMTzGPA3uva6MZVtNm7U8/ALB7Zb8nNuPG6x5HXP
         XMs8cql4IO3EUQYQEu57ZdGY5YiA4qv/gxM4QyGBOktjbrid4DAcHn2rd+KL3Y8djLVE
         tYtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764138472; x=1764743272;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ARxIA8tdQWb99qoXW28PLnSr1NCprmRt1PGWJHnjSzg=;
        b=SOi0ToloVwNHRa5FevfAt+bqYmEJ2GmswRg04AKKHuHKMjX255cZ45nG2TSDd3jwDB
         WXExs7CWaF7PE/+dEcp1ASJ+Cfb3QfLRbXd8zkKK09JLI2RCT3ponP5JtAnCOuJxz4Pv
         5bIrgVHaYqG8t5By/0TAJq4zfEilWXcS//ly/rXTY6uIYecPa3AZjhh2xWVKSBZagc/A
         MZF1/YJSMRK7ktt+1jDYDiplSSrz43WfTxxzsZAspaDvaIbANSIl2PLx6u3DKMio9uW1
         P62V/liAkd9pIEKkfahKgoGIrWOkTdanAluRt1LNUYXwfi0AxiKnWim1TBdg8vc+nyQF
         Jm4w==
X-Forwarded-Encrypted: i=1; AJvYcCXcCCJUl9vjxho6U7Tx9+OqEmu/O8L/v28QgP/2PDGu1xGUdTQj/NavZyCwu1395XhKK7M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwP6cKS64SvVwmYfIKpE3E7CDeGDLaEibG0HBilHRE1E9iN6JCc
	JX/itFQRyrKZMvozdiSYfsc1oGA3lOLBiolAaK7RE4f6X3GvnrXZQmy7FKO1RLQCkzTf5CQnPtK
	0RlCHW2qh0dHImKqrkoJHECIr/Wqni7GWuRj+OriqS/rqWT3H9KmcXw==
X-Gm-Gg: ASbGncsuQWwEgYmz+Sj8qIgThQJhQD8qqoLPq2npUtTcTrhhnHRlWb2hfoAKMKF65Jq
	ChrwvcwdDvtnSQtnYt2235mfKLQVWO7Tv2tMyN0A3/wX4Pa0wz3MY3t1Zlx2ThSWpRh4YUv1qUD
	7/WW+tor2cBQcJl0qCQhTODZuonphece/PtrCGV4bHcpy9KBvhNzTBYNxaMf6B6uV3xtSCEHXdY
	qPnHD0J8u1BG3dIiH5PutRJW/fN+IyI+bzfkRKjzOV6Ndd21gMHgbksQ/+Jg13+bnWAmpiUOQwR
	TB2dLrqqwJaJiNPOL80qzy2YCVXcqb8l8eBr85CsjQcKkphfWCkzFvyEHOQD2voOvNQooJMOnEB
	LhA9J38RpvWKoz/pdWetDlxJVZ2XjfA==
X-Received: by 2002:a05:600c:4443:b0:46e:53cb:9e7f with SMTP id 5b1f17b1804b1-47904b103e2mr53915425e9.18.1764138471839;
        Tue, 25 Nov 2025 22:27:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF0f1u0T3jzKYGdUCWINkcBdum6zqYD5lZ2uzy8Z3cJxh7vJamCVyKXR4UerdY4GLIpXEKe5g==
X-Received: by 2002:a05:600c:4443:b0:46e:53cb:9e7f with SMTP id 5b1f17b1804b1-47904b103e2mr53915225e9.18.1764138471351;
        Tue, 25 Nov 2025 22:27:51 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4790adc601dsm26881835e9.1.2025.11.25.22.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 22:27:50 -0800 (PST)
Date: Wed, 26 Nov 2025 01:27:48 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>, eperezma@redhat.com,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net V2] vhost: rewind next_avail_head while discarding
 descriptors
Message-ID: <20251126012023-mutt-send-email-mst@kernel.org>
References: <20251120022950.10117-1-jasowang@redhat.com>
 <20251125194202.49e0eec7@kernel.org>
 <CACGkMEuCgSVpshsdfeTwvRnMiY8WMEt8pT=gJ2A_=oiV188X0Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEuCgSVpshsdfeTwvRnMiY8WMEt8pT=gJ2A_=oiV188X0Q@mail.gmail.com>

On Wed, Nov 26, 2025 at 02:18:25PM +0800, Jason Wang wrote:
> On Wed, Nov 26, 2025 at 11:42 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 20 Nov 2025 10:29:50 +0800 Jason Wang wrote:
> > > Subject: [PATCH net V2] vhost: rewind next_avail_head while discarding descriptors
> >
> > >  drivers/vhost/net.c   | 53 ++++++++++++++++++------------
> > >  drivers/vhost/vhost.c | 76 +++++++++++++++++++++++++++++++++++--------
> > >  drivers/vhost/vhost.h | 10 +++++-
> >
> > Hm, is this targeting net because Michael is not planning any more PRs
> > for the 6.18 season?
> 
> Basically because it touches vhost-net. I need inputs for which tree
> we should go for this and future modifications that touch both vhost
> core and vhost-net.
> 
> Thanks
> 
> >


Well this change is mostly net, vhost changes are just moving code
around.  net tree gets more testing and more eyes looking at it, so it's
good for such cases.

-- 
MST


