Return-Path: <kvm+bounces-23411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97F449496A4
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 19:25:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C94EE1C222A5
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 17:25:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 508F557CB6;
	Tue,  6 Aug 2024 17:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="BChA6+7H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FE157CB4
	for <kvm@vger.kernel.org>; Tue,  6 Aug 2024 17:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722965098; cv=none; b=B+hzHGi2bKWCPGwmlvE1xrerZ1VFKKRi1dk/FqZ9+dwC5LKmIhnRyjTgw0L1RlS5gSKgaTimpLfLhgguqLpf/heUgJvc/RTqad4/YFlQ78VLFsxLHIg7zww9e7LcX12RBfbi/U1hBQNz+AiWzHWrmucynEZqlnh/DDOvDZpIMqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722965098; c=relaxed/simple;
	bh=MqaKHZxPTEOOQL0dPc8HBy57ffLggZgGByL+56jCEA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uMsiLcnfUqPcBhPUPK4HKOD7paRLY5dTOWrBSXC20Fc8SEfK+1Z4HJcu3/mh/ikEU6dvJYb9nTwqZzusRSW61sPZzmNg69bmoTia29xgAyW1/sTdyF3xQ5gAAB00rtV4RpTksrbsG6S3/G/9zLMxHt6RxiZ3o2OTWrQCy7CMYOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=BChA6+7H; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6bb96ef0e96so5105386d6.2
        for <kvm@vger.kernel.org>; Tue, 06 Aug 2024 10:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1722965096; x=1723569896; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T7HE5qomFnShgNw+dAFpKQn8211Vw3rMqkRCxPcaqwk=;
        b=BChA6+7H/DuZuuDVTwc+kJUGl1JRoCiifBWKlPvb1riMENYJzszeIpxuIsQbSP0+NE
         fBPt2Wv4qvhC3hd4HMT1sbHXF+lV1eSgk/S3YWaVZbx3Kz52S552eGV2lrzXdvzpqe25
         N2dtGTP2NxAQAfLzt+sngLqrmUUhZLOUNvruIytZDoKJLnlEhJuOdtLHP9udVZhhobmk
         4gsORT73GIjgFQgjITxIzWHsj4FqgfA1kk4bwzK0w/HbTlAVGJmN5r9AsqcgZ+8xOtW0
         rkVo9OLabzEE1Jw3cQKEyh8OIuIA03szr+WDoBPvk6iZPOAaOu/PscuJ94rqC4PQzvBr
         8THg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722965096; x=1723569896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T7HE5qomFnShgNw+dAFpKQn8211Vw3rMqkRCxPcaqwk=;
        b=iemd5/VMEpyP/qWOvYmkgJsCAoBpLVVE4k+LiY9XyG5zrJmQfH1D2DJ0uVIGWGeXj7
         9DECKk9b29H4/ehJhKwFaEjQZ2fxEq9qwIXnXhqrPElX2MGw+JfKVYTjjAn92hJl3b+5
         xlPh87J3GMhBgMYc22Ftz4/AqcYmppLQn6DvzYHGhh5oKHKFr93KPhl6+pOWE8P+O65i
         dp77oBarjwPxH0wSib5d7SZbVOBu/72bMYRpboK2qr7Ox0zhUt3RwK3U7+0YCjcTEm3l
         q+1pyXaS15GsQcMsCVewNDJzioL46D+ySP4BaTfSq2iSRjKQwqmfxAwcH1/q8EJ8/zmc
         eyPA==
X-Forwarded-Encrypted: i=1; AJvYcCUFXnsAEvxv+l6l/mQVBKgw5D7Topv4VDx3S2snKGAsgj6mbwfyqEynUW5BS2Nk9E04rUPTMlO4U9CjR4x4fXjkz9EH
X-Gm-Message-State: AOJu0YxrGh3pkehCtFYov63InpGiAkQePN8a/AfFnYM6+YUkB3UcLr32
	kJep3Hf/1ekpTFxHTfvfStNV0V6m5S9wjf7p+ecnrLDlsPjCRC0E1ZLny+MRUuo=
X-Google-Smtp-Source: AGHT+IFa9dVhWCrdPdbUkpdGZrho6h2SYLIO4aEGRVqFcYo1XlMAaNoBZNabBpbHu2isVnX5Mnu2Pw==
X-Received: by 2002:a05:6214:3a08:b0:6b7:9bdd:c5ac with SMTP id 6a1803df08f44-6bb9845d291mr182312036d6.54.1722965095947;
        Tue, 06 Aug 2024 10:24:55 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bb9c86772bsm48644876d6.124.2024.08.06.10.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 10:24:55 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sbNvb-00FYkR-1o;
	Tue, 06 Aug 2024 14:24:55 -0300
Date: Tue, 6 Aug 2024 14:24:55 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>,
	Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 04/11] mm: Add missing mmu_notifier_clear_young for
 !MMU_NOTIFIER
Message-ID: <20240806172455.GR676757@ziepe.ca>
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-5-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240724011037.3671523-5-jthoughton@google.com>

On Wed, Jul 24, 2024 at 01:10:29AM +0000, James Houghton wrote:
> Remove the now unnecessary ifdef in mm/damon/vaddr.c as well.
> 
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  include/linux/mmu_notifier.h | 7 +++++++
>  mm/damon/vaddr.c             | 2 --
>  2 files changed, 7 insertions(+), 2 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

