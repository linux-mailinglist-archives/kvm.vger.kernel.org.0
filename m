Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6135A6798
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 17:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiH3Pnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 11:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiH3Pns (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 11:43:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F069B95B6
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 08:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661874226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5LIdhu1lS7jdtXtXqeaM3XP6rtL42Pg7PAfv3l7oebo=;
        b=OZhD0zN6+U0Pbffmkf12ETp+PTTb7/5mgfwQxOxYdqRyTO2p76x84Iyuf9lwJswH3OLYyJ
        5Eo5AS+LJPVrCqJTddC1gDHC+BQfbC2SVxVwiW5CYRoe8BEgk4rkphrBrc749/c6E9b/X8
        Spb4zAuiw7Fe407SocjT15Qy8kBlHyc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-112-H51WdYf6OquDfJK43_ePNw-1; Tue, 30 Aug 2022 11:43:45 -0400
X-MC-Unique: H51WdYf6OquDfJK43_ePNw-1
Received: by mail-wm1-f69.google.com with SMTP id f7-20020a1c6a07000000b003a60ede816cso2144338wmc.0
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 08:43:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=5LIdhu1lS7jdtXtXqeaM3XP6rtL42Pg7PAfv3l7oebo=;
        b=drAvC0SJaM7Z8ylOin9I8GU7ZYJthBf6B8Nnn7tu5oZSkJ+pilHjvBSEYZ+2g+u35s
         LMD1PRxOmRutEgDGNLo6O18jcU3Cyo3KWR7fgAo5UKQaj5qdyEWwyQRT1Z/9nsExnzj9
         jWImiEtKEo8WyffZKb76vQ9Fg55c+RhtXBuut/KyMIQbqX1s56oGVJSpW3kc3pG/ORIS
         2HLEB3R5Wd56x3E0lHYzLqlwMry06lFDcH9zGkXwXCSOXfwMbyGV1SHHBiSV8edPP3I7
         KTKH0gp5bRLfOA/tFikESSnepBrz9IGKT5gzCAgr28SzefdyZz9emefTbqYakuDty4pX
         J+WQ==
X-Gm-Message-State: ACgBeo3fiToY7qJFEz5eGdPdjgl0TNZ0RnFmlk4wjtlFp4bRGoNucE9D
        2V6PkeTcR1zLGHrw+94vBk/4zHMR1KAGqaYWothJZzjPZVMpGcnh/rmNkN2zJja05Z6EURmInI1
        FbB7xURwBnAhE
X-Received: by 2002:a5d:59af:0:b0:220:6daf:5f64 with SMTP id p15-20020a5d59af000000b002206daf5f64mr9648510wrr.192.1661874224283;
        Tue, 30 Aug 2022 08:43:44 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4gkqPdWZbUokRdCqwdy4IuKKkxA7Rj+Tnk9DhqwplLuPQUU4aRQaSFoXshT0hGQOn942TiHA==
X-Received: by 2002:a5d:59af:0:b0:220:6daf:5f64 with SMTP id p15-20020a5d59af000000b002206daf5f64mr9648492wrr.192.1661874224005;
        Tue, 30 Aug 2022 08:43:44 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70a:1000:ecb4:919b:e3d3:e20b? (p200300cbc70a1000ecb4919be3d3e20b.dip0.t-ipconnect.de. [2003:cb:c70a:1000:ecb4:919b:e3d3:e20b])
        by smtp.gmail.com with ESMTPSA id d5-20020a5d4f85000000b0021e6c52c921sm11807206wru.54.2022.08.30.08.43.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 08:43:43 -0700 (PDT)
Message-ID: <e1747d53-a02d-ca32-cdc4-702315da57df@redhat.com>
Date:   Tue, 30 Aug 2022 17:43:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        lpivarc@redhat.com
References: <166182871735.3518559.8884121293045337358.stgit@omen>
 <39145649-c378-d027-8856-81b4f09050fc@redhat.com>
 <20220830091110.3f6d1737.alex.williamson@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH] vfio/type1: Unpin zero pages
In-Reply-To: <20220830091110.3f6d1737.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30.08.22 17:11, Alex Williamson wrote:
> On Tue, 30 Aug 2022 09:59:33 +0200
> David Hildenbrand <david@redhat.com> wrote:
> 
>> On 30.08.22 05:05, Alex Williamson wrote:
>>> There's currently a reference count leak on the zero page.  We increment
>>> the reference via pin_user_pages_remote(), but the page is later handled
>>> as an invalid/reserved page, therefore it's not accounted against the
>>> user and not unpinned by our put_pfn().
>>>
>>> Introducing special zero page handling in put_pfn() would resolve the
>>> leak, but without accounting of the zero page, a single user could
>>> still create enough mappings to generate a reference count overflow.
>>>
>>> The zero page is always resident, so for our purposes there's no reason
>>> to keep it pinned.  Therefore, add a loop to walk pages returned from
>>> pin_user_pages_remote() and unpin any zero pages.
>>>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: stable@vger.kernel.org
>>> Reported-by: Luboslav Pivarc <lpivarc@redhat.com>
>>> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
>>> ---
>>>  drivers/vfio/vfio_iommu_type1.c |   12 ++++++++++++
>>>  1 file changed, 12 insertions(+)
>>>
>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>> index db516c90a977..8706482665d1 100644
>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>> @@ -558,6 +558,18 @@ static int vaddr_get_pfns(struct mm_struct *mm, unsigned long vaddr,
>>>  	ret = pin_user_pages_remote(mm, vaddr, npages, flags | FOLL_LONGTERM,
>>>  				    pages, NULL, NULL);
>>>  	if (ret > 0) {
>>> +		int i;
>>> +
>>> +		/*
>>> +		 * The zero page is always resident, we don't need to pin it
>>> +		 * and it falls into our invalid/reserved test so we don't
>>> +		 * unpin in put_pfn().  Unpin all zero pages in the batch here.
>>> +		 */
>>> +		for (i = 0 ; i < ret; i++) {
>>> +			if (unlikely(is_zero_pfn(page_to_pfn(pages[i]))))
>>> +				unpin_user_page(pages[i]);
>>> +		}
>>> +
>>>  		*pfn = page_to_pfn(pages[0]);
>>>  		goto done;
>>>  	}
>>>
>>>   
>>
>> As discussed offline, for the shared zeropage (that's not even
>> refcounted when mapped into a process), this makes perfect sense to me.
>>
>> Good question raised by Sean if ZONE_DEVICE pages might similarly be
>> problematic. But for them, we cannot simply always unpin here.
> 
> What sort of VM mapping would give me ZONE_DEVICE pages?  Thanks,

I think one approach is mmap'ing a devdax device. To test without actual
NVDIMM hardware, there are ways to simulate it even on bare metal using
the "memmap=" kernel parameter.

https://nvdimm.wiki.kernel.org/

Alternatively, you can use an emulated nvdimm device under QEMU -- but
then you'd have to run VFIO inside the VM. I know (that you know) that
there are ways to get that working, but it certainly requires more effort :)

... let me know if you need any tips&tricks.

-- 
Thanks,

David / dhildenb

