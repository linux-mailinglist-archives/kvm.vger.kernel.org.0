Return-Path: <kvm+bounces-30568-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C08D9BBED8
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 21:36:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E97411F22C19
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 20:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 317A71F5852;
	Mon,  4 Nov 2024 20:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i5iSuyFg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E27D1F5846
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 20:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730752580; cv=none; b=lCKgDl0KwVBPyctuy/ayL1vgcFb0qyQpoLvZxlXXmacUC84gxhiQc/SU7Baql7S+O91IrJuowYf/dLjb44WMMuh13r+tYbg57447E3qbx3I3pJLq8E9UYTr9IV8PUvVg+6WuimOZ5CRbhP5RiHSGVWGbRLrXqth49pXnBAk+JB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730752580; c=relaxed/simple;
	bh=/4kipNipjsy0gHcbOzkKkJwEem+dCzCJOCvQ5nlQMks=;
	h=Date:In-Reply-To:Mime-Version:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=HGjuicquDkF6JWRKMwM0eR3aRuKU7pA2U/9G6oaCgMiNlGpgwvipiduzjFx0u1Ym3AWZ4AWlTL39IxBMHGwDeocrnSZv/MV3G7RmZrsTAMLIKVMVMHLiDOv91k6grKkL4YXRjxO8R9ohT6NHG+gYocT8WTzloN1r0i/byWOthGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i5iSuyFg; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-20c9fe994daso48565335ad.2
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2024 12:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730752578; x=1731357378; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FBUqoCi8K8ESiGlnRsBfO9wVHimd//kbdOXM7NxwLpg=;
        b=i5iSuyFggjPJv/oTGTbp8antd+ZclEomN7ky7z9OvHMnNrq3p38+MCOa0opATRRfWP
         UbbFrt/OfJ3BvN5Sh78Hp/e6N7Yfv54fZHX4LdjyK3/4tOrU6kfVxZmIWEXGU9L0GEsu
         O4iSJY1ARJQcoTd3yTX7J3P2qu4qi38H4VjufJ+nsXatrPWs12xOfNBlNSFrVdM2t77w
         5JpMDkWJxNZT5HT8V/mJkFqaAEcMBBNncIC8AfnY56G65m+H84CtVdABEp1b0i2dE3YA
         QIvy9SMx3e1cpopll8Obdqppw3ABDMA/KQcZt54WCS9AiWve+AebzNvRtJWmbGKgEXyS
         q7NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730752578; x=1731357378;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FBUqoCi8K8ESiGlnRsBfO9wVHimd//kbdOXM7NxwLpg=;
        b=AnDyJaxZMzqzs3VdUSKIy9MHICWen33+sY7L92H5+Doe9SukzmtVA2P6KHfDPEmYSt
         VcziUBpRo21F5c1TIC5KrYA3lcAg2ZUSHD6QsKG9D7iu1FhbjAVAG6BRz2jATg87maVo
         MrqZF7RqcIuovnXwkBGItN8pJ2MGXDSj4Zo+2zfniHVOuhOd19gvaaa5yCfzMCIwDTQH
         f0lTXWlnwA1lhVTPbZVK8dCGcA77VhzxLcS6EnwYx/mXwhzcmOpTk0h8rQas575nVKg+
         3gywltoEx90HsCyJQeZG/hc12bL3WEQhNVYDVhIHq+Lnc/7laxS+Ti/ymJKBX42Zru+Q
         IUUA==
X-Forwarded-Encrypted: i=1; AJvYcCV21/awJ4tZr4WGVCXGGTs46QKKMqk7Oz5bUnA4jTn9HBJM+MoZArV8dexkQPuYEY5LW7Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSAYKFp0SD9fFBX1lhzhwLZvE9nsxbZNmLEZl4Jbbz+NkZz2sD
	uiKqd0XI3eLxfOGfkbDdOQnE90h1m5OxFNkJHwVjoa8CuavTWO7Hm4xx2hHUmuu7lZcmY1DWtiZ
	noyg+3DpzSA/GMN68KMpw9Q==
X-Google-Smtp-Source: AGHT+IFU04o9XUDE//mBesDzlZUGfXhW0O1bweXhu5hafrvVsG3Q2k1UIzGyEqRQkYf6VWaas7XC9AtGk9HO8gA8fA==
X-Received: from ackerleytng-ctop-specialist.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1612]) (user=ackerleytng job=sendgmr) by
 2002:a17:902:c401:b0:20c:e4b5:40ff with SMTP id d9443c01a7336-210f763bf78mr2611005ad.7.1730752578323;
 Mon, 04 Nov 2024 12:36:18 -0800 (PST)
Date: Mon, 04 Nov 2024 20:36:16 +0000
In-Reply-To: <4b49248b-1cf1-44dc-9b50-ee551e1671ac@redhat.com> (message from
 David Hildenbrand on Thu, 10 Oct 2024 15:39:37 +0200)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <diqzmsieybwf.fsf@ackerleytng-ctop-specialist.c.googlers.com>
Subject: Re: Proposal: bi-weekly guest_memfd upstream call
From: Ackerley Tng <ackerleytng@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-coco@lists.linux.dev, kvm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

David Hildenbrand <david@redhat.com> writes:

> Ahoihoi,
>
> while talking to a bunch of folks at LPC about guest_memfd, it was 
> raised that there isn't really a place for people to discuss the 
> development of guest_memfd on a regular basis.
>
> There is a KVM upstream call, but guest_memfd is on its way of not being 
> guest_memfd specific ("library") and there is the bi-weekly MM alignment 
> call, but we're not going to hijack that meeting completely + a lot of 
> guest_memfd stuff doesn't need all the MM experts ;)
>
> So my proposal would be to have a bi-weekly meeting, to discuss ongoing 
> development of guest_memfd, in particular:
>
> (1) Organize development: (do we need 3 different implementation
>      of mmap() support ? ;) )
> (2) Discuss current progress and challenges
> (3) Cover future ideas and directions
> (4) Whatever else makes sense
>
> Topic-wise it's relatively clear: guest_memfd extensions were one of the 
> hot topics at LPC ;)
>
> I would suggest every second Thursdays from 9:00 - 10:00am PDT (GMT-7), 
> starting Thursday next week (2024-10-17).
>
> We would be using Google Meet.
>
>
> Thoughts?

We've been taking recordings of these meetings with attendees'
permission and the recordings are kind of stuck in a Google drive
now.

People interested in watching the recordings need to request access to
the meetings.

I would like to make these recordings more public and lower
administrative overheads of requesting/giving access by hosting the
videos somewhere.

Does anyone have any suggestions/preferences on a video hosting service?

Otherwise I'll default to using YouTube since that's also where LPC and
LSF/MM videos are hosted.

