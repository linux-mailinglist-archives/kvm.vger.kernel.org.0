Return-Path: <kvm+bounces-29922-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 106739B410C
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 04:33:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9063283716
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 03:33:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B1971FBF7E;
	Tue, 29 Oct 2024 03:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="pheDC6Bh"
X-Original-To: kvm@vger.kernel.org
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590E54400;
	Tue, 29 Oct 2024 03:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730172789; cv=none; b=EvZCR2+ZSjuG8UIZ7z9fbykdfggc/jCHuLYuJG0tPSpwrdGk6TpB//IhHANiYHfCHQaZP7ocvq8rlkEUIk7cHSv7didb2ZQAlQGZwg0wYPHuJr4TEU8LusxXkIyKXjkj2FeXzOSjYvNB0ATISXH6UFRgKMNZblouWa9dIoZ2hwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730172789; c=relaxed/simple;
	bh=Axfbl2mXtYfhUUvSfNjqd8Cjc2LFTccozln5xrrkvsA=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=KGzaEenVAoAI1qT5jvG4SrnF+8cFDX+j1jyg+tqlSzMBX2nsYTOkxLg9IvZbJ4YmQt7pvb3I54WgxyWJKA1YsVIajemhVcsQa3MEmUXcjRXSN8TZNK5dJFX3PZRiT2VWuTP88AcyCisAJ9gytA293Cvjm0g2tOAOxEVLiZ5iuj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=pheDC6Bh; arc=none smtp.client-ip=115.124.30.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1730172777; h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type;
	bh=I/2DTLm1WNbI9Umt9nEXdjlHaYdgN4nxe2/jWIWHQxM=;
	b=pheDC6Bh9ms3uzRRwGlVWSMEBYlpdkof185fts27k2qBA+niJrkVgE1eYB2XB9/MrhmfLbTzgwAbodFOV9F+/CtcQndbHZWY8Jh7YC0hT1dd8lqtCAK8DFZBo2C6IMHjDnZD+YVOXHC9ryJkX5n81YKbdq7XUbD1P2KTTVx+bH0=
Received: from 30.178.65.205(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0WI8m0P8_1730172769 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 29 Oct 2024 11:32:57 +0800
Message-ID: <18761ea2-46a7-4c79-a5b7-933e26362559@linux.alibaba.com>
Date: Tue, 29 Oct 2024 11:32:49 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
From: qinyuntan <qinyuntan@linux.alibaba.com>
Subject: Re: [PATCH v1: vfio: avoid unnecessary pin memory when dma map io
 address space 0/2]
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1729760996.git.qinyuntan@linux.alibaba.com>
 <20241024110624.63871cfa.alex.williamson@redhat.com>
In-Reply-To: <20241024110624.63871cfa.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

You are right, it seems I did not get the relevant updates in time. In 
the patch f9e54c3a2f5b7 ("vfio/pci: implement huge_fault support"), 
huge_fault was introduced, and maybe we can achieve the same effect by 
adjusting the function vfio_pci_mmap_huge_fault's order parameter.
Thanks,

Qinyun Tan

On 2024/10/25 01:06, Alex Williamson wrote:
> On Thu, 24 Oct 2024 17:34:42 +0800
> Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:
> 
>> When user application call ioctl(VFIO_IOMMU_MAP_DMA) to map a dma address,
>> the general handler 'vfio_pin_map_dma' attempts to pin the memory and
>> then create the mapping in the iommu.
>>
>> However, some mappings aren't backed by a struct page, for example an
>> mmap'd MMIO range for our own or another device. In this scenario, a vma
>> with flag VM_IO | VM_PFNMAP, the pin operation will fail. Moreover, the
>> pin operation incurs a large overhead which will result in a longer
>> startup time for the VM. We don't actually need a pin in this scenario.
>>
>> To address this issue, we introduce a new DMA MAP flag
>> 'VFIO_DMA_MAP_FLAG_MMIO_DONT_PIN' to skip the 'vfio_pin_pages_remote'
>> operation in the DMA map process for mmio memory. Additionally, we add
>> the 'VM_PGOFF_IS_PFN' flag for vfio_pci_mmap address, ensuring that we can
>> directly obtain the pfn through vma->vm_pgoff.
>>
>> This approach allows us to avoid unnecessary memory pinning operations,
>> which would otherwise introduce additional overhead during DMA mapping.
>>
>> In my tests, using vfio to pass through an 8-card AMD GPU which with a
>> large bar size (128GB*8), the time mapping the 192GB*8 bar was reduced
>> from about 50.79s to 1.57s.
> 
> If the vma has a flag to indicate pfnmap, why does the user need to
> provide a mapping flag to indicate not to pin?  We generally cannot
> trust such a user directive anyway, nor do we in this series, so it all
> seems rather redundant.
> 
> What about simply improving the batching of pfnmap ranges rather than
> imposing any sort of mm or uapi changes?  Or perhaps, since we're now
> using huge_fault to populate the vma, maybe we can iterate at PMD or
> PUD granularity rather than PAGE_SIZE?  Seems like we have plenty of
> optimizations to pursue that could be done transparently to the user.
> Thanks,
> 
> Alex


