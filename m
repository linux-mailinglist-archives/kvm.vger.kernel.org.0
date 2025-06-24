Return-Path: <kvm+bounces-50573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 49FC6AE7112
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 22:51:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92B1C3A5A08
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 20:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C78952E8895;
	Tue, 24 Jun 2025 20:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HaEY+VD4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB5D2580E1
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 20:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750798283; cv=none; b=tEsOZRcW+jjwtjZFlQ9Q26FGqqQcQsPGd94grxurkvkuvtas2NO6TCwq7kEK9TT7XgfbRr3O769WW4TafVRhEwEXvx74gVW0ttADdACtmoTY4ijTzz5G2v6wS+fwrhzIDI7HAHyfBGQHHSzXnBuS/ESK101ZIIW+QrWYcyV2iGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750798283; c=relaxed/simple;
	bh=kM/IfC/U8zaIW8FhwAjzCQVFNIYN0QjG4pYF0m7Ihgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=psn974nHi/bgfbeMd0D5aNXv19cXV7eedpV2KC7n83n6tE8Ar0A3+85RI4mMvp0mXJfl3AGQ94QhPNVOakuf6ryTutUP4kTeg7jM5eiEmb+i5TOWjs53lA9cYppTBp4t761GHaxWfWRu1NzGa4RFU8lb/3zmOwOfzHZsatxdb8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HaEY+VD4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750798280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J11ds042ECzs7H3dbgHbcrEw+iFqu0r/26P/J9h7Qko=;
	b=HaEY+VD4AT90uVlw+dzVqCpYqe4CllyMx/mrEvOICKGmv8RxSGXezXDC4LWW+p9oHVm3QJ
	pa6J59IxFXaUmlwo2yuMB5Lkt8m0SqmUTmtLBP6whNKYc22IoH9cXNpUwk+7SYvN+yUVvQ
	evzZ6CzUV5OjMhQMgap4/BFHnYuSFsA=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-674-QjD9P7cHMiaXUjpwEF5WDQ-1; Tue, 24 Jun 2025 16:51:17 -0400
X-MC-Unique: QjD9P7cHMiaXUjpwEF5WDQ-1
X-Mimecast-MFC-AGG-ID: QjD9P7cHMiaXUjpwEF5WDQ_1750798276
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7d40f335529so39322885a.0
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 13:51:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750798276; x=1751403076;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J11ds042ECzs7H3dbgHbcrEw+iFqu0r/26P/J9h7Qko=;
        b=mbMBwvjcOAcx5KsthvUkeEJctlp5OyMWxg6RYfx+KWZ8bj1Br3Ps7oXT32k5vkDXMH
         oawS6t8//tHS5duVCQHM5WkWQTu3maNVE4Z15BM9U4kKVoLif6Ge/M06w0DmtijVyZ8Y
         +6mLKTg6wxXfDeL60mGEGKM40b+mpKtVKlpmGF2qW40afyt4F2bSZOw6w1aiuVH1NL7D
         9PI+ehZTUsgWS6Cuk1ePjhgCuLtL6yFm7fHUImnm2kXgWniIKanm1eiNnKRZhiGGvdpm
         YZ0FBESfDabm2d3TShnHqO2LnpzG94zX7UsI+D4l0GD5JW6DqnbYosyzFrvJT+nQovyG
         w87w==
X-Forwarded-Encrypted: i=1; AJvYcCX6sCUecoIe1kIVIj3hT0c1NjoC/TiL+/CVSY+ncIlI4HMsws9nw/cE2pc+kpx0MRDEQYI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiPwszlHHvhS1Cg+Qai1mUeUaGhXwpIBW88C1vurhpgySc+MqE
	EfUB82tO1Kh+wTfIG6Md1HeqNXuAS+PO2Sa6cmjyvD52LTxM2w5ivrAIM7HhAm8A/xJw6/0PcgT
	9YCcS5myLAhRtXYEg1/JvNL9ivoBcS5AZdrW1M6v6VslVX3Dh18Gxdw==
X-Gm-Gg: ASbGncu8Y2WFwPn07T6QBme2zY/iseWtX585BUUxTtg+Lu2GBhAhDZ6uwTyQPx14hWo
	dPkCi2E68DBZnYU2fUWzpm8ITcyLNUZPpoy6ZzbPcpMY0uPr4EZXCV2IAr7RNfkNezJJOgZ3hFi
	+8JgxG7lxjue9a0++rAqDjEs48JczfvKyB1B/pGtZMmPSd3Ty1qb6yDrxJMNbaUgNsn+B07S8/T
	Io2H5UPdQ6AZlavOqdx47NJacIel0KNIPoixUxGi2Ca41zD3A0hd62RsBrOrmcUVfyOoANq2G1S
	9QoE4PmQU36X9A==
X-Received: by 2002:a05:620a:2907:b0:7d3:f8b8:b1ce with SMTP id af79cd13be357-7d429964b36mr55473085a.27.1750798276412;
        Tue, 24 Jun 2025 13:51:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGXB0NjNPJFhxsKe8ZP75Mk2G2kMyPcL9xehXKcPoe5G89surWH97a5ZybNtffg/Gvuki7iBg==
X-Received: by 2002:a05:620a:2907:b0:7d3:f8b8:b1ce with SMTP id af79cd13be357-7d429964b36mr55469885a.27.1750798275985;
        Tue, 24 Jun 2025 13:51:15 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d3f999c07bsm548154585a.4.2025.06.24.13.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 13:51:15 -0700 (PDT)
Date: Tue, 24 Jun 2025 16:51:12 -0400
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
Message-ID: <aFsPwLB41_3VDvtY@x1.local>
References: <aFHWbX_LTjcRveVm@x1.local>
 <20250617231807.GD1575786@nvidia.com>
 <aFH76GjnWfeHI5fA@x1.local>
 <aFLvodROFN9QwvPp@x1.local>
 <20250618174641.GB1629589@nvidia.com>
 <aFMQZru7l2aKVsZm@x1.local>
 <20250619135852.GC1643312@nvidia.com>
 <aFQkxg08fs7jwXnJ@x1.local>
 <20250619184041.GA10191@nvidia.com>
 <aFsMhnejq4fq6L8N@x1.local>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aFsMhnejq4fq6L8N@x1.local>

On Tue, Jun 24, 2025 at 04:37:26PM -0400, Peter Xu wrote:
> On Thu, Jun 19, 2025 at 03:40:41PM -0300, Jason Gunthorpe wrote:
> > Even with this new version you have to decide to return PUD_SIZE or
> > bar_size in pci and your same reasoning that PUD_SIZE make sense
> > applies (though I would probably return bar_size and just let the core
> > code cap it to PUD_SIZE)
> 
> Yes.
> 
> Today I went back to look at this, I was trying to introduce this for
> file_operations:
> 
> 	int (*get_mapping_order)(struct file *, unsigned long, size_t);
> 
> It looks almost good, except that it so far has no way to return the
> physical address for further calculation on the alignment.
> 
> For THP, VA is always calculated against pgoff not physical address on the
> alignment.  I think it's OK for THP, because every 2M THP folio will be
> naturally 2M aligned on the physical address, so it fits when e.g. pgoff=0
> in the calculation of thp_get_unmapped_area_vmflags().
> 
> Logically it should even also work for vfio-pci, as long as VFIO keeps
> using the lower 40 bits of the device_fd to represent the bar offset,
> meanwhile it'll also require PCIe spec asking the PCI bars to be mapped
> aligned with bar sizes.
> 
> But from an API POV, get_mapping_order() logically should return something
> for further calculation of the alignment to get the VA.  pgoff here may not
> always be the right thing to use to align to the VA: after all, pgtable
> mapping is about VA -> PA, the only reasonable and reliable way is to align
> VA to the PA to be mappped, and as an API we shouldn't assume pgoff is
> always aligned to PA address space.
> 
> Any thoughts?

I should have listed current viable next steps..  We have at least these
options:

(a) Ignore this issue, keep the get_mapping_order() interface like above,
    as long as it works for vfio-pci

    I don't like this option.  I prefer the API (if we're going to
    introduce one) to be applicable no matter how pgoff would be mapped to
    PAs.  I don't like the API to rely on specific driver on specific spec
    (in this case, PCI).

(b) I can make the new API like this instead:

    int (*get_mapping_order)(struct file *, unsigned long, unsigned long *, size_t);

    where I can return a *phys_pgoff altogether after the call returned the
    order to map in retval.  But that's very not pretty if not ugly.

(c) Go back to what I did with the current v1, addressing comments and keep
    using get_unmapped_area() until we know a better way.

I'll vote for (c), but I'm open to suggestions.

Thanks,

-- 
Peter Xu


