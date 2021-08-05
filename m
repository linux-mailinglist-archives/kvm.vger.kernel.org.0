Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23CA3E1EC3
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 00:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239154AbhHEWdU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 18:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbhHEWdQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Aug 2021 18:33:16 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF94C0613D5
        for <kvm@vger.kernel.org>; Thu,  5 Aug 2021 15:33:01 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id l19so12571589pjz.0
        for <kvm@vger.kernel.org>; Thu, 05 Aug 2021 15:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dhXk37eFC15pZKelOTmIoz91X3bzOOO01NaZQtp+pC0=;
        b=ajPRBLJkLHrlBjvvz7qW4niZDr0o3O4uy8cuF/Qa0I69yg6wp1RTWapwcaDOuVqv1A
         XSrw6E1Fd/rWKvnNwUY1gVxa7oExBRB45ozwUBE9YyCb9GoSwGEiKPz86155Or4mAMUi
         IB8yDX+WCefwKsxMXsEAF6T+s+wg3nQsEO4TVznBUEUxRPbsXhsLD88QzzK8ris5TPAR
         dRptKgrdBaYLdWXuNXhKZ2w+vHtA2B3pWlinOzxeOpUBB9n9ffNHozuT04krg8rOJxJS
         57EdyBwidZYhCiw2GhjG0DAZxS2B+sTyPdH6GB83CcKxWRBY8/yJYNuof2IUbiRx1Af0
         m5FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dhXk37eFC15pZKelOTmIoz91X3bzOOO01NaZQtp+pC0=;
        b=gmzulyKmyL9AKQ+47JsJNhucF5W6OTlBj332aJpbsPYUt2tqAXJZp/anY7gUfYt3JT
         iFPHPlJvt17+RaEapzboCyI8wDr5xNCTcA6AJw63BeGhlOIeSjX19LBkoYPRiCHQzlUG
         rZKTBBzkCD75P6/XAAnQ4KLVlWbD47hw7Cy6Bqo7SmkKUcbCwMMvI6d02JOV9VrShaDt
         b5M18j1Xt461lVfYStdQRn+erk6cBduBspwH+xslDuWGEBUOpdwCxuEEl6R21mwTf1ei
         OU3gZMylk1ETimZMEZnV2eVPn1jORotETBd0DgrkKnRwvp5zQi7YwCIc4l0gIa+NxC/X
         5/6Q==
X-Gm-Message-State: AOAM533iSqTi5vz33PsL9zPpAK1gdYlyTMMtSTDHep2hALfZpE78ZJAi
        QFgJCoP2JQLrdAmtb0kMs5pPdsKd2QvB5A==
X-Google-Smtp-Source: ABdhPJzFiCwBTBptI/4xg1FauXtCo55lGOg5JCiA28mQCJsWk8h1ajuQt+NG6YmnQFKlgsV4Js2KxQ==
X-Received: by 2002:a17:90a:d985:: with SMTP id d5mr6879897pjv.12.1628202780753;
        Thu, 05 Aug 2021 15:33:00 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u16sm9284456pgh.53.2021.08.05.15.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 15:33:00 -0700 (PDT)
Date:   Thu, 5 Aug 2021 22:32:56 +0000
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
Subject: Re: [PATCH v3 2/6] KVM: VMX: Extend BUILD_CONTROLS_SHADOW macro to
 support 64-bit variation
Message-ID: <YQxnGIT7XLQvPkrz@google.com>
References: <20210805151317.19054-1-guang.zeng@intel.com>
 <20210805151317.19054-3-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805151317.19054-3-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 05, 2021, Zeng Guang wrote:
> From: Robert Hoo <robert.hu@linux.intel.com>
> 
> The Tertiary VM-Exec Control, different from previous control fields, is 64
> bit. So extend BUILD_CONTROLS_SHADOW() by adding a 'bit' parameter, to
> support both 32 bit and 64 bit fields' auxiliary functions building.
> Also, define the auxiliary functions for Tertiary control field here, using
> the new BUILD_CONTROLS_SHADOW().
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.h | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 3979a947933a..945c6639ce24 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -413,31 +413,32 @@ static inline u8 vmx_get_rvi(void)
>  	return vmcs_read16(GUEST_INTR_STATUS) & 0xff;
>  }
>  
> -#define BUILD_CONTROLS_SHADOW(lname, uname)				    \
> -static inline void lname##_controls_set(struct vcpu_vmx *vmx, u32 val)	    \
> +#define BUILD_CONTROLS_SHADOW(lname, uname, bits)			    \
> +static inline void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val) \

Align the trailing backslashes (with tabs when possible).  It's a lot of unfortunate
churn, but it really does make the code easier to read.  An alternative is to split
"static inline" to a separate line.

>  {									    \
>  	if (vmx->loaded_vmcs->controls_shadow.lname != val) {		    \
> -		vmcs_write32(uname, val);				    \
> +		vmcs_write##bits(uname, val);				    \
>  		vmx->loaded_vmcs->controls_shadow.lname = val;		    \
>  	}								    \
>  }									    \
> -static inline u32 lname##_controls_get(struct vcpu_vmx *vmx)		    \
> +static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)	    \
>  {									    \
>  	return vmx->loaded_vmcs->controls_shadow.lname;			    \
>  }									    \
> -static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u32 val)   \
> +static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u##bits val)   \
>  {									    \
>  	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);	    \
>  }									    \
> -static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u32 val) \
> +static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##bits val) \
>  {									    \
>  	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);	    \
>  }
> -BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS)
> -BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS)
> -BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL)
> -BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL)
> -BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL)
> +BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS, 32)
> +BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS, 32)
> +BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL, 32)
> +BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL, 32)
> +BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL, 32)
> +BUILD_CONTROLS_SHADOW(tertiary_exec, TERTIARY_VM_EXEC_CONTROL, 64)

This fails to compile because all the TERTIARY collateral is in a later patch.

I think I'd also prefer hiding the 32/64 param via more macros, e.g.

#define __BUILD_CONTROLS_SHADOW(lname, uname, bits)				\
static inline void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val)	\
{										\
	if (vmx->loaded_vmcs->controls_shadow.lname != val) {			\
		vmcs_write##bits(uname, val);					\
		vmx->loaded_vmcs->controls_shadow.lname = val;			\
	}									\
}										\
static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)		\
{										\
	return vmx->loaded_vmcs->controls_shadow.lname;				\
}										\
static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u##bits val)	\
{										\
	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);		\
}										\
static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##bits val)	\
{										\
	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);		\
}
#define BUILD_CONTROLS_SHADOW(lname, uname)   __BUILD_CONTROLS_SHADOW(lname, uname, 32)
#define BUILD_CONTROLS_SHADOW64(lname, uname) __BUILD_CONTROLS_SHADOW(lname, uname, 64)
