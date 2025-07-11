Return-Path: <kvm+bounces-52199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB2F7B025AA
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 22:17:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD0F7564306
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 20:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05E701E835C;
	Fri, 11 Jul 2025 20:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eX1oU5U0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5484FBE4E
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 20:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752265027; cv=none; b=AMonC/oIDBKbEvfpQSBFRiw1StSiCKRwt7xat0hn/88jKymWYTLyKm9ow1PmgDOI2ovo4EjmoSBkvN9P9OXQh3wVRR9wDe9i1qXaUsPtvGKxcQ00pWCwbQZ9Rczwar4ck0VMNGGcTwFIFUVNq7ZryDcHaOEe17oaIUhpp6E6bsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752265027; c=relaxed/simple;
	bh=uhUoM6ywAnEWri45ypcJyb+pdXMCodbhW75C4R8j7mM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WO6R7tq4HKWpO2Dvw9DH+0lFC00PVwSUFpoAInA0w0vu1cT1FAojx5kIqo+cNhxV0uiqUtLOsb2PHblQ3LqZMyvaqmUwsm6DH8S1eLdhaZPTVgPMlbL8/k+is7uY7cSecvBz7HLHp/M+a53/RTwmDRjMEPRzBkQBlJVX/K/3//w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eX1oU5U0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752265024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O48GD7FwFjWqdhwSKV4bAY38Fn++pRls3eK+lDFL5nc=;
	b=eX1oU5U0hB/SBeT+GIl+vS/98QMBCIQM19cHvEacu7Kw67n89619OG4Mw2OlmM9WUQIdsf
	+sNDxVEKihGrHNs7S3nXkxAhW3A6GCkLtyjSHkrnrhLhHUYoVLYtyyjabDoNVQd5i6DeQS
	Y2VbXyB+G+6V2nc8fu/ZBqn4Ghs8Pcs=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-T6Vl4JlNOw-5V6EAXsYSFQ-1; Fri, 11 Jul 2025 16:17:02 -0400
X-MC-Unique: T6Vl4JlNOw-5V6EAXsYSFQ-1
X-Mimecast-MFC-AGG-ID: T6Vl4JlNOw-5V6EAXsYSFQ_1752265022
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-86cfa305eb6so9778139f.0
        for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 13:17:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752265022; x=1752869822;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O48GD7FwFjWqdhwSKV4bAY38Fn++pRls3eK+lDFL5nc=;
        b=qFvxQ5vc59RYjaw8W+F7NdIr4FbpeZKgU7wXKlYZB7jPkQrtLegB9n+fd4c/K4YVfI
         HU8jBAYOO3jlQIZOAXYN+V+L4xtrLdmND0fgwfKe4prkw/Q6P82UJtBO/LYXWeDONB16
         Ll8s3SnIsvANWrGzGBsmQGtXbl5yrPfVYBEuD3iWxQd0zHiDiZfJxDN9ympvFUPO7TsO
         43x8E+uLV8WCjcE3hiR1yKkB61dXfTrCHn4fsOPloH1yJdTn/dEMvP9L8IWSVr/SeSAz
         35lLXOo9hOCrEILdGj8Tylbc12Yu7cXmuHLYrhGIifc/X4igvZOcF92UrmvSEmMuPO+j
         nzog==
X-Forwarded-Encrypted: i=1; AJvYcCWkC1s7wSpUBCa5kP1u5Og74RxPebynBn6RBim8BWSeYJUPiRZuOEZfYu+Jk3u7POSoBCI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBdtlCvvIlEqkk8NJNECMkympe2eLyM3HS3NzCj17+shMVChf0
	ToAsY1uJw3uPEya0uySZLWAtLPnN8mT+OtiLEMm+kTAB/1j5LsCEBfYL9aXTvujYupL7H3i1HsU
	XYgT90MQLYXMSRxxPWRS8LKhfQCHUFpEVeJ9ti/uelc+8m0K1gLhpQg==
X-Gm-Gg: ASbGnctsYJg3WNdw8TNF9qhFkmsJgcqkp9kVE7xC9m6ZEiARnai9e9H3gEl/GVU98T1
	HbEiGXT2WoldPNEUmaCrQZL9vasVclXicdAaznThBVk5egteT1oi1CroYbJQwySaOvSHuCxRN8P
	sJcBKGuAzw2RLItU5O7irXyle77RxGrRP62SvQr24g69EMjyFbKDic1yfMDXswQcHZlCaqMsFsa
	uMlyHKv6wnnxFy3p/wfORbHD4YOjbwVuk4EroO84mL4ysiZQ8YTnIQyuqvZ8LhUOETrSMK56diP
	BbwsGxdLGpBuSTS022SDHpP5fB7aD/t+xzmSfJdzTq8=
X-Received: by 2002:a05:6e02:1a0c:b0:3dd:b51b:b704 with SMTP id e9e14a558f8ab-3e2543bc75cmr14400345ab.4.1752265021516;
        Fri, 11 Jul 2025 13:17:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjFOEEUyyAOBjTz6ILmAsXw1t5UMkvZPPRgLgQwYpeSBL00JPpZLe4wiwpuwYxDRVNC4E9ag==
X-Received: by 2002:a05:6e02:1a0c:b0:3dd:b51b:b704 with SMTP id e9e14a558f8ab-3e2543bc75cmr14400245ab.4.1752265020939;
        Fri, 11 Jul 2025 13:17:00 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e2461344besm14274485ab.20.2025.07.11.13.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jul 2025 13:17:00 -0700 (PDT)
Date: Fri, 11 Jul 2025 14:16:57 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/type1: conditional rescheduling while pinning
Message-ID: <20250711141657.16dd6a20.alex.williamson@redhat.com>
In-Reply-To: <aG7OspdCPAK2oILR@kbusch-mbp>
References: <20250312225255.617869-1-kbusch@meta.com>
	<20250317154417.7503c094.alex.williamson@redhat.com>
	<Z9iilzUTwLKzcVfK@kbusch-mbp.dhcp.thefacebook.com>
	<20250317165347.269621e5.alex.williamson@redhat.com>
	<Z9rm-Y-B2et9uvKc@kbusch-mbp>
	<20250319121704.7744c73e.alex.williamson@redhat.com>
	<aG7OspdCPAK2oILR@kbusch-mbp>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 9 Jul 2025 14:18:58 -0600
Keith Busch <kbusch@kernel.org> wrote:

> On Wed, Mar 19, 2025 at 12:17:04PM -0600, Alex Williamson wrote:
> > On Wed, 19 Mar 2025 09:47:05 -0600  
> > > > 
> > > > Note that we already have a cond_resched() in vfio_iommu_map(), which
> > > > we'll hit any time we get a break in a contiguous mapping.  We may hit
> > > > that regularly enough that it's not an issue for RAM mapping, but I've
> > > > certainly seen soft lockups when we have many GiB of contiguous pfnmaps
> > > > prior to the series above.  Thanks,    
> > > 
> > > So far adding the additional patches has not changed anything. We've
> > > ensured we are using an address and length aligned to 2MB, but it sure
> > > looks like vfio's fault handler is only getting order-0 faults. I'm not
> > > finding anything immediately obvious about what we can change to get the
> > > desired higher order behvaior, though. Any other hints or information I
> > > could provide?  
> > 
> > Since you mention folding in the changes, are you working on an upstream
> > kernel or a downstream backport?  Huge pfnmap support was added in
> > v6.12 via [1].  Without that you'd never see better than a order-a
> > fault.  I hope that's it because with all the kernel pieces in place it
> > should "Just work".  Thanks,  
> 
> I think I'm back to needing a cond_resched(). I'm finding too many user
> space programs, including qemu, for various reasons do not utilize
> hugepage faults, and we're ultimately locking up a cpu for long enough
> to cause other nasty side effects, like OOM due to blocked rcu free
> callbacks. As preferable as it is to get everything aligned to use the
> faster faults, I don't think the kernel should depend on that to prevent
> prolonged cpu lockups. What do you think?

I'm not opposed to adding a cond_resched, but I'll also note that Peter
Xu has been working on a series that tries to get the right mapping
alignment automatically.  It's still a WIP, but it'd be good to know if
that resolves the remaining userspace issues you've seen or we're still
susceptible to apps that aren't even trying to use THP:

https://lore.kernel.org/all/20250613134111.469884-1-peterx@redhat.com/

Thanks,
Alex


