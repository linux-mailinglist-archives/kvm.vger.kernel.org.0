Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FDF267833
	for <lists+kvm@lfdr.de>; Sat, 12 Sep 2020 08:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgILGVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Sep 2020 02:21:53 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45220 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725814AbgILGVt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 12 Sep 2020 02:21:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599891708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DoRfe+catPHrHtF6PXn2NHblX5adVVfE1OCD3cfXEoA=;
        b=VauOg51GEU78xXzmoWtg+EUixzQVOT3Fvdeoic8mtQBRq0NuxyNxGMfJLcwBT8sAqypfN7
        7kBeS95bHiFL86irowjZa90/4nOIlAa9NZ///E+4/0d6pITkTSPdbZxC94VnX5WIWpLDwM
        bxA/BS/AG8JidYb6HYXgSugj7dvimXI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-Wt0g7BUmNBuLwG48thdluw-1; Sat, 12 Sep 2020 02:21:46 -0400
X-MC-Unique: Wt0g7BUmNBuLwG48thdluw-1
Received: by mail-wr1-f69.google.com with SMTP id v12so4076521wrm.9
        for <kvm@vger.kernel.org>; Fri, 11 Sep 2020 23:21:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DoRfe+catPHrHtF6PXn2NHblX5adVVfE1OCD3cfXEoA=;
        b=fUAGn9oGsVGf9QHNmG+k7g/zkvU8tozOe+A1YGpVmZj8u69X4bCBtJzjNzwXCWLmCn
         E4D3TzXnO4Y/W5vp6cmyYvMUmMe4fbVklEoZq9MMcSj2h/aPTLSxwQTy+Efm04LHAa1e
         KDGggp5UIcCa20jTgBZCj2slDVp9Y0LOzmp+NhJHwfMzq7qJoqs/x4O0QuSAU5hc2F2X
         8czn5KCyORWIlHzfj/ijJo1owia4/UpbS59EglTiF45bbtcASaV6MmQSNMIv875tZxRV
         1IvbaG3MhEvy1VZqM7ccALmB1S7bTFLyu0Oauxk3VSx35Y5NqtWcpYYklIFT2/i+8NmV
         5ESg==
X-Gm-Message-State: AOAM531CTro2mdU8kkQx5JkQ5dJH/K8wln/627oZxfIydUmAptX0aHTD
        7Z4HdcXhVCmnwXU/xHx7ITRcvfy+ZN6iXpspt7mJhMvuIiUEEkDD6Xn4t3iVNzmk1bnNoryb4KU
        Fu8MzLTPb70dI
X-Received: by 2002:adf:ec82:: with SMTP id z2mr5363116wrn.214.1599891704832;
        Fri, 11 Sep 2020 23:21:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyOUxPWoc1KgfE5qSdceI4D2L/RmrE5drDfLuFzxyq0DwKRyHh5UTj02585OrvX2QJviXZorg==
X-Received: by 2002:adf:ec82:: with SMTP id z2mr5363096wrn.214.1599891704635;
        Fri, 11 Sep 2020 23:21:44 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id v9sm8452118wru.37.2020.09.11.23.21.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 23:21:44 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: LAPIC: Fix updating DFR missing apic map
 recalculation
To:     Wanpeng Li <kernellwp@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1597827327-25055-1-git-send-email-wanpengli@tencent.com>
 <CANRm+Cx=6zc=KTw5XwMQTdOG3m67MCcmthRuFR-VTnOTB06kow@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <35b993bf-24d5-5cab-4a93-9ed76b0a3215@redhat.com>
Date:   Sat, 12 Sep 2020 08:21:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CANRm+Cx=6zc=KTw5XwMQTdOG3m67MCcmthRuFR-VTnOTB06kow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/09/20 10:41, Wanpeng Li wrote:
> Any Reviewed-by for these two patches? :)
> On Wed, 19 Aug 2020 at 16:55, Wanpeng Li <kernellwp@gmail.com> wrote:
>>
>> From: Wanpeng Li <wanpengli@tencent.com>
>>
>> There is missing apic map recalculation after updating DFR, if it is
>> INIT RESET, in x2apic mode, local apic is software enabled before.
>> This patch fix it by introducing the function kvm_apic_set_dfr() to
>> be called in INIT RESET handling path.
>>
>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>> ---
>>  arch/x86/kvm/lapic.c | 15 ++++++++++-----
>>  1 file changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index 5ccbee7..248095a 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -310,6 +310,12 @@ static inline void kvm_apic_set_ldr(struct kvm_lapic *apic, u32 id)
>>         atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
>>  }
>>
>> +static inline void kvm_apic_set_dfr(struct kvm_lapic *apic, u32 val)
>> +{
>> +       kvm_lapic_set_reg(apic, APIC_DFR, val);
>> +       atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
>> +}
>> +
>>  static inline u32 kvm_apic_calc_x2apic_ldr(u32 id)
>>  {
>>         return ((id >> 4) << 16) | (1 << (id & 0xf));
>> @@ -1984,10 +1990,9 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>>                 break;
>>
>>         case APIC_DFR:
>> -               if (!apic_x2apic_mode(apic)) {
>> -                       kvm_lapic_set_reg(apic, APIC_DFR, val | 0x0FFFFFFF);
>> -                       atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
>> -               } else
>> +               if (!apic_x2apic_mode(apic))
>> +                       kvm_apic_set_dfr(apic, val | 0x0FFFFFFF);
>> +               else
>>                         ret = 1;
>>                 break;
>>
>> @@ -2303,7 +2308,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
>>                              SET_APIC_DELIVERY_MODE(0, APIC_MODE_EXTINT));
>>         apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
>>
>> -       kvm_lapic_set_reg(apic, APIC_DFR, 0xffffffffU);
>> +       kvm_apic_set_dfr(apic, 0xffffffffU);
>>         apic_set_spiv(apic, 0xff);
>>         kvm_lapic_set_reg(apic, APIC_TASKPRI, 0);
>>         if (!apic_x2apic_mode(apic))
>> --
>> 2.7.4
>>
> 

Queued, thanks.

Paolo

