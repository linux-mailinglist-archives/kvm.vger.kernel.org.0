Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48B646F386
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 19:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhLITBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 14:01:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhLITBD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 14:01:03 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45913C0617A1;
        Thu,  9 Dec 2021 10:57:29 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id w1so22482852edc.6;
        Thu, 09 Dec 2021 10:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aNV9iTbuRCMcyqqkrIODJw+a80kaeU6aMky6NsPwR3o=;
        b=ELSJBc5tobqgXdS9QgqjJ2TyxAdjhIK7t9CfvCWM0jzTY9EdmcTyEAivFmMI/S9Fe2
         o+Tx6Hm1DNgEzIJHjhQLoLXzzfJvWDbXF5A6OHwW1i3J5RXEu9t+TgrqIV+i3PdTaj68
         Ek/xTovrHmUP0+3ORmdHK7/chKUGiUWjtjg9ABDvb9oCpnte3ino14mgG05sw/CqGdAa
         OtCsI1KZGDNoAljguvNsrLPYdbZa8Cfx3pc82XjK2mvkx9UlnPm0BkZ1GjJBX4pwoGw9
         iPqy7e2uvs0bunDq7g5H/iB7EXXCvr7HpVzL61DsSehmA3UrYycNLX3MFzg9SUHzMwEu
         NX/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aNV9iTbuRCMcyqqkrIODJw+a80kaeU6aMky6NsPwR3o=;
        b=1xL6ZY8FVwVBBaMupCeThN33qekhz+PySQiUIx46KZNOtV1eAkR7a5tI8VWmqfvgyA
         t5WnHtfoTL/pSuQHEZnOCtEP7I2bsOFEsXJYe3QRAYIgXjRglhcoP5oeA36+3CGBwXI/
         1vGqjmFi1lkmD1IckxBQmsJtfOl6OdNfIs7mqGT0zj8ldeB0AyChIWff6+i0Z7Za2z55
         5ZqCTH4cq6IUlAEnTTgs2GGjEqWBCgRLAUQWXYXj8edZtaIY+x9Pm97ivUiCZvj7Ocif
         GUSOcR/SvxSHCLOWyOR6+5Eqnyr5rW5Aw1khz6g6qvJOUzadOOVKEPksZVW3wnA7E7Uw
         JXfw==
X-Gm-Message-State: AOAM532rmCt0Sh2HjJAtWaKV3ysiQ48Aq5O6MRkVJ9v/npk/qoGn78r7
        heTLIvaOzOJGQw3CD4dPKWk+e3sqn6M=
X-Google-Smtp-Source: ABdhPJzaOMS8bQyns7DCEFUWph6gd5S4M4l4hnAcYOvaXqnpOv+SbT8Re+eL1P22uhFWsSU1FqLnlA==
X-Received: by 2002:a50:d883:: with SMTP id p3mr31519083edj.94.1639076247739;
        Thu, 09 Dec 2021 10:57:27 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id cw20sm306378ejc.90.2021.12.09.10.57.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 10:57:27 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <81fe9f7a-79d5-a77a-089d-99a3b89d78fb@redhat.com>
Date:   Thu, 9 Dec 2021 19:57:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 1/6] KVM: x86/pmu: Setup pmc->eventsel for fixed PMCs
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
References: <20211130074221.93635-1-likexu@tencent.com>
 <20211130074221.93635-2-likexu@tencent.com>
 <CALMp9eT05nb56b16KkybvGSTYMhkRusQnNL4aWFU8tsets0O2w@mail.gmail.com>
 <8ca78cd6-12ad-56c4-ad73-e88757364ba9@redhat.com>
 <CALMp9eR-eniyvu_zsqUHidoDX9V=eAA2zJXKPHdUT6SOY+EQrA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALMp9eR-eniyvu_zsqUHidoDX9V=eAA2zJXKPHdUT6SOY+EQrA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/21 19:53, Jim Mattson wrote:
>> How do we know that i < size? For example, Ice Lake supports 4 fixed
>> counters, but fixed_pmc_events only has three entries.
> 
> We don't, and it's a preexisting bug in intel_pmu_refresh.
> As Like points out, KVM_GET_SUPPORTED_CPUID indicates that only three
> fixed counters are supported. So, per the KVM contract, if userspace
> configures four in the guest cpuid info, all bets are off.

Out of bounds accesses are not part of the contract though, even if 
squashed by an unorthodox use of array_index_nospec.  So I'll post my hack.

> I don't like that contract, but changing it means introducing KVM_SET_CPUID3.

And especially it means getting it right, which is the difficult part.

Paolo
