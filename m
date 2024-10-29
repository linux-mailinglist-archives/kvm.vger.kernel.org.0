Return-Path: <kvm+bounces-29917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 254BC9B40A2
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 03:50:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7F9F1F23029
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 02:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F0701F4272;
	Tue, 29 Oct 2024 02:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="VpaPZFxk"
X-Original-To: kvm@vger.kernel.org
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDB24400;
	Tue, 29 Oct 2024 02:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730170218; cv=none; b=J1QqmEKBMr+eOX284TNUqh/AacSL8XBRHJS56Rfle/mIfQhHRgHsRt4GtpU0dQXPWmVNPFBXBbwXY/IGSatGi64lXd87B1RoYO2Aey/dIE9M3XPl3Lc+1JuRZfoacc0dthtcHth18tqs4Q7q7ihIIS6weGfC8KaVozkotIfizLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730170218; c=relaxed/simple;
	bh=l6q2Qo1FBU0Lgv8Y7ZVXMC7wfKgt631DEtzqeoH+gao=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=kgAjom2LClr6b9ptbzmxvgRgui9ez0qv6+eNsr6Sv+2jAjg9m1enAUGj/laYrCyZAIurVbAU4MSjSQT14Q8fVnN/uo6MQBKoqWBQO9fDgEtJBnT4LAM7eElOfdePxLLmoloeWFUnxkScsOkkyv2N0dgPuKIMkUPifX56UvdIpD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=VpaPZFxk; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1730170212; h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To;
	bh=+LYH/w9vwFz4HfaTT2wWGyjrIaDoiS8YNbevERY3lVw=;
	b=VpaPZFxk0W9CJrV49olLc5Q7QkZooHSdQQ31RsqgYG3Q6F6HZB/wFBOUe6R3BZeMUBpb49nX9kuBCpq3ePMJSN2gRbur9Ewc9RiglqUPADOn8QN4InqhGmRSTP0ES69+6N7v4xhYaPV6P35OjY9ePl4OthJNP9eWmJ2dsfXGicM=
Received: from smtpclient.apple(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0WI8SNPI_1730170210 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 29 Oct 2024 10:50:11 +0800
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: Re: [PATCH v1: vfio: avoid unnecessary pin memory when dma map io
 address space 0/2]
From: =?utf-8?B?5Y2K5Y+2?= <qinyuntan@linux.alibaba.com>
In-Reply-To: <20241024110624.63871cfa.alex.williamson@redhat.com>
Date: Tue, 29 Oct 2024 10:50:00 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org,
 kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <90A096B9-0E6F-484E-A741-9C60E001E78C@linux.alibaba.com>
References: <cover.1729760996.git.qinyuntan@linux.alibaba.com>
 <20241024110624.63871cfa.alex.williamson@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
X-Mailer: Apple Mail (2.3818.100.11.1.3)



> 2024=E5=B9=B410=E6=9C=8825=E6=97=A5 01:06=EF=BC=8CAlex Williamson =
<alex.williamson@redhat.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Thu, 24 Oct 2024 17:34:42 +0800
> Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:
>=20
>> When user application call ioctl(VFIO_IOMMU_MAP_DMA) to map a dma =
address,
>> the general handler 'vfio_pin_map_dma' attempts to pin the memory and
>> then create the mapping in the iommu.
>>=20
>> However, some mappings aren't backed by a struct page, for example an
>> mmap'd MMIO range for our own or another device. In this scenario, a =
vma
>> with flag VM_IO | VM_PFNMAP, the pin operation will fail. Moreover, =
the
>> pin operation incurs a large overhead which will result in a longer
>> startup time for the VM. We don't actually need a pin in this =
scenario.
>>=20
>> To address this issue, we introduce a new DMA MAP flag
>> 'VFIO_DMA_MAP_FLAG_MMIO_DONT_PIN' to skip the 'vfio_pin_pages_remote'
>> operation in the DMA map process for mmio memory. Additionally, we =
add
>> the 'VM_PGOFF_IS_PFN' flag for vfio_pci_mmap address, ensuring that =
we can
>> directly obtain the pfn through vma->vm_pgoff.
>>=20
>> This approach allows us to avoid unnecessary memory pinning =
operations,
>> which would otherwise introduce additional overhead during DMA =
mapping.
>>=20
>> In my tests, using vfio to pass through an 8-card AMD GPU which with =
a
>> large bar size (128GB*8), the time mapping the 192GB*8 bar was =
reduced
>> from about 50.79s to 1.57s.
>=20
> If the vma has a flag to indicate pfnmap, why does the user need to
> provide a mapping flag to indicate not to pin?  We generally cannot
> trust such a user directive anyway, nor do we in this series, so it =
all
> seems rather redundant.
>=20
> What about simply improving the batching of pfnmap ranges rather than
> imposing any sort of mm or uapi changes?  Or perhaps, since we're now
> using huge_fault to populate the vma, maybe we can iterate at PMD or
> PUD granularity rather than PAGE_SIZE?  Seems like we have plenty of
> optimizations to pursue that could be done transparently to the user.
> Thanks,
>=20
> Alex


