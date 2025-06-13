Return-Path: <kvm+bounces-49444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 98413AD9143
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 17:27:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 774943BD33C
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 15:27:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E61B1F3BBB;
	Fri, 13 Jun 2025 15:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LaRmIurM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30411E5729
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 15:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749828435; cv=none; b=UftqgJTNB60BABTxdmkMQzx8CPxGt3UD5fIlgO7Jxlhi5j+omZORsmjeyF5jtK0sm5lRHc1Jh/EDPObSyeBaSSiaGmSWuXveMAuY0aytBWc3AJd/OXnT3/TmhrEf6OjvKx/fg/WpEdFxqtgTxWzBw3Jlvb8A8Ckct3otU2K+Q6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749828435; c=relaxed/simple;
	bh=dTLeBokCk+Qu5G4dlYAvuaZ2u1EV60MG1tXSrQgsAWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qz/WkjgMXAsFQ7UX0YLyWRI60cXBifBnQZEHKBeUW7EYzvM1X1R3qiGTTQIP5Eq8VvTqqxuEB/xtXxQduud5hDWwaQ410iMyqVkMBd2/WGr+Ny88R9yyMu1qVUzxBnqMl3xqkCqYE8qtMXE3QjIACeeXtJpSZZeb2bECzLVPZs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LaRmIurM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749828432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ffGF128HVtw6a+HHD8uShTa3yQQnx4ItFakvkjkmL6Q=;
	b=LaRmIurMi3MFlungW5nE765ug3R/LKISDtdRK0Y5ksSV3ufG/yWZ4JXuJGtVSQOhMAi0UZ
	uSOXhYptI4+UhEN8HI3mUUgxwp+n752g2uk+opzJMt7K4SAi0iDyZnnHUXqcCU9UXpdugE
	SYnNCX43/MjT9SO3DR6bQi3ceZrSuGc=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-320-u7Q68BsHOFWbkYVMxXnIAA-1; Fri, 13 Jun 2025 11:27:10 -0400
X-MC-Unique: u7Q68BsHOFWbkYVMxXnIAA-1
X-Mimecast-MFC-AGG-ID: u7Q68BsHOFWbkYVMxXnIAA_1749828428
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6fb3654112fso36889916d6.3
        for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 08:27:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749828428; x=1750433228;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ffGF128HVtw6a+HHD8uShTa3yQQnx4ItFakvkjkmL6Q=;
        b=Wh1sJN3HDM/UCbRlE7p+Vj+avY5I6yMe3sikeEQoB9b9ilZe1d6Hf9KQtN56So62FR
         4nBGMqeOw8VtX0Qf0N1kbbC3/XgfaXtmpmeRGVSfxZvhueYUjb914C2tzS/7WZhFV6nA
         aVOeN2VreQALaGR+wDYndiPRUnW3i0Gl4xkLbQzmWLNqaznSdkXCohhT7VKIUSOXZ5Cw
         UGHGjhjXBF/S9DWzLWQW7l5yr4tDV+N+XPp/+98GTvFan4SBOY3+hXpnPPcGXgVna53d
         hrBwB7aTA6MvTz7LwO+a7qCFV9rgJZ8t08tmh6UW8tAqQ8IwxwCGz0/MHGxCUO1pJ1HQ
         sHxA==
X-Forwarded-Encrypted: i=1; AJvYcCUb3Zg2xaC41MptK/Jrir+jjtwzDdpe2iQyHftO91lHjmw8fxZsdmMagJ2Lj49/NleEcWY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNnR9iJl6/rS7SiZjfP9qo6eVhAC7XAwspr7uXgN7eIGMUB1Ll
	Yb36aV+h2DOISibCxS7CPhBecbW7MBQ/09gBatBj6/GxoVHAkQslKbSiRL3Wmz6Nr7wucevvayn
	XG99ZFIb9VLdFf47VrTjXn2qU3Sh3HREPH6tL4SjyQ+LateWB/yEZjmHvRhS2Hg==
X-Gm-Gg: ASbGnctcqCDj0KDUC43oZ/H9/q1AOAzogKcWzHrn+g3aF8sGshYwyLkhRYiTLxJce21
	oshIbtQX6ZlHOEiJ2EDNkzlk0zyPnRQ29qkvcYFECRUzm/9cDDKkKYGKXm9xuLmEJvU11k6R48L
	oEgM3i2h/jaqEBJZVPlLGMA79rqU/7r9idgCbUHz3UWA2+zK6sEGSkobDfNL1ErNL2X8NTLyp7k
	ufswpmm9mpRjsF6rzPG0+H6WnxfofymjTqkqMbzHWoSD4vpFfePs5uyhzeMqtDZmdrtv8zEcPno
	Hh9PM1g3rPmQAQ==
X-Received: by 2002:a05:6e02:1909:b0:3dc:8b57:b759 with SMTP id e9e14a558f8ab-3de00c0cbaamr44637475ab.21.1749828415770;
        Fri, 13 Jun 2025 08:26:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8djcjjfItHRHrDNgzteRBKJ058qY0Qze27Tb0GmaT85bQCB0E8VSqwOBOZ5ggANoXHojH2Q==
X-Received: by 2002:a05:6214:2343:b0:6fb:3537:fcfe with SMTP id 6a1803df08f44-6fb3e602ce6mr52125976d6.22.1749828404861;
        Fri, 13 Jun 2025 08:26:44 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fb35c55ff4sm22627546d6.92.2025.06.13.08.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 08:26:44 -0700 (PDT)
Date: Fri, 13 Jun 2025 11:26:40 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 5/5] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED
 mappings
Message-ID: <aExDMO5fZ_VkSPqP@x1.local>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-6-peterx@redhat.com>
 <20250613142903.GL1174925@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250613142903.GL1174925@nvidia.com>

On Fri, Jun 13, 2025 at 11:29:03AM -0300, Jason Gunthorpe wrote:
> On Fri, Jun 13, 2025 at 09:41:11AM -0400, Peter Xu wrote:
> 
> > +	/* Choose the alignment */
> > +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && phys_len >= PUD_SIZE) {
> > +		ret = mm_get_unmapped_area_aligned(file, addr, len, phys_addr,
> > +						   flags, PUD_SIZE, 0);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	if (phys_len >= PMD_SIZE) {
> > +		ret = mm_get_unmapped_area_aligned(file, addr, len, phys_addr,
> > +						   flags, PMD_SIZE, 0);
> > +		if (ret)
> > +			return ret;
> > +	}
> 
> Hurm, we have contiguous pages now, so PMD_SIZE is not so great, eg on
> 4k ARM with we can have a 16*2M=32MB contiguity, and 16k ARM uses
> contiguity to get a 32*16k=1GB option.
> 
> Forcing to only align to the PMD or PUD seems suboptimal..

Right, however the cont-pte / cont-pmd are still not supported in huge
pfnmaps in general?  It'll definitely be nice if someone could look at that
from ARM perspective, then provide support of both in one shot.

> 
> > +fallback:
> > +	return mm_get_unmapped_area(current->mm, file, addr, len, pgoff, flags);
> 
> Why not put this into mm_get_unmapped_area_vmflags() and get rid of
> thp_get_unmapped_area_vmflags() too?
> 
> Is there any reason the caller should have to do a retry?

We would still need thp_get_unmapped_area_vmflags() because that encodes
PMD_SIZE for THPs; we need the flexibility of providing any size alignment
as a generic helper.

But I get your point.  For example, mm_get_unmapped_area_aligned() can
still fallback to mm_get_unmapped_area_vmflags() automatically.

That was ok, however that loses some flexibility when the caller wants to
try with different alignments, exactly like above: currently, it was trying
to do a first attempt of PUD mapping then fallback to PMD if that fails.

Indeed I don't know whether such fallback would help in our unit tests. But
logically speaking we'll need to look into every arch's va allocator to
know when it might fail with bigger allocations, and if PUD fails it's
still sensible one wants to retry with PMD if available.  From that POV, we
don't want to immediately fallback to 4K if 1G fails.

Thanks,

-- 
Peter Xu


