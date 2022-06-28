Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F199E55DBA4
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243824AbiF1Cwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 22:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243945AbiF1Cwd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 22:52:33 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FE710EF;
        Mon, 27 Jun 2022 19:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656384752; x=1687920752;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=UfFqc0h8Kx8Kp0A6TYOU/BgVN9CIyo8n4aZ9J5s0d+8=;
  b=FMIIf8ovVWhk+G7kYKOILQnsKmkfDS7QPXaHrLSw+V5Q/zavo6dA5eph
   rAHqdEUu++NOGPu5Emo+TWHNHiySqwW1mBlMU6KrpYBymfUTxF+lMX2IX
   qQCMbzIyk4w3j6TblPS+zavw/Sn05oeBM01KSdndH0x7vxVyvP68BcLW0
   iF9hVZztTIa4y3tLkdjvqK/fPNbWhgk3LHuPjZONNN5XezHibY4SGUoug
   RtE+7+hwZJkvbJCkpY+5RJzc5Bq4j62cPfgVDHVvmRjBiODATsQgUkJEI
   +8IvZx5V3YnamcUuyaIxe+35qRK6yaIqzpT3WjdAJev7CVBttV7hxCkCE
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="345614885"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="345614885"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 19:52:32 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="540334410"
Received: from iiturbeo-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.89.183])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 19:52:30 -0700
Message-ID: <3c5d4e38b631a921006e44551fe1249339393e41.camel@intel.com>
Subject: Re: [PATCH v7 012/102] KVM: x86: Introduce vm_type to differentiate
 default VMs from confidential VMs
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Date:   Tue, 28 Jun 2022 14:52:28 +1200
In-Reply-To: <5979d880dc074c7fa57e02da34a41a6905ebd89d.1656366338.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
         <5979d880dc074c7fa57e02da34a41a6905ebd89d.1656366338.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>=20
> Unlike default VMs, confidential VMs (Intel TDX and AMD SEV-ES) don't all=
ow
> some operations (e.g., memory read/write, register state access, etc).
>=20
> Introduce vm_type to track the type of the VM to x86 KVM.  Other arch KVM=
s
> already use vm_type, KVM_INIT_VM accepts vm_type, and x86 KVM callback
> vm_init accepts vm_type.  So follow them.  Further, a different policy ca=
n
> be made based on vm_type.  Define KVM_X86_DEFAULT_VM for default VM as
> default and define KVM_X86_TDX_VM for Intel TDX VM.  The wrapper function
> will be defined as "bool is_td(kvm) { return vm_type =3D=3D VM_TYPE_TDX; =
}"
>=20
> Add a capability KVM_CAP_VM_TYPES to effectively allow device model,
> e.g. qemu, to query what VM types are supported by KVM.  This (introduce =
a
> new capability and add vm_type) is chosen to align with other arch KVMs
> that have VM types already.  Other arch KVMs uses different name to query
> supported vm types and there is no common name for it, so new name was
> chosen.
>=20
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  Documentation/virt/kvm/api.rst        | 21 +++++++++++++++++++++
>  arch/x86/include/asm/kvm-x86-ops.h    |  1 +
>  arch/x86/include/asm/kvm_host.h       |  2 ++
>  arch/x86/include/uapi/asm/kvm.h       |  3 +++
>  arch/x86/kvm/svm/svm.c                |  6 ++++++
>  arch/x86/kvm/vmx/main.c               |  1 +
>  arch/x86/kvm/vmx/tdx.h                |  6 +-----
>  arch/x86/kvm/vmx/vmx.c                |  5 +++++
>  arch/x86/kvm/vmx/x86_ops.h            |  1 +
>  arch/x86/kvm/x86.c                    |  9 ++++++++-
>  include/uapi/linux/kvm.h              |  1 +
>  tools/arch/x86/include/uapi/asm/kvm.h |  3 +++
>  tools/include/uapi/linux/kvm.h        |  1 +
>  13 files changed, 54 insertions(+), 6 deletions(-)
>=20
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.=
rst
> index 9cbbfdb663b6..b9ab598883b2 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -147,10 +147,31 @@ described as 'basic' will be available.
>  The new VM has no virtual cpus and no memory.
>  You probably want to use 0 as machine type.
> =20
> +X86:
> +^^^^
> +
> +Supported vm type can be queried from KVM_CAP_VM_TYPES, which returns th=
e
> +bitmap of supported vm types. The 1-setting of bit @n means vm type with
> +value @n is supported.


Perhaps I am missing something, but I don't understand how the below change=
s
(except the x86 part above) in Documentation are related to this patch.

> +
> +S390:
> +^^^^^
> +
>  In order to create user controlled virtual machines on S390, check
>  KVM_CAP_S390_UCONTROL and use the flag KVM_VM_S390_UCONTROL as
>  privileged user (CAP_SYS_ADMIN).
> =20
> +MIPS:
> +^^^^^
> +
> +To use hardware assisted virtualization on MIPS (VZ ASE) rather than
> +the default trap & emulate implementation (which changes the virtual
> +memory layout to fit in user mode), check KVM_CAP_MIPS_VZ and use the
> +flag KVM_VM_MIPS_VZ.
> +
> +ARM64:
> +^^^^^^
> +
>  On arm64, the physical address size for a VM (IPA Size limit) is limited
>  to 40bits by default. The limit can be configured if the host supports t=
he
>  extension KVM_CAP_ARM_VM_IPA_SIZE. When supported, use
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kv=
m-x86-ops.h
> index 75bc44aa8d51..a97cdb203a16 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -19,6 +19,7 @@ KVM_X86_OP(hardware_disable)
>  KVM_X86_OP(hardware_unsetup)
>  KVM_X86_OP(has_emulated_msr)
>  KVM_X86_OP(vcpu_after_set_cpuid)
> +KVM_X86_OP(is_vm_type_supported)
>  KVM_X86_OP(vm_init)
>  KVM_X86_OP_OPTIONAL(vm_destroy)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index aa11525500d3..089e0a4de926 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1141,6 +1141,7 @@ enum kvm_apicv_inhibit {
>  };
> =20
>  struct kvm_arch {
> +	unsigned long vm_type;
>  	unsigned long n_used_mmu_pages;
>  	unsigned long n_requested_mmu_pages;
>  	unsigned long n_max_mmu_pages;
> @@ -1434,6 +1435,7 @@ struct kvm_x86_ops {
>  	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
>  	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
> =20
> +	bool (*is_vm_type_supported)(unsigned long vm_type);
>  	unsigned int vm_size;
>  	int (*vm_init)(struct kvm *kvm);
>  	void (*vm_destroy)(struct kvm *kvm);
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/=
kvm.h
> index 50a4e787d5e6..9792ec1cc317 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -531,4 +531,7 @@ struct kvm_pmu_event_filter {
>  #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (=
TSC) */
>  #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
> =20
> +#define KVM_X86_DEFAULT_VM	0
> +#define KVM_X86_TDX_VM		1
> +
>  #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 247c0ad458a0..815a07c594f1 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4685,6 +4685,11 @@ static void svm_vm_destroy(struct kvm *kvm)
>  	sev_vm_destroy(kvm);
>  }
> =20
> +static bool svm_is_vm_type_supported(unsigned long type)
> +{
> +	return type =3D=3D KVM_X86_DEFAULT_VM;
> +}
> +
>  static int svm_vm_init(struct kvm *kvm)
>  {
>  	if (!pause_filter_count || !pause_filter_thresh)
> @@ -4712,6 +4717,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata =
=3D {
>  	.vcpu_free =3D svm_vcpu_free,
>  	.vcpu_reset =3D svm_vcpu_reset,
> =20
> +	.is_vm_type_supported =3D svm_is_vm_type_supported,
>  	.vm_size =3D sizeof(struct kvm_svm),
>  	.vm_init =3D svm_vm_init,
>  	.vm_destroy =3D svm_vm_destroy,
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index ac788af17d92..7be4941e4c4d 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -43,6 +43,7 @@ struct kvm_x86_ops vt_x86_ops __initdata =3D {
>  	.hardware_disable =3D vmx_hardware_disable,
>  	.has_emulated_msr =3D vmx_has_emulated_msr,
> =20
> +	.is_vm_type_supported =3D vmx_is_vm_type_supported,
>  	.vm_size =3D sizeof(struct kvm_vmx),
>  	.vm_init =3D vmx_vm_init,
>  	.vm_destroy =3D vmx_vm_destroy,
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 54d7a26ed9ee..2f43db5bbefb 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -17,11 +17,7 @@ struct vcpu_tdx {
> =20
>  static inline bool is_td(struct kvm *kvm)
>  {
> -	/*
> -	 * TDX VM type isn't defined yet.
> -	 * return kvm->arch.vm_type =3D=3D KVM_X86_TDX_VM;
> -	 */
> -	return false;
> +	return kvm->arch.vm_type =3D=3D KVM_X86_TDX_VM;
>  }

If you put this patch before patch:

	[PATCH v7 009/102] KVM: TDX: Add placeholders for TDX VM/vcpu structure

Then you don't need to introduce this chunk in above patch and then remove =
it
here, which is unnecessary and ugly.

And you can even only introduce KVM_X86_DEFAULT_VM but not KVM_X86_TDX_VM i=
n
this patch, so you can make this patch as a infrastructural patch to report=
 VM
type.  The KVM_X86_TDX_VM can come with the patch where is_td() is introduc=
ed
(in your above patch 9). =C2=A0

To me, it's more clean way to write patch.  For instance, this infrastructu=
ral
patch can be theoretically used by other series if they have similar thing =
to
support, but doesn't need to carry is_td() and KVM_X86_TDX_VM burden that y=
ou
made.

> =20
>  static inline bool is_td_vcpu(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b30d73d28e75..5ba62f8b42ce 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7281,6 +7281,11 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
>  	return err;
>  }
> =20
> +bool vmx_is_vm_type_supported(unsigned long type)
> +{
> +	return type =3D=3D KVM_X86_DEFAULT_VM;
> +}
> +
>  #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possibl=
e. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide=
/hw-vuln/l1tf.html for details.\n"
>  #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation=
 disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org=
/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
> =20
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 2abead2f60f7..a5e85eb4e183 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -25,6 +25,7 @@ void vmx_hardware_unsetup(void);
>  int vmx_check_processor_compatibility(void);
>  int vmx_hardware_enable(void);
>  void vmx_hardware_disable(void);
> +bool vmx_is_vm_type_supported(unsigned long type);
>  int vmx_vm_init(struct kvm *kvm);
>  void vmx_vm_destroy(struct kvm *kvm);
>  int vmx_vcpu_precreate(struct kvm *kvm);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fb7a33fbc136..96dc8f52a137 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4408,6 +4408,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, =
long ext)
>  	case KVM_CAP_X86_NOTIFY_VMEXIT:
>  		r =3D kvm_caps.has_notify_vmexit;
>  		break;
> +	case KVM_CAP_VM_TYPES:
> +		r =3D BIT(KVM_X86_DEFAULT_VM);
> +		if (static_call(kvm_x86_is_vm_type_supported)(KVM_X86_TDX_VM))
> +			r |=3D BIT(KVM_X86_TDX_VM);
> +		break;
>  	default:
>  		break;
>  	}
> @@ -11858,9 +11863,11 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned l=
ong type)
>  	int ret;
>  	unsigned long flags;
> =20
> -	if (type)
> +	if (!static_call(kvm_x86_is_vm_type_supported)(type))
>  		return -EINVAL;
> =20
> +	kvm->arch.vm_type =3D type;
> +
>  	ret =3D kvm_page_track_init(kvm);
>  	if (ret)
>  		goto out;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 7569b4ec199c..6d6785d2685f 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1166,6 +1166,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_S390_PROTECTED_DUMP 217
>  #define KVM_CAP_X86_TRIPLE_FAULT_EVENT 218
>  #define KVM_CAP_X86_NOTIFY_VMEXIT 219
> +#define KVM_CAP_VM_TYPES 220
> =20
>  #ifdef KVM_CAP_IRQ_ROUTING
> =20
> diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/inclu=
de/uapi/asm/kvm.h
> index bf6e96011dfe..71a5851475e7 100644
> --- a/tools/arch/x86/include/uapi/asm/kvm.h
> +++ b/tools/arch/x86/include/uapi/asm/kvm.h
> @@ -525,4 +525,7 @@ struct kvm_pmu_event_filter {
>  #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (=
TSC) */
>  #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
> =20
> +#define KVM_X86_DEFAULT_VM	0
> +#define KVM_X86_TDX_VM		1
> +
>  #endif /* _ASM_X86_KVM_H */
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kv=
m.h
> index 6a184d260c7f..1e89b967e050 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -1152,6 +1152,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_DISABLE_QUIRKS2 213
>  /* #define KVM_CAP_VM_TSC_CONTROL 214 */
>  #define KVM_CAP_SYSTEM_EVENT_DATA 215
> +#define KVM_CAP_VM_TYPES 220
> =20
>  #ifdef KVM_CAP_IRQ_ROUTING
> =20

--=20
Thanks,
-Kai


