Return-Path: <kvm+bounces-41513-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CA89EA697D7
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 19:17:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 10AAF188AFF2
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 18:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0078620899C;
	Wed, 19 Mar 2025 18:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SZyv/HCp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34730208970
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 18:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742408234; cv=none; b=plVelxy0imMfLOsyAhiCiS7zg9SOn0HVz6JvxwC5b1oe28owJsN4jUV1SoNLRcguHqOGMqgHZZcFw8o8X+w3AMWwiQbjHwEHiAKkaH1LcVQb6/sNEvw1ewH61HGEYhzM43Pvci4j0jzlvr4BmlvHcT4UnVsupj1oINAQBY/sXv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742408234; c=relaxed/simple;
	bh=a9f/6tpQ5Nfjmt6Y9fBtdPMfU8jJKk5Ka2jWsqH446s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n4a6IuJeo8QXbL3Pd+JzA0PJuylS8MMQK3/7JrNlmIYYZIu2QuZFY0Hhizl7N2pCOVaniL9byOAqcybOg30VUOioVPSxhYOUpCuyIJ76szc8XeL3bKx3uWwUR0P9XqMktdkWDElZb0GhSxFby2Au6ovGu5IJP1EYpmCf6w+kKMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SZyv/HCp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742408231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JFUr0M69ODhF7brZUSPn837tWR3hKo9DP9FR/CuzQWU=;
	b=SZyv/HCpSqddEeSiu50M9EnxyDFrrWcCSB4dYBYmQHb71o3L0S4j5iOndTSfoxSYGiJc5u
	xZQsHS0D/20D9vF9rA99nWZ5lnCFvaVeNP6J8RoJ5FvkJfHbtUXm5Ic30GSr76EiZ2Ce0N
	fCE4yFWHWVaeRFCiY+LgsdpbPbF5Pqg=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-2K3E8Jl_PAaq34QrrrWLow-1; Wed, 19 Mar 2025 14:17:09 -0400
X-MC-Unique: 2K3E8Jl_PAaq34QrrrWLow-1
X-Mimecast-MFC-AGG-ID: 2K3E8Jl_PAaq34QrrrWLow_1742408229
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-849e7868f6eso72672239f.0
        for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 11:17:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742408228; x=1743013028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JFUr0M69ODhF7brZUSPn837tWR3hKo9DP9FR/CuzQWU=;
        b=fI4xt170DflWCMt/p0ku/hBIb9mlcD1U7kuzXE0zkEfXsbEzPxXgGKH7ueY+GHoETN
         a3YoEcistvKI00F+cdVsMsZVIrGzOlzNMxL7VKU+v0N6TIN5hA1f7RB/H2JbgmofrGFg
         xP2ChQQEm8JxAnTeuSf1YqfB+B+m71aEjdoNmaevuGEONUYE6HQjkvZg6QBavhtmtgkT
         y9u7hHIYukMZGGAUqyhC3HfcmVyQT5aiSubAzn6ZubsZ6xYEmwrmyrr4NZXBwWkhZ503
         Dq4jjXJmwcHMQi2AFZs9i2AUNZ1yDdgk9fBMtMAROL8KcH9Efojgd4AnQeCReCQACS2+
         oBwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBa/+/u+HVQJPqXHwnis+lxRJTU8IYoNMPa5MJ3xFzApBRLEzqQfM++oLNFWeip0TK4SQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YznqExD6ASA4Pb7ZnJKhN074vG7+8DckZBiEcq9B2YCSQk0C9C7
	s6hfQ7saiNQ8VIIrhsJHORcmZtrB0oQQ2tqc5A0cMXPpTMVaWwKxWI2S09xJEnoWx7LmdASwmIW
	6gnTNgCqYU/j1/PgWTAfWu/EEKosdPzO2EFVAXn+UpQ91l/Y+Mak/Nceq9Q==
X-Gm-Gg: ASbGnctKypel/1ET/JhOKLBDOwUdM0gJZv/uDVFOI+2o3ikGGvm5rEiASLjNFNgmsPt
	a7NKSUuLgXWLhjvu/wAhdug9YFT0h1Acuh4qxw1xigr95xAcAYXHFaDMSBjy3tUfLcWNGcNc3KF
	2DviWEeIC5HX1PqRccgvFsCJhykk7J3DTH8Sj2Xks2/yDZmQxNJ3TtD7rMsee4OaiSQyX7TNbYj
	8uIkQG0aNfP0oPzUh80ntiKRs6pHPnhaFgT2aorjtJAtGkQXzjMGNelf2G6JYuyzE6/KXvUf7ZE
	nbddzuzF8m/fzhmMaLw=
X-Received: by 2002:a05:6e02:1707:b0:3d3:e547:475e with SMTP id e9e14a558f8ab-3d586bd6020mr11398745ab.5.1742408227777;
        Wed, 19 Mar 2025 11:17:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFLBoeUjxXSXS4W+ipHr8w9aF4a13A5Kze4QyVbHstkka4sLj6Rw3yDxWqMIHbyTrf9xEosw==
X-Received: by 2002:a05:6e02:1707:b0:3d3:e547:475e with SMTP id e9e14a558f8ab-3d586bd6020mr11398615ab.5.1742408227366;
        Wed, 19 Mar 2025 11:17:07 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2637fb81esm3337752173.89.2025.03.19.11.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Mar 2025 11:17:06 -0700 (PDT)
Date: Wed, 19 Mar 2025 12:17:04 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/type1: conditional rescheduling while pinning
Message-ID: <20250319121704.7744c73e.alex.williamson@redhat.com>
In-Reply-To: <Z9rm-Y-B2et9uvKc@kbusch-mbp>
References: <20250312225255.617869-1-kbusch@meta.com>
	<20250317154417.7503c094.alex.williamson@redhat.com>
	<Z9iilzUTwLKzcVfK@kbusch-mbp.dhcp.thefacebook.com>
	<20250317165347.269621e5.alex.williamson@redhat.com>
	<Z9rm-Y-B2et9uvKc@kbusch-mbp>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 19 Mar 2025 09:47:05 -0600
Keith Busch <kbusch@kernel.org> wrote:

> On Mon, Mar 17, 2025 at 04:53:47PM -0600, Alex Williamson wrote:
> > On Mon, 17 Mar 2025 16:30:47 -0600
> > Keith Busch <kbusch@kernel.org> wrote:
> >   
> > > On Mon, Mar 17, 2025 at 03:44:17PM -0600, Alex Williamson wrote:  
> > > > On Wed, 12 Mar 2025 15:52:55 -0700    
> > > > > @@ -679,6 +679,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
> > > > >  
> > > > >  		if (unlikely(disable_hugepages))
> > > > >  			break;
> > > > > +		cond_resched();
> > > > >  	}
> > > > >  
> > > > >  out:    
> > > > 
> > > > Hey Keith, is this still necessary with:
> > > > 
> > > > https://lore.kernel.org/all/20250218222209.1382449-1-alex.williamson@redhat.com/    
> > > 
> > > Thank you for the suggestion. I'll try to fold this into a build, and
> > > see what happens. But from what I can tell, I'm not sure it will help.
> > > We're simply not getting large folios in this path and dealing with
> > > individual pages. Though it is a large contiguous range (~60GB, not
> > > necessarily aligned). Shoould we expect to only be dealing with PUD and
> > > PMD levels with these kinds of mappings?  
> > 
> > IME with QEMU, PMD alignment basically happens without any effort and
> > gets 90+% of the way there, PUD alignment requires a bit of work[1].
> >    
> > > > This is currently in linux-next from the vfio next branch and should
> > > > pretty much eliminate any stalls related to DMA mapping MMIO BARs.
> > > > Also the code here has been refactored in next, so this doesn't apply
> > > > anyway, and if there is a resched still needed, this location would
> > > > only affect DMA mapping of memory, not device BARs.  Thanks,    
> > > 
> > > Thanks for the head's up. Regardless, it doesn't look like bad place to
> > > cond_resched(), but may not trigger any cpu stall indicator outside this
> > > vfio fault path.  
> > 
> > Note that we already have a cond_resched() in vfio_iommu_map(), which
> > we'll hit any time we get a break in a contiguous mapping.  We may hit
> > that regularly enough that it's not an issue for RAM mapping, but I've
> > certainly seen soft lockups when we have many GiB of contiguous pfnmaps
> > prior to the series above.  Thanks,  
> 
> So far adding the additional patches has not changed anything. We've
> ensured we are using an address and length aligned to 2MB, but it sure
> looks like vfio's fault handler is only getting order-0 faults. I'm not
> finding anything immediately obvious about what we can change to get the
> desired higher order behvaior, though. Any other hints or information I
> could provide?

Since you mention folding in the changes, are you working on an upstream
kernel or a downstream backport?  Huge pfnmap support was added in
v6.12 via [1].  Without that you'd never see better than a order-a
fault.  I hope that's it because with all the kernel pieces in place it
should "Just work".  Thanks,

Alex

[1] https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/


