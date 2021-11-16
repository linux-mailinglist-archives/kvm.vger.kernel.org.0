Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E6A4532D2
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 14:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236712AbhKPN0i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 08:26:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54969 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236710AbhKPN01 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 08:26:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637069010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7QB9Djd7unSuWFppJ6ryGSoufF2SRnNHGOPyI0tESn4=;
        b=ZIstAnW0E0rBi5YPmzUSbyRKpnq0DuO6PR50Jh4JD3q9SQe/gbMGDETnNGnz20QqQ7PKKd
        6kLe4ilGFg11hvIySMDKfQ88SS7dHDVNQTQcFU6i/jqtJpfB9fYTj10LmjIGH7yr0JoyvK
        vf7oU3SyUiZQX2B1YsEZQD29hSCh41c=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-ql0MOcIINMSzqxLPuy-m0A-1; Tue, 16 Nov 2021 08:23:29 -0500
X-MC-Unique: ql0MOcIINMSzqxLPuy-m0A-1
Received: by mail-wm1-f71.google.com with SMTP id o22-20020a1c7516000000b0030d6f9c7f5fso7363963wmc.1
        for <kvm@vger.kernel.org>; Tue, 16 Nov 2021 05:23:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=7QB9Djd7unSuWFppJ6ryGSoufF2SRnNHGOPyI0tESn4=;
        b=DFy8dHOgE5+HGpB+EMWzFbT4vxAsKEF2UGvs6Zv+dVCshYkGhSqlg64TRI3dAXwxDT
         1vi3NN70+cUnM4CnV65+YpYqinvYlUsKR+XDyRpFvOVy5ZRHSWeftWOBTQPoBimJK+Gd
         QxwIu+VHnZwtXZQtj2/Sfr17oTlDtNBzHd2AJ49ZXeyCKxQzEOKzkJ301vsHtS6iq/db
         huMuwmbIKJxE3X5ITcRY7gkwACPnlvvf2pIiTIFUtOfjdCSlRqYiiNRcm/kSUvVFJjuW
         RFWd5LN0uOn85dxN4HLUab0O3UO/bi8SVwl4ScNwRXrQTDKVnFNYZIccNwhFdYjzZAtn
         cbYA==
X-Gm-Message-State: AOAM531/pyJTTzvSEqezrZkokAq4r8iOhpmCha7HEU7NZ6qofACblHSK
        mDn4+NHbIbhT++2MwAb9lF6EaWn2/v5r5W3rxF8u0BkkfkXfbPAc/sC08oYfkgX4GxCTqcI3yuR
        IACyC+Y0lJcV1
X-Received: by 2002:adf:fd90:: with SMTP id d16mr9035261wrr.385.1637069007897;
        Tue, 16 Nov 2021 05:23:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJypb9wLmwBU+C8U60E20ALWxdPmsGCyP6NgX66fxkM73bNsY5mStZduwVGh4q0guawc8+jIEQ==
X-Received: by 2002:adf:fd90:: with SMTP id d16mr9035209wrr.385.1637069007612;
        Tue, 16 Nov 2021 05:23:27 -0800 (PST)
Received: from fedora (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id n7sm17311363wro.68.2021.11.16.05.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 05:23:27 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
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
In-Reply-To: <ad3534bc-fe3a-55f5-b022-4dbec5f29798@redhat.com>
References: <20211111162746.100598-1-vkuznets@redhat.com>
 <20211111162746.100598-2-vkuznets@redhat.com>
 <a5cdff6878b7157587e92ebe4d5af362@kernel.org> <875ysxg0s1.fsf@redhat.com>
 <87k0hd8obo.wl-maz@kernel.org>
 <ad3534bc-fe3a-55f5-b022-4dbec5f29798@redhat.com>
Date:   Tue, 16 Nov 2021 14:23:25 +0100
Message-ID: <87y25onsj6.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 11/12/21 15:02, Marc Zyngier wrote:
>>> I'd like KVM to be consistent across architectures and have the same
>>> (similar) meaning for KVM_CAP_NR_VCPUS.
>> Sure, but this is a pretty useless piece of information anyway. As
>> Andrew pointed out, the information is available somewhere else, and
>> all we need to do is to cap it to the number of supported vcpus, which
>> is effectively a KVM limitation.
>> 
>> Also, we are talking about representing the architecture to userspace.
>> No amount of massaging is going to make an arm64 box look like an x86.
>
> Not sure what you mean?  The API is about providing a piece of 
> information independent of the architecture, while catering for a ppc 
> weirdness.  Yes it's mostly useless if you don't care about ppc, but 
> it's not about making arm64 look like x86 or ppc; it's about not having 
> to special case ppc in userspace.
>
> If anything, if KVM_CAP_NR_VCPUS returns the same for kvm and !kvm, then 
> *that* is making an arm64 box look like an x86.  On ARM the max vCPUs 
> depends on VM's GIC configuration, so KVM_CAP_NR_VCPUS should take that 
> into account.

(I'm about to send v2 as we have s390 sorted out.)

So what do we decide about ARM? 
- Current approach (kvm->arch.max_vcpus/kvm_arm_default_max_vcpus()
 depending on 'if (kvm)') - that would be my preference.
- Always kvm_arm_default_max_vcpus to make the output independent on 'if
 (kvm)'.
- keep the status quo (drop the patch).

Please advise)

-- 
Vitaly

