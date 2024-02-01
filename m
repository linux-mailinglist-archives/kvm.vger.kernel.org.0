Return-Path: <kvm+bounces-7699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CECE8456F8
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 13:08:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76F061F2451E
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 12:08:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 833C115DBB0;
	Thu,  1 Feb 2024 12:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PT5iRtAQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72AB15D5D2
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 12:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706789298; cv=none; b=NgQq4FG9J/EvgAbI55hYuSa0lKSzwYavim2HtgBlOs7ofVSiCBf4i19o1v7kKzoTr6dXLrJqXr2C0KCQmfpjLYX73JawVe4c0g6UQymKFLNeyTuzbQQu7N2zMXT14iz8FzvfBwJY7c/Jo97lr+xS0gGS7d0i9sGuYWuUBFl1+/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706789298; c=relaxed/simple;
	bh=u0Vuh6UaWWry58heleOtgI4U8v48NUQVhrdE1NWmmWk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u27Gtgr0N2uheHAX5EOclYILF/MIcX9Zn0y4LtnY3rd5uSt2PpoBDaT5rAH4qW+RTmP+geYDdx3Az6DB/5ztZ0NGhv4pKOXdqKWR8gMmzh1sahUu9HZYHFPsvOJ4MUFSnhuLQxT2z38SBir07oAuhUzuB43bzO2PJmEFUCLHcN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PT5iRtAQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706789296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=67+KP8NuzXrJWY7GCYMlyeCXW3DsHNIXpaSedC8ac8I=;
	b=PT5iRtAQiUyhi031ri04nGyx16CCRE7s+wC8SX3yV/WsVGy/o8yYAk0VXhzqTGKTsVMnm3
	8A9ESjEG7BJGvegZ9AXthulzSqSINqLB43sOgkmE2VosvmByurmcQMw9LhBr6N4WRDWvHG
	+EoVzB28hkNg1OoEDC3+4yKaEOt3XZU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-ftk5a4QnNSGkTOKudP9D4g-1; Thu, 01 Feb 2024 07:08:14 -0500
X-MC-Unique: ftk5a4QnNSGkTOKudP9D4g-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40e4478a3afso3400955e9.1
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 04:08:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706789294; x=1707394094;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=67+KP8NuzXrJWY7GCYMlyeCXW3DsHNIXpaSedC8ac8I=;
        b=u4nltMmtwghq7D0PX07fERMrs75LRGFWWCZXNsd6udNO6ldQ3s5TrbH2R+RjNb8/Ov
         P55MIG3gsP5YAzDbJIwlx8+G5hQfO9/5XXfDCHPAfgiZzxgmjBjWHxZBXk4ZvboqrcQB
         +8uM4Z4QhlVXCnUhaKlkPPP2vH7eLYnHSv5r2ALQHJVMMfQbs1fsMEbWjlpnShyIfRKp
         E0dycBVirlodHULSnIm0UuEwspXEF07CAXA4hLNqlwHesq//O6aKbz/81d8hRxa4n5/s
         TrxvHIwqYNve15SLzbFT6IR1GUE+pSdIZayOADGwWu3TyBgP8EeGzmwuoL0k2by1+GhS
         MdwA==
X-Gm-Message-State: AOJu0YyDzn/M96x53snJ5nkHGpTpQ6lGNjhu5RoHP/Q/fdM/n+vLSyg8
	v8/WRw8Q84xjA1ZZkXMn9L1Ni46NlnLeAyedP5Yaa2cD2J7vSj4P+PNmpoLFjauxre1AWGsXgWO
	e3F40Z5cjGvWTckjOOFO/EeuDYZ3mqiH7sNV8c++umQk3SfmfqA==
X-Received: by 2002:a05:600c:4f47:b0:40f:c234:2006 with SMTP id m7-20020a05600c4f4700b0040fc2342006mr775155wmq.8.1706789293435;
        Thu, 01 Feb 2024 04:08:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGDQw2vkPSv69Fu9yrnLpd0aYqNGmL2n/6eqCbInpygA0Mychbj/OwS+GC0Q9lu787+WoOWcw==
X-Received: by 2002:a05:600c:4f47:b0:40f:c234:2006 with SMTP id m7-20020a05600c4f4700b0040fc2342006mr775140wmq.8.1706789293092;
        Thu, 01 Feb 2024 04:08:13 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVN5PjvZNOJIZX1Hb80R4uibtcQCEcA7mS/7l9bCiZWkcaX3VmzRl+ibyL5qLva0hPJUT7ahMzD7qqmO3xH2iS2QmH3aQIyfzcU0unbJt0E/OBBAPMYA5aabGAzJIQBK39ZIYOob2+eW0pPGDoGCMgQ8i4mJ9kcYOQNGPxrQ4fpVlow0pA4q6BOn+JhoNSG19mZSieXpq4km33M7AXif8ZiTq/9PINTKZD9AiCECumvUyMNNTyhWg8y+a8aZ/JQplaF0tSh/xsfn6k=
Received: from redhat.com ([2.52.129.159])
        by smtp.gmail.com with ESMTPSA id jn22-20020a05600c6b1600b0040ef63a162dsm4241490wmb.26.2024.02.01.04.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 04:08:12 -0800 (PST)
Date: Thu, 1 Feb 2024 07:08:08 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tobias Huschle <huschle@linux.ibm.com>
Cc: Jason Wang <jasowang@redhat.com>, Abel Wu <wuyun.abel@bytedance.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
Message-ID: <20240201070437-mutt-send-email-mst@kernel.org>
References: <42870.123121305373200110@us-mta-641.us.mimecast.lan>
 <20231213061719-mutt-send-email-mst@kernel.org>
 <25485.123121307454100283@us-mta-18.us.mimecast.lan>
 <20231213094854-mutt-send-email-mst@kernel.org>
 <20231214021328-mutt-send-email-mst@kernel.org>
 <92916.124010808133201076@us-mta-622.us.mimecast.lan>
 <20240121134311-mutt-send-email-mst@kernel.org>
 <07974.124020102385100135@us-mta-501.us.mimecast.lan>
 <20240201030341-mutt-send-email-mst@kernel.org>
 <89460.124020106474400877@us-mta-475.us.mimecast.lan>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89460.124020106474400877@us-mta-475.us.mimecast.lan>

On Thu, Feb 01, 2024 at 12:47:39PM +0100, Tobias Huschle wrote:
> On Thu, Feb 01, 2024 at 03:08:07AM -0500, Michael S. Tsirkin wrote:
> > On Thu, Feb 01, 2024 at 08:38:43AM +0100, Tobias Huschle wrote:
> > > On Sun, Jan 21, 2024 at 01:44:32PM -0500, Michael S. Tsirkin wrote:
> > > > On Mon, Jan 08, 2024 at 02:13:25PM +0100, Tobias Huschle wrote:
> > > > > On Thu, Dec 14, 2023 at 02:14:59AM -0500, Michael S. Tsirkin wrote:
> > > 
> > > -------- Summary --------
> > > 
> > > In my (non-vhost experience) opinion the way to go would be either
> > > replacing the cond_resched with a hard schedule or setting the
> > > need_resched flag within vhost if the a data transfer was successfully
> > > initiated. It will be necessary to check if this causes problems with
> > > other workloads/benchmarks.
> > 
> > Yes but conceptually I am still in the dark on whether the fact that
> > periodically invoking cond_resched is no longer sufficient to be nice to
> > others is a bug, or intentional.  So you feel it is intentional?
> 
> I would assume that cond_resched is still a valid concept.
> But, in this particular scenario we have the following problem:
> 
> So far (with CFS) we had:
> 1. vhost initiates data transfer
> 2. kworker is woken up
> 3. CFS gives priority to woken up task and schedules it
> 4. kworker runs
> 
> Now (with EEVDF) we have:
> 0. In some cases, kworker has accumulated negative lag 
> 1. vhost initiates data transfer
> 2. kworker is woken up
> -3a. EEVDF does not schedule kworker if it has negative lag
> -4a. vhost continues running, kworker on same CPU starves
> --
> -3b. EEVDF schedules kworker if it has positive or no lag
> -4b. kworker runs
> 
> In the 3a/4a case, the kworker is given no chance to set the
> necessary flag. The flag can only be set by another CPU now.
> The schedule of the kworker was not caused by cond_resched, but
> rather by the wakeup path of the scheduler.
> 
> cond_resched works successfully once the load balancer (I suppose) 
> decides to migrate the vhost off to another CPU. In that case, the
> load balancer on another CPU sets that flag and we are good.
> That then eventually allows the scheduler to pick kworker, but very
> late.

I don't really understand what is special about vhost though.
Wouldn't it apply to any kernel code?

> > I propose a two patch series then:
> > 
> > patch 1: in this text in Documentation/kernel-hacking/hacking.rst
> > 
> > If you're doing longer computations: first think userspace. If you
> > **really** want to do it in kernel you should regularly check if you need
> > to give up the CPU (remember there is cooperative multitasking per CPU).
> > Idiom::
> > 
> >     cond_resched(); /* Will sleep */
> > 
> > 
> > replace cond_resched -> schedule
> > 
> > 
> > Since apparently cond_resched is no longer sufficient to
> > make the scheduler check whether you need to give up the CPU.
> > 
> > patch 2: make this change for vhost.
> > 
> > WDYT?
> 
> For patch 1, I would like to see some feedback from Peter (or someone else
> from the scheduler maintainers).

I am guessing once you post it you will see feedback.

> For patch 2, I would prefer to do some more testing first if this might have
> an negative effect on other benchmarks.
> 
> I also stumbled upon something in the scheduler code that I want to verify.
> Maybe a cgroup thing, will check that out again.
> 
> I'll do some more testing with the cond_resched->schedule fix, check the
> cgroup thing and wait for Peter then.
> Will get back if any of the above yields some results.
> 
> > 
> > -- 
> > MST
> > 
> > 


