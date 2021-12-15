Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFD34759DB
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 14:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237403AbhLONm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 08:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242974AbhLONmy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 08:42:54 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24D8C06173E;
        Wed, 15 Dec 2021 05:42:53 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id a18so38297105wrn.6;
        Wed, 15 Dec 2021 05:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PQjMxn6qJTOCu4WLYBTC7H6yDOVC/lj7pDQpiSi6VaI=;
        b=Y+sCX/uXXoSnqNOsQpRuA4Qer6cbTzPqlZvKri6W1VXh+wM9sN8nJmQKGeGuEMMTCh
         OzNUE7rX6ZJ+V38UFtFN+UNTvZpW+JTXIswzAjawhJCOgnGltRNtAPJiaTsBJUw1UE9n
         Fb6lELQtB52N1WyUSfeidytqaXSktzzhp9DIhSfAe37fbTH/VviFYODVL+1UaX223xVI
         7O9AQxYrpcNN+LUg7I8oUL4YntN85A/BbbwwuP4s6UD1ZBJ+blh/7Z97FaO4QzEADztO
         i7MBDagLm2PVOYkQcbDyc+leNoSKPt5yIEqtwbxgjeSknMiSTgirDW57xTpf/zi+jUt9
         du4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PQjMxn6qJTOCu4WLYBTC7H6yDOVC/lj7pDQpiSi6VaI=;
        b=Xx/oQchNgwLwII9xU0tO+KFHltFwXp9tAb0CUPVPV1r/CkBadeTHkZP6z1MjF7t55v
         Dzk+SqL8dCaXq4GuVPFIExzDleAu+A9IELmq2nX6F0PRE9srRWrv7Kw9x7LzqgpBk4lH
         r1oqNviLUIOGhn1DIw4pKg/10cwg4CvxkbHdVdiczv7Po9H6+5kciHVoRWuTSrShFRl6
         MipHxd2ynKNkRlvFw2BwcN5EWd4LaCOQ8PNH5t2UmhU2br3fa9aXI2ZxCC2G2bXrDFpN
         /XZeQGkfiVAL2xQEj0qY+75aG6iruRvn6QAkTchnvKiFHmVNEXNud0JGrwRnyjTAllx1
         qvXw==
X-Gm-Message-State: AOAM533ivcXQan1bSIq8faMEQpw0zYfjhX9MiFi6aa6sjuU9pDT2C7Iy
        /mJCrOtbOVldbLtz6dRYpeDIvXa6yhc=
X-Google-Smtp-Source: ABdhPJxcvMJ4OEvpcjc32m30jB/7icgUUTlB7pMFor2DIIcYMwjGGBvNxumXQVaznXM5L5xVld+02A==
X-Received: by 2002:a05:6000:10c4:: with SMTP id b4mr4047469wrx.514.1639575772365;
        Wed, 15 Dec 2021 05:42:52 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id v6sm5146887wmh.8.2021.12.15.05.42.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 05:42:51 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <cf329949-b81c-3e8c-0f38-4a28de22c456@redhat.com>
Date:   Wed, 15 Dec 2021 14:42:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 16/19] kvm: x86: Introduce KVM_{G|S}ET_XSAVE2 ioctl
Content-Language: en-US
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Cc:     "seanjc@google.com" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "jing2.liu@linux.intel.com" <jing2.liu@linux.intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-17-yang.zhong@intel.com>
 <d16aab21-0f81-f758-a61e-5919f223be78@redhat.com>
 <26ea7039-3186-c23f-daba-d039bb8d6f48@redhat.com>
 <86d3c3a5d61649079800a2038370365b@intel.com>
 <bdda79b5-79e4-22fd-9af8-ec6e87a412ab@redhat.com>
 <3ec6019a551249d6994063e56a448625@intel.com>
 <ba78d142-6a97-99dd-9d00-465f7d6aa712@redhat.com>
 <0c2dae4264ae4d3b87d023879c51833c@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <0c2dae4264ae4d3b87d023879c51833c@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/21 03:39, Wang, Wei W wrote:
>>> Why would KVM_GET_XSAVE2 still be needed in this case?
>>>
>>> I'm thinking it would also be possible to reuse KVM_GET_XSAVE:
>>>
>>> - If userspace calls to KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2),
>>>    then KVM knows that the userspace is a new version and it works with
>> larger xsave buffer using the "size" that it returns via KVM_CAP_XSAVE2.
>>>    So we can add a flag "kvm->xsave2_enabled", which gets set upon
>> userspace checks KVM_CAP_XSAVE2.
>>
>> You can use KVM_ENABLE_CAP(KVM_CAP_XSAVE2) for that, yes.  In that case
>> you don't need KVM_GET_XSAVE2.
>
> On more thing here, what size should KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2) return?
> If the size still comes from the guest CPUID(0xd, 0)::RCX, would it be better to just return 1?
> This requires that the QEMU CPUID info has been set to KVM before checking the cap.
> QEMU already has this CPUID info to get the size (seems no need to inquire KVM for it).

It's still easier to return the full size of the buffer from 
KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2).  It makes the userspace code a bit 
easier.

I'm also thinking that I prefer KVM_GET_XSAVE2 to 
KVM_ENABLE_CAP(KVM_CAP_XSAVE2), after all.  Since it would be a 
backwards-incompatible change to an _old_ ioctl (KVM_GET_XSAVE), I 
prefer to limit the ways that userspace can shoot itself in the foot.

Paolo
