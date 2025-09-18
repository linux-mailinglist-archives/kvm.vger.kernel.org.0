Return-Path: <kvm+bounces-58036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6FF1B864B5
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 19:42:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 335523AE669
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 17:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FCC331DD85;
	Thu, 18 Sep 2025 17:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RUGZ0eI/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A2231A811
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 17:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758217234; cv=none; b=QQVvuLjuaHvBZU6W/yOQHqEUmrcME+YqDHnZuTJX1KfCWOU+Ms6lRdEcNUnGiV40pVP+0z9h8Tz7SPSS7EXslH9SEvnN8HtPNMYPZyzK4Kknpn9d4d8Drc5pUN25NJqBamGYBHSV4EJdsgolcd1Ooss+6mwrO6K006TPe5AWsN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758217234; c=relaxed/simple;
	bh=PAJGdxzVh+hSxDOx5VKS60t2Dt2GkMypMDcKSqxK0Gg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FaI7se6e882XtzIcMHICl3UvwjtOSQOOe0qyalFWzsYBAhZBVDeu6Aj4hzmMNDBMFYkK1z/isQSObfHs5wbRb87QeXTLHD+tEJIZn1zgg6PfkckxXyf2LqzS+h/MPUCE977u/735P+wi8yXtqVXjipbnlLbn0fsTD97duZ0rk7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RUGZ0eI/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758217231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t1W/1phtqwQuVUIVURl6ScoEnd5TdTDKATokoKxzRnw=;
	b=RUGZ0eI/ZnBFQkTCZ0u+8BmK68rg+oCa2UfZG1Fs3IVdh76I7fgfxIyehLcISkxKqy1RSn
	JxT9lAY6lJ4b/91wnXpb1hySOFYey1B5x5NBplgMd9P5Q4Om1SY18Dk5hPBWUSmswF+vtK
	sbS0aqwKHT5CxhR6aP/f1LbmbLPIOmM=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-Hdi_lvOcPRyjIZzxb1LtZg-1; Thu, 18 Sep 2025 13:40:30 -0400
X-MC-Unique: Hdi_lvOcPRyjIZzxb1LtZg-1
X-Mimecast-MFC-AGG-ID: Hdi_lvOcPRyjIZzxb1LtZg_1758217229
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45de07b831dso6305545e9.1
        for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 10:40:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758217229; x=1758822029;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t1W/1phtqwQuVUIVURl6ScoEnd5TdTDKATokoKxzRnw=;
        b=ixMAaUJ+6SbfbsVMFnxzTgd+375c62XM/GMCdQzYNO0xEuctwT0t42eZYBidUAYj+i
         V3lCZDa4Op7fLLeQmQ7zrW47RvyZFWtZHvdP3rCuhpJe+9wMQGWyrCbAxr2Ik3w0x/tE
         X2fV40ken4WgUNKonMlJZJmT2y6Exyvx2m/Zqge/S/WKXiNDzmW2xHkb+DiJqHvSEn46
         1ynANHKkOzunfxTW0eYlQLFPiizHrhWjOkiEGRJLZbCP3JAMlc1xgKE9n+r0qX673q2P
         d/7c+sRdUMM3FBBXzxolDUIlDDUe2QsjQSnUIC9SsSrNz+ekJdb1g7SrFnL8b0nLul16
         mErw==
X-Forwarded-Encrypted: i=1; AJvYcCXjsK1zlSQZ0W+z7XL3xM/bEjO3KlWIpbgvqh+2gxHyXE9yha0aajAvPtLn+ooZBoJws7c=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMTKvz1z9pwokp5f6DJpReJrJcMpUOVcQZomAIaqRgYYfZQZjK
	kEv3mKtDaKdyGuZ46gX8qrj35h1UqUb0p9wkFB4adXArpfD9kijbsJlFoGx/AK9cvZdVG40j81L
	ee+rbG4IR2klUO8Jaa/o9cA0UGCIti4oWJiXq7JfJ+Mx1Iz8K9WLozA==
X-Gm-Gg: ASbGnctVmEeyhmn6gIGkg/vftA2yGs5X//gZpeJqn43VApShUa1/J3XYOMmxRce+RSj
	wHVdrDSp1/N1cmlsqje7xvqRwetaXxgpVan3nqX/SbQf9EvPiTBPhFGR3/f377IC8RqiXBwgCqO
	eYZbDfgclUi5CfdZlDAJdGHiZNREgwccxhzpxoxvhHktl0Rg1ArqMbwv0YhpXnoGGO20OpxSsYG
	nFDpUb+WYiFTR/Iljz/BKL1WtvftWWtBszxRJfqt6R9yV1avzi7GyRlqQ6BaIS6W+WVwJ5mR2jw
	7rFsmwoevHhrmeyZIf9/v6HOeg2qBPbSXAI=
X-Received: by 2002:a05:600c:48a5:b0:45f:28ed:6e1e with SMTP id 5b1f17b1804b1-467e8afde63mr763595e9.16.1758217228689;
        Thu, 18 Sep 2025 10:40:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOoCiSMZx3r6ahJEsPst7vmWcAL9LRHA1I1NtHk23nXFndZVGSronTsEuZNCUr5eL1KdExGQ==
X-Received: by 2002:a05:600c:48a5:b0:45f:28ed:6e1e with SMTP id 5b1f17b1804b1-467e8afde63mr763425e9.16.1758217228248;
        Thu, 18 Sep 2025 10:40:28 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73e7:4d00:2294:2331:c6cf:2fde])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4613e93dd85sm103570545e9.22.2025.09.18.10.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 10:40:27 -0700 (PDT)
Date: Thu, 18 Sep 2025 13:40:25 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] vhost_task: Fix a bug where KVM wakes an exited
 task
Message-ID: <20250918133938-mutt-send-email-mst@kernel.org>
References: <20250827194107.4142164-1-seanjc@google.com>
 <20250827201059.EmmdDFB_@linutronix.de>
 <20250918110828-mutt-send-email-mst@kernel.org>
 <20250918154826.oUc0cW0Y@linutronix.de>
 <aMwtd40q44q5uqwr@google.com>
 <20250918120658-mutt-send-email-mst@kernel.org>
 <aMw4wx5ENt-odhYS@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMw4wx5ENt-odhYS@google.com>

On Thu, Sep 18, 2025 at 09:52:19AM -0700, Sean Christopherson wrote:
> On Thu, Sep 18, 2025, Michael S. Tsirkin wrote:
> > On Thu, Sep 18, 2025 at 09:04:07AM -0700, Sean Christopherson wrote:
> > > On Thu, Sep 18, 2025, Sebastian Andrzej Siewior wrote:
> > > > On 2025-09-18 11:09:05 [-0400], Michael S. Tsirkin wrote:
> > > > > So how about switching to this approach then?
> > > > > Instead of piling up fixes like we seem to do now ...
> > > 
> > > I don't have a strong preference for 6.17, beyond landing a fix of some kind.
> > > I think there are three options for 6.17, in order of "least like to break
> > > something":
> > > 
> > >  1. Sebastian's get_task_struct() fix
> > 
> > 
> > I am just a bit apprehensive that we don't create a situation
> > where we leak the task struct somehow, given the limited
> > testing time. Can you help me get convinced that risk is 0?
> 
> I doubt it, I share same similar concerns about lack of testing.  So I guess
> thinking about this again, #2 is probably safer since it'd only impact KVM?

I can't say I understand completely how we get that state though?
Why did the warning trigger if it's not a UAF?

> > >  2. This series, without the KILLED sanity check in __vhost_task_wake()
> > >  3. This series, with my fixup (with which syzbot was happy)


