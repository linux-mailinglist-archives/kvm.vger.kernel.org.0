Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18BAD6E7E40
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 17:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbjDSP3I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 11:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbjDSP3G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 11:29:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB06975C
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 08:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681918045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0JNpJwmiFACkqi0TsruUzwO4IifuU5oAc++33wIMhdE=;
        b=OVYMTVcb/jqxDC2nYzWwC5kaj6sxCid6nl6Ghl2aZA1jtYsr5IMk+lzpf3C/wikoslhCRh
        2vi2SSz+5KbWy4IQucedU8CaEt8HW7y5cX5w6XQX9gJMzEH4BiNgKIXGGRecbviO7Cb9oT
        gzRPJgGrvOhr6yTq75WYM4FVGUtULwY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-gZ2XdE70OT6iKXO46Hyduw-1; Wed, 19 Apr 2023 11:27:23 -0400
X-MC-Unique: gZ2XdE70OT6iKXO46Hyduw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-2ff4bc7a6a3so269645f8f.3
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 08:27:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681918043; x=1684510043;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0JNpJwmiFACkqi0TsruUzwO4IifuU5oAc++33wIMhdE=;
        b=l4h1sCf5knLJcECU5tjZkn02SrfB8H8k19Y+qbxyiHWjrAZzKdVjDh1OzOgsiLd0Gc
         zfhh6CzY5DNuY5puwl2CpZetCuMPIXoQ1m4+jyblHdU9Veqb47sa/k0GcxyFZOZRDDsq
         72a4WddBufHgOJTHHygabX4yx+vdSAQfwevXw5JSgZhPN/7c2Y9KzJtF7ZqHaZzhfcIE
         GvWoAWsZpX8Tc5KhasGAU1jOZlcaeLerJBZ5eMEsl4aAqcXfUcNReTk2HSuoJ9H/CUjH
         7wKjF2+qzD6isBtgKoizln92lJB/O+VuNlly41B1CduwxbUYiTiyJVL+w0fHzL2NfqZa
         n0Uw==
X-Gm-Message-State: AAQBX9cSoNnVt5nRjcyqbF8ZcAgXf4r607SuwVbvv4SmXVoeMO71FVDF
        d4uUnIEvXo3t142n+mAFV0ODLFSL4vemrKMKcdjLxE4EWPdNM7nMJ8bQBTupKlBIV8X/mB9qyiX
        9cOfMjR2/Qmuw
X-Received: by 2002:adf:f8d1:0:b0:2f8:c65:2966 with SMTP id f17-20020adff8d1000000b002f80c652966mr5108637wrq.32.1681918042719;
        Wed, 19 Apr 2023 08:27:22 -0700 (PDT)
X-Google-Smtp-Source: AKy350bQCca7TZwC/DY71GMkp8QP25n5qhAvm8+MNF70jK0dZKOeYRWfyCK5MJywgo5ohbve6IL3HA==
X-Received: by 2002:adf:f8d1:0:b0:2f8:c65:2966 with SMTP id f17-20020adff8d1000000b002f80c652966mr5108605wrq.32.1681918042384;
        Wed, 19 Apr 2023 08:27:22 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70b:7b00:7c52:a5fa:8004:96fd? (p200300cbc70b7b007c52a5fa800496fd.dip0.t-ipconnect.de. [2003:cb:c70b:7b00:7c52:a5fa:8004:96fd])
        by smtp.gmail.com with ESMTPSA id y9-20020a7bcd89000000b003f173c566b5sm2527616wmj.5.2023.04.19.08.27.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 08:27:21 -0700 (PDT)
Message-ID: <a7dcbf5f-8ccf-1078-4bde-6cd2ed883ae6@redhat.com>
Date:   Wed, 19 Apr 2023 17:27:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Chao Peng <chao.p.peng@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        dhildenb@redhat.com, Quentin Perret <qperret@google.com>,
        tabba@google.com, Michael Roth <michael.roth@amd.com>,
        wei.w.wang@intel.com, Mike Rapoport <rppt@kernel.org>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221202061347.1070246-1-chao.p.peng@linux.intel.com>
 <ZD1oevE8iHsi66T2@google.com>
 <658018f9-581c-7786-795a-85227c712be0@redhat.com>
 <ZD12htq6dWg0tg2e@google.com>
 <1ed06a62-05a1-ebe6-7ac4-5b35ba272d13@redhat.com>
 <ZD2bBB00eKP6F8kz@google.com>
 <9efef45f-e9f4-18d1-0120-f0fc0961761c@redhat.com>
 <ZD86E23gyzF6Q7AF@google.com>
 <5869f50f-0858-ab0c-9049-4345abcf5641@redhat.com>
 <ZEAGIe7m4lWW5mV+@google.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <ZEAGIe7m4lWW5mV+@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19.04.23 17:17, Sean Christopherson wrote:
> On Wed, Apr 19, 2023, David Hildenbrand wrote:
>> On 19.04.23 02:47, Sean Christopherson wrote:
>>> On Tue, Apr 18, 2023, David Hildenbrand wrote:
>>>> "memfd_vm" / "vm_mem" would be sooo (feel free to add some more o's here)
>>>> much easier to get. It's a special fd to be used to back VM memory. Depending
>>>> on the VM type (encrypted/protected/whatever), restrictions might apply (not
>>>> able to mmap, not able to read/write ...). For example, there really is no
>>>> need to disallow mmap/read/write when using that memory to back a simple VM
>>>> where all we want to do is avoid user-space page tables.
>>>
>>> In seriousness, I do agree with Jason's very explicit objection[2] against naming
>>> a non-KVM uAPI "guest", or any variation thereof.
>>
>> While I agree, it's all better than the naming we use right now ...
>>
>>
>> Let me throw "tee_mem" / "memfd_tee" into the picture. That could eventually
>> catch what we want to have.
>>
>> Or "coco_mem" / "memfd_coco".
>>
>> Of course, both expect that people know the terminology (just like what "vm"
>> stands for), but it's IMHO significantly better than
>> restricted/guarded/opaque/whatsoever.
>>
>> Again, expresses what it's used for, not why it behaves in weird ways.
> 
> I don't want to explicitly tie this to trusted execution or confidential compute,
> as there is value in backing "normal" guests with memory that cannot be accessed
> by the host userspace without jumping through a few extra hoops, e.g. to add a
> layer of protection against data corruption due to host userspace bugs.

Nothing speaks against using tee_mem for the same purpose I guess. I 
like the sound of it after all. :)

-- 
Thanks,

David / dhildenb

