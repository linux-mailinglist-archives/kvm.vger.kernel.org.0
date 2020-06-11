Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452C81F6362
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 10:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgFKIOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 04:14:19 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47135 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726620AbgFKIOS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Jun 2020 04:14:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591863256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6d2EQPOsqa1ar4oQ2p7/Glt6a8pVE2+UZ79AyKGYcCI=;
        b=G4JIXey8Hqf8vXC9ypEJJN3zPJi8gs5APXEdRKQoRF6qicUV724w6GvnnZ01rJ8t0lJ1+N
        gXX9kYj3TqKvKnMQrAVLfOEVoBMmvtbTCCHlKXPG0tnqdOQhjKTBund767iHy4oW8f1ot/
        ELuitS1CNmEbk+BPZ4NPhi/9EHeGW4E=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-Saf-u6C1P5Kmp5Ds54lzrA-1; Thu, 11 Jun 2020 04:14:14 -0400
X-MC-Unique: Saf-u6C1P5Kmp5Ds54lzrA-1
Received: by mail-ej1-f71.google.com with SMTP id p27so2358457ejn.5
        for <kvm@vger.kernel.org>; Thu, 11 Jun 2020 01:14:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=6d2EQPOsqa1ar4oQ2p7/Glt6a8pVE2+UZ79AyKGYcCI=;
        b=DB9WmgrgccIvZuTDAEvpPi+DOo9pHO5X+VQr56aCA5lz7kA409kgdEHJ9gnE50QSgw
         9T8ADWjiu8Wlt7c3aquyYzn2Vj2Gb/f3wuefKfJ9/M3DSn+3dg8r/ydPUNxgblFOxmbY
         DVVYlT27IVvPo+SY7WLXVb7G1v8hwEf2Hh7pJXOZEt++xcjNl5329wheXXUIXW89M5/A
         /jWF6KsuhU1BK8Gu6S1rqG+r02U0BXCHDQLx/VY+XJX+VWZgVD/mxcY/6GoTsdIVykjf
         GhPhXsmN5y7ptZBMaTRG6aSnmLePej9LjWa8aVo7Q3y7nVpaUPK2kInguBjfFu14wjka
         Cj0A==
X-Gm-Message-State: AOAM533mCaq2PAVDJkQixrG7BBfv1TtWelYsXlb+IquGNk5O8bthpa13
        CFWxdLbBIr9aGY0+55Q1tpO1JOr8EI/2QBGsjqD/xdIII7xp6/feQp6Pz9YBMiik8Yl5lyJXv/m
        F7w5d3T56bv11
X-Received: by 2002:a05:6402:1bdc:: with SMTP id ch28mr5781447edb.19.1591863253571;
        Thu, 11 Jun 2020 01:14:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyF/fbM6YhBbbEG+5RVEOLIWwN0fUrk9C7qt3qtRtoDs4uoIhuTSMMvI9gPov6XPGvOoLf5Kg==
X-Received: by 2002:a05:6402:1bdc:: with SMTP id ch28mr5781428edb.19.1591863253290;
        Thu, 11 Jun 2020 01:14:13 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u13sm1452034ejf.60.2020.06.11.01.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2020 01:14:12 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: async_pf: Inject 'page ready' event only if 'page not present' was previously injected
In-Reply-To: <20200610193211.GB243520@redhat.com>
References: <20200610175532.779793-1-vkuznets@redhat.com> <20200610175532.779793-2-vkuznets@redhat.com> <20200610193211.GB243520@redhat.com>
Date:   Thu, 11 Jun 2020 10:14:11 +0200
Message-ID: <87v9jy9fzg.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Wed, Jun 10, 2020 at 07:55:32PM +0200, Vitaly Kuznetsov wrote:
>> 'Page not present' event may or may not get injected depending on
>> guest's state. If the event wasn't injected, there is no need to
>> inject the corresponding 'page ready' event as the guest may get
>> confused. E.g. Linux thinks that the corresponding 'page not present'
>> event wasn't delivered *yet* and allocates a 'dummy entry' for it.
>> This entry is never freed.
>> 
>> Note, 'wakeup all' events have no corresponding 'page not present'
>> event and always get injected.
>> 
>> s390 seems to always be able to inject 'page not present', the
>> change is effectively a nop.
>> 
>> Suggested-by: Vivek Goyal <vgoyal@redhat.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/s390/include/asm/kvm_host.h | 2 +-
>>  arch/s390/kvm/kvm-s390.c         | 4 +++-
>>  arch/x86/include/asm/kvm_host.h  | 2 +-
>>  arch/x86/kvm/x86.c               | 7 +++++--
>>  include/linux/kvm_host.h         | 1 +
>>  virt/kvm/async_pf.c              | 2 +-
>>  6 files changed, 12 insertions(+), 6 deletions(-)
>> 
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>> index 3d554887794e..cee3cb6455a2 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -978,7 +978,7 @@ bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu);
>>  void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu,
>>  			       struct kvm_async_pf *work);
>>  
>> -void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
>> +bool kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
>>  				     struct kvm_async_pf *work);
>
> Hi Vitaly,
>
> A minor nit. Using return code to figure out if exception was injected
> or not is little odd. How about we pass a pointer instead as parameter
> and kvm_arch_async_page_not_present() sets it to true if page not
> present exception was injected. This probably will be easier to
> read.
>
> If for some reason you don't like above, atleats it warrants a comment
> explaining what do 0 and 1 mean.
>

I think it's the 'kvm_arch_async_page_not_present' name which is a bit
misleading now, if we rename it to something like
kvm_arch_inject_apf_not_present() then it becomes a bit more clear
what's going on. We may as well write the code as

    if (kvm_arch_inject_apf_not_present())
        work->notpresent_injected = true;

or change the return type to int so it'll be

    if (!kvm_arch_inject_apf_not_present())
        work->notpresent_injected = true;

> Otherwise both the patches look good to me. I tested and I can confirm
> that now page ready events are not being delivered to guest if page
> not present was not injected.

Thank you for testing!

-- 
Vitaly

