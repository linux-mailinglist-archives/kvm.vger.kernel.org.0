Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A584130E523
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 22:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbhBCVrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 16:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbhBCVr3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 16:47:29 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B447C0613D6
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 13:46:49 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id v19so639951pgj.12
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 13:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=EXC4BHA62oPh1DytXMv6z3tOZEILHTomqpBj4phV+a4=;
        b=BCHTnncLTmJ42YFBYuEgoCsRxxh6EAN4G/9kBKu6FH7Z+tV8WCsfZxGYPmTIGT3yLM
         e/BD+HO9lL3sqDQEcXTcCfV8wYX0gVPg1fWPTG91IOBpObWsXaI0++SiHlQkC3p3aO8S
         H39EbEpBk7vqqhmRzcSxB0hdd8RTamq6vF8Ej/MXEEAWmZZfmS32BobdsgNcGfSvG8TO
         LEZAo7HboC1XFJahd1WVRoMdfoKN6eXTdBKb8u1EMVidTEYll+IUfTEJT0vBZ1a+11Px
         CXiXO0I2h8a2lT1EHb6qd8AJjkGyAtGKXOvBERNJKL70ZMiIoUjCRX9SoaVgwMF6jCUN
         IXpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EXC4BHA62oPh1DytXMv6z3tOZEILHTomqpBj4phV+a4=;
        b=T/Cag5YFYgwDez8AmrskgKZWAXHTEBIFFvbuI9bU2qBR5sOFxNEOni6zZ4l97kcz5a
         hkHZ6MVh4E4qBKvDKAFRHGnSqkNMpFZcZ+XRScX2D8hTk+yIzdtaSE7b3luVlbeO1fsU
         H9r0znZLsDGt6MiYCZl1zOiGepAOZQPa2aQuzNVWh3x+G73ATlw+HQ1XMxkYlnEF/Nj4
         We7SMwgfioLsWBToiO7bgO7WnWqoZYn+cbu73I2EmZQoaq6XOSwyO4LFssLiEXZmRBK1
         4XczYYOrV5uu6IdsQmiak3gnO41JbXUAOLXisB6Hc9xdDeHqVxOYMAu3JPaa8oS+yNaE
         eyFw==
X-Gm-Message-State: AOAM531hjtalsvnTDL6dvB+BPl9Cwm+zjMXafPw6OlYHPp3CHxQga/bb
        7wVOWsi+rv4nfrTzSPG7V12y5A==
X-Google-Smtp-Source: ABdhPJyZcygnYHILaIWLLZ+EMseHznGhgCOD2RrjG08d9tkPLewp6gFVF56H3Awh8q8nbOvysWwlBg==
X-Received: by 2002:a65:4781:: with SMTP id e1mr5739812pgs.30.1612388808835;
        Wed, 03 Feb 2021 13:46:48 -0800 (PST)
Received: from google.com ([2620:15c:f:10:a9a0:e924:d161:b6cb])
        by smtp.gmail.com with ESMTPSA id a37sm3820669pgm.79.2021.02.03.13.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 13:46:48 -0800 (PST)
Date:   Wed, 3 Feb 2021 13:46:42 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v15 04/14] KVM: x86: Add #CP support in guest exception
 dispatch
Message-ID: <YBsZwvwhshw+s7yQ@google.com>
References: <20210203113421.5759-1-weijiang.yang@intel.com>
 <20210203113421.5759-5-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210203113421.5759-5-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 03, 2021, Yang Weijiang wrote:
> Add handling for Control Protection (#CP) exceptions, vector 21, used
> and introduced by Intel's Control-Flow Enforcement Technology (CET).
> relevant CET violation case.  See Intel's SDM for details.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/include/uapi/asm/kvm.h | 1 +
>  arch/x86/kvm/x86.c              | 1 +
>  arch/x86/kvm/x86.h              | 2 +-
>  3 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 8e76d3701db3..507263d1d0b2 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -32,6 +32,7 @@
>  #define MC_VECTOR 18
>  #define XM_VECTOR 19
>  #define VE_VECTOR 20
> +#define CP_VECTOR 21
>  
>  /* Select x86 specific features in <linux/kvm.h> */
>  #define __KVM_HAVE_PIT
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 99f787152d12..d9d3bae40a8c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -436,6 +436,7 @@ static int exception_class(int vector)
>  	case NP_VECTOR:
>  	case SS_VECTOR:
>  	case GP_VECTOR:
> +	case CP_VECTOR:
>  		return EXCPT_CONTRIBUTORY;
>  	default:
>  		break;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index c5ee0f5ce0f1..bdbd0b023ecc 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -116,7 +116,7 @@ static inline bool x86_exception_has_error_code(unsigned int vector)
>  {
>  	static u32 exception_has_error_code = BIT(DF_VECTOR) | BIT(TS_VECTOR) |
>  			BIT(NP_VECTOR) | BIT(SS_VECTOR) | BIT(GP_VECTOR) |
> -			BIT(PF_VECTOR) | BIT(AC_VECTOR);
> +			BIT(PF_VECTOR) | BIT(AC_VECTOR) | BIT(CP_VECTOR);

These need to be conditional on CET being exposed to the guest.  TBD exceptions
are non-contributory and don't have an error code.  Found when running unit
tests in L1 with a kvm/queue as L1, but an older L0.  cr4_guest_rsvd_bits can be
used to avoid guest_cpuid_has() lookups.

The SDM also gets this wrong.  Section 26.2.1.3, VM-Entry Control Fields, needs
to be updated to add #CP to the list.

  — The field's deliver-error-code bit (bit 11) is 1 if each of the following
    holds: (1) the interruption type is hardware exception; (2) bit 0
    (corresponding to CR0.PE) is set in the CR0 field in the guest-state area;
    (3) IA32_VMX_BASIC[56] is read as 0 (see Appendix A.1); and (4) the vector
    indicates one of the following exceptions: #DF (vector 8), #TS (10),
    #NP (11), #SS (12), #GP (13), #PF (14), or #AC (17).

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index dbca1687ae8e..0b6dab6915a3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2811,7 +2811,7 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
                /* VM-entry interruption-info field: deliver error code */
                should_have_error_code =
                        intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
-                       x86_exception_has_error_code(vector);
+                       x86_exception_has_error_code(vcpu, vector);
                if (CC(has_error_code != should_have_error_code))
                        return -EINVAL;

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 28fea7ff7a86..0288d6a364bd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -437,17 +437,20 @@ EXPORT_SYMBOL_GPL(kvm_spurious_fault);
 #define EXCPT_CONTRIBUTORY     1
 #define EXCPT_PF               2

-static int exception_class(int vector)
+static int exception_class(struct kvm_vcpu *vcpu, int vector)
 {
        switch (vector) {
        case PF_VECTOR:
                return EXCPT_PF;
+       case CP_VECTOR:
+               if (vcpu->arch.cr4_guest_rsvd_bits & X86_CR4_CET)
+                       return EXCPT_BENIGN;
+               return EXCPT_CONTRIBUTORY;
        case DE_VECTOR:
        case TS_VECTOR:
        case NP_VECTOR:
        case SS_VECTOR:
        case GP_VECTOR:
-       case CP_VECTOR:
                return EXCPT_CONTRIBUTORY;
        default:
                break;
@@ -588,8 +591,8 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
                kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
                return;
        }
-       class1 = exception_class(prev_nr);
-       class2 = exception_class(nr);
+       class1 = exception_class(vcpu, prev_nr);
+       class2 = exception_class(vcpu, nr);
        if ((class1 == EXCPT_CONTRIBUTORY && class2 == EXCPT_CONTRIBUTORY)
                || (class1 == EXCPT_PF && class2 != EXCPT_BENIGN)) {
                /*
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index a14da36a30ed..dce756ffb577 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -120,12 +120,16 @@ static inline bool is_la57_mode(struct kvm_vcpu *vcpu)
 #endif
 }

-static inline bool x86_exception_has_error_code(unsigned int vector)
+static inline bool x86_exception_has_error_code(struct kvm_vcpu *vcpu,
+                                               unsigned int vector)
 {
        static u32 exception_has_error_code = BIT(DF_VECTOR) | BIT(TS_VECTOR) |
                        BIT(NP_VECTOR) | BIT(SS_VECTOR) | BIT(GP_VECTOR) |
                        BIT(PF_VECTOR) | BIT(AC_VECTOR) | BIT(CP_VECTOR);

+       if (vector == CP_VECTOR && (vcpu->arch.cr4_guest_rsvd_bits & X86_CR4_CET))
+               return false;
+
        return (1U << vector) & exception_has_error_code;
 }




