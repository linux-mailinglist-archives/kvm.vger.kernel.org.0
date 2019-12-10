Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 040BB1184E8
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 11:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbfLJKWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 05:22:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35072 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726574AbfLJKWu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 05:22:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575973369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1hYi5eS0bvVMUP0KaJ0gTC9c1AaBzYooRd9sn22yfd4=;
        b=ijlcLlMWuEzZo8em564b93MJ6lgjB6vX3OsC1zqKkTDsQAjMwWuPMo6NiXcvJ/WErHSoZt
        lZbVg6y/jNqIMXvJZlCQwSTU2Re1oKV3tAtPYxUC9sZ+tKo3/hq04ny+4Y/8EFeZLPLvuG
        gMydTIq3hKS17c9eU4DmAZGcL9XPMmw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-_1DjeiWaOfON0H6DeWMiKQ-1; Tue, 10 Dec 2019 05:22:46 -0500
Received: by mail-wr1-f69.google.com with SMTP id l20so8792298wrc.13
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 02:22:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1hYi5eS0bvVMUP0KaJ0gTC9c1AaBzYooRd9sn22yfd4=;
        b=k6NS/kB5yNo7qltRifHvV2dgRy5gCXhBoH/GdSX+JsKATFAiIWwtG0TiM6MCU5UF3J
         3vfOZFQpyDOWyzk0LJI35Veed+wGUFNCPa3K5cBnwmPoS+fjqGAV8weH1RbnqBBLqNv5
         8iyymm2isrj2YkMnE6PhgelOLBbHy21gvMhKoGbFMeuI1BHbSSnF5xgiB8RMtPIeWIQs
         G+tCaAoJUwOOU5tIZb/Kif1BYx5tuAcVpgGr8IgRcFdp6rrFOVGUeX2aewUIXrTVmEzO
         Nn6k1iibWKjaRzABF/jF6bMr/kfEXRo1/QBASsZAjC34vNbuG9A1XBAa6SGhOIKXaMWk
         P75g==
X-Gm-Message-State: APjAAAXmp/d+7KD8S5dFG0mRfmTtT3X1dmrAsirUfWqLyBJE0AkAalxb
        R/rOJBIJm0lJEWjXzvMnLQ1189+ulgzKqmD+rTZIXAUaSLGboF/jKwwwLPmqmk2w6de1b3gezGe
        DPvQ/ndLlSaQB
X-Received: by 2002:adf:ec83:: with SMTP id z3mr2272240wrn.133.1575973365550;
        Tue, 10 Dec 2019 02:22:45 -0800 (PST)
X-Google-Smtp-Source: APXvYqxBitfZdf/RJEPq1dZzPfkb453HjvEVJ0+/v+Z4WoHLXSV9FfeJBqhYpzRlJBzCwH1tt+vBvw==
X-Received: by 2002:adf:ec83:: with SMTP id z3mr2272216wrn.133.1575973365287;
        Tue, 10 Dec 2019 02:22:45 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id n3sm2520674wmc.27.2019.12.10.02.22.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 02:22:44 -0800 (PST)
Subject: Re: [PATCH 2/2] KVM: x86: Skip zeroing of MPX state on reset event
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191209201932.14259-1-sean.j.christopherson@intel.com>
 <20191209201932.14259-3-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8c0589c5-f7c5-604c-3090-56dc886cb817@redhat.com>
Date:   Tue, 10 Dec 2019 11:22:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191209201932.14259-3-sean.j.christopherson@intel.com>
Content-Language: en-US
X-MC-Unique: _1DjeiWaOfON0H6DeWMiKQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/12/19 21:19, Sean Christopherson wrote:
> Don't bother zeroing out MPX state in the guest's FPU on a reset event,
> the guest's FPU is always zero allocated and there is no path between
> kvm_arch_vcpu_create() and kvm_arch_vcpu_setup() that can lead to guest
> MPX state being modified.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Makes sense, but it's a bit weird to have INIT reset _less_ state than
RESET...  I've queued patch 1 only for now.

Paolo

> ---
>  arch/x86/kvm/x86.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 854ae27bb021..e6f4174f55cd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9194,15 +9194,14 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	kvm_async_pf_hash_reset(vcpu);
>  	vcpu->arch.apf.halted = false;
>  
> -	if (kvm_mpx_supported()) {
> +	if (kvm_mpx_supported() && init_event) {
>  		void *mpx_state_buffer;
>  
>  		/*
> -		 * To avoid have the INIT path from kvm_apic_has_events() that be
> -		 * called with loaded FPU and does not let userspace fix the state.
> +		 * Temporarily flush the guest's FPU to memory so that zeroing
> +		 * out the MPX areas is done using up-to-date state.
>  		 */
> -		if (init_event)
> -			kvm_put_guest_fpu(vcpu);
> +		kvm_put_guest_fpu(vcpu);
>  		mpx_state_buffer = get_xsave_addr(&vcpu->arch.guest_fpu->state.xsave,
>  					XFEATURE_BNDREGS);
>  		if (mpx_state_buffer)
> @@ -9211,8 +9210,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  					XFEATURE_BNDCSR);
>  		if (mpx_state_buffer)
>  			memset(mpx_state_buffer, 0, sizeof(struct mpx_bndcsr));
> -		if (init_event)
> -			kvm_load_guest_fpu(vcpu);
> +		kvm_load_guest_fpu(vcpu);
>  	}
>  
>  	if (!init_event) {
> 

