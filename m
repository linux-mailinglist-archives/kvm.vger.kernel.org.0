Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E3C570F50
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 03:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiGLBP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 21:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiGLBP5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 21:15:57 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B681C33402;
        Mon, 11 Jul 2022 18:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657588556; x=1689124556;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=h2wcAO4Lirq8IpSRBw7BGXPLtltbe44zHmO9tFyOx8s=;
  b=UfYe/fJUt0dc6LuT/H3groqRA/jbCLOwqiAy9iU9HIuH49nV4WHTUA67
   4gu412CkyfPHLXQ8lpmoTrfH6LiD2pRF7GKysdDM0aQYOh1j1KicO/MIg
   hrZOTrn5KivbmWeKt2JWQHPuHHoO8YAtbjSKbdcuDnpnBp+PKlWpe4Ugr
   hvJiNKNTzyiTj6xFIhlmbPLCK+asyUpaz4xKTPWX7n95vl0fSzBPeQi5m
   VeJVHWUN40n5wd+/+1+3BcXbxglWukzLekVF6ZsuBYxPyY9V4aoezqY0e
   uhenmj7nwSFR6+5mUBWbaBjeUha/rl8vjzePc2c9ys7HG7zf1pFCIxWyf
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="285552468"
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="285552468"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 18:15:56 -0700
X-IronPort-AV: E=Sophos;i="5.92,264,1650956400"; 
   d="scan'208";a="922007127"
Received: from snaskant-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.60.27])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 18:15:54 -0700
Message-ID: <1b5e06b237ad9f2bcbee320e95b94e336109b484.camel@intel.com>
Subject: Re: [PATCH v7 003/102] KVM: Refactor CPU compatibility check on
 module initialiization
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Tue, 12 Jul 2022 13:15:52 +1200
In-Reply-To: <e1f72040effd7b4ed31f9941e009f959d6345129.1656366338.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <e1f72040effd7b4ed31f9941e009f959d6345129.1656366338.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-27 at 14:52 -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>=20
> Although non-x86 arch doesn't break as long as I inspected code, it's by
> code inspection.  This should be reviewed by each arch maintainers.
>=20
> kvm_init() checks CPU compatibility by calling
> kvm_arch_check_processor_compat() on all online CPUs.  Move the callback
> to hardware_enable_nolock() and add hardware_enable_all() and
> hardware_disable_all().
> Add arch specific callback kvm_arch_post_hardware_enable_setup() for arch
> to do arch specific initialization that required hardware_enable_all().
> This makes a room for TDX module to initialize on kvm module loading.  TD=
X
> module requires all online cpu to enable VMX by VMXON.
>=20
> If kvm_arch_hardware_enable/disable() depend on (*) part, such dependency
> must be called before kvm_init().  In fact kvm_intel() does.  Although
> other arch doesn't as long as I checked as follows, it should be reviewed
> by each arch maintainers.
>=20
> Before this patch:
> - Arch module initialization
>   - kvm_init()
>     - kvm_arch_init()
>     - kvm_arch_check_processor_compat() on each CPUs
>   - post arch specific initialization ---- (*)
>=20
> - when creating/deleting first/last VM
>    - kvm_arch_hardware_enable() on each CPUs --- (A)
>    - kvm_arch_hardware_disable() on each CPUs --- (B)
>=20
> After this patch:
> - Arch module initialization
>   - kvm_init()
>     - kvm_arch_init()
>     - kvm_arch_hardware_enable() on each CPUs  (A)
>     - kvm_arch_check_processor_compat() on each CPUs
>     - kvm_arch_hardware_disable() on each CPUs (B)
>   - post arch specific initialization  --- (*)
>=20
> Code inspection result:
> (A)/(B) can depend on (*) before this patch.  If there is dependency, suc=
h
> initialization must be moved before kvm_init() with this patch.  VMX does
> in fact.  As long as I inspected other archs and find only mips has it.
>=20
> - arch/mips/kvm/mips.c
>   module init function, kvm_mips_init(), does some initialization after
>   kvm_init().  Compile test only.  Needs review.
>=20
> - arch/x86/kvm/x86.c
>   - uses vm_list which is statically initialized.
>   - static_call(kvm_x86_hardware_enable)();
>     - SVM: (*) is empty.
>     - VMX: needs fix
>=20
> - arch/powerpc/kvm/powerpc.c
>   kvm_arch_hardware_enable/disable() are nop
>=20
> - arch/s390/kvm/kvm-s390.c
>   kvm_arch_hardware_enable/disable() are nop
>=20
> - arch/arm64/kvm/arm.c
>   module init function, arm_init(), calls only kvm_init().
>   (*) is empty
>=20
> - arch/riscv/kvm/main.c
>   module init function, riscv_kvm_init(), calls only kvm_init().
>   (*) is empty
>=20
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/mips/kvm/mips.c     | 12 +++++++-----
>  arch/x86/kvm/vmx/vmx.c   | 15 +++++++++++----
>  include/linux/kvm_host.h |  1 +
>  virt/kvm/kvm_main.c      | 25 ++++++++++++++++++-------
>  4 files changed, 37 insertions(+), 16 deletions(-)
>=20
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index 092d09fb6a7e..17228584485d 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -1643,11 +1643,6 @@ static int __init kvm_mips_init(void)
>  	}
> =20
>  	ret =3D kvm_mips_entry_setup();
> -	if (ret)
> -		return ret;
> -
> -	ret =3D kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
> -
>  	if (ret)
>  		return ret;
> =20
> @@ -1656,6 +1651,13 @@ static int __init kvm_mips_init(void)
> =20
>  	register_die_notifier(&kvm_mips_csr_die_notifier);
> =20
> +	ret =3D kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
> +
> +	if (ret) {
> +		unregister_die_notifier(&kvm_mips_csr_die_notifier);
> +		return ret;
> +	}
> +
>  	return 0;
>  }
> =20
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 31e7630203fd..d3b68a6dec48 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8372,6 +8372,15 @@ static void vmx_exit(void)
>  }
>  module_exit(vmx_exit);
> =20
> +/* initialize before kvm_init() so that hardware_enable/disable() can wo=
rk. */
> +static void __init vmx_init_early(void)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu)
> +		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> +}
> +
>  static int __init vmx_init(void)
>  {
>  	int r, cpu;
> @@ -8409,6 +8418,7 @@ static int __init vmx_init(void)
>  	}
>  #endif
> =20
> +	vmx_init_early();
>  	r =3D kvm_init(&vmx_init_ops, sizeof(struct vcpu_vmx),
>  		     __alignof__(struct vcpu_vmx), THIS_MODULE);
>  	if (r)
> @@ -8427,11 +8437,8 @@ static int __init vmx_init(void)
>  		return r;
>  	}
> =20
> -	for_each_possible_cpu(cpu) {
> -		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
> -
> +	for_each_possible_cpu(cpu)
>  		pi_init_cpu(cpu);
> -	}
> =20
>  #ifdef CONFIG_KEXEC_CORE
>  	rcu_assign_pointer(crash_vmclear_loaded_vmcss,
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d4f130a9f5c8..79a4988fd51f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1441,6 +1441,7 @@ void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *=
vcpu, struct dentry *debugfs_
>  int kvm_arch_hardware_enable(void);
>  void kvm_arch_hardware_disable(void);
>  int kvm_arch_hardware_setup(void *opaque);
> +int kvm_arch_post_hardware_enable_setup(void *opaque);
>  void kvm_arch_hardware_unsetup(void);
>  int kvm_arch_check_processor_compat(void);
>  int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a5bada53f1fe..cee799265ce6 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4899,8 +4899,13 @@ static void hardware_enable_nolock(void *junk)
> =20
>  	cpumask_set_cpu(cpu, cpus_hardware_enabled);
> =20
> +	r =3D kvm_arch_check_processor_compat();
> +	if (r)
> +		goto out;
> +
>  	r =3D kvm_arch_hardware_enable();
> =20
> +out:
>  	if (r) {
>  		cpumask_clear_cpu(cpu, cpus_hardware_enabled);
>  		atomic_inc(&hardware_enable_failed);
> @@ -5697,9 +5702,9 @@ void kvm_unregister_perf_callbacks(void)
>  }
>  #endif
> =20
> -static void check_processor_compat(void *rtn)
> +__weak int kvm_arch_post_hardware_enable_setup(void *opaque)
>  {
> -	*(int *)rtn =3D kvm_arch_check_processor_compat();
> +	return 0;
>  }
> =20
>  int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
> @@ -5732,11 +5737,17 @@ int kvm_init(void *opaque, unsigned vcpu_size, un=
signed vcpu_align,
>  	if (r < 0)
>  		goto out_free_1;
> =20
> -	for_each_online_cpu(cpu) {
> -		smp_call_function_single(cpu, check_processor_compat, &r, 1);
> -		if (r < 0)
> -			goto out_free_2;
> -	}
> +	/* hardware_enable_nolock() checks CPU compatibility on each CPUs. */
> +	r =3D hardware_enable_all();
> +	if (r)
> +		goto out_free_2;
> +	/*
> +	 * Arch specific initialization that requires to enable virtualization
> +	 * feature.  e.g. TDX module initialization requires VMXON on all
> +	 * present CPUs.
> +	 */
> +	kvm_arch_post_hardware_enable_setup(opaque);

Please see my reply to your patch  "KVM: TDX: Initialize TDX module when lo=
ading
kvm_intel.ko".

The introduce of __weak kvm_arch_post_hardware_enable_setup() should be in =
that
patch since it has nothing to do the job you claimed to do in this patch.

And by removing it, this patch can be taken out of TDX series and upstreame=
d
separately.

> +	hardware_disable_all();
> =20
>  	r =3D cpuhp_setup_state_nocalls(CPUHP_AP_KVM_STARTING, "kvm/cpu:startin=
g",
>  				      kvm_starting_cpu, kvm_dying_cpu);

