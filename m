Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33A8F6CC10
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 11:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfGRJjs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 05:39:48 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33582 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfGRJjr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 05:39:47 -0400
Received: by mail-wm1-f66.google.com with SMTP id h19so21086937wme.0
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2019 02:39:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8haVWoDpVR5WxCmFLokklmzinBm2VLPR7zTTlvNe1xo=;
        b=sraqjUm3iQpUcYKLq/AN6GWvMCKoqr5FOx6vn8bdeKuFHJVwOYRn2Wg9sbm4tplRqs
         7ti0MvvjNTc9ZAvEoThiyLBe/9sK19Fb4dR5X4n1Z0p6rJSkcixjmF1UYXDveZMtjc7Y
         QoYKmq9jDreGjLusHzeouI2fXuTb5oO1wSThGbrLmLSXG3vN3yP7jCcd52j2PMe0brQY
         KK8A01P8JhxXZndZVFjeU653X4ptzY501Ec4fP421QmFv3jG2HZIVi7LoALoX5//vwzh
         enfC/WAgr58pR6jrzFDhGSJ/m0ntqLb/URzVJt99v9pKokf4KXngc/pReuE20PLzkNPf
         nx2g==
X-Gm-Message-State: APjAAAW5im98J9H1i2t4VRsCteVlHx/J8ywSwF4u1LLO5I2ethqJDqxS
        AIlvZ+Tb/17OMoTlc+AfdgamQQ==
X-Google-Smtp-Source: APXvYqx23CP7qsEyw52dzAYhntF3bkpxTa1Ol4aIfCYcJ9vKxpbFYwnXz61NjcCrebAKq/6WqokZGQ==
X-Received: by 2002:a7b:cc09:: with SMTP id f9mr42911311wmh.68.1563442785542;
        Thu, 18 Jul 2019 02:39:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e427:3beb:1110:dda2? ([2001:b07:6468:f312:e427:3beb:1110:dda2])
        by smtp.gmail.com with ESMTPSA id p3sm24437124wmg.15.2019.07.18.02.39.44
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 02:39:45 -0700 (PDT)
Subject: Re: [PATCH RESEND] KVM: Boosting vCPUs that are delivering interrupts
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <1562915730-9490-1-git-send-email-wanpengli@tencent.com>
 <f95fbf72-090f-fb34-3c20-64508979f251@redhat.com>
 <db74a3a8-290e-edff-10ad-f861c60fbf8e@de.ibm.com>
 <e31024e4-f437-becd-a9e3-e1ea8cd2e0c7@redhat.com>
 <CANRm+Cw43DKqD17U+7-OPX3BmeNBThSe9-uWP2Atob+A0ApzLA@mail.gmail.com>
 <bc210153-fbae-25d4-bf6b-e31ceef36aa5@redhat.com>
 <CANRm+CxV0c3RSidV_GQtVuQ5fUUCT8vM=5LpodgDg+dFWhkH3w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f6f9c2ca-6fea-d7b5-9797-d180e42f50d5@redhat.com>
Date:   Thu, 18 Jul 2019 11:39:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CANRm+CxV0c3RSidV_GQtVuQ5fUUCT8vM=5LpodgDg+dFWhkH3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/07/19 11:29, Wanpeng Li wrote:
> On Thu, 18 Jul 2019 at 17:07, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 18/07/19 10:43, Wanpeng Li wrote:
>>>>> Isnt that done by the sched_in handler?
>>>>
>>>> I am a bit confused because, if it is done by the sched_in later, I
>>>> don't understand why the sched_out handler hasn't set vcpu->preempted
>>>> already.
>>>>
>>>> The s390 commit message is not very clear, but it talks about "a former
>>>> sleeping cpu" that "gave up the cpu voluntarily".  Does "voluntarily"
>>>> that mean it is in kvm_vcpu_block?  But then at least for x86 it would
>>>
>>> see the prepare_to_swait_exlusive() in kvm_vcpu_block(), the task will
>>> be set in TASK_INTERRUPTIBLE state, kvm_sched_out will set
>>> vcpu->preempted to true iff current->state == TASK_RUNNING.
>>
>> Ok, I was totally blind to that "if" around vcpu->preempted = true, it's
>> obvious now.
>>
>> I think we need two flags then, for example vcpu->preempted and vcpu->ready:
>>
>> - kvm_sched_out sets both of them to true iff current->state == TASK_RUNNING
>>
>> - kvm_vcpu_kick sets vcpu->ready to true
>>
>> - kvm_sched_in clears both of them

... and also kvm_vcpu_on_spin should check vcpu->ready.  vcpu->preempted
remains only for use by vmx_vcpu_pi_put.

Later we could think of removing vcpu->preempted.  For example,
kvm_arch_sched_out and kvm_x86_ops->sched_out could get the code
currently in vmx_vcpu_pi_put (testing curent->state == TASK_RUNNING
instead of vcpu->preempted).  But for now there's no need and I'm not
sure it's an improvement at all.

Paolo

>> This way, vmx_vcpu_pi_load can keep looking at preempted only (it
>> handles voluntary preemption in pi_pre_block/pi_post_block).

