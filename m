Return-Path: <kvm+bounces-38392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E305EA38E55
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 22:56:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2B863B2855
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 21:56:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4996E1A9B29;
	Mon, 17 Feb 2025 21:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YPLLW8EX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100AE1A23B5
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 21:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739829374; cv=none; b=CznWp5NnAAwfERAxqIabaxNpKKTdED9c4vkyLBY55Q710UCDCjAEM8OUaCrZFiaFLfxhjyJlAXWmwBUF3ohlsGzPdHn21zw0DqCsyAkmJoX/Oo3UsYhVtnD+lfz+qT7Xt2zTnppK0DDIK3p/wTGphMmEtOAAYb4AB4v1U1w7wVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739829374; c=relaxed/simple;
	bh=N2pCvbsInOvtXuv75JS94lrc9pN+Og0+y7iXDBWGipE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QDLZWbjpcvFl13F0RQNOvb+dih1PwWdYGbUytDp8KEHceORiXbmHVa6ANCzQVMB4KROLtm9xujX0Cp5a/vKSFPAPApsQVyfKDuAXLwTD8YbCUMBzSx4CHhox8d+NhNZ8Eph6IpmrkoAsUnu38kQdN6ixDj4EbrcYL9a/4cl1fYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YPLLW8EX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739829371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ma+WDCstUob+rO5FJpLhVsCO991W7dWOQMuhns1ORLM=;
	b=YPLLW8EXZk3IEf82KnfiS7UcC7uYmiGx76757P2FSZ/jb7+Td9VopOitXA9QEhJ9rgq5CU
	4SLWz8cDOEgtTUqd6zFMVgHU5MqmYOYEyZ05iyTn/AtP+NUzH93z6fzPiLh2271dY9F/y8
	+TIPkMAyLyXypjccku+RxaFZ+d/R5jQ=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-VNUlUvFLPZawboaAL4q_Zg-1; Mon, 17 Feb 2025 16:56:10 -0500
X-MC-Unique: VNUlUvFLPZawboaAL4q_Zg-1
X-Mimecast-MFC-AGG-ID: VNUlUvFLPZawboaAL4q_Zg_1739829370
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3ce848b708fso3727435ab.3
        for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 13:56:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739829369; x=1740434169;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ma+WDCstUob+rO5FJpLhVsCO991W7dWOQMuhns1ORLM=;
        b=k7OKwdR/q8j2O614bGpXWYMd2x6F4GBJyz4H76pgbDOO/Uk8JUOKooeLXUFcBTW/Vv
         Jsboxs7rz15RR9DdOy28tEjZkvfgu710VehLB3M1THwBRdt3oBPUEY88JdddxSyjGR2I
         T1yW/cqDJ75XbJnYgqPbcO1/EQKy8B4QwIVk0p+DNGt4qrkDj3rOhqt3ohZeW5ZMxpbi
         q9XIkV7rT6cusm0rA26ouTTQBnNgZ2l4aJ0xjSbspuUmtxijazzYzunUGNdv6opHqdZt
         dKV/Meb92lDC84lPTifwbOSeZuTeAxP5ghDItUTiOIQIs+yXNtvntYfGN5PbvaBR+Jh/
         6nLA==
X-Gm-Message-State: AOJu0Yxbi1bbPK/D4eZKdk69l8T8aGk+CN/+LDh83LaHf7ChmNtxA/9u
	PZcM9KfOy3ryxEn5vVR0p6cREgRiTodE3xeucoPCbs47QPnPG0Zdk5mGuvnubtJr/Uco14DQRxI
	MEB+w1agIAQE4CXBSctY8V2AiGAuqhlI8ckyyujB8tauStFz5Dw==
X-Gm-Gg: ASbGncvI/LRrGnIhdzIgvtrgGtsmqrGKcTJASWJFjqNmPdhMAwATr+TfRNNb8ohwmsJ
	ztVfHVVGrRZDiQ4lks+lotwwFTQmiUdE2OV1gQQ3Oz9oWHPJ8t+OxWn8n+RT0npZT9bG0D98rY9
	8viA3oAO/2K0xdozuwToFS42MZ9JcGe/OBrQKwPdBAqa1+T6CA5Qxa36tPlui7P1uLZONfuGkW1
	D4Zix+9lDABT3RmjrpgH/FreVP+02+76ZC9MmLrK2i2lPmGzup8U9wkCcQwNZ2r5m6KlT+DWEh6
	2DJ0Qtql
X-Received: by 2002:a05:6602:13d4:b0:855:683d:d468 with SMTP id ca18e2360f4ac-85579fe5006mr245136639f.0.1739829369722;
        Mon, 17 Feb 2025 13:56:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGnC63RTWm/9A8auCeEObZ+CHD/OXQEjDxR7vyZ9cE6BFwEm2a2tfvMMhgn6LJkud3CRBJDvw==
X-Received: by 2002:a05:6602:13d4:b0:855:683d:d468 with SMTP id ca18e2360f4ac-85579fe5006mr245135939f.0.1739829369431;
        Mon, 17 Feb 2025 13:56:09 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ee82c8d5b0sm1436012173.120.2025.02.17.13.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2025 13:56:08 -0800 (PST)
Date: Mon, 17 Feb 2025 14:56:06 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterx@redhat.com,
 mitchell.augustin@canonical.com, clg@redhat.com, akpm@linux-foundation.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 4/5] mm: Provide page mask in struct follow_pfnmap_args
Message-ID: <20250217145606.22b95d9b.alex.williamson@redhat.com>
In-Reply-To: <c90376b4-0a8b-4db9-8b84-39325b1ac57e@redhat.com>
References: <20250205231728.2527186-1-alex.williamson@redhat.com>
	<20250205231728.2527186-5-alex.williamson@redhat.com>
	<20250214101735.4b180123.alex.williamson@redhat.com>
	<c90376b4-0a8b-4db9-8b84-39325b1ac57e@redhat.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 14 Feb 2025 22:39:30 +0100
David Hildenbrand <david@redhat.com> wrote:

> On 14.02.25 18:17, Alex Williamson wrote:
> > 
> > Nudge.  Peter Xu provided an R-b for the series.  Would any other mm
> > folks like to chime in here to provide objection or approval for this
> > change and merging it through the vfio tree?  Series[1].  Thanks!
> >   
> 
> Only skimmed over it, nothing jumped at me except ...
> 
> Nitpicking:
> 
> I was wondering if "page mask" really the right term here. I know that 
> we use it in some context (gup, hugetlb, zeropage) to express "mask this 
> off and you get the start of the aligned huge page".
> 
> For something that walks PFNMAPs (page frames without any real "huge 
> page" logical metadata etc. grouping) it was uintuitive for me at first.
> 
> addr_mask or pfn_mask (shifted addr_mask) would have been clearer for me.
> 
> No strong opinion, just what came to mind while reading this ...

It's called addr_mask in pfnmap_args_setup() so I'm happy to keep that
naming if pgmask is less intuitive.  Thanks,

Alex


