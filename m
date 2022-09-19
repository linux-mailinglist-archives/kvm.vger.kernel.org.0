Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6A945BC3BD
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 09:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiISHxr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 03:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiISHxg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 03:53:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFF31EAE6
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 00:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663574013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+jF6oIsWPK5kJUJRdE/upBDeiuSKze81vSXS8eDi/Hk=;
        b=ehjRtvaojdJPDJYbLY/CEuTxebZ2zwaXmc9HyESX6lWsShrm/jxDCVgUqUdvN1VPFgHrpF
        zvT/tRZ8dkr2d9dreZITY/yIUr8MHFWFdaMmOrBLWjBa1AIkAhmZcMxTI45iWMCZuMWbr4
        5/slQBLm1JYkZ5b2szape0aXfQcSve8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-226-0op1y6MYPFKqPhnUxG1Z3g-1; Mon, 19 Sep 2022 03:53:32 -0400
X-MC-Unique: 0op1y6MYPFKqPhnUxG1Z3g-1
Received: by mail-wm1-f70.google.com with SMTP id f25-20020a7bc8d9000000b003b4768dcd9cso2320152wml.9
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 00:53:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=+jF6oIsWPK5kJUJRdE/upBDeiuSKze81vSXS8eDi/Hk=;
        b=HK5yS0aSEEAPo45v8Loq5GVTsvH1B7sc4Duk1S3t/J0NuLwnY9i8sL6M+eV76iLjYF
         DXRB1IlEumlqsz9Hy1bORZUXBoyKJF3YE4lIM5Vl3hqYIOqyr5EhiTNoji+g6gUgZOFv
         0BGIjUK0xe/X0J7RSMK/FeNLIqnaRKGY/CQy6l1b6Wu+1jg9Zbfv4pwl2yO+suaGFidB
         fARxNAhXY1nWsToySb7/yEnTRZUIbwUR3hqit8vnT3RdxUWx9vcvii1aTGbk1SY9PFTL
         uzb0s8ex04LVa719O96YVwkEXFE9CtBCdokk790VURzvyHhMpDD/vxlv2sO2iOkIh7JS
         EbfQ==
X-Gm-Message-State: ACrzQf0PU5rnWcG5QYtQUsE5MHY5FsFnhKA5F1Mu6f+H5vp2Fy5M+cSz
        uMOfcbtooEIIeWXkYVLE/mP4NjE5nsOFj8LBOOp2moV4NXU8BZeoYddJtRwDftclJVar/N4W9AB
        XD9+VyDm95FGs
X-Received: by 2002:a5d:64a4:0:b0:22a:85a3:55bd with SMTP id m4-20020a5d64a4000000b0022a85a355bdmr9940656wrp.340.1663574011283;
        Mon, 19 Sep 2022 00:53:31 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6cl/99Fb6zf0Iio6HOH0AZbm1zMjRncUlMjPbnKoJ7GvYswGK8HUjr6ToG6Z5yuJljlakZTw==
X-Received: by 2002:a5d:64a4:0:b0:22a:85a3:55bd with SMTP id m4-20020a5d64a4000000b0022a85a355bdmr9940641wrp.340.1663574011014;
        Mon, 19 Sep 2022 00:53:31 -0700 (PDT)
Received: from ?IPV6:2003:cb:c703:c100:c136:f914:345f:f5f3? (p200300cbc703c100c136f914345ff5f3.dip0.t-ipconnect.de. [2003:cb:c703:c100:c136:f914:345f:f5f3])
        by smtp.gmail.com with ESMTPSA id k24-20020adfd238000000b0022ad393ba3csm12594453wrh.107.2022.09.19.00.53.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 00:53:30 -0700 (PDT)
Message-ID: <37b3162e-7b3a-919f-80e2-f96eca7d4b4c@redhat.com>
Date:   Mon, 19 Sep 2022 09:53:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <20220909104506.738478-1-eesposit@redhat.com>
 <YxtOEgJhe4EcAJsE@google.com>
 <5f0345d2-d4d1-f4fe-86ba-6e22561cb6bd@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <5f0345d2-d4d1-f4fe-86ba-6e22561cb6bd@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18.09.22 18:13, Emanuele Giuseppe Esposito wrote:
> 
> 
> Am 09/09/2022 um 16:30 schrieb Sean Christopherson:
>> On Fri, Sep 09, 2022, Emanuele Giuseppe Esposito wrote:
>>> KVM is currently capable of receiving a single memslot update through
>>> the KVM_SET_USER_MEMORY_REGION ioctl.
>>> The problem arises when we want to atomically perform multiple updates,
>>> so that readers of memslot active list avoid seeing incomplete states.
>>>
>>> For example, in RHBZ https://bugzilla.redhat.com/show_bug.cgi?id=1979276
>>
>> I don't have access.  Can you provide a TL;DR?
> 
> You should be able to have access to it now.
> 
>>
>>> we see how non atomic updates cause boot failure, because vcpus
>>> will se a partial update (old memslot delete, new one not yet created)
>>> and will crash.
>>
>> Why not simply pause vCPUs in this scenario?  This is an awful lot of a complexity
>> to take on for something that appears to be solvable in userspace.
>>
> 
> I think it is not that easy to solve in userspace: see
> https://lore.kernel.org/qemu-devel/20200312161217.3590-1-david@redhat.com/
> 
> 
> "Using pause_all_vcpus()/resume_all_vcpus() is not possible, as it will
> temporarily drop the BQL - something most callers can't handle (esp.
> when called from vcpu context e.g., in virtio code)."

Can you please comment on the bigger picture? The patch from me works 
around *exactly that*, and for that reason, contains that comment.

-- 
Thanks,

David / dhildenb

