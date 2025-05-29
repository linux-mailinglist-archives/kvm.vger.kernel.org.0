Return-Path: <kvm+bounces-47923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5333FAC75FD
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 04:58:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0241F4E5E47
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 02:58:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E203B24676F;
	Thu, 29 May 2025 02:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cVcifYV7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CB73D81
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 02:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748487492; cv=none; b=S0MFrFX30KJgto5s7NhG4U7ANIEQEBmg/crc29MKDTWXfy8/j7b/a4szxbeCk+ROHCTrzuK9s5vk5+TUrlIxRRlt/2hjGF7jOwJKyorY4ruPGwerwuf3gPSl/1S7RFE+juh26Zc5h6OoUnC9EM1Wxd6uq5BnJ3clQu2GzXgAvRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748487492; c=relaxed/simple;
	bh=rpoEA0roPA/6WnDuf+djP3mNqirr541LfjalROplITo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o6vsxSx3zBJLDSf3FRpQXRSfxfUM6fUn0rqqqfqtutE+oHpl0iDNTAYHdai8fRcBLTTG7J9i4LO+dD+YHCHmm+CEeyqnDVsD3aq6ExrQ59hKW9+a68yEfU3dvw2vhmGfwtm9YJypAZLifgHm3nlT1bPMSXheCwoePqkIf2tPm8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cVcifYV7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748487489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JhOTjzJrPC2AOwQMqb7KHh6NpQfzO802QIZm6oK5pK0=;
	b=cVcifYV7WGQ5rj79mWekDv1DDaXIgiofxA+6qrLcavzmiHkBtgIO5kU2aN/B8llQnWAS+o
	lPEQ6iLUNNd3WsUGOyW0rsX54OF+nR5aG+3TGlb3APT2OKZAgI2bfEKi2UCqfosqkZPgTu
	2zrhDT8D1flfhNmMPO/1DMUOojJc0iQ=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-CdarQyYYPdWBMENafXcTLw-1; Wed, 28 May 2025 22:58:07 -0400
X-MC-Unique: CdarQyYYPdWBMENafXcTLw-1
X-Mimecast-MFC-AGG-ID: CdarQyYYPdWBMENafXcTLw_1748487486
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3dd7b91575fso335745ab.0
        for <kvm@vger.kernel.org>; Wed, 28 May 2025 19:58:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748487486; x=1749092286;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JhOTjzJrPC2AOwQMqb7KHh6NpQfzO802QIZm6oK5pK0=;
        b=Ee5ewdDgogCbq3LIyQlwVVPcaa6BI63diNej66QhyfOuer4R4dVBVgVepuTtd2ewIf
         elcxu/GwdL1WMIbRIw19an4463BnGyBgn/Mj1p428DBkhLyWw+w/3tQc2w/IDQCsLQ2D
         pdh6sdt/7/02OUpB2NbNfw6F5IdqORMpDMXiVt2jrhwuKL0ZDFPnIjSjEIdto9YYICRo
         NbvFqCLu7EQYLoHybWfh68rrGefJ8AGDLnu4BXjdsqY7XsQ44e1MF/ihQnGaqeYqrkyx
         wIteqbCgLFqrkW3Ut9PQmWpv/iRJ6tNt12V2wr8WbxbJiIcW4rAyWw1skaceXgTqBwTB
         z+Eg==
X-Forwarded-Encrypted: i=1; AJvYcCXPto8buC5+8uLwpPpTDpLVydx1B6bxSUSewBrzOqU9EnaCjsxcmO43U0pgnLrfD84ZKcU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3EYH1BCvHJukYm0LNDmyRZRQNwOhyexJOWCzWNjLroyFshqCs
	ymNtQiELpC0n6sdzUEZwYkggaXSf3AWrq1dl7oClD98a98kre0I8qJkrpKxad2JM/GD2mBE6pco
	C1E8HMW2tiBHbbuA4oGDJAtkz1ddD5yeYW4VFuGfQVrYNSvMkJ0uc6A==
X-Gm-Gg: ASbGncscvB6DEwyTiIbTMvHT3kazHgKe0vQkhhm6uYgL6Z/B9NDdtY7a2z2BcqkExkf
	e0thuiRLhPN6S28tonMm7eF5PRIvc5UHA8JeG4+RTFXKED17wcS7BYtDAoQ2/j/wKqd8ynFzOV1
	RBzsM2xVmSKIdhc6THENqFKRgjW5Qvzq4qDe+2c2dVq0A3Y8sGpbnLtas4RpdDvMC46DbHoT53R
	OCTOZSmJEhC2bB9u10DeIi9hTaI5gX6yUFuOoJEKGK8KW+gNOiO4fQNLQCZpF4H0kbPHCFGqLJL
	je+BMqQM0PwhCvo=
X-Received: by 2002:a92:c24b:0:b0:3dd:929f:87c2 with SMTP id e9e14a558f8ab-3dd929f8a5dmr5146925ab.7.1748487486194;
        Wed, 28 May 2025 19:58:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFb9GEkjqdTNwnQ3NojrRwht7jJ0rh2LGkVZ67MSilHKitPlGwHazNwznnW4jK5o90PouRrxA==
X-Received: by 2002:a92:c24b:0:b0:3dd:929f:87c2 with SMTP id e9e14a558f8ab-3dd929f8a5dmr5146855ab.7.1748487485817;
        Wed, 28 May 2025 19:58:05 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdbd4bb4d1sm495356173.57.2025.05.28.19.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 May 2025 19:58:04 -0700 (PDT)
Date: Wed, 28 May 2025 20:58:02 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: David Hildenbrand <david@redhat.com>, lizhe.67@bytedance.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, muchun.song@linux.dev
Subject: Re: [PATCH v3] vfio/type1: optimize vfio_pin_pages_remote() for
 huge folio
Message-ID: <20250528205802.4afb3a1b.alex.williamson@redhat.com>
In-Reply-To: <20250529005147.GC192517@ziepe.ca>
References: <20250520070020.6181-1-lizhe.67@bytedance.com>
	<3f51d180-becd-4c0d-a156-7ead8a40975b@redhat.com>
	<20250520162125.772d003f.alex.williamson@redhat.com>
	<ff914260-6482-41a5-81f4-9f3069e335da@redhat.com>
	<20250521105512.4d43640a.alex.williamson@redhat.com>
	<20250526201955.GI12328@ziepe.ca>
	<20250527135252.7a7cfe21.alex.williamson@redhat.com>
	<20250527234627.GB146260@ziepe.ca>
	<20250528140941.151b2f70.alex.williamson@redhat.com>
	<20250529005147.GC192517@ziepe.ca>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 28 May 2025 21:51:47 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Wed, May 28, 2025 at 02:09:41PM -0600, Alex Williamson wrote:
> 
> > To be fair to libvirt, we'd really like libvirt to make use of iommufd
> > whenever it's available, but without feature parity this would break
> > users.    
> 
> If people ask there should be no issue with making API functionality
> discoverable with a query command of some kind. Alot of new stuff is
> already discoverable by invoking an ioctl with bogus arguments and
> checking for EOPNOTSUPP/ENOTTY.
> 
> But most likely P2P will use the same ioctl as memfd so it will not
> work that way.
> 
> So for now libvirt could assume no P2P support in iommufd. A simple
> algorithm would be to look for more than 1 VFIO device. Or add an xml
> "disable P2P" which is a useful thing anyhow.

Hotplug is always a problem if we make assumptions based on device
counts.  Thanks,

Alex


