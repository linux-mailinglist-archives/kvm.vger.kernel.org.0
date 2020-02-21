Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC51167E7B
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 14:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgBUN0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 08:26:54 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25808 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727053AbgBUN0v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Feb 2020 08:26:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582291609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pp52uql4euz6sc9/tpF3BoUO1r84mKC2NqpqrjvTgCE=;
        b=ht15uYttCA70vhyz6GJezZ8yIhy6w+7SbNuKFOGJJkK3o7Kj6UYUSaHA05/XThEpt+RPyj
        Piq+LwqTX7vLcMQJeJmHj2KRkBFFnmV/xsL49Gv+2dRulpHyOvtiFMDC8MMq3CXX2RlgMU
        sfVFLwupqFu1t5Mw1me/xPAtiT8d0ws=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-ZYhr4KfQP32HiyA-IzvWFA-1; Fri, 21 Feb 2020 08:26:47 -0500
X-MC-Unique: ZYhr4KfQP32HiyA-IzvWFA-1
Received: by mail-wm1-f72.google.com with SMTP id m4so570670wmi.5
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 05:26:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=pp52uql4euz6sc9/tpF3BoUO1r84mKC2NqpqrjvTgCE=;
        b=JjdZRf3zWxJP03lJ938/1qbxEcHGh3e2OTsyVbYPynuY3eiZUuajxOQY+G+LVPWpJ3
         d7mp/EqlYUhoZ9xBs2R1o8zjMrajxXTGq4/wta4joOBx8/NrJdKgGHP2rrz/8m8NCoS1
         4E8Fh2nWyFv5FXcFw9B0whWT9+EmB+5bwYLtAgmcOh82toggpaJz+haGHZ6Ol5ksmD2x
         wgfchuRW3/Yg5QNSSUi93+s4p97LOnfiSt6lUuVqVGwM3wV4BkRFCMIipJV+OyX0DuLj
         EkByDX1yAydgkbX/6NzyhNF4vp7F9NBULLAxx5LWqy+mHndx+T0+KayjOF2T98N49RkQ
         eFjQ==
X-Gm-Message-State: APjAAAWnGaRj8dQ6QRaKoIKghISttBaVxIDcyKA59H9O+jeZd7j399V1
        xeM9XQLj0ZAJGZg8HR44IyP//QbHdC0F7DfXTRMcOFu8jR41CeYErTOKsfM08SzpzuQFuoSW5D2
        TBVmE9sfVFKSx
X-Received: by 2002:a1c:b0c3:: with SMTP id z186mr3858294wme.36.1582291606598;
        Fri, 21 Feb 2020 05:26:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqzxbF95OXsrWyungR3AunMn453gY9WbnEXGRp+W3FBe+YdiQTXfHAprgJwrb8V0Wwn3+8m1hA==
X-Received: by 2002:a1c:b0c3:: with SMTP id z186mr3858273wme.36.1582291606366;
        Fri, 21 Feb 2020 05:26:46 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id b17sm4095785wrp.49.2020.02.21.05.26.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 05:26:45 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] KVM: VMX: Handle INVVPID fallback logic in vpid_sync_vcpu_addr()
In-Reply-To: <20200220204356.8837-4-sean.j.christopherson@intel.com>
References: <20200220204356.8837-1-sean.j.christopherson@intel.com> <20200220204356.8837-4-sean.j.christopherson@intel.com>
Date:   Fri, 21 Feb 2020 14:26:45 +0100
Message-ID: <8736b4t6ju.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Directly invoke vpid_sync_context() to do a global INVVPID when the
> individual address variant is not supported instead of deferring such
> behavior to the caller.  This allows for additional consolidation of
> code as the logic is basically identical to the emulation of the
> individual address variant in handle_invvpid().
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/ops.h | 12 +++++-------
>  arch/x86/kvm/vmx/vmx.c |  3 +--
>  2 files changed, 6 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/ops.h b/arch/x86/kvm/vmx/ops.h
> index a2b0689e65e3..612df1bdb26b 100644
> --- a/arch/x86/kvm/vmx/ops.h
> +++ b/arch/x86/kvm/vmx/ops.h
> @@ -276,17 +276,15 @@ static inline void vpid_sync_context(int vpid)
>  		vpid_sync_vcpu_global();
>  }
>  
> -static inline bool vpid_sync_vcpu_addr(int vpid, gva_t addr)
> +static inline void vpid_sync_vcpu_addr(int vpid, gva_t addr)
>  {
>  	if (vpid == 0)
> -		return true;
> +		return;
>  
> -	if (cpu_has_vmx_invvpid_individual_addr()) {
> +	if (cpu_has_vmx_invvpid_individual_addr())
>  		__invvpid(VMX_VPID_EXTENT_INDIVIDUAL_ADDR, vpid, addr);
> -		return true;
> -	}
> -
> -	return false;
> +	else
> +		vpid_sync_context(vpid);
>  }
>  
>  static inline void ept_sync_global(void)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9a6664886f2e..349a6e054e0e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2826,8 +2826,7 @@ static void vmx_flush_tlb_gva(struct kvm_vcpu *vcpu, gva_t addr)
>  {
>  	int vpid = to_vmx(vcpu)->vpid;
>  
> -	if (!vpid_sync_vcpu_addr(vpid, addr))
> -		vpid_sync_context(vpid);
> +	vpid_sync_vcpu_addr(vpid, addr);
>  
>  	/*
>  	 * If VPIDs are not supported or enabled, then the above is a no-op.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

