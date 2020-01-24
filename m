Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A69C14921E
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2020 00:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgAXXoh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 18:44:37 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58664 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729147AbgAXXoh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jan 2020 18:44:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5wmuqZHJ0qjX/S2LwVb/rXLGz5kyAVoKbDfXUhdGJdI=; b=TB5aRvyexEVLTORwua6Ovuia9
        0eOc3wsqmfUeXA3Ox4CsevvHi5qpJdZXPX/zQIAn5KmRtt8TA/O42Dx0MuWZf3TIF9Q13l0UZ8RsB
        HjlmHVDSXPkQ01XmxRijrou6QK2lwtY+ZLVftYalZbt8c4OKl01iE+b56BcQ5X8DizRD08i5n77bq
        hIP9tsM7Mhj9i2Lu8pJMbWssEbdhLRCxbhtjquHzeQ0B3jmTeGdZ8khKuR1Nf37xvvzpRxDO74XkL
        YcWWe3ToBkZEIVBm0XwuWlvFV/cAY89eECtiv0mm4DbQVUSEFGHn2aptw3XTnsrBHY4fvJcgkrfmK
        I/MHCDITg==;
Received: from [2601:1c0:6280:3f0::ed68]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iv8cn-0002lu-RU; Fri, 24 Jan 2020 23:44:29 +0000
Subject: Re: [PATCH] KVM: x86: Take a u64 when checking for a valid dr7 value
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20200124230722.8964-1-sean.j.christopherson@intel.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <bcd1b46c-15eb-f28a-c8c0-ed2fb103a25f@infradead.org>
Date:   Fri, 24 Jan 2020 15:44:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200124230722.8964-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/24/20 3:07 PM, Sean Christopherson wrote:
> Take a u64 instead of an unsigned long in kvm_dr7_valid() to fix a build
> warning on i386 due to right-shifting a 32-bit value by 32 when checking
> for bits being set in dr7[63:32].
> 
> Alternatively, the warning could be resolved by rewriting the check to
> use an i386-friendly method, but taking a u64 fixes another oddity on
> 32-bit KVM.  Beause KVM implements natural width VMCS fields as u64s to
> avoid layout issues between 32-bit and 64-bit, a devious guest can stuff
> vmcs12->guest_dr7 with a 64-bit value even when both the guest and host
> are 32-bit kernels.  KVM eventually drops vmcs12->guest_dr7[63:32] when
> propagating vmcs12->guest_dr7 to vmcs02, but ideally KVM would not rely
> on that behavior for correctness.
> 
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Fixes: ecb697d10f70 ("KVM: nVMX: Check GUEST_DR7 on vmentry of nested guests")
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks.

> ---
>  arch/x86/kvm/x86.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 2d2ff855773b..3624665acee4 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -357,7 +357,7 @@ static inline bool kvm_pat_valid(u64 data)
>  	return (data | ((data & 0x0202020202020202ull) << 1)) == data;
>  }
>  
> -static inline bool kvm_dr7_valid(unsigned long data)
> +static inline bool kvm_dr7_valid(u64 data)
>  {
>  	/* Bits [63:32] are reserved */
>  	return !(data >> 32);
> 


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
