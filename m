Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613211C4A9E
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 01:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgEDXxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 19:53:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27272 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728351AbgEDXw7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 19:52:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588636378;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aMMkAii//hOjjah/wFry8XI5JrN/TtYxtkhOj6HfRi0=;
        b=BtzWkZxyI0Nt+up6hKu6HMwpPVUR4LnawwbtbETO3gR1spry1BG+ORVaOUW2w3It7wNTr1
        w+LhIl95BJpv8j5o5ornSC7s3z+nXfCOD5Ku7wrB5sLxUXhSFlR7m4L7em98XUZsdRq0s2
        0y4VY/mI/FQkIIDuxd9blKliMBK9Ur8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-DWmS5O72MsepFRv42TrOaA-1; Mon, 04 May 2020 19:52:55 -0400
X-MC-Unique: DWmS5O72MsepFRv42TrOaA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5D07C835B4F;
        Mon,  4 May 2020 23:52:53 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-132.bne.redhat.com [10.64.54.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5856962486;
        Mon,  4 May 2020 23:52:48 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH RFC 2/6] KVM: x86: extend struct kvm_vcpu_pv_apf_data with
 token info
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
References: <20200429093634.1514902-1-vkuznets@redhat.com>
 <20200429093634.1514902-3-vkuznets@redhat.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <409b802c-0abe-0cb4-92fe-925733bfd612@redhat.com>
Date:   Tue, 5 May 2020 09:52:45 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200429093634.1514902-3-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly,

On 4/29/20 7:36 PM, Vitaly Kuznetsov wrote:
> Currently, APF mechanism relies on the #PF abuse where the token is being
> passed through CR2. If we switch to using interrupts to deliver page-ready
> notifications we need a different way to pass the data. Extent the existing
> 'struct kvm_vcpu_pv_apf_data' with token information.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>   arch/x86/include/uapi/asm/kvm_para.h |  3 ++-
>   arch/x86/kvm/x86.c                   | 10 ++++++----
>   2 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 2a8e0b6b9805..df2ba34037a2 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -113,7 +113,8 @@ struct kvm_mmu_op_release_pt {
>   
>   struct kvm_vcpu_pv_apf_data {
>   	__u32 reason;
> -	__u8 pad[60];
> +	__u32 token;
> +	__u8 pad[56];
>   	__u32 enabled;
>   };
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b93133ee07ba..7c21c0cf0a33 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2662,7 +2662,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
>   	}
>   
>   	if (kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.apf.data, gpa,
> -					sizeof(u32)))
> +					sizeof(u64)))
>   		return 1;
>   
>   	vcpu->arch.apf.send_user_only = !(data & KVM_ASYNC_PF_SEND_ALWAYS);
> @@ -10352,8 +10352,9 @@ static void kvm_del_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn)
>   	}
>   }
>   
> -static int apf_put_user(struct kvm_vcpu *vcpu, u32 val)
> +static int apf_put_user(struct kvm_vcpu *vcpu, u32 reason, u32 token)
>   {
> +	u64 val = (u64)token << 32 | reason;
>   
>   	return kvm_write_guest_cached(vcpu->kvm, &vcpu->arch.apf.data, &val,
>   				      sizeof(val));
> @@ -10405,7 +10406,8 @@ void kvm_arch_async_page_not_present(struct kvm_vcpu *vcpu,
>   	kvm_add_async_pf_gfn(vcpu, work->arch.gfn);
>   
>   	if (kvm_can_deliver_async_pf(vcpu) &&
> -	    !apf_put_user(vcpu, KVM_PV_REASON_PAGE_NOT_PRESENT)) {
> +	    !apf_put_user(vcpu, KVM_PV_REASON_PAGE_NOT_PRESENT,
> +			  work->arch.token)) {
>   		fault.vector = PF_VECTOR;
>   		fault.error_code_valid = true;
>   		fault.error_code = 0;
> @@ -10438,7 +10440,7 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
>   	trace_kvm_async_pf_ready(work->arch.token, work->cr2_or_gpa);
>   
>   	if (vcpu->arch.apf.msr_val & KVM_ASYNC_PF_ENABLED &&
> -	    !apf_put_user(vcpu, KVM_PV_REASON_PAGE_READY)) {
> +	    !apf_put_user(vcpu, KVM_PV_REASON_PAGE_READY, work->arch.token)) {
>   			fault.vector = PF_VECTOR;
>   			fault.error_code_valid = true;
>   			fault.error_code = 0;
> 

It would be as below based on two facts: (1) token is more important than reason;
(2) token will be put into high word of @val. I think apf_{get,put}_user() might
be worthy to be inline. However, it's not a big deal.

    static inline int apf_put_user(struct kvm_vcpu *vcpu, u32 token, u32 reason)

Thanks,
Gavin
    

