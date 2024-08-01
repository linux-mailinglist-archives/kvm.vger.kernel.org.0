Return-Path: <kvm+bounces-22968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D2FBE945157
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 19:14:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F970288AB1
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 17:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC70C1B4C45;
	Thu,  1 Aug 2024 17:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="U9xYYX9l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A5E13BC0C
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 17:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722532440; cv=none; b=E4z5uQ/uPxTwgYU+w9jbyXI4CCjGdzMDbo1wUPf3doB4gPokxIPjUCvU3LAHxmS0hUBjOOBUy4LuY0wZ/NtuxUZrm8EwC3KDCEtqb3xV73IYltKrM5mCIRB+eQEdv2+K9nzxq8ZpT3HRnS510vOuFDVyj7Y5KtBXQWAr9vGsegg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722532440; c=relaxed/simple;
	bh=Z9NiANsiT8uepznlxPs9TFqxFKoFMxV4W8rzjhGeB2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mCgnA4yoHG9hIXiaWhSCRnumvpZcL6G+nB5kvQiquY/a2ZHU24bYvMAuFtERlyv5AxrruCmfpjqunIwRBDhwPRe43H34eVbW1xT3ANN3lUu1bdi0M+PGKStOy11IDfBYxTtiabOn2x5DxXIniwEDIewifagOLQmf8x2Mh3tJ8Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=U9xYYX9l; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-45007373217so21129351cf.0
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 10:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1722532437; x=1723137237; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zW69CQDyoTBBfhvUaQTFTQPGEdlxv3AUnc728KFnPfA=;
        b=U9xYYX9lbYDsP/wZG6Z92yfy7h1/oGKVpEkEjHcrcgxKr5kFVAiWcIh3mNVxmuzJCE
         2sK2S3u5OYRhRxpdI68dsvBbWPSH3iIw0i/MvvcK5kGtwVIs38Kt0AFzqwHZzIJ2Wvgo
         T3GM2BszPRNzBa2Gc1l3kbE1ZoFIAo62aMqSemNiJ0IQd/EQiVsKOPkBqDJ0cfz/vCnd
         QkP8AF4CnWfKwnuYgkwYFnVYf4uX4u73v2puo2eu7i50TTDMeHWQbLEtSC5qWlqUSg4o
         lufjWlkmvlvsEznbarN25zVbsV2dZBnl6JEfcpPDbhHSQUw6K5f57AKzhVgpSAp2ASE6
         Wuqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722532437; x=1723137237;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zW69CQDyoTBBfhvUaQTFTQPGEdlxv3AUnc728KFnPfA=;
        b=rI+SeX/6he6rXjHM6TI0mPpGHNBKXiE6Oag575FUtNPVkEKeWl7kpzs5M/PfFQeTMV
         uPAyxRo4LBO5VH2ILixp4087XNBcduT39Fum9NszQ7Ys8b13d5skk1lUB0v3t58+uSuw
         6SvLHjUIaiIOCIzzhIGiZ00sshPGyIRrOSrfHCx+eit7XIVyf54P7fBulNaf8UNZipwv
         IdY9vJfaorpXGJyaiQBGzhir9Cb4LAn4o6wiSXqjwEpEUbyHyv+rXYcmPH5L9GXiqq8X
         8ktpQZkEGXTziDmvivU+UnC7Nzpioa+BLbIEaRG+w3SMu1AJReny1AeqfdJKK58ezjqT
         8Qsw==
X-Forwarded-Encrypted: i=1; AJvYcCXRlyaNytjIVbvVlp4T+h41LZpydvCLYYypCoq2SLTnXsGA60sUGTrrVpTEORvP5mQhlFGagWtbofwZg6BI6DFd4/pI
X-Gm-Message-State: AOJu0YwJDiGYtIzaAQVJiTZVicKsQOxDp+txji1lNjNA2D0rWtdyQ/UO
	hO0YALCUuG3Nq403tUMOjH5MrCyajNUDVHDW00fToOQlqXPhogS/OcybilMrtk4=
X-Google-Smtp-Source: AGHT+IFo8s4D2wC/SsBAOYzhTWDu6/g698CPYVxAus59MdAZXS/a24QmLz7Gs2lGSHnFzhYaNc7H3A==
X-Received: by 2002:a05:620a:4086:b0:7a1:e39e:c8ee with SMTP id af79cd13be357-7a34c0c1af4mr335074785a.34.1722532436932;
        Thu, 01 Aug 2024 10:13:56 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a34f796d10sm7357685a.134.2024.08.01.10.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 10:13:56 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sZZND-0001H4-Ly;
	Thu, 01 Aug 2024 14:13:55 -0300
Date: Thu, 1 Aug 2024 14:13:55 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH rfc] vfio-pci: Allow write combining
Message-ID: <20240801171355.GA4830@ziepe.ca>
References: <20240731155352.3973857-1-kbusch@meta.com>
 <20240801141914.GC3030761@ziepe.ca>
 <20240801094123.4eda2e91.alex.williamson@redhat.com>
 <20240801161130.GD3030761@ziepe.ca>
 <20240801105218.7c297f9a.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240801105218.7c297f9a.alex.williamson@redhat.com>

On Thu, Aug 01, 2024 at 10:52:18AM -0600, Alex Williamson wrote:
> > > vfio_region_info.flags in not currently tested for input therefore this
> > > proposal could lead to unexpected behavior for a caller that doesn't
> > > currently zero this field.  It's intended as an output-only field.  
> > 
> > Perhaps a REGION_INFO2 then?
> > 
> > I still think per-request is better than a global flag
> 
> I don't understand why we'd need a REGION_INFO2, we already have
> support for defining new regions.

It is not a new region, it is a modified mmap behavior for an existing
region.

> We'd populate these new regions only for BARs that support prefetch and
> mmap 

That's not the point, prefetch has nothing to do with write combining.

Every BAR can be mapped writecombining, it is up to the VFIO userspace
to understand if it can use it or not. The only use case for this
feature would be something like in DPDK.

VM side write combining is already handled by KVM allowing the VM to
upgrade the page attributes to WC from NC.

Doubling all the region indexes just for WC does not seem like a good
idea to me...

Jason

