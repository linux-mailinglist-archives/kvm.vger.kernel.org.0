Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2491B4368D1
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 19:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbhJURPi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 13:15:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:49957 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231701AbhJURPh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 13:15:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634836401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yllLqA21HI7HiQyi9iSL8DIj3iRFzAP86+C0IGx3f2Q=;
        b=YQnvIeUEoZ7uYMrqB5KuXBI4fBUQFflyVeot0aTJ3/Ksp2Gf8PbjZ9hNpBqh9Xbg9JTDXR
        JrgAEtLWoVZyp8KST7ZOwZlVcs/8jBbmbpYMgBY7o2BtO5BQkokOZo44rJr35/CamvHmeC
        HFKopSGMz5ptpT2smzZerXJX55eCwjU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-lqpIFdYlN-WoJg05Sx-w8w-1; Thu, 21 Oct 2021 13:13:19 -0400
X-MC-Unique: lqpIFdYlN-WoJg05Sx-w8w-1
Received: by mail-ed1-f69.google.com with SMTP id r25-20020a05640216d900b003dca3501ab4so1021292edx.15
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 10:13:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yllLqA21HI7HiQyi9iSL8DIj3iRFzAP86+C0IGx3f2Q=;
        b=Pn9quOQqv1F0fCF8FhzjP1Lr3J6h037E9Zn2fIgLX0A7FdRnbIIAayABtffjxh03Sp
         z9NMYmrKD0mqnI+Ogk2TcRtz3RRBkMFsr7jZTCSso1MqCQ/AOke5hdUD64p6/CFms2mj
         msavETQfvf0u403K0ySN1VQ+iZbh+1kL03OT7YZgXhPUf9jMNyclphy7pnVVW96cFCQm
         lsXKceOTrqVmGohvq8/iX9zwm5xY+HHY8WhD0mfsfx5TSnZczDsX+Op+/Z2W+DlidCes
         4p3TD8eWspI8wBgFcCZ36+jSU7TtRNc0pjLWZOf7PwXjQCRCkXzb6SYi5qx1ZNeQXXi4
         +bLA==
X-Gm-Message-State: AOAM531Z5N4n78jVnqBCtQ/pfZOLwenM8gxFuj8zrA5GAqBmg7mhhZ/s
        HcqlvuuynrOKH5mdnz1OQIkiJL2g6YHTjYZVinnY9/7Q+urVKp+0KU2K0OLmiC4GC49laiejKRr
        gflewBeQCUliI
X-Received: by 2002:a17:907:334f:: with SMTP id yr15mr9116754ejb.8.1634836398565;
        Thu, 21 Oct 2021 10:13:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWPR3wonWHNOs3y8vT+gjDmRUS38u9j+ZkN9PdXFXL5BIktKx51I1NPNokMxaEShcmMMwx3Q==
X-Received: by 2002:a17:907:334f:: with SMTP id yr15mr9116725ejb.8.1634836398392;
        Thu, 21 Oct 2021 10:13:18 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id y22sm3465397edc.76.2021.10.21.10.13.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 10:13:17 -0700 (PDT)
Message-ID: <945500f6-27e1-ed81-2b7d-c709cb1d4b33@redhat.com>
Date:   Thu, 21 Oct 2021 19:13:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 1/4] KVM: X86: Fix tlb flush for tdp in
 kvm_invalidate_pcid()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <20211019110154.4091-1-jiangshanlai@gmail.com>
 <20211019110154.4091-2-jiangshanlai@gmail.com> <YW7jfIMduQti8Zqk@google.com>
 <da4dfc96-b1ad-024c-e769-29d3af289eee@linux.alibaba.com>
 <YXBfaqenOhf+M3eA@google.com>
 <55abc519-b528-ddaa-120d-8d157b520623@linux.alibaba.com>
 <YXF+pG0yGA0TQZww@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YXF+pG0yGA0TQZww@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/10/21 16:52, Sean Christopherson wrote:
>> I think the EPT violation happens*after*  the cr3 write.  So the instruction to be
>> emulated is not "cr3 write".  The emulation will queue fault into guest though,
>> recursive EPT violation happens since the cr3 exceeds maxphyaddr limit.
> Doh, you're correct.  I think my mind wandered into thinking about what would
> happen with PDPTRs and forgot to get back to normal MOV CR3.
> 
> So yeah, the only way to correctly handle this would be to intercept CR3 loads.
> I'm guessing that would have a noticeable impact on guest performance.

Ouch... yeah, allow_smaller_maxphyaddr already has bad performance, but 
intercepting CR3 loads would be another kind of slow.

Paolo

> Paolo, I'll leave this one for you to decide, we have pretty much written off
> allow_smaller_maxphyaddr:-)

