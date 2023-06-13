Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A418972EA05
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 19:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239303AbjFMRjA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 13:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234961AbjFMRi7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 13:38:59 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9381E92;
        Tue, 13 Jun 2023 10:38:57 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id 006d021491bc7-55b3a245359so4070133eaf.2;
        Tue, 13 Jun 2023 10:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686677937; x=1689269937;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oyOAYNwVkM9HUvnjcsU6Sed1pY4ZELlXPdhcPMMxRNQ=;
        b=HtE6LkDQzqAroSxVz1WSGUQgxRqBGs1BAAt/3QddS0BVWlUONyAiP25CSjJIwz+TwP
         03zbNqGvPtpC9o3hQ2dPhHArP43btCX81GSdxa74E+wgpt+bdqkMstCY72zjJJ5+5eWd
         FAf6QyRgFZ3Kl4mzkqlDdPncEkYpBxYOtkLGFPmdCYrAmn0omlBzLv1UOoNv6hH8lKin
         lufkrncrH1W3W0UaUFm59d6Rw9rrZJI3pJ2ShLMyCVQEJNNY/eUiX06BlpuhaCz7Z3yC
         tTe8rr4+FGYWZDns5e51RhDrJxURAXTp+Elpx0LyHSD1HPQ5Dl3+YVQzQGYzC3Aq810+
         8/mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686677937; x=1689269937;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oyOAYNwVkM9HUvnjcsU6Sed1pY4ZELlXPdhcPMMxRNQ=;
        b=RplUsCDZyPLfpSGsmTqmpuy22/PjaZNczSYrLGy55LyEbyiGY9Uf6LgGYdcmRALakT
         tGMY7xQDw+9zANTfaOI5YrF1OaCPD+LOCeDn9Z2Z/OJSQpBFsG1ujvMKCM5GMLwiLYSO
         1IQDzRyEHqriAmsu3kE9kfJyaD2OehubTDTylvOtmkSXmmckIQ0xmIdmVYQB5tmLQ2ts
         1LTPwuGFDTTukFAnIPJeI2W/JxAa+22ueMWof4U7IGdzxnHrewuopq5aWl3IaAwldOkS
         Mf0qfVPR5RZcp1SWMOXUDQieODQJvMtP9uebE4a1OZb/AE9hPtHUR+q1pee3k1KpCaV/
         AffQ==
X-Gm-Message-State: AC+VfDz5mtPryt/NIl+yOCXmWJwvQxNn9gpj83woRJgb6c+GlYIAMGZY
        OcOonGqNrathwHKIDEBKQn0=
X-Google-Smtp-Source: ACHHUZ5aaBEo+mtY0JtXxeGFVVHLQbdNB0zHalhcuSeuJrsLjXPmcXl4cqFf0clS0qyIAD396VD/7Q==
X-Received: by 2002:a05:6808:b0c:b0:39c:71fc:4cb4 with SMTP id s12-20020a0568080b0c00b0039c71fc4cb4mr6706788oij.58.1686677936711;
        Tue, 13 Jun 2023 10:38:56 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id u16-20020a63f650000000b00502f4c62fd3sm9685685pgj.33.2023.06.13.10.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 10:38:56 -0700 (PDT)
Date:   Tue, 13 Jun 2023 10:38:54 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chen, Bo2" <chen.bo@intel.com>, "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "dmatlack@google.com" <dmatlack@google.com>,
        "zhi.wang.linux@gmail.com" <zhi.wang.linux@gmail.com>
Subject: Re: [PATCH v14 004/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Message-ID: <20230613173854.GP2244082@ls.amr.corp.intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <e628e2d235d9b6c00b9bd5d81bb69136b77d13c4.1685333727.git.isaku.yamahata@intel.com>
 <3d8355ae582119486ac7ec129c4ba18d2cdf3ccb.camel@intel.com>
 <20230607180616.GF2244082@ls.amr.corp.intel.com>
 <6b60200b23fa3eac689a140abb92506410b14531.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6b60200b23fa3eac689a140abb92506410b14531.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 12, 2023 at 11:55:14PM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Wed, 2023-06-07 at 11:06 -0700, Isaku Yamahata wrote:
> > Thanks for pointing it out. The following is the fix.
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 8a1d0755d275..b0d3f646afb1 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -4499,26 +4499,39 @@ u64 tdx_non_arch_field_switch(u64 field)
> >  	}
> >  }
> >  
> > -static void __init vmx_tdx_on(void *info)
> > +struct vmx_tdx_enabled {
> > +	cpumask_var_t vmx_enabled;
> > +	atomic_t *err;
> > +};
> > +
> 
> Sorry for late reply.
> 
> I think you just need to mimic hardware_enable_all() -- using a per-cpu
> variable.  In this way you can get rid of this structure.
> 
> But again, we have listed a couple of options in the v13 discussion [1]:
> 
> 1) Call kvm_ops_update() twice before and after hardware_setup() in order to use
> hardware_enable_all() directly.
> 
> 2) Expose kvm_x86_ops as symbol so VMX can set hardware_{enable|disable}()
> callback before hardware_setup() in order to use hardware_enable_all().
> 
> 3) Implement VMX's own hardware_enable_all() logic as shown in this patch.
> 
> 4) ???
> 
> I think it would be better if Sean can provide some comments here, but until he
> does, we can keep using option 3) (this patch).
> 
> [1]
> https://lore.kernel.org/lkml/5dc84a2601a47ccc29ef43200cf3ec0d1b485d23.camel@intel.com/

Ok, makes sense. Here is the updated version with the fix for the error you
pointed out.  Introduce cpu bitmap to track which cpu enable VMX(VMXON)
successfully.  Disable VMX off only for cpu with bit set.


From 01dbb58b50e3119da9c3d639a10eb5d0029ee944 Mon Sep 17 00:00:00 2001
Message-Id: <01dbb58b50e3119da9c3d639a10eb5d0029ee944.1686677692.git.isaku.yamahata@intel.com>
From: Isaku Yamahata <isaku.yamahata@intel.com>
Date: Tue, 22 Feb 2022 14:44:15 -0800
Subject: [PATCH] KVM: TDX: Initialize the TDX module when loading the KVM
 intel kernel module

TDX requires several initialization steps for KVM to create guest TDs.
Detect CPU feature, enable VMX (TDX is based on VMX) on all online CPUs,
detect the TDX module availability, initialize it and disable VMX.

To enable/disable VMX on all online CPUs, utilize
vmx_hardware_enable/disable().  The method also initializes each CPU for
TDX.  TDX requires calling a TDX initialization function per logical
processor (LP) before the LP uses TDX.  When the CPU is becoming online,
call the TDX LP initialization API.  If it fails to initialize TDX, refuse
CPU online for simplicity instead of TDX avoiding the failed LP.

There are several options on when to initialize the TDX module.  A.) kernel
module loading time, B.) the first guest TD creation time.  A.) was chosen.
With B.), a user may hit an error of the TDX initialization when trying to
create the first guest TD.  The machine that fails to initialize the TDX
module can't boot any guest TD further.  Such failure is undesirable and a
surprise because the user expects that the machine can accommodate guest
TD, but not.  So A.) is better than B.).

Introduce a module parameter, kvm_intel.tdx, to explicitly enable TDX KVM
support.  It's off by default to keep the same behavior for those who don't
use TDX.  Implement hardware_setup method to detect TDX feature of CPU and
initialize TDX module.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Makefile      |  1 +
 arch/x86/kvm/vmx/main.c    | 34 ++++++++++++++-
 arch/x86/kvm/vmx/tdx.c     | 84 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  8 ++++
 4 files changed, 125 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/tdx.c

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 0e894ae23cbc..4b01ab842ab7 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -25,6 +25,7 @@ kvm-$(CONFIG_KVM_SMM)	+= smm.o
 kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
 			   vmx/hyperv.o vmx/nested.o vmx/posted_intr.o vmx/main.o
 kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
+kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o
 
 kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
 			   svm/sev.o svm/hyperv.o
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index bbeb32d40b8b..af037d1367e7 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -6,6 +6,36 @@
 #include "nested.h"
 #include "pmu.h"
 
+static bool enable_tdx __ro_after_init;
+module_param_named(tdx, enable_tdx, bool, 0444);
+
+static int vt_hardware_enable(void)
+{
+	int ret;
+
+	ret = vmx_hardware_enable();
+	if (ret || !enable_tdx)
+		return ret;
+
+	ret = tdx_cpu_enable();
+	if (ret)
+		vmx_hardware_disable();
+	return ret;
+}
+
+static __init int vt_hardware_setup(void)
+{
+	int ret;
+
+	ret = vmx_hardware_setup();
+	if (ret)
+		return ret;
+
+	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
+
+	return 0;
+}
+
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLE)|			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
@@ -22,7 +52,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.hardware_unsetup = vmx_hardware_unsetup,
 
-	.hardware_enable = vmx_hardware_enable,
+	.hardware_enable = vt_hardware_enable,
 	.hardware_disable = vmx_hardware_disable,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
@@ -157,7 +187,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
-	.hardware_setup = vmx_hardware_setup,
+	.hardware_setup = vt_hardware_setup,
 	.handle_intel_pt_intr = NULL,
 
 	.runtime_ops = &vt_x86_ops,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
new file mode 100644
index 000000000000..8a378fb6f1d4
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -0,0 +1,84 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/cpu.h>
+
+#include <asm/tdx.h>
+
+#include "capabilities.h"
+#include "x86_ops.h"
+#include "x86.h"
+
+#undef pr_fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+static int __init tdx_module_setup(void)
+{
+	int ret;
+
+	ret = tdx_enable();
+	if (ret) {
+		pr_info("Failed to initialize TDX module.\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+struct vmx_tdx_enabled {
+	cpumask_var_t vmx_enabled;
+	atomic_t err;
+};
+
+static void __init vmx_tdx_on(void *_vmx_tdx)
+{
+	struct vmx_tdx_enabled *vmx_tdx = _vmx_tdx;
+	int r;
+
+	r = vmx_hardware_enable();
+	if (!r) {
+		cpumask_set_cpu(smp_processor_id(), vmx_tdx->vmx_enabled);
+		r = tdx_cpu_enable();
+	}
+	if (r)
+		atomic_set(&vmx_tdx->err, r);
+}
+
+static void __init vmx_off(void *_vmx_enabled)
+{
+	cpumask_var_t *vmx_enabled = (cpumask_var_t *)_vmx_enabled;
+
+	if (cpumask_test_cpu(smp_processor_id(), *vmx_enabled))
+		vmx_hardware_disable();
+}
+
+int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
+{
+	struct vmx_tdx_enabled vmx_tdx = {
+		.err = ATOMIC_INIT(0),
+	};
+	int r = 0;
+
+	if (!enable_ept) {
+		pr_warn("Cannot enable TDX with EPT disabled\n");
+		return -EINVAL;
+	}
+
+	if (!zalloc_cpumask_var(&vmx_tdx.vmx_enabled, GFP_KERNEL)) {
+		r = -ENOMEM;
+		goto out;
+	}
+
+	/* tdx_enable() in tdx_module_setup() requires cpus lock. */
+	cpus_read_lock();
+	on_each_cpu(vmx_tdx_on, &vmx_tdx, true);	/* TDX requires vmxon. */
+	r = atomic_read(&vmx_tdx.err);
+	if (!r)
+		r = tdx_module_setup();
+	else
+		r = -EIO;
+	on_each_cpu(vmx_off, &vmx_tdx.vmx_enabled, true);
+	cpus_read_unlock();
+	free_cpumask_var(vmx_tdx.vmx_enabled);
+
+out:
+	return r;
+}
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 051b5c4b5c2f..a30683c6d822 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -20,6 +20,8 @@ bool kvm_is_vmx_supported(void);
 int __init vmx_init(void);
 void vmx_exit(void);
 
+__init int vmx_hardware_setup(void);
+
 extern struct kvm_x86_ops vt_x86_ops __initdata;
 extern struct kvm_x86_init_ops vt_init_ops __initdata;
 
@@ -133,4 +135,10 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
 #endif
 void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
+#ifdef CONFIG_INTEL_TDX_HOST
+int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
+#else
+static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
+#endif
+
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.25.1



-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
