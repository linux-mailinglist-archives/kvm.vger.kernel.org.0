Return-Path: <kvm+bounces-29202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3868D9A51C3
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 02:17:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D87B01F22E02
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2024 00:17:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BC3F28FF;
	Sun, 20 Oct 2024 00:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d6lNs9NC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9146A7E1
	for <kvm@vger.kernel.org>; Sun, 20 Oct 2024 00:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729383415; cv=none; b=ZK1V7EVS8wOWjTX0PBp7IgSIC3N6S5NP3Ifh1z83PC2pSzhD8N4c0Q2k/+pvR1NUBWfw0TrjRIF7zCGABkvj5KH4+UkmiA0Qnc81bNsP6ZTieHMYgTdPiaoTyMVCmv+gc6241C2fOSG9eFGW91aS6Wlo+BeCPJwRnKm4cq/S4D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729383415; c=relaxed/simple;
	bh=4nWCcVgNwZmT+J155u8sQ6LHY+zidjsozMsC45vxYmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S5D6LRuicAHQbcLZqaL17Wl1QHDAWkcJRbym4RTHn3Mggzu/qJbxF1X0oqyJJJjH/8au1RKWTvBICOH2gzV9lwXtoM7KpCmI5aCyJHxDCrNIvb29zLvJrBDuwFPGotsVohI2Ub+y7W2dZSiG74enx23hhqwkcRy5E4PqUz9WNAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d6lNs9NC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729383412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=or/yiB9Bu3RiCaJk2pWKK99jtEnWq4g9dV4LlVxDLOc=;
	b=d6lNs9NCvVKc1hO87pZwpqRra47voKkxLWUwbH7NTeWgRcADtCrG77GmIKwDuR57SK+o22
	TFASrhUvBI0eNRR2vTLv13b07v1HTwsYrTzc2CxJSx+pu4Ef3v3Qmgzk2bL+d74/RDaKMi
	1BXBYrvvg9F4ah2dquVxHwb3mByQPBQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-rRvsM5pUP9ee6XqdMoKJWA-1; Sat, 19 Oct 2024 20:16:51 -0400
X-MC-Unique: rRvsM5pUP9ee6XqdMoKJWA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-37d4922d8c7so1737487f8f.1
        for <kvm@vger.kernel.org>; Sat, 19 Oct 2024 17:16:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729383410; x=1729988210;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=or/yiB9Bu3RiCaJk2pWKK99jtEnWq4g9dV4LlVxDLOc=;
        b=s0mmyhhJeC3LLwQm1GK0T5Kx3rNm/PM2N1QTilMrj+vGZU6c5ICEpxiv6zLjj6SYZH
         qhfg9aaj/WymB+xX+W7jYS7QHI2G2Us9f2mSQxXQKTFwX7SM6noCew32HhCGe8PRloy5
         x295e+E9QuimsfSHxDoFucWNd6XKailZQ4y8Qdq611WcXkspryoxx2l6EGTXw7R7f9eL
         idW/sXNLq6bXhtyEV2+X8FtI4K0I5gxaLi/h9jQjpZ4DhsEsouDlaXoIrkEhyZtDV3WT
         z2YALNPEtnFlawc+fYRSyx0sSNXPdh58M5vwWsxqjZFqltk+GnDiO6Pdnk3eZmQYD+/w
         irOA==
X-Forwarded-Encrypted: i=1; AJvYcCVm1buufCeLSHgpkgtkYIrEimGF5qh6A7BkSX6ofAxOH9IPraqOBe5pw26P565toxMlqiA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+KA8kgxRFETcUWEumeJfAq99ZwIfiXKiZ0KdzzHPllHmpy8h6
	khC8MGMrbI4HSj8/lQ7D2PaG/uL+GjWvSpQtWtb9GwPXopUNkz7gI/KyccSWJnDLe9fLJAO7gFw
	0LAJkeUQ0Ovl/mTo8lhhLXPUcslsdUNGJmWBJBues8mHfV/ky/A==
X-Received: by 2002:a5d:4952:0:b0:374:fa0a:773c with SMTP id ffacd0b85a97d-37eab4ed869mr4187052f8f.47.1729383409833;
        Sat, 19 Oct 2024 17:16:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFW8rNNSMLfWH/xZFL3V72aDhzOhHJhrgTxKwJDJWnDH+yL3bJWVtZvNkVfYNU8FESgNMMTWg==
X-Received: by 2002:a5d:4952:0:b0:374:fa0a:773c with SMTP id ffacd0b85a97d-37eab4ed869mr4187044f8f.47.1729383409436;
        Sat, 19 Oct 2024 17:16:49 -0700 (PDT)
Received: from redhat.com ([2a06:c701:7405:9900:56a3:401a:f419:5de9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37ee0b94131sm585161f8f.81.2024.10.19.17.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2024 17:16:47 -0700 (PDT)
Date: Sat, 19 Oct 2024 20:16:44 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Srujana Challa <schalla@marvell.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"jasowang@redhat.com" <jasowang@redhat.com>,
	"eperezma@redhat.com" <eperezma@redhat.com>,
	Nithin Kumar Dabilpuram <ndabilpuram@marvell.com>,
	Jerin Jacob <jerinj@marvell.com>
Subject: Re: [EXTERNAL] Re: [PATCH v2 0/2] vhost-vdpa: Add support for
 NO-IOMMU mode
Message-ID: <20241019201059-mutt-send-email-mst@kernel.org>
References: <20240920140530.775307-1-schalla@marvell.com>
 <Zvu3HktM4imgHpUw@infradead.org>
 <DS0PR18MB5368BC2C0778D769C4CAC835A0442@DS0PR18MB5368.namprd18.prod.outlook.com>
 <Zw3mC3Ej7m0KyZVv@infradead.org>
 <20241016134127-mutt-send-email-mst@kernel.org>
 <ZxCrqPPbidzZb6w1@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxCrqPPbidzZb6w1@infradead.org>

On Wed, Oct 16, 2024 at 11:16:08PM -0700, Christoph Hellwig wrote:
> On Wed, Oct 16, 2024 at 01:41:51PM -0400, Michael S. Tsirkin wrote:
> > It's basically because vfio does, so we have to follow suit.
> 
> That's a very bold argument, especially without any rationale of
> 
>  a) why you need to match the feature set

Because people want to move from some vendor specific solution with vfio
to a standard vdpa compatible one with vdpa.

We could just block them since we don't support tainted kernels anyway,
but it's a step in the right direction since it allows moving to
virtio, and the kernel is tained so no big support costs (although
qe costs do exist, as with any code).

>  b) how even adding it to vfio was agood idea

That ship has sailed.

-- 
MST


