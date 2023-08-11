Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE0D77960C
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 19:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235812AbjHKR0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Aug 2023 13:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233483AbjHKR0f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Aug 2023 13:26:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B5330CA
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 10:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691774750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X6sQ8Q6WelCDCKZ8Z8ftpDHYvOx3deYiCFU+E3Ltf9Y=;
        b=cMnDtgqYcWZMmKhSNJ8jt25f55SL4q83cWhGNwlj9nCCUeS4uyT0uGJHol1YOr1oD2ZuPE
        R93sJD+TupAVb6ZiNIe2azwMOY0DvxJpAQwJOgioYG25vedtfBmYwWyzjv6wpA2oKuhBUi
        Ltpk/weH367ibRnGlJtk19Nnk8ZIopo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-QdHXOxskNlihrUQLkgkkFw-1; Fri, 11 Aug 2023 13:25:49 -0400
X-MC-Unique: QdHXOxskNlihrUQLkgkkFw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3177af1ceacso1232231f8f.1
        for <kvm@vger.kernel.org>; Fri, 11 Aug 2023 10:25:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691774732; x=1692379532;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X6sQ8Q6WelCDCKZ8Z8ftpDHYvOx3deYiCFU+E3Ltf9Y=;
        b=G98t7viYHfn/GgxC8Ds3G4O6yoegrZ6GjH1aW0iD0H9j2QRBd3fiXh8ERj5ZvITPj7
         IlISEef/jlYroG8WUWvT6eZhGBUylSITLSZMpCTxHKSx/1ilZFRhXoqD8aAHEFG10ze0
         tACHdVNShU0o7eRakNJl2vc6QibVhIGpMJvhm2uxXhVQRZj6vBruvUUF1QBvVHk6q4vI
         NhiPH1e+u+zQOF1JYd2KZXbaeRcVWhLQCjqEMjcP/aKlXxmLg97Z/KrdhiBXC29dCc06
         RgDt6agy1smb9bwPEDXmO0Z+a536UdhU6NQsMSQmUm/lriiMWZVVfYrsGJgXaxRS0B9W
         jFjg==
X-Gm-Message-State: AOJu0Yx0w8ru4e2ey4A2rfCwSbRaGoMvBKQIapG98RPOBKSmB8zg9cxK
        WICJBgrD2o0I6Ku+slnjV8aF0WuhIabFWwCWzeRI9AJp9pdi5Bfi8t7SewbeEsM6TBjT7IO2yN+
        jKHZ9yR3uVYPB
X-Received: by 2002:adf:f511:0:b0:317:6b92:26b5 with SMTP id q17-20020adff511000000b003176b9226b5mr1820013wro.23.1691774732466;
        Fri, 11 Aug 2023 10:25:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESQhR+T4R/2hhEkOkTbdXkRMH8nFN557GFq/6P+WCs1OfxoSnCzpP/VC0zaopv5X94Y+Tueg==
X-Received: by 2002:adf:f511:0:b0:317:6b92:26b5 with SMTP id q17-20020adff511000000b003176b9226b5mr1820002wro.23.1691774732111;
        Fri, 11 Aug 2023 10:25:32 -0700 (PDT)
Received: from ?IPV6:2003:cb:c71a:3000:973c:c367:3012:8b20? (p200300cbc71a3000973cc36730128b20.dip0.t-ipconnect.de. [2003:cb:c71a:3000:973c:c367:3012:8b20])
        by smtp.gmail.com with ESMTPSA id o13-20020a05600c378d00b003fe2de3f94fsm5803925wmr.12.2023.08.11.10.25.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Aug 2023 10:25:31 -0700 (PDT)
Message-ID: <6b48a161-257b-a02b-c483-87c04b655635@redhat.com>
Date:   Fri, 11 Aug 2023 19:25:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v2 0/5] Reduce NUMA balance caused TLB-shootdowns in a
 VM
Content-Language: en-US
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        mike.kravetz@oracle.com, apopple@nvidia.com, jgg@nvidia.com,
        rppt@kernel.org, akpm@linux-foundation.org, kevin.tian@intel.com,
        John Hubbard <jhubbard@nvidia.com>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <41a893e1-f2e7-23f4-cad2-d5c353a336a3@redhat.com>
 <ZNSyzgyTxubo0g/D@yzhao56-desk.sh.intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <ZNSyzgyTxubo0g/D@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10.08.23 11:50, Yan Zhao wrote:
> On Thu, Aug 10, 2023 at 11:34:07AM +0200, David Hildenbrand wrote:
>>> This series first introduces a new flag MMU_NOTIFIER_RANGE_NUMA in patch 1
>>> to work with mmu notifier event type MMU_NOTIFY_PROTECTION_VMA, so that
>>> the subscriber (e.g.KVM) of the mmu notifier can know that an invalidation
>>> event is sent for NUMA migration purpose in specific.
>>>
>>> Patch 2 skips setting PROT_NONE to long-term pinned pages in the primary
>>> MMU to avoid NUMA protection introduced page faults and restoration of old
>>> huge PMDs/PTEs in primary MMU.
>>>
>>> Patch 3 introduces a new mmu notifier callback .numa_protect(), which
>>> will be called in patch 4 when a page is ensured to be PROT_NONE protected.
>>>
>>> Then in patch 5, KVM can recognize a .invalidate_range_start() notification
>>> is for NUMA balancing specific and do not do the page unmap in secondary
>>> MMU until .numa_protect() comes.
>>>
>>
>> Why do we need all that, when we should simply not be applying PROT_NONE to
>> pinned pages?
>>
>> In change_pte_range() we already have:
>>
>> if (is_cow_mapping(vma->vm_flags) &&
>>      page_count(page) != 1)
>>
>> Which includes both, shared and pinned pages.
> Ah, right, currently in my side, I don't see any pinned pages are
> outside of this condition.
> But I have a question regarding to is_cow_mapping(vma->vm_flags), do we
> need to allow pinned pages in !is_cow_mapping(vma->vm_flags)?

One issue is that folio_maybe_pinned...() ... is unreliable as soon as 
your page is mapped more than 1024 times.

One might argue that we also want to exclude pages that are mapped that 
often. That might possibly work.

> 
>> Staring at page #2, are we still missing something similar for THPs?
> Yes.
> 
>> Why is that MMU notifier thingy and touching KVM code required?
> Because NUMA balancing code will firstly send .invalidate_range_start() with
> event type MMU_NOTIFY_PROTECTION_VMA to KVM in change_pmd_range()
> unconditionally, before it goes down into change_pte_range() and
> change_huge_pmd() to check each page count and apply PROT_NONE.

Ah, okay I see, thanks. That's indeed unfortunate.

> 
> Then current KVM will unmap all notified pages from secondary MMU
> in .invalidate_range_start(), which could include pages that finally not
> set to PROT_NONE in primary MMU.
> 
> For VMs with pass-through devices, though all guest pages are pinned,
> KVM still periodically unmap pages in response to the
> .invalidate_range_start() notification from auto NUMA balancing, which
> is a waste.

Should we want to disable NUMA hinting for such VMAs instead (for 
example, by QEMU/hypervisor) that knows that any NUMA hinting activity 
on these ranges would be a complete waste of time? I recall that John H. 
once mentioned that there are similar issues with GPU memory:  NUMA 
hinting is actually counter-productive and they end up disabling it.

-- 
Cheers,

David / dhildenb

