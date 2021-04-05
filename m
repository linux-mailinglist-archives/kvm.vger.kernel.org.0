Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F24354383
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 17:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238513AbhDEPir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 11:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238086AbhDEPiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Apr 2021 11:38:46 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8BEC061756
        for <kvm@vger.kernel.org>; Mon,  5 Apr 2021 08:38:39 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso6037873pjb.3
        for <kvm@vger.kernel.org>; Mon, 05 Apr 2021 08:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mqIlwFOOOA0vcSzb6hHnC7YZ/6X4ZhlgnjWsfjUkLKQ=;
        b=hDoWOz1VNgLo+jKfgiuyBFcOHAVoIaMb4BXjV0GIxRfdZXR/Zfv1pgQwx8WcM5hH9d
         LP0ZPI0UB3ErHezup9baPZgbjNh7u1DFBFtOXCe1/vCdHmw7KLZyxHzjEja/OzknMrnv
         xZhxpNxamtrG6i3EzofyGOonNd5R/hdgcjeuW+BorA6IQ5Jl5MlmNSxb0C/gSOrqY9Ir
         Vo2xnmvwnfvjSm4GxXtirNwP1yTWLOndGd3YyRqgwfwt+Od76HPanSddFdU6vKH87E18
         ajhU6gshiTBCwj9DaGVWFqO+a+GO+cFO8zBBgOYzbUoUlOhD3pfziRiwYAGszhXpAULE
         gtCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mqIlwFOOOA0vcSzb6hHnC7YZ/6X4ZhlgnjWsfjUkLKQ=;
        b=rk4+ZYxZCiPTY+lCeLn7s3B8yQPRnMOUOR4mYhGBFVFkaPHmV2UIaKwUS8R24LZPN8
         5jyBhtKr9oQAa3vgMHzC8LwVYVa0xxedx2N8WY6Y4u7+a7el2sKE7nLfZ+EN9ruXz5ok
         VROnPqQkP6W32AK+YXaH38xcYWZeKuqZpNh2r6S/MvIF9kgS1xLCQMJAlTtdYTpWZCGh
         1udQvJwXttGoWSMLbhRfxzWzr4QfFxNg8XxxLg64Vd9s6KjAiiYUNIRlNwSjJXOg97RF
         qNaj2TBvAi/8hZaSDzFtT0TSH00V2LYbYqNk+ImxC3vkZtgsQ2KTy+KjZBKeh610kr4z
         hkag==
X-Gm-Message-State: AOAM531+xl2ZqHe45/inqJ7Fo/o/XIXMJ3dVXWube6dH06mlTSweNvI/
        GWwfIBkpigIr6dT/niohfFIKPw==
X-Google-Smtp-Source: ABdhPJz6v+rY+iAdCFqJyZoJKCRZbLXujL4ctHMEuJ6RJF7v6IP76tlhijpT1qGpGyA8aY6IH+Kiqg==
X-Received: by 2002:a17:90a:86c2:: with SMTP id y2mr7000546pjv.164.1617637118368;
        Mon, 05 Apr 2021 08:38:38 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id e6sm9376514pgm.92.2021.04.05.08.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 08:38:37 -0700 (PDT)
Date:   Mon, 5 Apr 2021 15:38:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, chang.seok.bae@intel.com,
        kvm@vger.kernel.org, robert.hu@intel.com
Subject: Re: [RFC PATCH 03/12] kvm/vmx: Introduce the new tertiary
 processor-based VM-execution controls
Message-ID: <YGsu+ckrwEsZSUoN@google.com>
References: <1611565580-47718-1-git-send-email-robert.hu@linux.intel.com>
 <1611565580-47718-4-git-send-email-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1611565580-47718-4-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 25, 2021, Robert Hoo wrote:
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index f6f66e5..94f1c27 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -373,6 +373,14 @@ static inline u8 vmx_get_rvi(void)
>  BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL)
>  BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL)
>  
> +static inline void tertiary_exec_controls_set(struct vcpu_vmx *vmx, u64 val)
> +{
> +	if (vmx->loaded_vmcs->controls_shadow.tertiary_exec != val) {
> +		vmcs_write64(TERTIARY_VM_EXEC_CONTROL, val);
> +		vmx->loaded_vmcs->controls_shadow.tertiary_exec = val;
> +	}
> +}

Add a "bits" param to the builder macros and use string concatenation, then the
tertiary controls can share those macros.

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 7886a08505cc..328039157535 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -398,25 +398,25 @@ static inline u8 vmx_get_rvi(void)
        return vmcs_read16(GUEST_INTR_STATUS) & 0xff;
 }

-#define BUILD_CONTROLS_SHADOW(lname, uname)                                \
-static inline void lname##_controls_set(struct vcpu_vmx *vmx, u32 val)     \
-{                                                                          \
-       if (vmx->loaded_vmcs->controls_shadow.lname != val) {               \
-               vmcs_write32(uname, val);                                   \
-               vmx->loaded_vmcs->controls_shadow.lname = val;              \
-       }                                                                   \
-}                                                                          \
-static inline u32 lname##_controls_get(struct vcpu_vmx *vmx)               \
-{                                                                          \
-       return vmx->loaded_vmcs->controls_shadow.lname;                     \
-}                                                                          \
-static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u32 val)   \
-{                                                                          \
-       lname##_controls_set(vmx, lname##_controls_get(vmx) | val);         \
-}                                                                          \
-static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u32 val) \
-{                                                                          \
-       lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);        \
+#define BUILD_CONTROLS_SHADOW(lname, uname, bits)                              \
+static inline void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val)     \
+{                                                                              \
+       if (vmx->loaded_vmcs->controls_shadow.lname != val) {                   \
+               vmcs_write##bits(uname, val);                                   \
+               vmx->loaded_vmcs->controls_shadow.lname = val;                  \
+       }                                                                       \
+}                                                                              \
+static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)               \
+{                                                                              \
+       return vmx->loaded_vmcs->controls_shadow.lname;                         \
+}                                                                              \
+static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u##bits val)  \
+{                                                                              \
+       lname##_controls_set(vmx, lname##_controls_get(vmx) | val);             \
+}                                                                              \
+static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##bits val)        \
+{                                                                              \
+       lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);            \
 }
 BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS)
 BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS)

> +
>  static inline void vmx_register_cache_reset(struct kvm_vcpu *vcpu)
>  {
>  	vcpu->arch.regs_avail = ~((1 << VCPU_REGS_RIP) | (1 << VCPU_REGS_RSP)
> -- 
> 1.8.3.1
> 
