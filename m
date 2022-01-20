Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36AE4948D9
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 08:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239923AbiATHsa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 02:48:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234741AbiATHs3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 02:48:29 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D63C061574;
        Wed, 19 Jan 2022 23:48:29 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id c66so3481922pfc.6;
        Wed, 19 Jan 2022 23:48:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=JbYFvNF151zWjhr7eZdq6LQppTjpTqHyi8Y4T7hLZ+Y=;
        b=iWkHfBMOzSNyLyYxN6/roPAYODwihEek7EVQu5ztN8P0+RbOzwWBXJdRkgz8c/syGm
         OO8Se+6X7jK+XRQno2zHbcFqUx0h9IlHsuoZoVeld0uY4tAOpWpr9Av6atzGM3M/2DUw
         CPerF2PoWLI7b//MuBE27BHIcdfZgR2kIPFJFVNrNaypk7g8lD0ddCSENT4fwg4nPbMr
         2aB55pmy1ytW1a0kKe6v6BP/P1VjO1X7QjNNsMcuBfrNybh2yI3lxbkHFu1tYwsL0PCg
         thMLGY4XxnfOnGsn3FJZrKQcXvcNnWaPH08N7fUbRRX5GWm46YIkwwNEYGJrSmOTJK5J
         I8Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=JbYFvNF151zWjhr7eZdq6LQppTjpTqHyi8Y4T7hLZ+Y=;
        b=lGVJ+SLR7HOlxMH6wQ5aRXC+qc2ynOPfEjSkxqNMDkw1vATBzPEP+KZ/vmVcOuJ6c9
         7UtnVR6BQeyuz8vNYh4mmTTzTLzqXbaYWdBE7qLIMTCteKNxVWDAMBfC/64g5VgrIXOT
         HrEglRbjzjDYc9Eh66y2052v6bFrdscqKeyE0y1yB7RoLEC98bC9bsIHmOAz9ce1JJEU
         sg9WQuWG7MLcSYYpmYMot9Dn4O95QO1XfHME3B6YSbfCyzVz2WcNKwayPnptyb2LIA6i
         QptAJJceVaquBQZde+XeeHPOeTjQG/UCJE5LvYMxpI0g82bxVteDLwx8zOTSIGxjTFlC
         QZaw==
X-Gm-Message-State: AOAM533H38YpsUyQF02oJNo/B4TXK52MgD3Zsh3j6XXplGvsVyRVuxpo
        ftuoupdR69skmssyPTAHAgg=
X-Google-Smtp-Source: ABdhPJxMFcfTtEOFUiRtq7uxukhzX+XOJxvxyJhHacSOpp/vaUtRZmKpvpJiLt0AGh4EsbYLyg058Q==
X-Received: by 2002:a05:6a00:138d:b0:4c3:58f2:18d3 with SMTP id t13-20020a056a00138d00b004c358f218d3mr23032962pfg.35.1642664908808;
        Wed, 19 Jan 2022 23:48:28 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d16sm2131094pfu.9.2022.01.19.23.48.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jan 2022 23:48:28 -0800 (PST)
Message-ID: <92b16faf-c9a7-4be3-43f7-3450259346e9@gmail.com>
Date:   Thu, 20 Jan 2022 15:48:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [DROP][PATCH] KVM: x86: Fix the #GP(0) and #UD conditions for
 XSETBV emulation
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220117072456.71155-1-likexu@tencent.com>
 <a133d6e2-34de-8a41-475e-3858fc2902bf@redhat.com>
 <9c655b21-640f-6ce8-61b4-c6444995091e@gmail.com>
 <0d7ed850-8791-42b4-ef9a-bbaa8c52279e@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <0d7ed850-8791-42b4-ef9a-bbaa8c52279e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/1/2022 7:18 pm, Paolo Bonzini wrote:
> On 1/17/22 10:44, Like Xu wrote:
>>> Also, the "Fixes" tag is not really correct as the behavior was the same 
>>> before.  Rather, it fixes commit 02d4160fbd76 ("x86: KVM: add xsetbv to the 
>>
>> It seems the original code comes from 81dd35d42c9a ("KVM: SVM: Add xsetbv 
>> intercept").
>> 2acf923e38 ("KVM: VMX: Enable XSAVE/XRSTOR for guest") and 92f9895c146d.
>>
>>> emulator", 2019-08-22).  Checking OSXSAVE is a bug in the emulator path, even 
>>> though it's not needed in the XSETBV vmexit case.
>>
>> The kvm_emulate_xsetbv() has been removed from the emulator path.
>> I'm not really sure why it's not needed in the XSETBV vmexit case. More details ?
> 
> Nevermind, I confused AMD (where #UD is generated before checking for 
> exceptions) with Intel where it's unconditional.
> 
> So the bug should be there since 2acf923e38 by executing XSETBV with 
> CR4.XSAVE=0.  If so, please include a testcase.

In the testcase "executing XSETBV with CR4.XSAVE=0",

- on the VMX, #UD delivery does not require vm-exit;
- on the SVM, #UD is trapped but goes to the ud_interception() path;

There is no room to run this pointless patch.
Thank you and sorry for the noise.

> 
> Paolo
> 
>>>
>>> Thanks,
>>>
>>> Paolo
>>>
>>>> +    if ((is_protmode(vcpu) && static_call(kvm_x86_get_cpl)(vcpu) != 0) ||
>>>>           __kvm_set_xcr(vcpu, kvm_rcx_read(vcpu), kvm_read_edx_eax(vcpu))) {
>>>>           kvm_inject_gp(vcpu, 0);
>>>>           return 1;
>>>
>>>
>>
> 
> 
