Return-Path: <kvm+bounces-6494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 50883835746
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 19:45:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFDFE1F210C7
	for <lists+kvm@lfdr.de>; Sun, 21 Jan 2024 18:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 466FA383A0;
	Sun, 21 Jan 2024 18:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fkwIE3fs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E498F381D3
	for <kvm@vger.kernel.org>; Sun, 21 Jan 2024 18:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705862684; cv=none; b=pCRt2tvrDnNo+xcYO668mneIWEqPjCn6SQ4Gj0QJjY9td9QZy5MUyFLFLkUGJ79tDltIJRMAECViltPAwoW0jif0yBcxrEpROrfeEUjA0RDswHIdbJAdP+52JzY8bLR6Z9kcPdsSzqLCyIlfpmgj6vFtczVrxc+uv+jiRP0Lfhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705862684; c=relaxed/simple;
	bh=pAwTTU33ri9CTWjjk66csXD8pbCteqoL4Oh7bntQT0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LuzD52A4/J4N7MUVPofjgioyOvcJwOd6CXL3osGOL6mLTJ6pT7AKRdzcilOjPhNLext5McEgiumwksV8lw+2V51ZJ0aE922ImhL3lS/aqcos2I/4wuuBY7J1n6Q8sBDavGYxblO2x8IZ1zfD4rMdyx0OsDljKHXrte7MjFu1FTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fkwIE3fs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705862681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=guMoP2TLsfEqj1Hggx/w0+mwdRN+95oChUYRB7tzFcY=;
	b=fkwIE3fsYqPUJrAUjl/tXGq68rAl7Is2LgnmQT94mPow7aPsiz9QIDCKW08gu7AoDjNiO5
	WDA+4mrh+nEVrDj0eBzAd8z9x1WqOCXd630FHrNQdBWMb+9fLltDtoNcz5Qzw7OEeMHF1k
	/hHWlipsDOq8Qq4rAFJ47NcjdfJAqc0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-2-aI-wvekSOlKmHXvbT2SBfQ-1; Sun, 21 Jan 2024 13:44:39 -0500
X-MC-Unique: aI-wvekSOlKmHXvbT2SBfQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40e8d72e1b3so25999765e9.2
        for <kvm@vger.kernel.org>; Sun, 21 Jan 2024 10:44:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705862678; x=1706467478;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=guMoP2TLsfEqj1Hggx/w0+mwdRN+95oChUYRB7tzFcY=;
        b=CQIU8pCYpuE/6GpmrS1xViV087MqkEVcWk9p/CkeuEdQDJ6WN5UNMrDlBCmnzQrkdE
         jeLdPsDjI5yU+JQPudWEcnDwD8jHJ8sKVJFR3HloF9Uu/NY/6ObC/K8wCcoprZNoI1WK
         d81EJsjHZqbXTT6IJdtxkT5l/i34VYX5Vq/JlLQX77kkTNQ5GH1onkMUduACiYKwps+y
         6PAL35yibC2Z9UrNSKykoYwPdpL5b8GjVXrnG7bWlZRUzU9yQTxyYR6GN78j4mgRco+q
         Bmh32xm7mMnYxZhud+ygc2DMHbTEcPpiUoLILY0ixVVdDzO7hRgPK4modF6skzcCd9I5
         GpIw==
X-Gm-Message-State: AOJu0YyrqqexicHYuBlx3TM/bopWMRH1O3dtmv99hhMXP+2skFKt5T64
	KAVrx3nFXXGMNWTW6+GvqtiTD+JNIK56lEkLhiR7kbqMe+m0FYVRbHza5ZyrXUPeYUV/WKDpoBU
	1poQqkXQXrdS+CPQ53wUbqoVi53qQ3zp7JeV3xqMYslC4S8SO2w==
X-Received: by 2002:a05:600c:1c85:b0:40e:4789:7842 with SMTP id k5-20020a05600c1c8500b0040e47897842mr1857738wms.236.1705862678258;
        Sun, 21 Jan 2024 10:44:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE1bzkFTUa/tUGQacRJtg45xo0chZy5yADvcP07PoL9frmkMFBtGIdedbJbDN6aNNam0c94GQ==
X-Received: by 2002:a05:600c:1c85:b0:40e:4789:7842 with SMTP id k5-20020a05600c1c8500b0040e47897842mr1857731wms.236.1705862677920;
        Sun, 21 Jan 2024 10:44:37 -0800 (PST)
Received: from redhat.com ([2.52.14.57])
        by smtp.gmail.com with ESMTPSA id t18-20020a05600c199200b0040e5951f199sm36202366wmq.34.2024.01.21.10.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jan 2024 10:44:36 -0800 (PST)
Date: Sun, 21 Jan 2024 13:44:32 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tobias Huschle <huschle@linux.ibm.com>
Cc: Jason Wang <jasowang@redhat.com>, Abel Wu <wuyun.abel@bytedance.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6
 sched/fair: Add lag based placement)
Message-ID: <20240121134311-mutt-send-email-mst@kernel.org>
References: <CACGkMEuSGT-e-i-8U7hum-N_xEnsEKL+_07Mipf6gMLFFhj2Aw@mail.gmail.com>
 <20231211115329-mutt-send-email-mst@kernel.org>
 <CACGkMEudZnF7hUajgt0wtNPCxH8j6A3L1DgJj2ayJWhv9Bh1WA@mail.gmail.com>
 <20231212111433-mutt-send-email-mst@kernel.org>
 <42870.123121305373200110@us-mta-641.us.mimecast.lan>
 <20231213061719-mutt-send-email-mst@kernel.org>
 <25485.123121307454100283@us-mta-18.us.mimecast.lan>
 <20231213094854-mutt-send-email-mst@kernel.org>
 <20231214021328-mutt-send-email-mst@kernel.org>
 <92916.124010808133201076@us-mta-622.us.mimecast.lan>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92916.124010808133201076@us-mta-622.us.mimecast.lan>

On Mon, Jan 08, 2024 at 02:13:25PM +0100, Tobias Huschle wrote:
> On Thu, Dec 14, 2023 at 02:14:59AM -0500, Michael S. Tsirkin wrote:
> > 
> > Peter, would appreciate feedback on this. When is cond_resched()
> > insufficient to give up the CPU? Should Documentation/kernel-hacking/hacking.rst
> > be updated to require schedule() instead?
> > 
> 
> Happy new year everybody!
> 
> I'd like to bring this thread back to life. To reiterate:
> 
> - The introduction of the EEVDF scheduler revealed a performance
>   regression in a uperf testcase of ~50%.
> - Tracing the scheduler showed that it takes decisions which are
>   in line with its design.
> - The traces showed as well, that a vhost instance might run
>   excessively long on its CPU in some circumstance. Those cause
>   the performance regression as they cause delay times of 100+ms
>   for a kworker which drives the actual network processing.
> - Before EEVDF, the vhost would always be scheduled off its CPU
>   in favor of the kworker, as the kworker was being woken up and
>   the former scheduler was giving more priority to the woken up
>   task. With EEVDF, the kworker, as a long running process, is
>   able to accumulate negative lag, which causes EEVDF to not
>   prefer it on its wake up, leaving the vhost running.
> - If the kworker is not scheduled when being woken up, the vhost
>   continues looping until it is migrated off the CPU.
> - The vhost offers to be scheduled off the CPU by calling 
>   cond_resched(), but, the the need_resched flag is not set,
>   therefore cond_resched() does nothing.
> 
> To solve this, I see the following options 
>   (might not be a complete nor a correct list)
> - Along with the wakeup of the kworker, need_resched needs to
>   be set, such that cond_resched() triggers a reschedule.

Let's try this? Does not look like discussing vhost itself will
draw attention from scheduler guys but posting a scheduling
patch probably will? Can you post a patch?

> - The vhost calls schedule() instead of cond_resched() to give up
>   the CPU. This would of course be a significantly stricter
>   approach and might limit the performance of vhost in other cases.
> - Preventing the kworker from accumulating negative lag as it is
>   mostly not runnable and if it runs, it only runs for a very short
>   time frame. This might clash with the overall concept of EEVDF.
> - On cond_resched(), verify if the consumed runtime of the caller
>   is outweighing the negative lag of another process (e.g. the 
>   kworker) and schedule the other process. Introduces overhead
>   to cond_resched.

Or this last one.


> 
> I would be curious on feedback on those ideas and interested in
> alternative approaches.


