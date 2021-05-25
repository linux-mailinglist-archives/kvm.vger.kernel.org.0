Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5520438FAD9
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 08:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbhEYG1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 02:27:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43875 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230462AbhEYG1H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 02:27:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621923937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O2u8/KcKMigjRFo17Ta45XDICW0GwxksgjFfdg5+KBE=;
        b=Omkw1PwSALA5IGbe8g1DQOG7qGHVyO4AGZ2Py2CYwUZ5pjN2hQLZN/SwyZYy9Gb1nEiI0g
        0N/UD6QMz/ztoFNtjhvRdOq47/i2sDKxBdAUvxm+i75pOFkQyn3KS9TtPgygSb3Ib5sw3y
        kkfAFKYmxGFCDTOIe5g9BevzHVWo7ds=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-nHijEJpRPCaZ5bNNmOVFyA-1; Tue, 25 May 2021 02:25:36 -0400
X-MC-Unique: nHijEJpRPCaZ5bNNmOVFyA-1
Received: by mail-wr1-f70.google.com with SMTP id i102-20020adf90ef0000b029010dfcfc46c0so14146797wri.1
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 23:25:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=O2u8/KcKMigjRFo17Ta45XDICW0GwxksgjFfdg5+KBE=;
        b=BQraARIA6sGYgXtar+MoySJ3lefL4CZ6ANVoibOx5vpuPbulep6Jw9lWLheyG3a2IN
         Wq6f9BbOl+uAM/fvSFuYPL/HhPMhwd+2+Z7TMM8Gx3BarRbTmpkRF7A3hGeAA2FV9kHl
         mRL104KwLmCkmum7uCbq5Ozhyy+mGtIBBQLxHk6AJOpN5cJvp8r+7NxvGZdIQhGQWrMg
         xy3f2ncHdvJdJZkEB7gZRc1hw4+S+dRR43ENBIiGvB1x6PD9Bcye/diVs0tM5KAvmRKm
         KItY71Oe7vWVd//y7QUG1snQRPVCiv/SVQfxpqduzjk35IKOatwvOlpPZDR5kgvi4cmC
         KLRg==
X-Gm-Message-State: AOAM5300spO3r6jHx+9IdHzHeeB1bQdLtSn5EJ36oLD+JDsQa/jQHcVX
        5tFVURmFWKJ0lrWTO9b86fkLFA+Ie73i3+6Bn3Gu0sCvJcub/kBqVCz+cFYECiTRa2hK+wQP2Lt
        5Vsjr5b2p5m/f
X-Received: by 2002:adf:ed52:: with SMTP id u18mr24752092wro.379.1621923934828;
        Mon, 24 May 2021 23:25:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFbS+Phm3Wzu6vFH9TExvTJCPfhn0t9gxxsslxSgPxz1EyZ+IFtsbxGHbauYQDHqhFsO4k/A==
X-Received: by 2002:adf:ed52:: with SMTP id u18mr24752079wro.379.1621923934677;
        Mon, 24 May 2021 23:25:34 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id i5sm15145188wrw.29.2021.05.24.23.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 23:25:34 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2] KVM: x86: Assume a 64-bit hypercall for guests with
 protected state
In-Reply-To: <e0b20c770c9d0d1403f23d83e785385104211f74.1621878537.git.thomas.lendacky@amd.com>
References: <e0b20c770c9d0d1403f23d83e785385104211f74.1621878537.git.thomas.lendacky@amd.com>
Date:   Tue, 25 May 2021 08:25:32 +0200
Message-ID: <87cztf8h43.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tom Lendacky <thomas.lendacky@amd.com> writes:

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
>   of is_64_bit_mode() in hypercall related areas.
> - Add a WARN_ON_ONCE() to is_64_bit_mode() to issue a warning if invoked
>   for a guest with protected state.
> ---
>  arch/x86/kvm/hyperv.c |  4 ++--
>  arch/x86/kvm/x86.c    |  2 +-
>  arch/x86/kvm/x86.h    | 12 ++++++++++++
>  arch/x86/kvm/xen.c    |  2 +-
>  4 files changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index f98370a39936..1cdf2b213f41 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1818,7 +1818,7 @@ static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
>  {
>  	bool longmode;
>  
> -	longmode = is_64_bit_mode(vcpu);
> +	longmode = is_64_bit_hypercall(vcpu);
>  	if (longmode)
>  		kvm_rax_write(vcpu, result);
>  	else {
> @@ -1895,7 +1895,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  	}
>  
>  #ifdef CONFIG_X86_64
> -	if (is_64_bit_mode(vcpu)) {
> +	if (is_64_bit_hypercall(vcpu)) {
>  		param = kvm_rcx_read(vcpu);
>  		ingpa = kvm_rdx_read(vcpu);
>  		outgpa = kvm_r8_read(vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9b6bca616929..dc72f0a1609a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8403,7 +8403,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  
>  	trace_kvm_hypercall(nr, a0, a1, a2, a3);
>  
> -	op_64_bit = is_64_bit_mode(vcpu);
> +	op_64_bit = is_64_bit_hypercall(vcpu);
>  	if (!op_64_bit) {
>  		nr &= 0xFFFFFFFF;
>  		a0 &= 0xFFFFFFFF;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 521f74e5bbf2..3102caf689d2 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -151,12 +151,24 @@ static inline bool is_64_bit_mode(struct kvm_vcpu *vcpu)
>  {
>  	int cs_db, cs_l;
>  
> +	WARN_ON_ONCE(vcpu->arch.guest_state_protected);
> +
>  	if (!is_long_mode(vcpu))
>  		return false;
>  	static_call(kvm_x86_get_cs_db_l_bits)(vcpu, &cs_db, &cs_l);
>  	return cs_l;
>  }
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
>  static inline bool is_la57_mode(struct kvm_vcpu *vcpu)
>  {
>  #ifdef CONFIG_X86_64
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index ae17250e1efe..c58f6369e668 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -680,7 +680,7 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
>  	    kvm_hv_hypercall_enabled(vcpu))
>  		return kvm_hv_hypercall(vcpu);
>  
> -	longmode = is_64_bit_mode(vcpu);
> +	longmode = is_64_bit_hypercall(vcpu);
>  	if (!longmode) {
>  		params[0] = (u32)kvm_rbx_read(vcpu);
>  		params[1] = (u32)kvm_rcx_read(vcpu);

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Thanks!

-- 
Vitaly

