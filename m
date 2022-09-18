Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980915BBEEC
	for <lists+kvm@lfdr.de>; Sun, 18 Sep 2022 18:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiIRQSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Sep 2022 12:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiIRQSb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Sep 2022 12:18:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1191AF18
        for <kvm@vger.kernel.org>; Sun, 18 Sep 2022 09:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663517909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LBfOixkOjHpC0SlW/myuMM+eEQ6CMURRJUP0DN9jWbI=;
        b=WHDUNHz0KhDfgkHINtlmdq0wBCemQXyMj9TCkbuJI8CbSipsBu1y13lR/pwpxztnnN5LFN
        HXSWrPQ8QB7PUH1ybz9RUu0xDuN74wxYRp+LOiRUE7atPqQrJ5iHlwf3zu53QtmlrBwJcp
        0zSA0UjU78a1WlBHqeqHciMHnPa6fIY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-454-8shn3CzOPEWGuK4UX4D_vQ-1; Sun, 18 Sep 2022 12:18:28 -0400
X-MC-Unique: 8shn3CzOPEWGuK4UX4D_vQ-1
Received: by mail-qt1-f198.google.com with SMTP id w4-20020a05622a134400b0035cbc5ec9a2so8918503qtk.14
        for <kvm@vger.kernel.org>; Sun, 18 Sep 2022 09:18:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=LBfOixkOjHpC0SlW/myuMM+eEQ6CMURRJUP0DN9jWbI=;
        b=OuiAvudnCoMOwzMd8K20bROkVsMGKGcAhe844yS5qEZ864rWNiHzmK+HwiIAbLu2qU
         z93f4XRKHBQUZKZ/G65oSD0qmrNx2jH7iS6lip4LS7U/CUcexOACLnMwqf4Ptt+/Mbz8
         sfL5bSAU24KkBzqgulF4aH9wCZ6yGPjUi+tG3gq9cjK+8LWObXiSxWgTZN/GDdx3p5Qk
         9P6tfSZ68s7lgThZ20bCfvxBJuAnqMA+kCnoiJWaVXEv/X3QdnuHzK8RUsXx3kMOi3ni
         g+O6uHKzQLk+EYXW3KcLmhnyCTZHWtysT7kMW6F1khUjTJqJvnnNvCbtMAtei+b+96Hp
         9HGA==
X-Gm-Message-State: ACrzQf3ADk3hRlZCXnhb3cx2QwrNpan4rWLGOQVPOOyf1jZUDGqMduC3
        FAQO/PY6/Gefr+JodyzsWW0gsucroXOjRy42gQUSdW5iaBuVt5uuaZHB3iHVVmuAyVUscxikkf/
        uuJBvWr/CpLKo
X-Received: by 2002:a05:620a:2a0c:b0:6ce:7f98:d7a5 with SMTP id o12-20020a05620a2a0c00b006ce7f98d7a5mr10228421qkp.713.1663517907662;
        Sun, 18 Sep 2022 09:18:27 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4fgpD0KMAoAXpDXKH9gaDlFMR/QMWzXGxAYozX3WJQ8dzcwHKXfL1Yi6D9FrOIzRNTGWmuXw==
X-Received: by 2002:a05:620a:2a0c:b0:6ce:7f98:d7a5 with SMTP id o12-20020a05620a2a0c00b006ce7f98d7a5mr10228399qkp.713.1663517907447;
        Sun, 18 Sep 2022 09:18:27 -0700 (PDT)
Received: from ?IPV6:2a04:ee41:4:31cb:e591:1e1e:abde:a8f1? ([2a04:ee41:4:31cb:e591:1e1e:abde:a8f1])
        by smtp.gmail.com with ESMTPSA id v16-20020a05620a441000b006ceafb1aa92sm8124430qkp.96.2022.09.18.09.18.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 09:18:26 -0700 (PDT)
Message-ID: <d7e508d2-0f55-c417-107a-44c3315be030@redhat.com>
Date:   Sun, 18 Sep 2022 18:18:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 9/9] kvm_main.c: handle atomic memslot update
Content-Language: en-US
To:     "Yang, Weijiang" <weijiang.yang@intel.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20220909104506.738478-1-eesposit@redhat.com>
 <20220909104506.738478-10-eesposit@redhat.com>
 <7e64d472-fbce-6640-033a-51b8906b7924@intel.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <7e64d472-fbce-6640-033a-51b8906b7924@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 13/09/2022 um 04:30 schrieb Yang, Weijiang:
> 
> On 9/9/2022 6:45 PM, Emanuele Giuseppe Esposito wrote:
>> When kvm_vm_ioctl_set_memory_region_list() is invoked, we need
>> to make sure that all memslots are updated in the inactive list
>> and then swap (preferreably only once) the lists, so that all
>> changes are visible immediately.
> [...]
>> +static int kvm_vm_ioctl_set_memory_region_list(struct kvm *kvm,
>> +               struct kvm_userspace_memory_region_list *list,
>> +               struct kvm_userspace_memory_region_entry __user *mem_arg)
>> +{
>> +    struct kvm_userspace_memory_region_entry *mem, *m_iter;
>> +    struct kvm_userspace_memory_region *mem_region;
>> +    struct kvm_internal_memory_region_list *batch, *b_iter;
>> +    int i, r = 0;
>> +    bool *as_to_swap;
>> +
>> +    /* TODO: limit the number of mem to a max? */
>> +
>> +    if (!list->nent)
>> +        return r;
>> +
>> +    mem = vmemdup_user(mem_arg, array_size(sizeof(*mem), list->nent));
>> +    if (IS_ERR(mem)) {
>> +        r = PTR_ERR(mem);
>> +        goto out;
>> +    }
> 
> IMO, it's more natural to dup the user memory at the first place, i.e.,
> kvm_vm_ioctl,
> 
> it also makes the outlets shorter.
> 

I followed the same pattern as kvm_vcpu_ioctl_set_cpuid2, which performs
the user memory dup inside the call :)

I see your point but I guess it's better to keep all ioctl
implementations similar.

Thank you,
Emanuele

