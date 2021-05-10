Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8E5378FAC
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 15:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236894AbhEJNwg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 09:52:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53461 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241616AbhEJNpL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 09:45:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620654243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W6Wr/fcCvGXSJiUgiCM3h04BjKushL2O2fPQ/SYIby8=;
        b=FR4ioUu+bpRzrYp01/sF9nZm+V1jCvoqaxTtjgrpGU1osp4fHtSvDJgHcMyO1AVkrSMKJQ
        t5rK2TVbsyNVZ5yNjFmaPPtrNnKgWShHg/1xmB7ce2FnMgPmFCjk1Ej0Fi0gv2xX3h0Jv7
        1iP6cN/MLCkWzcaHw4y1Jb++SCgb2OY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-fa6o1iECMFCvU-7tn_-cpg-1; Mon, 10 May 2021 09:43:59 -0400
X-MC-Unique: fa6o1iECMFCvU-7tn_-cpg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F42B189C44C;
        Mon, 10 May 2021 13:43:58 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87A8E1037F32;
        Mon, 10 May 2021 13:43:54 +0000 (UTC)
Message-ID: <6b7835a40a9a67de9ca2ea585fda93221fcadc09.camel@redhat.com>
Subject: Re: [PATCH 2/8] KVM: X86: Store L1's TSC scaling ratio in 'struct
 kvm_vcpu_arch'
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     ilstam@mailbox.org, kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     ilstam@amazon.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        haozhong.zhang@intel.com, zamsden@gmail.com, mtosatti@redhat.com,
        dplotnikov@virtuozzo.com, dwmw@amazon.co.uk
Date:   Mon, 10 May 2021 16:43:53 +0300
In-Reply-To: <20210506103228.67864-3-ilstam@mailbox.org>
References: <20210506103228.67864-1-ilstam@mailbox.org>
         <20210506103228.67864-3-ilstam@mailbox.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-05-06 at 10:32 +0000, ilstam@mailbox.org wrote:
> From: Ilias Stamatis <ilstam@amazon.com>
> 
> Store L1's scaling ratio in that struct like we already do for L1's TSC
> offset. This allows for easy save/restore when we enter and then exit
> the nested guest.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 5 +++--
>  arch/x86/kvm/x86.c              | 4 +++-
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index cbbcee0a84f9..132e820525fb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -705,7 +705,7 @@ struct kvm_vcpu_arch {
>  	} st;
>  
>  	u64 l1_tsc_offset;
> -	u64 tsc_offset;
> +	u64 tsc_offset; /* current tsc offset */
>  	u64 last_guest_tsc;
>  	u64 last_host_tsc;
>  	u64 tsc_offset_adjustment;
> @@ -719,7 +719,8 @@ struct kvm_vcpu_arch {
>  	u32 virtual_tsc_khz;
>  	s64 ia32_tsc_adjust_msr;
>  	u64 msr_ia32_power_ctl;
> -	u64 tsc_scaling_ratio;
> +	u64 l1_tsc_scaling_ratio;
> +	u64 tsc_scaling_ratio; /* current scaling ratio */
>  
>  	atomic_t nmi_queued;  /* unprocessed asynchronous NMIs */
>  	unsigned nmi_pending; /* NMI queued after currently running handler */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cebdaa1e3cf5..7bc5155ac6fd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2119,6 +2119,7 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
>  
>  	/* Guest TSC same frequency as host TSC? */
>  	if (!scale) {
> +		vcpu->arch.l1_tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
>  		vcpu->arch.tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
>  		return 0;
>  	}
> @@ -2145,7 +2146,7 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
>  		return -1;
>  	}
>  
> -	vcpu->arch.tsc_scaling_ratio = ratio;
> +	vcpu->arch.l1_tsc_scaling_ratio = vcpu->arch.tsc_scaling_ratio = ratio;
>  	return 0;
>  }
>  
> @@ -2157,6 +2158,7 @@ static int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
>  	/* tsc_khz can be zero if TSC calibration fails */
>  	if (user_tsc_khz == 0) {
>  		/* set tsc_scaling_ratio to a safe value */
> +		vcpu->arch.l1_tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
>  		vcpu->arch.tsc_scaling_ratio = kvm_default_tsc_scaling_ratio;
>  		return -1;
>  	}
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>



