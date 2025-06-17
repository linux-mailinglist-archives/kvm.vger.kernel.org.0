Return-Path: <kvm+bounces-49767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1C3FADDDC2
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 23:14:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03CC4400704
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 21:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FAC42F005B;
	Tue, 17 Jun 2025 21:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K0yb/Up9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8F32EF9CB
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 21:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750194850; cv=none; b=V2q4EEWOC76m0/sMIuZg74vuld858FWS+T8Wq5iObmL0tYua3bUMGhWN+jQXxhBvYlCkFPHkxd0V++bCL1RG/TPCEA/VbO9JJuqotU+n08WJH4IhwsIKvQIS8tns4WPnasrlLIjZ1GZtoNx6ILqaShn+SWIaXY5pe9omyHvgQLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750194850; c=relaxed/simple;
	bh=SrRpeaxXNGWfFb/1PTz2R6YEk4t6TG0fvw2R3i9KdSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wm2wZ5aNDtLagBr4pHmHxaA4YMYfK+BGkJtjDhKnYNbFhaJeFaE0Rw/MuRdtX7EqLx3iP55trV0tWJXIP6ivpvfAxT2aqcBufbK7CFXDXMb8BJIsiwuD3AmxjQsFsfYyi7lHNsubTrlywrkZaMtZE56RwpkpA5tAUK7sNwLHp3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K0yb/Up9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750194846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5xyVcI21nsfxdfOvk8Q+hN3uxkhpR2sAV2MrhUYOX6E=;
	b=K0yb/Up9lbIzjWgeo6mRNMIk1HCdYFCOnqUuzW97+qsYabWsDYXE/v7pdL2g8yLKDD9Qpt
	n95IC7qDW3NYfclmmrOfOm+jJW3/7xiHH0uEt3SJO6IJRB6TW0Y9jRa3w7MhUWYN7Z8gft
	vYzg4EHqbxbapTsy1qMPMyFHRnj0CSA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-E5OnAabsNPi3_-cwYIu-lA-1; Tue, 17 Jun 2025 17:14:03 -0400
X-MC-Unique: E5OnAabsNPi3_-cwYIu-lA-1
X-Mimecast-MFC-AGG-ID: E5OnAabsNPi3_-cwYIu-lA_1750194843
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6fb1c6b5ea7so94461856d6.0
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 14:14:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750194843; x=1750799643;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5xyVcI21nsfxdfOvk8Q+hN3uxkhpR2sAV2MrhUYOX6E=;
        b=coJo6F9qyvKF9m2N29F0Y29CQR2zLtdI7LaO8Qy92AqRsRjmDJp4pUx6sZPfgnyiOV
         mD7NSz3Xd8ywfa7TaYhrmDOhwvreD5OJ5WPQlQlcQHxgbaXEA0aiD063hXSO4YoWtcEt
         az0iU/dhKkPAFlm85uOhz0NU/0loC5LWkeqyp+1zYV5rIPNgw63emRQ3i4XNBvG89Alq
         /BVTBCqU52BPJ3dbX+mv1SsTiNS0YgOoLe26vUrARoUUXmYVQK++2XbecmnSrXMI80iM
         oEmvTdlgHnrtJqv31XBcEi0ivSQ9q+c/yKUA/Ln0DxMAZzdNfQeXhdSR79kEUOTdczcd
         hlLA==
X-Forwarded-Encrypted: i=1; AJvYcCUsEGS8UtMTm/V7PygETYZe3zK+rNHWNaILaIbh4pd9djqVZLsnfoBm23cynuVM4iYL42M=@vger.kernel.org
X-Gm-Message-State: AOJu0YymW1oZnK47QZOSUBznVuzaX2J/ak86ZW/dSlR5Nc/U9BV9kg2Q
	sXrUr62J4DmwMQ6ELK5GHobN8MF+bNWcA/7z8jCvU+JdtYOzHCDq6f/r2c0X96nFykIVuxIl93q
	YBQpK87DeoJcRdDjkPd+si/rKgKp8oK1SVqBZ/bk1wkPgO9pqUDMAgg==
X-Gm-Gg: ASbGncvUf6ETthTtn0NuAxesb5WYNoS/uM7XPr7kMUIXz/YWol6oUX2USaaS5T8BTWQ
	EYsY4Wv2qTpFlrzyT/JcwAnlFL0bMo4Cb8KewwlLZz1/Y7v+t93bczsvxT5tD3P10XibpCPuUFl
	bSGSMb3VbV7qpyx0111/d+K/NKs2KWLEhi/ocMYjvNJCetgiHipbHQtB+wKITJ+THUma8JxBLDE
	KnH0M13eNmUX5wJg9FPzsqGVsqYeRxKDWy9tG7AUtDypsXyxrIqUMsqvQ3gRJyyOyaJny9h2WNc
	OgjM/ardZK5mUA==
X-Received: by 2002:a05:6214:5c47:b0:6fa:fddf:734b with SMTP id 6a1803df08f44-6fb47778883mr208411036d6.24.1750194842854;
        Tue, 17 Jun 2025 14:14:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGd9iW2NHB23PfBNcvXV74RskpHtC25owk7vFs1c30i5QjvUnprzErLHz+PlrbZV3IBT1BdGg==
X-Received: by 2002:a05:6214:5c47:b0:6fa:fddf:734b with SMTP id 6a1803df08f44-6fb47778883mr208410726d6.24.1750194842564;
        Tue, 17 Jun 2025 14:14:02 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d3b8f2c4d3sm690671485a.116.2025.06.17.14.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 14:14:02 -0700 (PDT)
Date: Tue, 17 Jun 2025 17:13:59 -0400
From: Peter Xu <peterx@redhat.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 1/5] mm: Deduplicate mm_get_unmapped_area()
Message-ID: <aFHal-sGQfrdpztL@x1.local>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-2-peterx@redhat.com>
 <20250616090134.476427c0@pumpkin>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250616090134.476427c0@pumpkin>

On Mon, Jun 16, 2025 at 09:01:34AM +0100, David Laight wrote:
> On Fri, 13 Jun 2025 09:41:07 -0400
> Peter Xu <peterx@redhat.com> wrote:
> 
> > Essentially it sets vm_flags==0 for mm_get_unmapped_area_vmflags().  Use
> > the helper instead to dedup the lines.
> 
> Would it make more sense to make it an inline wrapper?
> Moving the EXPORT_SYMBOL to mm_get_unmapped_area_vmflags.

Yes, makes sense to me. However that seems to be better justified as a
separate patch.

If you wouldn't mind, I hope we can land the minimum version of the series
first without expanding too much of what it touches.  I already start to
regret having the first two patches, but since I've posted, I'll carry them
as of now.  Please let me know if you have strong feelings.

Thanks a lot for taking a look,

-- 
Peter Xu


