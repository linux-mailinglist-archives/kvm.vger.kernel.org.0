Return-Path: <kvm+bounces-29113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0CB29A2D78
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 21:11:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7782F1F235CE
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 19:11:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AE992204DB;
	Thu, 17 Oct 2024 19:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A7hm5upB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C4C21D2A3
	for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 19:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192281; cv=none; b=Gmwue+VKZ11DcnnnD5X5WRPDJOp6jecc9UkcvA/2JZ+inzzwJaRTqGn6hvrziwxfnwEZl1fH+efu+uIagfZT97x7HrZMuLOtlcwzw8eDJPr9NVVAcSgW42Q1vnmmN8Vi/TJv02Cwha603b+VcZTCVdm0MlHfI43dq7jyXFdAyD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192281; c=relaxed/simple;
	bh=hcSnhusDnzekwr4ikkkXoQOJfK5bGeBFS4Sx6s5jV2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=phlMTRMgrsQYyzOjs1iW2bp11zwOMslG01X2SL13hXrQS9sdQfhkBOIJn2jajRk2STtWmrdNp4Wbd6GMGeP/KRrBzQkEPjmBh33jJU9jX71dGCvA0rz1IDuBAGyo/uxpTgDUJUFMayYKSv2zN4kUrV3EAEFJqaLlnWgZ0533QV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A7hm5upB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729192278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ENOjaNeBX4g+6hbHPWlxkYnjEgbpAhFHbENRWbsgfbY=;
	b=A7hm5upBMwy6xajwd4vLf85GDl+eChuK9rghLPB2LHRmwkA+rx5D2m3XPD8cgx6bu+bOrg
	kHPSbxo6HMLRj1rjkY21GhIb0G2BFHPzECbBKS1Ni7ntEEzLJsltYmpuvRenfbGQmV1trL
	5rDgvBjm9s3ZBfWBTR87zJTVgMI100A=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-xk7C3gFlNMm9bCrNwbRKZg-1; Thu, 17 Oct 2024 15:11:17 -0400
X-MC-Unique: xk7C3gFlNMm9bCrNwbRKZg-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6cbec7fbf1cso17451046d6.1
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2024 12:11:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729192277; x=1729797077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ENOjaNeBX4g+6hbHPWlxkYnjEgbpAhFHbENRWbsgfbY=;
        b=gHPMucKRWdZIBtsUGVSzakytAyiE7M6977TGKQn3mh/c7JKNFepkJ1AAWriUYsYkMH
         syCLjZcU0We/GN60QkG+HehsqAHdPBAsthk8TwMwnEdThvVWwDvzcTUNzyasIvH/BC+c
         3Ihsg9msqPshtHiRgsD8EkvO/UM9ipPZfq/luNO6KzIJ/mhyk86xQ7qYGE+Y7K3cH1Qb
         5dq95b0G6seJVwyvB9DvXcugWkClMub2v12qrkAyD3b3ku/UiD0yPw3nYWfJ058KXxh5
         ltS3eo8D7FLmg0GwU6kvq6jo1cy6Oq4dOjBNTV+P8ZcUxanAT/WhKgTwilTP81p+7AL9
         ETMQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHBBbszkdYps9ofbDSYbltAPVucPcEsloHNhuTLSKDxYliBSksMo78GNxvQeG6xbaXQhE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1qQCZA437ob14+6+DVf65LTWWxEfiEDGWLPyFqKSNqcFXiQ96
	KRmifiodwKJaJMjhwXa5JsCzQScq517yZ48E0E7xfDAbt4NwMn3B1LxI3Vn6Xk45IC7jRC54Ktc
	Mf2opankgnxRd/R/5tcnL/tBNgBaXNYQ446DmxpPN1ZQxFLLjCg==
X-Received: by 2002:a05:6214:4984:b0:6cb:d583:3765 with SMTP id 6a1803df08f44-6cbf0003300mr291066446d6.1.1729192277035;
        Thu, 17 Oct 2024 12:11:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8+4MNI4FqCiYZuqBBeWgc19wifz1OLKYbCakcqMhYRU1GwBxzDpLpZYujB2+NGQzmuJpFGw==
X-Received: by 2002:a05:6214:4984:b0:6cb:d583:3765 with SMTP id 6a1803df08f44-6cbf0003300mr291065846d6.1.1729192276677;
        Thu, 17 Oct 2024 12:11:16 -0700 (PDT)
Received: from x1n (pool-99-254-114-190.cpe.net.cable.rogers.com. [99.254.114.190])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6cc22959ae2sm30837856d6.93.2024.10.17.12.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2024 12:11:14 -0700 (PDT)
Date: Thu, 17 Oct 2024 15:11:10 -0400
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>,
	Ackerley Tng <ackerleytng@google.com>, tabba@google.com,
	quic_eberman@quicinc.com, roypat@amazon.co.uk, rientjes@google.com,
	fvdl@google.com, jthoughton@google.com, seanjc@google.com,
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com,
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev,
	erdemaktas@google.com, vannapurve@google.com, qperret@google.com,
	jhubbard@nvidia.com, willy@infradead.org, shuah@kernel.org,
	brauner@kernel.org, bfoster@redhat.com, kent.overstreet@linux.dev,
	pvorel@suse.cz, rppt@kernel.org, richard.weiyang@gmail.com,
	anup@brainfault.org, haibo1.xu@intel.com, ajones@ventanamicro.com,
	vkuznets@redhat.com, maciej.wieczor-retman@intel.com,
	pgonda@google.com, oliver.upton@linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 26/39] KVM: guest_memfd: Track faultability within a
 struct kvm_gmem_private
Message-ID: <ZxFhTtEs2Mz7Dj-O@x1n>
References: <diqz1q0hndb3.fsf@ackerleytng-ctop.c.googlers.com>
 <1d243dde-2ddf-4875-890d-e6bb47931e40@redhat.com>
 <ZxAfET87vwVwuUfJ@x1n>
 <20241016225157.GQ3559746@nvidia.com>
 <ZxBRC-v9w7xS0xgk@x1n>
 <20241016235424.GU3559746@nvidia.com>
 <ZxEmFY1FcrRtylJW@x1n>
 <20241017164713.GF3559746@nvidia.com>
 <ZxFD3kYfKY0b-qFz@x1n>
 <20241017171010.GK3559746@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241017171010.GK3559746@nvidia.com>

On Thu, Oct 17, 2024 at 02:10:10PM -0300, Jason Gunthorpe wrote:
> > If so, maybe that's a non-issue for non-CoCo, where the VM object /
> > gmemfd object (when created) can have a flag marking that it's
> > always shared and can never be converted to private for any page
> > within.
> 
> What is non-CoCo? Does it include the private/shared concept?

I used that to represent the possible gmemfd use cases outside confidential
computing.

So the private/shared things should still be around as fundamental property
of gmemfd, but it should be always shared and no convertion needed for the
whole lifecycle of the gmemfd when marked !CoCo.

Basically, that's the KVM-only hugetlbfs v2.. especially if this series
will move on with hugetlb allocators, that's even closer.. which makes some
sense to me at least for now to avoid reinvent the wheels all over the
places over cgroup/pool/meminfo/etc.

-- 
Peter Xu


