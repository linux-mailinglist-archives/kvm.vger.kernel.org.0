Return-Path: <kvm+bounces-11801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3916087BF9B
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 16:09:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A29E51F23B24
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 15:09:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1446471747;
	Thu, 14 Mar 2024 15:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YH0GHa/k"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CF971738
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 15:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710428977; cv=none; b=mOh2I8plbEhq8lem1hyjmr2AHK+tcJScyKjHpSLJJaqbcs7bKPKMn+miE/oMrJDKkyp9LcTo06VQHWCAuk8snUKaGwSGEoM56YEQ6lK2/yTY8mAiJYsebY99WEsGkVvQ0V6gxEolkpbdTBkgaZJ+ZP2xK8KQXlLVaR8A6ScnOeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710428977; c=relaxed/simple;
	bh=AQfUW3gFNrbjXXL3IloGvW+E2jBS9PDIeGTSBRAl+RQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hiTeHfxwEMkNPD1qt9kgLdzZFqT/0TKh2uBtUlJhrd+6OLahZDvRG9JaH3VDM8hiYOapB8Fx6It6gAIgyPicChcCpALNzKd155T4Uaf0AbWWQzH9LtoQU2woKHfqTqTRXFFhCii6ksXJTCvJ50551tVyP7qhtkWrxmVBZLFr3Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YH0GHa/k; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710428974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EtZDDd/rvhCl2ys9FRYjPigN0aLlgEl2NbUy3nuNa/o=;
	b=YH0GHa/kkfq82Ig8TjQ7hEwSZePuVU3KXEjfWKmoW9ZvwfHhbYauqPNoPKI1g+B2qCMwJ1
	qru4Y8fQUXBcmm7kSFEO9NFN2nseHgEBlBsSlYN7O2wJLyPi0bHXyOZiwRJkqT2++9skPM
	QMtTQaXw9iV8re1hWmK9gOLQZDdRhGo=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-xID35eQ2M4eYPNH7BZsUDQ-1; Thu, 14 Mar 2024 11:09:31 -0400
X-MC-Unique: xID35eQ2M4eYPNH7BZsUDQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-513a1ed3ff8so1297265e87.1
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 08:09:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710428970; x=1711033770;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EtZDDd/rvhCl2ys9FRYjPigN0aLlgEl2NbUy3nuNa/o=;
        b=jgWjdVHcPQX3ohkBaptULEynnyJilaSUOhPfG1LOBASrO3o/ZuOr67O4z5wtyaSoQ/
         xuGupRBTHL1sKsFec1xQsAP0ocmnJGAWrv+FNjOkg4KUoaZZJRiW3bjEuqV41yZkHne2
         OypojJu3l5HT73J8Ifhy0OIQfWyzd8UlFyVVSQwZ3zz9mIx5wBMqyOdOvLDS+KdaSy+R
         1d+P2VCqrHIUI4vDoImUE5hb9CQ9E8HebufVKTN/qenIEZFUhGhlJvDoWBvJYay25+Qm
         s9luwkNmVy5YJ4sobQhX25e0pR3MK1qtJBVvwVbg5Hk6gxhXHcMGaqwz0J4qn64zFuuc
         nFrg==
X-Forwarded-Encrypted: i=1; AJvYcCUlK03mo6W6Om9FxRN6bdSe39SPAyHCCPQEywWxXWlQ3C5mNLfwMLShbYQLkOvGUL5P2a+aHDv6PdylNJmSCwGG6+SP
X-Gm-Message-State: AOJu0YyxSkkMSmy6tqOo09ylhxWZo0Ct7VxzUp5gweKZF3SnRfYEZ7cH
	vneCZwQ/YSPXULFizVa/V0yNf3OiOAdbgWpYGhTNpTLVFtHQgieMaw4L7E8er9Ez3cTpJ6hSPtA
	EIUkg17aRWsLhwNIO5eQZjVIYO35tIKrt3c1sokwo1cj0gBQbrA==
X-Received: by 2002:a19:914c:0:b0:513:cab1:dc9a with SMTP id y12-20020a19914c000000b00513cab1dc9amr1492769lfj.19.1710428970153;
        Thu, 14 Mar 2024 08:09:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEJWuoe/3iFru0sIgh80GCQKJ1jGXO44jJmLMs2cyMkKY2erF0fOYFgEPRPLaBXlctWIZnyYg==
X-Received: by 2002:a19:914c:0:b0:513:cab1:dc9a with SMTP id y12-20020a19914c000000b00513cab1dc9amr1492752lfj.19.1710428969612;
        Thu, 14 Mar 2024 08:09:29 -0700 (PDT)
Received: from redhat.com ([2.52.141.198])
        by smtp.gmail.com with ESMTPSA id b9-20020a05600c4e0900b004132f8c2ac1sm2732690wmq.14.2024.03.14.08.09.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Mar 2024 08:09:29 -0700 (PDT)
Date: Thu, 14 Mar 2024 11:09:25 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tobias Huschle <huschle@linux.ibm.com>
Cc: Luis Machado <luis.machado@arm.com>, Jason Wang <jasowang@redhat.com>,
	Abel Wu <wuyun.abel@bytedance.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	nd <nd@arm.com>
Subject: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair: Add
 lag based placement)
Message-ID: <20240314110649-mutt-send-email-mst@kernel.org>
References: <20231213094854-mutt-send-email-mst@kernel.org>
 <20231214021328-mutt-send-email-mst@kernel.org>
 <92916.124010808133201076@us-mta-622.us.mimecast.lan>
 <20240121134311-mutt-send-email-mst@kernel.org>
 <07974.124020102385100135@us-mta-501.us.mimecast.lan>
 <20240201030341-mutt-send-email-mst@kernel.org>
 <89460.124020106474400877@us-mta-475.us.mimecast.lan>
 <20240311130446-mutt-send-email-mst@kernel.org>
 <cf813f92-9806-4449-b099-1bb2bd492b3c@arm.com>
 <73123.124031407552500165@us-mta-156.us.mimecast.lan>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73123.124031407552500165@us-mta-156.us.mimecast.lan>

On Thu, Mar 14, 2024 at 12:46:54PM +0100, Tobias Huschle wrote:
> On Tue, Mar 12, 2024 at 09:45:57AM +0000, Luis Machado wrote:
> > On 3/11/24 17:05, Michael S. Tsirkin wrote:
> > > 
> > > Are we going anywhere with this btw?
> > > 
> > >
> > 
> > I think Tobias had a couple other threads related to this, with other potential fixes:
> > 
> > https://lore.kernel.org/lkml/20240228161018.14253-1-huschle@linux.ibm.com/
> > 
> > https://lore.kernel.org/lkml/20240228161023.14310-1-huschle@linux.ibm.com/
> > 
> 
> Sorry, Michael, should have provided those threads here as well.
> 
> The more I look into this issue, the more things to ponder upon I find.
> It seems like this issue can (maybe) be fixed on the scheduler side after all.
> 
> The root cause of this regression remains that the mentioned kworker gets
> a negative lag value and is therefore not elligible to run on wake up.
> This negative lag is potentially assigned incorrectly. But I'm not sure yet.
> 
> Anytime I find something that can address the symptom, there is a potential
> root cause on another level, and I would like to avoid to just address a
> symptom to fix the issue, wheras it would be better to find the actual
> root cause.
> 
> I would nevertheless still argue, that vhost relies rather heavily on the fact
> that the kworker gets scheduled on wake up everytime. But I don't have a 
> proposal at hand that accounts for potential side effects if opting for
> explicitly initiating a schedule.
> Maybe the assumption, that said kworker should always be selected on wake 
> up is valid. In that case the explicit schedule would merely be a safety 
> net.
> 
> I will let you know if something comes up on the scheduler side. There are
> some more ideas on my side how this could be approached.

Thanks a lot! To clarify it is not that I am opposed to changing vhost.
I would like however for some documentation to exist saying that if you
do abc then call API xyz. Then I hope we can feel a bit safer that
future scheduler changes will not break vhost (though as usual, nothing
is for sure).  Right now we are going by the documentation and that says
cond_resched so we do that.

-- 
MST


