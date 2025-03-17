Return-Path: <kvm+bounces-41312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10AB3A660E0
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 22:45:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 90FF83B69BB
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 21:44:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B2602045A1;
	Mon, 17 Mar 2025 21:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XMxscT1x"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106B51FFC44
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 21:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742247866; cv=none; b=E5CRhkJaMJhZI36hkIuZPH7lfa/ErG6Mw/idDTaMxaYiEn7hbT83e5ayYifqGeLYzPFQ7GXDH9U+vmMQfEi3jCsEXG1AhcMpga0U4gkpiUqG2zWjeO3MywL1uKwVtgvsSaKGzC1PRLFS3/cRhQRl4NE/1MmogFFIUQX+Niu/cqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742247866; c=relaxed/simple;
	bh=gEwxoY1TaPZJ7Fea1d/D3sG6GU71QVPd70ype/rkdao=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t1SxCJRPBYnG1hs5x9xCPgtTRcD5m0Qjfdv6QZ+ht92TB3Df5F40WaPxKsqeHmM9G175wr/ZmlqIYHZOUefG6al6ewf1fjP1tcJrKgF5wPnUqyalVDYUkA60OJykpUpmqHsXwTGc2kgWEvDRdOfQ0w2LganpGFNwXgGKJ873dlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XMxscT1x; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742247864;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ct8pqjOjiSTyCi2hhSivSmq+MCiDJVwRUQ4M3Fhl4Xw=;
	b=XMxscT1x6Kfc4BSPjeV7rjNhjUha7PJM4hkuSURi+BxXqHsG64z3WJLE9tzLZYE1chmMzV
	vR3Nbo+WXH2quNmhQKVxf2YzZq7gkBcgXf0d+mRfEw2O5fJt9zrCz4n0PJXFDFEFJaRYeZ
	dNz2l6FXnqeUrv8GUDyaWWBUwSifSNQ=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361-2fppTM33NjWQ1njbYyQz8A-1; Mon, 17 Mar 2025 17:44:21 -0400
X-MC-Unique: 2fppTM33NjWQ1njbYyQz8A-1
X-Mimecast-MFC-AGG-ID: 2fppTM33NjWQ1njbYyQz8A_1742247861
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3ce8c06be57so8145285ab.1
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 14:44:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742247860; x=1742852660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ct8pqjOjiSTyCi2hhSivSmq+MCiDJVwRUQ4M3Fhl4Xw=;
        b=AcCKc9SeLGpFRoMhRb1kKcBa569DMA71nZznIVYQCNEWdsXLqkg91u18lpyvwTgGJ4
         tRtncmR/i0LmZeQg0iSopowRKqcXsjaVc+lBpxRRJTbtpXh63xyHugzS8tByu/Cp4CTi
         5YDnlO6Dasl7ruuzbuCntWNbYGJ0usLBOjX5HAPW0ln7ylkmeHPyRFrs+KhjtkmWCKWO
         UvA2w5df0XCQz6Nl8Bq0iBKWht3TIBoQ9rXjwy+jMIr4ff41NGXGZps1DP4xWb1ryiVo
         T0706lQ4lElRoHOsEWhzc1HSWyhXjC7xqf3je8u2gWryMJLzyHO4D0wvKx7cCHM3rKbU
         FK/Q==
X-Gm-Message-State: AOJu0Yyj3k8ojFO5iX+tIGIg5qSYChDoBJejovywTXTrDIQYPU9fKEEn
	M5Cl3s3l1gdR87do7PLnRK9FtB2wB30HreIS0ylSS14R1h01i5oGkRpeOvdYptaRDGjPvFV07MK
	ykFxzi9Yf8qo+H6EQ60oPgzZLLIip0m4WodCrkagiAT1ky0AmRg==
X-Gm-Gg: ASbGncsxEvaObJW9P2wwnfsNwynokzK8FWOENwPTqfVdU06+Q4ZyXOruG+CZJgN/91x
	/U2oyOZuywNIbsb6+KIkwA4RuOXyW4Jnus0FA9F7oLk0uONNP75/qa3UD0qZSv2mAfQIRbsb2Lu
	Rk6QMBMfWyzBXStsIkcJkgDS0wsuOtz7dkCZPjMBwfo1iqYN9tUbCcucUvJFMJDpFwfza9ZIOjA
	lyjdodc9Fpsp4AEGmCpo7RLmmd46W2wO1cQuyvqJ6G5Srgkw+959wLoACy+NbnXNod06YpPEin0
	7Wk5AfMoMYUwJmH8yO0=
X-Received: by 2002:a05:6e02:154f:b0:3d4:3aba:a8b3 with SMTP id e9e14a558f8ab-3d483a63bbfmr39440255ab.3.1742247860522;
        Mon, 17 Mar 2025 14:44:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFS9gbJ9Lo8PUZQXttgf7SDnnxlWSZk+AIELOREunMzmYqiRmGKUDS75uZkIX5kojIlTRy7rw==
X-Received: by 2002:a05:6e02:154f:b0:3d4:3aba:a8b3 with SMTP id e9e14a558f8ab-3d483a63bbfmr39440205ab.3.1742247860178;
        Mon, 17 Mar 2025 14:44:20 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2637fb2b2sm2446169173.94.2025.03.17.14.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 14:44:19 -0700 (PDT)
Date: Mon, 17 Mar 2025 15:44:17 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: <kvm@vger.kernel.org>, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH] vfio/type1: conditional rescheduling while pinning
Message-ID: <20250317154417.7503c094.alex.williamson@redhat.com>
In-Reply-To: <20250312225255.617869-1-kbusch@meta.com>
References: <20250312225255.617869-1-kbusch@meta.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 12 Mar 2025 15:52:55 -0700
Keith Busch <kbusch@meta.com> wrote:

> From: Keith Busch <kbusch@kernel.org>
> 
> A large DMA mapping request can loop through dma address pinning for
> many pages. The repeated vmf_insert_pfn can be costly, so let the task
> reschedule as need to prevent CPU stalls.
> 
>  rcu: INFO: rcu_sched self-detected stall on CPU
>  rcu: 	36-....: (20999 ticks this GP) idle=b01c/1/0x4000000000000000 softirq=35839/35839 fqs=3538
>  rcu: 	         hardirqs   softirqs   csw/system
>  rcu: 	 number:        0        107            0
>  rcu: 	cputime:       50          0        10446   ==> 10556(ms)
>  rcu: 	(t=21075 jiffies g=377761 q=204059 ncpus=384)
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
>  drivers/vfio/vfio_iommu_type1.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 50ebc9593c9d7..9ad5fcc2de7c7 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -679,6 +679,7 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
>  
>  		if (unlikely(disable_hugepages))
>  			break;
> +		cond_resched();
>  	}
>  
>  out:

Hey Keith, is this still necessary with:

https://lore.kernel.org/all/20250218222209.1382449-1-alex.williamson@redhat.com/

This is currently in linux-next from the vfio next branch and should
pretty much eliminate any stalls related to DMA mapping MMIO BARs.
Also the code here has been refactored in next, so this doesn't apply
anyway, and if there is a resched still needed, this location would
only affect DMA mapping of memory, not device BARs.  Thanks,

Alex


