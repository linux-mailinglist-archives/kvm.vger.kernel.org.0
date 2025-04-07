Return-Path: <kvm+bounces-42818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1153FA7D80A
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 10:35:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0DFC5189010D
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 08:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B06022A4D2;
	Mon,  7 Apr 2025 08:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QpdX44Lg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A5E225388
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 08:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744014879; cv=none; b=la/l1zsDBmr6XffEfjyQIvjI0EGWkq5YLdyWg8J6U9LW99kFvXVUsv1m65w4XpiHI1LMgQCdJQhsoEhNf3mH1POppaKmsPR7n5pNpR+DGlLfx7mha4ayETbDAR2cXmcfc+iqOlquvw8NbafrlcHrTTyTwJwq/4+1wpq2E4bDtLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744014879; c=relaxed/simple;
	bh=sLck2J+6PcjmSINGrDUpZvijf9T2VzrBWCePSK/Qvj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DwxixZVEL89lQFFLcQtp+Ms52CPI4ZjaybpgpewPwyaRFlCT0vjNFn/Ga7vDXJ8To9RmKeb5bDVy2bw1lIeNLyyPNlZ95NVpF3d+nGsFOpN/JWGkHRgQR6GTD/q0sxJ4knELFNm9B2Dn9Tdzwi9fN7gtAt48SEasK6lg30fbMjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QpdX44Lg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744014876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RyTmsi9BhA0X2tfDIhwHRBuV/xgf5KDyDiyovwov3BE=;
	b=QpdX44LgbzIPJTqRMIvF5PZ7fFBPXIgzvk6qPV4RxuarKW7iXOq4pvWTSW/Zej43/XdUdF
	iNixCp2vkg5yQHU6fkczUuFRTPEqUxtcgcUyqhCIsd+iMKFv4NM+bESdAVyCUJ84U+ha/H
	PspcaSKa/V/UJyKByhlhRLO3/94cYOs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-lTwNVdJdOQC1sSUjFEbR7w-1; Mon, 07 Apr 2025 04:34:35 -0400
X-MC-Unique: lTwNVdJdOQC1sSUjFEbR7w-1
X-Mimecast-MFC-AGG-ID: lTwNVdJdOQC1sSUjFEbR7w_1744014874
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43d0a037f97so23878265e9.2
        for <kvm@vger.kernel.org>; Mon, 07 Apr 2025 01:34:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744014874; x=1744619674;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RyTmsi9BhA0X2tfDIhwHRBuV/xgf5KDyDiyovwov3BE=;
        b=GiZ6PYRShbCFonb/fpK3l7AZFkNw/p0yGKRr3ppU7ewtxw7NIi/2tCVTQgdGJcBbSf
         EWGBRc/Uspu1mUHv6MTnK4EZ68MABy4AK746mqKVyjFASLUWRG8UNwNlee8gS0kALfAI
         zUHZgh8NEFxj5qjRW8ATP+jn5XANbpEwkEMwiWeSlC2kt0vLTaJi0UkMRfwJE6fcIYDv
         zChcd2RysTd6F07cG6blA/4akeJMdpKYtVwCgO/QhToXW8JGjKsX7oo2ExYMyNCFcoV9
         cUlJgJNleyffhtlQEfdNtAkHPDlaIFKHH3Dwz2WZ/uZ4D4p/zlgIEXnrHE2/psD+RBV2
         VoeQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8gf7ltCtRsGbp2gplBMIiVNrp6WFYQJK0ebJfuyuvMo/tkqM+uZ3iOKtt+ZTgCszRN6U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7lozee69Fr4KdWIUgmJYOO80pspUB5ZiCb2eAKxsFzi9+CPey
	3KGcphsUCl6ZCYyl2YBkx6Xj072Yb8/SofRRvywPmehf6Rq/xGHpHSBynhNyGPltatiLsKssS4l
	IUOJwdE4IqBaH7fIm6bfKZUhO2ZS+PAeDAB+dglrX5sxn89OM3w==
X-Gm-Gg: ASbGncu/hdcxYbvy7gxVE8kDxaoSD0zSFTF8M14w2WUKtChNp7+e1B+QsIPe0Rltaat
	Oa8a7O9O9DjcJLnY9Furjts+DnvcovqfXntIAK1+F01JPgSr87N9A9bTEw1Dsdp5RB8QLT6+Qab
	XwhGKSGUm+KavIHraJ6Puv+6eRxVd4foI1EueluQzcfFdxT0aD5SS7lEjegg3xcFLSq0wRgSl1X
	5iPVaz8W5yZdQCIWrRzUYGKIt9eYVjQZWFRgM924KRQW8gOFkmy9h6X/ChrIhRkE9UpXKDCSaQV
	WKA+g5veew==
X-Received: by 2002:a05:600c:1e13:b0:43d:abd:ad0e with SMTP id 5b1f17b1804b1-43ecf8e72d6mr114694685e9.18.1744014874157;
        Mon, 07 Apr 2025 01:34:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+83STYsHXI3xn6x5xnem+/h77ehJWni3dU6P1EgXI8aWI6y/h2doOJ2sCUgok7+DS4MLeKg==
X-Received: by 2002:a05:600c:1e13:b0:43d:abd:ad0e with SMTP id 5b1f17b1804b1-43ecf8e72d6mr114694305e9.18.1744014873776;
        Mon, 07 Apr 2025 01:34:33 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec1630f21sm126976935e9.8.2025.04.07.01.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Apr 2025 01:34:33 -0700 (PDT)
Date: Mon, 7 Apr 2025 04:34:29 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Halil Pasic <pasic@linux.ibm.com>, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org, virtualization@lists.linux.dev,
	kvm@vger.kernel.org, Chandra Merla <cmerla@redhat.com>,
	Stable@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
	Thomas Huth <thuth@redhat.com>, Eric Farman <farman@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
Message-ID: <20250407042058-mutt-send-email-mst@kernel.org>
References: <20250404063619.0fa60a41.pasic@linux.ibm.com>
 <4a33daa3-7415-411e-a491-07635e3cfdc4@redhat.com>
 <d54fbf56-b462-4eea-a86e-3a0defb6298b@redhat.com>
 <20250404153620.04d2df05.pasic@linux.ibm.com>
 <d6f5f854-1294-4afa-b02a-657713435435@redhat.com>
 <20250404160025.3ab56f60.pasic@linux.ibm.com>
 <6f548b8b-8c6e-4221-a5d5-8e7a9013f9c3@redhat.com>
 <20250404173910.6581706a.pasic@linux.ibm.com>
 <20250407034901-mutt-send-email-mst@kernel.org>
 <2b187710-329d-4d36-b2e7-158709ea60d6@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b187710-329d-4d36-b2e7-158709ea60d6@redhat.com>

On Mon, Apr 07, 2025 at 10:17:10AM +0200, David Hildenbrand wrote:
> On 07.04.25 09:52, Michael S. Tsirkin wrote:
> > On Fri, Apr 04, 2025 at 05:39:10PM +0200, Halil Pasic wrote:
> > > > 
> > > > Not perfect, but AFAIKS, not horrible.
> > > 
> > > It is like it is. QEMU does queue exist if the corresponding feature
> > > is offered by the device, and that is what we have to live with.
> > 
> > I don't think we can live with this properly though.
> > It means a guest that does not know about some features
> > does not know where to find things.
> 
> Please describe a real scenario, I'm missing the point.


OK so.

Device has VIRTIO_BALLOON_F_FREE_PAGE_HINT and VIRTIO_BALLOON_F_REPORTING
Driver only knows about VIRTIO_BALLOON_F_REPORTING so
it does not know what does VIRTIO_BALLOON_F_FREE_PAGE_HINT do.
How does it know which vq to use for reporting?
It will try to use the free page hint one.



> Whoever adds new feat_X *must be aware* about all previous features,
> otherwise we'd be reusing feature bits and everything falls to pieces.


The knowledge is supposed be limited to which feature bit to use.



> > 
> > So now, I am inclined to add linux code to work with current qemu and
> > with spec compliant one, and add qemu code to work with current linux
> > and spec compliant one.
> > 
> > Document the bug in the spec, maybe, in a non conformance section.
> 
> I'm afraid this results in a lot of churn without really making things
> better.

> IMHO, documenting things how they actually behave, and maybe moving towards
> fixed queue indexes for new features is the low hanging fruit.

I worry about how to we ensure that?
If old code is messed up people will just keep propagating that.
I would like to fix old code so that new code is correct.

> 
> As raised, it's not just qemu+linux, it's *at least* also cloud-hypervisor.
> 
> -- 
> Cheers,
> 
> David / dhildenb

There's a slippery slope here in that people will come to us
with buggy devices and ask to change the spec.




-- 
MST


