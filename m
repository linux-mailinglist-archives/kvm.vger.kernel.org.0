Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501BF2744E6
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 17:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgIVPC4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 11:02:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51528 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726566AbgIVPCy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 11:02:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600786973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sXdt9fw/2TfAWO/mEExo03IIhZLgGrVm6hP0Uymy1YA=;
        b=Lq0xNvbsPh+zdS04Ofizf9fcmZWDOBQRqm7XCuzZCkKFqp7IFKfIM5Vp5432RD0iWcbAzZ
        0H8sRsiFa+T8duSGfum6XPeOywYZLyscoOFzorCAx63swwfs/XVrk5ca4hNq/KfpKaSr6A
        IG8M6EmtTAms3/15SPqt3sds5QIsTXY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-5hGt41ZnNL-wIQGe6pon7A-1; Tue, 22 Sep 2020 11:02:50 -0400
X-MC-Unique: 5hGt41ZnNL-wIQGe6pon7A-1
Received: by mail-wm1-f69.google.com with SMTP id t8so659360wmj.6
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 08:02:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sXdt9fw/2TfAWO/mEExo03IIhZLgGrVm6hP0Uymy1YA=;
        b=m31L7fdZ4qiQoWEwZz9cSK/XRIQxgVjyCwOyN9BcGbNKnwfGLDSiIdCcVLXhQCHMJb
         2x48wKFsM0iQVbu3/oLH+zxgvwuoaITZEagFS3oOF+gxhLG8a9x5Fkjduz9unEga1/Qy
         GdOj+Y9O20ruBWweYq7pV0T7QcoE5NkafpFNRx0WHrMQMZJN9hew24mg3mV73G6OX0ec
         On3zWYH2gk6yxekTDum1UI2NYGtK9RtgKGeNqn8D52pIy8W7BqsmYnkrhVilQ+pf9Tws
         ARys4wj0evkOeE2d+WHP+SxS4sAhdP8CHV+sZAyg/1ORGAVhmYq49zxh3X61GA+VHNj6
         uSUQ==
X-Gm-Message-State: AOAM5301I3FVKyHTBi10bTHCGh424Fit6I1M143rT61R+4ROY1ERq2QE
        4Qz8tkkqOfdYBJVoF5eiCp1Dc/5od10NAhn82FB7t62erWN9liiAFmNDjVbV4KKVuPFcigs6kav
        BBVBQzGWmEvMk
X-Received: by 2002:a5d:69c9:: with SMTP id s9mr5824701wrw.348.1600786968815;
        Tue, 22 Sep 2020 08:02:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRvyk0As47yCKQ4K4LA3bzVIXSVekCW8ltcHuOYNeRajNkns6Q/QHxseNRPJDB06L6FIsMAQ==
X-Received: by 2002:a5d:69c9:: with SMTP id s9mr5824677wrw.348.1600786968569;
        Tue, 22 Sep 2020 08:02:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec2c:90a9:1236:ebc6? ([2001:b07:6468:f312:ec2c:90a9:1236:ebc6])
        by smtp.gmail.com with ESMTPSA id w21sm4965312wmk.34.2020.09.22.08.02.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 08:02:47 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Use a separate vmcb for the nested L2 guest
To:     Cathy Avery <cavery@redhat.com>, Wei Huang <wei.huang2@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com
References: <20200917192306.2080-1-cavery@redhat.com>
 <20200918211109.GA803484@weilap>
 <7549df39-b00b-0b0e-9f25-f64cdf6db366@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c3645ce6-5110-9bcc-450d-69e3f6aabc6a@redhat.com>
Date:   Tue, 22 Sep 2020 17:02:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <7549df39-b00b-0b0e-9f25-f64cdf6db366@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/09/20 16:07, Cathy Avery wrote:
>>>   -    if (npt_enabled)
>>> -        svm->vmcb->save.cr3 = hsave->save.cr3;
>>> +    if (!npt_enabled)
>>> +        svm->vmcb01->save.cr3 = kvm_read_cr3(&svm->vcpu);
>> Does this mean the original code is missing the following?
>>
>>          else
>>         svm->vmcb01->save.cr3 = kvm_read_cr3(&svm->vcpu);
> No it means I made an assumption here. I'll look at this again.

This should not be needed, nested_svm_load_cr3's call to kvm_init_mmu
should write to svm->vmcb->save.cr3.

>>>
>>> +    unsigned long vmcb01_pa;
>> Any reason that vmcb01_pa can't be placed in "struct vcpu_svm" below, along
>> with vmcb01?
> I just grouped it with the other nesting components. I can move it.

Please do it, vmcb01 is not part of nesting.

>     static inline struct vmcb *get_host_vmcb(struct vcpu_svm *svm)
>   {
> -    if (is_guest_mode(&svm->vcpu))
> -        return svm->nested.hsave;
> -    else
> -        return svm->vmcb;
> +    return svm->vmcb01; 

You can remove the function altogether (in a second patch).

Paolo

