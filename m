Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D39D348DF5A
	for <lists+kvm@lfdr.de>; Thu, 13 Jan 2022 22:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234818AbiAMVDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 16:03:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234794AbiAMVDu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 16:03:50 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6F5C061574
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 13:03:50 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id x20so959391pgk.1
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 13:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Tf1MJf6G2L7udqFNeyVKsBEheXd/tBNophjVUNr0QVo=;
        b=DeQodgOHBqWkgcKGoBpIkzq3Rxnr4OG1z4IS+qgaflCyJUTYyUSaA64hl9hI+tKJqB
         u2jYnP8pn0xJ7sBp3f8EfjJYKFEhWUerIBDY5/2slyHYfOLqCFriEyGpQOcb8Dn0kJFT
         +Jo331nwAqEOGAxi9kgQKUzh5oEBvCOoiHEwFMTNGUIpqlmMKki7jTabKs1Fir6h5aHU
         cRUSJqlC1FvWpRoyifPd6sujgNaHrOjuniP2fMwCZqQRObnYEbaePhW6Cus/WyvyZkGF
         sqk5ztNWZvuSGnsDODN6LvEPitJ2SxCEmi+wdFMRsjnh3G3HsweQELMmGZ1NOfx6TZki
         aRKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Tf1MJf6G2L7udqFNeyVKsBEheXd/tBNophjVUNr0QVo=;
        b=tBxd9mTnZgtJgs37k9gnx1YurvIKJhFpzGX8K0nSWPgK4H77PYd/Ekb4Z/DE20SMTp
         x+AE0wonQ14iv/wT0HJ47yxKXP3D4CtUJD6pT9iz7rl2jtSHXRzkOREusaW2OFgyct84
         LmTIPwO+xr1jC/4P6M0HJMOIA1INPm5W2x5Dqd/uCkMBVJVWi1qgdsF536kkBCQyYc2I
         5mt5WCEzPZPoUjMlOqzpgYkWuFGlBOvUDsT7OZoiun19xVxswhfUWDs2odly0n6kuih+
         d2OkRQprmuoPER3yBQSaxKz6Y2xsdRYLonblSl31CLHY2hx6+VThLrNUrivhzgZWq9B4
         AzwQ==
X-Gm-Message-State: AOAM533fAy4o9CaPuDfqdv/HEgGTwRVDK5qUNW773SpP5eHVJjTgkra/
        afm8TSNO5OCEmsjzY0X74BKEng==
X-Google-Smtp-Source: ABdhPJzQ+lbF4Ngarff0hCewsh2F0/UOv1xny5L70zC8QKcPqQdmFzCrzJo0x6NSN9juSeEhSwE74g==
X-Received: by 2002:a62:33c7:0:b0:4bd:5aa4:1220 with SMTP id z190-20020a6233c7000000b004bd5aa41220mr5864708pfz.55.1642107829603;
        Thu, 13 Jan 2022 13:03:49 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h5sm3419529pfo.57.2022.01.13.13.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 13:03:49 -0800 (PST)
Date:   Thu, 13 Jan 2022 21:03:45 +0000
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
        Gao Chao <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: Re: [PATCH v5 4/8] KVM: VMX: dump_vmcs() reports
 tertiary_exec_control field as well
Message-ID: <YeCTsVCwEkT2N6kQ@google.com>
References: <20211231142849.611-1-guang.zeng@intel.com>
 <20211231142849.611-5-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211231142849.611-5-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 31, 2021, Zeng Guang wrote:
> From: Robert Hoo <robert.hu@linux.intel.com>
> 
> Add tertiary_exec_control field report in dump_vmcs()
> 
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index fb0f600368c6..5716db9704c0 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5729,6 +5729,7 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	u32 vmentry_ctl, vmexit_ctl;
>  	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
> +	u64 tertiary_exec_control = 0;
>  	unsigned long cr4;
>  	int efer_slot;
>  
> @@ -5746,6 +5747,9 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>  	if (cpu_has_secondary_exec_ctrls())
>  		secondary_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);

Gah, this (not your) code is silly.  I had to go look at the full source to see
that secondary_exec_control isn't accessed uninitialized...

Can you opportunistically tweak it to the below, and use the same patter for the
tertiary controls?

	if (cpu_has_secondary_exec_ctrls())
		secondary_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
	else
		secondary_exec_control = 0;

>  
> +	if (cpu_has_tertiary_exec_ctrls())
> +		tertiary_exec_control = vmcs_read64(TERTIARY_VM_EXEC_CONTROL);
> +
>  	pr_err("VMCS %p, last attempted VM-entry on CPU %d\n",
>  	       vmx->loaded_vmcs->vmcs, vcpu->arch.last_vmentry_cpu);
>  	pr_err("*** Guest State ***\n");
> @@ -5844,8 +5848,9 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>  		vmx_dump_msrs("host autoload", &vmx->msr_autoload.host);
>  
>  	pr_err("*** Control State ***\n");
> -	pr_err("PinBased=%08x CPUBased=%08x SecondaryExec=%08x\n",
> -	       pin_based_exec_ctrl, cpu_based_exec_ctrl, secondary_exec_control);
> +	pr_err("PinBased=0x%08x CPUBased=0x%08x SecondaryExec=0x%08x TertiaryExec=0x%016llx\n",
> +	       pin_based_exec_ctrl, cpu_based_exec_ctrl, secondary_exec_control,
> +	       tertiary_exec_control);

Can you provide a sample dump?  It's hard to visualize the output, e.g. I'm worried
this will be overly log and harder to read than putting tertiary controls on their
own line.

>  	pr_err("EntryControls=%08x ExitControls=%08x\n", vmentry_ctl, vmexit_ctl);
>  	pr_err("ExceptionBitmap=%08x PFECmask=%08x PFECmatch=%08x\n",
>  	       vmcs_read32(EXCEPTION_BITMAP),
> -- 
> 2.27.0
> 
