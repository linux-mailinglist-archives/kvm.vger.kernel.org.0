Return-Path: <kvm+bounces-39308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 311D5A4688F
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 18:56:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B36381888B63
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 17:56:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F40822A7E3;
	Wed, 26 Feb 2025 17:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QmUTRCZR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963B722A4D9
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740592551; cv=none; b=bU7nZ1WfvJmP8/RRot2YF0Jf9itsUB7prJjysydx5nXIFZdglXZ1YzEhVl+phAv1SdQck30+q0GkSG+gjEGr7dj1fSf8sdTx3kh6XLfo5/lIv9YKDy/XgL8/+7+3JzYnGiNqaIhaCIkscWcna89WXwqYCIYqdlWh3DrG9ut+Vzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740592551; c=relaxed/simple;
	bh=jKWuuJWv6A+vUltg7krISG4nDtKKTEvwhC3/E1ZD+sY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J97Z0muQvt/VAuAunOX8G6zrvotbNu2KbPLY6/TUjY+ebSAV+CSUrrtDqLJxpjhXhp34D0CRbjYJFPKmjfIeVoWBYzVfW58XRWjyo3aysa4Nha/6T6smdGH2wyLfoVqizOmOBS7QTP3wNM8VxDz7UqZnNJnZx6IGFnGxUBt0sww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QmUTRCZR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740592548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l5deIFWf7QW+foShMtc0J6gQh0z1hOsU2aErwIMaqEs=;
	b=QmUTRCZRzq18DPHSDt8Nx/ChUGy1Q+IR4ZkBgEuFYxfDHYS2tdz/QOyi5/X1XYGBc8t8S4
	yudu4DT/RQRincn2VCdavEOkQ1Yqlh46jL0tjWzwSSZt68BtjJ5eNYrvQmqFWd1OTlJGda
	MwxAAmbas9ZoihrSs+LXbZ2opO/KTaY=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-1C4sUJY-NyW4vbRPEPPQTg-1; Wed, 26 Feb 2025 12:55:45 -0500
X-MC-Unique: 1C4sUJY-NyW4vbRPEPPQTg-1
X-Mimecast-MFC-AGG-ID: 1C4sUJY-NyW4vbRPEPPQTg_1740592545
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-855b7b526fbso860839f.1
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 09:55:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740592545; x=1741197345;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l5deIFWf7QW+foShMtc0J6gQh0z1hOsU2aErwIMaqEs=;
        b=N/XkgoCyJ6sl6S7aFSLVk0FFxlUITQTVOFekQtND8AtqR6mR1X4x5febmn9SovYDYk
         XFUFloiWzstAy+M6ykqw7amDrvzM0sqkvlJ5b+W5feVFace4Wphi4ese+eEk66Jo46X7
         Z0E0XqGpvhb8LaxDffFni9swVy/yLnvaldcVzhnTnssSzMeRvNEfhHyldKFMmCXkil2N
         uwAjCJvFLdt28RSnytEL4HMWpi8sZinXzbHlknj+Q9qT0PfCZPTlKmvLr9ZNfXX4cqjR
         Vz5qnhPNtc+mz5r4L5OXs17HB8U5/4sTcivqNsvUYfOeDR9QtuGo0H0qmJ1/6QIdAuCM
         gTJg==
X-Forwarded-Encrypted: i=1; AJvYcCXr82xhHpAOGBs8WeKVywscsC1Zi6T2lbW8Mvqe/4T7OG4Z/2GMJP3DtVC28bzrxtxDvNI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzwxq91GO/6xk04NN6daD8J9RpB/ntSDK0jLA/6qvvgo7ffSkas
	m0KItNGsXsYCY2Bk/W4OCwT3/Awuf/7cTSLcy7mKtgsbLaP8uMCpRx/JxqBUPG3lb3FcAmTjVpk
	cVDUOjlSkqyCbfLpDYE8bXo7+1jtpvoCkubvSxsONXt5XOcqTkQ==
X-Gm-Gg: ASbGncvnBn13P45w9wDoC56v1VUH5tzXXOHmM6Hcmz4F7dzs+VULdIs8brb/Wk748Hr
	EEBHt4vj7m3kk1Py+Y8m2KbJZU5mMfJy8zP20gMfBmb9SEUw8KPxU3zcY+xREZJQOOxtXZGclpf
	EmoY+Zn6ZG9LiqpL5TuzCGtFUIAdsjt8nH8yGP8tnmmQH3jcWsAQhmCYIjeDTxnnEmw1Qo/dRTn
	53CezjdGwBuMFNKzfvZkbHU6fyXGQ0tfl9CLKJB0udr7UiePwOnfYw5Uwl1syysy9/KSjBSk1Tq
	Pzh2LA5Xc8I5nGfYOvE=
X-Received: by 2002:a92:ca48:0:b0:3d3:dcd5:cde5 with SMTP id e9e14a558f8ab-3d3dcd5cfddmr1419245ab.4.1740592544904;
        Wed, 26 Feb 2025 09:55:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGLi9toGQNcAOsQjLNocJqsr2fmMBl60KY6Tab7NdzqDWlTOWNKvbA3zWCXMh0ikHg+n0TqbA==
X-Received: by 2002:a92:ca48:0:b0:3d3:dcd5:cde5 with SMTP id e9e14a558f8ab-3d3dcd5cfddmr1419175ab.4.1740592544567;
        Wed, 26 Feb 2025 09:55:44 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d367fef1f5sm8799375ab.62.2025.02.26.09.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2025 09:55:43 -0800 (PST)
Date: Wed, 26 Feb 2025 10:55:40 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Mitchell Augustin <mitchell.augustin@canonical.com>
Cc: Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, clg@redhat.com, jgg@nvidia.com,
 willy@infradead.org
Subject: Re: [PATCH v2 6/6] vfio/type1: Use mapping page mask for pfnmaps
Message-ID: <20250226105540.696a4b80.alex.williamson@redhat.com>
In-Reply-To: <CAHTA-ubiguHnrQQH7uML30LsVc+wk-b=zTCioVTs3368eWkmeg@mail.gmail.com>
References: <20250218222209.1382449-1-alex.williamson@redhat.com>
	<20250218222209.1382449-7-alex.williamson@redhat.com>
	<Z7UOEpgH5pdTBcJP@x1.local>
	<20250218161407.6ae2b082.alex.williamson@redhat.com>
	<CAHTA-ua8mTgNkDs0g=_8gMyT1NkgZqCE0J7QjOU=+cmZ2xqd7Q@mail.gmail.com>
	<20250219080808.0e22215c.alex.williamson@redhat.com>
	<CAHTA-ubiguHnrQQH7uML30LsVc+wk-b=zTCioVTs3368eWkmeg@mail.gmail.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 19 Feb 2025 14:32:35 -0600
Mitchell Augustin <mitchell.augustin@canonical.com> wrote:

> > Thanks for the review and testing!  
> 
> Sure thing, thanks for the patch set!
> 
> If you happen to have a few minutes, I'm struggling to understand the
> epfn computation and would appreciate some insight.

Sorry, this slipped off my todo list for a few days.

> My current understanding (very possibly incorrect):
> - epfn is intended to be the last page frame number that can be
> represented at the mapping level corresponding to addr_mask. (so, if
> addr_mask == PUD_MASK, epfn would be the highest pfn still in PUD
> level).

Actually epfn is the first pfn of the next addr_mask level page.  The
value in the parens (*pfn | (~addr_mask >> PAGE_SHIFT)) is the last pfn
within the same level page.  We could do it either way, it's just a
matter of where the +1 gets added.

> - ret should be == npages if all pfns in the requested vma are within
> the memory hierarchy level denoted by addr_mask. If npages is more
> than can be represented at that level, ret == the max number of page
> frames representable at addr_mask level.

Yes.

> - - (if the second case is true, that means we were not able to obtain
> all requested pages due to running out of PFNs at the current mapping
> level)

vaddr_get_pfns() is called again if we haven't reached npage.
Specifically, from vfio_pin_pages_remote() we hit the added continue
under the !batch->size branch.  If the pfnmaps are fully PUD aligned,
we'll call vaddr_get_pfns() once per PUD_SIZE, vfio_pin_pages_remote()
will only return with the full requested npage value, and we'll only
call vfio_iommu_map() once.  The latter has always been true, the
difference is the number of times we iterate calling vaddr_get_pfns().

> If the above is all correct, what is confusing me is where the "(*pfn)
> | " comes into this equation. If epfn is meant to be the last pfn
> representable at addr_mask level of the hierarchy, wouldn't that be
> represented by (~pgmask >> PAGE_SHIFT) alone?

(~addr_mask >> PAGE_SHIFT) gives us the last pfn relative to zero.  We
want the last pfn relative to *pfn, therefore we OR in *pfn.  The OR
handles any offset that *pfn might have within the addr_mask page, so
this operation always provides the last pfn of the addr_mask page
relative to *pfn.  +1 because we want to calculate the number of pfns
until the next page.  Thanks,

Alex


