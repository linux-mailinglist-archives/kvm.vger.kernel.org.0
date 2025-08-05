Return-Path: <kvm+bounces-54012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BF399B1B616
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 16:14:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 31FBF1885958
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 14:11:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E901324168D;
	Tue,  5 Aug 2025 14:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cYrF9sgN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DF21C4A2D
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 14:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754403053; cv=none; b=dP6u0vhwOkHJ2E3cXhyVfUYUtCxmmeERgcEDK08hUFTdYCCIzS2lgPzRM2Ei5BdFiz0jdo3Fmycyp8VgXm37bI1hHhfhGWwdjvsmY7rcBsnypTuzb3tyntPeCfSciZFtxIK6NUZSlU24T45Dim+6wQT0dX2FSr/vHld1yxCCb+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754403053; c=relaxed/simple;
	bh=TsaADbPptyH1cgXg0qVwhNBfnCMXc9onrE46aaSHIIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MYDW1/Y1YazIjzNEV+6/FG9VLYbiVI3UAbR2igYj1WQ8c0V0+3+xYsA/FsaYKp8PDNydmZFbwi3MLq5YUL0hGJGGx83Xx/GbSLp+vL41zgJzSojAePyX/HgtDNWgVup931ofe5oI27dxM+i4tUPxNoHMfYtq3VG/OLjfT+GdX8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cYrF9sgN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754403050;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0m5Gw04UbMRLmAQHZrUFAKCbY0Ac8md2NOdlEcfunIs=;
	b=cYrF9sgNab1FOcvRH6+BjRSq537kXihtLUJ42ht1/h1LIMkyq723CNrnTF16DCs28NaF6r
	jvPMLzoDdTVOu4ADVPmx6eLi/3kHvTIIiSI4g2GSv60DrCpWpJNvq9+aETDZ9I9rEzazx/
	CSXYae1z86op37gnaxXZDob1PVPaDwA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-hb6Q7uARP8i7lZ_fAhn33g-1; Tue, 05 Aug 2025 10:10:49 -0400
X-MC-Unique: hb6Q7uARP8i7lZ_fAhn33g-1
X-Mimecast-MFC-AGG-ID: hb6Q7uARP8i7lZ_fAhn33g_1754403048
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3b78329f180so4083378f8f.3
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 07:10:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754403048; x=1755007848;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0m5Gw04UbMRLmAQHZrUFAKCbY0Ac8md2NOdlEcfunIs=;
        b=Fl1wjsiSnLJq3ug8lAYn19uz/9iCYeVd4v2xhXBiPw5szPL8DgQ4426tapJSMvXc2Z
         AXxRXdHizi4YZNuoNwb7UrU20hQT7Y1Zudbp1eTTfafGJuEqfTkug0TrXv+EbrMl/kjw
         o2/qRdG+9vsGW451y/adgJiAygBOBUA0foB+Fe7BCUicJWZ6iT8qUgnG4WzcfCbFoZ2t
         xSzRSMAQcdxyO5sL9GQVBZ+6fGDpaRmHCTSnTtDcJM68dDz6YV/e3qMWpi79lXLPwCe+
         Nbqr6y3GHoc/yfgZocJ4UNgpuNHmHAmYdy3kowMs9RyFJ2eY+1QmLsQkT/56H+HjgBSc
         jFnQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9q9cljAzYl7y8Jp+CTyR7kA559xS7TVOe+yYNVQJSYLrov6N3L1Cm8sOwtMC4RF2IoWg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwoO2eUsJFVjKVcVXeDNmt4JOx7nn4wGQl539xm58D4jY5r4e+M
	r2ljcoCZzQR8/sPSxRQMsObfhlqG08P0FEtzyq8GbNWS9RIAdqJMOfubdpNRpdW17qyZIW5s7d7
	56NDDrDINKo+gVPtJIIGWJmhpQXr2duO3t+p5VquBoZCePIzoILQclw==
X-Gm-Gg: ASbGncvVQZmDUpYQzRBSzT7WKBfI3yaD5MSa6ZqkqjG0/ZOk2RaocmENqcRK2rSXGqz
	cR+GSf/cfki2BoYSuj9jqRkLpJ62nqzUd6+58fNLkSLukRA2Ry5NNbCjJKzwBQ2aI7Gq+FtWdvO
	uX8Q+kQzHCdxH9CW8LomsKrqUY7BRB/mHIT89mTnAxexGYxsl0vdju71LdGuauf2h5ldc4+Ew1y
	7Y2JPrUTHc/rz+zSdSWV+CQhQozG7gAO9NVgwrd4p/iqkuwY7VEjq3HYT6MouVpacDF1CCYuIU0
	ZVKeMEdb+tq/p8aS2PSo2acY88XLlYVXuc5/qSVWMcipjP51VjDSBGAcgDEATstePq3oifs=
X-Received: by 2002:a05:6000:1a88:b0:3a4:d6ed:8df8 with SMTP id ffacd0b85a97d-3b8d94c3709mr11246744f8f.39.1754403047900;
        Tue, 05 Aug 2025 07:10:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEexNiINw+B4zOB1F3l89SuwXwPjwmOTkxYd/AiBzbluL+XUrha4BO9qng5Gb9r3LombGt9uQ==
X-Received: by 2002:a05:6000:1a88:b0:3a4:d6ed:8df8 with SMTP id ffacd0b85a97d-3b8d94c3709mr11246710f8f.39.1754403047439;
        Tue, 05 Aug 2025 07:10:47 -0700 (PDT)
Received: from [192.168.3.141] (p57a1a26f.dip0.t-ipconnect.de. [87.161.162.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c45346asm19484393f8f.39.2025.08.05.07.10.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 07:10:46 -0700 (PDT)
Message-ID: <44157147-c424-4cc0-9302-ccf42c648247@redhat.com>
Date: Tue, 5 Aug 2025 16:10:45 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "lizhe.67@bytedance.com" <lizhe.67@bytedance.com>
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
 <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com>
 <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
 <CAHk-=wiCYfNp4AJLBORU-c7ZyRBUp66W2-Et6cdQ4REx-GyQ_A@mail.gmail.com>
 <20250805132558.GA365447@nvidia.com>
 <00999740-d762-488a-a946-0c10589df146@redhat.com>
 <20250805135505.GL184255@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250805135505.GL184255@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.08.25 15:55, Jason Gunthorpe wrote:
> On Tue, Aug 05, 2025 at 03:33:49PM +0200, David Hildenbrand wrote:
> 
>>> David, there is another alternative to prevent this, simple though a
>>> bit wasteful, just allocate a bit bigger to ensure the allocation
>>> doesn't end on an exact PAGE_SIZE boundary?
>>
>> :/ in particular doing that through the memblock in sparse_init_nid(), I am
>> not so sure that's a good idea.
> 
> It would probably be some work to make larger allocations to avoid
> padding :\
> 
>> I prefer Linus' proposal and avoids the one nth_page(), unless any other
>> approach can help us get rid of more nth_page() usage -- and I don't think
>> your proposal could, right?
> 
> If the above were solved - so the struct page allocations could be
> larger than a section, arguably just the entire range being plugged,
> then I think you also solve the nth_page() problem too. > Effectively the nth_page() problem is that we allocate the struct page
> arrays on an arbitary section-by-section basis, and then the arch sets
> MAX_ORDER so that a folio can cross sections, effectively guaranteeing
> to virtually fragment the page *'s inside folios.
> 
> Doing a giant vmalloc at the start so you could also cheaply add some
> padding would effectively also prevent the nth_page problem as we can
> reasonably say that no folio should extend past an entire memory
> region.
> 
> Maybe there is some reason we can't do a giant vmalloc on these
> systems that also can't do SPARSE_VMMEMAP :\ But perhaps we could get
> up to MAX_ORDER at least? Or perhaps we could have those systems
> reduce MAX_ORDER?
> 
> So, I think they are lightly linked problems.

There are some weird scenarios where you hotplug memory after boot 
memory, and suddenly you can runtime-allocate a gigantic folio that 
spans both ranges etc.

So while related, the corner cases are all a bit nasty, and just 
forbidding folios to span a memory section on these problematic configs 
(sparse !vmemmap) sounds interesting.

As Linus said, x86-64 and arm64 are already VMEMMAP-only. s390x allows 
for gigantic folios, and VMEMMAP migjt still be configurable. Same for 
ppc at least. Not sure about riscv and others, will have to dig.

That way we could just naturally make folio_page() and folio_page_idx() 
simpler. (and some GUP code IIRC as well where we still have to use 
nth_page)

> 
> I suppose this is also a limitation with Linus's suggestion. It
> doesn't give the optimal answer for for 1G pages on these older systems:
> 
>          for (size_t nr = 1; nr < nr_pages; nr++) {
>                  if (*pages++ != ++page)
>                          break;
> 
> Since that will exit every section.

Yes. If folios can no longer span a section in these configs, then we'd 
be good if we stop when we cross a section. We'd still always cover the 
full folio.

> 
> At least for scatterlist like cases the point of this function is just
> to speed things up. If it returns short the calling code should still
> be directly checking phys_addr contiguity anyhow.

Same for vfio I think.

-- 
Cheers,

David / dhildenb


