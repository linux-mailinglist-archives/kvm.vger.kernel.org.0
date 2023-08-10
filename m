Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9747A7774AE
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 11:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbjHJJfL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 05:35:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbjHJJfI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 05:35:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86CE2D5F
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 02:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691660052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eZQ1UrO3pXfioDS5G776rsMtsdXOwQUomsUH8c+ASvc=;
        b=d2GOTzLvy7cuWoRiS23hiEQJL8VzPoh7f84aBz7JLcfZbpP+gYHMhWl2L6tVYka+NZ0MMO
        Z4ZKjIaMSGTOAaR2bu85diVbWxg7Tg/5vswfHdISFitETPGABj+haN2UogVijhG7EvTGRu
        smZR2/KSIV5zhostmP1gejHKF8AS4sY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-1IZMp0d6OVCsIb5irp166g-1; Thu, 10 Aug 2023 05:34:10 -0400
X-MC-Unique: 1IZMp0d6OVCsIb5irp166g-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3fe2fc65f1fso4304665e9.3
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 02:34:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691660049; x=1692264849;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eZQ1UrO3pXfioDS5G776rsMtsdXOwQUomsUH8c+ASvc=;
        b=FV7jhuACo6YZHhbnpHO8oUuXtABNZbAb6TTkC/XuGp5tipF7PZOqPNlUQ4sgGoSUVp
         DrhFvTtLdl3xDjLMcoTiNGvHdTRpA29aksNKBUH+M+2n5WU5GYqgsYALxmbMYAxa7+Oc
         LnAzqXTOPM4Qt8pvSRZTGzKuajDkerADgZGGuMVDvOcnCatPwo6xywRiPn4DI95eiOFi
         q8OMBRhZ1X943DwtpJECAqvycxpeg+y3pTu6+/1pSU45di1lPricY9umybuGy8uG6IWh
         LMIM1ElNYyan+Gn+hhdHfBSWKw20oq7eFNmrKRZKHZyM+F+Vh44G4B5p/tf/MKjXbQzI
         acjQ==
X-Gm-Message-State: AOJu0YxuoPrEdUhrOQALkjgzunQ8FiC407PeVDyYlI8TLnrunzQpFm6y
        RPfJ5mvr5siFKwQLwYxsR0xQPDXt1M9PEukWjaYAqI2LeR03mFKevovNI6GZYrFtfXuEIPSR9Nn
        KBNQBrvdbzHQp
X-Received: by 2002:a05:600c:254:b0:3fe:10d8:e7fa with SMTP id 20-20020a05600c025400b003fe10d8e7famr1422541wmj.41.1691660049436;
        Thu, 10 Aug 2023 02:34:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE5yXe9vL7tImqVqRug64hJBNl2Wwl4As7KFn3mriGnFbR0uj4kA1OXmyoV172388L152+YOw==
X-Received: by 2002:a05:600c:254:b0:3fe:10d8:e7fa with SMTP id 20-20020a05600c025400b003fe10d8e7famr1422528wmj.41.1691660049085;
        Thu, 10 Aug 2023 02:34:09 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id s13-20020a7bc38d000000b003fe2ebf479fsm1525174wmj.36.2023.08.10.02.34.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 02:34:08 -0700 (PDT)
Message-ID: <41a893e1-f2e7-23f4-cad2-d5c353a336a3@redhat.com>
Date:   Thu, 10 Aug 2023 11:34:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH v2 0/5] Reduce NUMA balance caused TLB-shootdowns in a
 VM
Content-Language: en-US
To:     Yan Zhao <yan.y.zhao@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, mike.kravetz@oracle.com,
        apopple@nvidia.com, jgg@nvidia.com, rppt@kernel.org,
        akpm@linux-foundation.org, kevin.tian@intel.com
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230810085636.25914-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10.08.23 10:56, Yan Zhao wrote:
> This is an RFC series trying to fix the issue of unnecessary NUMA
> protection and TLB-shootdowns found in VMs with assigned devices or VFIO
> mediated devices during NUMA balance.
> 
> For VMs with assigned devices or VFIO mediated devices, all or part of
> guest memory are pinned for long-term.
> 
> Auto NUMA balancing will periodically selects VMAs of a process and change
> protections to PROT_NONE even though some or all pages in the selected
> ranges are long-term pinned for DMAs, which is true for VMs with assigned
> devices or VFIO mediated devices.
> 
> Though this will not cause real problem because NUMA migration will
> ultimately reject migration of those kind of pages and restore those
> PROT_NONE PTEs, it causes KVM's secondary MMU to be zapped periodically
> with equal SPTEs finally faulted back, wasting CPU cycles and generating
> unnecessary TLB-shootdowns.
> 
> This series first introduces a new flag MMU_NOTIFIER_RANGE_NUMA in patch 1
> to work with mmu notifier event type MMU_NOTIFY_PROTECTION_VMA, so that
> the subscriber (e.g.KVM) of the mmu notifier can know that an invalidation
> event is sent for NUMA migration purpose in specific.
> 
> Patch 2 skips setting PROT_NONE to long-term pinned pages in the primary
> MMU to avoid NUMA protection introduced page faults and restoration of old
> huge PMDs/PTEs in primary MMU.
> 
> Patch 3 introduces a new mmu notifier callback .numa_protect(), which
> will be called in patch 4 when a page is ensured to be PROT_NONE protected.
> 
> Then in patch 5, KVM can recognize a .invalidate_range_start() notification
> is for NUMA balancing specific and do not do the page unmap in secondary
> MMU until .numa_protect() comes.
> 

Why do we need all that, when we should simply not be applying PROT_NONE 
to pinned pages?

In change_pte_range() we already have:

if (is_cow_mapping(vma->vm_flags) &&
     page_count(page) != 1)

Which includes both, shared and pinned pages.

Staring at page #2, are we still missing something similar for THPs?

Why is that MMU notifier thingy and touching KVM code required?

-- 
Cheers,

David / dhildenb

