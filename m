Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C372F3DA7
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 01:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393402AbhALVoe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 16:44:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42181 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393408AbhALVoc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 16:44:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610487786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jHOTLuvOelFAWd5ADGi2rVRtP5HMnmatf+qZhnhdrxI=;
        b=X+Lk15iJe7X2vLeey5ArsBQjees9wHHHcRMPVT5y9oJTJfXHEpZy9/Wbo6VJhO6V1PyWgb
        XkVIpIlnqAFRLHUieOiMXSU+eIoYbOx7eetAnZlqZAYlRkIipn9r2rX96yqj3JPsUJcmT7
        nTlcRoK2Lr7oboLzxzjx1X6M2P9F6fY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-bnbQ_frtMou42Tv-VP5RnA-1; Tue, 12 Jan 2021 16:43:04 -0500
X-MC-Unique: bnbQ_frtMou42Tv-VP5RnA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B97ED1007463;
        Tue, 12 Jan 2021 21:43:02 +0000 (UTC)
Received: from [10.10.115.107] (ovpn-115-107.rdu2.redhat.com [10.10.115.107])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 083306F96B;
        Tue, 12 Jan 2021 21:43:01 +0000 (UTC)
Subject: Re: [PATCH] Revert "KVM: x86: Unconditionally enable irqs in guest
 context"
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        w90p710@gmail.com, pbonzini@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
References: <20210105192844.296277-1-nitesh@redhat.com>
 <874kjuidgp.fsf@vitty.brq.redhat.com> <X/XvWG18aBWocvvf@google.com>
 <87ble1gkgx.fsf@vitty.brq.redhat.com>
From:   Nitesh Narayan Lal <nitesh@redhat.com>
Organization: Red Hat Inc,
Message-ID: <fb41e24f-a5e3-8319-d25b-e0fe6b902a2b@redhat.com>
Date:   Tue, 12 Jan 2021 16:43:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <87ble1gkgx.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/7/21 4:33 AM, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
>
>> On Wed, Jan 06, 2021, Vitaly Kuznetsov wrote:
>>> Looking back, I don't quite understand why we wanted to account ticks
>>> between vmexit and exiting guest context as 'guest' in the first place;
>>> to my understanging 'guest time' is time spent within VMX non-root
>>> operation, the rest is KVM overhead (system).
>> With tick-based accounting, if the tick IRQ is received after PF_VCPU is cleared
>> then that tick will be accounted to the host/system.  The motivation for opening
>> an IRQ window after VM-Exit is to handle the case where the guest is constantly
>> exiting for a different reason _just_ before the tick arrives, e.g. if the guest
>> has its tick configured such that the guest and host ticks get synchronized
>> in a bad way.
>>
>> This is a non-issue when using CONFIG_VIRT_CPU_ACCOUNTING_GEN=y, at least with a
>> stable TSC, as the accounting happens during guest_exit_irqoff() itself.
>> Accounting might be less-than-stellar if TSC is unstable, but I don't think it
>> would be as binary of a failure as tick-based accounting.
>>
> Oh, yea, I vaguely remember we had to deal with a very similar problem
> but for userspace/kernel accounting. It was possible to observe e.g. a
> userspace task going 100% kernel while in reality it was just perfectly
> synchronized with the tick and doing a syscall just before it arrives
> (or something like that, I may be misremembering the details).
>
> So depending on the frequency, it is probably possible to e.g observe
> '100% host' with tick based accounting, the guest just has to
> synchronize exiting to KVM in a way that the tick will always arrive
> past guest_exit_irqoff().
>
> It seems to me this is a fundamental problem in case the frequency of
> guest exits can match the frequency of the time accounting tick.
>

Just to make sure that I am understanding things correctly.
There are two issues:
1. The first issue is with the tick IRQs that arrive after PF_VCPU is
   cleared as they are then accounted into the system context atleast on
   the setup where CONFIG_VIRT_CPU_ACCOUNTING_GEN is not enabled. With the
   patch "KVM: x86: Unconditionally enable irqs in guest context", we are
   atleast taking care of the scenario where the guest context is exiting
   constantly just before the arrival of the tick.
 
2. The second issue that Sean mentioned was introduced because of moving
   guest_exit_irqoff() closer to VM-exit. Due to this change, any ticks that
   happen after IRQs are disabled are incorrectly accounted into the system
   context. This is because we exit the guest context early without
   ensuring if the required guest states to handle IRQs are restored.
 
So, the increase in the system time (reported by cpuacct.stats) that I was
observing is not entirely correct after all.
Am I missing anything here?

--
Thanks
Nitesh

