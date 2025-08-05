Return-Path: <kvm+bounces-54010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F6ECB1B556
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 15:55:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6BEA64E215F
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 13:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0D9A274B43;
	Tue,  5 Aug 2025 13:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iWQJiooz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D50D24166E
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 13:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754402140; cv=none; b=sQA10+yJgaERI23tPz2HbxxRZtS/bbQFf2c2rOAIEN5HGqf8NJ9NisVa+Kls0PPZGn+kQ1RMvJlfPhDesGERT43bfVHjgGivHa8euAQGnX9oxuuLJ9WBTVdoCI7UMsfg6Hjd3DMLdlizi08FqrE1of82a844oc0EDDGsGjIgYes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754402140; c=relaxed/simple;
	bh=RCxtOYxRw8jnu+E0HL7hJ9DlWMNd2nAXNBur1Wv7+GM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oLn1Lq2cgEfhICa8IrATYjNsnRSayZJTRCEX+I4l3L9BQI9taDq7CH5+8s4qJav2j/zVSeq79H1PPW7v+xOZsgKGEL6M/cKoeFPz+hP0Z12nu+bVOzDhIAX6qrq+d+6BZp4dAAGXien5zlW0QFNafu49HF1cWIxjnVq9Y+P9z7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iWQJiooz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754402137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JNtcQKAXzpB+G+TaagoXTa6Qm2CqmP2bGFMsVRytZMs=;
	b=iWQJioozWRndwKsvSUymEGA6wijRjdPw9Vfsp0qK+aw0XA/zRhBOMwu3FhqsX3NxKyDQYL
	r5YF/I6uAZP5uyU0qc9vQSiNMMtJZvqZMEbFn43cn5su5QyZ3+xjcKnMTNGW8pRtMww1QW
	8QW2l8FbRAo4dKgEvpWduid5D7suNho=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-150-aa73JT4EOZicBAM8Ee5lcA-1; Tue, 05 Aug 2025 09:55:36 -0400
X-MC-Unique: aa73JT4EOZicBAM8Ee5lcA-1
X-Mimecast-MFC-AGG-ID: aa73JT4EOZicBAM8Ee5lcA_1754402135
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b783265641so3552643f8f.1
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 06:55:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754402135; x=1755006935;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JNtcQKAXzpB+G+TaagoXTa6Qm2CqmP2bGFMsVRytZMs=;
        b=oPXyaIMvBpsA6OW9Ef+c0laYpc/bwxNBscwCJIsWDIh21xx/5ZiMD0u/MHAzR8yikb
         llHfUrMuSOiM9EHMaubbmoXVWWblvWlzkOb0TQIf8V+jrfEx4wXEfuoZG0X7Yau+ERRs
         c/PQx/t7WnBqGUS2Msuu6rbqCocDDaPukhj1gBn+4b3/+FRy2/xfaRQIkVHvGDAKD6Gj
         2UwmD1dBHxX7AL5q2GT6WNWZ/Y2gf7EdRU7f0WjlRras2EjW2tG++hyepbHRSijGRkZ+
         vZx5KdIYYHRPqU09aE22FdK/KhXYHr3ajwZJDGPYE9fKL30I3i1bDnyixLSTLZS8jZdT
         bCBA==
X-Forwarded-Encrypted: i=1; AJvYcCWubjRKU5ZK+f/vZSVl27Akg1UuPVnWLBRbspJzvwsrrh9xbCFbCcbwjBeRmifFUBS1e5A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzAmJQsy9+mvsKpRq+yzXtpRABRbSQqQ5GHoCeulRI34bQojl31
	Jz2p4RPql31uXpbKJ3Y1wHayHKvr75jWLrpN4YNLhC/5rp4dIgTo//FvhPlFd/p7FnxG37TSW/S
	e4IZBpMfwI8f7r4mmk6VqmKZ8TCkpww+5sMf3w2dX6YOjs7UQGkHhcA==
X-Gm-Gg: ASbGncukuHDHsAg0gh8AaavHid2HojgMvX3nuCXyw9AjKORg0o5ePtrfPBb+YpMhE3j
	gTvUBwlkLVEMVW5XlwWOC+aP2LgTHKorFQvaX7o8d8Eh9xir5PN8FBe+rRQtyXlT08XcuYFYRE2
	3TSg2NpAdmuZSdGnNe4/T4+j+CSwlxk7CMoAe7mMfJ6PROm50b/NR0dIBRymkbnhj0AHN3fvrrm
	y0V3VPsmN9Y9RTwl3ewv3dkFBTdASGzuYZ6TKTmJBjcdidlF6R/za7J0pfX137NeQv1EVgy4F8D
	Z4LjCg2jR1JzAB49rZjwhUf2Betco6puBEblyFU9s3MVzU07L2tHLwu0KHMcUWgTIW/Pd7NiGqW
	esddlxS1/srpCUEWuk5Tfgqed7Ma0GcKjrlOXIJaSuFQN4esw8sdXzx6xd+4HctQqHj4=
X-Received: by 2002:a05:6000:2403:b0:3b7:8fc4:2f4c with SMTP id ffacd0b85a97d-3b8d9468ce7mr10064725f8f.1.1754402134781;
        Tue, 05 Aug 2025 06:55:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH/K9Q5gGrODzOMXhZkXj3VQiTGBBS22kcioNlNEcOLv5L+Wh1I5dEV9Bld7KqWwSSJQKmlPw==
X-Received: by 2002:a05:6000:2403:b0:3b7:8fc4:2f4c with SMTP id ffacd0b85a97d-3b8d9468ce7mr10064694f8f.1.1754402134326;
        Tue, 05 Aug 2025 06:55:34 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:b200:607d:d3d2:3271:1be0? (p200300d82f2bb200607dd3d232711be0.dip0.t-ipconnect.de. [2003:d8:2f2b:b200:607d:d3d2:3271:1be0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e5879d76sm5430445e9.24.2025.08.05.06.55.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 06:55:33 -0700 (PDT)
Message-ID: <839fe8af-3157-427a-b059-50eccd594d0e@redhat.com>
Date: Tue, 5 Aug 2025 15:55:32 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] VFIO updates for v6.17-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>,
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
 <CAHk-=wg75QKYCCCAtbro5F7rnrwq4xYuKmKeg4hUwuedcPXuGw@mail.gmail.com>
 <4c68eb5d-1e0e-47f3-a1fc-1e063dd1fd47@redhat.com>
 <CAHk-=whoh31th2awzO02zA3=cv4QNTFjdYr73=eSDDFfW2OdOw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <CAHk-=whoh31th2awzO02zA3=cv4QNTFjdYr73=eSDDFfW2OdOw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.08.25 15:51, Linus Torvalds wrote:
> On Tue, 5 Aug 2025 at 16:47, David Hildenbrand <david@redhat.com> wrote:
>>
>> arch/x86/Kconfig:       select SPARSEMEM_VMEMMAP_ENABLE if X86_64
>>
>> But SPARSEMEM_VMEMMAP is still user-selectable.
> 
> I think you missed this confusion on x86:

Yeah ...

> 
>          select SPARSEMEM_VMEMMAP if X86_64
> 
> IOW, that SPARSEMEM_VMEMMAP_ENABLE is entirely historical, I think,
> and it's unconditional these days.

Same for arm64. The other seem to still allow for configuring it. 
Probably we could really just force-enable it for the others that 
support it.

Then fence of gigantic folios and remove most of the nth_page hackery 
when we're working within a folio.

-- 
Cheers,

David / dhildenb


