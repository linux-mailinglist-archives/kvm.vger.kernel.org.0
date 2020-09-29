Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C915427C342
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 13:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbgI2LEL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 07:04:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51341 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728509AbgI2LDt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 07:03:49 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601377428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6miLrUQUJpi0ZbnLsa20/zYd3ZyHfOVi/SV5ZTHigpA=;
        b=gemMk8vunpLLk5k2bm2iQrPexmcEgxvHEvVJpIsKYNiGGvk6gG44o0UW1hqLqKc6act0Ll
        2YHGjRv9tYIzShq0dNE0woxKKuX/2JRqIIKMZxtlWRMDpNJaOrW2/qSh5EsO8eVj6u9nlS
        hXkHe+0oewg4imzG6D5cEU6bO+9lFPE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-o-KCWrciPo6jGsdG8PMdPw-1; Tue, 29 Sep 2020 07:03:45 -0400
X-MC-Unique: o-KCWrciPo6jGsdG8PMdPw-1
Received: by mail-wm1-f70.google.com with SMTP id m19so1681717wmg.6
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 04:03:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6miLrUQUJpi0ZbnLsa20/zYd3ZyHfOVi/SV5ZTHigpA=;
        b=JEfn5GT2imq8sLH9HFl7WKCPU6yRn13OuM0kN7kwwEtkCPe1K5YTu7A2ENNWp2cinc
         XUSYz0K0efnlJODiY+DFh58ac909AM10d39SmMrwtzC9uV5JTe+fjmp+m81Bglzyh26L
         LUwJHD02Aihsfo08kq1bMXoo+M/6CJrQiecOUnENRZBGjQ4h1bdQTuipeieRDnNV97nE
         UrCVaZqRYEG9ZaxjJ06iW87o6e69Qer7M1aNjm54DQj/kGGPmRX5ycK6neQ0lo/Ziw5R
         AlvOficDEXNBNckbNndiikyUG95KHDsJDImnJ/JzKnXGMoBQvhhHjGCkgqE0BUxW7BZf
         v2Aw==
X-Gm-Message-State: AOAM531Cmvpn3UOPuW9g8nlQVbyara/6cWrB2sjYd9fiMEv54QPANRTf
        4lEgQUhRxXIZlYQkGX83lY0rnK3dU7TTuZmrtNP7LL/g9YUubub/0VEzdhyouCeQM48GIfd4VEm
        Ta133ATkFdQJv
X-Received: by 2002:adf:fdcc:: with SMTP id i12mr3484202wrs.281.1601377424501;
        Tue, 29 Sep 2020 04:03:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzoSxbPLyRrVgl+fQ88NJqS/MyNf0tJGYIbVpUDvSZoeJEWCQ2UlaIOBdX35NI2Nhymxw0L2g==
X-Received: by 2002:adf:fdcc:: with SMTP id i12mr3484179wrs.281.1601377424282;
        Tue, 29 Sep 2020 04:03:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9dbe:2c91:3d1b:58c6? ([2001:b07:6468:f312:9dbe:2c91:3d1b:58c6])
        by smtp.gmail.com with ESMTPSA id j14sm5640340wrr.66.2020.09.29.04.03.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 04:03:43 -0700 (PDT)
Subject: Re: [PATCH v2 4/7] KVM: x86: hyper-v: always advertise
 HV_STIMER_DIRECT_MODE_AVAILABLE
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Jon Doron <arilou@gmail.com>, linux-kernel@vger.kernel.org
References: <20200924145757.1035782-1-vkuznets@redhat.com>
 <20200924145757.1035782-5-vkuznets@redhat.com>
 <ded79131-bef1-cb56-68ca-d2bc596a4425@redhat.com>
 <875z7wdg43.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <34ea6c7c-6c10-5cdb-de75-6b4afc023dd2@redhat.com>
Date:   Tue, 29 Sep 2020 13:03:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <875z7wdg43.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/09/20 12:36, Vitaly Kuznetsov wrote:
>> Sorry for the late reply.  I think this is making things worse.  It's
>> obviously okay to add a system KVM_GET_SUPPORTED_HV_CPUID, and I guess
>> it makes sense to have bits in there that require to enable a
>> capability.  For example, KVM_GET_SUPPORTED_CPUID has a couple bits such
>> as X2APIC, that we return even if they require in-kernel irqchip.
>>
>> For the vCPU version however we should be able to copy the returned
>> leaves to KVM_SET_CPUID2, meaning that unsupported features should be
>> masked.
> What I don't quite like about exposing HV_STIMER_DIRECT_MODE_AVAILABLE
> conditionally is that we're requiring userspace to have a certain
> control flow: first, it needs to create irqchip and only then call
> KVM_GET_SUPPORTED_HV_CPUID or it won't know that
> HV_STIMER_DIRECT_MODE_AVAILABLE is supported. 
> 
> Also, are you only concerned about HV_STIMER_DIRECT_MODE_AVAILABLE? E.g.
> PATCH3 of this series is somewhat similar, it exposes eVMCS even when
> the corresponding CAP wasn't enabled.

All of them, but this was only about the vCPU ioctl.  I agree with you
that the system ioctl should return everything unconditionally.

But perhaps the best thing to do is to deprecate the vCPU ioctl and just
leave it as is with all its quirks.

Paolo

> While I slightly prefer to get rid of this conditional feature exposure
> once and for all, I don't really feel very strong about it. We can have
> the system ioctl which always exposes all supported features and vCPU
> version which only exposes what is currently enabled. We would, however,
> need to preserve some inconsistency as a legacy: e.g. SynIC bits are now
> exposed unconditionally, even before KVM_CAP_HYPERV_SYNIC[2] is enabled
> (and if we change that we will break at least QEMU).

