Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC355EBE7E
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 11:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiI0JYk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 05:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbiI0JYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 05:24:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DB9116C29
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 02:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664270544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6+Ba1/Qa0bdARicBepVl0B2bwfkxaeMWLDXIhxaAd8k=;
        b=EeOA/5iwGUlOLM5Kpm189twXoxm8y9AEd1WTuJN6hZVSn20rVhh2NYIfLYG6VNXRB910H0
        m5uL0zPyB3pSsFdWr54c19af92Dblf8F0OdPcb8yGrG56+IooM6Yr7zTEDJ14rRghVQOoO
        +w/paGdPU697EBJYUlPLkiChmPcJ9o4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-645-g-ljfOf-MuWSnlGnNea_-g-1; Tue, 27 Sep 2022 05:22:23 -0400
X-MC-Unique: g-ljfOf-MuWSnlGnNea_-g-1
Received: by mail-wm1-f71.google.com with SMTP id t14-20020a1c770e000000b003b4856a6ecaso2550257wmi.2
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 02:22:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=6+Ba1/Qa0bdARicBepVl0B2bwfkxaeMWLDXIhxaAd8k=;
        b=YRUm3SISH0ruKripuTRpkKeQVaFDcEMoBzfQQSq5FqFrQnhtEwDnoO1smKqfewnzuk
         tbgdpwlMLJviczRtFK+A8yep8IZUtxggCzDrnyGce5oomT83bOAddC/jzwbYTquglSFU
         V4gNg6o+CRM4gkrGwPaWIydevxSjBLgZzHilB8iCwQ7h36ieQCHdJ6V6xKRjVRK7DCtJ
         H2AZAqpnhc3KrGlIcK+9iDFmsMFHWrpqPjp60+P2qEysG647jy/M/+hzelA5t/jmzzDN
         mq92Hlg7GM9uR1P9LRPrLM/BGBx+Ur5IREf1B7TLwZQSXOGqAlQpC6nE+UQG0Jv2y79l
         jVKg==
X-Gm-Message-State: ACrzQf1asKKkRCl2cOv9ZuxD2iC+G8P/tzTq71qDq0d+xbcHxh086oyI
        S5eQqzIHmTPWMUW0JrgFC07NjQj6evIn+U6qlq1SlJidyZPnOiEYPwlCGS6DUGLNyzqIQWRRTWy
        FMRHwC8/FIT95
X-Received: by 2002:a5d:6d4e:0:b0:22c:9dfd:4159 with SMTP id k14-20020a5d6d4e000000b0022c9dfd4159mr7051786wri.307.1664270542275;
        Tue, 27 Sep 2022 02:22:22 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5XU1e+ar3H07xcOqysuVeYiMro12Mx6YEVDsbU7wsLpdnjZ1sK2jRqwDOMRAqdXSPn1M3AAg==
X-Received: by 2002:a5d:6d4e:0:b0:22c:9dfd:4159 with SMTP id k14-20020a5d6d4e000000b0022c9dfd4159mr7051751wri.307.1664270541978;
        Tue, 27 Sep 2022 02:22:21 -0700 (PDT)
Received: from ?IPV6:2003:cb:c705:ff00:9ec2:6ff6:11a1:3e80? (p200300cbc705ff009ec26ff611a13e80.dip0.t-ipconnect.de. [2003:cb:c705:ff00:9ec2:6ff6:11a1:3e80])
        by smtp.gmail.com with ESMTPSA id d12-20020adfe88c000000b002205a5de337sm1226236wrm.102.2022.09.27.02.22.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 02:22:21 -0700 (PDT)
Message-ID: <a8c40c94-771c-ca3d-ee1d-44cbed2398e8@redhat.com>
Date:   Tue, 27 Sep 2022 11:22:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [RFC PATCH 9/9] kvm_main.c: handle atomic memslot update
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20220909104506.738478-1-eesposit@redhat.com>
 <20220909104506.738478-10-eesposit@redhat.com>
 <cde8be9d-64c0-80e5-7663-4302d075dcbc@redhat.com>
 <07014070-5186-ca95-7028-82f77612dedd@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <07014070-5186-ca95-7028-82f77612dedd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27.09.22 10:35, Emanuele Giuseppe Esposito wrote:
> 
> 
> Am 27/09/2022 um 09:46 schrieb David Hildenbrand:
>> On 09.09.22 12:45, Emanuele Giuseppe Esposito wrote:
>>> When kvm_vm_ioctl_set_memory_region_list() is invoked, we need
>>> to make sure that all memslots are updated in the inactive list
>>> and then swap (preferreably only once) the lists, so that all
>>> changes are visible immediately.
>>>
>>> The only issue is that DELETE and MOVE need to perform 2 swaps:
>>> firstly replace old memslot with invalid, and then remove invalid.
>>>
>>
>> I'm curious, how would a resize (grow/shrink) or a split be handled?
>>
> 
> There are only 4 operations possible in KVM: KVM_MR_{DELETE, MOVE,
> CREATE, FLAGS_ONLY}.
> 
> A resize should be implemented in QEMU as DELETE+CREATE.
> 
> Therefore a resize on memslot X will be implemented as:
> First pass on the userspace operations:
> 	invalidate memslot X;
> 	swap_memslot_list(); // NOW it is visible to the guest
> 
> What guest sees: memslot X is invalid, so MMU keeps retrying the page fault
> 
> Second pass:
> 	create new memslot X
> 	delete old memslot X

Thanks a lot for the very nice explanation!

Does the invalidation already free up memslot metadata (especially the 
rmaps) or will we end up temporarily allocating twice the memslot metadata?

-- 
Thanks,

David / dhildenb

