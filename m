Return-Path: <kvm+bounces-7673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40F8184526B
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 09:09:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 734281C26024
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 08:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AFEE15A499;
	Thu,  1 Feb 2024 08:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KUf9fVqL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405C715B109
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 08:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706774907; cv=none; b=d+Y0OPFDnXdYtD6NM4/6tN/2rWXpBbgPOzqWH1NVWtrD8ZM34LPITrYJT11LnVSxI9UQY6mTm1W0V0kYmgxteabyl3W6B7gBmvj+HL8gb7s+N41lXIQCFL2xuOHkALrGiDyYob2Rj/1kw6IGxu7L6ksDI8PXwg9hDpbnLtxTD6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706774907; c=relaxed/simple;
	bh=yRW+zk6ipQx+/UeKBycRl86N7OpB8VApca3JZVyt31I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=phR+6fmlyjKOjSQ6u3eGLznEpmaY6nZSNh78hNUCFAiKUug94AwFztkCfKVVCUytmmUFA79qsoL8d2EgSZ4cJvX8Bl9Bia1IPK3Q4UC6WvtIUw0a4++KWIlqHLUJQd0+PohD6GoF03FcrUdBX6ka10p+LXgwZb1Go5EyS7OEduc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KUf9fVqL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706774896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iy0to9gJNsnChVp/GnNaL86E7YakxrA6m3SgledDRmM=;
	b=KUf9fVqL2VNKyOK/W4u2vJjGcoR0ZzK0JfOARQOruN+EmAIoApqVfkDNm5N83wlLezXF8z
	hgy9yuQeD7uiATwZR6OojRBpzEExLxt2NxnP/Hjq5LVtdSxNveoDBgC4d7FB3DdrFTiUB9
	v5cQ0Y3GDeZx20dShwcSQBJ6rjWjrcY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-DlyIt0NBOg6P3Iyl7CjwOQ-1; Thu, 01 Feb 2024 03:08:14 -0500
X-MC-Unique: DlyIt0NBOg6P3Iyl7CjwOQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a2fba67ec20so38712266b.3
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 00:08:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706774894; x=1707379694;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iy0to9gJNsnChVp/GnNaL86E7YakxrA6m3SgledDRmM=;
        b=DJUkPKmhRYXyjOQ9rgMIVJ1J7MrKOvd0wWnj154+WhHq24o6GGxvu7zdOMeaw/yleH
         xBskIPUTXm+VLRW/Mv9JXx8SNciI7PzmgxfHgDNweYsHrDk9qANDVM2j5MxG/9Gp8Rbd
         GP8ftcHBOtk+bCkFa1fr/PGQ30qmDeVC40C6e22yLmVvNUcrdk0mOBB1E++m8xB6nlFI
         rzycOdbc0wimgnusvBKrvWAKpJQaWGOU8k3y+ccQhHS8NWJiWoOdWLL2yNhwequ8hzDv
         6WH3Krk5QB0c2NZO1J20Zj1YdaWNlzZFqRFYh+hk1cCkf0qVEljsPvId+YSz/EP4G4bb
         2Q0A==
X-Gm-Message-State: AOJu0YxceHvkxAntudGEoPCEzlbm51ni6X/QEGeFbgfyXg6GafHdmBN8
	2xc5adc1Msrw7z9yW9PnvjAvbAGH+7IpgsCpyR+B8FxHw0uDiQ9zDYHrgmRFRserE8ounV6Y13n
	xRvRYAuu9rLsvovqcSHG72Ce0gAmA5LvuwVjjBXTz4v0ZLhzxkw==
X-Received: by 2002:a17:907:994a:b0:a36:6198:3505 with SMTP id kl10-20020a170907994a00b00a3661983505mr2891736ejc.25.1706774893763;
        Thu, 01 Feb 2024 00:08:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGR6sQz2gxBGtwqzlmOhuYoQMalz//Dwvh7p+uyOALTuWEkXwrce4iZxrh7C6Z3DpndGvJclg==
X-Received: by 2002:a17:907:994a:b0:a36:6198:3505 with SMTP id kl10-20020a170907994a00b00a3661983505mr2891712ejc.25.1706774893374;
        Thu, 01 Feb 2024 00:08:13 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUPikGwlmK61HBD824LPki9FCPfzBqA8DOG1qFKTu86qM6TT3O5V9/CvItrJ98+QzfcVoEyp+96Zr1Nn2L+BvS4DqHAaoL3vKwZ6lp6Isco+Twi35RKwnoZUuMkraXf3k7IhNqwNPtWxXU0q5hpZ3dtYMws/l0G/WLT2JxU+Az61Ph3wfFwo0rWQrE9KpQ7vopZeP4GRY7hV6XC5TPZ8jR/tHxE8mlGsfTD2vqlwVDFVHk3t88eeqmNpQtAeXcq4Z1TDE9naso78eI=
Received: from redhat.com ([2a02:14f:179:3a6d:f252:c632:3893:a2ef])
        by smtp.gmail.com with ESMTPSA id m1-20020a1709062b8100b00a363e8be473sm2143643ejg.143.2024.02.01.00.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Feb 2024 00:08:12 -0800 (PST)
Date: Thu, 1 Feb 2024 03:08:07 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tobias Huschle <huschle@linux.ibm.com>
Cc: Jason Wang <jasowang@redhat.com>, Abel Wu <wuyun.abel@bytedance.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
Message-ID: <20240201030341-mutt-send-email-mst@kernel.org>
References: <CACGkMEudZnF7hUajgt0wtNPCxH8j6A3L1DgJj2ayJWhv9Bh1WA@mail.gmail.com>
 <20231212111433-mutt-send-email-mst@kernel.org>
 <42870.123121305373200110@us-mta-641.us.mimecast.lan>
 <20231213061719-mutt-send-email-mst@kernel.org>
 <25485.123121307454100283@us-mta-18.us.mimecast.lan>
 <20231213094854-mutt-send-email-mst@kernel.org>
 <20231214021328-mutt-send-email-mst@kernel.org>
 <92916.124010808133201076@us-mta-622.us.mimecast.lan>
 <20240121134311-mutt-send-email-mst@kernel.org>
 <07974.124020102385100135@us-mta-501.us.mimecast.lan>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07974.124020102385100135@us-mta-501.us.mimecast.lan>

On Thu, Feb 01, 2024 at 08:38:43AM +0100, Tobias Huschle wrote:
> On Sun, Jan 21, 2024 at 01:44:32PM -0500, Michael S. Tsirkin wrote:
> > On Mon, Jan 08, 2024 at 02:13:25PM +0100, Tobias Huschle wrote:
> > > On Thu, Dec 14, 2023 at 02:14:59AM -0500, Michael S. Tsirkin wrote:
> > > - Along with the wakeup of the kworker, need_resched needs to
> > >   be set, such that cond_resched() triggers a reschedule.
> > 
> > Let's try this? Does not look like discussing vhost itself will
> > draw attention from scheduler guys but posting a scheduling
> > patch probably will? Can you post a patch?
> 
> As a baseline, I verified that the following two options fix
> the regression:
> 
> - replacing the cond_resched in the vhost_worker function with a hard
>   schedule 
> - setting the need_resched flag using set_tsk_need_resched(current)
>   right before calling cond_resched
> 
> I then tried to find a better spot to put the set_tsk_need_resched
> call. 
> 
> One approach I found to be working is setting the need_resched flag 
> at the end of handle_tx and hande_rx.
> This would be after data has been actually passed to the socket, so 
> the originally blocked kworker has something to do and will profit
> from the reschedule. 
> It might be possible to go deeper and place the set_tsk_need_resched
> call to the location right after actually passing the data, but this
> might leave us with sprinkling that call in multiple places and
> might be too intrusive.
> Furthermore, it might be possible to check if an error occured when
> preparing the transmission and then skip the setting of the flag.
> 
> This would require a conceptual decision on the vhost side.
> This solution would not touch the scheduler, only incentivise it to
> do the right thing for this particular regression.
> 
> Another idea could be to find the counterpart that initiates the
> actual data transfer, which I assume wakes up the kworker. From
> what I gather it seems to be an eventfd notification that ends up
> somewhere in the qemu code. Not sure if that context would allow
> to set the need_resched flag, nor whether this would be a good idea.
> 
> > 
> > > - On cond_resched(), verify if the consumed runtime of the caller
> > >   is outweighing the negative lag of another process (e.g. the 
> > >   kworker) and schedule the other process. Introduces overhead
> > >   to cond_resched.
> > 
> > Or this last one.
> 
> On cond_resched itself, this will probably only be possible in a very 
> very hacky way. That is because currently, there is no immidiate access
> to the necessary data available, which would make it necessary to 
> bloat up the cond_resched function quite a bit, with a probably 
> non-negligible amount of overhead.
> 
> Changing other aspects in the scheduler might get us in trouble as
> they all would probably resolve back to the question "What is the magic
> value that determines whether a small task not being scheduled justifies
> setting the need_resched flag for a currently running task or adjusting 
> its lag?". As this would then also have to work for all non-vhost related
> cases, this looks like a dangerous path to me on second thought.
> 
> 
> -------- Summary --------
> 
> In my (non-vhost experience) opinion the way to go would be either
> replacing the cond_resched with a hard schedule or setting the
> need_resched flag within vhost if the a data transfer was successfully
> initiated. It will be necessary to check if this causes problems with
> other workloads/benchmarks.

Yes but conceptually I am still in the dark on whether the fact that
periodically invoking cond_resched is no longer sufficient to be nice to
others is a bug, or intentional.  So you feel it is intentional?
I propose a two patch series then:

patch 1: in this text in Documentation/kernel-hacking/hacking.rst

If you're doing longer computations: first think userspace. If you
**really** want to do it in kernel you should regularly check if you need
to give up the CPU (remember there is cooperative multitasking per CPU).
Idiom::

    cond_resched(); /* Will sleep */


replace cond_resched -> schedule


Since apparently cond_resched is no longer sufficient to
make the scheduler check whether you need to give up the CPU.

patch 2: make this change for vhost.

WDYT?

-- 
MST


