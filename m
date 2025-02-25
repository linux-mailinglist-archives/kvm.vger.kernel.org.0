Return-Path: <kvm+bounces-39102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D229BA43ACE
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 11:08:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F3FF3B805C
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 10:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94D92269AF3;
	Tue, 25 Feb 2025 10:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i66jAuZ9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D367626281C
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 10:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740477686; cv=none; b=uj/BrCmkfmNgUos3P7JVwzGUizBmXJ+LdChbmayD0PRWToBtH14dT//zVlVIjWT3pXy+pG06EZOxps1ST4nVW8eoiWONZb2XsJtmjd8OWHDi3kJZaddoKXRvodBwF1aZJY3hpjqJ6GBdLlIOQqtQWAhiuELEFq0GR56obHGWEPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740477686; c=relaxed/simple;
	bh=/lpmKbM98sReqxt4FChWNyPL5Ir7mfBCbTrSm6gJgfE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pxm4kshc/ZvJc+rzM93Is26c7jX++39OyeWRDd/wcAAIut4wu3I976ie6297fpgK6LmaTM+2InWxBkCnNLfTUFKcTuH1VK8fH+KbXR3ZLRgvtHthfDsYmKvnd7mHeDcueO7Bk6FrSIBkq5/dZkK1cC+JxXwpCUk8CkuBCeqFLpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i66jAuZ9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740477681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/oob05Zz0uyD/XBE51wa6Mc8C+ILDhC8TNNOox+clSQ=;
	b=i66jAuZ9Bfw70LLklFG1seVbHZxWmjde87f19Pe49Fog+mcEKwMAHonmtfRVik5Wz8qDKc
	Ybd92SXobyJBFy/qKFMl4W5/exDr3omcXKLw/SECGGkDnSP0+v1HDdAHj+Fd7y310KRWi9
	hJx+/P38xO5PpNXdhZOrHWNxATqySKo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-NCcuRGt-MwurfPbSmCAPhQ-1; Tue, 25 Feb 2025 05:01:18 -0500
X-MC-Unique: NCcuRGt-MwurfPbSmCAPhQ-1
X-Mimecast-MFC-AGG-ID: NCcuRGt-MwurfPbSmCAPhQ_1740477678
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43947979ce8so23293605e9.0
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 02:01:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740477677; x=1741082477;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/oob05Zz0uyD/XBE51wa6Mc8C+ILDhC8TNNOox+clSQ=;
        b=Phto1GgX802QZS6+fKrZZ3qZBYiYl89ONqtNNIgqPxvw0lWEiOshh6wwHb4f1QGpv2
         lxlMZYOPjhOJlh5wCnGOXqzsFq5VNwpJL9cu6psGJlK/B90g1wcrC99KWLKQx9iQeWUd
         fIcy8lK2UxNhw+NvrEF2czteNoLrDFpVVzOry+4PRdVYBTce4T4Q4JAZ9WUGtu5qo1JT
         nUHnfSuXF93Jxa5rI5Sakog0yIoQxf49x1MGUzAC7nLWlDnhwkPnIQUsK7/HQKUZEXIU
         f6eTmnOsBRRTQ8yu4Tw1Mh/BbYehlAJwW5m2/NDAxQBVQtJNW6hvAaNMF3BkfHqO7vsT
         9Gqg==
X-Forwarded-Encrypted: i=1; AJvYcCWAL6BoNr7AryJLl6ye0INQZ/RLZghYrwL+PqsEJzaVD1n2WR8+4l+17UAtrPxIBIKltyc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqtGeZXc80ShyqbwRBfGjOW3d1vnRuANLjr33DvqbWcJ0IRFaC
	JRRmFPvb2sNg4LhRODU5P4kyXmUlZ8Y/blUaQa75EqMGDMgTrCotnAsYZdowtKrGHAQfRl3fi7D
	e85kLYAwnRupAQGgvhTX55Z+f6dwlBUXp9j7PomMs1wAJzP5J3w==
X-Gm-Gg: ASbGnctfncNV++kFP0Whl2OwfbzxnFtEgGHAbb+icbcP40c76Wow3H01pqi3lM8RPiJ
	MouOeu4ZmTwQHVar9MVa6FZuHgycjHzAZ4AZxJE3tu0+7VOB6Yynu2WDkptJoqN5DsfJdqml28x
	UJW9RYkM4GnITu+TFV+xVaT0mXMWxoeWVwDPVte+aWncPVT9Oq4dJl/QcgnvK8kchiPuWFJLY40
	VfsW5wtVHUvmAK2RhFCQ1pm1KrVKWp9kb/FrInRpapQ18Joaad+bQA1jIBvN2xL4D02c4oEBKgM
	trBvslNH4TcI/7+tbBB66J0sszT7lBY7SCUWm1D1j5tdVdeSweDnAnRQPX31Hys=
X-Received: by 2002:a05:600c:3582:b0:434:f131:1e64 with SMTP id 5b1f17b1804b1-439ae1e960dmr126912615e9.9.1740477677421;
        Tue, 25 Feb 2025 02:01:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGFtCPwMwCWEkCujQAtGB/IAc3Rx6Ggr5o3VQ96qC0I11ol3KnmivdGHCMQQLoZ6t1X2yVwRA==
X-Received: by 2002:a05:600c:3582:b0:434:f131:1e64 with SMTP id 5b1f17b1804b1-439ae1e960dmr126912025e9.9.1740477676935;
        Tue, 25 Feb 2025 02:01:16 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43ab1546f77sm19802945e9.20.2025.02.25.02.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 02:01:16 -0800 (PST)
Date: Tue, 25 Feb 2025 11:01:15 +0100
From: Igor Mammedov <imammedo@redhat.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>, "Michael S . Tsirkin"
 <mst@redhat.com>, Shiju Jose <shiju.jose@huawei.com>,
 <qemu-arm@nongnu.org>, <qemu-devel@nongnu.org>, Philippe =?UTF-8?B?TWF0?=
 =?UTF-8?B?aGlldS1EYXVkw6k=?= <philmd@linaro.org>, Ani Sinha
 <anisinha@redhat.com>, Cleber Rosa <crosa@redhat.com>, Dongjiu Geng
 <gengdongjiu1@gmail.com>, Eduardo Habkost <eduardo@habkost.net>, Eric Blake
 <eblake@redhat.com>, John Snow <jsnow@redhat.com>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, "Markus Armbruster" <armbru@redhat.com>,
 Michael Roth <michael.roth@amd.com>, "Paolo Bonzini" <pbonzini@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Shannon Zhao
 <shannon.zhaosl@gmail.com>, Yanan Wang <wangyanan55@huawei.com>, Zhao Liu
 <zhao1.liu@intel.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, Gavin Shan <gshan@redhat.com>, Ani Sinha
 <anisinha@redhat.com>
Subject: Re: [PATCH v3 00/14] Change ghes to use HEST-based offsets and add
 support for error inject
Message-ID: <20250225110115.6090e416@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250221102127.000059e6@huawei.com>
References: <cover.1738345063.git.mchehab+huawei@kernel.org>
	<20250203110934.000038d8@huawei.com>
	<20250203162236.7d5872ff@imammedo.users.ipa.redhat.com>
	<20250221073823.061a1039@foz.lan>
	<20250221102127.000059e6@huawei.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 21 Feb 2025 10:21:27 +0000
Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:

> On Fri, 21 Feb 2025 07:38:23 +0100
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
> 
> > Em Mon, 3 Feb 2025 16:22:36 +0100
> > Igor Mammedov <imammedo@redhat.com> escreveu:
> >   
> > > On Mon, 3 Feb 2025 11:09:34 +0000
> > > Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:
> > >     
> > > > On Fri, 31 Jan 2025 18:42:41 +0100
> > > > Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
> > > >       
> > > > > Now that the ghes preparation patches were merged, let's add support
> > > > > for error injection.
> > > > > 
> > > > > On this series, the first 6 patches chang to the math used to calculate offsets at HEST
> > > > > table and hardware_error firmware file, together with its migration code. Migration tested
> > > > > with both latest QEMU released kernel and upstream, on both directions.
> > > > > 
> > > > > The next patches add a new QAPI to allow injecting GHESv2 errors, and a script using such QAPI
> > > > >    to inject ARM Processor Error records.
> > > > > 
> > > > > If I'm counting well, this is the 19th submission of my error inject patches.        
> > > > 
> > > > Looks good to me. All remaining trivial things are in the category
> > > > of things to consider only if you are doing another spin.  The code
> > > > ends up how I'd like it at the end of the series anyway, just
> > > > a question of the precise path to that state!      
> > > 
> > > if you look at series as a whole it's more or less fine (I guess you
> > > and me got used to it)
> > > 
> > > however if you take it patch by patch (as if you've never seen it)
> > > ordering is messed up (the same would apply to everyone after a while
> > > when it's forgotten)
> > > 
> > > So I'd strongly suggest to restructure the series (especially 2-6/14).
> > > re sum up my comments wrt ordering:
> > > 
> > > 0  add testcase for HEST table with current HEST as expected blob
> > >    (currently missing), so that we can be sure that we haven't messed
> > >    existing tables during refactoring.    
> 
> To potentially save time I think Igor is asking that before you do anything
> at all you plug the existing test hole which is that we don't test HEST
> at all.   Even after this series I think we don't test HEST.  You add
> a stub hest and exclusion but then in patch 12 the HEST stub is deleted whereas
> it should be replaced with the example data for the test.

that's what I was saying.
HEST table should be in DSDT, but it's optional and one has to use
'ras=on' option to enable that, which we aren't doing ATM.
So whatever changes are happening we aren't seeing them in tests
nor will we see any regression for the same reason.

While white listing tables before change should happen and then updating them
is the right thing to do, it's not sufficient since none of tests
run with 'ras' enabled, hence code is not actually executed. 

> 
> That indeed doesn't address testing the error data storage which would be
> a different problem.

I'd skip hardware_errors/CPER testing from QEMU unit tests.
That's basically requires functioning 'APEI driver' to test that.

Maybe we can use Ani's framework to parse HEST and all the way
towards CPER record(s) traversal, but that's certainly out of
scope of this series.
It could be done on top, but I won't insist even on that
since Mauro's out of tree error injection testing will
cover that using actual guest (which I assume he would
like to run periodically).

> > 
> > Not sure if I got this one. The HEST table is part of etc/acpi/tables,
> > which is already tested, as you pointed at the previous reviews. Doing
> > changes there is already detected. That's basically why we added patches
> > 10 and 12:
> > 
> > 	[PATCH v3 10/14] tests/acpi: virt: allow acpi table changes for a new table: HEST
> > 	[PATCH v3 12/14] tests/acpi: virt: add a HEST table to aarch64 virt and update DSDT
> > 
> > What tests don't have is a check for etc/hardware_errors firmware inside 
> > tests/data/acpi/aarch64/virt/, but, IMO, we shouldn't add it there.
> > 
> > See, hardware_errors table contains only some skeleton space to
> > store:
> > 
> > 	- 1 or more error block address offsets;
> > 	- 1 or more read ack register;
> > 	- 1 or more HEST source entries containing CPER blocks.
> > 
> > There's nothing there to be actually checked: it is just some
> > empty spaces with a variable number of fields.
> > 
> > With the new code, the actual number of CPER blocks and their
> > corresponding offsets and read ack registers can be different on 
> > different architectures. So, for instance, when we add x86 support,
> > we'll likely start with just one error source entry, while arm will
> > have two after this changeset.
> > 
> > Also, one possibility to address the issues reported by Gavin Shan at
> > https://lore.kernel.org/qemu-devel/20250214041635.608012-1-gshan@redhat.com/
> > would be to have one entry per each CPU. So, the size of such firmware
> > could be dependent on the number of CPUs.
> > 
> > So, adding any validation to it would just cause pain and probably
> > won't detect any problems.  
> 
> If we did do this the test would use a fixed number of CPUs so
> would just verify we didn't break a small number of variants. Useful
> but to me a follow up to this series not something that needs to
> be part of it - particularly as Gavin's work may well change that!
> 
> > 
> > What could be done instead is to have a different type of tests that
> > would use the error injection script to check if regressions are 
> > introduced after QEMU 10.0. Such new kind of test would require
> > this series to be merged first. It would also require the usage of
> > an OSPM image with some testing tools on it. This is easier said 
> > than done, as besides the complexity of having an OSPM test image,
> > such kind of tests would require extra logic, specially if it would
> > check regressions for SEA and other notification sources.
> >   
> Agreed that a more end to end test is even better, but those are
> quite a bit more complex so definitely a follow up.
> 
> J
> > Thanks,
> > Mauro
> >   
> 


