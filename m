Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E42730489
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 18:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjFNQFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 12:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjFNQFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 12:05:12 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600E2122;
        Wed, 14 Jun 2023 09:05:11 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-652426346bbso5347637b3a.3;
        Wed, 14 Jun 2023 09:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686758711; x=1689350711;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iVZ7KAcLsTMz8WwXirFAGzm9Wo7TgZXbXs9ARjn0gQQ=;
        b=c6RftKDv+j/LPMq7if5uMwQDwc/5r0ChORD87GYS7ad9Wm+a+ovqQzRxBFNjCUXPil
         0lD3NnSs1s64RioxZBiKsZvFq064v1ddHigPmkEd4RyBfJ4l2n1EDIUqFQ6fM3/oLFLb
         eru9RRIuO8AKeB+8Zult2SZyTi6nuFdRILuDBb8iU5OWARcQhkC0ZebSH/ElKs+2ENPn
         WaTYAyOa3b/wLQ/NNGxgQjCqtfcurBs7JPWdOerwjB464r08yDPiTj3yHOdZWlrcuEvD
         K+Mq4WY/6OdPKxMbaDyJoYLwakyGRBIt6mOML4Bwu1VhKEeQVFu+pCP9h6YEdunZT3Xd
         6gIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686758711; x=1689350711;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iVZ7KAcLsTMz8WwXirFAGzm9Wo7TgZXbXs9ARjn0gQQ=;
        b=Ojr4h0Of+559ijmi1sIo4UxPH7wjbe/yUlZ6p2xgkAY0a+3a6DZW+7US5swtyxkryL
         o43uCrVeWd2rSAfpOEYnpl0uDxEHLgQDZ09ME4hytry6PpkNKRQ7cEktPuMagLyH902u
         yjTDGImAAVQy8tEWG4hpSYhHfpioJrhV88Hcm36SZBLq+Bi1yzM1X0ice4XgIlAysQtS
         OCK5XthGX0BYb19jfNGnRUIU3CvHD+RislHD/neKobb8q8xvdYKj7HdvlqYNvpwaH3kP
         XVCmKu0O2AJJBBMfZM+McngfZG3pfXT2wvPEqlXFAhgOOLyOQ6JlDv52jDnkz5hGne75
         GFOw==
X-Gm-Message-State: AC+VfDxUZjF8wVj9AdlxffEeL1ExKuSCp/Rgsq/JiHVxXeL3QTPG1Uiy
        ARJZksmFAATjrwOg7WHTWvs=
X-Google-Smtp-Source: ACHHUZ4ngJrADvm4eZ2kU1VHrFA53HtwAqEQk1dPE8ObdJ5pdZUt1WAdTLbPAVbm6qOMNq/kwVa5Hw==
X-Received: by 2002:a05:6a00:88d:b0:65a:cbf3:46a4 with SMTP id q13-20020a056a00088d00b0065acbf346a4mr2193843pfj.5.1686758709968;
        Wed, 14 Jun 2023 09:05:09 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id j24-20020a62b618000000b00643889e30c2sm10564363pff.180.2023.06.14.09.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 09:05:09 -0700 (PDT)
Date:   Wed, 14 Jun 2023 09:05:07 -0700
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
Message-ID: <20230614160507.GR2244082@ls.amr.corp.intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <e628e2d235d9b6c00b9bd5d81bb69136b77d13c4.1685333727.git.isaku.yamahata@intel.com>
 <3d8355ae582119486ac7ec129c4ba18d2cdf3ccb.camel@intel.com>
 <20230607180616.GF2244082@ls.amr.corp.intel.com>
 <6b60200b23fa3eac689a140abb92506410b14531.camel@intel.com>
 <20230613173854.GP2244082@ls.amr.corp.intel.com>
 <831f6e968e4794775c3e2adba1d550be70b01c33.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <831f6e968e4794775c3e2adba1d550be70b01c33.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 14, 2023 at 09:41:58AM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Tue, 2023-06-13 at 10:38 -0700, Isaku Yamahata wrote:
> > On Mon, Jun 12, 2023 at 11:55:14PM +0000,
> > "Huang, Kai" <kai.huang@intel.com> wrote:
> > 
> > > On Wed, 2023-06-07 at 11:06 -0700, Isaku Yamahata wrote:
> > > > Thanks for pointing it out. The following is the fix.
> > > > 
> > > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > > index 8a1d0755d275..b0d3f646afb1 100644
> > > > --- a/arch/x86/kvm/vmx/tdx.c
> > > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > > @@ -4499,26 +4499,39 @@ u64 tdx_non_arch_field_switch(u64 field)
> > > >  	}
> > > >  }
> > > >  
> > > > -static void __init vmx_tdx_on(void *info)
> > > > +struct vmx_tdx_enabled {
> > > > +	cpumask_var_t vmx_enabled;
> > > > +	atomic_t *err;
> > > > +};
> > > > +
> > > 
> > > Sorry for late reply.
> > > 
> > > I think you just need to mimic hardware_enable_all() -- using a per-cpu
> > > variable.  In this way you can get rid of this structure.
> > > 
> > > But again, we have listed a couple of options in the v13 discussion [1]:
> > > 
> > > 1) Call kvm_ops_update() twice before and after hardware_setup() in order to use
> > > hardware_enable_all() directly.
> > > 
> > > 2) Expose kvm_x86_ops as symbol so VMX can set hardware_{enable|disable}()
> > > callback before hardware_setup() in order to use hardware_enable_all().
> > > 
> > > 3) Implement VMX's own hardware_enable_all() logic as shown in this patch.
> > > 
> > > 4) ???
> > > 
> > > I think it would be better if Sean can provide some comments here, but until he
> > > does, we can keep using option 3) (this patch).
> > > 
> > > [1]
> > > https://lore.kernel.org/lkml/5dc84a2601a47ccc29ef43200cf3ec0d1b485d23.camel@intel.com/
> > 
> > Ok, makes sense. Here is the updated version with the fix for the error you
> > pointed out.  Introduce cpu bitmap to track which cpu enable VMX(VMXON)
> > successfully.  Disable VMX off only for cpu with bit set.
> > 
> > 
> [...]
> 
> > +struct vmx_tdx_enabled {
> > +	cpumask_var_t vmx_enabled;
> > +	atomic_t err;
> > +};
> > +
> 
> Again (and again), why not just mimic hardware_enable_all() to use a per-cpu
> variable instead of a cpumask, so that you can get rid of this structure?

Do you mean __hardware_enable_nolock() uses per-cpu variable?
Because hardware setup is one shot on the initialization, we don't want to
allocate the variable statically. Anyway the following is a patch to use
per-cpu variable with dynamic allocation.  Which version do you prefer?


diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 95be6b2fba83..40a3c9c01ac6 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -4511,38 +4511,34 @@ u64 tdx_non_arch_field_switch(u64 field)
 }
 
 struct vmx_tdx_enabled {
-	cpumask_var_t vmx_enabled;
-	atomic_t err;
+	bool vmx_enabled;
+	int err;
 };
 
 static void __init vmx_tdx_on(void *_vmx_tdx)
 {
-	struct vmx_tdx_enabled *vmx_tdx = _vmx_tdx;
-	int r;
+	struct vmx_tdx_enabled *vmx_tdx = this_cpu_ptr(_vmx_tdx);
 
-	r = vmx_hardware_enable();
-	if (!r) {
-		cpumask_set_cpu(smp_processor_id(), vmx_tdx->vmx_enabled);
-		r = tdx_cpu_enable();
+	vmx_tdx->err = vmx_hardware_enable();
+	if (!vmx_tdx->err) {
+		vmx_tdx->vmx_enabled = true;
+		vmx_tdx->err = tdx_cpu_enable();
 	}
-	if (r)
-		atomic_set(&vmx_tdx->err, r);
 }
 
-static void __init vmx_off(void *_vmx_enabled)
+static void __init vmx_off(void *_vmx_tdx)
 {
-	cpumask_var_t *vmx_enabled = (cpumask_var_t *)_vmx_enabled;
+	struct vmx_tdx_enabled *vmx_tdx = this_cpu_ptr(_vmx_tdx);
 
-	if (cpumask_test_cpu(smp_processor_id(), *vmx_enabled))
+	if (vmx_tdx->vmx_enabled)
 		vmx_hardware_disable();
 }
 
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 {
-	struct vmx_tdx_enabled vmx_tdx = {
-		.err = ATOMIC_INIT(0),
-	};
+	struct vmx_tdx_enabled __percpu *vmx_tdx_enabled;
 	int max_pkgs;
+	int cpu;
 	int r = 0;
 	int i;
 
@@ -4603,7 +4599,8 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 	for (i = 0; i < max_pkgs; i++)
 		mutex_init(&tdx_mng_key_config_lock[i]);
 
-	if (!zalloc_cpumask_var(&vmx_tdx.vmx_enabled, GFP_KERNEL)) {
+	vmx_tdx_enabled = alloc_percpu_gfp(struct vmx_tdx_enabled, GFP_KERNEL | __GFP_ZERO);
+	if (!vmx_tdx_enabled) {
 		r = -ENOMEM;
 		goto out;
 	}
@@ -4618,15 +4615,21 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 	 */
 	if (!cpumask_equal(cpu_online_mask, cpu_present_mask))
 		pr_warn("The old TDX module requires all present CPUs to be online to initialize.\n");
-	on_each_cpu(vmx_tdx_on, &vmx_tdx, true);	/* TDX requires vmxon. */
-	r = atomic_read(&vmx_tdx.err);
+	on_each_cpu(vmx_tdx_on, vmx_tdx_enabled, true);	/* TDX requires vmxon. */
+	for_each_present_cpu(cpu) {
+		struct vmx_tdx_enabled *vmx_tdx = per_cpu_ptr(vmx_tdx_enabled, cpu);
+		if (vmx_tdx->err) {
+			r = vmx_tdx->err;
+			break;
+		}
+	}
 	if (!r)
 		r = tdx_module_setup();
 	else
 		r = -EIO;
-	on_each_cpu(vmx_off, &vmx_tdx.vmx_enabled, true);
+	on_each_cpu(vmx_off, vmx_tdx_enabled, true);
 	cpus_read_unlock();
-	free_cpumask_var(vmx_tdx.vmx_enabled);
+	free_percpu(vmx_tdx_enabled);
 	if (r)
 		goto out;
 
-- 
2.25.1




-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
