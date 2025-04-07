Return-Path: <kvm+bounces-42845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E34D0A7DF5B
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 15:34:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 037927A4922
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 13:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE90F170A37;
	Mon,  7 Apr 2025 13:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DFqxnFcK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EE3156F4A
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 13:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744032748; cv=none; b=Hh1qhBp0ifMFMAMD288QrqB2/5CL4ZLgWDFqtdYsLBvLIwD9BCkgSQhnuZBYcnjeWjf5MmqkxxyGFNFfNjmoPHhRl0eMiHJb90eR9YFz7ZmjFXz1kSsxGXYOdkcljI6JV1a6ADH02QKHXwambq7rUPdEL9yEry8Mqee4iyrITc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744032748; c=relaxed/simple;
	bh=OuqnqTBRovbLLVo3HjN6qkc40vRHSouYVZwbCzzmelk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SiA2oMmno6GgU3dDMlDL5dDXnDPHf9e8sm0s1Z3cEMNQsXCBRJ3WqbyB6Z0xyhXD34ku+QOMCHnTzYt7OH/QzsODs/ksdNbGjyGZilkXjxlLneI7jJAgrKGvcy2Z/VnYY29n3Qoy5gW1zmAN5/Weh/49xvv7xpospbI5p2ajSEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DFqxnFcK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744032742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=h2t9badq02L1YqSPP4iwtiUyd5ByYzFMz5Gq8uEjc+Q=;
	b=DFqxnFcKeeDY59rfkJkHqIrkMQl/9T/a1aDZ/Ljo0lKn0R7j9OrSi+IITmPbWYw/zfoPV8
	sGyd3G/+nyEp0XPdwOI+pQldM7XA4AcNmQj8yaY9i+erGwLOD04Ue00KmgE90n32Z+pCao
	ylB4jQlm5bJjJDtxLYTay/gofj3d2M8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-306-fIiMaIdWM6qD5JuFTVeZtw-1; Mon, 07 Apr 2025 09:32:19 -0400
X-MC-Unique: fIiMaIdWM6qD5JuFTVeZtw-1
X-Mimecast-MFC-AGG-ID: fIiMaIdWM6qD5JuFTVeZtw_1744032738
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-39134c762ebso1930550f8f.0
        for <kvm@vger.kernel.org>; Mon, 07 Apr 2025 06:32:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744032738; x=1744637538;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h2t9badq02L1YqSPP4iwtiUyd5ByYzFMz5Gq8uEjc+Q=;
        b=PBsGVhCjEHljcPBOFJ/qSDz7qf3F3xc+MZq4HguTNcKiuZvFwHM9F0dhcU3fJGNYNR
         bZUeUajMhOZISGMnQIKiOkjdgb3EPAwCfBMIaixXTOEkHuz2whlaUuHaf6MxafsyK3L5
         gRbrmy7e0EZiyseUEVbAClup2ExAYiVmqKCHDD0zlunF+ivRLJdbS6WnbFi4oixfCqtJ
         4XRoQBnKz3qny9Gp5f+IuP4rBDOejWC/ZPCiCFPMpavAc/FREpsguBdwjCA7IBECRz0P
         vAkmPxsU51jnd+3R6jKwJsffG+1wL19NclL+lm8tH8pdtZIZHtUzELWntpea9ntJblSb
         L3GQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4t7Hm4MSJxlrdttXpNNQaUvGR12CGSGuQb4qsAsr+Ni7pmfQEQGJF/2viposdIUHBjB0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRAcA0PZ1SS+7T2uPdzC0c6b/vTFoPLY8SO7I5S8tYzBaWQPQN
	JU5xv21+XH/XzckKpEISs8DJfGboqkF9YIVvJ7W7IMCzYmUBA27HjtHoyvFDPXb5zBEOsAWPGnD
	IcWzC0ydRU+N3+nvGxBltn8GJ+fQ9uKolK153+k59//Jfpgu/wg==
X-Gm-Gg: ASbGnctLuh5uPPKkbxNZfBBVutgY1Lj94BHkLFqdmIQCJ/oCsc1sTm36FswYsj3Hfv3
	TPdoeyHJwZr1I/nHxEyfmwIoLwsPSFhv1g8QaV2bE0rGnLpzQoaAOw6WmgJ0Sy70kGymLOa7QWa
	RSIWC7VIM2nczYJh6WFU8/lE2ohanzsCOMxhM30OMaN/jvUi/U/b4Q4lZ1gUXXLr1HFHZ7ZN2AP
	rzg18IrboGQjtGOgqEo9ZrbEMk4YZIKOSthmOdBeLEgmKfe/ybrPwRW6JZIX1EXd8KvAnoZzmg9
	N/2sbvfrAg==
X-Received: by 2002:a5d:64cb:0:b0:391:3f64:ed00 with SMTP id ffacd0b85a97d-39d6fc4e930mr7966135f8f.26.1744032738414;
        Mon, 07 Apr 2025 06:32:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGvXFTZnDhg+4j5062m2TfC0SmlVES+KRW+YMFO/ahaSOai2rwVuCa6Gs1wgPmSJN+hQ8wtpg==
X-Received: by 2002:a5d:64cb:0:b0:391:3f64:ed00 with SMTP id ffacd0b85a97d-39d6fc4e930mr7966079f8f.26.1744032737999;
        Mon, 07 Apr 2025 06:32:17 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c3020da49sm11908898f8f.80.2025.04.07.06.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Apr 2025 06:32:17 -0700 (PDT)
Date: Mon, 7 Apr 2025 09:32:14 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cornelia Huck <cohuck@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	Chandra Merla <cmerla@redhat.com>, Stable@vger.kernel.org,
	Thomas Huth <thuth@redhat.com>, Eric Farman <farman@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH v1] s390/virtio_ccw: don't allocate/assign airqs for
 non-existing queues
Message-ID: <20250407093047-mutt-send-email-mst@kernel.org>
References: <d6f5f854-1294-4afa-b02a-657713435435@redhat.com>
 <20250404160025.3ab56f60.pasic@linux.ibm.com>
 <6f548b8b-8c6e-4221-a5d5-8e7a9013f9c3@redhat.com>
 <20250404173910.6581706a.pasic@linux.ibm.com>
 <20250407034901-mutt-send-email-mst@kernel.org>
 <2b187710-329d-4d36-b2e7-158709ea60d6@redhat.com>
 <20250407042058-mutt-send-email-mst@kernel.org>
 <20250407151249.7fe1e418.pasic@linux.ibm.com>
 <9126bfbf-9461-4959-bd38-1d7bc36d7701@redhat.com>
 <87h6309k42.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h6309k42.fsf@redhat.com>

On Mon, Apr 07, 2025 at 03:28:13PM +0200, Cornelia Huck wrote:
> On Mon, Apr 07 2025, David Hildenbrand <david@redhat.com> wrote:
> 
> > On 07.04.25 15:12, Halil Pasic wrote:
> >> On Mon, 7 Apr 2025 04:34:29 -0400
> >> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> >> 
> >>> On Mon, Apr 07, 2025 at 10:17:10AM +0200, David Hildenbrand wrote:
> >>>> On 07.04.25 09:52, Michael S. Tsirkin wrote:
> >>>>> On Fri, Apr 04, 2025 at 05:39:10PM +0200, Halil Pasic wrote:
> >>>>>>>
> >>>>>>> Not perfect, but AFAIKS, not horrible.
> >>>>>>
> >>>>>> It is like it is. QEMU does queue exist if the corresponding feature
> >>>>>> is offered by the device, and that is what we have to live with.
> >>>>>
> >>>>> I don't think we can live with this properly though.
> >>>>> It means a guest that does not know about some features
> >>>>> does not know where to find things.
> >>>>
> >>>> Please describe a real scenario, I'm missing the point.
> >>>
> >>>
> >>> OK so.
> >>>
> >>> Device has VIRTIO_BALLOON_F_FREE_PAGE_HINT and VIRTIO_BALLOON_F_REPORTING
> >>> Driver only knows about VIRTIO_BALLOON_F_REPORTING so
> >>> it does not know what does VIRTIO_BALLOON_F_FREE_PAGE_HINT do.
> >>> How does it know which vq to use for reporting?
> >>> It will try to use the free page hint one.
> >> 
> >> First, sorry for not catching up again with the discussion earlier.
> >> 
> >> I think David's point is based on the assumption that by the time feature
> >> with the feature bit N+1 is specified and allocates a queue Q, all
> >> queues with indexes smaller than Q are allocated and possibly associated
> >> with features that were previously specified (and probably have feature
> >> bits smaller than N+1).
> >> 
> >> I.e. that we can mandate, even if you don't want to care about other
> >> optional features, you have to, because we say so, for the matter of
> >> virtqueue existence. And anything in the future, you don't have to care
> >> about because the queue index associated with future features is larger
> >> than Q, so it does not affect our position.
> >> 
> >> I think that argument can fall a part if:
> >> * future features reference optional queues defined in the past
> >> * somebody managed to introduce a limbo where a feature is reserved, and
> >>    they can not decide if they want a queue or not, or make the existence
> >>    of the queue depend on something else than a feature bit.
> >
> > Staring at the cross-vmm, including the adding+removing of features and 
> > queues that are not in the spec, I am wondering if (in a world with 
> > fixed virtqueues)
> >
> > 1) Feature bits must be reserved before used.
> >
> > 2) Queue indices must be reserved before used.
> >
> > It all smells like a problem similar to device IDs ...
> 
> Indeed, we need a rule "reserve a feature bit/queue index before using
> it, even if you do not plan to spec it properly".


Reserving feature bits is something I do my best to advocate for
in all presentations I do.


-- 
MST


