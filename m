Return-Path: <kvm+bounces-11573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FAD48785FA
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 18:05:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 16377B21852
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 17:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF8444B5CD;
	Mon, 11 Mar 2024 17:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UltoYNgI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1063C46B
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 17:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710176733; cv=none; b=mBdqDzZRsvL2bd+d2R+o1vYWECEYLByykFwv3dAGYxjg6lC964n3ZfW8g2GqfZS33ovplPtZZUst2lAjJyQR6WYahSNvj5v0J7r8kznZ1xvHyEVrNH+ZIx3sBd8PHBntRWV+BhMeHp+6Lkgmvmdg0VJuixtM2kj2gC2g2MEs5nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710176733; c=relaxed/simple;
	bh=XNwbXKaCLGvCbpxIvSjj9i4O3/8QvDmG0N51zcg49XU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sD4+Z9VocZAvvZmqsj2NZmb2EBWi8a9QBB3/wnjCj5ZW0z92k7NxbTopZBIqj0Tp4W7uObMEgatMkKFyqdVouOwTqaOeTWIg4eZgYSZi27sZg0DmAUouVUoyQihlVuAjBtCljjYK8QfNTkb4Wp5RhVLqy3WS2Y1a3bCEK9Pvm/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UltoYNgI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710176730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ofx1nXrTDjwWTrrBkspXHarb2XIic0gZXzZbExCDCt4=;
	b=UltoYNgIrkqupEomPKTgHkXVcatmK86S40SZZMdQu3TsLXwxDJ9BLKQWljOS6CGGwegBn0
	Qnw2ZjqpxBzDutQZXXlA8jTNndR0GGGTT5ldbgJxZbJJpTeH70PHXchCLBBXXqmEhS0nAE
	UsCXxSP+32F4WnepNmzbpIuUH0duZnk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-j01EvM3iOFmFzKnhXKC5bw-1; Mon, 11 Mar 2024 13:05:29 -0400
X-MC-Unique: j01EvM3iOFmFzKnhXKC5bw-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33e8b93b4efso1013935f8f.0
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 10:05:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710176727; x=1710781527;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ofx1nXrTDjwWTrrBkspXHarb2XIic0gZXzZbExCDCt4=;
        b=bQrfkqclFtWhZXgdSZM/j/hQSL5gvR2bcLZHv0Uxju5gGTpKUgwcJbbGtmPhSR3Xj6
         Zv8Xn3kMl0gajlI+EA3mnaaIlJJLW2keaEVJkTHxQyqHZrK45+UPtByasETO6lIrZ6L+
         hT41AhNTEBa1SWgQdZ1LefMeH68OQ2BUQ9Y8tFFyf8s95+Q82r67tl4X2I1UZrYHJbn0
         ahRfDBvlFU/mRZ5dWhSrsdme7K1HbGT6S9tEfq8MpJibMEkEP+ywQ/o5BfhGOkjzn9kK
         dJwUvSlIZDDa3dsH/lNSX3goukdTO1274oobEzaZMFVgR3zNOFKMl4LnWoCsBJo4Paew
         mX3g==
X-Forwarded-Encrypted: i=1; AJvYcCXN92FMu2ei/arntKmZKIi3/mgIArWx1zBoaJvUCNPkjZzBy8yMFS0JRU0RGHOjPBmgX+H7HkyWjNoWoZLhzb4QLcdp
X-Gm-Message-State: AOJu0YwFU62BDO+sLFy7ILXgtgGrHH+1flDSU7/8DxfAyArThiqXiiBr
	HcEa6d6I4rQxnRIFIu4+62l35UYyiG+BU2Zc40/EyBX0/H96GPCeO1LqlT/uQh9gQYWiN/CxI46
	x5EzKfypweFxPjdDYLnY9sDPUK3GpVHprx/Ly8im84iyQAsTIBA==
X-Received: by 2002:a05:6000:230:b0:33e:96b7:af6d with SMTP id l16-20020a056000023000b0033e96b7af6dmr1971472wrz.6.1710176727049;
        Mon, 11 Mar 2024 10:05:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHkykAXhh3ZDBHaIBqo4LqQhaHhS1QTgvnZKN/euSPkgltlwWOCucmDgB5XoQsM841Kz8WUQQ==
X-Received: by 2002:a05:6000:230:b0:33e:96b7:af6d with SMTP id l16-20020a056000023000b0033e96b7af6dmr1971451wrz.6.1710176726496;
        Mon, 11 Mar 2024 10:05:26 -0700 (PDT)
Received: from redhat.com ([2.52.134.16])
        by smtp.gmail.com with ESMTPSA id b3-20020a05600003c300b0033e239040d8sm7123545wrg.84.2024.03.11.10.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 10:05:25 -0700 (PDT)
Date: Mon, 11 Mar 2024 13:05:21 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tobias Huschle <huschle@linux.ibm.com>
Cc: Jason Wang <jasowang@redhat.com>, Abel Wu <wuyun.abel@bytedance.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
Message-ID: <20240311130446-mutt-send-email-mst@kernel.org>
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

Are we going anywhere with this btw?


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


