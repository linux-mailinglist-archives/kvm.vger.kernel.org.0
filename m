Return-Path: <kvm+bounces-42832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 54609A7D9D4
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 11:38:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5651E188E96B
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 09:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A016230BC8;
	Mon,  7 Apr 2025 09:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rr19dGFZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B67822FE0F
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 09:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744018680; cv=none; b=jWJ6QpCGFB4tNXubFrLUZSiZm4I3MLtiflfONMCJxF+RX26ReoBWkrdLXE4zrnzjtGX4vomitIEkyyiSu/3cxL1cishNnsCCexe+k0ZHK407StL/Jw0OD5m1AmOJrxz09cozkpOYklE5nPMctPOmgO4SgMAj6BIDlIa613TBHIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744018680; c=relaxed/simple;
	bh=UYVpnQToVhKkeD2a7choe2evBwk4oKQuBCk3T1e9dSo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=frLxDDT3NYlgMDuphhPrk9T7IFWIHRLN/u83I2/UriswDpU2tAmTGFXL1/GO6VnRO7C/wG3wWJgRsgst38LoQq8LMuw9c6yQkQbqr6S/Q+9fuYsGhPX4pwflTeSdTRwFe/SOzOXdhgfR7CI+WRgM3Vcn6AHQXkot5iZgrUjlHGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rr19dGFZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744018677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dTru+5exuSFoOa7/E+HIvTf2c8suoUygvHtY3wcFXLI=;
	b=Rr19dGFZIwezT+XvsKu7x9U4t2b5RQTXDH9fB+SgFdgrTCw4x/MxATb2deZ6dc4va8+aGw
	NM1tuiFlN5qI2V8TdQlb3CtEp5+lgQXB8uxk3oeapa9mccar43na8+fJT9uwNz2R+Hufis
	Phxd6QuDKqISycpEiSdfi4Z3EKnGwgc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-0Xne5SmWPnG7MJgK_v_XXQ-1; Mon, 07 Apr 2025 05:37:55 -0400
X-MC-Unique: 0Xne5SmWPnG7MJgK_v_XXQ-1
X-Mimecast-MFC-AGG-ID: 0Xne5SmWPnG7MJgK_v_XXQ_1744018675
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43cfda30a3cso24834595e9.3
        for <kvm@vger.kernel.org>; Mon, 07 Apr 2025 02:37:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744018674; x=1744623474;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dTru+5exuSFoOa7/E+HIvTf2c8suoUygvHtY3wcFXLI=;
        b=HuagOjDojlCx8aId2YGhOjpQJT4nYLeDUlwz8vUQYwKsl63uQsp4nAFCMXLBRBWLN7
         YI9MnVwUVJ+HrCtMIkQaYxCkhNAr1qm8yJeGr7+5kDcJAkclgQoR+gaC6ZIHTWcd8hPr
         2q36112x1gimGF/7UVVG/PBl26v8VFYXNDGdsV84j3b8A5acwOm8FulMuqAe0Yyk/xsg
         EFC7Lv5TyHlicDRxIgrperxqJoMyuE+SGccWqz3aQmL2PEvYTlQ5oWw+PSKSjiCCtK1v
         6Kdb7J1o+fbRxmVvu2K2jFn6y8Li2Wq93bg7c6a2crOVLVUoEtt7hB9J11EIiYRCJAcQ
         iGDg==
X-Forwarded-Encrypted: i=1; AJvYcCVqLkI5nmxBNoPlHNCdVdLRK+sPeAU3AX+qmMHQK8Yrf++t+JekMDjKM+bGR/EBCZ6Iebg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRVjJbeqJNzJmqqr4akGzlVdT8d7i4Tv5E/2bplim53XjBZcU7
	xQsr6WqsFvOlhdkqwcwYkesxPbn6G8hFjU+D7TBhWnTnoBNd765/I9ljP1IliCdNJOk4qxla0br
	P4gGY8hM1PrJsrGs76LN///jxuSsRzAO0Z/++3V4ZhE9JUGCCEQ==
X-Gm-Gg: ASbGnctoS7WJmSsPYIxpEb/V+1d3NaPLLLcj6nhQ+1s2v8YT0zASThse/G5cvel6a1D
	/GxPHR7NOBcbwAkpbYItDKbATUiw/QEqnm/6q2pvIdwIeHOnJXnzm7xD0eeSfSmTRV7jEL9LCS9
	2/p6CyOWetBJJshYZNgt8+dj65/MkiDFW8IVqBQAr8EFtS7eQ6Yg19AfLsdnnrh5iiyjnfhE+P6
	gs1SFzLiQW30yH5m3ywPxgVPeoBejy4hyp9xTZQ9l2CP9ko/TRhOeNhnTML4lfUcV1XcCJuXom7
	/zZLVuOysA==
X-Received: by 2002:a05:600c:470d:b0:43d:47e:3205 with SMTP id 5b1f17b1804b1-43ecf85f23bmr79396965e9.11.1744018674550;
        Mon, 07 Apr 2025 02:37:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFRDexwe+g43YwqQL8SzrJOq1OlI7SDdhXyepzHhoBm7gIYyJsaf0/QWV3+ztzeILwqBFtKrA==
X-Received: by 2002:a05:600c:470d:b0:43d:47e:3205 with SMTP id 5b1f17b1804b1-43ecf85f23bmr79396625e9.11.1744018674172;
        Mon, 07 Apr 2025 02:37:54 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ec17b33c2sm132022505e9.40.2025.04.07.02.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Apr 2025 02:37:53 -0700 (PDT)
Date: Mon, 7 Apr 2025 05:37:50 -0400
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
Message-ID: <20250407053037-mutt-send-email-mst@kernel.org>
References: <6f548b8b-8c6e-4221-a5d5-8e7a9013f9c3@redhat.com>
 <20250404173910.6581706a.pasic@linux.ibm.com>
 <20250407034901-mutt-send-email-mst@kernel.org>
 <2b187710-329d-4d36-b2e7-158709ea60d6@redhat.com>
 <20250407042058-mutt-send-email-mst@kernel.org>
 <0c221abf-de20-4ce3-917d-0375c1ec9140@redhat.com>
 <20250407044743-mutt-send-email-mst@kernel.org>
 <b331a780-a9db-4d76-af7c-e9e8e7d1cc10@redhat.com>
 <20250407045456-mutt-send-email-mst@kernel.org>
 <a86240bc-8417-48a6-bf13-01dd7ace5ae9@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a86240bc-8417-48a6-bf13-01dd7ace5ae9@redhat.com>

On Mon, Apr 07, 2025 at 11:11:34AM +0200, David Hildenbrand wrote:
> On 07.04.25 10:58, Michael S. Tsirkin wrote:
> > On Mon, Apr 07, 2025 at 10:54:00AM +0200, David Hildenbrand wrote:
> > > On 07.04.25 10:49, Michael S. Tsirkin wrote:
> > > > On Mon, Apr 07, 2025 at 10:44:21AM +0200, David Hildenbrand wrote:
> > > > > > 
> > > > > > 
> > > > > > 
> > > > > > > Whoever adds new feat_X *must be aware* about all previous features,
> > > > > > > otherwise we'd be reusing feature bits and everything falls to pieces.
> > > > > > 
> > > > > > 
> > > > > > The knowledge is supposed be limited to which feature bit to use.
> > > > > 
> > > > > I think we also have to know which virtqueue bits can be used, right?
> > > > > 
> > > > 
> > > > what are virtqueue bits? vq number?
> > > 
> > > Yes, sorry.
> > 
> > I got confused myself, it's vq index actually now, we made the spec
> > consistent with that terminology. used to be number/index
> > interchangeably.
> > 
> > > Assume cross-vm as an example. It would make use of virtqueue indexes 5+6
> > > with their VIRTIO_BALLOON_F_WS_REPORTING.
> > 
> > 
> > crossvm guys really should have reserved the feature bit even if they
> > did not bother specifying it. Let's reserve it now at least?
> 
> Along with the virtqueue indices, right?

Well ... as long as the implementation is careful to check that feature
is negotiated, reusing vq index at least causes no trouble for others.


> Note that there was
> 
> https://lists.gnu.org/archive/html/qemu-devel/2023-05/msg02503.html
> 
> and
> 
> https://groups.oasis-open.org/communities/community-home/digestviewer/viewthread?GroupId=3973&MessageKey=afb07613-f56c-4d40-8981-2fad1c723998&CommunityKey=2f26be99-3aa1-48f6-93a5-018dce262226&hlmlt=VT
> 
> But it only was RFC, and as the QEMU implementation didn't materialize,
> nobody seemed to care ...

Thanks! I will try poke the author again.


> > 
> > 
> > > So whatever feature another device implements couldn't use this feature bit
> > > or these virtqueue indexes.
> > > 
> > > (as long the other device never intends to implement
> > > VIRTIO_BALLOON_F_WS_REPORTING, the virtqueue indexes could be reused. But
> > > the spec will also be a mess, because virtqueue indexes could also have
> > > duplicate meanings ... ugh)
> > 
> > what do they do with vq indices btw?
> 
> See above links, they use the two for "s_vq and notification_vq".
> 
> -- 
> Cheers,
> 
> David / dhildenb


