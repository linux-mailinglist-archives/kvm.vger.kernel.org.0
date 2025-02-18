Return-Path: <kvm+bounces-38506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 056A9A3ABFA
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 23:46:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AAFDA18962B1
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 22:46:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FE871DBB37;
	Tue, 18 Feb 2025 22:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ANuAXFyd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D50199EB2
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 22:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739918781; cv=none; b=oVZAWcYRF+hnGObRSPWzb/Xbi+YUPUwMmQw9/Ljroq4/IZ042N+Gdafq5MdzSgRUlmrhKE6cwEPBV+rP/bNKk8VXg6OuVQLi869v8KPuQLGCXnJfpWNmswGda8TVuJG0SyYmXsBwFo4V7SBmAnA4lkEQhmvOltxN65k3YKiaVeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739918781; c=relaxed/simple;
	bh=y1fqN5GbYRykCGi1zwcfHTkU/ZfRpFRIPo+3x+cnynk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RUKiJFlWgccRkKjMg4Cn2D+7QIWc9bipq2N6ZEcQlgrEJi/g1tbMLbUkXX9AkVvHqtsYT11OIGtRxH7EVif6DBkdfiQTttvx14i4n1H7KpaRruyI3orKOL1qLCnyxQG8X/Tx6dD+ZOu5jXRnZLOxge6aLLIPChrzYlBYggqzfig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ANuAXFyd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739918778;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iZQ+x7hOq3PQQbEiSyLtN+TOyYxHPYGDMm2XpmalGJM=;
	b=ANuAXFyd3/6QpsTWGPykMR75iEIiGETyr45ufSYA0gSgARz6kZASAhvXg7AIuiGYFwDprS
	GoHPDr+T1+R9KVjuoKdpY0LMb5RWu+tFHgXjxAWvemicvncofiQtirVoYra4jCiWlZKF/d
	n1iddgPDoN+9pCj7YyQnOIGb2rQXrkE=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-EWC6LeDcO4exv3TL0w4n-w-1; Tue, 18 Feb 2025 17:46:14 -0500
X-MC-Unique: EWC6LeDcO4exv3TL0w4n-w-1
X-Mimecast-MFC-AGG-ID: EWC6LeDcO4exv3TL0w4n-w_1739918774
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7c07668e74bso1397900485a.1
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 14:46:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739918774; x=1740523574;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iZQ+x7hOq3PQQbEiSyLtN+TOyYxHPYGDMm2XpmalGJM=;
        b=tU6dDaW3kw/5tywEgC8XjST55+cmg2SlI3wtxppDbgSq5SA/8QW6mB8HrsIGt31uh5
         yM9wJzl06GD+/qteAKtC9ZN+CtA2z+44qsgftGS8MBiIiuUnAKP+58NE34nFG42pvMUE
         BxRIobvYCKfCZj5oQVO7WWBRJgW4x9JiqraZYujSz47C9ZcQZUO2e5vXk00Fo84ZVQf0
         WpglmNehA5uNffDJ58O4xbO87O1+CjQUJ2zxsE9YdQ6jLRMj1RrJsSyjA1tM75AOlOrZ
         Ch6RE1slhvvKNEDxOmumzwu4XR3yu0NGzGW69rY4t82JBAkN8Np4CGAbiuhz4lNNYAFo
         yNCg==
X-Gm-Message-State: AOJu0Yx7lLypOuQvuuxwUcY7zKQL5bqbtu6XM1ZTOxIcmu0JTZyfZiJk
	P6BgAcG3w1d2UC6psriN1FfZlOGvj6wczpWlHj2E5pY0H4UpKtfkqs32WVGjlsmBh+RROwEK8/9
	O6tgiY80udG+cuDyEUDbayWrV0BiiIyczCkpthFwK1GAVBjjuAQ==
X-Gm-Gg: ASbGnctZGHnPKLUNSAk9pn5uxphXoUm0+EHu4DWCi224BP/fR6Sb/yfQuMPDxcdgP8M
	xHpFJrgKGFdCYTv5gT5vosirndF19iHKn7nE+T+m4luBSosqgl/njK+NIeQBjcB8AVxPpnKQh/w
	VvZOUOzgESzgAaJ3z3Qbkz2H+gkIlwJITByaBcsRdJAEw4fJTEakKCcXxXkJDqGykKFNixkIMG7
	BKKBLMqfnWhtj7Bb3Gbdn5twpadSe6u2zxuz+IUCvFqNCdwE3e7jBMPR/8=
X-Received: by 2002:a05:620a:2989:b0:7c0:5fff:210a with SMTP id af79cd13be357-7c08a9aaa8dmr2285348985a.23.1739918774556;
        Tue, 18 Feb 2025 14:46:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF9aYa7xb0jSy10KYfjbvxeGabOuqZLuvs7LaEOm/AXuBMyqdCDraAKcVyHKcDCqvuv8zIW6g==
X-Received: by 2002:a05:620a:2989:b0:7c0:5fff:210a with SMTP id af79cd13be357-7c08a9aaa8dmr2285346185a.23.1739918774251;
        Tue, 18 Feb 2025 14:46:14 -0800 (PST)
Received: from x1.local ([2604:7a40:2041:2b00::1000])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e660f65c5csm62704546d6.117.2025.02.18.14.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 14:46:13 -0800 (PST)
Date: Tue, 18 Feb 2025 17:46:10 -0500
From: Peter Xu <peterx@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	mitchell.augustin@canonical.com, clg@redhat.com, jgg@nvidia.com
Subject: Re: [PATCH v2 4/6] vfio/type1: Use consistent types for page counts
Message-ID: <Z7UNsiRfdOWfZWuq@x1.local>
References: <20250218222209.1382449-1-alex.williamson@redhat.com>
 <20250218222209.1382449-5-alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250218222209.1382449-5-alex.williamson@redhat.com>

On Tue, Feb 18, 2025 at 03:22:04PM -0700, Alex Williamson wrote:
> Page count should more consistently be an unsigned long when passed as
> an argument while functions returning a number of pages should use a
> signed long to allow for -errno.
> 
> vaddr_get_pfns() can therefore be upgraded to return long, though in
> practice it's currently limited by the batch capacity.  In fact, the
> batch indexes are noted to never hold negative values, so while it
> doesn't make sense to bloat the structure with unsigned longs in this
> case, it does make sense to specify these as unsigned.
> 
> No change in behavior expected.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


