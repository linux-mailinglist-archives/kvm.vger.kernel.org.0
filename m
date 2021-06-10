Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B703A2F5E
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 17:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhFJPds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 11:33:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50895 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231356AbhFJPdr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 11:33:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623339110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4ejIcZ8d5xgOmkEkmdVu8bslcTPC2PG7HhmoLIKG7Ig=;
        b=ZeMvd3mSf8OgbmKRNoz9UD0Kt/MGwArrQXiXVVneX7h/Tx5JXcvEWmAT0LXiTptguRj/1/
        ITqOn5G4A+qNhhVUQAf0jfkpvb1sdntr5ZN2z0pQKqff7ig0C8UMt0iNeZCpWPLLBHHZ7n
        G2CGbR2f5fXtFQ57jUoI+4bby2WjBEM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-mGA5r_oIOlmh-Pm86pFnXg-1; Thu, 10 Jun 2021 11:31:49 -0400
X-MC-Unique: mGA5r_oIOlmh-Pm86pFnXg-1
Received: by mail-wm1-f70.google.com with SMTP id o82-20020a1ca5550000b029019ae053d508so3119787wme.6
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 08:31:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4ejIcZ8d5xgOmkEkmdVu8bslcTPC2PG7HhmoLIKG7Ig=;
        b=FCMjLcfW2vZiLfbq6w4u7FA9ual8m/u0O+y/bYEJIh1L1L6dm8Lj74Lo2yYGz8XEDu
         LlMCW+3AQr7MGL7kXOAEehb7P2d9BIQFt1bhrH+mf+4d4mIYPIM1Cu/V9jn45eGNJ579
         Ke+x6E82ZkZZE6tytBFou5womJoH7bVr6wol3ajA6AUuITIQWq9Xsvz/HH4QXjSy+IC3
         msgKL0X5Df4QtF+aWvpBnG4evhsvj0H5ATsw+NISoqhmdKuhKMN5MUo7q1yn8WiYuP4g
         wD1GRPN7kTW+bXKamuCxqgwVFW63MW9NKlG1000EltC/VtBiPV3Q7yo/rtDSLZ30N4tW
         NPqQ==
X-Gm-Message-State: AOAM531JdmEflJ1xVriyifHBbagxDEAxgMYWnd89C4HBgRc6zjmVtJT2
        H4kGXWDpqJfpH/oU/POR6TqeKC5tHSqKO+G7324OrF5zZ0IIInNnkY89CVmO0rj5XT5qdAbTNb9
        6dTWh9Tz6JJMKw7N/juoD7gc64WX9Xb1HPKU1+Cri0+//FzHs5C739O260mPv6wC8
X-Received: by 2002:a1c:4e12:: with SMTP id g18mr11603264wmh.101.1623339108136;
        Thu, 10 Jun 2021 08:31:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfyDWlbcUS4cHDkBjouUKwwgaqOQDkkyG6DbzCOWk22Yp81Al+gQru6bh2DqAPDQVKBDiyxQ==
X-Received: by 2002:a1c:4e12:: with SMTP id g18mr11603240wmh.101.1623339107875;
        Thu, 10 Jun 2021 08:31:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id o18sm9890566wmh.38.2021.06.10.08.31.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 08:31:47 -0700 (PDT)
Subject: Re: [PATCH v3 00/11] KVM: nVMX: Fixes for nested state migration when
 eVMCS is in use
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210526132026.270394-1-vkuznets@redhat.com>
 <87mtrxyer2.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <31df7026-9500-a802-b23c-4f2233f120d5@redhat.com>
Date:   Thu, 10 Jun 2021 17:31:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87mtrxyer2.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/06/21 16:29, Vitaly Kuznetsov wrote:
> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
> 
>> Changes since v2:
>> - 'KVM: nVMX: Use '-1' in 'hv_evmcs_vmptr' to indicate that eVMCS is not in
>>   use'/ 'KVM: nVMX: Introduce 'EVMPTR_MAP_PENDING' post-migration state'
>>   patches instead of 'KVM: nVMX: Introduce nested_evmcs_is_used()' [Paolo]
>> - 'KVM: nVMX: Don't set 'dirty_vmcs12' flag on enlightened VMPTRLD' patch
>>   added [Max]
>> - 'KVM: nVMX: Release eVMCS when enlightened VMENTRY was disabled' patch
>>    added.
>> - 'KVM: nVMX: Make copy_vmcs12_to_enlightened()/copy_enlightened_to_vmcs12()
>>   return 'void'' patch added [Paolo]
>> - R-b tags added [Max]
>>
>> Original description:
>>
>> Commit f5c7e8425f18 ("KVM: nVMX: Always make an attempt to map eVMCS after
>> migration") fixed the most obvious reason why Hyper-V on KVM (e.g. Win10
>>   + WSL2) was crashing immediately after migration. It was also reported
>> that we have more issues to fix as, while the failure rate was lowered
>> signifincatly, it was still possible to observe crashes after several
>> dozens of migration. Turns out, the issue arises when we manage to issue
>> KVM_GET_NESTED_STATE right after L2->L2 VMEXIT but before L1 gets a chance
>> to run. This state is tracked with 'need_vmcs12_to_shadow_sync' flag but
>> the flag itself is not part of saved nested state. A few other less
>> significant issues are fixed along the way.
>>
>> While there's no proof this series fixes all eVMCS related problems,
>> Win10+WSL2 was able to survive 3333 (thanks, Max!) migrations without
>> crashing in testing.
>>
>> Patches are based on the current kvm/next tree.
> 
> Paolo, Max,
> 
> Just to double-check: are we good here? I know there are more
> improvements/ideas to explore but I'd like to treat this patchset as a
> set of fixes, it would be unfortunate if we miss 5.14.
> 

Yes, I was busy the last couple of weeks but I am back now.

Paolo

