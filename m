Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 722C358EA1E
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 11:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbiHJJzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 05:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbiHJJz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 05:55:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C793226AFE
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 02:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660125326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m5UKomJJr5XDUN8t2Kmb7khiadiUQsrzaj90s+j66gQ=;
        b=fI8cMPhQIhB7cjMruazIzxRZJLxED0MV5GOTgXh9RRLmn5BSHVxXODLuAjmvjyq6z+8UUq
        wORPd0l7tlzEIEScVZVdPvESfvRu6/nQzm8EpP69UqK/DB4D7x0XROeRULZqmFU9hJyaiU
        VVt4nM7p341byCkxETEUc3PYJ2sKN3E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-rimLvj9kNdyPy1q5tZYLdw-1; Wed, 10 Aug 2022 05:55:23 -0400
X-MC-Unique: rimLvj9kNdyPy1q5tZYLdw-1
Received: by mail-wm1-f69.google.com with SMTP id c189-20020a1c35c6000000b003a4bfb16d86so7193818wma.3
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 02:55:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=m5UKomJJr5XDUN8t2Kmb7khiadiUQsrzaj90s+j66gQ=;
        b=z82B20YPPX9dI/L+dbWeechTxZthuo1pXdtNJnxD6EBNDVkJeEOSihUMw7XU5T1LlV
         Otq0Gm6ct9BF1Fha+tr5GZubXjmIQ8qjPB+xg7BmhuqzhJvlBINrmKH12ZMx+NuARcZz
         jEMSQFEMwH3VNyD25EMUqUmr5787GWKtMUqpNAYfF9wZIuXu1v+23X/qG3OuHFrj0Elb
         8YXGVxvJG0aDR6V/pAikChpiU6tfZ/xkOqZxgg6VLu5bC4bavCNbjsnvGTwwzmz+dz63
         YmTkr/v3k9/zHa8AVeo2hVf/7xmrgBOR/lmULXsZJa7HbEq+0Rkl9qy5LlqaDrpuihv6
         BOgQ==
X-Gm-Message-State: ACgBeo0cio2VKQdo2wIfi+NmLbsMRBhWfxePGDqr6H6gf63P2RK6hF4p
        xyb7JMsQHPTE/Dwu2CpWgWZFmTnHeC/3vCvFmajDU7G5h5Ha8EFrz7TT6ADFbNVVNWSu0iYWAWJ
        QUivcjQbDfiTB
X-Received: by 2002:a5d:64e4:0:b0:222:d4da:c2e1 with SMTP id g4-20020a5d64e4000000b00222d4dac2e1mr7468914wri.15.1660125322314;
        Wed, 10 Aug 2022 02:55:22 -0700 (PDT)
X-Google-Smtp-Source: AA6agR57ng+8LAmFqiWIYkxzU0qIaLTw96OSbpCj25JDzNCtyJxE1FXqxz6BaUC8mUFwvCSeHhucCg==
X-Received: by 2002:a5d:64e4:0:b0:222:d4da:c2e1 with SMTP id g4-20020a5d64e4000000b00222d4dac2e1mr7468880wri.15.1660125322007;
        Wed, 10 Aug 2022 02:55:22 -0700 (PDT)
Received: from ?IPV6:2003:cb:c707:1600:a3ce:b459:ef57:7b93? (p200300cbc7071600a3ceb459ef577b93.dip0.t-ipconnect.de. [2003:cb:c707:1600:a3ce:b459:ef57:7b93])
        by smtp.gmail.com with ESMTPSA id l3-20020a05600c4f0300b003a4bb3f9bc6sm1837127wmq.41.2022.08.10.02.55.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 02:55:21 -0700 (PDT)
Message-ID: <64ab9678-c72d-b6d9-8532-346cc9c06814@redhat.com>
Date:   Wed, 10 Aug 2022 11:55:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v7 05/14] mm/memfd: Introduce MFD_INACCESSIBLE flag
Content-Language: en-US
To:     Chao Peng <chao.p.peng@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
        qemu-devel@nongnu.org, linux-kselftest@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
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
 <20220706082016.2603916-6-chao.p.peng@linux.intel.com>
 <203c752f-9439-b5ae-056c-27b2631dcb81@redhat.com>
 <20220810093741.GE862421@chaop.bj.intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220810093741.GE862421@chaop.bj.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10.08.22 11:37, Chao Peng wrote:
> On Fri, Aug 05, 2022 at 03:28:50PM +0200, David Hildenbrand wrote:
>> On 06.07.22 10:20, Chao Peng wrote:
>>> Introduce a new memfd_create() flag indicating the content of the
>>> created memfd is inaccessible from userspace through ordinary MMU
>>> access (e.g., read/write/mmap). However, the file content can be
>>> accessed via a different mechanism (e.g. KVM MMU) indirectly.
>>>
>>> It provides semantics required for KVM guest private memory support
>>> that a file descriptor with this flag set is going to be used as the
>>> source of guest memory in confidential computing environments such
>>> as Intel TDX/AMD SEV but may not be accessible from host userspace.
>>>
>>> The flag can not coexist with MFD_ALLOW_SEALING, future sealing is
>>> also impossible for a memfd created with this flag.
>>
>> It's kind of weird to have it that way. Why should the user have to
>> care? It's the notifier requirement to have that, no?
>>
>> Why can't we handle that when register a notifier? If anything is
>> already mapped, fail registering the notifier if the notifier has these
>> demands. If registering succeeds, block it internally.
>>
>> Or what am I missing? We might not need the memfile set flag semantics
>> eventually and would not have to expose such a flag to user space.
> 
> This makes sense if doable. The major concern was: is there a reliable
> way to detect this (already mapped) at the time of memslot registering.

If too complicated, we could simplify to "was this ever mapped" and fail
for now. Hooking into shmem_mmap() might be sufficient for that to get
notified about the first mmap.

As an alternative, mapping_mapped() or similar *might* do what we want.



-- 
Thanks,

David / dhildenb

