Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD94977F15A
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 09:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348557AbjHQHjl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 03:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348509AbjHQHj1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 03:39:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC67D2D66
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 00:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692257922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hNX6iGWfWtgznBVcEU39c4WOS7GjaLk+AhKULELPJ68=;
        b=FQLJX+I4B8mOYlEOu5cPKDk/plSOgowWsYebbA5+HwGhqZz65c67Xp+j8NpPEIdSr2Fjmz
        XXxLa6DCiIx+jSBJlGkPmIxb6yN99KBPFl7WnPxzqemjTFKuLeywFUDqry15oBGZU1mPcx
        mUznIYeDcAzVYaO73vNSRQq5VZV8L4M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-x6Eh4N7OOw28R2ZQTZ9W9Q-1; Thu, 17 Aug 2023 03:38:41 -0400
X-MC-Unique: x6Eh4N7OOw28R2ZQTZ9W9Q-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3fe4f953070so48678725e9.2
        for <kvm@vger.kernel.org>; Thu, 17 Aug 2023 00:38:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692257920; x=1692862720;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hNX6iGWfWtgznBVcEU39c4WOS7GjaLk+AhKULELPJ68=;
        b=ImrJHSWjP4fEyF3M9E5Qlexb8t2U2OWakErr5UOsbem1cDM+5rer82Q4xh/XJbKZfO
         3QASLbp4wBqORpA1guC2Oo7XSvWvJYeRQJEvPzEMJx89CRpz/AYXnJyBs9yxX1OA+8Zw
         GZYRpl/P7QujzcnOJLXuQCVzXBK+f0JakHLEruM0qjqNVdRebU6lOPajPvQ0PCm8n66M
         A4z+cvnjCjFFIILJe5mGuu//26va6LyhRTvEzLJQZX2vMGyDxoRkzN68Lx2B5eS10TyX
         fSdslYt9JLPkBBj77tizbWF3purD6X3c6WRkCDx4qZ+MM+epaWuI6LvcGPc3l5nSu1XV
         yfpg==
X-Gm-Message-State: AOJu0YxLY6FUOs24HFKxVyOW1Aj+Q4xkTHVmZMTFp6C5K6+XO97BC9Po
        oKzem0lXOKejwSmFVDITPxFtCYtcM0CfSfhX1rwYqDff/RYPyKCmqwc6206+2k8OtECnkp1jgMF
        p4iwfCvVOu+Mr
X-Received: by 2002:a5d:610e:0:b0:319:7b57:8dc5 with SMTP id v14-20020a5d610e000000b003197b578dc5mr3099284wrt.54.1692257920017;
        Thu, 17 Aug 2023 00:38:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMupVkiUckbZbPaywGKv1CUrex5iaNb0W6ic9ImLtpdoKy0/hM4FBYORaNqKg4S3FiZ2Pueg==
X-Received: by 2002:a5d:610e:0:b0:319:7b57:8dc5 with SMTP id v14-20020a5d610e000000b003197b578dc5mr3099267wrt.54.1692257919567;
        Thu, 17 Aug 2023 00:38:39 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id z10-20020a5d4d0a000000b0031ad5a54bedsm1686403wrt.9.2023.08.17.00.38.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Aug 2023 00:38:38 -0700 (PDT)
Message-ID: <5c9e52ab-d46a-c939-b48f-744b9875ce95@redhat.com>
Date:   Thu, 17 Aug 2023 09:38:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v2 0/5] Reduce NUMA balance caused TLB-shootdowns in a
 VM
To:     Yan Zhao <yan.y.zhao@intel.com>, John Hubbard <jhubbard@nvidia.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        mike.kravetz@oracle.com, apopple@nvidia.com, jgg@nvidia.com,
        rppt@kernel.org, akpm@linux-foundation.org, kevin.tian@intel.com,
        Mel Gorman <mgorman@techsingularity.net>,
        alex.williamson@redhat.com
References: <6b48a161-257b-a02b-c483-87c04b655635@redhat.com>
 <1ad2c33d-95e1-49ec-acd2-ac02b506974e@nvidia.com>
 <846e9117-1f79-a5e0-1b14-3dba91ab8033@redhat.com>
 <d0ad2642-6d72-489e-91af-a7cb15e75a8a@nvidia.com>
 <ZNnvPuRUVsUl5umM@yzhao56-desk.sh.intel.com>
 <4271b91c-90b7-4b48-b761-b4535b2ae9b7@nvidia.com>
 <f523af84-59de-5b57-a3f3-f181107de197@redhat.com>
 <ZNyRnU+KynjCzwRm@yzhao56-desk.sh.intel.com>
 <ded3c4dc-2df9-2ef2-add0-c17f0cdfaf32@redhat.com>
 <37325c27-223d-400d-bd86-34bdbfb92a5f@nvidia.com>
 <ZN2qg4cPC2hEgtmY@yzhao56-desk.sh.intel.com>
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <ZN2qg4cPC2hEgtmY@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17.08.23 07:05, Yan Zhao wrote:
> On Wed, Aug 16, 2023 at 11:00:36AM -0700, John Hubbard wrote:
>> On 8/16/23 02:49, David Hildenbrand wrote:
>>> But do 32bit architectures even care about NUMA hinting? If not, just
>>> ignore them ...
>>
>> Probably not!
>>
>> ...
>>>> So, do you mean that let kernel provide a per-VMA allow/disallow
>>>> mechanism, and
>>>> it's up to the user space to choose between per-VMA and complex way or
>>>> global and simpler way?
>>>
>>> QEMU could do either way. The question would be if a per-vma settings
>>> makes sense for NUMA hinting.
>>
>>  From our experience with compute on GPUs, a per-mm setting would suffice.
>> No need to go all the way to VMA granularity.
>>
> After an offline internal discussion, we think a per-mm setting is also
> enough for device passthrough in VMs.
> 
> BTW, if we want a per-VMA flag, compared to VM_NO_NUMA_BALANCING, do you
> think it's of any value to providing a flag like VM_MAYDMA?
> Auto NUMA balancing or other components can decide how to use it by
> themselves.

Short-lived DMA is not really the problem. The problem is long-term pinning.

There was a discussion about letting user space similarly hint that 
long-term pinning might/will happen.

Because when long-term pinning a page we have to make sure to migrate it 
off of ZONE_MOVABLE / MIGRATE_CMA.

But the kernel prefers to place pages there.

So with vfio in QEMU, we might preallocate memory for the guest and 
place it on ZONE_MOVABLE/MIGRATE_CMA, just so long-term pinning has to 
migrate all these fresh pages out of these areas again.

So letting the kernel know about that in this context might also help.

-- 
Cheers,

David / dhildenb

