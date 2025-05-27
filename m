Return-Path: <kvm+bounces-47786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB291AC4D12
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 13:20:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 746323BFC24
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 11:19:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05001253350;
	Tue, 27 May 2025 11:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KR+wdLVK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7ACC1EF0A6
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 11:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748344811; cv=none; b=WsQONoYHo8NWkNIVlyh1AH7o1j4IURbD8jykYOiYSib4hF0RI+WP5XcvMX10nUpMxou8oXnor3/93t4jQ65KKPelocvS9+CU8UF99C4Kx7rl7kIWexWFkLy1rKanxiH1TrkDjCqSCliX+AYmCyZ8nL+hUKSucofIxEP8/gRmKL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748344811; c=relaxed/simple;
	bh=i9zs3MNgLyaLMfszNlqEQ6848Cr3zKyVT+K6o0LhT5Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tMSCItJ+nlV2twGaggQCWtxCHFioXmIfMljd+CxFbw5AITGkN646NRZ/mEYfQBlu0T70OPYuVOiEv5s52DdX9u16bdAs+Q8BrO4POoHH4iPxHZcdO/1lVv1hQm19IY+1d6D+PNUmQz8/U97Nu21pkIfbtFawHDDIhXPe6dTsMss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KR+wdLVK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748344807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YKNVYFC2IcMe1Fm7SeSy11DsiVXZP+F286iJgXwsNUQ=;
	b=KR+wdLVK4fEomeF0ld1+3nstlw3dOYx4N7GZ3NBzlBfv717sHPK/h2BiXidMVGsDx8F2g4
	lba7/VX8JJYklMQi1saCNwo3qiXksvIvl5TLEoZ22DVOp6rIMzLbdjw8AOa6TH9+TwsKLJ
	4xBnyQK7Mn9S6sfbS5kk6TcYJaZ/hkA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-49-DqBa3wd-N-SS9561Xsxe1Q-1; Tue, 27 May 2025 07:20:06 -0400
X-MC-Unique: DqBa3wd-N-SS9561Xsxe1Q-1
X-Mimecast-MFC-AGG-ID: DqBa3wd-N-SS9561Xsxe1Q_1748344805
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43d734da1a3so18927455e9.0
        for <kvm@vger.kernel.org>; Tue, 27 May 2025 04:20:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748344805; x=1748949605;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YKNVYFC2IcMe1Fm7SeSy11DsiVXZP+F286iJgXwsNUQ=;
        b=ZOeUgqF1wc6QBtZcZK4HKfSEJiI6jvGLqvdH9EH057TtY68YrpeT4s7hyDZ/zco6XW
         IJHgSpsVvU7X+TjMv7Dmg8slc9+2358KY1c4KpjDxG/MC7HzXVLPEziXGdVa3FEZMOtP
         CLp40+aOW2TRRwJSjJDdYH600WL4i3MYWrwXhGuNAUmF+X7HMIP8lISP7tQOO5U7heU+
         mTvH2zw9ziEpsd3ezKqEdHaDTcMV6iF0DdP9TIB4P2Wcy70aVRel0NlJulSp9v3CG4ym
         fob5GG/JmZKP9TeTwURWRDI8XFthBhTpLc2nlPHFRwcwkqYydwBtLnYF722iuS9t8C06
         G3BA==
X-Forwarded-Encrypted: i=1; AJvYcCUQKF8x/LQQ9CENj72h/BQoCIJXYVPMcPb++y2Ij2Xy4Td0DrggeulExYlQTUnZUS4MveU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFgO6o25BRg7g6ceXOJDC2Hx3YvOFFpks/hiyddPcLcvTsXh8T
	f8JmDW6K+2WiycxpbCj1eFeeF1F91J0aGMVgG84/9WHh0w9nLPIWP0uZZT/7B8XGc7b0Cd0qNuP
	bXlPywzybxzc/sxjm5Vav659hvUvLYwq0I0ICw6X3rl+CHY4i/9lt3Q==
X-Gm-Gg: ASbGnct4wS59MVVMi+SlkQVhsaRHpolVGVLT0+lMNb9jwXDW+5sat+lN8AWIPG9GuCo
	ARd6ZPf63g21aQKDJdigtRx4as1QCwZbjtYm172gOfb3VJ9zkW+rq1EJr1EGXyYRtmB9BobIuZi
	nXLPPCCTRjme2Dd3Syn1pJc1NWUaQOV4EZHgfckCaJyA8x+wLDxS3rSGC6kUKhIzF0Q9xNPVP3p
	LylrZoaEN8qE1L0smE2cY5IhTkKYMvDxD3xGi+y4JuDyIA4KGIOcwMN5gvLU+XXjJUTvmB5t/OD
	uldZT2PFNOlObRvdp3YG81Q2epq0ZuVBtHJ93coBy7Re
X-Received: by 2002:a05:600c:1547:b0:440:54ef:dfdc with SMTP id 5b1f17b1804b1-44c935dca2emr106324085e9.8.1748344805160;
        Tue, 27 May 2025 04:20:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGlyickPkgs/njo2SCri2jqrG0yQeRWlByYHp0iamN4soyrSABHNsEoh0+qGZMhx4sYPUWZCA==
X-Received: by 2002:a05:600c:1547:b0:440:54ef:dfdc with SMTP id 5b1f17b1804b1-44c935dca2emr106323715e9.8.1748344804691;
        Tue, 27 May 2025 04:20:04 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4d17266d5sm8387859f8f.68.2025.05.27.04.20.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 May 2025 04:20:04 -0700 (PDT)
Message-ID: <e187cd31-09b4-48da-88ea-20582023e5d8@redhat.com>
Date: Tue, 27 May 2025 13:20:03 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/10] RAMBlock: Make guest_memfd require coordinate
 discard
To: Chenyi Qiang <chenyi.qiang@intel.com>, Alexey Kardashevskiy
 <aik@amd.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <20250520102856.132417-8-chenyi.qiang@intel.com>
 <7af3f5c9-7385-432f-aad6-7c25db2fafe2@redhat.com>
 <cf9a8d77-c80f-459f-8a4b-d8b015418b98@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <cf9a8d77-c80f-459f-8a4b-d8b015418b98@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 27.05.25 07:47, Chenyi Qiang wrote:
> 
> 
> On 5/26/2025 5:08 PM, David Hildenbrand wrote:
>> On 20.05.25 12:28, Chenyi Qiang wrote:
>>> As guest_memfd is now managed by RamBlockAttribute with
>>> RamDiscardManager, only block uncoordinated discard.
>>>
>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>> ---
>>> Changes in v5:
>>>       - Revert to use RamDiscardManager.
>>>
>>> Changes in v4:
>>>       - Modify commit message (RamDiscardManager->PrivateSharedManager).
>>>
>>> Changes in v3:
>>>       - No change.
>>>
>>> Changes in v2:
>>>       - Change the ram_block_discard_require(false) to
>>>         ram_block_coordinated_discard_require(false).
>>> ---
>>>    system/physmem.c | 6 +++---
>>>    1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/system/physmem.c b/system/physmem.c
>>> index f05f7ff09a..58b7614660 100644
>>> --- a/system/physmem.c
>>> +++ b/system/physmem.c
>>> @@ -1916,7 +1916,7 @@ static void ram_block_add(RAMBlock *new_block,
>>> Error **errp)
>>>            }
>>>            assert(new_block->guest_memfd < 0);
>>>    -        ret = ram_block_discard_require(true);
>>> +        ret = ram_block_coordinated_discard_require(true);
>>>            if (ret < 0) {
>>>                error_setg_errno(errp, -ret,
>>>                                 "cannot set up private guest memory:
>>> discard currently blocked");
>>> @@ -1939,7 +1939,7 @@ static void ram_block_add(RAMBlock *new_block,
>>> Error **errp)
>>>                 * ever develops a need to check for errors.
>>>                 */
>>>                close(new_block->guest_memfd);
>>> -            ram_block_discard_require(false);
>>> +            ram_block_coordinated_discard_require(false);
>>>                qemu_mutex_unlock_ramlist();
>>>                goto out_free;
>>>            }
>>> @@ -2302,7 +2302,7 @@ static void reclaim_ramblock(RAMBlock *block)
>>>        if (block->guest_memfd >= 0) {
>>>            ram_block_attribute_destroy(block->ram_shared);
>>>            close(block->guest_memfd);
>>> -        ram_block_discard_require(false);
>>> +        ram_block_coordinated_discard_require(false);
>>>        }
>>>          g_free(block);
>>
>>
>> I think this patch should be squashed into the previous one, then the
>> story in that single patch is consistent.
> 
> I think this patch is a gate to allow device assignment with guest_memfd
> and want to make it separately. Can we instead add some commit message
> in previous one? like:
> 
> "Using guest_memfd with vfio is still blocked via
> ram_block_discard_disable()/ram_block_discard_require()."

For the title it should probably be something like:

"physmem: support coordinated discarding of RAM with guest_memdfd"

Then explain how we install the RAMDiscardManager that will notify 
listeners (esp. vfio).

-- 
Cheers,

David / dhildenb


