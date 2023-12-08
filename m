Return-Path: <kvm+bounces-3908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B11BE80A10A
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 11:32:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69BF42815BD
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 10:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74BCC1A27E;
	Fri,  8 Dec 2023 10:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HdIaCoB0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8731FEE
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 02:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702031487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tcu3WmbH0rDpAmwPqLlBrIXFmcIviRa8i1AFTtWd1Zs=;
	b=HdIaCoB0A+Nbv3Vb+O+09Ua7kVADsbLtma6Wtzp3HejOryUJAdvzVwIIEh2bYf1L/HhJBo
	f2ErbHDGfHNJIPfRD81Y5xGRWnjwFpH8ZkHhJep605alkEMIoEDQb6SrbV8MGhXL6HtmY7
	U4DWxOCWPVUpHkjdzfMYiDkxryE1BWM=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-385-aNFQJjx3NoOA5eXzOcM8pw-1; Fri, 08 Dec 2023 05:31:25 -0500
X-MC-Unique: aNFQJjx3NoOA5eXzOcM8pw-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2ca35adeb10so9451751fa.1
        for <kvm@vger.kernel.org>; Fri, 08 Dec 2023 02:31:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702031483; x=1702636283;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tcu3WmbH0rDpAmwPqLlBrIXFmcIviRa8i1AFTtWd1Zs=;
        b=TDPDYHJC+wRi5U69l/GiljVyMmTE0GURkfeP/A0nizFCTv0FGdM0dNdVkB999IPjui
         oNfly5SW5hsvuAWqf/Ek3D1+n07Jjr+A2VIrp4zxX/ZLMXJ5jL3AGoGrhWlTxYaG8x0Q
         Z490UtzowvKayz5fY83WQjWezuwWhRYwierCm8d/d42FAnliJzRZ2DuXFxxflKFDO6+a
         D6d1Y9yQdQm7wd5sA7nz5IBpF7np0Riik9r4BDOvre6Ob3q+JyHD9/27WwhQKAj9yniG
         nQkFv4ieXv2CYG4QAJ8hwu/Xthxy+5WRy8eDD7fPVICaxz5/WxYgbg7G4iPtXry0goOy
         gs8w==
X-Gm-Message-State: AOJu0YyYxlFtZly+AoUKmRjaxgKwNRT+r51Mm2Gv8Z2WDBQ60nqEcLM+
	PgD7ONYILibwgRTbaE41ECc4E6t0nVfuqDtpPEdnV0Gyabf96HAL+HL1XAqIgc5VcYJpUCdszYK
	cqLXcU9BU/uXGwrVFMZ22
X-Received: by 2002:a2e:8884:0:b0:2ca:56:778f with SMTP id k4-20020a2e8884000000b002ca0056778fmr1257125lji.48.1702031483559;
        Fri, 08 Dec 2023 02:31:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHKcY1LCS/VjPyEMeTLMNoGPvmPdJg2dsZtFpUis0zp6RJwZ5WMd0CWqzm2EoCROz7SrjQSKA==
X-Received: by 2002:a2e:8884:0:b0:2ca:56:778f with SMTP id k4-20020a2e8884000000b002ca0056778fmr1257123lji.48.1702031483207;
        Fri, 08 Dec 2023 02:31:23 -0800 (PST)
Received: from redhat.com ([2a02:14f:1f0:7466:b10d:58c8:869f:7e91])
        by smtp.gmail.com with ESMTPSA id cu12-20020a170906ba8c00b00a10f3030e11sm829135ejd.1.2023.12.08.02.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Dec 2023 02:31:22 -0800 (PST)
Date: Fri, 8 Dec 2023 05:31:18 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tobias Huschle <huschle@linux.ibm.com>
Cc: Abel Wu <wuyun.abel@bytedance.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	jasowang@redhat.com
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
Message-ID: <20231208052150-mutt-send-email-mst@kernel.org>
References: <ZVdbdSXg4qefTNtg@DESKTOP-2CCOB1S.>
 <20231117123759.GP8262@noisy.programming.kicks-ass.net>
 <46a997c2-5a38-4b60-b589-6073b1fac677@bytedance.com>
 <ZVyt4UU9+XxunIP7@DESKTOP-2CCOB1S.>
 <20231122100016.GO8262@noisy.programming.kicks-ass.net>
 <6564a012.c80a0220.adb78.f0e4SMTPIN_ADDED_BROKEN@mx.google.com>
 <d4110c79-d64f-49bd-9f69-0a94369b5e86@bytedance.com>
 <07513.123120701265800278@us-mta-474.us.mimecast.lan>
 <20231207014626-mutt-send-email-mst@kernel.org>
 <56082.123120804242300177@us-mta-137.us.mimecast.lan>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56082.123120804242300177@us-mta-137.us.mimecast.lan>

On Fri, Dec 08, 2023 at 10:24:16AM +0100, Tobias Huschle wrote:
> On Thu, Dec 07, 2023 at 01:48:40AM -0500, Michael S. Tsirkin wrote:
> > On Thu, Dec 07, 2023 at 07:22:12AM +0100, Tobias Huschle wrote:
> > > 3. vhost looping endlessly, waiting for kworker to be scheduled
> > > 
> > > I dug a little deeper on what the vhost is doing. I'm not an expert on
> > > virtio whatsoever, so these are just educated guesses that maybe
> > > someone can verify/correct. Please bear with me probably messing up 
> > > the terminology.
> > > 
> > > - vhost is looping through available queues.
> > > - vhost wants to wake up a kworker to process a found queue.
> > > - kworker does something with that queue and terminates quickly.
> > > 
> > > What I found by throwing in some very noisy trace statements was that,
> > > if the kworker is not woken up, the vhost just keeps looping accross
> > > all available queues (and seems to repeat itself). So it essentially
> > > relies on the scheduler to schedule the kworker fast enough. Otherwise
> > > it will just keep on looping until it is migrated off the CPU.
> > 
> > 
> > Normally it takes the buffers off the queue and is done with it.
> > I am guessing that at the same time guest is running on some other
> > CPU and keeps adding available buffers?
> > 
> 
> It seems to do just that, there are multiple other vhost instances
> involved which might keep filling up thoses queues. 
> 

No vhost is ever only draining queues. Guest is filling them.

> Unfortunately, this makes the problematic vhost instance to stay on
> the CPU and prevents said kworker to get scheduled. The kworker is
> explicitly woken up by vhost, so it wants it to do something.
> 
> At this point it seems that there is an assumption about the scheduler
> in place which is no longer fulfilled by EEVDF. From the discussion so
> far, it seems like EEVDF does what is intended to do.
> 
> Shouldn't there be a more explicit mechanism in use that allows the
> kworker to be scheduled in favor of the vhost?
> 
> It is also concerning that the vhost seems cannot be preempted by the
> scheduler while executing that loop.


Which loop is that, exactly?

-- 
MST


