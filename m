Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166711A97FC
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 11:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408288AbgDOJII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 05:08:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59722 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2408279AbgDOJIB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 05:08:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586941679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lisOMIPYzGEOUKW/w9q538cTmyUuHd07/Sojgyr8MlQ=;
        b=Jx2FDyTWiVDSj+TGOWOlb6Tpt+VTUEEy0yd9fpRMKl7rQKOY871ngDkQGOjhAC8N+d7SY0
        Bs4Q8EQdCr8SzcYu4yqzOh5h22g90k72oCAFQQ0KvtupPEZo/SY0pBdzJTkbeMQmNX+mlb
        qi4WIYZbc8j89wpMCMzWuylFT++B45o=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-kb8Q2WltPg69z_XDMoEMhA-1; Wed, 15 Apr 2020 05:07:57 -0400
X-MC-Unique: kb8Q2WltPg69z_XDMoEMhA-1
Received: by mail-wm1-f72.google.com with SMTP id h22so3970351wml.1
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 02:07:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=lisOMIPYzGEOUKW/w9q538cTmyUuHd07/Sojgyr8MlQ=;
        b=C+0EpUAsGHRfoYKb/A4nCju7tuWEzaiAFkIPa8CQ4Yz3XXc1sdPbhn82mg20siLO22
         lpt9pSwusDPkg8S2puc9bRihuCqpLVi4JiJ7refAgHgoE5VBvQ+usWMwYYh7r18vGSr4
         Dj4+9eNcbYqvf5B+Xumt1Da3ZL2evGAwMWLhbGoPCH1U6RjWSrBKHorxW8SfvYBhmKpv
         RGsi7LJuLWskeE4GSuh+mdRR1M6ki1olFJD90+zg6IrHfnG8iXq9y0m7+fzSKK5IfvZD
         fKtH/LDD/X6YXXr3nVSmWD7OMg6o/uInrZj6sDMU2qNl1cQIYuDFgJ5xcpF6ZSDl5J4u
         dRmw==
X-Gm-Message-State: AGi0PuYan6VqrB3P5j07P/G++0afBfMOINLnTzagnwnReygm485t9eCm
        77LwbRVDEyJBn9U1zdYMhj7+4VrebV1A7QgahwC86WhlmRjSHiqnRmyOgIOXTYhlYiXFNfBDzA6
        xy7rXUZDbYX7U
X-Received: by 2002:a5d:6841:: with SMTP id o1mr27977379wrw.412.1586941676331;
        Wed, 15 Apr 2020 02:07:56 -0700 (PDT)
X-Google-Smtp-Source: APiQypIXD/p9LNlXg20pn+U/yQCcvvORh177d5YZbgu7SsoqIprQYNJ2FhjSis/HsfEJeQMW+4tCHg==
X-Received: by 2002:a5d:6841:: with SMTP id o1mr27977353wrw.412.1586941676047;
        Wed, 15 Apr 2020 02:07:56 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id e5sm23214697wru.92.2020.04.15.02.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 02:07:55 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Subject: Re: [PATCH] KVM: Optimize kvm_arch_vcpu_ioctl_run function
In-Reply-To: <cc29ce22-4c70-87d1-d7aa-9d38438ba8a5@linux.alibaba.com>
References: <20200413034523.110548-1-tianjia.zhang@linux.alibaba.com> <875ze2ywhy.fsf@vitty.brq.redhat.com> <cc29ce22-4c70-87d1-d7aa-9d38438ba8a5@linux.alibaba.com>
Date:   Wed, 15 Apr 2020 11:07:53 +0200
Message-ID: <87a73dxgk6.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tianjia Zhang <tianjia.zhang@linux.alibaba.com> writes:

> On 2020/4/14 22:26, Vitaly Kuznetsov wrote:
>> Tianjia Zhang <tianjia.zhang@linux.alibaba.com> writes:
>> 
>>> kvm_arch_vcpu_ioctl_run() is only called in the file kvm_main.c,
>>> where vcpu->run is the kvm_run parameter, so it has been replaced.
>>>
>>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>>> ---
>>>   arch/x86/kvm/x86.c | 8 ++++----
>>>   virt/kvm/arm/arm.c | 2 +-
>>>   2 files changed, 5 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 3bf2ecafd027..70e3f4abbd4d 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -8726,18 +8726,18 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>>>   		r = -EAGAIN;
>>>   		if (signal_pending(current)) {
>>>   			r = -EINTR;
>>> -			vcpu->run->exit_reason = KVM_EXIT_INTR;
>>> +			kvm_run->exit_reason = KVM_EXIT_INTR;
>> 
>> I have a more generic question: why do we need to pass 'kvm_run' to
>> kvm_arch_vcpu_ioctl_run() if it can be extracted from 'struct kvm_vcpu'?
>> The only call site looks like
>> 
>> virt/kvm/kvm_main.c:            r = kvm_arch_vcpu_ioctl_run(vcpu, vcpu->run);
>> 
>
> In the earlier version, kvm_run is used to pass parameters with user 
> mode and is not included in the vcpu structure, so it has been retained 
> until now.
>

In case this is no longer needed I'd suggest we drop 'kvm_run' parameter
and extract it from 'struct kvm_vcpu' when needed. This looks like a
natural add-on to your cleanup patch.

-- 
Vitaly

