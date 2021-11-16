Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFBE45339D
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 15:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237093AbhKPOH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 09:07:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56761 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237094AbhKPOH7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 09:07:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637071501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hBtk2aPZbU2pteLbgMkZkjDkjfuxdJX2rybR87y4uZ4=;
        b=fQXchlOqjb3ZCi5ZqTO8/iS2U2Kyj7GLqNkRqkJ3CXNPR6wXL9PwSq6li9PZX3POzy1/7R
        a5W94jTjDkiXPIat8kohq+6E2mtFTkLd41AOpT6flVzYCWr4vLQ3UEd7T7Fe+n8HBfnd0x
        wxFQjQ4C6+yc5GmS4nnDHjcBAYMNzVA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-L8W_GkDdPby-uiSCgnu-Aw-1; Tue, 16 Nov 2021 09:05:00 -0500
X-MC-Unique: L8W_GkDdPby-uiSCgnu-Aw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85E8880DDE4;
        Tue, 16 Nov 2021 14:04:57 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A662F10023B8;
        Tue, 16 Nov 2021 14:04:48 +0000 (UTC)
Message-ID: <330eb780-1963-ac1f-aaad-908346112f28@redhat.com>
Date:   Tue, 16 Nov 2021 15:04:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 4/5] KVM: x86: Use kvm_get_vcpu() instead of open-coded
 access
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linuxppc-dev@lists.ozlabs.org,
        Huacai Chen <chenhuacai@kernel.org>,
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
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YYWOKTYHhJywwCRk@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/5/21 21:03, Sean Christopherson wrote:
> But I think even that is flawed, as APICv can be dynamically deactivated and
> re-activated while the VM is running, and I don't see a path that re-updates
> the IRTE when APICv is re-activated.  So I think a more conservative check is
> needed, e.g.
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index 5f81ef092bd4..6cf5b2e86118 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -272,7 +272,7 @@ int pi_update_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,
> 
>          if (!kvm_arch_has_assigned_device(kvm) ||
>              !irq_remapping_cap(IRQ_POSTING_CAP) ||
> -           !kvm_vcpu_apicv_active(kvm->vcpus[0]))
> +           !irqchip_in_kernel(kvm) || !enable_apicv)
>                  return 0;
> 
>          idx = srcu_read_lock(&kvm->irq_srcu);

What happens then if pi_pre_block is called and the IRTE denotes a 
posted interrupt?

I might be wrong, but it seems to me that you have to change all of the 
occurrences this way.  As soon as enable_apicv is set, you need to go 
through the POSTED_INTR_WAKEUP_VECTOR just in case.

Paolo

