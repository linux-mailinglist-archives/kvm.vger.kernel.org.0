Return-Path: <kvm+bounces-37130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4F6AA25E94
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 16:25:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93B4D164844
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 15:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 876FF209F2A;
	Mon,  3 Feb 2025 15:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VHyvM+0m"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A8B208974
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 15:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738596163; cv=none; b=VZXmd8seBJVqqJqn8F56h862KppqWd4UIciqKhNHbYSQSOrxDjwNYulF+lQUosHsaw7NMzGY+piZhROU0yAQxcZIy+FApHhpM6WauAfNtVuSqEgrU1ZAzEVoKhPJSULxpRnsxQH8zkX6IeGUAUKwgrzKg5XvGr49O0F1tfXlHnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738596163; c=relaxed/simple;
	bh=s8T40ATQi5ozZFq3mLiRG0r8Wyc9sfTkDVrpD+sYS2g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ebmn1GR+UHq04MZ77uOsuz0+HTB6nU8+Ss0CR2qGiyEAe8dWHcoW/rYokKPNL7+RfhhNSBajt6qOPAAqU5dAXcXWddYJapdGOUs2djNqmtg64EZZOzQkVn7XTCYsmg2W6p/FfS32snsLRHuMn8oao+RNd2HRtEaCp/4iHjRso0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VHyvM+0m; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738596160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IPyZM1t4JHDpUYVyrdVFxb2Um0jbsvrzJI4R8XaR9uA=;
	b=VHyvM+0mxz8D1ToLZ+kPH28eqf+f/XA7CMpuYVl/43+wuLo8X8mTYXxnKBYB7KIdij8eFp
	FzdcyEJsrqqYo5Vl7CWd/OkYnrpIxFr8+OwfJGNTfXtJiY/fEEG2epEGo6jOzKyHVqTWZy
	PgUzDhentl0a0H1RwQYBD0+fi8mu570=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-ko0hemhxML2ItK6TrFTqJA-1; Mon, 03 Feb 2025 10:22:39 -0500
X-MC-Unique: ko0hemhxML2ItK6TrFTqJA-1
X-Mimecast-MFC-AGG-ID: ko0hemhxML2ItK6TrFTqJA
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-385fdff9db5so1895417f8f.0
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2025 07:22:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738596158; x=1739200958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IPyZM1t4JHDpUYVyrdVFxb2Um0jbsvrzJI4R8XaR9uA=;
        b=E7jdtuvV8Q4aGODtW6PiX+gGl5Cxtp65c294U1iWyDX9Y7uD0KtDRoaFSjVQ976X8C
         tfO4PmXhXKKhfLhp2AVkTlYq/hbvWQdqkdSgeedxUBTrkIFRGevDxqzopXWl8QOvSD61
         SbzLm+tgVggXLe/mJ1bnzem+dNqqaFdB44TOZV4bPLA03xRJpS2wCb9/TKmn3jCzG4+D
         EijMpN64tFAATsleYjF5Pg0Y/Z63wYXjFs4eOZ5LSrtdUZd6j3MoTdhFiW/vswRqNEPQ
         yqMJU2OB2wk8EJi3Z7ds0bZaljXXvmE86HGhHeG3PQW1angd2JiLMA3y8zufGqLbjWJu
         sBug==
X-Forwarded-Encrypted: i=1; AJvYcCVS+5VZQ/3zJ3VG2aPshkO/zWMnnkckuy+r+agdEfyd1qAMZdJsgCNLVa22VYBhwnHQ9bA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZBoW40nQCMbNNCCMIpqcagTOKH5FtATjkoujRe+Ckt7lXcoyV
	movLbBS/fjJteP26RltCEHHkPFULsCV4AXXwyf01y+qpulaqbPm0T8Duq4VV5oyX2tLcv3xo2w7
	/Wa3g6Ehdpl7JTlFd+gZqO2Lhs1fsn3jboIRzJW5CLJqCQAA/YQ==
X-Gm-Gg: ASbGncs12/gqvc05iNfy/ZUBdEeQ0xl7uoFgf6TeTAa2TDepEcvX7rvzyskLl6Bx742
	S+9tUNXjdj3UpTr4uyIQZV9hJsH1xh2cE3lfqOC2xN90FZ6VKipHxVS+KIf/35FJUdVt7LYCD48
	/0UpWqKLF7b4SLXjtyXjx38mG7fJ3xbOyPOyZu+IGc4YHfDrRL2FltoBU1d1t7beuUGH/Ejkwcl
	Gn/bTiyN1UtticNUW5csKJcsWSbaMBLboa9oXMeWYi1WRElseQvMC2hX/TOvA4dCN7sB62tFjYE
	LuA1Y7NSmh+GKvYgx+1Cc2CnPeBws1Wn8pFp4NJ3vSnQbF3Va5ph
X-Received: by 2002:a05:6000:4011:b0:385:e8b0:df13 with SMTP id ffacd0b85a97d-38c52095e20mr20768469f8f.40.1738596158360;
        Mon, 03 Feb 2025 07:22:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFU8GdTGi8sB7oRmFhV909MaP4kFCPPAe8WiAnv6V5VuMzr3T7UiP99xHMB2JJSil2uW9p+BA==
X-Received: by 2002:a05:6000:4011:b0:385:e8b0:df13 with SMTP id ffacd0b85a97d-38c52095e20mr20768432f8f.40.1738596157876;
        Mon, 03 Feb 2025 07:22:37 -0800 (PST)
Received: from imammedo.users.ipa.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438e23de772sm157161035e9.13.2025.02.03.07.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2025 07:22:37 -0800 (PST)
Date: Mon, 3 Feb 2025 16:22:36 +0100
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
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 00/14] Change ghes to use HEST-based offsets and add
 support for error inject
Message-ID: <20250203162236.7d5872ff@imammedo.users.ipa.redhat.com>
In-Reply-To: <20250203110934.000038d8@huawei.com>
References: <cover.1738345063.git.mchehab+huawei@kernel.org>
	<20250203110934.000038d8@huawei.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 3 Feb 2025 11:09:34 +0000
Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:

> On Fri, 31 Jan 2025 18:42:41 +0100
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
> 
> > Now that the ghes preparation patches were merged, let's add support
> > for error injection.
> > 
> > On this series, the first 6 patches chang to the math used to calculate offsets at HEST
> > table and hardware_error firmware file, together with its migration code. Migration tested
> > with both latest QEMU released kernel and upstream, on both directions.
> > 
> > The next patches add a new QAPI to allow injecting GHESv2 errors, and a script using such QAPI
> >    to inject ARM Processor Error records.
> > 
> > If I'm counting well, this is the 19th submission of my error inject patches.  
> 
> Looks good to me. All remaining trivial things are in the category
> of things to consider only if you are doing another spin.  The code
> ends up how I'd like it at the end of the series anyway, just
> a question of the precise path to that state!

if you look at series as a whole it's more or less fine (I guess you
and me got used to it)

however if you take it patch by patch (as if you've never seen it)
ordering is messed up (the same would apply to everyone after a while
when it's forgotten)

So I'd strongly suggest to restructure the series (especially 2-6/14).
re sum up my comments wrt ordering:

0  add testcase for HEST table with current HEST as expected blob
   (currently missing), so that we can be sure that we haven't messed
   existing tables during refactoring.
1. Introduce use_hest_addr (disabled) for now so we could place all
   legacy code to !use_hest_addr branch
2. then patches that do the part of switching to HEST addr lookup,
    * ged lookup (preferably at the place it should end up eventually)
    * legacy bios_linker/fwcfg fencing patches
    * on top of that new hest bios_linker/fwcfg ones
    * and then the rest 
    (everything that belongs to the 2nd error source should _not_ be a part of that)
3. add 2nd error source incl. necessary tests procedures introduce
   and update DSDT/HEST



> 
> Jonathan
> 


