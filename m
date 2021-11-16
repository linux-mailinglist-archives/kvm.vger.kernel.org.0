Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82495453543
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 16:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238082AbhKPPJt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 10:09:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39677 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237880AbhKPPJD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 10:09:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637075165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HyuXwAmkkTO7mgEitLVMCJ/JNa+mg8wXRbHRR4HRkr8=;
        b=XKuXNHYzKMn0EwCAoVmfjP9DgOqDBulWylTVf6NPM+MuE9QCmgE4MWrWhXxAqs3MUvhhpk
        n6+jFLBe2pglqMQJagPSpFQSVVPwfAfp3reNqhAKhVugP4SYnXTPu5nJ/WneVaVGw1Afaa
        TvQGQbHepcggzqo6FbhrroDkyUz6kjY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-6FF3lnZpM36imoqjrLFBtQ-1; Tue, 16 Nov 2021 10:06:02 -0500
X-MC-Unique: 6FF3lnZpM36imoqjrLFBtQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AED3C1006AA0;
        Tue, 16 Nov 2021 15:05:58 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E1D5E5D6BA;
        Tue, 16 Nov 2021 15:05:50 +0000 (UTC)
Message-ID: <e144f5fc-ea16-7f52-9c9c-4422c889f082@redhat.com>
Date:   Tue, 16 Nov 2021 16:05:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2] KVM: x86: Assume a 64-bit hypercall for guests with
 protected state
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>
References: <e0b20c770c9d0d1403f23d83e785385104211f74.1621878537.git.thomas.lendacky@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <e0b20c770c9d0d1403f23d83e785385104211f74.1621878537.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/24/21 19:48, Tom Lendacky wrote:
> When processing a hypercall for a guest with protected state, currently
> SEV-ES guests, the guest CS segment register can't be checked to
> determine if the guest is in 64-bit mode. For an SEV-ES guest, it is
> expected that communication between the guest and the hypervisor is
> performed to shared memory using the GHCB. In order to use the GHCB, the
> guest must have been in long mode, otherwise writes by the guest to the
> GHCB would be encrypted and not be able to be comprehended by the
> hypervisor.
> 
> Create a new helper function, is_64_bit_hypercall(), that assumes the
> guest is in 64-bit mode when the guest has protected state, and returns
> true, otherwise invoking is_64_bit_mode() to determine the mode. Update
> the hypercall related routines to use is_64_bit_hypercall() instead of
> is_64_bit_mode().
> 
> Add a WARN_ON_ONCE() to is_64_bit_mode() to catch occurences of calls to
> this helper function for a guest running with protected state.
> 
> Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
> Reported-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
> ---
> 
> Changes since v1:
> - Create a new helper routine, is_64_bit_hypercall(), and use it in place
>    of is_64_bit_mode() in hypercall related areas.
> - Add a WARN_ON_ONCE() to is_64_bit_mode() to issue a warning if invoked
>    for a guest with protected state.
> ---
>   arch/x86/kvm/hyperv.c |  4 ++--
>   arch/x86/kvm/x86.c    |  2 +-
>   arch/x86/kvm/x86.h    | 12 ++++++++++++
>   arch/x86/kvm/xen.c    |  2 +-
>   4 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index f98370a39936..1cdf2b213f41 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1818,7 +1818,7 @@ static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
>   {
>   	bool longmode;
>   
> -	longmode = is_64_bit_mode(vcpu);
> +	longmode = is_64_bit_hypercall(vcpu);
>   	if (longmode)
>   		kvm_rax_write(vcpu, result);
>   	else {
> @@ -1895,7 +1895,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>   	}
>   
>   #ifdef CONFIG_X86_64
> -	if (is_64_bit_mode(vcpu)) {
> +	if (is_64_bit_hypercall(vcpu)) {
>   		param = kvm_rcx_read(vcpu);
>   		ingpa = kvm_rdx_read(vcpu);
>   		outgpa = kvm_r8_read(vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9b6bca616929..dc72f0a1609a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8403,7 +8403,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>   
>   	trace_kvm_hypercall(nr, a0, a1, a2, a3);
>   
> -	op_64_bit = is_64_bit_mode(vcpu);
> +	op_64_bit = is_64_bit_hypercall(vcpu);
>   	if (!op_64_bit) {
>   		nr &= 0xFFFFFFFF;
>   		a0 &= 0xFFFFFFFF;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 521f74e5bbf2..3102caf689d2 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -151,12 +151,24 @@ static inline bool is_64_bit_mode(struct kvm_vcpu *vcpu)
>   {
>   	int cs_db, cs_l;
>   
> +	WARN_ON_ONCE(vcpu->arch.guest_state_protected);
> +
>   	if (!is_long_mode(vcpu))
>   		return false;
>   	static_call(kvm_x86_get_cs_db_l_bits)(vcpu, &cs_db, &cs_l);
>   	return cs_l;
>   }
>   
> +static inline bool is_64_bit_hypercall(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * If running with protected guest state, the CS register is not
> +	 * accessible. The hypercall register values will have had to been
> +	 * provided in 64-bit mode, so assume the guest is in 64-bit.
> +	 */
> +	return vcpu->arch.guest_state_protected || is_64_bit_mode(vcpu);
> +}
> +
>   static inline bool is_la57_mode(struct kvm_vcpu *vcpu)
>   {
>   #ifdef CONFIG_X86_64
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index ae17250e1efe..c58f6369e668 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -680,7 +680,7 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
>   	    kvm_hv_hypercall_enabled(vcpu))
>   		return kvm_hv_hypercall(vcpu);
>   
> -	longmode = is_64_bit_mode(vcpu);
> +	longmode = is_64_bit_hypercall(vcpu);
>   	if (!longmode) {
>   		params[0] = (u32)kvm_rbx_read(vcpu);
>   		params[1] = (u32)kvm_rcx_read(vcpu);
> 

Queued, thanks.

Paolo

