Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2541C4B15
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 02:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgEEAgr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 20:36:47 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29477 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726891AbgEEAgq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 20:36:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588639004;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0SZj6Gw7F7K83+hrO9xjG8SSTgvs+vu7sVPYN7PJrHA=;
        b=OKSKzDh8jXRILNqSeBi05zo9l/BlJ7GS+lW/mHCnQWwjdd1vSTGo6rldRYIUnIi/XZFbw1
        mrUBU4yos+jB6sWPs8ySVLnGo1nN3oW+kMgMxzy+5VKhsYB5g1MBetqEgBcFE9WrTy9hPm
        r0PcJSNDffnykQG+Me/cOjwojh9O06A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-l1hft9ObPeyd7nOG3vMWJw-1; Mon, 04 May 2020 20:36:41 -0400
X-MC-Unique: l1hft9ObPeyd7nOG3vMWJw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A729462;
        Tue,  5 May 2020 00:36:39 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-132.bne.redhat.com [10.64.54.132])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E85666062;
        Tue,  5 May 2020 00:36:34 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH RFC 4/6] KVM: x86: acknowledgment mechanism for async pf
 page ready notifications
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
 <20200429093634.1514902-5-vkuznets@redhat.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <bdd3fba1-72d6-9096-e63d-a89f2990a26d@redhat.com>
Date:   Tue, 5 May 2020 10:36:32 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200429093634.1514902-5-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly,

On 4/29/20 7:36 PM, Vitaly Kuznetsov wrote:
> If two page ready notifications happen back to back the second one is not
> delivered and the only mechanism we currently have is
> kvm_check_async_pf_completion() check in vcpu_run() loop. The check will
> only be performed with the next vmexit when it happens and in some cases
> it may take a while. With interrupt based page ready notification delivery
> the situation is even worse: unlike exceptions, interrupts are not handled
> immediately so we must check if the slot is empty. This is slow and
> unnecessary. Introduce dedicated MSR_KVM_ASYNC_PF_ACK MSR to communicate
> the fact that the slot is free and host should check its notification
> queue. Mandate using it for interrupt based type 2 APF event delivery.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>   Documentation/virt/kvm/msr.rst       | 16 +++++++++++++++-
>   arch/x86/include/uapi/asm/kvm_para.h |  1 +
>   arch/x86/kvm/x86.c                   |  9 ++++++++-
>   3 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/msr.rst b/Documentation/virt/kvm/msr.rst
> index 7433e55f7184..18db3448db06 100644
> --- a/Documentation/virt/kvm/msr.rst
> +++ b/Documentation/virt/kvm/msr.rst
> @@ -219,6 +219,11 @@ data:
>   	If during pagefault APF reason is 0 it means that this is regular
>   	page fault.
>   
> +	For interrupt based delivery, guest has to write '1' to
> +	MSR_KVM_ASYNC_PF_ACK every time it clears reason in the shared
> +	'struct kvm_vcpu_pv_apf_data', this forces KVM to re-scan its
> +	queue and deliver next pending notification.
> +
>   	During delivery of type 1 APF cr2 contains a token that will
>   	be used to notify a guest when missing page becomes
>   	available. When page becomes available type 2 APF is sent with
> @@ -340,4 +345,13 @@ data:
>   
>   	To switch to interrupt based delivery of type 2 APF events guests
>   	are supposed to enable asynchronous page faults and set bit 3 in
> -	MSR_KVM_ASYNC_PF_EN first.
> +
> +MSR_KVM_ASYNC_PF_ACK:
> +	0x4b564d07
> +
> +data:
> +	Asynchronous page fault acknowledgment. When the guest is done
> +	processing type 2 APF event and 'reason' field in 'struct
> +	kvm_vcpu_pv_apf_data' is cleared it is supposed to write '1' to
> +	Bit 0 of the MSR, this caused the host to re-scan its queue and
> +	check if there are more notifications pending.

I'm not sure if I understood the usage of MSR_KVM_ASYNC_PF_ACK
completely. It seems it's used to trapped to host, to have chance
to check/deliver pending page ready events. If there is no pending
events, no work will be finished in the trap. If it's true, it might
be good idea to trap conditionally, meaning writing to ASYNC_PF_ACK
if there are really pending events?

Thanks,
Gavin

> diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> index 1bbb0b7e062f..5c7449980619 100644
> --- a/arch/x86/include/uapi/asm/kvm_para.h
> +++ b/arch/x86/include/uapi/asm/kvm_para.h
> @@ -51,6 +51,7 @@
>   #define MSR_KVM_PV_EOI_EN      0x4b564d04
>   #define MSR_KVM_POLL_CONTROL	0x4b564d05
>   #define MSR_KVM_ASYNC_PF2	0x4b564d06
> +#define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
>   
>   struct kvm_steal_time {
>   	__u64 steal;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 861dce1e7cf5..e3b91ac33bfd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1243,7 +1243,7 @@ static const u32 emulated_msrs_all[] = {
>   	HV_X64_MSR_TSC_EMULATION_STATUS,
>   
>   	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
> -	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF2,
> +	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF2, MSR_KVM_ASYNC_PF_ACK,
>   
>   	MSR_IA32_TSC_ADJUST,
>   	MSR_IA32_TSCDEADLINE,
> @@ -2915,6 +2915,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		if (kvm_pv_enable_async_pf2(vcpu, data))
>   			return 1;
>   		break;
> +	case MSR_KVM_ASYNC_PF_ACK:
> +		if (data & 0x1)
> +			kvm_check_async_pf_completion(vcpu);
> +		break;
>   	case MSR_KVM_STEAL_TIME:
>   
>   		if (unlikely(!sched_info_on()))
> @@ -3194,6 +3198,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	case MSR_KVM_ASYNC_PF2:
>   		msr_info->data = vcpu->arch.apf.msr2_val;
>   		break;
> +	case MSR_KVM_ASYNC_PF_ACK:
> +		msr_info->data = 0;
> +		break;
>   	case MSR_KVM_STEAL_TIME:
>   		msr_info->data = vcpu->arch.st.msr_val;
>   		break;
> 

