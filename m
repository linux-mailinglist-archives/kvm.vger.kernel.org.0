Return-Path: <kvm+bounces-47163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DBC8ABE16D
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 19:00:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B20F63B2810
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 16:59:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C035027A927;
	Tue, 20 May 2025 16:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iUf63vfp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437DD2797B2
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 16:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747760396; cv=none; b=isCuJudOJv4O8+NUrLFeDH/p5bKmzLLFuxT/O2b5JWmCIQExtLDJ5qoyLxaGCQz37lviJEq2jhVHs9t7AY2/PpB+oOtcBdCjHHH+YFyawz4qFTwF+K4DZKF/l/2UYk59+NUXgWGG6ypVwKZUOCyFzH19OKj31cqSUuTJ1XyqbHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747760396; c=relaxed/simple;
	bh=Jh2BvARYgXxOW9h9dO25z5GwMY969hNL4tjAnGB4lfY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Plv9yDPyIbg+YDilzPnq3KRYE4017HkHq/z7jl3Flin0GpbcT9d8vP+EbPnG3j/UGmpgOO3j4jHAI7T8ym2vcad1n9kLqjxXNDCEONEcaqm3VwSrt32dr1grztQ5ECWyGov3K6NxQVq9RbyElu6KI4zHw53hC8hbw9IVAG3kj6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iUf63vfp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747760394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rEMj9V3JwMyZ4OkKJP+U49jj1V+/NAmehjsFGeGy4Gg=;
	b=iUf63vfp13KaJiaT+HsD+cZmptvVA7Jp7ziFKOmqPQwpdHqvBs++XPMeQPsNGXq3x/igGq
	CN1I6uNIo6Qd7XImllrrGjPfwB/kqxQ9rizYRf/XANPhQDgBMlpcIR4yR95OUALtKL48YH
	hATBCnKY8T0SAI6/NS43XwS+/FurhGw=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-RyIMRWYoOJuHEP0xN_IQSA-1; Tue, 20 May 2025 12:59:52 -0400
X-MC-Unique: RyIMRWYoOJuHEP0xN_IQSA-1
X-Mimecast-MFC-AGG-ID: RyIMRWYoOJuHEP0xN_IQSA_1747760392
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6f8bdefcb39so69137246d6.0
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 09:59:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747760392; x=1748365192;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rEMj9V3JwMyZ4OkKJP+U49jj1V+/NAmehjsFGeGy4Gg=;
        b=tMas+NYrbUfph7IgeQ3jjI4OmejfkmyvdkBh1Fcs3ihxMV8XkC9N2o+eTpRP68N/3J
         1XCZpnr9twYREzaaA87YLzP5uXo7aB3FcUwg5w4vwTqLiU6F+Py2FvAgMCJmtLcfB0jt
         jaq57pcKrxKd1+qcw3vrNIEGmj8v+ohAg6HeixYUdRDIqQx2JhhVEQGs8w5NCVaoRx4D
         8aWHy9RboMJQIyMwmU05DtpOh/17XcBXEoF/oWxDF4ykypRLYDnxJ5HAOp0zPsOwtKmg
         essJvwzyRxSBx631VA3+5GfRfeLm1yoXcUUIh9vzRSkdgVI6eHPHa2LnRCck5Wpm3Q2N
         7cMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXxhvRFoGQAqd9+KQbqenwd0mllyCpVQT9s7Pq3zxkrEEO1JTQBMXFxmW0CcJfwXWsfHY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVKMhM8B3giBO3zLvMBxLHFil6SRdaqoVO14+rwsD6uQl1VI+c
	ji/DTHfb/76WlkNA4aiuMSpBjVTywSZ/wSZJEsaPTVWSAbCMTapHMIxshhZI4bPV32F3LZ6tQDq
	cvJHgOxP6nEYZZcaipgV33j2OIeJUlPb534rVlkfQQOvAd2aai7oNQA==
X-Gm-Gg: ASbGncsVodpk2SM96YPlOKyZ6PHwFqGu7PydbXPssdZgYslx9i5SHvAVQzAN/AcBoB1
	Ckz+Cka5xlHktjxVARskppt7uHCirWiCn3ivuWZAQa+taEvhD2MhpFbeXbdukO7nUDFecsuyQUm
	tsFNUfFq10ldm8UZqYtIP5v+5dsbkeR2psijmAsF614k725jN2arQQ3PeayrDNX3CPJs8DMq6eX
	RFd2nKMwR2WMF6IcA6STvQ9xHvvfW0G2FdOldw1qivM8FJRyX0aD9JVvHT10AmO58Ts2FxPBQz1
	W/I=
X-Received: by 2002:a05:6214:33c7:b0:6f8:ca09:d60f with SMTP id 6a1803df08f44-6f8ca09d764mr183451756d6.10.1747760392250;
        Tue, 20 May 2025 09:59:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH9IfWJXFVUh9zlVq3n1AuEKD6UqJhdqI6hkbwqQIr3nDPfW3C8vHTS4HJ61qbW6AJWrPiEAw==
X-Received: by 2002:a05:6214:33c7:b0:6f8:ca09:d60f with SMTP id 6a1803df08f44-6f8ca09d764mr183451476d6.10.1747760391869;
        Tue, 20 May 2025 09:59:51 -0700 (PDT)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f8b08aed47sm73634666d6.50.2025.05.20.09.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 09:59:51 -0700 (PDT)
Date: Tue, 20 May 2025 12:59:47 -0400
From: Peter Xu <peterx@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: lizhe.67@bytedance.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, muchun.song@linux.dev,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v3] vfio/type1: optimize vfio_pin_pages_remote() for huge
 folio
Message-ID: <aCy1AzYFyo4Ma1Z1@x1.local>
References: <20250520070020.6181-1-lizhe.67@bytedance.com>
 <20250520080719.2862017e.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250520080719.2862017e.alex.williamson@redhat.com>

Hi, Alex,

On Tue, May 20, 2025 at 08:07:19AM -0600, Alex Williamson wrote:
> Peter, David, if you wouldn't mind double checking the folio usage
> here, I'd appreciate it.  The underlying assumption used here is that
> folios always have physically contiguous pages, so we can increment at
> the remainder of the folio_nr_pages() rather than iterate each page.

Yes I think so.  E.g., there's comment above folio definition too:

/**
 * struct folio - Represents a contiguous set of bytes.
 * ...
 * A folio is a physically, virtually and logically contiguous set
 * of bytes...
 */

For 1G, I wonder if in the future vfio can also use memfd_pin_folios()
internally when possible, e.g. after stumbled on top of a hugetlb folio
when filling the batch.

Thanks,

-- 
Peter Xu


