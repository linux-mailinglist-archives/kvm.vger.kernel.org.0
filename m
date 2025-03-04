Return-Path: <kvm+bounces-40094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 83670A4F16B
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 00:25:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69B1C188C120
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 23:25:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FBD827BF7A;
	Tue,  4 Mar 2025 23:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FSH7mami"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B1927935D
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 23:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741130689; cv=none; b=p+bvGWwh+pTPcJhReZc8qsuAeYjV6Ez24QggRb1W+CBnWDALnKGgat/Z2eplolMLmK1aMUq05SylzSA2mYoHqQ3omE4SU3Y8b7/aK6KTVSAQOZ2t7MdB/PaF9CxMdZyqas7UBgagCsIeB5Phw4BrXNOIXID8VxfC+x97NqTo5UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741130689; c=relaxed/simple;
	bh=ft4BPe47zhRld0rPUuffwsZAusYgbs12YAc92bs01Gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i6fBv/JVLQpdoync3iSwYFXBTl9mLtFBGUNFXntx+5ConJwTdJpBVcoLU+BT3bPGI+udp2mUzrN4/Y/8qYPMkrXaq2aMtmy8LSu/nIkWOh8wDsrZGLr/3JhLMG6s3nMdNQca2fVSK4+cyoJUuBh7yqHC3o90mpzghOGUKHnAsaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FSH7mami; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741130686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=srEgUoPvUOjlJVSCl5jmznUtYK/BU6V0NKB10e7D9Q8=;
	b=FSH7mamiLTbhi+2pc23B/EzwqTBJFac5e5sFgimn90Yn8XsV87NN61f2iUbjSNrKBHZatV
	PaFjV/fUSR7MxqfQsEqg2ql4ZleUOQUGckrRUr+vvIurnsPgyTQz9MeVzp1/LcATImbhSm
	FOYuM0UMD5clOUEV5/VEuYfW39RxKuo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-mvZlHRleP5ylApWKirYJnA-1; Tue, 04 Mar 2025 18:24:41 -0500
X-MC-Unique: mvZlHRleP5ylApWKirYJnA-1
X-Mimecast-MFC-AGG-ID: mvZlHRleP5ylApWKirYJnA_1741130680
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7c0c1025adbso1544548085a.1
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 15:24:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741130680; x=1741735480;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=srEgUoPvUOjlJVSCl5jmznUtYK/BU6V0NKB10e7D9Q8=;
        b=j1W4cpmRNeYqrdKMEICQdPAXQzUGYSKwP4tByxSZRXdmfkMP+FOuw306pJfiKMigAY
         oe592gxzgj+lN6i2scTjPW3EkSSv1ZhHlPdk1MqBG5aRwJij88ZMP5rw0UyB95yb1PJ2
         ho4IgwJiNy0rZVKTlHeZcKwffdzmRRNLoHmexbQEr7/46hshYo6ZDdbsQ+FKcjktXPIY
         +dl4ZBJaN0kpZqQpiDh0ORLBiA+aF48OGGUKZ0+VJvC571Lqh8E1mp+LZe6waOHk7waW
         oOKe/7SWGyylUMoORHBzGG4Dy3sazEv96+aib8cCeKryRlrMOUzwEQbeW1AePlF5tjxO
         R67Q==
X-Forwarded-Encrypted: i=1; AJvYcCVNsJ37Z9JC8xkVKw9t5EMsk/G1uqMTBl9OcDk2j8lT9RZSOnMubvX8yAov+l+1LWgEv1c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUbJYO7nNOyNu2RLwAXYJ/8TpE/avN16rcRyReZV/1xxc9R9fC
	VeB/taT55UUg4QN3Wuy00hsLsVkU3OgtvvRmRWeBrf3m5irWPmV1eNfSYWR063rrf/iZEK8Oe9R
	rp/7sc1l0kZkzWfGOxotNTW+nGoJSDXWuNrLqnyI9KkhI2GM15A==
X-Gm-Gg: ASbGncugxvzEkmYmowODu0jhZcYXAEp/fO2Id11owwin4gubEXLjapb69J+QsPFbyYz
	RcX9jxAUsJK8Dcnt/91cyDk9DX9mz+h+80ThXEzlQFG9CXcOVOtIDndFNBBZv5vtW7I2uuQGc3t
	0trPNiBnqu2d1X7jRUU1SGo4mKQGLjHouo1Rg3PgqUCaSF/T1WiD09iIm5B2V11hcat93nS968G
	LQNoUMI3IfLh/1lD5khsUceFOYtA1ohv17tN0VvtFk/1iajozEVXZELG4LOkcdqGS22JyOmlWR6
	QosTNIs=
X-Received: by 2002:a05:620a:4c81:b0:7c0:bad7:12b5 with SMTP id af79cd13be357-7c3d8ee13demr168822185a.54.1741130680395;
        Tue, 04 Mar 2025 15:24:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF6MzWOSSNkUTEXlvQ9iJOjQzvGjjEFVSlf2ZUpEyaz6kgQfPIR8TZfY2WcFT4CY7XBnhBEjw==
X-Received: by 2002:a05:620a:4c81:b0:7c0:bad7:12b5 with SMTP id af79cd13be357-7c3d8ee13demr168819085a.54.1741130680145;
        Tue, 04 Mar 2025 15:24:40 -0800 (PST)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c3c3edff13sm266678485a.69.2025.03.04.15.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 15:24:39 -0800 (PST)
Date: Tue, 4 Mar 2025 18:24:35 -0500
From: Peter Xu <peterx@redhat.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: tabba@google.com, quic_eberman@quicinc.com, roypat@amazon.co.uk,
	jgg@nvidia.com, david@redhat.com, rientjes@google.com,
	fvdl@google.com, jthoughton@google.com, seanjc@google.com,
	pbonzini@redhat.com, zhiquan1.li@intel.com, fan.du@intel.com,
	jun.miao@intel.com, isaku.yamahata@intel.com, muchun.song@linux.dev,
	mike.kravetz@oracle.com, erdemaktas@google.com,
	vannapurve@google.com, qperret@google.com, jhubbard@nvidia.com,
	willy@infradead.org, shuah@kernel.org, brauner@kernel.org,
	bfoster@redhat.com, kent.overstreet@linux.dev, pvorel@suse.cz,
	rppt@kernel.org, richard.weiyang@gmail.com, anup@brainfault.org,
	haibo1.xu@intel.com, ajones@ventanamicro.com, vkuznets@redhat.com,
	maciej.wieczor-retman@intel.com, pgonda@google.com,
	oliver.upton@linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-fsdevel@kvack.org
Subject: Re: [RFC PATCH 27/39] KVM: guest_memfd: Allow mmapping guest_memfd
 files
Message-ID: <Z8eLs-53UwKHfEeK@x1.local>
References: <cover.1726009989.git.ackerleytng@google.com>
 <5a05eb947cf7aa21f00b94171ca818cc3d5bdfee.1726009989.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5a05eb947cf7aa21f00b94171ca818cc3d5bdfee.1726009989.git.ackerleytng@google.com>

On Tue, Sep 10, 2024 at 11:43:58PM +0000, Ackerley Tng wrote:
> @@ -790,6 +791,9 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
>  	 */
>  	filemap_invalidate_lock(inode->i_mapping);
>  
> +	/* TODO: Check if even_cows should be 0 or 1 */
> +	unmap_mapping_range(inode->i_mapping, start, len, 0);

Should be s/start/offset/ here, or should expect some filemap crash assert
on non-zero mapcounts (when it starts to matter).

Btw, it would be nice if the new version would allow kvm to be compiled as
a module.  Currently it uses a lot of mm functions that are not yet
exported, so AFAIU it will only build if kvm is builtin.

Thanks,

-- 
Peter Xu


