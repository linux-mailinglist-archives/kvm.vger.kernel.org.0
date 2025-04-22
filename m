Return-Path: <kvm+bounces-43822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37BCDA96CFD
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 15:37:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5F150175E2A
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 13:36:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9878128153A;
	Tue, 22 Apr 2025 13:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P1cDfsDF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0E22749C7
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 13:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745328972; cv=none; b=sR4wK7mo8qcK1PHlz0HTdXWfjx51uzjPKiWhZHN81dvZcRqCxKhdPWR3jmTQZD/W+zUs9nAnMI2VgS3LpN6iIaHJPaQNnyqtKtlNK5FovT6kForNjyPaIpjOVvFzVc3u3OrAzTnnH7QADCpfUYSPqBcR2U3eyHVUvRbsB2R3X4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745328972; c=relaxed/simple;
	bh=MhJ6N+6JZAFe/JvD8yyHGfBmPBcTg8eAd1GjxfpVjew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GA2kYSnukeS2fDcBfugZTKF2yMpWQ5ZAM/p86Prmgb8Dr3/h6MZyqWk5mcoUQ3kQRwAs0yMxQ0e3PMJ/5sUq9CJ/fRyjKeK4Y3uAqkLYjuBzXkAwD0B1a+gj9n3E5sj+UVru651wZEBZTdwiLLtEo3sx/l2wAiwm7YzILpGh8o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P1cDfsDF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745328969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y4IJdBYSNW9wdRnD2IO79uxHJEEzuWz9Azk+82pxLcg=;
	b=P1cDfsDFtz/r9ile8hgUYIZIKcKJiv29qRP4AZLfSF2/PFF/Ny+mJQYGRelfbu20LbRk8R
	Qr41oDQ2Kd5y2fiuCFZj2D2Ejyu5hRrv3TNKRPDVyOJ/inJL2LUNqdmtD+mac3zrpg/eU+
	xNbkr4/QawgnzD7s5stf+2TEL38RyHg=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-T_7j9kkZPKasUA8b0IYnRg-1; Tue, 22 Apr 2025 09:36:08 -0400
X-MC-Unique: T_7j9kkZPKasUA8b0IYnRg-1
X-Mimecast-MFC-AGG-ID: T_7j9kkZPKasUA8b0IYnRg_1745328967
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-acb66d17be4so342405066b.2
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 06:36:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745328967; x=1745933767;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y4IJdBYSNW9wdRnD2IO79uxHJEEzuWz9Azk+82pxLcg=;
        b=OSGK+Hg0ZNknFRG2psO+aD/O18TrqCFlAzzF8b+hVDxjENEKG1Wn4KI8ycHVrhuBee
         l53kWVxyN/OKm+8LRxgTQMmwDWcXNOjOUJAVic5vDoUVdQ38gx/GQZDzAZpHQnvDjnIZ
         Y9pSCRvJrNHy9cYdOovSC/vM4uXhtN4MhoeVeB9oNS0f/4nvTD96YqsJ3mDLfQZ0/zXH
         OWVpb6rDwdufSRWQ4d1rt4w9HvOMo8XMtaVZzUrdql5gOtMJBbC/skltGfEpesNPqchP
         /6EDj4lCaapIGwf+vnDXYG6XJJfhl+Y/bB/B60NWCjFj4sfBwcgxsmfOGchsZmXHmcCg
         Nw9w==
X-Forwarded-Encrypted: i=1; AJvYcCWbXZdmc35hfs0+cXYXvUhnlhnNVGBDsNzeCpMyUbkI9/AnaPRo1hhXlxiobWwCNyjzLSY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8oRr8LK9bjHsln34NMDveEvYZCoBtS8Ms7s7wZ2KS0AmEJHIw
	tk2IIOlIjUVUlDeYYWGj0rPgVBw0FDzZetB3h7XaN0UsHDHs96AFMGjQ++7LXtkgG9d8Yxj7NNJ
	+OETErTq6bNe2Y6XQLXifA0BZnDIMkflMwL5SGv3FPbDSNWLW6Q==
X-Gm-Gg: ASbGncv0J88D3YyJFRFra1HwldPJ0128+4NLcjT9HpreW4WMjZUSC0iIjE5h/nhJKL+
	Ak+16iXJcU71tdIrVg7K8xE91krAkCWRkYa4+dUGF8WeorLfjEryr9aPNA0emFsXdiALCxEzJmZ
	rkLswcxt6fgK3nFQ8grTD9VFuNFfCvAj7vZ2BYdPxUYbSNTV2iLFlCGAEsBprzMnEj64fXoh7OP
	F5sw2RId/JRbgRRUKgFJyA3gLyd4cvIgrV6OXpuuDD8lEbGqgj1ck+73+16x2G9t3RCd2L9SihK
	lBlymALL8iLXRqaz
X-Received: by 2002:a17:906:794b:b0:acb:6401:1d78 with SMTP id a640c23a62f3a-acb74b3babbmr1327403566b.22.1745328967029;
        Tue, 22 Apr 2025 06:36:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBkiqCdJcdh4nLSjqfuJ0gy11q1xiL79JrcHiQzXtTr8fDrs+JOgRZWCNY3kyY1iJGy5Dzng==
X-Received: by 2002:a17:906:794b:b0:acb:6401:1d78 with SMTP id a640c23a62f3a-acb74b3babbmr1327397766b.22.1745328966303;
        Tue, 22 Apr 2025 06:36:06 -0700 (PDT)
Received: from sgarzare-redhat ([193.207.218.81])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb6ec0b302sm654711166b.3.2025.04.22.06.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 06:36:05 -0700 (PDT)
Date: Tue, 22 Apr 2025 15:35:57 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>, 
	Jakub Kicinski <kuba@kernel.org>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
	Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, "David S. Miller" <davem@davemloft.net>, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/3] vsock: add namespace support to vhost-vsock
Message-ID: <shj5e5sweuvhk4onjbnwb3h7m6mx22nnm6kivtchjgbscisrr2@mvuowcp7c33p>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <r6a6ihjw3etlb5chqsb65u7uhcav6q6pjxu65iqpp76423w2wd@kmctvoaywmbu>
 <Z-w47H3qUXZe4seQ@redhat.com>
 <Z+yDCKt7GpubbTKJ@devvm6277.cco0.facebook.com>
 <CAGxU2F7=64HHaAD+mYKYLqQD8rHg1CiF1YMDUULgSFw0WSY-Aw@mail.gmail.com>
 <Z-0BoF4vkC2IS1W4@redhat.com>
 <Z+23pbK9t5ckSmLl@devvm6277.cco0.facebook.com>
 <Z-_ZHIqDsCtQ1zf6@redhat.com>
 <aAKSoHQuycz24J5l@devvm6277.cco0.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aAKSoHQuycz24J5l@devvm6277.cco0.facebook.com>

On Fri, Apr 18, 2025 at 10:57:52AM -0700, Bobby Eshleman wrote:
>On Fri, Apr 04, 2025 at 02:05:32PM +0100, Daniel P. Berrangé wrote:
>> On Wed, Apr 02, 2025 at 03:18:13PM -0700, Bobby Eshleman wrote:
>> > On Wed, Apr 02, 2025 at 10:21:36AM +0100, Daniel P. Berrangé wrote:
>> > > It occured to me that the problem we face with the CID space usage is
>> > > somewhat similar to the UID/GID space usage for user namespaces.
>> > >
>> > > In the latter case, userns has exposed /proc/$PID/uid_map & gid_map, to
>> > > allow IDs in the namespace to be arbitrarily mapped onto IDs in the host.
>> > >
>> > > At the risk of being overkill, is it worth trying a similar kind of
>> > > approach for the vsock CID space ?
>> > >
>> > > A simple variant would be a /proc/net/vsock_cid_outside specifying a set
>> > > of CIDs which are exclusively referencing /dev/vhost-vsock associations
>> > > created outside the namespace. Anything not listed would be exclusively
>> > > referencing associations created inside the namespace.
>> > >
>> > > A more complex variant would be to allow a full remapping of CIDs as is
>> > > done with userns, via a /proc/net/vsock_cid_map, which the same three
>> > > parameters, so that CID=15 association outside the namespace could be
>> > > remapped to CID=9015 inside the namespace, allow the inside namespace
>> > > to define its out association for CID=15 without clashing.
>> > >
>> > > IOW, mapped CIDs would be exclusively referencing /dev/vhost-vsock
>> > > associations created outside namespace, while unmapped CIDs would be
>> > > exclusively referencing /dev/vhost-vsock associations inside the
>> > > namespace.
>> > >
>> > > A likely benefit of relying on a kernel defined mapping/partition of
>> > > the CID space is that apps like QEMU don't need changing, as there's
>> > > no need to invent a new /dev/vhost-vsock-netns device node.
>> > >
>> > > Both approaches give the desirable security protection whereby the
>> > > inside namespace can be prevented from accessing certain CIDs that
>> > > were associated outside the namespace.
>> > >
>> > > Some rule would need to be defined for updating the /proc/net/vsock_cid_map
>> > > file as it is the security control mechanism. If it is write-once then
>> > > if the container mgmt app initializes it, nothing later could change
>> > > it.
>> > >
>> > > A key question is do we need the "first come, first served" behaviour
>> > > for CIDs where a CID can be arbitrarily used by outside or inside namespace
>> > > according to whatever tries to associate a CID first ?
>> >
>> > I think with /proc/net/vsock_cid_outside, instead of disallowing the CID
>> > from being used, this could be solved by disallowing remapping the CID
>> > while in use?
>> >
>> > The thing I like about this is that users can check
>> > /proc/net/vsock_cid_outside to figure out what might be going on,
>> > instead of trying to check lsof or ps to figure out if the VMM processes
>> > have used /dev/vhost-vsock vs /dev/vhost-vsock-netns.
>> >
>> > Just to check I am following... I suppose we would have a few typical
>> > configurations for /proc/net/vsock_cid_outside. Following uid_map file
>> > format of:
>> > 	"<local cid start>		<global cid start>		<range size>"
>> >
>> > 	1. Identity mapping, current namespace CID is global CID (default
>> > 	setting for new namespaces):
>> >
>> > 		# empty file
>> >
>> > 				OR
>> >
>> > 		0    0    4294967295
>> >
>> > 	2. Complete isolation from global space (initialized, but no mappings):
>> >
>> > 		0    0    0
>> >
>> > 	3. Mapping in ranges of global CIDs
>> >
>> > 	For example, global CID space starts at 7000, up to 32-bit max:
>> >
>> > 		7000    0    4294960295
>> > 	
>> > 	Or for multiple mappings (0-100 map to 7000-7100, 1000-1100 map to
>> > 	8000-8100) :
>> >
>> > 		7000    0       100
>> > 		8000    1000    100
>> >
>> >
>> > One thing I don't love is that option 3 seems to not be addressing a
>> > known use case. It doesn't necessarily hurt to have, but it will add
>> > complexity to CID handling that might never get used?
>>
>> Yeah, I have the same feeling that full remapping of CIDs is probably
>> adding complexity without clear benefit, unless it somehow helps us
>> with the nested-virt scenario to disambiguate L0/L1/L2 CID ranges ?
>> I've not thought the latter through to any great level of detail
>> though
>>
>> > Since options 1/2 could also be represented by a boolean (yes/no
>> > "current ns shares CID with global"), I wonder if we could either A)
>> > only support the first two options at first, or B) add just
>> > /proc/net/vsock_ns_mode at first, which supports only "global" and
>> > "local", and later add a "mapped" mode plus /proc/net/vsock_cid_outside
>> > or the full mapping if the need arises?
>>
>> Two options is sufficient if you want to control AF_VSOCK usage
>> and /dev/vhost-vsock usage as a pair. If you want to separately
>> control them though, it would push for three options - global,
>> local, and mixed. By mixed I mean AF_VSOCK in the NS can access
>> the global CID from the NS, but the NS can't associate the global
>> CID with a guest.
>>
>> IOW, this breaks down like:
>>
>>  * CID=N local - aka fully private
>>
>>      Outside NS: Can associate outside CID=N with a guest.
>>                  AF_VSOCK permitted to access outside CID=N
>>
>>      Inside NS: Can NOT associate outside CID=N with a guest
>>                 Can associate inside CID=N with a guest
>>                 AF_VSOCK forbidden to access outside CID=N
>>                 AF_VSOCK permitted to access inside CID=N
>>
>>
>>  * CID=N mixed - aka partially shared
>>
>>      Outside NS: Can associate outside CID=N with a guest.
>>                  AF_VSOCK permitted to access outside CID=N
>>
>>      Inside NS: Can NOT associate outside CID=N with a guest
>>                 AF_VSOCK permitted to access outside CID=N
>>                 No inside CID=N concept
>>
>>
>>  * CID=N global - aka current historic behaviour
>>
>>      Outside NS: Can associate outside CID=N with a guest.
>>                  AF_VSOCK permitted to access outside CID=N
>>
>>      Inside NS: Can associate outside CID=N with a guest
>>                 AF_VSOCK permitted to access outside CID=N
>>                 No inside CID=N concept
>>
>>
>> I was thinking the 'mixed' mode might be useful if the outside NS wants
>> to retain control over setting up the association, but delegate to
>> processes in the inside NS for providing individual services to that
>> guest.  This means if the outside NS needs to restart the VM, there is
>> no race window in which the inside NS can grab the assocaition with the
>> CID
>>
>> As for whether we need to control this per-CID, or a single setting
>> applying to all CID.
>>
>> Consider that the host OS can be running one or more "service VMs" on
>> well known CIDs that can be leveraged from other NS, while those other
>> NS also run some  "end user VMs" that should be private to the NS.
>>
>> IOW, the CIDs for the service VMs would need to be using "mixed"
>> policy, while the CIDs for the end user VMs would be "local".
>>
>
>I think this sounds pretty flexible, and IMO adding the third mode
>doesn't add much more additional complexity.
>
>Going this route, we have:
>- three modes: local, global, mixed
>- at first, no vsock_cid_map (local has no outside CIDs, global and mixed have no inside
>	CIDs, so no cross-mapping needed)
>- only later add a full mapped mode and vsock_cid_map if necessary.
>
>Stefano, any preferences on this vs starting with the restricted
>vsock_cid_map (only supporting "0 0 0" and "0 0 <size>")?

No preference, I also like this idea.

>
>I'm leaning towards the modes because it covers more use cases and seems
>like a clearer user interface?

Sure, go head!

>
>To clarify another aspect... child namespaces must inherit the parent's
>local. So if namespace P sets the mode to local, and then creates a
>child process that then creates namespace C... then C's global and mixed
>modes are implicitly restricted to P's local space?

I think so, but it's still not clear to me if the mode can be selected 
per namespace or it's a setting for the entire system, but I think we 
can discuss this better on a proposal with some code :-)

Thanks,
Stefano


