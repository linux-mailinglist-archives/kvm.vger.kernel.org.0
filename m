Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3538945EE65
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 14:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhKZNDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 08:03:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35599 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229721AbhKZNB3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 08:01:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637931496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=07gYPm51QmP01NPxr0xY8xNHChiDq7dEoTRgz7R1Jo4=;
        b=afkbZs7/ftyqBABgZP4E6l9cyluqFOusTe34/VHf3VmFrYgfaKWMvLF0uWSvnVdRlRjx6f
        s4malLTfIUz58qmgxlyjM2ntncFTDHFocqsVr9BsuXj4ItBeCf3d5LVM2h7EUkEA0a9pQ3
        E0S10X6a4bv8yKNi6xfl00X8vTzQOrk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-228-Bs_NHJ67NEuvWgyOB9Ni0A-1; Fri, 26 Nov 2021 07:58:13 -0500
X-MC-Unique: Bs_NHJ67NEuvWgyOB9Ni0A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 06AB1100C609;
        Fri, 26 Nov 2021 12:58:06 +0000 (UTC)
Received: from [10.39.195.16] (unknown [10.39.195.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C28C604CC;
        Fri, 26 Nov 2021 12:58:02 +0000 (UTC)
Message-ID: <c2977edf-8ab8-9751-677d-991b653823f1@redhat.com>
Date:   Fri, 26 Nov 2021 13:58:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 12/12] KVM: X86: Walk shadow page starting with
 shadow_root_level
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20211124122055.64424-1-jiangshanlai@gmail.com>
 <20211124122055.64424-13-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211124122055.64424-13-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/24/21 13:20, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> Walking from the root page of the shadow page table should start with
> the level of the shadow page table: shadow_root_level.
> 
> Also change a small defect in audit_mappings(), it is believed
> that the current walking level is more valuable to print.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>   arch/x86/kvm/mmu/mmu_audit.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu_audit.c b/arch/x86/kvm/mmu/mmu_audit.c
> index 9e7dcf999f08..6bbbf85b3e46 100644
> --- a/arch/x86/kvm/mmu/mmu_audit.c
> +++ b/arch/x86/kvm/mmu/mmu_audit.c
> @@ -63,7 +63,7 @@ static void mmu_spte_walk(struct kvm_vcpu *vcpu, inspect_spte_fn fn)
>   		hpa_t root = vcpu->arch.mmu->root_hpa;
>   
>   		sp = to_shadow_page(root);
> -		__mmu_spte_walk(vcpu, sp, fn, vcpu->arch.mmu->root_level);
> +		__mmu_spte_walk(vcpu, sp, fn, vcpu->arch.mmu->shadow_root_level);
>   		return;
>   	}
>   
> @@ -119,8 +119,7 @@ static void audit_mappings(struct kvm_vcpu *vcpu, u64 *sptep, int level)
>   	hpa =  pfn << PAGE_SHIFT;
>   	if ((*sptep & PT64_BASE_ADDR_MASK) != hpa)
>   		audit_printk(vcpu->kvm, "levels %d pfn %llx hpa %llx "
> -			     "ent %llxn", vcpu->arch.mmu->root_level, pfn,
> -			     hpa, *sptep);
> +			     "ent %llxn", level, pfn, hpa, *sptep);
>   }
>   
>   static void inspect_spte_has_rmap(struct kvm *kvm, u64 *sptep)
> 

Queued all except patch 11, thanks.

Paolo

