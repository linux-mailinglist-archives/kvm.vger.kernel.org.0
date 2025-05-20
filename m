Return-Path: <kvm+bounces-47184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBF5AABE690
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 23:56:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 688714C4C73
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 21:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A174525E440;
	Tue, 20 May 2025 21:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b62RuAFF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2F5219A71
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 21:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747778192; cv=none; b=uaDIfRMjOeP4H2IUZ6i5k1fcsc1Mrdvp6DdttiWBrBJnT/2kZ2ja+d1NG7a26s2QFjz2dGQTCIXPhG87jNXTuQI+fB50yOngjvxDWepp3V+xrMmy7yf7g4O6f5wmIt0kUvbuXQBqh9dRlej3oSnDAcxRZYNP4p2bHvBKF2BVAQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747778192; c=relaxed/simple;
	bh=oWb5hAu/l5YSX8uJ039kggIhfQkxgNS/Ezdx1ZpAoFo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R8AVsOA96q+I/hqMdAHWnG2cSrCssT2P7QZN919lU01JOEziLZyq/CaGM/s9SE98Fsce9lOPQElBpRIr7t2Nz+FaF9wH8Q/zJs1RHw90iHwihEAVj1Kg9aTupIJ5uD34YxyUeuf+MCrUxyIeeLDk7D3C4u5GjkgOH/rJE1YOfhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b62RuAFF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747778190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8I/zlDb7KnN1EE0TcCQ0JoPgED/9jrw+qsbSjcDT74Q=;
	b=b62RuAFF6csILHLe4D14GzQ7hPtaNdHJbT0+VD/nUzO5xz+nLwDM03W4lHt+FRVDlHggeo
	ABqDvrC/E2dOr0FW07aeDVfzypgs40rV3LgtPwwqplwrCSGYafZP9/oQ17RsOAB9LI9LdL
	+tDCooxesjeaMvqvPFpxggOg3OPlV94=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-387-NRQKo9KIPy-fcvtuz9uUVg-1; Tue, 20 May 2025 17:56:28 -0400
X-MC-Unique: NRQKo9KIPy-fcvtuz9uUVg-1
X-Mimecast-MFC-AGG-ID: NRQKo9KIPy-fcvtuz9uUVg_1747778188
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-730445c2584so1206519a34.2
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 14:56:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747778188; x=1748382988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8I/zlDb7KnN1EE0TcCQ0JoPgED/9jrw+qsbSjcDT74Q=;
        b=J/xe9ZqMpkrtqHvxCjszJMSFBLi17RPUN8cNtcIMXsuRo+UrdM8E1NG3jodMorkZrt
         z4vnfqeqizurJQwpB4zU55ZNlWvAgPWSdSFcH6/lN4E8hoegjmphGz1s0dEJ3QIxE50p
         R08CkvhnlLulxNJrcDDCd8hoEX1TmHWgqHvmnyr7dBQZw9mb3p0fMW6XqKtCUiOA4QI+
         IZhvcorU6F/AeyJJyBjQKc8n8vlr6RF1XUimlvJGz6RVz2/UzEuuKEjpoZlWmLhS+kK5
         suyLEg8x56qbyeMjKDl4RF2415ic7QGDSVqt5N/7CGCxrp1BZcB/Bc98PRf7QYkZEKK4
         pH1Q==
X-Forwarded-Encrypted: i=1; AJvYcCU6KqAuGwoi6Dh2LDK5dyLV23IgDkXSyx5KJufPeNYSDe+w6pVCY/TUPkkCzLjzfKpcphI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3+peSIHwKaK0AV4Chwin8x3+TCz68NujBS8gI6gUQtgvryS2P
	Ko+2a9paAgPX19CGPxz6PFbafa7MhDHb5IPAUhBygr9S/6GNm3hVyKaoieMDJp1j2OmlOOCePas
	vGMNTiD+rHYBEb9VTWxRo5UFZQSlS1eUHcDDTWxxVSLCxQtD+ub1YZA==
X-Gm-Gg: ASbGncvigTNwSzJUEgkx3nrVh0yfjn/pKg7FDGspw7uYiFn+Fj3Yc/+dlTVd/LYpRXx
	MYAFJBL76tcpdXUaO/ilw6CQQY3NMxfQ2ufIJcP4g6XIDLwBrBIpIiNE0yDV5BTlwQnQX+Wd+dN
	ptbVkwDFvvY/IfuxYELklLN9WYrrlDdATPjpcqgOZCkokCA9xRaRk0gxoQCcT4aLBIeCTSqaWlO
	W+4XGFF22KbHgs68+Wh7slCoysHYUgdQ3TgdDdOLfceKtsDIrQKsq1D74mTfenxVPjn6e34W3Ax
	hGZyQkR23ttJGO4=
X-Received: by 2002:a05:6830:2b10:b0:727:3b8d:6b2a with SMTP id 46e09a7af769-734f6b91e7emr5189928a34.7.1747778187741;
        Tue, 20 May 2025 14:56:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFk9JqMhUFPwxwAxuXj2yAnvft1vt3nStZWtHNmFycnDXM5L8C/WRYPVEXsZD3K/2UWIMr5xg==
X-Received: by 2002:a05:6830:2b10:b0:727:3b8d:6b2a with SMTP id 46e09a7af769-734f6b91e7emr5189917a34.7.1747778187411;
        Tue, 20 May 2025 14:56:27 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-734f6b3cbb4sm1971038a34.44.2025.05.20.14.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 14:56:26 -0700 (PDT)
Date: Tue, 20 May 2025 15:56:24 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>, lizhe.67@bytedance.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, muchun.song@linux.dev
Subject: Re: [PATCH v3] vfio/type1: optimize vfio_pin_pages_remote() for
 huge folio
Message-ID: <20250520155624.3d0fdc38.alex.williamson@redhat.com>
In-Reply-To: <8bd88c21-4164-4e10-8605-d6a8483d0aeb@redhat.com>
References: <20250520070020.6181-1-lizhe.67@bytedance.com>
	<20250520080719.2862017e.alex.williamson@redhat.com>
	<aCy1AzYFyo4Ma1Z1@x1.local>
	<8bd88c21-4164-4e10-8605-d6a8483d0aeb@redhat.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 20 May 2025 19:41:19 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 20.05.25 18:59, Peter Xu wrote:
> > Hi, Alex,
> > 
> > On Tue, May 20, 2025 at 08:07:19AM -0600, Alex Williamson wrote:  
> >> Peter, David, if you wouldn't mind double checking the folio usage
> >> here, I'd appreciate it.  The underlying assumption used here is that
> >> folios always have physically contiguous pages, so we can increment at
> >> the remainder of the folio_nr_pages() rather than iterate each page.  
> > 
> > Yes I think so.  E.g., there's comment above folio definition too:  
> 
> It has consecutive PFNs, yes (i.e., pfn++). The "struct page" might not 
> be consecutive (i.e., page++ does not work for larger folios).

The former, contiguous PFNs is all we need here.  We're feeding the
IOMMU mapping, so we're effectively just looking for the largest extent
of contiguous PFNs for mapping a given IOVA.  The struct page is really
just for GUP, finding the next pfn, and with this, finding the offset
into the large folio.

> > /**
> >   * struct folio - Represents a contiguous set of bytes.
> >   * ...
> >   * A folio is a physically, virtually and logically contiguous set
> >   * of bytes...
> >   */
> > 
> > For 1G, I wonder if in the future vfio can also use memfd_pin_folios()
> > internally when possible, e.g. after stumbled on top of a hugetlb folio
> > when filling the batch.  
> 
> Yeah, or have a better GUP interface that gives us folio ranges instead 
> of individual pages.
> 
> Using memfd directly is obviously better where possible.

Yeah, we brought up some of these issues during previous reviews.
Ultimately we want to move to IOMMUFD, which already has these
features, but it still lacks P2P DMA mapping and isn't as well
supported by various management stacks.  This leaves some performance
on the table, but has a pretty high return for a relatively trivial
change.  Thanks,

Alex


