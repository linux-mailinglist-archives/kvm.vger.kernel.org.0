Return-Path: <kvm+bounces-22969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B84B945189
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 19:33:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 31CB41F232CB
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 17:33:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69E521B4C39;
	Thu,  1 Aug 2024 17:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PkRBH051"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C8313D62B
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 17:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722533631; cv=none; b=aTnyx4z67Wtrd0G+9lB0CiWPK4bw/UHgXv/yHTLE3TLPwyTPKkQQWpl7aQvAUHgfZ4aNLa7EZsprGG2IppNueR13gdFbtgyXho8++fcEs4xvtNfd71rr2hUwtConPIIsTKgYLpHRaegcZPfVSOxiFsBCzack8wuK538QC/P4jR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722533631; c=relaxed/simple;
	bh=U2npBzXlRSVrs0cPhd01r3GAJVreXC/fpzD7MBT8kiA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jtvhznVw9A5L0oxqr72fncnSNiuGO55q8HRwbWg0d6s1l7Oe9KUNXcPZVOoNZrB2651wTyToqt1vdrnWSPyG2mNY2ORr55oGBp8JhqHtBR6RC0I8DNhWu4zyfPGl9dIbZh3YjlF3xQmzC8ndftXvhbbgpB4FUly8hrZnn8BJB7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PkRBH051; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722533628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Tez0j9zghp/f/0VS8Hdp8DQXpHNy6plMc/Q7qIBFpVA=;
	b=PkRBH051yX9ASvNrCce2wpgJjn5OwdVUjLjgV4zfNpchCiKWzVd6cdUAotr8zGHrVo1+DM
	hqN6ljlbhP6WrxcVX4yNGAUCzrup2izltYp3PmF1OpaJ+/ythMqs5njMkE4yimcG1mEt1W
	vxr62OUb33XldYhSrenGRFLwMxmP2Xg=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-3j5HpzTlOSqWvVlbt8yHiA-1; Thu, 01 Aug 2024 13:33:47 -0400
X-MC-Unique: 3j5HpzTlOSqWvVlbt8yHiA-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-81f9612b44fso991252839f.2
        for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 10:33:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722533627; x=1723138427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tez0j9zghp/f/0VS8Hdp8DQXpHNy6plMc/Q7qIBFpVA=;
        b=qwFQILrvkbs177oQW37DomQf623lIHPsMq2tsSHnswy6My69GVXTCrXp3s67meBxx8
         pEpBgHzzbdlphKH3gh5WQ1/9/NyjmBfAGyHHmhD1T7QGl7GiP2H62/eB+ht5CIB6fl4H
         Lay+MIv2gK05sKn6BFURbrQ9z9rsoDDnNP08zmXUbcM8Doo3iN1aSPdMAcWw+/nZHdi5
         /MiOqhUPomrwb/XDsyUZyzC2kcT7cPvYViTPWvVANp399xXO8qgh4wZo2C0xdr6jdeq3
         gENQoIriCUgui2YuHBAgOnEqsdhgWWJcOH/o0BOiBgaSG7TIBkko+7Jg8x4qCILD7a4p
         MD4w==
X-Forwarded-Encrypted: i=1; AJvYcCX8fM+cxuPRb/SMHrbyvlPDWqZ7LF6K4Z7VYtNy+V26aMR7H9rOTG7c+AUNBTO5FvglccWyunBLgiLNX2BE5n05mSlB
X-Gm-Message-State: AOJu0YzqiFYQqRwVaaPGW4uMFiLdzRKhBmTU1DxeH4E7+3YtwW7GvC+X
	wlivv3+Qo4FQKhnYCGzGYCHQdAdBBH1Lf+Zh8aNMlPIylJZG0tnR+HnxzTeSKuaOOiWZulIstuG
	n63k9zSW2YuoAwqevnS0FsIqBprW17t3rTkFpup/8dSJXk8auDw==
X-Received: by 2002:a05:6602:2ccb:b0:81f:cb09:2815 with SMTP id ca18e2360f4ac-81fd4348a65mr145386939f.4.1722533626876;
        Thu, 01 Aug 2024 10:33:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1tBZXB5uPxsl+TjUbx5Y8d5hyg1nIl1avS8ovdExA4JQahS2mMHhtVp+JsGRbADekA0wOTQ==
X-Received: by 2002:a05:6602:2ccb:b0:81f:cb09:2815 with SMTP id ca18e2360f4ac-81fd4348a65mr145383439f.4.1722533626417;
        Thu, 01 Aug 2024 10:33:46 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-81fd4d1b7acsm7519939f.9.2024.08.01.10.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 10:33:45 -0700 (PDT)
Date: Thu, 1 Aug 2024 11:33:44 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org, Keith Busch
 <kbusch@kernel.org>
Subject: Re: [PATCH rfc] vfio-pci: Allow write combining
Message-ID: <20240801113344.1d5b5bfe.alex.williamson@redhat.com>
In-Reply-To: <20240801171355.GA4830@ziepe.ca>
References: <20240731155352.3973857-1-kbusch@meta.com>
	<20240801141914.GC3030761@ziepe.ca>
	<20240801094123.4eda2e91.alex.williamson@redhat.com>
	<20240801161130.GD3030761@ziepe.ca>
	<20240801105218.7c297f9a.alex.williamson@redhat.com>
	<20240801171355.GA4830@ziepe.ca>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 1 Aug 2024 14:13:55 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Thu, Aug 01, 2024 at 10:52:18AM -0600, Alex Williamson wrote:
> > > > vfio_region_info.flags in not currently tested for input therefore this
> > > > proposal could lead to unexpected behavior for a caller that doesn't
> > > > currently zero this field.  It's intended as an output-only field.    
> > > 
> > > Perhaps a REGION_INFO2 then?
> > > 
> > > I still think per-request is better than a global flag  
> > 
> > I don't understand why we'd need a REGION_INFO2, we already have
> > support for defining new regions.  
> 
> It is not a new region, it is a modified mmap behavior for an existing
> region.

If we're returning a different offset into the vfio device file from
which to get a WC mapping, what's the difference?  A vfio "region" is
describing a region or range of the vfio device file descriptor.
Region indexes that map into the same device resource are not
fundamentally incompatible AFAICT, but it does mean that zapping user
access is not a nice contiguous single range.
 
> > We'd populate these new regions only for BARs that support prefetch and
> > mmap   
> 
> That's not the point, prefetch has nothing to do with write combining.

I was following the original proposal in this thread that added a
prefetch flag to REGION_INFO and allowed enabling WC only for
IORESOURCE_PREFETCH.

> Every BAR can be mapped writecombining, it is up to the VFIO userspace
> to understand if it can use it or not. The only use case for this
> feature would be something like in DPDK.
> 
> VM side write combining is already handled by KVM allowing the VM to
> upgrade the page attributes to WC from NC.
> 
> Doubling all the region indexes just for WC does not seem like a good
> idea to me...

Is the difference you see that in the REQ_WC proposal the user is
effectively asking vfio to pop a WC region into existence vs here
they're pre-populated?  At the limit they're the same.  We could use a
DEVICE_FEATURE to ask vfio to selectively populate WC regions after
which the user could re-enumerate additional regions, or in fact to
switch on WC for a given region if we want to go that route.  Thanks,

Alex


