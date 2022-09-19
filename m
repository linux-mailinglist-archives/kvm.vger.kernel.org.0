Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B905BD3BA
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 19:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiISRan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 13:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbiISRaj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 13:30:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B7A1F600
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 10:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663608636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ktr9bDwDkSOY4tgjv0p5MEEpxq5LKhpeLVSkV/fxrFM=;
        b=HaY1XE4LQpNr+q/WQiKLcKJXoBzgB7Hqc1+JYTmaiEAvHX2dROi+8DTlJUYgWSe8oDaoC3
        lKZQCW27FAAIJjsuXbzmRYJoHYp9Hn2WHUDNucndmsUYimziL5Hh0bzZpa3taMqMDWqUzA
        WSUc+cN+g0a97k4YYVpSCR14MPzuSxg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-41-RQRUn-j5PRymdU9UXDsNbg-1; Mon, 19 Sep 2022 13:30:35 -0400
X-MC-Unique: RQRUn-j5PRymdU9UXDsNbg-1
Received: by mail-wr1-f71.google.com with SMTP id i27-20020adfaadb000000b0022a48b6436dso21047wrc.23
        for <kvm@vger.kernel.org>; Mon, 19 Sep 2022 10:30:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization
         :references:cc:to:from:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=Ktr9bDwDkSOY4tgjv0p5MEEpxq5LKhpeLVSkV/fxrFM=;
        b=pFm6ANVRJr4r/HkLTF37L6PWoA5m5mu+B2LCSpp8uqXeRI37B5761AaB2rfUpsSVvX
         cL5rpwcXlyJa3IZ+S/J2f9HcNPIPpxaY/UAabGSG46FGNHZv/2XXWM+iI83g2AN21jwH
         qLkr0gjRpMMLpjzKbVmmB3IVAwZBOoO6OpUMoLUdD98HiSXYvOtS8csEArLaVL1KXIWX
         eoBSpL22W77qTBG/cwERL8FXDDSTWIpjMRr4otuab4N4JCnyqk5cRWOOBz1+C9tZUmst
         9Tz3djy7gi9ODT8IJSXmmomDGIXKKx7QCcYgV2xO8ZlTN7DT9ukgNybO2cmOGYsj5CAj
         AeYg==
X-Gm-Message-State: ACrzQf2YgI+vNdpL6TbQ84phPvMKWUNp51beLPzgp+7LhM3Yq4inKVxA
        WxqZciylF70268jPw4JtQAFN3nSOJP1FG5BawKk+mc86y8R1TwPNs9zBI0gJ3Wx3APYlCZXy5vR
        tGSRLhy6V9wlX
X-Received: by 2002:adf:e4cc:0:b0:22a:d755:aaf7 with SMTP id v12-20020adfe4cc000000b0022ad755aaf7mr11545358wrm.692.1663608634010;
        Mon, 19 Sep 2022 10:30:34 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4I19lUmBRaG5mQQK/Ancn1KWYGCyHdn6tBeCNVCWmk9gTFjPn93e+WYIMWmDLnqR+MjCBlLQ==
X-Received: by 2002:adf:e4cc:0:b0:22a:d755:aaf7 with SMTP id v12-20020adfe4cc000000b0022ad755aaf7mr11545338wrm.692.1663608633645;
        Mon, 19 Sep 2022 10:30:33 -0700 (PDT)
Received: from ?IPV6:2003:cb:c703:c100:c136:f914:345f:f5f3? (p200300cbc703c100c136f914345ff5f3.dip0.t-ipconnect.de. [2003:cb:c703:c100:c136:f914:345f:f5f3])
        by smtp.gmail.com with ESMTPSA id p26-20020a05600c1d9a00b003b47ff307e1sm15027570wms.31.2022.09.19.10.30.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 10:30:33 -0700 (PDT)
Message-ID: <dfcbdf1d-b078-ec6c-7706-6af578f79ec2@redhat.com>
Date:   Mon, 19 Sep 2022 19:30:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Content-Language: en-US
From:   David Hildenbrand <david@redhat.com>
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
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Like Xu <like.xu.linux@gmail.com>
References: <20220909104506.738478-1-eesposit@redhat.com>
 <YxtOEgJhe4EcAJsE@google.com>
 <5f0345d2-d4d1-f4fe-86ba-6e22561cb6bd@redhat.com>
 <37b3162e-7b3a-919f-80e2-f96eca7d4b4c@redhat.com>
Organization: Red Hat
Subject: Re: [RFC PATCH 0/9] kvm: implement atomic memslot updates
In-Reply-To: <37b3162e-7b3a-919f-80e2-f96eca7d4b4c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19.09.22 09:53, David Hildenbrand wrote:
> On 18.09.22 18:13, Emanuele Giuseppe Esposito wrote:
>>
>>
>> Am 09/09/2022 um 16:30 schrieb Sean Christopherson:
>>> On Fri, Sep 09, 2022, Emanuele Giuseppe Esposito wrote:
>>>> KVM is currently capable of receiving a single memslot update through
>>>> the KVM_SET_USER_MEMORY_REGION ioctl.
>>>> The problem arises when we want to atomically perform multiple updates,
>>>> so that readers of memslot active list avoid seeing incomplete states.
>>>>
>>>> For example, in RHBZ https://bugzilla.redhat.com/show_bug.cgi?id=1979276
>>>
>>> I don't have access.  Can you provide a TL;DR?
>>
>> You should be able to have access to it now.
>>
>>>
>>>> we see how non atomic updates cause boot failure, because vcpus
>>>> will se a partial update (old memslot delete, new one not yet created)
>>>> and will crash.
>>>
>>> Why not simply pause vCPUs in this scenario?  This is an awful lot of a complexity
>>> to take on for something that appears to be solvable in userspace.
>>>
>>
>> I think it is not that easy to solve in userspace: see
>> https://lore.kernel.org/qemu-devel/20200312161217.3590-1-david@redhat.com/
>>
>>
>> "Using pause_all_vcpus()/resume_all_vcpus() is not possible, as it will
>> temporarily drop the BQL - something most callers can't handle (esp.
>> when called from vcpu context e.g., in virtio code)."
> 
> Can you please comment on the bigger picture? The patch from me works
> around *exactly that*, and for that reason, contains that comment.
> 

FWIW, I hacked up my RFC to perform atomic updates on any memslot 
transactions (not just resizes) where ranges do add overlap with ranges 
to remove.

https://github.com/davidhildenbrand/qemu/tree/memslot


I only performed simple boot check under x86-64 (where I can see region 
resizes) and some make checks -- pretty sure it has some rough edges; 
but should indicate what's possible and what the possible price might 
be. [one could wire up a new KVM ioctl and call it conditionally on 
support if really required]



-- 
Thanks,

David / dhildenb

