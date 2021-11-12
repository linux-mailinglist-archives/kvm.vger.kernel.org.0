Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F4C44E83B
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 15:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235049AbhKLONo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 09:13:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24205 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234942AbhKLONn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 09:13:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636726252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WG8PFqpRKxCavfbVvSUmpH7cc2ZZWGSAwL7C9wQeDCQ=;
        b=iVO/jZumYpSVk4Y8U3AmTuGLAtEeCq8pfY4bTlRo2wjoMzlOhS3krPGRkavHuEhSL9WAQ1
        pamw75+0YeDCgidv0AIOlqGtWcSB3JjgiCdM7l9JSjeA/+db0vE8Z69m7pK4pa1nmqa3tS
        Q4seLqvn/FtnI5EOzGHeQZ19ie4sswM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-vtSOMdmQMPC3jGlwUWxpGg-1; Fri, 12 Nov 2021 09:10:49 -0500
X-MC-Unique: vtSOMdmQMPC3jGlwUWxpGg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B07E871817;
        Fri, 12 Nov 2021 14:10:46 +0000 (UTC)
Received: from [10.39.193.118] (unknown [10.39.193.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB60218A50;
        Fri, 12 Nov 2021 14:10:42 +0000 (UTC)
Message-ID: <ad3534bc-fe3a-55f5-b022-4dbec5f29798@redhat.com>
Date:   Fri, 12 Nov 2021 15:10:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/5] KVM: arm64: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
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
References: <20211111162746.100598-1-vkuznets@redhat.com>
 <20211111162746.100598-2-vkuznets@redhat.com>
 <a5cdff6878b7157587e92ebe4d5af362@kernel.org> <875ysxg0s1.fsf@redhat.com>
 <87k0hd8obo.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87k0hd8obo.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/21 15:02, Marc Zyngier wrote:
>> I'd like KVM to be consistent across architectures and have the same
>> (similar) meaning for KVM_CAP_NR_VCPUS.
> Sure, but this is a pretty useless piece of information anyway. As
> Andrew pointed out, the information is available somewhere else, and
> all we need to do is to cap it to the number of supported vcpus, which
> is effectively a KVM limitation.
> 
> Also, we are talking about representing the architecture to userspace.
> No amount of massaging is going to make an arm64 box look like an x86.

Not sure what you mean?  The API is about providing a piece of 
information independent of the architecture, while catering for a ppc 
weirdness.  Yes it's mostly useless if you don't care about ppc, but 
it's not about making arm64 look like x86 or ppc; it's about not having 
to special case ppc in userspace.

If anything, if KVM_CAP_NR_VCPUS returns the same for kvm and !kvm, then 
*that* is making an arm64 box look like an x86.  On ARM the max vCPUs 
depends on VM's GIC configuration, so KVM_CAP_NR_VCPUS should take that 
into account.  Or KVM_CAP_NR_VCPUS should have been only for !kvm; but 
the ship for that has sailed.

Paolo

>>> which I'm keen on avoiding. I'd rather have the kvm and !kvm cases
>>> return the same thing.
>> Forgive me my (ARM?) ignorance but what would it be then? If we go for
>> min(num_online_cpus(), kvm_arm_default_max_vcpus()) in both cases, cat
>> this can still go above KVM_CAP_MAX_VCPUS after vGIC is created?
> "min(num_online_cpus(), kvm_arm_default_max_vcpus())" is probably the
> right thing in all cases. Yes, KVM_CAP_NR_VCPUS will keep reporting
> more than the VM can actually support. But that's why we have
> KVM_CAP_MAX_VCPUS, which tells you now many vcpus you can create for a
> given configuration.

