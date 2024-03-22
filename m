Return-Path: <kvm+bounces-12528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2931B88746A
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 22:23:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3E59283281
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 21:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EDF67FBD2;
	Fri, 22 Mar 2024 21:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HfcGhKp+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102F67FBBD;
	Fri, 22 Mar 2024 21:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711142605; cv=none; b=hpw3y/lE5XSust11gom9GGDYI4LWvYbGQITGenmKpgXPpMMxzKcDhoVp109FBZLQQP7TY9LHEaP3Rru2HAnxKMtDngDDbdqbtLNjtArZgkoDCXzTetwoV5AAYqyi8l3dZlhGDO7HQUsg6j4fkgsUUueaXNNGn7ysK9Ce525nwcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711142605; c=relaxed/simple;
	bh=aNXR6cp4GNyqYOIZ5rINxHxXA0qK9zVACqy7F5CseQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mf9PIUH2T8Nm1kjrvlisnr+/vo2S5Y4inPptPSWgAB1TzKdxwPeIzBTViSRw2igmGiCrFVhE/dc+06dWFvrYoBpqPmjxEivwryD41iUKJj8ERcMoKThKqJrUG8JZo6tvWkFuGe1BMFTW0nceZAV2GlL0CiRsKPJAY7rKrIg+NMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HfcGhKp+; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711142603; x=1742678603;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=aNXR6cp4GNyqYOIZ5rINxHxXA0qK9zVACqy7F5CseQ0=;
  b=HfcGhKp+6aKkgcI1vM9/fV0A6nfz0GN5vFWp0g55u4UVQ3PvmDKCG034
   w7DZ9i7CyImjrOOPdXV8Qe1lL+N8MVo4DxmRrmnt9BaK30vdn+sIQGo8x
   RUh8oCaKa3QkMU/p/ht486XZ6aoeRtKasp9e4w0BzIY1p5GSyJPx7Vpmq
   DEHBJoYxDirqAeWIbL3GydS3EihDrpu61Vds2ho6AntjQxJerWufA1Gox
   fZJHG4Kkzjnxdt1aO97jRGkQbOhdCbbVHqGa11vFXumFyHaFewdnvuabr
   XVqsftI+tdBm9oRpHJEIMhSaVGY2NBrFroVDbE+3N8R3Dj8axn3VOf1Bf
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11021"; a="6066222"
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="6066222"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 14:23:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,147,1708416000"; 
   d="scan'208";a="15132322"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 14:23:22 -0700
Date: Fri, 22 Mar 2024 14:23:21 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Message-ID: <20240322212321.GA1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <f028d43abeadaa3134297d28fb99f283445c0333.1708933498.git.isaku.yamahata@intel.com>
 <d45bb93fb5fc18e7cda97d587dad4a1c987496a1.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d45bb93fb5fc18e7cda97d587dad4a1c987496a1.camel@intel.com>

On Thu, Mar 21, 2024 at 01:07:27PM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Mon, 2024-02-26 at 00:25 -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX requires several initialization steps for KVM to create guest TDs.
> > Detect CPU feature, enable VMX (TDX is based on VMX) on all online CPUs,
> > detect the TDX module availability, initialize it and disable VMX.
> 
> Before KVM can use TDX to create and run TDX guests, the kernel needs to
> initialize TDX from two perspectives:
> 
> 1) Initialize the TDX module.
> 1) Do the "per-cpu initialization" on any logical cpu before running any TDX   
> code on that cpu.
> 
> The host kernel provides two functions to do them respectively: tdx_cpu_enable()
> and tdx_enable().  
> 
> Currently, tdx_enable() requires all online cpus being in VMX operation with CPU
> hotplug disabled, and tdx_cpu_enable() needs to be called on local cpu with that
> cpu being in VMX operation and IRQ disabled.
> 
> > 
> > To enable/disable VMX on all online CPUs, utilize
> > vmx_hardware_enable/disable().  The method also initializes each CPU for
> > TDX.  
> > 
> 
> I don't understand what you are saying here.
> 
> Did you mean you put tdx_cpu_enable() inside vmx_hardware_enable()?

Now the section doesn't make sense. Will remove it.


> > TDX requires calling a TDX initialization function per logical
> > processor (LP) before the LP uses TDX.  
> > 
> 
> [...]
> 
> > When the CPU is becoming online,
> > call the TDX LP initialization API.  If it fails to initialize TDX, refuse
> > CPU online for simplicity instead of TDX avoiding the failed LP.
> 
> Unless I am missing something, I don't see this has been done in the code.

You're right. Somehow the code was lost.  Let me revive it with the next
version.


> > There are several options on when to initialize the TDX module.  A.) kernel
> > module loading time, B.) the first guest TD creation time.  A.) was chosen.
> 
> A.) was chosen -> Choose A).
> 
> Describe your change in "imperative mood".
> 
> > With B.), a user may hit an error of the TDX initialization when trying to
> > create the first guest TD.  The machine that fails to initialize the TDX
> > module can't boot any guest TD further.  Such failure is undesirable and a
> > surprise because the user expects that the machine can accommodate guest
> > TD, but not.  So A.) is better than B.).
> > 
> > Introduce a module parameter, kvm_intel.tdx, to explicitly enable TDX KVM
> 
> You don't have to say the name of the new parameter.  It's shown in the code.
> 
> > support.  It's off by default to keep the same behavior for those who don't
> > use TDX.  
> > 
> 
> [...]
> 
> 
> > Implement hardware_setup method to detect TDX feature of CPU and
> > initialize TDX module.
> 
> You are not detecting TDX feature anymore.
> 
> And put this in a separate paragraph (at a better place), as I don't see how
> this is connected to "introduce a module parameter".

Let me update those sentences.


> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> > v19:
> > - fixed vt_hardware_enable() to use vmx_hardware_enable()
> > - renamed vmx_tdx_enabled => tdx_enabled
> > - renamed vmx_tdx_on() => tdx_on()
> > 
> > v18:
> > - Added comment in vt_hardware_enable() by Binbin.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/Makefile      |  1 +
> >  arch/x86/kvm/vmx/main.c    | 19 ++++++++-
> >  arch/x86/kvm/vmx/tdx.c     | 84 ++++++++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/x86_ops.h |  6 +++
> >  4 files changed, 109 insertions(+), 1 deletion(-)
> >  create mode 100644 arch/x86/kvm/vmx/tdx.c
> > 
> > diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> > index 274df24b647f..5b85ef84b2e9 100644
> > --- a/arch/x86/kvm/Makefile
> > +++ b/arch/x86/kvm/Makefile
> > @@ -24,6 +24,7 @@ kvm-intel-y		+= vmx/vmx.o vmx/vmenter.o vmx/pmu_intel.o vmx/vmcs12.o \
> >  
> >  kvm-intel-$(CONFIG_X86_SGX_KVM)	+= vmx/sgx.o
> >  kvm-intel-$(CONFIG_KVM_HYPERV)	+= vmx/hyperv.o vmx/hyperv_evmcs.o
> > +kvm-intel-$(CONFIG_INTEL_TDX_HOST)	+= vmx/tdx.o
> >  
> >  kvm-amd-y		+= svm/svm.o svm/vmenter.o svm/pmu.o svm/nested.o svm/avic.o \
> >  			   svm/sev.o
> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index 18cecf12c7c8..18aef6e23aab 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -6,6 +6,22 @@
> >  #include "nested.h"
> >  #include "pmu.h"
> >  
> > +static bool enable_tdx __ro_after_init;
> > +module_param_named(tdx, enable_tdx, bool, 0444);
> > +
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
> >  #define VMX_REQUIRED_APICV_INHIBITS				\
> >  	(BIT(APICV_INHIBIT_REASON_DISABLE)|			\
> >  	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
> > @@ -22,6 +38,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> >  
> >  	.hardware_unsetup = vmx_hardware_unsetup,
> >  
> > +	/* TDX cpu enablement is done by tdx_hardware_setup(). */
> 
> What's the point of this comment?  I don't understand it either.

Will delete the comment.


> >  	.hardware_enable = vmx_hardware_enable,
> >  	.hardware_disable = vmx_hardware_disable,
> 
> Shouldn't you also implement vt_hardware_enable(), which also does
> tdx_cpu_enable()? 
> 
> Because I don't see vmx_hardware_enable() is changed to call tdx_cpu_enable() to
> make CPU hotplug work with TDX.

hardware_enable() doesn't help for cpu hot plug support. See below.


> >  	.has_emulated_msr = vmx_has_emulated_msr,
> > @@ -161,7 +178,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> >  };
> >  
> >  struct kvm_x86_init_ops vt_init_ops __initdata = {
> > -	.hardware_setup = vmx_hardware_setup,
> > +	.hardware_setup = vt_hardware_setup,
> >  	.handle_intel_pt_intr = NULL,
> >  
> >  	.runtime_ops = &vt_x86_ops,
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > new file mode 100644
> > index 000000000000..43c504fb4fed
> > --- /dev/null
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -0,0 +1,84 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/cpu.h>
> > +
> > +#include <asm/tdx.h>
> > +
> > +#include "capabilities.h"
> > +#include "x86_ops.h"
> > +#include "x86.h"
> > +
> > +#undef pr_fmt
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> > +static int __init tdx_module_setup(void)
> > +{
> > +	int ret;
> > +
> > +	ret = tdx_enable();
> > +	if (ret) {
> > +		pr_info("Failed to initialize TDX module.\n");
> 
> As I commented before, tdx_enable() itself will print similar message when it
> fails, so no need to print again.
> 
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> 
> That being said, I don't think tdx_module_setup() is necessary.  Just call
> tdx_enable() directly.

Ok, Will move this funciton to the patch that uses it first.


> > +
> > +struct tdx_enabled {
> > +	cpumask_var_t enabled;
> > +	atomic_t err;
> > +};
> 
> struct cpu_tdx_init_ctx {
> 	cpumask_var_t vmx_enabled_cpumask;
> 	atomic_t err;
> };
> 
> ?
> 
> > +
> > +static void __init tdx_on(void *_enable)
> 
> tdx_on() -> cpu_tdx_init(), or cpu_tdx_on()?
> 
> > +{
> > +	struct tdx_enabled *enable = _enable;
> > +	int r;
> > +
> > +	r = vmx_hardware_enable();
> > +	if (!r) {
> > +		cpumask_set_cpu(smp_processor_id(), enable->enabled);
> > +		r = tdx_cpu_enable();
> > +	}
> > +	if (r)
> > +		atomic_set(&enable->err, r);
> > +}
> > +
> > +static void __init vmx_off(void *_enabled)
> 
> cpu_vmx_off() ?

Ok, let's add cpu_ prefix.


> > +{
> > +	cpumask_var_t *enabled = (cpumask_var_t *)_enabled;
> > +
> > +	if (cpumask_test_cpu(smp_processor_id(), *enabled))
> > +		vmx_hardware_disable();
> > +}
> > +
> > +int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> 
> Why do you need the 'x86_ops' function argument?  I don't see it is used?

Will move it to the patch that uses it first.


> > +{
> > +	struct tdx_enabled enable = {
> > +		.err = ATOMIC_INIT(0),
> > +	};
> > +	int r = 0;
> > +
> > +	if (!enable_ept) {
> > +		pr_warn("Cannot enable TDX with EPT disabled\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (!zalloc_cpumask_var(&enable.enabled, GFP_KERNEL)) {
> > +		r = -ENOMEM;
> > +		goto out;
> > +	}
> > +
> > +	/* tdx_enable() in tdx_module_setup() requires cpus lock. */
> 
> 	/* tdx_enable() must be called with CPU hotplug disabled */
> 
> > +	cpus_read_lock();
> > +	on_each_cpu(tdx_on, &enable, true); /* TDX requires vmxon. */
> 
> I don't think you need this comment _here_.
> 
> If you want keep it, move to the tdx_on() where the code does what this comment
> say.

Will move the comment into cpu_tdx_on().


> > +	r = atomic_read(&enable.err);
> > +	if (!r)
> > +		r = tdx_module_setup();
> > +	else
> > +		r = -EIO;
> > +	on_each_cpu(vmx_off, &enable.enabled, true);
> > +	cpus_read_unlock();
> > +	free_cpumask_var(enable.enabled);
> > +
> > +out:
> > +	return r;
> > +}
> 
> At last, I think there's one problem here:
> 
> KVM actually only registers CPU hotplug callback in kvm_init(), which happens
> way after tdx_hardware_setup().
> 
> What happens if any CPU goes online *BETWEEN* tdx_hardware_setup() and
> kvm_init()?
> 
> Looks we have two options:
> 
> 1) move registering CPU hotplug callback before tdx_hardware_setup(), or
> 2) we need to disable CPU hotplug until callbacks have been registered.
> 
> Perhaps the second one is easier, because for the first one we need to make sure
> the kvm_cpu_online() is ready to be called right after tdx_hardware_setup().
> 
> And no one cares if CPU hotplug is disabled during KVM module loading.
> 
> That being said, we can even just disable CPU hotplug during the entire
> vt_init(), if in this way the code change is simple?
> 
> But anyway, to make this patch complete, I think you need to replace
> vmx_hardware_enable() to vt_hardware_enable() and do tdx_cpu_enable() to handle
> TDX vs CPU hotplug in _this_ patch.

The option 2 sounds easier. But hardware_enable() doesn't help because it's
called when the first guest is created. It's risky to change it's semantics
because it's arch-independent callback.

- Disable CPU hot plug during TDX module initialization.
- During hardware_setup(), enable VMX, tdx_cpu_enable(), disable VMX
  on online cpu. Don't rely on KVM hooks.
- Add a new arch-independent hook, int kvm_arch_online_cpu(). It's called always
  on cpu onlining. It eventually calls tdx_cpu_enabel(). If it fails, refuse
  onlining.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

