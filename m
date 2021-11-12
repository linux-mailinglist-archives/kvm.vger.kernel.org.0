Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A5A44E42C
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 10:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234823AbhKLJyL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 04:54:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44995 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234803AbhKLJyK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 04:54:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636710679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q3tNE6PVDp1t883O718wrcDgXu0HBWeQVivnEf04yl8=;
        b=RkO3qVub/Trsy4BlS9rHaB1lpRaw7zBkJbbB8wb7OJVsi7FSN2IAu1qTQRVwDxKnCEYBEr
        Z4bZY6LxqGIHdWnRNwGp1oMIUrmnuUlaD2rYAoCiCHHowtkpfIWZojrYfVYIm/UD4GBCId
        FgB/XfwUoyJQkALDpUgsbnFKrmIVlIw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-l-feSVDEPmOYlPHeaSVo4g-1; Fri, 12 Nov 2021 04:51:13 -0500
X-MC-Unique: l-feSVDEPmOYlPHeaSVo4g-1
Received: by mail-ed1-f72.google.com with SMTP id i9-20020a508709000000b003dd4b55a3caso7800393edb.19
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 01:51:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Q3tNE6PVDp1t883O718wrcDgXu0HBWeQVivnEf04yl8=;
        b=4MgH3WWJR5WJBgddzz5mxscd5WRgaYvu20WtN2OOQqY3rFsAkWIVVBBwu6ttiDDaRd
         lesNJFDtnVZglvBjH9Uofx74sv6FC83Dv6B1oBBCkhRVxNC4TKwkHBePpQKu5gT/LyFc
         CeuKbCWALPWDrZFTJlpzwVkSgu7T8o5Xthv2NwJfE4wexZ5lhEYrJGHobb7UXh1LXwh8
         r4bo49lqsFGl7m8pMcAHcfh4EKmUp9lo+8gmeHmH9jNSViHjrTjss+H08iFHTO9s+9yu
         0no4kqPYHBdOi/mkZnXp41mZroYlLbLORwQn1CwTTLZAKQLRoN/PvDCQdGUyaoXHBvVj
         aacw==
X-Gm-Message-State: AOAM5330DPVxZ9pXMxrwTHP9wIzbwEcq8lJC81i+eSwYv5zHRAqYcgiJ
        t+7JhB6HB0E/PNjBN7tnl1YzIPbmBCeFY3sGDhIJBR1oFbaRX4PwpSy/YK35IPY9rN56TPm4+X0
        VEJwpMRaGqJe0
X-Received: by 2002:a05:6402:27d3:: with SMTP id c19mr19433476ede.2.1636710672859;
        Fri, 12 Nov 2021 01:51:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzLDjahuFseIZ7e+RowWVF5yMybji+/f1TpttlCU7zwauHRgLTGqMPciQsWHxQYl16h4+En2Q==
X-Received: by 2002:a05:6402:27d3:: with SMTP id c19mr19433437ede.2.1636710672630;
        Fri, 12 Nov 2021 01:51:12 -0800 (PST)
Received: from fedora (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id q14sm2845328edj.42.2021.11.12.01.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 01:51:12 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] KVM: arm64: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
In-Reply-To: <a5cdff6878b7157587e92ebe4d5af362@kernel.org>
References: <20211111162746.100598-1-vkuznets@redhat.com>
 <20211111162746.100598-2-vkuznets@redhat.com>
 <a5cdff6878b7157587e92ebe4d5af362@kernel.org>
Date:   Fri, 12 Nov 2021 10:51:10 +0100
Message-ID: <875ysxg0s1.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Marc Zyngier <maz@kernel.org> writes:

> Hi Vitaly,
>
> On 2021-11-11 16:27, Vitaly Kuznetsov wrote:
>> It doesn't make sense to return the recommended maximum number of
>> vCPUs which exceeds the maximum possible number of vCPUs.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  arch/arm64/kvm/arm.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 7838e9fb693e..391dc7a921d5 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -223,7 +223,12 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, 
>> long ext)
>>  		r = 1;
>>  		break;
>>  	case KVM_CAP_NR_VCPUS:
>> -		r = num_online_cpus();
>> +		if (kvm)
>> +			r = min_t(unsigned int, num_online_cpus(),
>> +				  kvm->arch.max_vcpus);
>> +		else
>> +			r = min_t(unsigned int, num_online_cpus(),
>> +				  kvm_arm_default_max_vcpus());
>>  		break;
>>  	case KVM_CAP_MAX_VCPUS:
>>  	case KVM_CAP_MAX_VCPU_ID:
>
> This looks odd. This means that depending on the phase userspace is
> in while initialising the VM, KVM_CAP_NR_VCPUS can return one thing
> or the other.
>
> For example, I create a VM on a 32 CPU system, NR_VCPUS says 32.
> I create a GICv2 interrupt controller, it now says 8.
>
> That's a change in behaviour that is visible by userspace

Yes, I realize this is a userspace visible change. The reason I suggest
it is that logically, it seems very odd that the maximum recommended
number of vCPUs (KVM_CAP_NR_VCPUS) can be higher, than the maximum
supported number of vCPUs (KVM_CAP_MAX_VCPUS). All userspaces which use
this information somehow should already contain some workaround for this
case. (maybe it's a rare one and nobody hit it yet or maybe there are no
userspaces using KVM_CAP_NR_VCPUS for anything besides complaining --
like QEMU).

I'd like KVM to be consistent across architectures and have the same
(similar) meaning for KVM_CAP_NR_VCPUS.

> which I'm keen on avoiding. I'd rather have the kvm and !kvm cases
> return the same thing.

Forgive me my (ARM?) ignorance but what would it be then? If we go for
min(num_online_cpus(), kvm_arm_default_max_vcpus()) in both cases, cat
this can still go above KVM_CAP_MAX_VCPUS after vGIC is created?

Thanks for the feedback!

-- 
Vitaly

