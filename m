Return-Path: <kvm+bounces-25215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A0BA961A2D
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 00:57:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C0651C22D1D
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 22:57:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D4E51D4168;
	Tue, 27 Aug 2024 22:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DQAGmMB0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25BA64A
	for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 22:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724799450; cv=none; b=bp0bM9FUpZhtnkT9vn3yKTYL+dRNYrxzPoUqphDoTadOdop8carJzeaFnEUZiNpypAeHmaFRpB2+7yv0gJoyAWhodbLuJpH1+JF0D3ek3MxKZa3it6H/CMRvUqmsBzIP6OQroTo7AriIJPjnCZ4hxYJKDPfXpqg8q3zJSh9YnT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724799450; c=relaxed/simple;
	bh=+5KSSJmpv92zQCwlRGk1Ci3RpieYCmpb/rqeFlbM700=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uJpj2uAswjQpSE6usJsp7jd47rtt07XbV1B+8319C7bcU6fqqD/Exu9UliMY1/5NuQHR0v3h9o2/6D2mCveO98Lfd9hP4t/Hr6tW+Bwv1IhOXmbsMgjaAJfQ9Su58KO1WDmkuAb6SwAsmrcRgwzAsMw9eQRKBiH4C9qeKmwW2pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DQAGmMB0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724799447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AK6C3A50tnsGBsRCbow729A4DBuHr+gMMuMlTEw8uyc=;
	b=DQAGmMB0UfGxP9ULVum2HSSHeVgQn4PSYla4pjuDqJr1krq7q54/Fzt2GyPojFfralQ+1Q
	SuFYn5deVQ/sSIc03uR4Fqe0P6IbAF3qw2tEO02VtvaN4Vvcbu61Ic2McksJWPMsm5EMSH
	MKdW7a5MU0f94/1gieiZnNLmbJ1A7Ec=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-wt1u-VmANDq291dmS4u_ig-1; Tue, 27 Aug 2024 18:57:26 -0400
X-MC-Unique: wt1u-VmANDq291dmS4u_ig-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7a7cb12345fso635744485a.1
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2024 15:57:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724799446; x=1725404246;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AK6C3A50tnsGBsRCbow729A4DBuHr+gMMuMlTEw8uyc=;
        b=MgpS8jy+RdPVMoP4nYFT/oHSIzdQp5BZVOSHup5BlTAbV6XIs7UNlBbKvTuMRy/ol/
         RQKYKbe7oiHIFKVjYaO55GS3ipDGxUZrqBEVMgAoJyT8dOqNJHt15zlr/gjQkLR8taqu
         NM7uQRg5m1biR4DtFm70lsL2D/ZtzA43LEMLoQoZMf6gVZGBguA4lO4d/vdA7engqQRU
         9lV19VrLqkVxTMXfoxEI1goh757pRFG7x639n5oIya7+VouPSCcw/QZVynWZ+XxeWb7U
         rIC1T23ERdF7U5v071fuBUsyc/C4dRoC3+BN1M01VashLZU6Jxma4oQkoO98w03OAe04
         GNfw==
X-Forwarded-Encrypted: i=1; AJvYcCV2+glJzSbzlGMmbWRH+kS5rVFtemEBTRLscRIRBs8JE+mg2y9VY0kBu2OSQkqEOMI4lEQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFnsr5IBJp21W6twb/lfAo/Pp66ijaBhMOAkczvfpdj7U5bImT
	++3oLimTR6pwkww3ZqhGngsdvth+dL0vngjR4DYp8kErbipl5x9HkpcEpmz2vRMKiTJe7EQHWNN
	JKS7F4N3Y2jJAS7BlrQo4waheR54mw3aB6sueGCa9fLEoHivixw==
X-Received: by 2002:a05:620a:294a:b0:79f:d0f:2b19 with SMTP id af79cd13be357-7a6897ac51amr1874152085a.68.1724799446107;
        Tue, 27 Aug 2024 15:57:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFI4+OTLE/+AELbN/FBXKKldemh+MzRZdeNQ6HQxBpbtU51+fjlWi4bBqNnU0zHwgoZ09GhcQ==
X-Received: by 2002:a05:620a:294a:b0:79f:d0f:2b19 with SMTP id af79cd13be357-7a6897ac51amr1874149285a.68.1724799445728;
        Tue, 27 Aug 2024 15:57:25 -0700 (PDT)
Received: from x1n (pool-99-254-121-117.cpe.net.cable.rogers.com. [99.254.121.117])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a67f3dc360sm590479185a.88.2024.08.27.15.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 15:57:25 -0700 (PDT)
Date: Tue, 27 Aug 2024 18:57:21 -0400
From: Peter Xu <peterx@redhat.com>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>, Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH v2 00/19] mm: Support huge pfnmaps
Message-ID: <Zs5Z0Y8kiAEe3tSE@x1n>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <CACw3F50Zi7CQsSOcCutRUy1h5p=7UBw7ZRGm4WayvsnuuEnKow@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACw3F50Zi7CQsSOcCutRUy1h5p=7UBw7ZRGm4WayvsnuuEnKow@mail.gmail.com>

On Tue, Aug 27, 2024 at 03:36:07PM -0700, Jiaqi Yan wrote:
> Hi Peter,

Hi, Jiaqi,

> I am curious if there is any work needed for unmap_mapping_range? If a
> driver hugely remap_pfn_range()ed at 1G granularity, can the driver
> unmap at PAGE_SIZE granularity? For example, when handling a PFN is

Yes it can, but it'll invoke the split_huge_pud() which default routes to
removal of the whole pud right now (currently only covers either DAX
mappings or huge pfnmaps; it won't for anonymous if it comes, for example).

In that case it'll rely on the driver providing proper fault() /
huge_fault() to refault things back with smaller sizes later when accessed
again.

> poisoned in the 1G mapping, it would be great if the mapping can be
> splitted to 2M mappings + 4k mappings, so only the single poisoned PFN
> is lost. (Pretty much like the past proposal* to use HGM** to improve
> hugetlb's memory failure handling).

Note that we're only talking about MMIO mappings here, in which case the
PFN doesn't even have a struct page, so the whole poison idea shouldn't
apply, afaiu.

Thanks,

-- 
Peter Xu


