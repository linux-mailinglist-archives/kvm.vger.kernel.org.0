Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5488510AA43
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2019 06:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfK0Fi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Nov 2019 00:38:27 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39149 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfK0Fi0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Nov 2019 00:38:26 -0500
Received: by mail-pl1-f195.google.com with SMTP id o9so9232204plk.6;
        Tue, 26 Nov 2019 21:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PZ38mr03x4n0Hi0LAeX1Fyf6YARPd4dg2r2YT7NMoiY=;
        b=L3/bBq3sSJBUwl2YVUgyLOELI0a+o/FOycRflATLzcCeJCNNJkY+Fw7VkwcIDon3Kg
         ugwwMn7Js1ccKVhZ22EFm1LW+96wW2vQ2OxOAe5WiScf9glcLS06BigIdASmUSgndm2d
         PxJ31O8oA4f7fngDg4rnLHJQdFuC+FXsbdfBLmXJLrLJOURiT9JNHjDd61pkaFEkQKQs
         jDxMTWkMurjkSWcEIkN6EgJ8x0UgypJRu/Trc9IobcDz5a0qma/E1FyF3mEXJFBj1SZu
         fSYiHuuIpRzo55TiZczQ2oq5reYKwp3Q85VzLf2iXPkD3LwgEPl4dawN8Ol39CEXAurA
         Z0QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PZ38mr03x4n0Hi0LAeX1Fyf6YARPd4dg2r2YT7NMoiY=;
        b=TDzCbkgx/llHw7BA/CJg7uBQYXHqllnxvo8GVtnGnAUpQumjX+al3azsnHcf7z/NoK
         cZZygEE5FvXQEHobmtbQf04sBhY8gEMhVSOuy3wYPg3PbEidLPTrdWlVyMS+/UCztjzq
         Y5qgq4ZCZYFRd8OC7LhoWrSmRfFvlzpTgXEKfWhIwAAFhWP60aYJQu7OV2cmMM4ev6ux
         3wGMDfM6GbKpbvGMkubnFx/ikIZHYawteI6DFU/XLvfa5MSZ4QGrdee6msmF4hL1TwE+
         9hjyZzEUQSYAgWEw5Ka5gAzqBNL4TYyX7UThrMAa9Sk5jHek717Qj0DWeyWwPY5k2gGo
         pJlQ==
X-Gm-Message-State: APjAAAVWx5aX8SX+XceAK6pSSt5BGl1zn3iJjU5JU0LaF2vXZ3D5wMxx
        yu7mcb3uXVwkmuNj2jDDUA==
X-Google-Smtp-Source: APXvYqwnEPLb2M8pn4TGv5xLOmG5c1Exx5Qnq0/wCFptTmV3MfZBKKMpSg+QDpGxGpiXWKZLRuLF6A==
X-Received: by 2002:a17:902:a9c7:: with SMTP id b7mr2334855plr.41.1574833105932;
        Tue, 26 Nov 2019 21:38:25 -0800 (PST)
Received: from [127.0.0.1] ([203.205.141.52])
        by smtp.gmail.com with ESMTPSA id i9sm1259147pfk.24.2019.11.26.21.38.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2019 21:38:24 -0800 (PST)
Subject: Re: [PATCH] KVM: SVM: Fix "error" isn't initialized
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linmiaohe <linmiaohe@huawei.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
References: <3b418fab6b804c6cba48e372cce875c1@huawei.com>
 <20191127034443.GF22233@linux.intel.com>
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Message-ID: <7acdc897-5e7f-4c55-ce58-cc57e16628e4@gmail.com>
Date:   Wed, 27 Nov 2019 13:38:12 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191127034443.GF22233@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2019/11/27 11:44, Sean Christopherson wrote:
> On Wed, Nov 27, 2019 at 03:30:06AM +0000, linmiaohe wrote:
>>
>>> From: Haiwei Li <lihaiwei@tencent.com>
>>> Subject: [PATCH] initialize 'error'
>>>
>>> There are a bunch of error paths were "error" isn't initialized.
>> Hi,
>> In case error case, sev_guest_df_flush() do not set the error.
>> Can you set the value of error to reflect what error happened
>> in sev_guest_df_flush()?
>> The current fix may looks confused when print "DF_FLUSH failed" with
>> error = 0.
>> Thanks.
>>
>> PS: This is just my personal point.
> 
> Disclaimer: not my world at all...
> 
> Based on the prototype for __sev_do_cmd_locked(), @error is intended to be
> filled only if there's an actual response from the PSP, which is a 16-bit
> value.  So maybe init @psp_ret at the beginning of __sev_do_cmd_locked() to
> -1 to indicate the command was never sent to the PSP?  And update the
> pr_err() in sev_asid_flush() to explicitly state it's the PSP return?
> 

Thanks for your advise. Good point. I will send a new patch.
