Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0E93A0BF8
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 07:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbhFIFx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 01:53:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51105 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233165AbhFIFxz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Jun 2021 01:53:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623217921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zBlO5SUlBu4kEPbM4S2HV+BFWwYYvZMzotDUfmY4wqk=;
        b=CZR8+5naER1slbicg7cTs6B7Pzn2mdkcYpvdfUSkdiTm300KVy7NsMrPutZCP4H1RG+yy/
        AXIul7HC9D7UGTQ+TwcpbD7udj1/xLGp3LJElnwkCVRUSeR+MZ+UD8xraV8pCljazdkNW1
        Vg5QfL/gE3qGRmY/TYYmqDXV0mTuBmw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-1mMzUmslMQ-FNkv25yDhPQ-1; Wed, 09 Jun 2021 01:51:57 -0400
X-MC-Unique: 1mMzUmslMQ-FNkv25yDhPQ-1
Received: by mail-wm1-f70.google.com with SMTP id v20-20020a05600c2154b029019a6368bfe4so1501624wml.2
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 22:51:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zBlO5SUlBu4kEPbM4S2HV+BFWwYYvZMzotDUfmY4wqk=;
        b=URsPR91D6MkBoFmjm/7aLOLRT2y3tsi8DuohkJwnSgn6+P4V4eNdyyuM42WdklyT/1
         bqmDvODISBTIPOh2dxWL8OevEOxQiJYW03mBWDcjtDgb+Ve3WAjVvpB+fmV7uDdTDl8W
         +RGTbYkbvSaJZm7P86G9H5j0jNZiD6Pp1oH3oaizukrrffZAWuQoJ8599d3TFUeDjFFy
         smLEdFVAm2uqaNJToBNWdPznZS2DHzJXE0TnP3vsU+7shb4TcnlKqtKRHFUqgMecf09B
         suAIL9AcPV2lBuChIJY1VQQAFunEVASGkt9zn3AfWYiL2uybPe/9MSHLCBHxxvgq2Wy9
         ovjg==
X-Gm-Message-State: AOAM53151QddecI/9aVH5YghrzTgJ46Ycu2c2H2uKOCn9eJP4niD45m+
        S7XFolSb9wC+dhuDEpP3i4U7CpiIR6gAHkSpUg4RvfxHC5NJrHv36B+a7RLdSgLvWFreZ4Ytmp9
        qD7kfgv0eqCjM
X-Received: by 2002:a5d:568a:: with SMTP id f10mr3117911wrv.252.1623217916623;
        Tue, 08 Jun 2021 22:51:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJypZdy0ngsECXPmFiGY62B4hG9MP8f4LPp2rJ41kW29cDiE/x+WYEv9GMwZIqgrB1AiNqiaig==
X-Received: by 2002:a5d:568a:: with SMTP id f10mr3117897wrv.252.1623217916423;
        Tue, 08 Jun 2021 22:51:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o20sm4700490wms.3.2021.06.08.22.51.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 22:51:55 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] KVM: LAPIC: Reset TMCCT during vCPU reset
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1623050385-100988-1-git-send-email-wanpengli@tencent.com>
 <1623050385-100988-2-git-send-email-wanpengli@tencent.com>
 <0584d79d-9f2c-52dd-5dcc-beffd18f265b@redhat.com>
 <CANRm+Cx3LpnMwWHAvJoTErAdWoceO9DBPqY0UkbQHW-ZUHw5=g@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f8c80e8a-0749-eb5b-d5ab-162f504c9d33@redhat.com>
Date:   Wed, 9 Jun 2021 07:51:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CANRm+Cx3LpnMwWHAvJoTErAdWoceO9DBPqY0UkbQHW-ZUHw5=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/21 04:15, Wanpeng Li wrote:
> On Wed, 9 Jun 2021 at 00:27, Paolo Bonzini <pbonzini@redhat.com> wrote:
> [...]
>> Perhaps instead set TMCCT to 0 in kvm_apic_set_state, instead of keeping
>> the value that was filled in by KVM_GET_LAPIC?
> 
> Keeping the value that was filled in by KVM_GET_LAPIC is introduced by
> commit 24647e0a39b6 (KVM: x86: Return updated timer current count
> register from KVM_GET_LAPIC), could you elaborate more? :)

KVM_GET_LAPIC stores the current value of TMCCT and KVM_SET_LAPIC's 
memcpy stores it in vcpu->arch.apic->regs.  KVM_SET_LAPIC perhaps could 
store zero in vcpu->arch.apic->regs after it uses it, and then the 
stored value would always be zero.

Paolo

