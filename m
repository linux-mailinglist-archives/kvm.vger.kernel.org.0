Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5395D6E73E9
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 09:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbjDSHW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 03:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbjDSHWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 03:22:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26E949E7
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 00:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681888922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FCCYf58WbiV7ZwiVXeHUCjynN8kwG+K1Gw0EryKxlNA=;
        b=Nl5QHTX9P9UAKj1HZkOlQSvyRs06ZeY6ODC+Mlo7vuAUwkEx3np+JeY2ipTlNs3wy5mpSe
        1zdm+N5cfrKps34CE4MKXnPWubhohPuwF/H/V6zyNi6hGdfjghsXRGNuQVp2booBLeA0bO
        vijN2Nr6fSwVW3uils2AD+CZ46+FT7U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-5OfRxNMwMfOYtJtHnSHV7w-1; Wed, 19 Apr 2023 03:22:01 -0400
X-MC-Unique: 5OfRxNMwMfOYtJtHnSHV7w-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f080f53c49so16384885e9.0
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 00:22:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681888920; x=1684480920;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :content-language:references:cc:to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FCCYf58WbiV7ZwiVXeHUCjynN8kwG+K1Gw0EryKxlNA=;
        b=jBdN6+fTL3xqANyE6anDvwYDu5eixILV0OfbPIy484/9hhuPtKH8BHgT+WVth0G7Ue
         ek6sLhzJnegpIumXaKiaKdSBlvjiiuhiGW091qZcv/EoOlsy3i7zneSyEkLs6KX9hAWn
         ub1JEd//e6y9iweSG2HVZ3Vh4F1GRdh3gpuyP0j17DgAxTIE0ZAwNwzjaRYu3/Lix8xw
         9/qU9L2tg5Dnm2VH3qXyA/GOLWKcG4x7WaRk5bWmmzirpMqdLRSkUaoar3IzTDyc0nbI
         Rgx7VdO7HETDU+OOIhlfUJDBWgl5Fmc/gMkYjlyxFMDpVQ7NwNhfUk25i0YZbUIb6uaT
         EbjQ==
X-Gm-Message-State: AAQBX9ePgxhTughbIeCLGaI7YcHlFw3kdohugU+3QNMYKrsv4tdZ97O6
        FN6zcErTiB1n+bGBOQe+gsuCSJS6GJQYOAJTwiKanj9CVcsbyBApkZ0aexALHZYcvqVVHW+ruwN
        UOI7OTL4MRawO
X-Received: by 2002:adf:ea4f:0:b0:2da:2aa0:13e8 with SMTP id j15-20020adfea4f000000b002da2aa013e8mr3873858wrn.26.1681888920568;
        Wed, 19 Apr 2023 00:22:00 -0700 (PDT)
X-Google-Smtp-Source: AKy350aNwuzmpbvYRPHoSltgT3RyKQDrpmpgLNn+Tljmbr7T+NCiG+eylILlLmRgC0uK/hpojLTqCA==
X-Received: by 2002:adf:ea4f:0:b0:2da:2aa0:13e8 with SMTP id j15-20020adfea4f000000b002da2aa013e8mr3873828wrn.26.1681888920083;
        Wed, 19 Apr 2023 00:22:00 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70b:7b00:7c52:a5fa:8004:96fd? (p200300cbc70b7b007c52a5fa800496fd.dip0.t-ipconnect.de. [2003:cb:c70b:7b00:7c52:a5fa:8004:96fd])
        by smtp.gmail.com with ESMTPSA id s9-20020a5d6a89000000b002cf1c435afcsm15031069wru.11.2023.04.19.00.21.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 00:21:59 -0700 (PDT)
Message-ID: <5869f50f-0858-ab0c-9049-4345abcf5641@redhat.com>
Date:   Wed, 19 Apr 2023 09:21:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
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
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
In-Reply-To: <ZD86E23gyzF6Q7AF@google.com>
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

On 19.04.23 02:47, Sean Christopherson wrote:
> On Tue, Apr 18, 2023, David Hildenbrand wrote:
>> On 17.04.23 21:16, Sean Christopherson wrote:
>>> Hidden/Concealed/etc - Too close to secretmem, suffers the "hidden from whom" problem,
>>> and depending on the use case, the memory may not actually be concealed from the
>>> user that controls the VMM.
>>>
>>> Restricted - "rmem" collides with "reserved memory" in code.
>>>
>>> Guarded - Conflicts with s390's "guarded storage", has the "from whom" problem.
>>>
>>> Inaccessible - Many of the same problems as "hidden".
>>>
>>> Unmappable - Doesn't cover things like read/write, and is wrong in the sense that
>>> the memory is still mappable, just not via mmap().
>>>
>>> Secured - I'm not getting anywhere near this one :-)
>>
>> The think about "secretmem" that I kind-of like (a little) is that it
>> explains what it's used for: storing secrets. We don't call it "unmapped"
>> memory because we unmap it from the directmap or "unpinnable" memory or
>> "inaccessible" memory ... or even "restricted" because it has restrictions
>> ... how the secrets are protected is kind of an implementation detail.
>>
>> So instead of describing *why*/*how* restrictedmem is the weird kid
>> (restricted/guarded/hidden/restricted/inaccessible/ ...), maybe rather
>> describe what it's used for?
>>
>> I know, I know, "there are other use cases where it will be used outside of
>> VM context". I really don't care.
> 
> Heh, we originally proposed F_SEAL_GUEST, but that was also sub-optimal[1] ;-)
> 
>> "memfd_vm" / "vm_mem" would be sooo (feel free to add some more o's here)
>> much easier to get. It's a special fd to be used to back VM memory. Depending
>> on the VM type (encrypted/protected/whatever), restrictions might apply (not
>> able to mmap, not able to read/write ...). For example, there really is no
>> need to disallow mmap/read/write when using that memory to back a simple VM
>> where all we want to do is avoid user-space page tables.
> 
> In seriousness, I do agree with Jason's very explicit objection[2] against naming
> a non-KVM uAPI "guest", or any variation thereof.

While I agree, it's all better than the naming we use right now ...


Let me throw "tee_mem" / "memfd_tee" into the picture. That could 
eventually catch what we want to have.

Or "coco_mem" / "memfd_coco".

Of course, both expect that people know the terminology (just like what 
"vm" stands for), but it's IMHO significantly better than 
restricted/guarded/opaque/whatsoever.

Again, expresses what it's used for, not why it behaves in weird ways.


> 
> An alternative that we haven't considered since the very early days is making the
> uAPI a KVM ioctl() instead of a memfd() flag or dedicated syscall.  Looking at the
> code for "pure shim" implementation[3], that's actually not that crazy of an idea.

Yes.

> 
> I don't know that I love the idea of burying this in KVM, but there are benefits
> to coupling restrictedmem to KVM (aside from getting out from behind this bikeshed
> that I created).

Yes, it's all better than jumping through hoops to come up with a bad 
name like "restrictedmem".

> 
> The big benefit is that the layer of indirection goes away.  That simplifies things
> like enhancing restrictedmem to allow host userspace access for debug purposes,
> batching TLB flushes if a PUNCH_HOLE spans multiple memslots, enforcing exclusive
> access, likely the whole "share with a device" story if/when we get there, etc.
> 
> The obvious downsides are that (a) maintenance falls under the KVM umbrella, but
> that's likely to be true in practice regardless of where the code lands, and

Yes.

> (b) if another use case comes along, e.g. the Gunyah hypervisor[4][5], we risk
> someone reinventing a similar solution.

I agree. But if it's as simple as providing an ioctl for that hypervisor 
that simply wires up the existing implementation, it's not too bad.

> 
> If we can get Gunyah on board and they don't need substantial changes to the
> restrictedmem implementation, then I'm all for continuing on the path we're on.
> But if Gunyah wants to do their own thing, and the lightweight shim approach is
> viable, then it's awfully tempting to put this all behind a KVM ioctl().

Right. Or we still succeed in finding a name that's not as bad as what 
we had so far.

-- 
Thanks,

David / dhildenb

