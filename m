Return-Path: <kvm+bounces-54005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC243B1B533
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 15:48:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C7D43BD540
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:48:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04BD02472B7;
	Tue,  5 Aug 2025 13:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IGu3b92R"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8602AD14
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 13:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754401674; cv=none; b=HmEJ199z3TyXTPevOHwRoQLL0RBVNYIHY9JuQb+ErpQ+mHjWm9rDhtQXUPhdc8DwT4eYJ3dKx/pgMWjm1FAGvrj4qRzT6ZUH2iVdbtEPPxlIorDTU2GqVB0XWTNEvZZh654CAsbcDCGCexAuuIymxuQ5ItoYM2Vhaz50w3V9GTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754401674; c=relaxed/simple;
	bh=fVs0QLegblmuEyu09CFHJFY68Aw4hYw45jDhfodxUFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OSIcJTrYeS4CCYp44PPHtyf18H4D+Hi0unxmScWeiyg1d57NXqy7takvp2okoBu0VKyavWQn8SIhQL33dabNnJsuXsprG4vkuvhh+7WJAaZuv1HnjO66FA2g35JYGR/VjAyVUHXR6B6Lp6uUxFsjCN+YJfjAQmF947S7xcEFLMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IGu3b92R; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754401671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JCZPG4PRFkWmStclsKNVUS0P5cudUlD8q2j0fKBlVN0=;
	b=IGu3b92RXcf9CTShd89BMt0WJgH4LXYJLasGCroPTuf1KnxINw4180lmovBqn4Im4rZEcm
	GDmiJoAfSiP602ZTiO2xI+p9ZecSpUj52n5E8A5gqX4E3tqw51P5Smys+tMuxlQt1xY6DC
	5rFA2O0PsiWg+1Fcf9ohc8OBNC9Pih8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-32-C5zscQrnP5K88nP7btsi4w-1; Tue, 05 Aug 2025 09:47:50 -0400
X-MC-Unique: C5zscQrnP5K88nP7btsi4w-1
X-Mimecast-MFC-AGG-ID: C5zscQrnP5K88nP7btsi4w_1754401669
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-458a31421a3so21012165e9.0
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 06:47:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754401669; x=1755006469;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JCZPG4PRFkWmStclsKNVUS0P5cudUlD8q2j0fKBlVN0=;
        b=WHIM1c6f4bSRhQXFqC95tO/xP9vLAX09FjC8zI+0wqYbyC8FHB+lzMKCRWGilyIVdo
         47y9LbEuJOGn/XBahIMxp7GoHJnzt1UP6XrKipxS55dcIz3rk/TpWoIOzBlB6Wk4hhzr
         tggMqctbtVKLK+Q3i/BcP2l4WUeDe4UlYWTmwyEbkvoNQe7hskUIA8zFKyeVbXp7+BGh
         svngLLS9AYRtHbqnZKhC59Z1DSq3ydjqu3xhhBKZ7lwWmGlvCIhrty0ur01v1UW9HTRK
         48xieUBHuz1vJfhGQ+/MR+UeCOTBY1Ez9K0h8cqdHROSeyhxnjUOXV2PqzDRweAR+jJY
         eJoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEem28QDLM13bwX+og43AE7SosNCadzA8GVvJrCdA50ZC4X7HFrLSuZrNfvjdZSodc1oQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz119izIULz/Gr7HFJOYcaXJjCcCiMA2/IHU4f0hV1Og8Fx8lXu
	LGOlN+fZ6Je6UlUv6oXvIZGnxfdRYN0AAy+QTGvWC172DYuumuSBDdfPaulblU2oPTaiQ+v7iVu
	6yY8wXMuMDPbDp5iijvumu5FvFwZNzxAoU5dTmv5tfVDeJO6kcMJlrtm2MLC63gun
X-Gm-Gg: ASbGncuO3A36s9JG6EDFC/DAhFCCc4mcUI7zxJS5DqQlvtG/8uUBHqq/SY/bLl9C0JS
	W5kAbr74wxua0r4+Q+JgcIcvmZUZyRI3zp8KsqxZZqs+O7qQzSI+JOJrOi7QhIFxkt7v5wl+PLd
	uHgIn4ZNXfizCC10X08SZcoDioIhVW8CQIeSBjw/9VkMascNospyTd/Tuen2ygfBhQoSjH4tSJP
	a6jprkqCip+uMJnFsELbel7tvk04hlrGC21/CRalpIAb1S3WVF7TJbU5oYt++fWRbFFrZaAbJ5+
	nkjSYwp90m+D2/679BBDQVtftdd7Jaqq7+Jjid6Cf1NLx+2WxXOi5JrX9jqRYevTFPD65sQmnJ0
	wpGmG1N26X+UacHbVdzk3OLktZQFtVob0ErCD5mirUju2gXH+e5MAMyhdSRLueqFqCrs=
X-Received: by 2002:a05:6000:2382:b0:3b5:dc05:79b with SMTP id ffacd0b85a97d-3b8d9470dbcmr12025169f8f.14.1754401669080;
        Tue, 05 Aug 2025 06:47:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGoBNgG9DHTZL/GHvltXJl3Ksy/Yg1AUSXduvhyK/z2xEluiR9OBlvVhh6LjDXV5JACQ/pyqQ==
X-Received: by 2002:a05:6000:2382:b0:3b5:dc05:79b with SMTP id ffacd0b85a97d-3b8d9470dbcmr12025138f8f.14.1754401668575;
        Tue, 05 Aug 2025 06:47:48 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:b200:607d:d3d2:3271:1be0? (p200300d82f2bb200607dd3d232711be0.dip0.t-ipconnect.de. [2003:d8:2f2b:b200:607d:d3d2:3271:1be0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c48105csm19390080f8f.64.2025.08.05.06.47.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 06:47:47 -0700 (PDT)
Message-ID: <4c68eb5d-1e0e-47f3-a1fc-1e063dd1fd47@redhat.com>
Date: Tue, 5 Aug 2025 15:47:47 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "lizhe.67@bytedance.com" <lizhe.67@bytedance.com>
References: <20250804162201.66d196ad.alex.williamson@redhat.com>
 <CAHk-=whhYRMS7Xc9k_JBdrGvp++JLmU0T2xXEgn046hWrj7q8Q@mail.gmail.com>
 <20250804185306.6b048e7c.alex.williamson@redhat.com>
 <0a2e8593-47c6-4a17-b7b0-d4cb718b8f88@redhat.com>
 <CAHk-=wiCYfNp4AJLBORU-c7ZyRBUp66W2-Et6cdQ4REx-GyQ_A@mail.gmail.com>
 <20250805132558.GA365447@nvidia.com>
 <CAHk-=wg75QKYCCCAtbro5F7rnrwq4xYuKmKeg4hUwuedcPXuGw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <CAHk-=wg75QKYCCCAtbro5F7rnrwq4xYuKmKeg4hUwuedcPXuGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.08.25 15:36, Linus Torvalds wrote:
> On Tue, 5 Aug 2025 at 16:26, Jason Gunthorpe <jgg@nvidia.com> wrote:
>>
>> David, there is another alternative to prevent this, simple though a
>> bit wasteful, just allocate a bit bigger to ensure the allocation
>> doesn't end on an exact PAGE_SIZE boundary?
> 
> So I don't mind adding a check for "page_section()", because at least
> that makes sense.
> 
> But yes, it would also probably be a good idea to try to minimize
> SPARSEMEM without VMEMMAP. I'd love to get rid of it entirely, of
> course, but even if that isn't possible, I'd *really* just like people
> to try to make sure that it's neve ra valid thing to try to combine
> memory across different sections.
> 
> David mentioned the 1GB hugepage folios, and I really thought that
> even *those* were all in one section. They *should* be.

The memory section size on x86 is always 128 MiB. Even with SPARSEMEM.

There are weird interactions between memory section size and memory 
hotplug / DAX, so we try to keep it small'ish.

It's more that we don't care that much about memory section size with 
SPARSEMEM because nth_page() and everything around that is just plain 
simple.

> 
> Do we have any relevant architectures that still do SPARSEMEM without
> VMEMMAP? Because if it's purely some "legacy architecture" thing (ie
> x86-32), how about just saying "no 1GB hugepages for you".

arch/arm64/Kconfig:     select SPARSEMEM_VMEMMAP_ENABLE
arch/loongarch/Kconfig: select SPARSEMEM_VMEMMAP_ENABLE
arch/powerpc/Kconfig:   select SPARSEMEM_VMEMMAP_ENABLE
arch/riscv/Kconfig:     select SPARSEMEM_VMEMMAP_ENABLE if 64BIT
arch/s390/Kconfig:      select SPARSEMEM_VMEMMAP_ENABLE
arch/sparc/Kconfig:     select SPARSEMEM_VMEMMAP_ENABLE
arch/x86/Kconfig:       select SPARSEMEM_VMEMMAP_ENABLE if X86_64

But SPARSEMEM_VMEMMAP is still user-selectable.

I would assume SPARSEMEM_VMEMMAP_ENABLE support would cover most hugetlb 
+ dax users indeed, at least when it comes to gigantic folios.

Would have to figure out why someone would want to disable it (limited 
vspace? but that should also not really be a problem on 64bit I think).

-- 
Cheers,

David / dhildenb


