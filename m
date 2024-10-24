Return-Path: <kvm+bounces-29661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E3D629AED18
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 19:06:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B6A51F2314C
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 17:06:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E76E1FAEF1;
	Thu, 24 Oct 2024 17:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IfESQaJ0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E64D1F9EBE
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 17:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729789592; cv=none; b=trw5O5KSOzP6yRbhOauLomLcfRdUZ4x2Y6/tUq+7CQ//6apnCTTDPEcxPA+L8MIYmYMSi4ScUVLvuzuAt03G5KyhE2CWD60BPhBCyCQ8x88u+YHxUnv4A3SAHb0XTCzahi5oqEaYweLw4Z5YkmdmyY13tdJpHlmv4uaCGO/a+aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729789592; c=relaxed/simple;
	bh=klh9W07z9dnYrx+WDBXVU7Y7gwPoTbnFgZFMj8f913U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rQ8ceXN+ktsjymQO+isM4f8RfsV7XY/ydj+Vl2/8RmRcrNAD0iRJxJ3SikgEs7H5U8AOtUWTJ9kSufj2gcZ8ptLV/NXm6aVicpCKPoM1SW8D/+ujVPcJ9RrwqTBuvVZ8jkhJy+ni9X6CQtbDw4Mab0IM4zCPSNDHIiCybV/4800=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IfESQaJ0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729789589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DJivlp5+vY5saGH+G4HFhSzZKNWMZaI7pdxEbQ8gMx4=;
	b=IfESQaJ06LjEXY4X+YXhP1S/CjMYMJAdfyVXDZ9qsipSWA/vDSuPTl3jef5p8A0GMuISbg
	yOSjp+G5js7gYE9rUUZE3oWnZ9ZKqsNz4PhXr7fpuUiCY6dlbNR3/TUuOCFJRaPpAw4dfk
	M0KA2J2BuAGLk4B4ngPheJHSV0b/C6U=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-HrAG1fjnNgON-vtFd9jzGQ-1; Thu, 24 Oct 2024 13:06:28 -0400
X-MC-Unique: HrAG1fjnNgON-vtFd9jzGQ-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-83aae920bb7so19765939f.0
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 10:06:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729789587; x=1730394387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DJivlp5+vY5saGH+G4HFhSzZKNWMZaI7pdxEbQ8gMx4=;
        b=amKjAKb/KTgyqcSj00Q9+/54xV66I1QxYArE2rG/0K5kVkIePs/q+tH5SzJo3MreI/
         pX92Xi4sWZKWSPR+W8WQZxwq1A1fLSXSCf4v/ki1e9yKJv89d95GlceWO9cNz86fIUsL
         BRBfihTOSaSOryLTqifavBpuzItEMzOpRNSLo7EmfvgSyCVw7/a6EqL6jt7k1Go00/GG
         zIraTTTDJcT5QXYyRlUVHdqLTbrPfZJck/64r6RpUgYlrRR/SUNMQ5cY+1HYWGEdnGiV
         2JKQTTSvN1TEgh+a95V1y/O/Zu3yijmbqPjcolUjnzF/ewR9QcvjZv4kq1S0tyQT6beU
         9G0A==
X-Forwarded-Encrypted: i=1; AJvYcCXbl6Wvsjai6OwRcwYfqFr7LU4D5WC1Xyr4rKpWHY1eLaUKfCRC9vvNQw8JxNtMi9mcMuk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJXkAHQmyEk6UfZxycN5vHQ4bkWWniWExjet/IZ2NQw4Mugdj1
	6G7pi9ejoEH0Ix27liMXnAFDiGSJaR7badV394f7cSdzxeNXTzu+WYiCXc2VOb1iDm6tRgG9bJk
	g5pb1DPQlC2zHzeKwxOCcCj70n3vGLzu0SwInBav2K+946PMosmXy2Zk/SA==
X-Received: by 2002:a05:6602:2564:b0:83a:9c22:23b3 with SMTP id ca18e2360f4ac-83af6460bd2mr172822139f.4.1729789586996;
        Thu, 24 Oct 2024 10:06:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0kqiNgE1U9eRrDe1V4C/y24cuS+s9R9LQzqi7g3Sgz9abY/IAJocZ7cw6oH4QmP1S6Y7LyQ==
X-Received: by 2002:a05:6602:2564:b0:83a:9c22:23b3 with SMTP id ca18e2360f4ac-83af6460bd2mr172819539f.4.1729789586416;
        Thu, 24 Oct 2024 10:06:26 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83ad1c4e380sm286926339f.13.2024.10.24.10.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 10:06:25 -0700 (PDT)
Date: Thu, 24 Oct 2024 11:06:24 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1: vfio: avoid unnecessary pin memory when dma map io
 address space 0/2]
Message-ID: <20241024110624.63871cfa.alex.williamson@redhat.com>
In-Reply-To: <cover.1729760996.git.qinyuntan@linux.alibaba.com>
References: <cover.1729760996.git.qinyuntan@linux.alibaba.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 24 Oct 2024 17:34:42 +0800
Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:

> When user application call ioctl(VFIO_IOMMU_MAP_DMA) to map a dma address,
> the general handler 'vfio_pin_map_dma' attempts to pin the memory and
> then create the mapping in the iommu.
> 
> However, some mappings aren't backed by a struct page, for example an
> mmap'd MMIO range for our own or another device. In this scenario, a vma
> with flag VM_IO | VM_PFNMAP, the pin operation will fail. Moreover, the
> pin operation incurs a large overhead which will result in a longer
> startup time for the VM. We don't actually need a pin in this scenario.
> 
> To address this issue, we introduce a new DMA MAP flag
> 'VFIO_DMA_MAP_FLAG_MMIO_DONT_PIN' to skip the 'vfio_pin_pages_remote'
> operation in the DMA map process for mmio memory. Additionally, we add
> the 'VM_PGOFF_IS_PFN' flag for vfio_pci_mmap address, ensuring that we can
> directly obtain the pfn through vma->vm_pgoff.
> 
> This approach allows us to avoid unnecessary memory pinning operations,
> which would otherwise introduce additional overhead during DMA mapping.
> 
> In my tests, using vfio to pass through an 8-card AMD GPU which with a
> large bar size (128GB*8), the time mapping the 192GB*8 bar was reduced
> from about 50.79s to 1.57s.

If the vma has a flag to indicate pfnmap, why does the user need to
provide a mapping flag to indicate not to pin?  We generally cannot
trust such a user directive anyway, nor do we in this series, so it all
seems rather redundant.

What about simply improving the batching of pfnmap ranges rather than
imposing any sort of mm or uapi changes?  Or perhaps, since we're now
using huge_fault to populate the vma, maybe we can iterate at PMD or
PUD granularity rather than PAGE_SIZE?  Seems like we have plenty of
optimizations to pursue that could be done transparently to the user.
Thanks,

Alex


