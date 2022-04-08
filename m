Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568BC4F9D55
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 20:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239070AbiDHS4R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 14:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbiDHS4M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 14:56:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2FA773C3DC6
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 11:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649444047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9uyU2VFoeBsyhZOJQIlctyu40TJSn7XsF2RPXyVl1do=;
        b=bPbJpzFTWJ1kz+HbNC8CputV4kqjt3EqDmVP0l7nUYx4EsrhnA6u0XW00SgrmliA8NjrS6
        Z00od8mtowCCuTEsXKXNA5/iNoZKTpKJzUFSquw7JcFOWojwUqSYA0azShz0qBGpN2IC2K
        7KD05f5tQd02w3Ol4O/n4BAOCl4OHaE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-5L4_lN-iOD25V-O1rZWDuA-1; Fri, 08 Apr 2022 14:54:06 -0400
X-MC-Unique: 5L4_lN-iOD25V-O1rZWDuA-1
Received: by mail-wm1-f69.google.com with SMTP id a16-20020a05600c349000b0038e6392a346so4768778wmq.4
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 11:54:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=9uyU2VFoeBsyhZOJQIlctyu40TJSn7XsF2RPXyVl1do=;
        b=g3VNlSTuINsNOTAHWkT87tdbYs664NR9sd+G5nzve06zxNO3wV+DAyyJM9HwqpP4Fq
         Ah1KtAxejEZ3Ufr6lZm7qu+gDRgGzApoS4qpvbUkO+trF81Pxo1WuCFNUZ6YcuGINRfg
         SRPAvCwFFziC6sHXsfFmyLHbxHnC+A66oGQzMquHiC1SFMD5Hv9oQBNKetAsj/KaT4fk
         tzUPFYUGokabpAIRdNhALw+qJDWzPC2/WR/jX8msAxQN2Ld3hne8A3wZj9fBCedmGyOA
         pthC1K+8gtxLmuN+U/kxSdA5tlqrUJ1OCeFIE3rfp1e5aFt/CuMQlXIXnZMGsw/jmRwt
         oeoQ==
X-Gm-Message-State: AOAM530qeFAvnMRaY82fLB5U2wYjXuI8E43efBfyTXtpG8pytL8Gvg8h
        usa2auXcWFwUzgFkpyL0g3ld50n+WMxSkAheeCBeME1cHQAV1kPmElRvj+cj/cy4rAntEV9kXWx
        JZGriDJDJCxy7
X-Received: by 2002:a05:600c:4f96:b0:38e:7dbf:f80b with SMTP id n22-20020a05600c4f9600b0038e7dbff80bmr18613230wmq.2.1649444044839;
        Fri, 08 Apr 2022 11:54:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwfhFIN8L3LyDcNyYvbpwcm/BIFpkPDSLWEfCSbEb0j8Zms39cvKkg2Ev9kPXAaH+LcMXIctA==
X-Received: by 2002:a05:600c:4f96:b0:38e:7dbf:f80b with SMTP id n22-20020a05600c4f9600b0038e7dbff80bmr18613189wmq.2.1649444044533;
        Fri, 08 Apr 2022 11:54:04 -0700 (PDT)
Received: from ?IPV6:2003:cb:c704:fd00:612:f12b:a4a2:26b0? (p200300cbc704fd000612f12ba4a226b0.dip0.t-ipconnect.de. [2003:cb:c704:fd00:612:f12b:a4a2:26b0])
        by smtp.gmail.com with ESMTPSA id o19-20020a05600c511300b0038d0d8f67e5sm10994785wms.16.2022.04.08.11.54.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 11:54:04 -0700 (PDT)
Message-ID: <7ab689e7-e04d-5693-f899-d2d785b09892@redhat.com>
Date:   Fri, 8 Apr 2022 20:54:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Chao Peng <chao.p.peng@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Steven Price <steven.price@arm.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Andi Kleen <ak@linux.intel.com>
References: <20220310140911.50924-1-chao.p.peng@linux.intel.com>
 <20220310140911.50924-5-chao.p.peng@linux.intel.com>
 <Yk8L0CwKpTrv3Rg3@google.com>
 <02e18c90-196e-409e-b2ac-822aceea8891@www.fastmail.com>
 <YlB3Z8fqJ+67a2Ck@google.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v5 04/13] mm/shmem: Restrict MFD_INACCESSIBLE memory
 against RLIMIT_MEMLOCK
In-Reply-To: <YlB3Z8fqJ+67a2Ck@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08.04.22 19:56, Sean Christopherson wrote:
> On Thu, Apr 07, 2022, Andy Lutomirski wrote:
>>
>> On Thu, Apr 7, 2022, at 9:05 AM, Sean Christopherson wrote:
>>> On Thu, Mar 10, 2022, Chao Peng wrote:
>>>> Since page migration / swapping is not supported yet, MFD_INACCESSIBLE
>>>> memory behave like longterm pinned pages and thus should be accounted to
>>>> mm->pinned_vm and be restricted by RLIMIT_MEMLOCK.
>>>>
>>>> Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
>>>> ---
>>>>  mm/shmem.c | 25 ++++++++++++++++++++++++-
>>>>  1 file changed, 24 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>>> index 7b43e274c9a2..ae46fb96494b 100644
>>>> --- a/mm/shmem.c
>>>> +++ b/mm/shmem.c
>>>> @@ -915,14 +915,17 @@ static void notify_fallocate(struct inode *inode, pgoff_t start, pgoff_t end)
>>>>  static void notify_invalidate_page(struct inode *inode, struct folio *folio,
>>>>  				   pgoff_t start, pgoff_t end)
>>>>  {
>>>> -#ifdef CONFIG_MEMFILE_NOTIFIER
>>>>  	struct shmem_inode_info *info = SHMEM_I(inode);
>>>>  
>>>> +#ifdef CONFIG_MEMFILE_NOTIFIER
>>>>  	start = max(start, folio->index);
>>>>  	end = min(end, folio->index + folio_nr_pages(folio));
>>>>  
>>>>  	memfile_notifier_invalidate(&info->memfile_notifiers, start, end);
>>>>  #endif
>>>> +
>>>> +	if (info->xflags & SHM_F_INACCESSIBLE)
>>>> +		atomic64_sub(end - start, &current->mm->pinned_vm);
>>>
>>> As Vishal's to-be-posted selftest discovered, this is broken as current->mm
>>> may be NULL.  Or it may be a completely different mm, e.g. AFAICT there's
>>> nothing that prevents a different process from punching hole in the shmem
>>> backing.
>>>
>>
>> How about just not charging the mm in the first place?  There’s precedent:
>> ramfs and hugetlbfs (at least sometimes — I’ve lost track of the current
>> status).
>>
>> In any case, for an administrator to try to assemble the various rlimits into
>> a coherent policy is, and always has been, quite messy. ISTM cgroup limits,
>> which can actually add across processes usefully, are much better.
>>
>> So, aside from the fact that these fds aren’t in a filesystem and are thus
>> available by default, I’m not convinced that this accounting is useful or
>> necessary.
>>
>> Maybe we could just have some switch require to enable creation of private
>> memory in the first place, and anyone who flips that switch without
>> configuring cgroups is subject to DoS.
> 
> I personally have no objection to that, and I'm 99% certain Google doesn't rely
> on RLIMIT_MEMLOCK.
> 

It's unnacceptable for distributions to have random unprivileged users
be able to allocate an unlimited amount of unmovable memory. And any
kind of these "switches" won't help a thing because the distribution
will have to enable them either way.

I raised in the past that accounting might be challenging, so it's no
surprise that something popped up now.

RLIMIT_MEMLOCK was the obvious candidate, but as we discovered int he
past already with secretmem, it's not 100% that good of a fit (unmovable
is worth than mlocked). But it gets the job done for now at least.

So I'm open for alternative to limit the amount of unmovable memory we
might allocate for user space, and then we could convert seretmem as well.

Random switches are not an option.

-- 
Thanks,

David / dhildenb

