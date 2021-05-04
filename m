Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B77372683
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 09:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhEDHYH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 03:24:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57690 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229897AbhEDHYG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 May 2021 03:24:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620112991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vDZzFVHUz6nuJ5xJd1dslJwLGgGS3xgzc5l8z25vt0g=;
        b=iuolmwkV5dhIJhz+qCL9x5nP+6Lbq2SaMAlv4nFzJYoXFx1Nt4JeVJhDiUSis4jldezBzL
        fMXJ8gAIzA5NVu3RNjFemqiEF4DnDLOuw0XQbnQs9hUfuKhSLADm5shEQ1y2AeXQE39OWB
        3kjuIud9B+/VpFH7YkPU7BeK7ZPP6Gw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-j2ZR6viaOb6kdoa6w_WkxA-1; Tue, 04 May 2021 03:23:08 -0400
X-MC-Unique: j2ZR6viaOb6kdoa6w_WkxA-1
Received: by mail-ed1-f72.google.com with SMTP id i2-20020a0564020542b02903875c5e7a00so5957443edx.6
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 00:23:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vDZzFVHUz6nuJ5xJd1dslJwLGgGS3xgzc5l8z25vt0g=;
        b=CFY9cHYb8z1InHFIr4IkE4WbeSzkis16sV2nNVoqivPjT2lzAjpUtDuI+996kSNyCT
         fBB6ak+2CnJ9BNiuxBLQzVD9q+HmiL7fuX1p6NP2pxSwvk/cG7Od/Mc5SGssNDYUTjFJ
         xpwxoXUr53su7HHg4VSXja3eVrjo66qnXPESJr/su07dV/EtPnPbCQyzpC9Or2/Vyxb1
         T2HTA/PvDCYOU4NfN3l2GsAOvRyzdKLqkrCXqXXxv+/r7G6JCu/XkDmNzjF5/thUW7DA
         P+AkP4LlSzSFKr2XIMRJzUzIqDVcwspVZjQ4D+N1hUX4Dnm4Zl/rMBR27VNO7Vo0VLy+
         GUtQ==
X-Gm-Message-State: AOAM533axc+rDXus09HuZu9Nnxkem25NInudtxZ3snC6OX/6GhrVyo4n
        wmq/q0do9czwPTOQQPnwyQsI+pOyIgILNGoElNJENVhvUhJDC0hAhhHbH7W7pzu6MaR2RhCJp0g
        bO2Fqbg+4AnN/
X-Received: by 2002:a17:906:1284:: with SMTP id k4mr19971121ejb.409.1620112987710;
        Tue, 04 May 2021 00:23:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzH+i8bygB46cYQo1fTbkLpUNZoJa+LXWC2Ieg7+dXmg88oJQA7q0vx3511SV/4Uuatr98sDg==
X-Received: by 2002:a17:906:1284:: with SMTP id k4mr19971092ejb.409.1620112987470;
        Tue, 04 May 2021 00:23:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h15sm915197ejs.72.2021.05.04.00.23.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 May 2021 00:23:06 -0700 (PDT)
Subject: Re: [PATCH v4] KVM: x86: Fix KVM_GET_CPUID2 ioctl to return cpuid
 entries count
To:     "Denis V. Lunev" <den@openvz.org>,
        Sean Christopherson <seanjc@google.com>,
        Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
Cc:     linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Shuah Khan <shuah@kernel.org>,
        Aaron Lewis <aaronlewis@google.com>,
        Alexander Graf <graf@amazon.com>,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Like Xu <like.xu@linux.intel.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20210428172729.3551-1-valeriy.vdovin@virtuozzo.com>
 <YIoFFl72VSeuhCRt@google.com>
 <0d68dbc3-8462-7763-fbad-f3b895fcf6e6@redhat.com>
 <be7eedf7-03a2-f998-079d-b18101b8b187@openvz.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <63e54361-0018-ad3b-fb2b-e5dba6a0f221@redhat.com>
Date:   Tue, 4 May 2021 09:23:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <be7eedf7-03a2-f998-079d-b18101b8b187@openvz.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/21 21:18, Denis V. Lunev wrote:
> On 5/3/21 5:54 PM, Paolo Bonzini wrote:
>> On 29/04/21 03:00, Sean Christopherson wrote:
>>> On Wed, Apr 28, 2021, Valeriy Vdovin wrote:
>>>> It's very explicit by the code that it was designed to receive some
>>>> small number of entries to return E2BIG along with the corrected
>>>> number.
>>>
>>> LOL, saying KVM_GET_CPUID2 was "designed" is definitely giving the KVM
>>> forefathers the benefit of the doubt.
>>
>> I was going to make a different joke, i.e. that KVM_GET_CPUID2 was
>> indeed designed the way Valeriy described, but that design was
>> forgotten soon after.
>>
>> Really, this ioctl has been such a trainwreck that I think the only
>> good solution here is to drop it.
>>
>> Paolo
>>
> 
> should we discuss KVM_GET_CPUID3 which will work "normally"?

Is anybody using KVM_GET_CPUID2 at all?

Paolo

