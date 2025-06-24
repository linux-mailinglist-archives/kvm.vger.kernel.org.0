Return-Path: <kvm+bounces-50571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95E4BAE70F6
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 22:37:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20EB33AA194
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 20:37:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CCE82EA47E;
	Tue, 24 Jun 2025 20:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OZPDxSLW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08723FB1B
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 20:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750797456; cv=none; b=uDE5ME3QeA/MDBCm/y52HXYQUczqkbleChQIYOuDBFQrXP2vhvgFC1OyhxpsTeicJL7UNgQnmZuNrDJPB+j2ALiew/ovGy4Lw8pBcGBo7cQaDc5aQKznXOwh9wJKQ83Xy3pUyj+YwnMF8yl2S/FjHND1XHn1UpzACoPDcH+82pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750797456; c=relaxed/simple;
	bh=0Xmn1uuMhDiiBO05TyWDJfrX1cm44KxsQolkC8UP5n8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sdk29j5S1lwcvHRxA2YgQJYqpYdI/nDFI2cxtLFFqk/0XAtBtIdS4M+cZ54FvAWTxYFeJcqBEJZUkUCH65s13It64HQ5S+1iGR5D3kBP4uSDeMAJVkeIjFy5VAx2T4vl3e+XXczAGOSk2feNzlSSZMkHaUJCFrzGVyJhmcfLDxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OZPDxSLW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750797453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6yxMqBKwP1JxoQEpLOHCxLcmo0QA6v2itUNxKEqsozo=;
	b=OZPDxSLWoLJwPZry3vWA0gEFyxd9IENV45ktIAARuOZAZ3ZisrQaHsPa5jlcOQIVAif7UT
	4bWq8kLmygfcHFAXNi1aa1dvqp8EmgRT79rfhhf0Trfr0vveNyK0VPL4sVfl3iTaHi0Dnz
	ZKGcexauImovXb9fIvKBiHIzkHP46ww=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-31-W7f3bsTtMsG3w9sVdkVmqg-1; Tue, 24 Jun 2025 16:37:32 -0400
X-MC-Unique: W7f3bsTtMsG3w9sVdkVmqg-1
X-Mimecast-MFC-AGG-ID: W7f3bsTtMsG3w9sVdkVmqg_1750797452
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c5e2a31f75so200108385a.1
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 13:37:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750797452; x=1751402252;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6yxMqBKwP1JxoQEpLOHCxLcmo0QA6v2itUNxKEqsozo=;
        b=PZchRLKS+KAWJ24mA703u02++mxhr+1lNqe0brKzOqOKDE+smvM3lzcdQAjhle8opT
         ZVbIamdvVI5cX+6ZCmSbtZ8Aq+XS/5kiJbDYCAN/hcX2co5CmGDmzzDIxmWb5Kmx/Mio
         p/mykhMmYBy9pwZq9e49pXbmdNrryGs7P59grxUtSWkeYiI91oQw+zhHuFK925RPnRmM
         uLVR5B1FuBWb/o/9ZOLU3+gnHq/X6U8y3Pb2iBQKn5ZFoqb0/J8brqVQt0pKsrqlMy7S
         dbb4K7Jic/bxm7sq4InCt3BDWpW453Nn35xXCXlG6QKgvHGPlS5sjd4hXBAlpXO1qc+o
         jiRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZybjjfhdOtnku4/UC+o8XIdHh3O1rpmZFPCbi7R4+9BDKUM05z6rCEQxonV7LyIB0NTM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKAAcN/Jf/6OKJXULFEEDQtj1IgA6P70JbDsuVaQZsB+WbvCee
	W1Yjx/4NcxvPP+CMz/erMlxvbL5cYRbuY38wdQMLVvsVBLt42eqqwRBZ4AlmBz8H2gq76kF3fp7
	6ej+orWk99di+5J0fgB1DT26Fm9WUqLUswlduBO1K0hNSKJ/7fEEf5yz73jcHLw==
X-Gm-Gg: ASbGncsgjeQiLfUgy+Kg4sUWIv//jRNhoQU/F3aDGk0H5cYa9FrVcnFP8E+MskB1OXn
	0e59yPMI79eilHnJQ52FeXusxF8YSFXOmIteikQfVgwAABBukLuBpMQ82K2jQdAibl+FJa5pQsm
	1YaKg66jahft6BHbG8czt8pUeCZ56x1x2lqHrLi98N1U9SonJIA/BrLu81/aW5TVudneXiUL6qs
	1JP65dz3nRVxCMEHBLUop5J2oeXp+Z8+Q9l+3FMqMeU8AZwUT05k/EBbWBCK9gKP1Ol4izIxOMx
	Lt4LOVYPcoYeIw==
X-Received: by 2002:a05:620a:4245:b0:7d4:2868:89ea with SMTP id af79cd13be357-7d4296ca006mr71567585a.4.1750797451598;
        Tue, 24 Jun 2025 13:37:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJhrZbzSf4nFQrc7HvgOH4lF63QunCi8blfM0+NnlfUmmge32P6rWG9OyIu4U5ZJRiNzQrZw==
X-Received: by 2002:a05:620a:4245:b0:7d4:2868:89ea with SMTP id af79cd13be357-7d4296ca006mr71563085a.4.1750797451009;
        Tue, 24 Jun 2025 13:37:31 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fd09576766sm60648376d6.81.2025.06.24.13.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 13:37:30 -0700 (PDT)
Date: Tue, 24 Jun 2025 16:37:26 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 5/5] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED
 mappings
Message-ID: <aFsMhnejq4fq6L8N@x1.local>
References: <20250616230011.GS1174925@nvidia.com>
 <aFHWbX_LTjcRveVm@x1.local>
 <20250617231807.GD1575786@nvidia.com>
 <aFH76GjnWfeHI5fA@x1.local>
 <aFLvodROFN9QwvPp@x1.local>
 <20250618174641.GB1629589@nvidia.com>
 <aFMQZru7l2aKVsZm@x1.local>
 <20250619135852.GC1643312@nvidia.com>
 <aFQkxg08fs7jwXnJ@x1.local>
 <20250619184041.GA10191@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250619184041.GA10191@nvidia.com>

On Thu, Jun 19, 2025 at 03:40:41PM -0300, Jason Gunthorpe wrote:
> Even with this new version you have to decide to return PUD_SIZE or
> bar_size in pci and your same reasoning that PUD_SIZE make sense
> applies (though I would probably return bar_size and just let the core
> code cap it to PUD_SIZE)

Yes.

Today I went back to look at this, I was trying to introduce this for
file_operations:

	int (*get_mapping_order)(struct file *, unsigned long, size_t);

It looks almost good, except that it so far has no way to return the
physical address for further calculation on the alignment.

For THP, VA is always calculated against pgoff not physical address on the
alignment.  I think it's OK for THP, because every 2M THP folio will be
naturally 2M aligned on the physical address, so it fits when e.g. pgoff=0
in the calculation of thp_get_unmapped_area_vmflags().

Logically it should even also work for vfio-pci, as long as VFIO keeps
using the lower 40 bits of the device_fd to represent the bar offset,
meanwhile it'll also require PCIe spec asking the PCI bars to be mapped
aligned with bar sizes.

But from an API POV, get_mapping_order() logically should return something
for further calculation of the alignment to get the VA.  pgoff here may not
always be the right thing to use to align to the VA: after all, pgtable
mapping is about VA -> PA, the only reasonable and reliable way is to align
VA to the PA to be mappped, and as an API we shouldn't assume pgoff is
always aligned to PA address space.

Any thoughts?

-- 
Peter Xu


