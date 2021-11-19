Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1EDC456C09
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 10:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbhKSJG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 04:06:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55595 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232120AbhKSJG3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 04:06:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637312607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iQtpyLAVYENXDFADgRTyWauR5YWHwKLLWz+hp3I4u94=;
        b=Pz1Zd3kyrJXveqmWKtaZqps1Dmx0bYPxR+wBf9daq7DSsicQpr3h+GGd+x72OHglbn4+dC
        6X1XuCva4Ythdi3UV4Ds6cQYwnMxjJo3/H+RySt3IgAxv1+jRWOkpfJFzmFYaRlgB3lLT5
        ID/fe5W7+voFlecByjCFGmXVxLNPyHA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-196-HnDGnQq_O4yyL8dejjlc0Q-1; Fri, 19 Nov 2021 04:03:23 -0500
X-MC-Unique: HnDGnQq_O4yyL8dejjlc0Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 23C4F19253C9;
        Fri, 19 Nov 2021 09:03:22 +0000 (UTC)
Received: from [10.39.194.192] (unknown [10.39.194.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F0385D9DE;
        Fri, 19 Nov 2021 09:02:50 +0000 (UTC)
Message-ID: <942d487e-ba6b-9c60-e200-3590524137b9@redhat.com>
Date:   Fri, 19 Nov 2021 10:02:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 11/15] KVM: x86/MMU: Refactor vmx_get_mt_mask
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
References: <20211115234603.2908381-1-bgardon@google.com>
 <20211115234603.2908381-12-bgardon@google.com>
 <a1be97c6-6784-fd5f-74a8-85124f039530@redhat.com>
 <YZZxivgSeGH4wZnB@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YZZxivgSeGH4wZnB@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/18/21 16:30, Sean Christopherson wrote:
> On Thu, Nov 18, 2021, Paolo Bonzini wrote:
>> On 11/16/21 00:45, Ben Gardon wrote:
>>> Remove the gotos from vmx_get_mt_mask to make it easier to separate out
>>> the parts which do not depend on vcpu state.
>>>
>>> No functional change intended.
>>>
>>>
>>> Signed-off-by: Ben Gardon <bgardon@google.com>
>>
>> Queued, thanks (with a slightly edited commit message; the patch is a
>> simplification anyway).
> 
> Don't know waht message you've queued, but just in case you kept some of the original,
> can you further edit it to remove any snippets that mention separating out the parts
> that don't depend on vCPU state?

Indeed I did keep some:

commit b7297e02826857e068d03f844c8336ce48077d78
Author: Ben Gardon <bgardon@google.com>
Date:   Mon Nov 15 15:45:59 2021 -0800

     KVM: x86/MMU: Simplify flow of vmx_get_mt_mask
     
     Remove the gotos from vmx_get_mt_mask.  This may later make it easier
     to separate out the parts which do not depend on vcpu state, but it also
     simplifies the code in general.
     
     No functional change intended.

i.e. keeping it conditional but I can edit it further, like

     Remove the gotos from vmx_get_mt_mask.  It's easier to build the whole
     memory type at once, than it is to combine separate cacheability and ipat
     fields.

Paolo

> IMO, we should not separate vmx_get_mt_mask() into per-VM and per-vCPU variants,
> because the per-vCPU variant is a lie.  The memtype of a SPTE is not tracked anywhere,
> which means that if the guest has non-uniform CR0.CD/NW or MTRR settings, KVM will
> happily let the guest consumes SPTEs with the incorrect memtype.  In practice, this
> isn't an issue because no sane BIOS or kernel uses per-CPU MTRRs, nor do they have
> DMA operations running while the cacheability state is in flux.
> 
> If we really want to make this state per-vCPU, KVM would need to incorporate the
> CR0.CD and MTRR settings in kvm_mmu_page_role.  For MTRRs in particular, the worst
> case scenario is that every vCPU has different MTRR settings, which means that
> kvm_mmu_page_role would need to be expanded by 10 bits in order to track every
> possible vcpu_idx (currently capped at 1024).

Yes, that's insanity.  I was also a bit skeptical about Ben's try_get_mt_mask callback,
but this would be much much worse.

Paolo

> So unless we want to massively complicate kvm_mmu_page_role and gfn_track for a
> scenario no one cares about, I would strongly prefer to acknowledge that KVM assumes
> memtypes are a per-VM property, e.g. on top:
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 77f45c005f28..8a84d30f1dbd 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6984,8 +6984,9 @@ static int __init vmx_check_processor_compat(void)
>          return 0;
>   }
> 
> -static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> +static u64 vmx_get_mt_mask(struct kvm *kvm, gfn_t gfn, bool is_mmio)
>   {
> +       struct kvm_vcpu *vcpu;
>          u8 cache;
> 
>          /* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
> @@ -7009,11 +7010,15 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>          if (is_mmio)
>                  return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
> 
> -       if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
> +       if (!kvm_arch_has_noncoherent_dma(kvm))
>                  return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
> 
> +       vcpu = kvm_get_vcpu_by_id(kvm, 0);
> +       if (KVM_BUG_ON(!vcpu, kvm))
> +               return;
> +
>          if (kvm_read_cr0(vcpu) & X86_CR0_CD) {
> -               if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
> +               if (kvm_check_has_quirk(kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
>                          cache = MTRR_TYPE_WRBACK;
>                  else
>                          cache = MTRR_TYPE_UNCACHABLE;
> 

