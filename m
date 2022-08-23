Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53A759D252
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 09:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240863AbiHWHhR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 03:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240494AbiHWHhO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 03:37:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6B8647C9
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 00:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661240232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HohlDOM1an5R3Aeg0WJ6GQRtA32+l/PSRz3n64TVcFI=;
        b=F8UFVaOpUKLnAPbZY5BDbh5cCH523dBc/Sd8j5y0Je0vnNi0KPpn1ExG4tHLknD8e4cD9y
        WdqGEVGCkHdMrkjVCafn6ywWqHL1RBykmSRWinoJ4ktg6Z3yHl24toiZOV84HiUueFceze
        es4OhKPP7S8v/OLPVNOg2mxsSLQXoJ8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-507-KEPII2IMMne9UWoDh6TZNQ-1; Tue, 23 Aug 2022 03:37:01 -0400
X-MC-Unique: KEPII2IMMne9UWoDh6TZNQ-1
Received: by mail-wr1-f71.google.com with SMTP id g11-20020adfa48b000000b002250d091f76so2024136wrb.3
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 00:37:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=HohlDOM1an5R3Aeg0WJ6GQRtA32+l/PSRz3n64TVcFI=;
        b=REmwCEjOsfwtegnr14YUeslPG6Bi6/P79YmZgisIL08VWl5KtGRQv1XnHR6jCuWzpe
         iG9DfQvQCljHEue0FoLfIrAyhO3bcYqjeXDD1aXgm4iwHVvHMbzCF497MIgGlFuR6l0b
         jwoCjGwkqQgPzCYEiQmq+Xv6eU0tH0vgO7pgiOmum28EQ28EmizKRgdyzBNMqf5M85Ft
         8BoU+UjfQhdfS5MawegX7amj6ylFX9FPz58sTYse3b8qa5WtOvotpIKAps5jpkhlx241
         M4dWh/0hdyy2lvKwccnEgkuEk2wKPZ5c6cIT5aHrm/Cpnb8En6mwvELCVtlB0VDNWrHn
         bbyw==
X-Gm-Message-State: ACgBeo2qOsJXphDkxGx82JENO0H4HtQf+cw8pmDuZM8dsweIOOJCRo0t
        bI8UwngoUJy8dmKetNN3XXiCkHE4E2DyPAX7pTgLaJZFsamda04u4B2gx2MIfeXF1dQ3daJu+pQ
        bfBEsG20dfXL5
X-Received: by 2002:a05:600c:4e04:b0:3a5:a34e:ae81 with SMTP id b4-20020a05600c4e0400b003a5a34eae81mr1210658wmq.147.1661240219940;
        Tue, 23 Aug 2022 00:36:59 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4NUFG4IFicJqv+j50eM5lq6Rzd1ri/9X+RKdy6Bv7oWpP5THIKdol8DYBnS2vZ39y/40KufQ==
X-Received: by 2002:a05:600c:4e04:b0:3a5:a34e:ae81 with SMTP id b4-20020a05600c4e0400b003a5a34eae81mr1210635wmq.147.1661240219655;
        Tue, 23 Aug 2022 00:36:59 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70b:1600:c48b:1fab:a330:5182? (p200300cbc70b1600c48b1faba3305182.dip0.t-ipconnect.de. [2003:cb:c70b:1600:c48b:1fab:a330:5182])
        by smtp.gmail.com with ESMTPSA id u18-20020adfdb92000000b0021eaf4138aesm16379582wri.108.2022.08.23.00.36.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 00:36:59 -0700 (PDT)
Message-ID: <8f6f428b-85e6-a188-7f32-512b6aae0abf@redhat.com>
Date:   Tue, 23 Aug 2022 09:36:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v7 01/14] mm: Add F_SEAL_AUTO_ALLOCATE seal to memfd
Content-Language: en-US
To:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Chao Peng <chao.p.peng@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, qemu-devel@nongnu.org,
        linux-kselftest@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Steven Price <steven.price@arm.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        luto@kernel.org, jun.nakajima@intel.com, dave.hansen@intel.com,
        ak@linux.intel.com, aarcange@redhat.com, ddutile@redhat.com,
        dhildenb@redhat.com, Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>, mhocko@suse.com,
        Muchun Song <songmuchun@bytedance.com>
References: <20220706082016.2603916-1-chao.p.peng@linux.intel.com>
 <20220706082016.2603916-2-chao.p.peng@linux.intel.com>
 <f39c4f63-a511-4beb-b3a4-66589ddb5475@redhat.com>
 <472207cf-ff71-563b-7b66-0c7bea9ea8ad@redhat.com>
 <20220817234120.mw2j3cgshmuyo2vw@box.shutemov.name>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220817234120.mw2j3cgshmuyo2vw@box.shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18.08.22 01:41, Kirill A. Shutemov wrote:
> On Fri, Aug 05, 2022 at 07:55:38PM +0200, Paolo Bonzini wrote:
>> On 7/21/22 11:44, David Hildenbrand wrote:
>>>
>>> Also, I*think*  you can place pages via userfaultfd into shmem. Not
>>> sure if that would count "auto alloc", but it would certainly bypass
>>> fallocate().
>>
>> Yeah, userfaultfd_register would probably have to forbid this for
>> F_SEAL_AUTO_ALLOCATE vmas.  Maybe the memfile_node can be reused for this,
>> adding a new MEMFILE_F_NO_AUTO_ALLOCATE flags?  Then userfault_register
>> would do something like memfile_node_get_flags(vma->vm_file) and check the
>> result.
> 
> I donno, memory allocation with userfaultfd looks pretty intentional to
> me. Why would F_SEAL_AUTO_ALLOCATE prevent it?
> 

Can't we say the same about a write()?

> Maybe we would need it in the future for post-copy migration or something?
> 
> Or existing practises around userfaultfd touch memory randomly and
> therefore incompatible with F_SEAL_AUTO_ALLOCATE intent?
> 
> Note, that userfaultfd is only relevant for shared memory as it requires
> VMA which we don't have for MFD_INACCESSIBLE.

This feature (F_SEAL_AUTO_ALLOCATE) is independent of all the lovely
encrypted VM stuff, so it doesn't matter how it relates to MFD_INACCESSIBLE.

-- 
Thanks,

David / dhildenb

