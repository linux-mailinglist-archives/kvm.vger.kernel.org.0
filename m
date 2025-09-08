Return-Path: <kvm+bounces-56966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCAB5B48636
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 10:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BFE417D714
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 08:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59AC82E92D9;
	Mon,  8 Sep 2025 08:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FaMpPTP3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1035E29AAFD
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 08:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757318416; cv=none; b=soBochwy3tB2COY8TrZS2qgtSDQd0qoMLLunkYyL4um4njkOgN5orDJPPsVKmINiq0OfPjjgl6W5AGcDqlcf7WrMyDleGzq/GHHSA0VT4ocQqj60nfMTeDexcjgvVRED5ybvoAdV5OHHoRkSy+bCUhHCO+o29HgE64LiXQ1uq3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757318416; c=relaxed/simple;
	bh=+YwpdcGwlF5pvdpd2It9H4VZTjzT37L3k9Tc+m9Is7Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gyi37KGAt073oz1gk86ES0kbMSjylZk+Yu9nBsR0DIYfDuc6neR+xx/E4bwOmdBpvHbP/IJFEOMSqidtIXcPVwq1hkNwtIjNkBzwOerkSSTcHwVK/CgaZa8XPijOjRBUPICFtJkrtngKghif2tIAyY8M/onsg+2WiG8I0sULYeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FaMpPTP3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757318414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6ZtGxzPBBhWZb8TdeGEHePc9lnXNDI+6sWWhJSedy84=;
	b=FaMpPTP3K+Uw1/EXIzN3BxZJ0eENfDTE2Z7Iws2ev+mKqd0ODiVpnEm1sptrfQy0rcIyZ1
	p81v2Q8hiBn8hbUWzYRdgqFR1bhcPdMYOIqzJ8jhqBaFtMSFP87GO+r4ODJs3YI4YGIpXP
	iLm0jRN0v2uQMk83EGNPyDJYY+hJxOM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-gvCTqARHMDCEQNlcLWNiEw-1; Mon, 08 Sep 2025 04:00:12 -0400
X-MC-Unique: gvCTqARHMDCEQNlcLWNiEw-1
X-Mimecast-MFC-AGG-ID: gvCTqARHMDCEQNlcLWNiEw_1757318409
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3e3b77972cbso1376584f8f.1
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 01:00:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757318409; x=1757923209;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6ZtGxzPBBhWZb8TdeGEHePc9lnXNDI+6sWWhJSedy84=;
        b=koM8JDWUfDtBGhSC8ldPpzfyRY2JwgPAMyas+JVLubFF1WGjYvxyg1CdTXqHbyYkku
         30L7ziY/5m/A4lBl14pc7IH+jgwb5UaAnHaTXeqGO1pYBG+jrLknCveopGwQ/3Kp8tXo
         82K7cYT6NJYSgpSRw7pURVUWkQWxM6s11zWBhkaqQvk+Zx6vrVeNnQJaj6TrYwKlPfuC
         xCLIRad3Pd2oUDUvcvJctMIwH2oE942JA5SSqpK8dnqraue42EvH76Ldojlue0jKgV9R
         OkS6iEDjyQkeeLOnJCeKawaFBfdxejPVqpGoShktq5o1rIfd2M8MsBLAQhouAHw5BeAu
         DIVw==
X-Forwarded-Encrypted: i=1; AJvYcCUR6wJ4F2YvYSdgTBYZnxuM8/J8z04vtEg/g5H1iF/jE93mHRJ0D+lg5ppdJuJGuRrU10Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6+RJrudbEMzCFI91mMTHBciLyTMyqsydE756+VR3qwWVSepjr
	1I2vNeQVa2ivnerz3Scp0paNrD9VMYlQcojQw3dRvreKv/PA3NN4e6N7wfz/hBlSBRRPP7FrRlN
	NnQRlUG8AtTZ/DRWGvkWyK/R3jk9Tt6A0fTg+J30+mnYtHKj6gXCcEQ==
X-Gm-Gg: ASbGncu/TRSRvhCKu/44ndzBaQ5PIzbaZjcZPP4gckE4K2ZoT3lzoDXbKTpIwl+8Oag
	4QagD6slRQriT6Ws/NCZ3RIJ0683YWQ49sVhuWmgsdMtkvMj+98f1BSgbifXow+N/ATn+TM4+TM
	HJ9mYVeJs0AQvs0+mncZ5Hi7w2XLN5KdW9Tqrl2GAvJ4lzPt7sC4DGG8pjTfsVtmr5uLoxw3irI
	2nJCRgYJA3cJjahls0xEX+yZn0Tyil5nZU3rdwQyHVIXDjG1TjDnM0KG473Syos7emv5rRwtlTH
	SRIt0YpzbcqDKhGZ5BVb5PFkrw2YEijQ3Rwb0ZM7LYQZjl+/PKq6oiPhbNz/+MaSaR8azPs=
X-Received: by 2002:a05:6000:26cd:b0:3e0:2a95:dc9e with SMTP id ffacd0b85a97d-3e64ce50347mr4840516f8f.57.1757318409123;
        Mon, 08 Sep 2025 01:00:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+e2xgTQYe5kT3rV+uD8LRSVafVXIklNJL7Am05EAxkn8s4rPl3yNNJ7oQs/EOmF2miaT83w==
X-Received: by 2002:a05:6000:26cd:b0:3e0:2a95:dc9e with SMTP id ffacd0b85a97d-3e64ce50347mr4840495f8f.57.1757318408663;
        Mon, 08 Sep 2025 01:00:08 -0700 (PDT)
Received: from [192.168.3.141] (p57a1ae98.dip0.t-ipconnect.de. [87.161.174.152])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e740369f1esm6798834f8f.11.2025.09.08.01.00.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 01:00:08 -0700 (PDT)
Message-ID: <28fc8fb3-f16b-4efb-b8e3-24081f035c73@redhat.com>
Date: Mon, 8 Sep 2025 10:00:05 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
To: John Hubbard <jhubbard@nvidia.com>, linux-kernel@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, kasan-dev@googlegroups.com,
 kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
 Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
 Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev,
 Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org,
 Zi Yan <ziy@nvidia.com>, Aristeu Rozanski <aris@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-20-david@redhat.com>
 <016307ba-427d-4646-8e4d-1ffefd2c1968@nvidia.com>
 <85e760cf-b994-40db-8d13-221feee55c60@redhat.com>
 <0a28adde-acaf-4d55-96ba-c32d6113285f@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <0a28adde-acaf-4d55-96ba-c32d6113285f@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>> Roughly, what I am thinking (limiting it to pte+pmd case) about is the
>> following:
> 
> The code below looks much cleaner, that's great!

Great, I (or Aristeu if he has capacity) will clean this all up soon.

-- 
Cheers

David / dhildenb


