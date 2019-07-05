Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3546660690
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 15:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbfGEN0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 09:26:06 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45417 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbfGEN0F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 09:26:05 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so9920212wre.12
        for <kvm@vger.kernel.org>; Fri, 05 Jul 2019 06:26:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5QNK02sutwjpQD4Kojggq80G41ltWM2v/J3VAs0y3RE=;
        b=X9vmuWyWyekVan1VT6z7ouFbsz7vgcWk+fhKJA0wQwIkIuQLVxeYXp0G5p8BL94lfs
         gu/WX0j7GWHWrr/FfAtLe48XUfVT7NixSOjTjMk8jasG2TIf4MBnxh4To+QFfCLbKLBO
         3oozMXldihhE0CQHdhP4Fq9tzehTUdLEPoCGB9FE9oPd70taHnvNOatCGJl7hea8f5ps
         0eRhJmfVa/PpghLcDJSjqz139BZ//yXhU6Pr5yBUMk1hwpsbqYAPC+WPiwdzurvmjXUk
         TFJ6xYCvFSPS3PxoLPgjeas3zDS/HDQW+I56uzQzD2clV/7P9zDTn8i0+Lr3Ko336KD0
         MGIQ==
X-Gm-Message-State: APjAAAV0sGw+hdCES1HDH/fzVLIZH6ECNtZADplSXcjOLa2HF/T7OAKd
        oEXkmR94+zuwDO9Y2nF9/sPTkA==
X-Google-Smtp-Source: APXvYqzKhj5sL/IxIleuiZ5IX5haQeq0M7D55wlrZJL3O4fo1x/nntdB9V+CG2PaHhNPuAuvfVvc+A==
X-Received: by 2002:a5d:5510:: with SMTP id b16mr4165583wrv.267.1562333163572;
        Fri, 05 Jul 2019 06:26:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e943:5a4e:e068:244a? ([2001:b07:6468:f312:e943:5a4e:e068:244a])
        by smtp.gmail.com with ESMTPSA id y7sm3656457wmm.19.2019.07.05.06.26.02
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 06:26:03 -0700 (PDT)
Subject: Re: [PATCH v5 4/4] KVM: LAPIC: Don't inject already-expired timer via
 posted interrupt
To:     Wanpeng Li <wanpeng.li@hotmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <1561110002-4438-1-git-send-email-wanpengli@tencent.com>
 <1561110002-4438-5-git-send-email-wanpengli@tencent.com>
 <67fad01b-8a77-5892-d963-77a3d321bb65@redhat.com>
 <HK2PR02MB4145B13227997511174DBFA480F50@HK2PR02MB4145.apcprd02.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <847fc9bd-c0b9-0f7b-f029-9a5499f2c74e@redhat.com>
Date:   Fri, 5 Jul 2019 15:26:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <HK2PR02MB4145B13227997511174DBFA480F50@HK2PR02MB4145.apcprd02.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/07/19 15:11, Wanpeng Li wrote:
> On 7/5/19 8:40 PM, Paolo Bonzini wrote:
> 
>> On 21/06/19 11:40, Wanpeng Li wrote:
>>> From: Wanpeng Li <wanpengli@tencent.com>
>>>
>>> already-expired timer interrupt can be injected to guest when vCPU who
>>> arms the lapic timer re-vmentry, don't posted inject in this case.
>>>
>>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>>> Cc: Radim Krčmář <rkrcmar@redhat.com>
>>> Cc: Marcelo Tosatti <mtosatti@redhat.com>
>>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
>>> ---
>>>   arch/x86/kvm/lapic.c | 14 +++++++-------
>>>   1 file changed, 7 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>>> index ae575c0..7cd95ea 100644
>>> --- a/arch/x86/kvm/lapic.c
>>> +++ b/arch/x86/kvm/lapic.c
>>> @@ -1452,7 +1452,7 @@ static void kvm_apic_inject_pending_timer_irqs(struct kvm_lapic *apic)
>>>   	}
>>>   }
>>>   
>>> -static void apic_timer_expired(struct kvm_lapic *apic)
>>> +static void apic_timer_expired(struct kvm_lapic *apic, bool can_pi_inject)
>>>   {
>>>   	struct kvm_vcpu *vcpu = apic->vcpu;
>>>   	struct swait_queue_head *q = &vcpu->wq;
>>> @@ -1464,7 +1464,7 @@ static void apic_timer_expired(struct kvm_lapic *apic)
>>>   	if (apic_lvtt_tscdeadline(apic) || ktimer->hv_timer_in_use)
>>>   		ktimer->expired_tscdeadline = ktimer->tscdeadline;
>>>   
>>> -	if (posted_interrupt_inject_timer(apic->vcpu)) {
>>> +	if (can_pi_inject && posted_interrupt_inject_timer(apic->vcpu)) {
>> Perhaps it should use a posted interrupt if kvm_arch_should_kick(vcpu),
>> i.e. just add kvm_arch_vcpu_should_kick(apic->vcpu) to
>> posted_interrupt_inject_timer?
> 
> So do you mean not nohz_full setup? An external interrupt is incurred 
> here and preemption timer is better.

No, I mean instead of adding can_pi_inject, just test
kvm_arch_should_kick in posted_interrupt_inject_timer, skipping the PI
if the vCPU is not running.  Instead just go down the normal path and
the guest will get the interrupt by checking the timer-pending flag.

Paolo
