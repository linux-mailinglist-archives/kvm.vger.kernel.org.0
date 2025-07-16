Return-Path: <kvm+bounces-52636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D77CFB075AE
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 14:32:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48D5C3B723A
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 12:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 709F22F5081;
	Wed, 16 Jul 2025 12:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="SNK0NrGW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C12EED8
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 12:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752669126; cv=none; b=NSIrWiRXYWGTFmwfACq4725icbQNLDlVMqCUL887tsGiQZU1QhA14Iyb2Tfe7noSDnwVf6bhNCS218NG6DGFjF7uWdvEimlpdjskzoJkcf+QNVolAPsCgVQ2gQveEpKDFL15rh0l7yoa3GRFM1p1oSNd+HJD8aePDa9MptHBfyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752669126; c=relaxed/simple;
	bh=Y0cRjNio6SFvjLryWJfo1g4J3xecGV6bJLudwyQb0Qc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rroh+Q81sdJOEkQdlmjrktKJ5UIYge0/Wx0X2V8/bP6uXxqti85SzwsuYqLOEkbQqfdTW+Yt/J/JoUpwqhcbAUFpcDKpW35vhnpBUelBlzK+cBwNjEFOO2Xs5uH8c6ILPjH5z/fOfGrsciUKxaqZ94SeHr1X6fKllevvTeAsH+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=SNK0NrGW; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-6fae04a3795so50546516d6.3
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 05:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1752669122; x=1753273922; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JcSMbH/4MOYwTmw6dPN5aHBbQu4qMFpEZO0zk7HKEmM=;
        b=SNK0NrGWyaNckMFPDDj88yWtLiBHEXmXG7mn6k1/xhcRU+mNxKxPjaOXLYOsW5j9y1
         7pFm6DhNUDX9wMdO42iTbqRUP2+pGucdL5qw4CuiLbQPtza//f09QGC9Gb+JuScJWDae
         qPOPK/cavNSAvs5XCdzYXbEG1uh5mBdhSKfQwyiKCz3+7hoAKuLASHlh2uXRXp8I9wLZ
         U4xqArEho+IoaDzcY77tDjb3Mzcgyc6cH8XVoNaH/kRXoXuTY3xhaoQd5KDWIaZIMYFY
         imsuRsW/QHlyixkZ0J/TK2jCLQlqYXP1LEw4b9blZ+B4LEBayvtQ9OXINiR9SQd4lRJl
         iy6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752669122; x=1753273922;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JcSMbH/4MOYwTmw6dPN5aHBbQu4qMFpEZO0zk7HKEmM=;
        b=fxJ39nE3DA2liAerSsZZ0o48vnOUGdOHdIQBd12TW6KmhDdOimd1+FiG1zdzN4WjEY
         MmdGi/7xWM9wb0omh58xURvLEiw82sAzJamC9hz2jK95uEge97eEXx+1L71fDwSVMuE4
         Pre+SBtMIW3SU7afFFDQjncYhFC49iIoz0L4Zm5VopTnjshQs1bmagHMeh6LaG9eURuJ
         eDJ12Jhbmveknw0WuKPSd61ehRMaLpvR/XzYWQzSMR83XRfol1kjT5p9DSo30bOTyMRH
         DuXFz8nlzI/nrRrQOZsV9Ykh5kZDPcLQPXJTz9RO0ZvSYRFYHuBLQPRlKeKBnoijxrx8
         UUPg==
X-Forwarded-Encrypted: i=1; AJvYcCWWx8eThfpVWZeFYnDDYSNdR4yyN8JaYKnPrQncw3rlkuDuP8NgmdNJQs7CBU3IQrpmssk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyldW55mjSqissS4/nQJlzpliw6Xic+5p3BemGszhp6VL7lv7MW
	dtZs/lTHn7X+yv1hT9w7hGuyJXALFX+RjZtkOoQqAU4zJJYKEFWWNZjQSC+3XKQj3nk=
X-Gm-Gg: ASbGncuELX849SdqMb8Q/qRooVK8S8b8Pk8yYXKG2HVGhot0oORadnCROgOGto1T3m9
	+zHVstINSx+Pf54d7OOqlwapH+ipjVVvBHBnPQY+AjVnauCVbXEXu/uq6LDynB3FlUYJ5uURnjt
	fk3XbK1dqkiFyASmHbSUGeuxU0Die6ElihPkmxbv5nExX20EkXGdX3J3xz8XsOmv9BJcfew9nSN
	GF8ycvVnyMMgv0vjtCq8uZQg/bMHDxxisyNIb4YHesz+0xBeVq7DsBvw0pjEMCG0aZC/7VCNRm8
	7U9DSdBOy9OEcnY7gpTlXM8YI7q1q7zkBB8GH6E/kkGSPDBGXibMin/qwA0EJkcbB0Rmfinv5a9
	18uI+7vxH40/R76WI/bygqA3+JvhF705CdOR1nHOpZ36uUiiTplchGLQvLH4gH8jE0lG2ciucqg
	==
X-Google-Smtp-Source: AGHT+IFfoiXMU7kaonX0Zkj7Vxcoxxju6KIHxh2IZru9E7Ey6ohAZ0uaUPZbEXgGduO4r/WE8O2aaw==
X-Received: by 2002:a05:6214:252a:b0:704:b066:f2b3 with SMTP id 6a1803df08f44-704f481a7a4mr45483696d6.15.1752669122322;
        Wed, 16 Jul 2025 05:32:02 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-704979b4187sm69808526d6.26.2025.07.16.05.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 05:32:01 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uc1In-00000008yGO-0rQq;
	Wed, 16 Jul 2025 09:32:01 -0300
Date: Wed, 16 Jul 2025 09:32:01 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Keith Busch <kbusch@meta.com>
Cc: alex.williamson@redhat.com, kvm@vger.kernel.org,
	linux-pci@vger.kernel.org, paulmck@kernel.org,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2] vfio/type1: conditional rescheduling while pinning
Message-ID: <20250716123201.GA2135755@ziepe.ca>
References: <20250715184622.3561598-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250715184622.3561598-1-kbusch@meta.com>

On Tue, Jul 15, 2025 at 11:46:22AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> A large DMA mapping request can loop through dma address pinning for
> many pages. In cases where THP can not be used, the repeated vmf_insert_pfn can
> be costly, so let the task reschedule as need to prevent CPU stalls. Failure to
> do so has potential harmful side effects, like increased memory pressure
> as unrelated rcu tasks are unable to make their reclaim callbacks and
> result in OOM conditions.
> 
>  rcu: INFO: rcu_sched self-detected stall on CPU
>  rcu:   36-....: (20999 ticks this GP) idle=b01c/1/0x4000000000000000 softirq=35839/35839 fqs=3538
>  rcu:            hardirqs   softirqs   csw/system
>  rcu:    number:        0        107            0
>  rcu:   cputime:       50          0        10446   ==> 10556(ms)
>  rcu:   (t=21075 jiffies g=377761 q=204059 ncpus=384)
> ...
>   <TASK>
>   ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>   ? walk_system_ram_range+0x63/0x120
>   ? walk_system_ram_range+0x46/0x120
>   ? pgprot_writethrough+0x20/0x20
>   lookup_memtype+0x67/0xf0
>   track_pfn_insert+0x20/0x40
>   vmf_insert_pfn_prot+0x88/0x140
>   vfio_pci_mmap_huge_fault+0xf9/0x1b0 [vfio_pci_core]
>   __do_fault+0x28/0x1b0
>   handle_mm_fault+0xef1/0x2560
>   fixup_user_fault+0xf5/0x270
>   vaddr_get_pfns+0x169/0x2f0 [vfio_iommu_type1]
>   vfio_pin_pages_remote+0x162/0x8e0 [vfio_iommu_type1]
>   vfio_iommu_type1_ioctl+0x1121/0x1810 [vfio_iommu_type1]
>   ? futex_wake+0x1c1/0x260
>   x64_sys_call+0x234/0x17a0
>   do_syscall_64+0x63/0x130
>   ? exc_page_fault+0x63/0x130
>   entry_SYSCALL_64_after_hwframe+0x4b/0x53
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
> v1->v2:
> 
>   Merged up to vfio/next
> 
>   Moved the cond_resched() to a more appropriate place within the
>   loop, and added a comment about why it's there.
> 
>   Update to change log describing one of the consequences of not doing
>   this.
> 
>  drivers/vfio/vfio_iommu_type1.c | 7 +++++++
>  1 file changed, 7 insertions(+)

You should be making a matching change to iommufd too..

Jason

