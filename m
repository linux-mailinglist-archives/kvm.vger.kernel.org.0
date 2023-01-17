Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9056C66E2FD
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 17:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjAQQDp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 11:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbjAQQDd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 11:03:33 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE572E0D6;
        Tue, 17 Jan 2023 08:03:32 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id c26so19410684pfp.10;
        Tue, 17 Jan 2023 08:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oRkvG8XIcQviuVHh1q5C9ulShLob104i0vqKxul4XRg=;
        b=IaQqYiPScZyPgzvh1Dz7kBYumyUGIQLGQMSibojq5dLsjKZsHMKErSOpUb8fjI8+9o
         mfm/okFUn2a+gFH+zvjcta4LYJA6p4rvbybF2y3RjgJee8yav3DyAPSF0hNWC8p2piMb
         bN4nFvie/HbSCNbjblxRaj9PZ6X8XDa9SklQZzqngyLrXmbEIiAhVGEk1iB4FlMfb2dT
         LAB2E9jD4RefNu8VvmjA35Vvc0gVuIqc4isoaQN6ZkjSFdIrUe1CoCdb1GM1v36ZKN8G
         1GEBiCZv3C1JWGNgB00RjjNqXCnSt9cPNHI5cxxLihQnxqk4X67vnH5P/P1HW3dV8O41
         DJKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oRkvG8XIcQviuVHh1q5C9ulShLob104i0vqKxul4XRg=;
        b=GCrOy9hIJSSJ5G1ZK/Ss9wl2Laq6+eAF7bPD3oLqaHVXsQQBYCa+dA7sny0AR6JZNB
         n62MCQSR01cELV1k1kDz8D1t9D+IKK1j+gMZ+rOVtB2V8wHhOIsOGVVCupzTP5Jybnpb
         Q499umEv7Hh+rp3Q2bfScRkA2+q6pjPbsMJ9sIMwfL8k6ZfgSf1jOcoCQrkiyvbj3B0w
         Yb8f0/w9YVhpiEwpMhOILN5zdFVMlvbQ8VwAUEGoslwBsBZmwPd/TBnilyZaIrrlCt6p
         Q7v1ABJ2tgH7+Kp87v0L464He5j48GvJoayDsmZMuOBekIijfXq6gOj3ujwadbD+ERLi
         +YnQ==
X-Gm-Message-State: AFqh2koDIWHKOEOJLASAobWHVVo8/qv1jHhejSBP6Bzidei0Y60kvGTG
        tw/YNs4Kkq79ACxr+6strTF/QKOrP1A=
X-Google-Smtp-Source: AMrXdXtyD3IxrDDem1vzzNuEQKqif42cDxBEQKtI6SXquTbu5o5i/doOdVIaPuKudvuf42+42ZMDfg==
X-Received: by 2002:aa7:8c51:0:b0:58d:8d88:447b with SMTP id e17-20020aa78c51000000b0058d8d88447bmr2826812pfd.2.1673971411539;
        Tue, 17 Jan 2023 08:03:31 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id g8-20020aa79f08000000b0058d928374f2sm5126608pfr.20.2023.01.17.08.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 08:03:31 -0800 (PST)
Date:   Tue, 17 Jan 2023 08:03:30 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v11 004/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Message-ID: <20230117160330.GA2959778@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <60c842f347eaecdd0673bdc63acd95b82eeeda9c.1673539699.git.isaku.yamahata@intel.com>
 <20230113143158.00006ca5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230113143158.00006ca5@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 13, 2023 at 02:31:58PM +0200,
Zhi Wang <zhi.wang.linux@gmail.com> wrote:

> On Thu, 12 Jan 2023 08:31:12 -0800
> isaku.yamahata@intel.com wrote:
> 
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX requires several initialization steps for KVM to create guest TDs.
> > Detect CPU feature, enable VMX (TDX is based on VMX), detect the TDX
> > module availability, and initialize it.  This patch implements those
> > steps.
> > 
> > There are several options on when to initialize the TDX module.  A.)
> > kernel module loading time, B.) the first guest TD creation time.  A.)
> > was chosen. With B.), a user may hit an error of the TDX initialization
> > when trying to create the first guest TD.  The machine that fails to
> > initialize the TDX module can't boot any guest TD further.  Such failure
> > is undesirable and a surprise because the user expects that the machine
> > can accommodate guest TD, but actually not.  So A.) is better than B.).
> > 
> > Introduce a module parameter, enable_tdx, to explicitly enable TDX KVM
> > support.  It's off by default to keep same behavior for those who don't
> > use TDX.  Implement hardware_setup method to detect TDX feature of CPU.
> > Because TDX requires all present CPUs to enable VMX (VMXON).  The x86
> > specific kvm_arch_post_hardware_enable_setup overrides the existing weak
> > symbol of kvm_arch_post_hardware_enable_setup which is called at the KVM
> > module initialization.
> > 
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/Makefile      |  1 +
> >  arch/x86/kvm/vmx/main.c    | 33 +++++++++++++++++++++++-----
> >  arch/x86/kvm/vmx/tdx.c     | 44 ++++++++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/vmx.c     | 39 +++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/x86_ops.h | 10 +++++++++
> >  5 files changed, 122 insertions(+), 5 deletions(-)
> >  create mode 100644 arch/x86/kvm/vmx/tdx.c
> > 
> > diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> > index 0e894ae23cbc..4b01ab842ab7 100644
> > --- a/arch/x86/kvm/Makefile
> > +++ b/arch/x86/kvm/Makefile
> > @@ -25,6 +25,7 @@ kvm-$(CONFIG_KVM_SMM)	+= smm.o
> >  kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o
> > vmx/vmcs12.o \ vmx/hyperv.o vmx/nested.o vmx/posted_intr.o vmx/main.o
> >  kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
> > +kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o
> >  
> >  kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o
> > svm/nested.o svm/avic.o \ svm/sev.o svm/hyperv.o
> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index 18f659d1d456..f5d1166d2718 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -7,6 +7,22 @@
> >  #include "pmu.h"
> >  #include "tdx.h"
> >  
> > +static bool enable_tdx __ro_after_init =
> > IS_ENABLED(CONFIG_INTEL_TDX_HOST); +module_param_named(tdx, enable_tdx,
> > bool, 0444); +
> 
> The comments says "TDX is off by default". It seems default on/off is controlled
> by the kernel configuration here.

I'll update the comments.

> > +static __init int vt_hardware_setup(void)
> > +{
> > +	int ret;
> > +
> > +	ret = vmx_hardware_setup();
> > +	if (ret)
> > +		return ret;
> > +
> > +	enable_tdx = enable_tdx && !tdx_hardware_setup(&vt_x86_ops);
> > +
> > +	return 0;
> > +}
> > +
> >  struct kvm_x86_ops vt_x86_ops __initdata = {
> >  	.name = KBUILD_MODNAME,
> >  
> > @@ -149,7 +165,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> >  };
> >  
> >  struct kvm_x86_init_ops vt_init_ops __initdata = {
> > -	.hardware_setup = vmx_hardware_setup,
> > +	.hardware_setup = vt_hardware_setup,
> >  	.handle_intel_pt_intr = NULL,
> >  
> >  	.runtime_ops = &vt_x86_ops,
> > @@ -182,10 +198,17 @@ static int __init vt_init(void)
> >  	 * Common KVM initialization _must_ come last, after this,
> > /dev/kvm is
> >  	 * exposed to userspace!
> >  	 */
> > -	vt_x86_ops.vm_size = max(sizeof(struct kvm_vmx), sizeof(struct
> > kvm_tdx));
> > -	vcpu_size = max(sizeof(struct vcpu_vmx), sizeof(struct
> > vcpu_tdx));
> > -	vcpu_align = max(__alignof__(struct vcpu_vmx),
> > -			 __alignof__(struct vcpu_tdx));
> > +	vt_x86_ops.vm_size = sizeof(struct kvm_vmx);
> > +	vcpu_size = sizeof(struct vcpu_vmx);
> > +	vcpu_align = __alignof__(struct vcpu_vmx);
> > +	if (enable_tdx) {
> > +		vt_x86_ops.vm_size = max_t(unsigned int,
> > vt_x86_ops.vm_size,
> > +					   sizeof(struct kvm_tdx));
> > +		vcpu_size = max_t(unsigned int, vcpu_size,
> > +				  sizeof(struct vcpu_tdx));
> > +		vcpu_align = max_t(unsigned int, vcpu_align,
> > +				   __alignof__(struct vcpu_tdx));
> > +	}
> >  	r = kvm_init(vcpu_size, vcpu_align, THIS_MODULE);
> >  	if (r)
> >  		goto err_kvm_init;
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > new file mode 100644
> > index 000000000000..d7a276118940
> > --- /dev/null
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -0,0 +1,44 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/cpu.h>
> > +
> > +#include <asm/tdx.h>
> > +
> > +#include "capabilities.h"
> > +#include "x86_ops.h"
> > +#include "tdx.h"
> > +#include "x86.h"
> > +
> > +#undef pr_fmt
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> > +static int __init tdx_module_setup(void)
> > +{
> > +	int ret;
> > +
> 
> Better mention the tdx_enable() is implemented in another patch? But I guess
> we need a wrapper here so that the compilation would succeed.

The coverletter mentions it. I'll make the commit message of this patch
mention it anyway.

> > +	ret = tdx_enable();
> > +	if (ret) {
> > +		pr_info("Failed to initialize TDX module.\n");
> > +		return ret;
> > +	}
> > +
> > +	pr_info("TDX is supported.\n");
> > +	return 0;
> > +}
> > +
> > +int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> > +{
> > +	int r;
> > +
> > +	if (!enable_ept) {
> > +		pr_warn("Cannot enable TDX with EPT disabled\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* TDX requires VMX. */
> > +	r = vmxon_all();
> > +	if (!r)
> > +		r = tdx_module_setup();
> > +	vmxoff_all();
> > +
> > +	return r;
> > +}
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 5de1792c9902..5dc7687dcf16 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -8147,6 +8147,45 @@ static unsigned int vmx_handle_intel_pt_intr(void)
> >  	return 1;
> >  }
> >  
> > +static __init void vmxon(void *arg)
> > +{
> > +	int cpu = raw_smp_processor_id();
> > +	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
> > +	atomic_t *failed = arg;
> > +	int r;
> > +
> > +	if (cr4_read_shadow() & X86_CR4_VMXE) {
> > +		r = -EBUSY;
> > +		goto out;
> > +	}
> > +
> > +	r = kvm_cpu_vmxon(phys_addr);
> > +out:
> > +	if (r)
> > +		atomic_inc(failed);
> > +}
> > +
> > +__init int vmxon_all(void)
> > +{
> > +	atomic_t failed = ATOMIC_INIT(0);
> > +
> > +	on_each_cpu(vmxon, &failed, 1);
> > +
> > +	if (atomic_read(&failed))
> > +		return -EBUSY;
> > +	return 0;
> > +}
> > +
> > +static __init void vmxoff(void *junk)
> > +{
> > +	cpu_vmxoff();
> > +}
> > +
> > +__init void vmxoff_all(void)
> > +{
> > +	on_each_cpu(vmxoff, NULL, 1);
> > +}
> > +
> >  static __init void vmx_setup_user_return_msrs(void)
> >  {
> >  
> > diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> > index 051b5c4b5c2f..fbc57fcbdd21 100644
> > --- a/arch/x86/kvm/vmx/x86_ops.h
> > +++ b/arch/x86/kvm/vmx/x86_ops.h
> > @@ -20,6 +20,10 @@ bool kvm_is_vmx_supported(void);
> >  int __init vmx_init(void);
> >  void vmx_exit(void);
> >  
> > +__init int vmxon_all(void);
> > +__init void vmxoff_all(void);
> > +__init int vmx_hardware_setup(void);
> > +
> >  extern struct kvm_x86_ops vt_x86_ops __initdata;
> >  extern struct kvm_x86_init_ops vt_init_ops __initdata;
> >  
> > @@ -133,4 +137,10 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
> >  #endif
> >  void vmx_setup_mce(struct kvm_vcpu *vcpu);
> >  
> > +#ifdef CONFIG_INTEL_TDX_HOST
> > +int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
> > +#else
> > +static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) {
> > return 0; } +#endif
> > +
> >  #endif /* __KVM_X86_VMX_X86_OPS_H */
> 

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
