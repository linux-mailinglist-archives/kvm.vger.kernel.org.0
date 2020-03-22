Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69BAC18E913
	for <lists+kvm@lfdr.de>; Sun, 22 Mar 2020 14:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbgCVNIV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 09:08:21 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:37204 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725892AbgCVNIT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 22 Mar 2020 09:08:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584882498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wo+FEifuRFslOR4lP0rC0Ti7Taj/A+kMlugh1DShQME=;
        b=Tag0G7d6ysCVSnBR/Mg16CmGmSfgV+RcWeGKn+tmHgqQGjYocGNSRV0iXlx0o17P43Kz1Q
        L5uOElm80PRZxXFY4KlfpcyqCozpwIBQRXf8WP8N3I9L1bHDfe5N1ondA2AByXtsX3J2Ly
        8p63TYncfx4HUDZybwwjH9wrwVinOBY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-eIxScHk1Pcq93aIvx1QP3g-1; Sun, 22 Mar 2020 09:08:16 -0400
X-MC-Unique: eIxScHk1Pcq93aIvx1QP3g-1
Received: by mail-wr1-f70.google.com with SMTP id r9so3663841wrs.13
        for <kvm@vger.kernel.org>; Sun, 22 Mar 2020 06:08:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=wo+FEifuRFslOR4lP0rC0Ti7Taj/A+kMlugh1DShQME=;
        b=HZeqav2hBZ4yLU6VgNXO/VWc0P1dHnkxM40HmgOP0fJ77JgGZuevgi1pQTi2Vs+snN
         /C1kAb/nSUTITPlEj7dqg6VXwPQMS+ddvEBSz7vkoKOanh6LKHNF8DfdySmA7So/uHOw
         lykTGwU1sIt/SSoSGu54SgOjy1BKCXUg+dwIqF4z4lUoxGXHZS1m/XsDtJjCGOapTgy8
         KpGTwrbWaGntX9Nmsxb/9xzoZx0LPd7Baef+fqIQBjYG9iGR3HIzuvut59S1oEuJteDu
         +c2gquf/yQB5uQHYdaVRWa/BYP9284OFdhU8Fs6ryKBlobjLu0uijm05PLFpzR1aH1o6
         72AQ==
X-Gm-Message-State: ANhLgQ3Yva7lIroutjuEtVWeeCwsXtDRXBxJMus6FgVlgCLJ0+ysYFAM
        c6rTtfjU5NdLQZ9IYrl4LRjotRD6CishhZsdUeuqXaVk3gnXUar6LNPuTD2z4JxrBt/R06q562V
        pXxb29XWnml9Y
X-Received: by 2002:adf:dd10:: with SMTP id a16mr15126892wrm.26.1584882495419;
        Sun, 22 Mar 2020 06:08:15 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vusblq6la+uuydp58U1smaFH+cEB4h83QoWWeBOqy/iybNOzxNYvMhb326r5THN16y+CJaS9A==
X-Received: by 2002:adf:dd10:: with SMTP id a16mr15126869wrm.26.1584882495224;
        Sun, 22 Mar 2020 06:08:15 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id g1sm4072755wro.28.2020.03.22.06.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2020 06:08:14 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] KVM: VMX: Fold loaded_vmcs_init() into alloc_loaded_vmcs()
In-Reply-To: <20200321193751.24985-3-sean.j.christopherson@intel.com>
References: <20200321193751.24985-1-sean.j.christopherson@intel.com> <20200321193751.24985-3-sean.j.christopherson@intel.com>
Date:   Sun, 22 Mar 2020 14:08:13 +0100
Message-ID: <87fte0bkqq.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Subsume loaded_vmcs_init() into alloc_loaded_vmcs(), its only remaining
> caller, and drop the VMCLEAR on the shadow VMCS, which is guaranteed to
> be NULL.  loaded_vmcs_init() was previously used by loaded_vmcs_clear(),
> but loaded_vmcs_clear() also subsumed loaded_vmcs_init() to properly
> handle smp_wmb() with respect to VMCLEAR.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 14 ++++----------
>  arch/x86/kvm/vmx/vmx.h |  1 -
>  2 files changed, 4 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index efaca09455bf..07634caa560d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -653,15 +653,6 @@ static int vmx_set_guest_msr(struct vcpu_vmx *vmx, struct shared_msr_entry *msr,
>  	return ret;
>  }
>  
> -void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs)
> -{
> -	vmcs_clear(loaded_vmcs->vmcs);
> -	if (loaded_vmcs->shadow_vmcs && loaded_vmcs->launched)
> -		vmcs_clear(loaded_vmcs->shadow_vmcs);
> -	loaded_vmcs->cpu = -1;
> -	loaded_vmcs->launched = 0;
> -}
> -
>  #ifdef CONFIG_KEXEC_CORE
>  static void crash_vmclear_local_loaded_vmcss(void)
>  {
> @@ -2555,9 +2546,12 @@ int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs)
>  	if (!loaded_vmcs->vmcs)
>  		return -ENOMEM;
>  
> +	vmcs_clear(loaded_vmcs->vmcs);
> +
>  	loaded_vmcs->shadow_vmcs = NULL;
>  	loaded_vmcs->hv_timer_soft_disabled = false;
> -	loaded_vmcs_init(loaded_vmcs);
> +	loaded_vmcs->cpu = -1;
> +	loaded_vmcs->launched = 0;
>  
>  	if (cpu_has_vmx_msr_bitmap()) {
>  		loaded_vmcs->msr_bitmap = (unsigned long *)
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index be93d597306c..79d38f41ef7a 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -492,7 +492,6 @@ struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags);
>  void free_vmcs(struct vmcs *vmcs);
>  int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
>  void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
> -void loaded_vmcs_init(struct loaded_vmcs *loaded_vmcs);
>  void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs);
>  
>  static inline struct vmcs *alloc_vmcs(bool shadow)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

