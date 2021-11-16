Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B29F453811
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 17:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbhKPQvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 11:51:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22018 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236439AbhKPQvo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 11:51:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637081325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cg0A/Tqzd8C8bvQHxDRqW8bNEhwYvKBZVV4KLqiN8xQ=;
        b=KtFOF5n2N6H4znCn3ujnXG+RyBM6Ae+4UZiwiHSJebKHyO02JGUHJW3SuD3jzvlvjDcfPd
        XVqIp0tFifuwUDKa4flBd1qWqqh5BvjsglEa5Kgzu1dMF5e+k/SNgReJ5gxTAJZMhXyZif
        eC1epwIwETc0BsbnQhL4ihlOGNPTdF0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-p3SenisWPY62m1a-Emj8qQ-1; Tue, 16 Nov 2021 11:48:39 -0500
X-MC-Unique: p3SenisWPY62m1a-Emj8qQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F53487D542;
        Tue, 16 Nov 2021 16:48:37 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 757005FC13;
        Tue, 16 Nov 2021 16:48:20 +0000 (UTC)
Message-ID: <58fcf40e-75f5-f092-5aee-29d018f6bf67@redhat.com>
Date:   Tue, 16 Nov 2021 17:48:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 4/5] KVM: x86: Use kvm_get_vcpu() instead of open-coded
 access
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        linux-mips@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linuxppc-dev@lists.ozlabs.org, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup.patel@wdc.com>,
        Atish Patra <atish.patra@wdc.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Juergen Gross <jgross@suse.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
References: <20211105192101.3862492-1-maz@kernel.org>
 <20211105192101.3862492-5-maz@kernel.org> <YYWOKTYHhJywwCRk@google.com>
 <330eb780-1963-ac1f-aaad-908346112f28@redhat.com>
 <YZPXU3eBT8j0fUPs@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YZPXU3eBT8j0fUPs@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 17:07, Sean Christopherson wrote:
>>>           if (!kvm_arch_has_assigned_device(kvm) ||
>>>               !irq_remapping_cap(IRQ_POSTING_CAP) ||
>>> -           !kvm_vcpu_apicv_active(kvm->vcpus[0]))
>>> +           !irqchip_in_kernel(kvm) || !enable_apicv)
>>>                   return 0;
>>>
>>>           idx = srcu_read_lock(&kvm->irq_srcu);
>> What happens then if pi_pre_block is called and the IRTE denotes a posted
>> interrupt?
>>
>> I might be wrong, but it seems to me that you have to change all of the
>> occurrences this way.  As soon as enable_apicv is set, you need to go
>> through the POSTED_INTR_WAKEUP_VECTOR just in case.
> Sorry, I didn't grok that at all.  All occurences of what?

Of the !assigned-device || !VTd-PI || !kvm_vcpu_apicv_active(vcpu) 
checks.  This way, CPUs are woken up correctly even if you have 
!kvm_vcpu_apicv_active(vcpu) but the IRTE is a posted-interrupt one.

Paolo

