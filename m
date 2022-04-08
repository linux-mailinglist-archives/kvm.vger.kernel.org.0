Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209054F9AE8
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 18:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbiDHQsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 12:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiDHQsO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 12:48:14 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B19A1DA5E
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 09:46:10 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso12411496pju.1
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 09:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KjGzlPUuopnzOxDb70wPeYUUzIj9x1BrlBL7vAL3tEU=;
        b=nMUAsD6DVHxasPy+bHqB5yAyTxDamuiDmy7FuYy+5YCzQjXg5KrVCglUnu2RwZ7wDO
         VgUgFHdgmXbomd+tDzupYzwVUMcDOVfbohBWX9cbf33EaAI/OEasRPiFIV29b9A/408p
         2jRsSnMB7pf4mlzcGNKqGnI3PhClL5e7SL0+4o1nYt+weKwj+NG7sKlMDs81oppC4S/E
         k0camdZClD+mxlZhX4kfxSCiK2oUXQjXyYylESC/QLV8+g+NBBGzKbRkl11spdr/Vv6s
         DQuKmHtidbNWwSr/KLU7DGMxB64gp1TbS36mA++3AuZGeCdYhVDfkX7yS5eSKLmWgwbG
         spmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KjGzlPUuopnzOxDb70wPeYUUzIj9x1BrlBL7vAL3tEU=;
        b=K8UpKrlxkFA72Q9nU4U5D+yTMsxpP6Hk+Kf9pUG/UMlknozBZYQ4ia1AuqXComL0kp
         HCYV5+zSLSrUG546q+Jhy3hRHfLP+p6WQsmovuK8+A0kvuO+NsTnS3IMPzn9Se3GgJwH
         JTCFXv4H3NDhZcuZ3LTBcxb0t8tLLxnyUEus6EYY+Q2wA8EY4tpawng75FZOevko8Y9g
         wK1LrqnM+GLSHijtcu22R1jXbLMkeZzWA+1IQ+uAlX4YZI/8iiHfFKTVoUeJ8KkRxjYo
         A9BIxQSskfj4rrncNc5lEzw5gyM41fTud53aV3QYJszc/DPcdn5Vjx9QgMNIeUUvtblx
         +VBw==
X-Gm-Message-State: AOAM530vIS7YGhwv+uUv46beKdiIAKVNAA2UzdfNrf2giQC2XvAnQ96q
        QVuCc2wvLUBbCEt56GL0BgyQDg==
X-Google-Smtp-Source: ABdhPJz0iwytqOS32LIa00b7FHRew+z1BX9zsSQNqylpLVDQVJoWyNnMedQm0cD5GiqNLfHfoAXT5Q==
X-Received: by 2002:a17:902:f649:b0:156:1609:79e9 with SMTP id m9-20020a170902f64900b00156160979e9mr20434203plg.69.1649436369344;
        Fri, 08 Apr 2022 09:46:09 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d16-20020a056a00245000b004f771b48736sm28031213pfj.194.2022.04.08.09.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 09:46:08 -0700 (PDT)
Date:   Fri, 8 Apr 2022 16:46:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>
Subject: Re: [RFC PATCH v5 003/104] KVM: TDX: Detect CPU feature on kernel
 module initialization
Message-ID: <YlBmzDcYdahXzSue@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <70201fd686c6cc6e03f5af8a9f59af67bdc81194.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70201fd686c6cc6e03f5af8a9f59af67bdc81194.1646422845.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 04, 2022, isaku.yamahata@intel.com wrote:
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> new file mode 100644
> index 000000000000..1acf08c310c4
> --- /dev/null
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -0,0 +1,53 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/cpu.h>
> +
> +#include <asm/tdx.h>
> +
> +#include "capabilities.h"
> +#include "x86_ops.h"
> +
> +#undef pr_fmt
> +#define pr_fmt(fmt) "tdx: " fmt
> +
> +static bool __read_mostly enable_tdx = true;
> +module_param_named(tdx, enable_tdx, bool, 0644);

This is comically unsafe, userspace must not be allowed to toggle enable_tdx
after KVM is loaded.

> +static u64 hkid_mask __ro_after_init;
> +static u8 hkid_start_pos __ro_after_init;
> +
> +static int __init __tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> +{
> +	u32 max_pa;
> +
> +	if (!enable_ept) {
> +		pr_warn("Cannot enable TDX with EPT disabled\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!platform_has_tdx()) {
> +		pr_warn("Cannot enable TDX with SEAMRR disabled\n");
> +		return -ENODEV;
> +	}
> +
> +	if (WARN_ON_ONCE(x86_ops->tlb_remote_flush))
> +		return -EIO;
> +
> +	max_pa = cpuid_eax(0x80000008) & 0xff;
> +	hkid_start_pos = boot_cpu_data.x86_phys_bits;
> +	hkid_mask = GENMASK_ULL(max_pa - 1, hkid_start_pos);
> +
> +	return 0;
> +}
> +
> +void __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> +{
> +	/*
> +	 * This function is called at the initialization.  No need to protect
> +	 * enable_tdx.
> +	 */
> +	if (!enable_tdx)
> +		return;
> +
> +	if (__tdx_hardware_setup(&vt_x86_ops))
> +		enable_tdx = false;

Clearing enable_tdx here unnecessarily risks introducing bugs in the caller,
e.g. acting on enable_tdx before tdx_hardware_setup() is invoked.  I'm guessing
this was the result of trying to defer module load until VM creation.  With that
gone, the flag can be moved to vmx/main.c, as there should be zero reason for
tdx.c to check/modify enable_tdx, i.e. functions in tdx.c should never be called
if enabled_tdx = false.

An alteranative to 

	if (enable_tdx && tdx_hardware_setup(&vt_x86_ops))
		enable_tdx = false;

would be

	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);

I actually prefer the latter (no "if"), but I already generated and wiped the below
diff before thinking of that.

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index b79fcc8d81dd..43e13c2a804e 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -6,6 +6,9 @@
 #include "nested.h"
 #include "pmu.h"

+static bool __read_mostly enable_tdx = IS_ENABLED(CONFIG_INTEL_TDX_HOST);
+module_param_named(tdx, enable_tdx, bool, 0644);
+
 static __init int vt_hardware_setup(void)
 {
        int ret;
@@ -14,7 +17,8 @@ static __init int vt_hardware_setup(void)
        if (ret)
                return ret;

-       tdx_hardware_setup(&vt_x86_ops);
+       if (enable_tdx && tdx_hardware_setup(&vt_x86_ops))
+               enable_tdx = false;

        return 0;
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 1acf08c310c4..3f660f323426 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -9,13 +9,10 @@
 #undef pr_fmt
 #define pr_fmt(fmt) "tdx: " fmt

-static bool __read_mostly enable_tdx = true;
-module_param_named(tdx, enable_tdx, bool, 0644);
-
 static u64 hkid_mask __ro_after_init;
 static u8 hkid_start_pos __ro_after_init;

-static int __init __tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
+static int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 {
        u32 max_pa;

@@ -38,16 +35,3 @@ static int __init __tdx_hardware_setup(struct kvm_x86_ops *x86_ops)

        return 0;
 }
-
-void __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
-{
-       /*
-        * This function is called at the initialization.  No need to protect
-        * enable_tdx.
-        */
-       if (!enable_tdx)
-               return;
-
-       if (__tdx_hardware_setup(&vt_x86_ops))
-               enable_tdx = false;
-}
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index ccf98e79d8c3..fd60128eb10a 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -124,9 +124,9 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
 void vmx_setup_mce(struct kvm_vcpu *vcpu);

 #ifdef CONFIG_INTEL_TDX_HOST
-void __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
+int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
 #else
-static inline void tdx_hardware_setup(struct kvm_x86_ops *x86_ops) {}
+static inline int void tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
 #endif

 #endif /* __KVM_X86_VMX_X86_OPS_H */

