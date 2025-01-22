Return-Path: <kvm+bounces-36249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 57EBCA193D4
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 15:25:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3602A3A4C87
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 14:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED22C213E91;
	Wed, 22 Jan 2025 14:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dAvsISGH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FC81C4604
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 14:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737555938; cv=none; b=lsZ79l7qsMRy/S1k0mch5LjO+r8/QQ9VdGqiHCMfK9XpcbLuagwUl83Sp/8zguOm3rmDjheT5Lpt87ynN7Q3rsJW3dkz81y0Oj5ERGJ/BvkMrwwx1YoeuNal+zL71h4dqSsI0bu1OlTrum2CvBV6NYQyRWsp8HAOEXLeDeF8yIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737555938; c=relaxed/simple;
	bh=wyj7joyQXfg7+GOVFFjTB6uG3Fqn1LGGA2Y1RlGW/Jg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JpNUnTvGGvssWwlexuxwqj/L/njeb2zI4TEtmBcZZefrnDgAUW+/qdQ9b9bSvBK7+bDIvYVnboMIffHJPowlTkF02B7vVg6mzd3I2vHtZC39lRdmpuy4AWCEhIzM5vLPXZpRf5GU4Vpk6KZ2pzIATwmk17gg5ncdLyNrqT4utp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dAvsISGH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737555935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VovBY8C7ZX9LJhRPptigwsin2oTqYRePd/bJwWqtKt4=;
	b=dAvsISGHlvCPxEF02H5ahGWL7iVIadYuUZKOPuiXNbQAb/12ESESWt43cHifbNNLcjRLB2
	EbJ567Pni1CxTlcepc4aTjOGgd4JydNjdImRpE5N8+CR3IlVOJF33nSCSt64aBc/CwMu+V
	uTjZTDPV2ccOnqCdgQceVR1BoEUlWCg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-Vfj3EKQNOr-tX9snD3E8FA-1; Wed, 22 Jan 2025 09:25:33 -0500
X-MC-Unique: Vfj3EKQNOr-tX9snD3E8FA-1
X-Mimecast-MFC-AGG-ID: Vfj3EKQNOr-tX9snD3E8FA
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4361c040ba8so38518175e9.1
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 06:25:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737555933; x=1738160733;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VovBY8C7ZX9LJhRPptigwsin2oTqYRePd/bJwWqtKt4=;
        b=q0V/0XLjclzh6V+TfVYvEekC6aORVM9xQUVNg34pTd2NtmmeHgzmdyv4FoOe4CFNF/
         odvXqM8dB8dGQL5nlrQFgFfC6JDpMWrRkEKcjfj+khAh0nRAWSDSRk2Xn8euabFL/6zA
         KKWf2NuPKFFdubR08IMXgZK0dk24hlV3sveoJmw7IVqW23F7kszyzLD/x60iRSU+mUNR
         qshubB+oKyRu3II1dgqRitz74IUFqAe5BH/2dv8DlnIsDKidly6LlaDDdKbKLO2R1uUu
         pxn7kYg5X6YmlzTx6twamVxdzA8Zl3ujaY+OCS4XGhQ/ytMzYjX23PBlU8zlWwquUO71
         nNdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUj9P+VbkfTjw12w9bNDO/3blYH2wTie6kVkW3Sh0nsLo0YfcOr36Mw9HoRYAYrUdFA1tw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6Wq/PyWHsHew54hYj5Id3COJ60L7SDCuVIR14dyi7l8kCX73a
	7ZS1MaLaf8KqOsMBahCmbnfFQQr3Rxgrcfi4fuoOwVr84gMA4bF8+zGKGRlLqK55UrxkcggBg+q
	4y2YMn+yz6vXKfGHA0oH7GW+2JH356l4uPXJh62riRG+PlEO79Q==
X-Gm-Gg: ASbGncsa/1TTdR+o3jSztIHeo3gvANlwA27a/qnsFwAdZ9GcjbS/o+M1c2pK/zhX2FH
	CxGlXI+VOsmaEMQGHb4du5Vs40w9gJXSSLwiG65RWh2t9B2MBnAOQwDQ64btuOKG4o8vk4Q7dPj
	01DYabrRy5qkRQ9db+nWxMv13NU8BGNMh5ZtPVX9kEiGATHIQUXNpIAlLrKAtidlOfg6+Q5jgt3
	zeqG6/sRwQdXE1H65CtZYgkycgWdA6cvMcbFEKlerPTJdCLpEArT2uMkSTKokOUXi3LOFtFbV1Y
	IUgtY0Xng4CaFiPBSt/JWKQ=
X-Received: by 2002:a5d:4568:0:b0:385:decf:52bc with SMTP id ffacd0b85a97d-38bf5671bc4mr14426399f8f.32.1737555932574;
        Wed, 22 Jan 2025 06:25:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGpy7cMaLRk9dVBA0cgo6W1sQQN68NTp1FDxLTVIYJMJIluWqgnE07uX+vLudYeqOl4NBxvoQ==
X-Received: by 2002:a5d:4568:0:b0:385:decf:52bc with SMTP id ffacd0b85a97d-38bf5671bc4mr14426373f8f.32.1737555932110;
        Wed, 22 Jan 2025 06:25:32 -0800 (PST)
Received: from [192.168.3.141] (p4ff2353b.dip0.t-ipconnect.de. [79.242.53.59])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3221c30sm16704789f8f.32.2025.01.22.06.25.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2025 06:25:30 -0800 (PST)
Message-ID: <6e55db63-debf-41e6-941e-04690024d591@redhat.com>
Date: Wed, 22 Jan 2025 15:25:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 0/5] KVM: gmem: 2MB THP support and preparedness
 tracking changes
To: "Shah, Amit" <Amit.Shah@amd.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "Roth, Michael" <Michael.Roth@amd.com>
Cc: "liam.merwick@oracle.com" <liam.merwick@oracle.com>,
 "seanjc@google.com" <seanjc@google.com>, "jroedel@suse.de"
 <jroedel@suse.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "Sampat, Pratik Rajesh" <PratikRajesh.Sampat@amd.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, "vbabka@suse.cz"
 <vbabka@suse.cz>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
 "Kalra, Ashish" <Ashish.Kalra@amd.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "vannapurve@google.com" <vannapurve@google.com>
References: <20241212063635.712877-1-michael.roth@amd.com>
 <11280705-bcb1-4a5e-a689-b8a5f8a0a9a6@redhat.com>
 <3bd7936624b11f755608b1c51cc1376ebf2c3a4f.camel@amd.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <3bd7936624b11f755608b1c51cc1376ebf2c3a4f.camel@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

>> Sorry for the late reply, it's been a couple of crazy weeks, and I'm
>> trying to give at least some feedback on stuff in my inbox before
>> even
>> more will pile up over Christmas :) . Let me summarize my thoughts:
> 
> My turn for the lateness - back from a break.
> 
> I should also preface that Mike is off for at least a month more, but
> he will return to continue working on this.  In the meantime, I've had
> a chat with him about this work to keep the discussion alive on the
> lists.

So now it's my turn to being late again ;) As promised during the last 
call, a few points from my side.

> 
>> THPs in Linux rely on the following principle:
>>
>> (1) We try allocating a THP, if that fails we rely on khugepaged to
>> fix
>>       it up later (shmem+anon). So id we cannot grab a free THP, we
>>       deffer it to a later point.
>>
>> (2) We try to be as transparent as possible: punching a hole will
>>       usually destroy the THP (either immediately for shmem/pagecache
>> or
>>       deferred for anon memory) to free up the now-free pages. That's
>>       different to hugetlb, where partial hole-punching will always
>> zero-
>>       out the memory only; the partial memory will not get freed up
>> and
>>       will get reused later.
>>
>>       Destroying a THP for shmem/pagecache only works if there are no
>>       unexpected page references, so there can be cases where we fail
>> to
>>       free up memory. For the pagecache that's not really
>>       an issue, because memory reclaim will fix that up at some point.
>> For
>>       shmem, there  were discussions to do scan for 0ed pages and free
>>       them up during memory reclaim, just like we do now for anon
>> memory
>>        as well.
>>
>> (3) Memory compaction is vital for guaranteeing that we will be able
>> to
>>       create THPs the longer the system was running,
>>
>>
>> With guest_memfd we cannot rely on any daemon to fix it up as in (1)
>> for
>> us later (would require page memory migration support).
> 
> True.  And not having a huge page when requested to begin with (as in 1
> above) beats the purpose entirely -- the point is to speed up SEV-SNP
> setup and guests by having fewer pages to work with.

Right.

> 
>> We use truncate_inode_pages_range(), which will split a THP into
>> small
>> pages if you partially punch-hole it, so (2) would apply; splitting
>> might fail as well in some cases if there are unexpected references.
>>
>> I wonder what would happen if user space would punch a hole in
>> private
>> memory, making truncate_inode_pages_range() overwrite it with 0s if
>> splitting the THP failed (memory write to private pages under TDX?).
>> Maybe something similar would happen if a private page would get 0-ed
>> out when freeing+reallocating it, not sure how that is handled.
>>
>>
>> guest_memfd currently actively works against (3) as soon as we (A)
>> fallback to allocating small pages or (B) split a THP due to hole
>> punching, as the remaining fragments cannot get reassembled anymore.
>>
>> I assume there is some truth to "hole-punching is a userspace
>> policy",
>> but this mechanism will actively work against itself as soon as you
>> start falling back to small pages in any way.
>>
>>
>>
>> So I'm wondering if a better start would be to (A) always allocate
>> huge
>> pages from the buddy (no fallback) and
> 
> that sounds fine..
> 
>> (B) partial punches are either
>> disallowed or only zero-out the memory. But even a sequence of
>> partial
>> punches that cover the whole huge page will not end up freeing all
>> parts
>> if splitting failed at some point, which I quite dislike ...
> 
> ... this  basically just looks like hugetlb support (i.e. without the
> "transparent" part), isn't it?

Yes, just using a different allocator until we have a predictable 
allocator with reserves.

Note that I am not sure how much "transparent" here really applies, 
given the differences to THPs ...

> 
>> But then we'd need memory preallocation, and I suspect to make this
>> really useful -- just like with 2M/1G "hugetlb" support -- in-place
>> shared<->private conversion will be a requirement. ... at which point
>> we'd have reached the state where it's almost the 2M hugetlb support.
> 
> Right, exactly.
> 
>> This is not a very strong push back, more a "this does not quite
>> sound
>> right to me" and I have the feeling that this might get in the way of
>> in-place shared<->private conversion; I might be wrong about the
>> latter
>> though.

As discussed in the last bi-weekly MM meeting (and in contrast to what I 
assumed), Vishal was right: we should be able to support in-place 
shared<->private conversion as long as we can split a large folio when 
any page of it is getting converted to shared.

(split is possible if there are no unexpected folio references; private 
pages cannot be GUP'ed, so it is feasible)

So similar to the hugetlb work, that split would happen and would be a 
bit "easier", because ordinary folios (in contrast to hugetlb) are 
prepared to be split.

So supporting larger folios for private memory might not make in-place 
conversion significantly harder; the important part is that shared 
folios may only be small.

The split would just mean that we start exposing individual small folios 
to the core-mm, not that we would allow page migration for the shared 
parts etc. So the "whole 2M chunk" will remain allocated to guest_memfd.

> 
> TBH my 2c are that getting hugepage supported, and disabling THP for
> SEV-SNP guests will work fine.

Likely it will not be that easy as soon as hugetlb reserves etc. will 
come into play.

> 
> But as Mike mentioned above, this series is to add a user on top of
> Paolo's work - and that seems more straightforward to experiment with
> and figure out hugepage support in general while getting all the other
> hugepage details done in parallel.

I would suggest to not call this "THP". Maybe we can call it "2M folio 
support" for gmem.

Similar to other FSes, we could just not limit ourselves to 2M folios, 
and simply allocate any large folios. But sticking to 2M might be 
beneficial in regards to memory fragmentation (below).

> 
>> With memory compaction working for guest_memfd, it would all be
>> easier.
> 
> ... btw do you know how well this is coming along?

People have been talking about that, but I suspect this is very 
long-term material.

> 
>> Note that I'm not quite sure about the "2MB" interface, should it be
>> a
>> "PMD-size" interface?
> 
> I think Mike and I touched upon this aspect too - and I may be
> misremembering - Mike suggested getting 1M, 2M, and bigger page sizes
> in increments -- and then fitting in PMD sizes when we've had enough of
> those.  That is to say he didn't want to preclude it, or gate the PMD
> work on enabling all sizes first.

Starting with 2M is reasonable for now. The real question is how we want 
to deal with

(a) Not being able to allocate a 2M folio reliably
(b) Partial discarding

Using only (unmovable) 2M folios would effectively not cause any real 
memory fragmentation in the system, because memory compaction operates 
on 2M pageblocks on x86. So that feels quite compelling.

Ideally we'd have a 2M pagepool from which guest_memfd would allocate 
pages and to which it would putback pages. Yes, this sound similar to 
hugetlb, but might be much easier to implement, because we are not 
limited by some of the hugetlb design decisions (HVO, not being able to 
partially map them, etc.).

-- 
Cheers,

David / dhildenb


