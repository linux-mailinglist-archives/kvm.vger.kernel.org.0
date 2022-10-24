Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D849260B3DA
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 19:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbiJXRSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 13:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbiJXRRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 13:17:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABB05AA08
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 08:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666626675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UBAegUasNa5RuqJ7q9GZwuYTzFErEwMDb+Eg1mrTrvE=;
        b=cjDyOZS9+qibKDaZiSwq7e78kgPyqnkljFRHJd6T7GuQVMvZxq8XwatN0BKWrRM6eWqB2G
        LHq74hKGZFBA4yZYNFqaH0KPFhZpef0RbiuEJHW88zL8nkBYccJuv0A3RMosc3fZOSeNJp
        IXZjgFyNEjS6yHVfMviNwvkthKjBxfE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-426-aQZadwx4N2yi2UwFoxvjGA-1; Mon, 24 Oct 2022 11:26:39 -0400
X-MC-Unique: aQZadwx4N2yi2UwFoxvjGA-1
Received: by mail-wr1-f69.google.com with SMTP id o13-20020adfa10d000000b00232c00377a0so3542365wro.13
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 08:26:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UBAegUasNa5RuqJ7q9GZwuYTzFErEwMDb+Eg1mrTrvE=;
        b=feFb1JmkLd8Vq2maGXG+s1Kw0Y4jvmVBM1jOAAJMkn2dJs/WlDLBb86S/BI8Fhx1rt
         mzyp92ArqrAP8nhfigUNymOipbyEOoUUQSW1yG5yFapHjAAoQjf+H4p9L0/9jnDHK3Uq
         JId2ZlUdx21kHRRbK1NZv8bLaN0/lWc/ndWgfYZ+1gStZroACVIWsS2FwSzd+Kn+z3eM
         o/utZVRo2FxwM126viPARVPrRclSGRr99Ks5xtTbOUzk+Y72eXSMn/EunY1knYUhYpw9
         TpiqKeGoKW+DzcAfz1WN4Os90N387shmi/wCipsstgHNy1tfBPUzEsOMMovqXPFWuy3T
         /cAQ==
X-Gm-Message-State: ACrzQf37uWm7MyJc3LVrPBri3CUxh5EfZOvZSmZRbeN+PItYRTN72gxX
        hWH8kxT6xFwZYOx7YsbQs+6f2ZbERddM5dRd4xgUarmOMAZK9VMGeE+6J2K6WTQFleSz9zCjl7A
        a/0eg4atTcxyV
X-Received: by 2002:a5d:5a11:0:b0:22e:3ed1:e426 with SMTP id bq17-20020a5d5a11000000b0022e3ed1e426mr21883682wrb.642.1666625197882;
        Mon, 24 Oct 2022 08:26:37 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4QYF0qpu+Yh4YQF+Y42ukyfMe46omRnCHz7TFmRMmq2+h+eVJ2IzD1faJk9A3cMFb5eNTxMw==
X-Received: by 2002:a5d:5a11:0:b0:22e:3ed1:e426 with SMTP id bq17-20020a5d5a11000000b0022e3ed1e426mr21883650wrb.642.1666625197580;
        Mon, 24 Oct 2022 08:26:37 -0700 (PDT)
Received: from ?IPV6:2003:cb:c704:f100:6371:a05b:e038:ac2c? (p200300cbc704f1006371a05be038ac2c.dip0.t-ipconnect.de. [2003:cb:c704:f100:6371:a05b:e038:ac2c])
        by smtp.gmail.com with ESMTPSA id k21-20020a05600c0b5500b003cdf141f363sm194606wmr.11.2022.10.24.08.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 08:26:37 -0700 (PDT)
Message-ID: <e0371b20-0edf-0fc3-71db-e0c94bd0f290@redhat.com>
Date:   Mon, 24 Oct 2022 17:26:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v8 1/8] mm/memfd: Introduce userspace inaccessible memfd
Content-Language: en-US
To:     "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Chao Peng <chao.p.peng@linux.intel.com>,
        Vishal Annapurve <vannapurve@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
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
        Yu Zhang <yu.c.zhang@linux.intel.com>, luto@kernel.org,
        jun.nakajima@intel.com, dave.hansen@intel.com, ak@linux.intel.com,
        aarcange@redhat.com, ddutile@redhat.com, dhildenb@redhat.com,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>, mhocko@suse.com,
        Muchun Song <songmuchun@bytedance.com>, wei.w.wang@intel.com
References: <20220915142913.2213336-1-chao.p.peng@linux.intel.com>
 <20220915142913.2213336-2-chao.p.peng@linux.intel.com>
 <CAGtprH_MiCxT2xSxD2UrM4M+ghL0V=XEZzEX4Fo5wQKV4fAL4w@mail.gmail.com>
 <20221021134711.GA3607894@chaop.bj.intel.com> <Y1LGRvVaWwHS+Zna@google.com>
 <20221024145928.66uehsokp7bpa2st@box.shutemov.name>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20221024145928.66uehsokp7bpa2st@box.shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24.10.22 16:59, Kirill A . Shutemov wrote:
> On Fri, Oct 21, 2022 at 04:18:14PM +0000, Sean Christopherson wrote:
>> On Fri, Oct 21, 2022, Chao Peng wrote:
>>>>
>>>> In the context of userspace inaccessible memfd, what would be a
>>>> suggested way to enforce NUMA memory policy for physical memory
>>>> allocation? mbind[1] won't work here in absence of virtual address
>>>> range.
>>>
>>> How about set_mempolicy():
>>> https://www.man7.org/linux/man-pages/man2/set_mempolicy.2.html
>>
>> Andy Lutomirski brought this up in an off-list discussion way back when the whole
>> private-fd thing was first being proposed.
>>
>>    : The current Linux NUMA APIs (mbind, move_pages) work on virtual addresses.  If
>>    : we want to support them for TDX private memory, we either need TDX private
>>    : memory to have an HVA or we need file-based equivalents. Arguably we should add
>>    : fmove_pages and fbind syscalls anyway, since the current API is quite awkward
>>    : even for tools like numactl.
> 
> Yeah, we definitely have gaps in API wrt NUMA, but I don't think it be
> addressed in the initial submission.
> 
> BTW, it is not regression comparing to old KVM slots, if the memory is
> backed by memfd or other file:
> 
> MBIND(2)
>         The  specified policy will be ignored for any MAP_SHARED mappings in the
>         specified memory range.  Rather the pages will be allocated according to
>         the  memory  policy  of the thread that caused the page to be allocated.
>         Again, this may not be the thread that called mbind().

IIRC, that documentation is imprecise/incorrect especially when it comes 
to memfd. Page faults in shared mappings will similarly obey the set 
mbind() policy when allocating new pages.

QEMU relies on that.

The "fun" begins when we have multiple mappings, and only some have a 
policy set ... or if we already, previously allocated the pages.

-- 
Thanks,

David / dhildenb

