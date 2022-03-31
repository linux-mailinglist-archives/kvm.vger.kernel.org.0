Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FEF4EE477
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 01:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242818AbiCaXJa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 19:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242805AbiCaXJ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 19:09:27 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AA424CED6
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 16:07:35 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id p4-20020a17090ad30400b001c7ca87c05bso3710103pju.1
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 16:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qRJmN8JDG7m72p3VxsXuKnTc88XHvYZJpC/RFCon9dM=;
        b=aMwVbgfWGFLicig1gsSp/2jhSdYkiuTO1sd60UIlMKfjmpZpl5LkWpSarIu7YDUBU3
         rpmb+z7cl8bVsE19t3bKrk/98bKoakg/taFBzWkzbIDxIrhfdDPDGXS3V+Vxe1xURGWj
         WvuJItBvoHNgb2dsWSoRjyDQPEqWuMfS+HSKacI4VjKVxZOhbhF5tnw4zTQlVzNT70vu
         5QhsS41hLl//IjuCrBUqLumqai/xWHvj59KY2P8a6gCRhTmEtmSpKeph2yaiiH/rJ0Dt
         C7UsXmnOaK5uHBz8v+8ZT3DQyJxB9hIkbE9e/9Blb8rqFnm+zzLheVrYV4gTl5EtIqTU
         yMDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qRJmN8JDG7m72p3VxsXuKnTc88XHvYZJpC/RFCon9dM=;
        b=Q5aaiLDejpHFINiurzPARJiLHWkLWdGX7U50d2iar9IVumTy/+gVAg+RXHactXVukN
         bc36YuyxVQN3T45ja7ymRjXNSOJRFXvr0iHHiH2ql/WIchzyMH9RJ7W/obKDOso3xT+P
         GRYbyX78GR/OubSksYJGEQW9H6FRaUNA6XnrVJUA3yi24I4cvhKoYt27vZYkcQBNqqxs
         cL1pg80umSiR1+MT6GbzPJ/83Kt217kqf1eltgSOTX/B72SoH1l2MbdqI0ZX5dI2d0U3
         QYh1z+aZ0bIK3CyustpdNu1L3cNIPGtVdrNiq2D4+gZm4N9MwkH9ofRmtaMDj5f6EilT
         DOzw==
X-Gm-Message-State: AOAM532BZW2uGntyHTJrAjXWwNEef9mcDXR1KD3UKYsERZ1416idNAO2
        RZllXAxhWLL8/pOocAdhGZrUag==
X-Google-Smtp-Source: ABdhPJwcvMMyYOYWUXp6ynrxs98Tajw+xE+iCgBuHmT4zvMeroO3/+V6AvYJmeHor1eycxWFbkpIew==
X-Received: by 2002:a17:903:124a:b0:154:c7a4:9374 with SMTP id u10-20020a170903124a00b00154c7a49374mr7673970plh.68.1648768054442;
        Thu, 31 Mar 2022 16:07:34 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s10-20020a056a00178a00b004fda49fb25dsm552215pfg.9.2022.03.31.16.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 16:07:33 -0700 (PDT)
Date:   Thu, 31 Mar 2022 23:07:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>
Subject: Re: [PATCH v7 5/8] KVM: x86: Add support for vICR APIC-write
 VM-Exits in x2APIC mode
Message-ID: <YkY0MvAIPiISfk4u@google.com>
References: <20220304080725.18135-1-guang.zeng@intel.com>
 <20220304080725.18135-6-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304080725.18135-6-guang.zeng@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 04, 2022, Zeng Guang wrote:
> Upcoming Intel CPUs will support virtual x2APIC MSR writes to the vICR,
> i.e. will trap and generate an APIC-write VM-Exit instead of intercepting
> the WRMSR.  Add support for handling "nodecode" x2APIC writes, which
> were previously impossible.
> 
> Note, x2APIC MSR writes are 64 bits wide.
> 
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> ---
>  arch/x86/kvm/lapic.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 629c116b0d3e..22929b5b3f9b 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -67,6 +67,7 @@ static bool lapic_timer_advance_dynamic __read_mostly;
>  #define LAPIC_TIMER_ADVANCE_NS_MAX     5000
>  /* step-by-step approximation to mitigate fluctuation */
>  #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
> +static int kvm_lapic_msr_read(struct kvm_lapic *apic, u32 reg, u64 *data);
>  
>  static inline void __kvm_lapic_set_reg(char *regs, int reg_off, u32 val)
>  {
> @@ -2227,10 +2228,25 @@ EXPORT_SYMBOL_GPL(kvm_lapic_set_eoi);
>  /* emulate APIC access in a trap manner */
>  void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
>  {
> -	u32 val = kvm_lapic_get_reg(vcpu->arch.apic, offset);
> +	struct kvm_lapic *apic = vcpu->arch.apic;
> +	u64 val;
> +
> +	if (apic_x2apic_mode(apic)) {
> +		/*
> +		 * When guest APIC is in x2APIC mode and IPI virtualization
> +		 * is enabled, accessing APIC_ICR may cause trap-like VM-exit
> +		 * on Intel hardware. Other offsets are not possible.
> +		 */
> +		if (WARN_ON_ONCE(offset != APIC_ICR))
> +			return;
>  
> -	/* TODO: optimize to just emulate side effect w/o one more write */
> -	kvm_lapic_reg_write(vcpu->arch.apic, offset, val);
> +		kvm_lapic_msr_read(apic, offset, &val);
> +		kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));

This needs to clear the APIC_ICR_BUSY bit.  It'd also be nice to trace this write.
The easiest thing is to use kvm_x2apic_icr_write().  Kinda silly as it'll generate
an extra write, but on the plus side the TODO comment doesn't have to move :-D

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index c4c3155d98db..58bf296ee313 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2230,6 +2230,7 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
        struct kvm_lapic *apic = vcpu->arch.apic;
        u64 val;

+       /* TODO: optimize to just emulate side effect w/o one more write */
        if (apic_x2apic_mode(apic)) {
                /*
                 * When guest APIC is in x2APIC mode and IPI virtualization
@@ -2240,10 +2241,9 @@ void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
                        return;

                kvm_lapic_msr_read(apic, offset, &val);
-               kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
+               kvm_x2apic_icr_write(apic, val);
        } else {
                val = kvm_lapic_get_reg(apic, offset);
-               /* TODO: optimize to just emulate side effect w/o one more write */
                kvm_lapic_reg_write(apic, offset, (u32)val);
        }
 }


> +	} else {
> +		val = kvm_lapic_get_reg(apic, offset);
> +		/* TODO: optimize to just emulate side effect w/o one more write */
> +		kvm_lapic_reg_write(apic, offset, (u32)val);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(kvm_apic_write_nodecode);
>  
> -- 
> 2.27.0
> 
