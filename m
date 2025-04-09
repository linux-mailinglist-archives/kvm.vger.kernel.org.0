Return-Path: <kvm+bounces-43008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1368A822EA
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 12:56:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FCB717D656
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 10:56:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAED325DB1A;
	Wed,  9 Apr 2025 10:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ixxqMDGy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E6525DAE3
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 10:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744196188; cv=none; b=lSN6Hv37/TUo0ZZpjRTKkLCmduBD2vDYeAtkq1i3m0UoihTp1tAmdCOdPnHYuIqntp8XEQ3TwqSr9E2oH1iTSSslor8XV7rCtRgv7svRAA2ELPelWkkF19oRqNe4NrOKflGzo9fSo00m0M3uxbPaxomcK81n7F2iRWHn8OKqV+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744196188; c=relaxed/simple;
	bh=LTCwaImwKuvWXY2scLkUXgWwOFI49yWpZ+qPbyisx2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bGnFFyW1furgf6k9Olp3gtxdq8mQNCdMTK8vb5qPbfREVcVJezka4HQ9WqyQYFjBIih4AFJITGNCUJe020/9hBjOQawbdzClzIDMtmSdGtUfLanJRMuUy+G455KyiPlXXCnR4pqBA9+rK3TSzXc4xHQlXiYHEZ4fN3K7qPQQgkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ixxqMDGy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744196185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Giukvq1XMekOaAYyLauP2qjMQgVPWM9Bad3lqnf3cCw=;
	b=ixxqMDGyqDi8ws85MxA1Bbw9uSgqBf+7qHGJV1iDLH3p+YMKHwaFje2mSc/A8ef01TzmmR
	GIZCOWp4zPsbYNIgg1rEKmK45VSLvU4v4JvGWiH3CXxGZoJu2UFXFK8gG+J2iabrrbRxbK
	COE6WZSfuU8TXR2ehLt3JuJd1X6Qh7U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-a5ypMq5XPwGDHfnDpTHIow-1; Wed, 09 Apr 2025 06:56:23 -0400
X-MC-Unique: a5ypMq5XPwGDHfnDpTHIow-1
X-Mimecast-MFC-AGG-ID: a5ypMq5XPwGDHfnDpTHIow_1744196182
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43d51bd9b45so44682125e9.1
        for <kvm@vger.kernel.org>; Wed, 09 Apr 2025 03:56:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744196182; x=1744800982;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Giukvq1XMekOaAYyLauP2qjMQgVPWM9Bad3lqnf3cCw=;
        b=CjL8MLVQxudsD2Q3nmJ5dPN6CJvyuHSuJ2XY5dSXimoH8imDfSQmTg/dly3a3LsQBS
         6boko0y8df7S2mfwQPV7wgIWFAnlIgef8HNOOW1olH+JZkV4tYZgbjfftwnJljGVvXwD
         Sglpx7o8Gzu1wjzhgQJZatwsOplHgYtViTTSht+0G/OPaZSXVJAM09SnRU9oIRYcYPei
         VJZDg7Z79N+dHg2JioyOFVSH6FQ7c1ws2AkR7xhcISFZMcsqdTC8SvuYeXA2F6N3tpfg
         WsjDuyR8VGeYIcVHddynPEK4Ap6HeyMUMS/np1hRE6G+rxQWd4ydTpC+eGovTJMO3Vkx
         o2Iw==
X-Forwarded-Encrypted: i=1; AJvYcCVOTp3naiAtdlKo1g/Rfe/QdrKyU1N7OFL6DTcFxwSp9O6ida+n780YrGsXinxJx1yvao0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzzt8AAQtYvWKTPB/TsxgJBEm8uG1iOxD/FuzG90t58EsC5lPTq
	QBqJFHHCoNxwp0Jr/FKT2FLQVMK7uZRNqZuArm9Ve/y81VcduJTl5KTlFAUR/5oHAkf4T0h8TXP
	X+ueJV5ZFySjJZSIdTA6eAY9bWOrvyJP+BOHorMsOLoebFNVX4w==
X-Gm-Gg: ASbGnctI7snPsU2p4ryob3VfoLTBowhPd7daTN8HX4+MAnWWetGtTvXDomrByb+JcQE
	Oe3PQfPYubPLym66AlIw46muk0R72A2xSlJV78PlWyXktiH57xJE2bHtK5NmD+b0kuoKEW51Aa5
	hDFMnEpKPUapXyorUS1BEpXduV6jBoXhDo6W9YqbCJt4xyGfDEIBNPvUmc3Asl4PW2nRYLn5ZVo
	wZoUkO/TueBqiflv/2KApzADZcLLT2qSEyzwniI/8qXcadrJrUbmRpKJW2D67ht55/EfMpUrWUq
	GyU+UA==
X-Received: by 2002:a05:600c:3b0d:b0:43b:b756:f0a9 with SMTP id 5b1f17b1804b1-43f1eca7da6mr24601235e9.11.1744196182107;
        Wed, 09 Apr 2025 03:56:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGNLH4SJp0xl9ym+oA6t+X06BpgXTrGstDaDUYdeGqpHCubYFfAQEql88GLYD8pGId9XSYpMw==
X-Received: by 2002:a05:600c:3b0d:b0:43b:b756:f0a9 with SMTP id 5b1f17b1804b1-43f1eca7da6mr24600885e9.11.1744196181679;
        Wed, 09 Apr 2025 03:56:21 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f20625eeesm16142845e9.11.2025.04.09.03.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Apr 2025 03:56:20 -0700 (PDT)
Date: Wed, 9 Apr 2025 06:56:17 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Daniel Verkamp <dverkamp@chromium.org>,
	Halil Pasic <pasic@linux.ibm.com>, linux-kernel@vger.kernel.org,
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
Message-ID: <20250409065216-mutt-send-email-mst@kernel.org>
References: <20250407044743-mutt-send-email-mst@kernel.org>
 <b331a780-a9db-4d76-af7c-e9e8e7d1cc10@redhat.com>
 <20250407045456-mutt-send-email-mst@kernel.org>
 <a86240bc-8417-48a6-bf13-01dd7ace5ae9@redhat.com>
 <33def1b0-d9d5-46f1-9b61-b0269753ecce@redhat.com>
 <88d8f2d2-7b8a-458f-8fc4-c31964996817@redhat.com>
 <CABVzXAmMEsw70Tftg4ZNi0G4d8j9pGTyrNqOFMjzHwEpy0JqyA@mail.gmail.com>
 <3bbad51d-d7d8-46f7-a28c-11cc3af6ef76@redhat.com>
 <20250407170239-mutt-send-email-mst@kernel.org>
 <440de313-e470-4afa-9f8a-59598fe8dc21@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <440de313-e470-4afa-9f8a-59598fe8dc21@redhat.com>

On Wed, Apr 09, 2025 at 12:46:41PM +0200, David Hildenbrand wrote:
> On 07.04.25 23:20, Michael S. Tsirkin wrote:
> > On Mon, Apr 07, 2025 at 08:47:05PM +0200, David Hildenbrand wrote:
> > > > In my opinion, it makes the most sense to keep the spec as it is and
> > > > change QEMU and the kernel to match, but obviously that's not trivial
> > > > to do in a way that doesn't break existing devices and drivers.
> > > 
> > > If only it would be limited to QEMU and Linux ... :)
> > > 
> > > Out of curiosity, assuming we'd make the spec match the current QEMU/Linux
> > > implementation at least for the 3 involved features only, would there be a
> > > way to adjust crossvm without any disruption?
> > > 
> > > I still have the feeling that it will be rather hard to get that all
> > > implementations match the spec ... For new features+queues it will be easy
> > > to force the usage of fixed virtqueue numbers, but for free-page-hinting and
> > > reporting, it's a mess :(
> > 
> > 
> > Still thinking about a way to fix drivers... We can discuss this
> > theoretically, maybe?
> 
> Yes, absolutely. I took the time to do some more digging; regarding drivers
> only Linux seems to be problematic.
> 
> virtio-win, FreeBSD, NetBSD and OpenBSD and don't seem to support
> problematic features (free page hinting, free page reporting) in their
> virtio-balloon implementations.
> 
> So from the known drivers, only Linux is applicable.
> 
> reporting_vq is either at idx 4/3/2
> free_page_vq is either at idx 3/2
> statsq is at idx2 (only relevant if the feature is offered)
> 
> So if we could test for the existence of a virtqueue at an idx easily, we
> could test from highest-to-smallest idx.
> 
> But I recall that testing for the existance of a virtqueue on s390x resulted
> in the problem/deadlock in the first place ...
> 
> -- 
> Cheers,
> 
> David / dhildenb

So let's talk about a new feature bit?

Since vqs are probed after feature negotiation, it looks like
we could have a feature bit trigger sane behaviour, right?

I kind of dislike it that we have a feature bit for bugs though.
What would be a minimal new feature to add so it does not
feel wrong?

Maybe it's in the field of psychology though ...


-- 
MST


