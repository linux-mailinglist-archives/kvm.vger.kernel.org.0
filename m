Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D933455B2E
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 13:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344492AbhKRMHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 07:07:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38496 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344501AbhKRMHZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 07:07:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637237064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W5Ghb5uAlf942gVdbek0yVdXvRxLK8U0BDO6Bp0gMAI=;
        b=JSPbHF3ENpOolrthgXfyiTyy84c6bAcd1pFyzBQ3YO+UNBX+nw9jZz+Upoo+nDOvNEh3cZ
        Ce/v3E+WatSI1Cnl5vqMrJla7KljJYXgECyBjW7g5eHTQ5y8ryQxP20yXAmW2AIokoh4mr
        WaoXH6y9jl6vj3pvmPgQIZoYnYONpCo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-115-k6mdJvwXNi-BzEtUcDvh4A-1; Thu, 18 Nov 2021 07:04:21 -0500
X-MC-Unique: k6mdJvwXNi-BzEtUcDvh4A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81DF11006AA1;
        Thu, 18 Nov 2021 12:04:17 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 377E05F4EE;
        Thu, 18 Nov 2021 12:04:09 +0000 (UTC)
Message-ID: <4c48546b-eb4a-dff7-cc38-5df54f73f5d4@redhat.com>
Date:   Thu, 18 Nov 2021 13:04:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 08/12] KVM: Propagate vcpu explicitly to
 mark_page_dirty_in_slot()
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anup Patel <anup.patel@wdc.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org
References: <20211117174003.297096-1-dwmw2@infradead.org>
 <20211117174003.297096-9-dwmw2@infradead.org>
 <85d9fec17f32c3eb9e100e56b91af050.squirrel@twosheds.infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <85d9fec17f32c3eb9e100e56b91af050.squirrel@twosheds.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/17/21 22:09, David Woodhouse wrote:
>>   {
>> -	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>> +	struct kvm_vcpu *running_vcpu = kvm_get_running_vcpu();
>>
>> +	WARN_ON_ONCE(vcpu && vcpu != running_vcpu);
>>   	WARN_ON_ONCE(vcpu->kvm != kvm);
> Ah, that one needs to be changed to check running_vcpu instead. Or this
> needs to go first:
> 
> I think I prefer making the vCPU a required argument. If anyone's going to
> pull a vCPU pointer out of their posterior, let the caller do it.
> 

I understand that feeling, but still using the running vCPU is by far 
the common case, and it's not worth adding a new function parameter to 
all call sites.

What about using a separate function, possibly __-prefixed, for the case 
where you have a very specific vCPU?

Paolo

