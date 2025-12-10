Return-Path: <kvm+bounces-65681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 82DD8CB3F39
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 21:25:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7BF70312405C
	for <lists+kvm@lfdr.de>; Wed, 10 Dec 2025 20:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4555132BF41;
	Wed, 10 Dec 2025 20:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B/r4/YZ5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="dq/Eh4uW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5126A320CCB
	for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 20:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765398191; cv=none; b=L5527MuDpQuLHhQceWeZ0J3nyPLhqS6El3uc7PRv+m+tPlI/cRLD5+Dyk0stu4zgU0vebboeuP6gu2KYsj95gjXbD+5RJnKfO3mxg05D2xNPewQfYLlpsdXV7tS4jJi+cTwnslQ+lYzxEJN0N5EU5f4zB1imvOSQvYNmitbPsY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765398191; c=relaxed/simple;
	bh=4biQEPINOrg4CKxgMwHCUpM+UC2ZDmzxUgjLbt2N7cU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p5wiSIf86l5QXrhnJ7XOEQbqCG6Kn6Hlovq6aA6cN96TmUiYM5TaxawIBrmKAH+dJkQQggqt1+qbqOYqvWCq2kPjMZ9EV4U+o6ETIPDdTp+VV5dLEWPlt3VEQV58YyGcifTSNK9EkVSuH1Gvoapusq033WfmyUj6mtd5WOwoT7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B/r4/YZ5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=dq/Eh4uW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765398188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qCVxcy9QRWz5ZYAmOizCoYj4D+NmiFdOKdb5vzD8rtA=;
	b=B/r4/YZ52H4jhqM27AAG00PvVvfTbOl592GtUCoAm8WQpt4uj35Wkhi+q9+m5XKymaddxA
	gyN+rHzAQibtD8nKtQRRqd/+ccJGDYuym50Qo0t61kzqOYU/ylR9+ka03FY9dQGurGsE8L
	YFTbeESrx+r8EEYVDoVoBrncsUIPEuk=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-gcMG05-mORKy4JP_9C4Zhg-1; Wed, 10 Dec 2025 15:23:05 -0500
X-MC-Unique: gcMG05-mORKy4JP_9C4Zhg-1
X-Mimecast-MFC-AGG-ID: gcMG05-mORKy4JP_9C4Zhg_1765398184
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-882380beb27so6871536d6.3
        for <kvm@vger.kernel.org>; Wed, 10 Dec 2025 12:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765398184; x=1766002984; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qCVxcy9QRWz5ZYAmOizCoYj4D+NmiFdOKdb5vzD8rtA=;
        b=dq/Eh4uWIeu8k7J92gSKsn+3ssZYXV3VDFFy+jM8Xi7mN+Pbhdl2aoRw6UaSuOw31U
         C63f6bhL8SgEs8xTNF54ag7tXx6m+jpR8jsDcs0pm6G9oWPANYU9GKtzv94FAhw5l5/m
         F1fMfKHPOnaIL1yEFong0yDL24eh2N7JCzAiZhwskczan4FwamKY3eLOItoWaj7PQx8b
         lV+Xn9OF5eyclq9zlY+yINnHki++3xkWCTurrIAb/V1LJ/n0Qas/YLY48LV0DvrCtmUj
         NgRnyf2aY381MswiiwDZHf6SH831jz18m8vDn4qcerfEa+RJxoVJuoWEW3BiCickGTWJ
         uj0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765398184; x=1766002984;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qCVxcy9QRWz5ZYAmOizCoYj4D+NmiFdOKdb5vzD8rtA=;
        b=oyPszO4UvvfPu3l1n88VYHXEnWyzr0Bx9w5BruyFywzI9TGO52X2wpbxQYxpkNBHSM
         uiUoKkUtXBbqkvwUYtfunv4PoLEn5cXz0EDgXWRBn78yvGt7E53p276Kb+V73FO4K+ab
         IoTlKM3hnUsw55g1GS7BEA9L0XewdzKsp88CvZudGhbFDqibF4YSCFAUfOoV1K4jtKQf
         HN5LqfPXk6r8dqb3Zy77LRuN0w42KSe0kT3eYNsLp2R6paXedaevg+Eb3SY7epLrYrZE
         InkzfljYtLOg2mFwXwlu4oYI0LogLWG0x4ot5CytMQ+UktE377cSy2M3/oOvWNFtQ1/n
         zGAg==
X-Gm-Message-State: AOJu0YwyivPOHvoRCLfpuIiWrDpDszG3BKDIivjJ9qSPlcjQOESxrOYU
	1+oSVAB6j3kFsudgDjpOTZUDIAx6KTQlPv805hNAl2vqWHigip/c/TMw5SY8slj/h5fzO6mnHQR
	dLuOBQ8hk+seC5RxOSnCAArsR1H/LWQ78g/pXIQmBJU55Vn1VXYw+SQ==
X-Gm-Gg: AY/fxX7yqiDZFVQjzU7CM0PNiVyfGMw+eoDD1V/Zn/AYbjXpYcoArvKRM1dpKYxhPUH
	e4YQ8w2YwycfH1zn/Z/wyyl8CbjxnXNaiNHa7BkdMnOk/IHHeYAVX+8PajFwk253xrfNX4IaazN
	u88pm+fM3R9pTDOpi/u5+UNE7fF15qf04hbR4Cs2rqvMkQhPNEP5ZlQRuRPIvj1C5Q4Zwl+u2Xy
	mt4TxVoCHs8sqxN4fQqjIST1uPsjDTNUL7uTCjcTJptZ1rC6tLxmXv131wJeOdWpWmoPPXWpuC5
	6l3UrVLjUuv/umDAgjeQI30LF/C8qMzOyh/zi5hZOo2KoFMDzUDOyf1587O5YXMfX8+6DZw7toy
	/7fo=
X-Received: by 2002:a05:6214:4903:b0:87d:e32:81c4 with SMTP id 6a1803df08f44-88863ad08cemr52863416d6.48.1765398184392;
        Wed, 10 Dec 2025 12:23:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEen9Ttl4I4Ei6GHZ1MxrJ25bb6YcCEXyK7UMXPPB/FWpCm+gy8UvSEyxIjsONMA4wz0hEVYw==
X-Received: by 2002:a05:6214:4903:b0:87d:e32:81c4 with SMTP id 6a1803df08f44-88863ad08cemr52862896d6.48.1765398183866;
        Wed, 10 Dec 2025 12:23:03 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8886ec567dfsm5133986d6.22.2025.12.10.12.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 12:23:03 -0800 (PST)
Date: Wed, 10 Dec 2025 15:23:02 -0500
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <aTnWphMGVwWl12FX@x1.local>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-3-peterx@redhat.com>
 <aTWpjOhLOMOB2e74@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aTWpjOhLOMOB2e74@nvidia.com>

On Sun, Dec 07, 2025 at 12:21:32PM -0400, Jason Gunthorpe wrote:
> On Thu, Dec 04, 2025 at 10:10:01AM -0500, Peter Xu wrote:
> > Add one new file operation, get_mapping_order().  It can be used by file
> > backends to report mapping order hints.
> > 
> > By default, Linux assumed we will map in PAGE_SIZE chunks.  With this hint,
> > the driver can report the possibility of mapping chunks that are larger
> > than PAGE_SIZE.  Then, the VA allocator will try to use that as alignment
> > when allocating the VA ranges.
> > 
> > This is useful because when chunks to be mapped are larger than PAGE_SIZE,
> > VA alignment matters and it needs to be aligned with the size of the chunk
> > to be mapped.
> > 
> > Said that, no matter what is the alignment used for the VA allocation, the
> > driver can still decide which size to map the chunks.  It is also not an
> > issue if it keeps mapping in PAGE_SIZE.
> > 
> > get_mapping_order() is defined to take three parameters.  Besides the 1st
> > parameter which will be the file object pointer, the 2nd + 3rd parameters
> > being the pgoff + size of the mmap() request.  Its retval is defined as the
> > order, which must be non-negative to enable the alignment.  When zero is
> > returned, it should behave like when the hint is not provided, IOW,
> > alignment will still be PAGE_SIZE.
> 
> This should explain how it works when the incoming pgoff is not
> aligned..

Hmm, I thought the charm of this new proposal (based on suggestions of your
v1 reviews) is to not need to worry on this..  Or maybe you meant I should
add some doc comments in the commit message?

If so I can do that.

thp_get_unmapped_area_vmflags() should have taken all kinds of pgoff
unalignment into account.  It's just that this v2 is better than v1 when
using this new API because that THP function doesn't need to be exported
anymore.

> 
> I think for dpdk we want to support mapping around the MSI hole so
> something like
> 
>  pgoff 0 -> 2M
>  skip 4k
>  2m + 4k -> 64M
> 
> Should setup the last VMA to align to 2M + 4k so the first PMD is
> fragmented to 4k pages but the remaning part is 2M sized or better.
> 
> We just noticed a bug very similer to this in qemu around it's manual
> alignment scheme where it would de-align things around the MSI window
> and spoil the PMDs.

Right, IIUC this series should work all fine exactly as you said.

Here the driver should only care about what owns the content of (pgoff,
len) range, and the proper order to map these chunks.  In case of VFIO, it
will know what BAR it's mapping, so as to return a proper order for that
specific bar pointed by (pgoff, len).

The driver doesn't need to worry on anything else like above.

Let me know if I misread your question, or if this series doesn't achieve
what you're asking here..

Thanks,

> 
> I guess ideally the file could return the order assuming an aligned-to-start
> pgoff and the core code could use that order to compute an adjustment
> for
> the actual pgoff so we maintain:
>   va % order = pgoff % order
> 
> Jason
> 

-- 
Peter Xu


