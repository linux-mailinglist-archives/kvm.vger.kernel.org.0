Return-Path: <kvm+bounces-23542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D89594A9EF
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 16:19:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FAA328757D
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 14:19:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 418435811A;
	Wed,  7 Aug 2024 14:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="J0wRgAYm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655D45F873
	for <kvm@vger.kernel.org>; Wed,  7 Aug 2024 14:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723040354; cv=none; b=BDVjm/Tu2ebQYzweWtm7UyAqIMhnIbfNbh44dJkF8Ija97AMqbkDa/z2BBCJ2bt0IoaTXs2znjSd2gga5Id8pZhdsMOfZjxb4EZX1TWbLMtejWsXMsq2LBS+NmY9OLc2Xjb2GFoqHprb70xxFrkY50Aw0zxAfzUbRU4h/pf5A7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723040354; c=relaxed/simple;
	bh=peFwmbLDqzimMwsMbwLnHboPj9QdzlHHu3xtEh/74bQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t/LmfXWTIQo+evDP06OjGAK3e2jxdC0bFCKYUZ9xJTOPziQ4dxHhLnD0XnghQ+2DOUhkpHgsa+rboxU/Brw8+CCWH1+LT1cE6HgHcLNcgs74rqIfs3rlVw0R1vdhq0K87bbw+Yzmw9TYLrRvL8VeO45Gh8bF96fUi+IpwHVj7AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=J0wRgAYm; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6b797a2384cso9640756d6.0
        for <kvm@vger.kernel.org>; Wed, 07 Aug 2024 07:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1723040351; x=1723645151; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fc+eIBdmBWYGGAFauD33Z4DSyOmQ4sMLZI/hex83pEU=;
        b=J0wRgAYm9pJzziAhuPtmYuEMxLPfV5OW7uV1bEMCzlr8ePkY7zSJVkAmI3S5eavy/V
         mued0L+4nuD8Vi0UZXCgbfyBPDehsvrv9JC35Pm9TJ7oYKLsxIhuDWzgUFccBQAP+irR
         IY5o7R2olXzMAIM17KeBoCg1v5soSQ6MN4Xd0jSJCUwUewYaSS2dtzZTmxY6qTuLGvFq
         bpx/jdgXdO7vKcx9FAMDQvjPRiZbg9dzSBAl3G8l+CO5Xbj09imW4KhkFJ60OsIQq6Dw
         GETLjtNEqwvieGSHfC2pl/6B1FERyirGquemqSzstVeBf5CqdvHhs108bkH0U7DE2qp5
         i5Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723040351; x=1723645151;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fc+eIBdmBWYGGAFauD33Z4DSyOmQ4sMLZI/hex83pEU=;
        b=HxBc9KpghKwQ2q2ml0xk7enwnvC5geu0QTHJqTSNK0ZsP5UWGypcia8RR8/zvg+GAA
         e8/G4hFOzr1nB3tcNrN0ncHqIOwaFxbyngR3FG9z6rokbbYRvMY3GMbO8M4uzgKDSf0H
         F5BPF4cYxti8LB7Egjl4L6iEpXvqF9LLAqfzpAS/Gcv3XQmlTxtDXNn85s95IFZGeeLl
         SJH3U2DG2AI+5Uh94cPlO7ym0hCrtAzIE2xEviTWM/OPOrA8o6gvXLv/n9DfXNF5Ql/Z
         Naj1XXM9CibfE0u4eQl9UyKb8I0ccShJ8Y1LI/mtBPcpL6QzV7ReAatOPy8DeaRvvAx5
         WFCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWL/ukCVZ3DeW+1gNO8XLbmAXR7G9lnHEQd3v57jgrfib7m6b2aRkxETq8SxWCzkz++etCTANQ3nSA0XvtrHxfXj+/e
X-Gm-Message-State: AOJu0YyY9gRg7DL+VA2ay9uWuMSbpnVEeH9noYdWbOIKDgNXZlrDxHQu
	e9dElWb4KGYuT+fhrre0HUYvk/i6nB4VeGRKZThHTCnpBN5tbC0arWgw517LZR8=
X-Google-Smtp-Source: AGHT+IG/a6WJsIFp3OiJbuidiihLgUhE96YpBIcBVwBElb+FQlz4EtBYwB8OsdscWbVOsU/78uk1uQ==
X-Received: by 2002:a05:6214:c4d:b0:6bb:9b66:f262 with SMTP id 6a1803df08f44-6bb9b66f6f1mr241534946d6.41.1723040351106;
        Wed, 07 Aug 2024 07:19:11 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bb9c79af64sm57928126d6.37.2024.08.07.07.19.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 07:19:10 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sbhVO-002HOu-0i;
	Wed, 07 Aug 2024 11:19:10 -0300
Date: Wed, 7 Aug 2024 11:19:10 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH rfc] vfio-pci: Allow write combining
Message-ID: <20240807141910.GG8473@ziepe.ca>
References: <20240801161130.GD3030761@ziepe.ca>
 <20240801105218.7c297f9a.alex.williamson@redhat.com>
 <20240801171355.GA4830@ziepe.ca>
 <20240801113344.1d5b5bfe.alex.williamson@redhat.com>
 <20240801175339.GB4830@ziepe.ca>
 <20240801121657.20f0fdb4.alex.williamson@redhat.com>
 <20240802115308.GA676757@ziepe.ca>
 <20240802110506.23815394.alex.williamson@redhat.com>
 <20240806165312.GI676757@ziepe.ca>
 <20240806124302.21e46cee.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806124302.21e46cee.alex.williamson@redhat.com>

On Tue, Aug 06, 2024 at 12:43:02PM -0600, Alex Williamson wrote:

> > So we don't leak this too much into the drivers? Why should all the
> > VFIO drivers have to be changed to alter how their region indexes work
> > just to add a single flag??

> I don't know how you're coming to this conclusion.

Ideally we'd want to support the WC option basically everywhere.

> > I fear we might need to do this as there may not be room in the pgoff
> > space (at least for 32 bit) to duplicate everything....

> We'll root out userspace drivers that hard code region offsets in doing
> this, but otherwise it shouldn't be an issue.

The issue is running out of pgoff bits on 32 bit. Maybe this isn't an
issue for VFIO, but it was for RDMA. We needed tight optimal on-demand
packing of actual requested mmaps. Allocating gigabytes of address
space for possible mmaps ran out of pgoff bits. :\

> How does an "mmap cookie" not duplicate that a device range is
> accessible through multiple offsets of the vfio device file?

pgoff duplcation is not really an issue, from an API perspective the
driver would call a helper to convert the pgoff into a region index
and mmap flags. It wouldn't matter to any driver how many duplicates
there are.

> Well first, we're not talking about a fixed number of additional
> regions, we're talking about defining region identifiers for each BAR
> with a WC mapping attribute, but at worst we'd only populate
> implemented MMIO BARs.  But then we've also mentioned that a device
> feature could be used to allow a userspace driver to selectively bring
> these regions into existence.  In an case, an mmap cookie also consumes
> address space from the vfio device file, so I'm still failing to see
> how calling them a region vs just an mmap cookie makes a substantive
> difference.

You'd only allocate the mmap cookie when userspace requests it.

My original suggestion was to send a flag to REGION_INFO to
specifically ask for the different behavior, that (and only that)
would return new mmap cookies.

The alternative version of this might be to have a single
'GET_REGION_MMAP' that gives a new mmap cookie for a singular
specified region index. Userspace would call REGION_INFO to learn the
memory regions and then it could call GET_REGION_MMAP(REQ_WC) and will
get back a single dynamic mmap cookie that links the WC flags.

No system call, no cookie allocation. Existing apps don't start seeing
more regions from REGION_INFO. Drivers keep region indexes 1:1 with HW
objects. The uAPI has room to add more mmap flags.

Jason

