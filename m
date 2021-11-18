Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0214556FF
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 09:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244616AbhKRIeO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 03:34:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29403 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244601AbhKRIeK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 03:34:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637224269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lTL4eaK5mfz0wzJaY3ZitLZvSdyNfMyW+TIZzVoNB2w=;
        b=exLxs4WDHZWq7pUB5zqOnfjUGNviNcDPuWMho0dsKxcJMGXhuVCtETxLFFKojis01/38x7
        SNU3wt5ZvUFdgsPISInWo1QZq9Ohb5BEBLqqDW61rQ+pgEIoZSmUUOANebXatRs06gCcqX
        X/dD0GLRz6TIpRJ9BTaFNH/THxm5QyM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-591-xLAL6LpiPKeleQ07hE0K2Q-1; Thu, 18 Nov 2021 03:31:06 -0500
X-MC-Unique: xLAL6LpiPKeleQ07hE0K2Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F58815721;
        Thu, 18 Nov 2021 08:31:04 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93603104A9CB;
        Thu, 18 Nov 2021 08:30:15 +0000 (UTC)
Message-ID: <a1be97c6-6784-fd5f-74a8-85124f039530@redhat.com>
Date:   Thu, 18 Nov 2021 09:30:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 11/15] KVM: x86/MMU: Refactor vmx_get_mt_mask
Content-Language: en-US
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
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
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211115234603.2908381-12-bgardon@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/21 00:45, Ben Gardon wrote:
> Remove the gotos from vmx_get_mt_mask to make it easier to separate out
> the parts which do not depend on vcpu state.
> 
> No functional change intended.
> 
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>

Queued, thanks (with a slightly edited commit message; the patch is a 
simplification anyway).

Paolo

> ---
>   arch/x86/kvm/vmx/vmx.c | 23 +++++++----------------
>   1 file changed, 7 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 71f54d85f104..77f45c005f28 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6987,7 +6987,6 @@ static int __init vmx_check_processor_compat(void)
>   static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>   {
>   	u8 cache;
> -	u64 ipat = 0;
>   
>   	/* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
>   	 * memory aliases with conflicting memory types and sometimes MCEs.
> @@ -7007,30 +7006,22 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>   	 * EPT memory type is used to emulate guest CD/MTRR.
>   	 */
>   
> -	if (is_mmio) {
> -		cache = MTRR_TYPE_UNCACHABLE;
> -		goto exit;
> -	}
> +	if (is_mmio)
> +		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
>   
> -	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm)) {
> -		ipat = VMX_EPT_IPAT_BIT;
> -		cache = MTRR_TYPE_WRBACK;
> -		goto exit;
> -	}
> +	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
> +		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
>   
>   	if (kvm_read_cr0(vcpu) & X86_CR0_CD) {
> -		ipat = VMX_EPT_IPAT_BIT;
>   		if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
>   			cache = MTRR_TYPE_WRBACK;
>   		else
>   			cache = MTRR_TYPE_UNCACHABLE;
> -		goto exit;
> -	}
>   
> -	cache = kvm_mtrr_get_guest_memory_type(vcpu, gfn);
> +		return (cache << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
> +	}
>   
> -exit:
> -	return (cache << VMX_EPT_MT_EPTE_SHIFT) | ipat;
> +	return kvm_mtrr_get_guest_memory_type(vcpu, gfn) << VMX_EPT_MT_EPTE_SHIFT;
>   }
>   
>   static void vmcs_set_secondary_exec_control(struct vcpu_vmx *vmx, u32 new_ctl)
> 

