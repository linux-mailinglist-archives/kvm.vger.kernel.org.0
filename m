Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB4E6DD785
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 12:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjDKKJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 06:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjDKKJS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 06:09:18 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518FE2683;
        Tue, 11 Apr 2023 03:09:16 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id 38308e7fff4ca-2a76ef2a6cbso218731fa.0;
        Tue, 11 Apr 2023 03:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681207754; x=1683799754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bwleV0CUAeGT8tuXPsQz1019CH9QCgOOPQO59NHIIRw=;
        b=clUeZ+QvxtRjRj7B2vuPh0lY8+ZZOu8MT1JB5FvsLsJ3662gfX0I2moNA+CahTmgzU
         arhfbJyxg9Za6AiCWFz0ZEIwUMYqnQQ2KjnP8LcEY/pLaoI10nbdvacjzJ/RDnmyZycJ
         VnuRVTWfxWSjrGdUxfusJAvZ1fBzTo1YtpkVjmtYlukLIiBeg5MD0V5hyZ3lz1xOM0PI
         o8Szyl2JqKYcTr6ict3BvdjOA99r8VkbHvRntOj2ryeJTvs4LrgDAdk74y8H2rpG/2Pw
         6OV/aWA6dkTM78hmvhrLPC0vySeHkd435t/iROE57cpw/FeOuKNtem5wwAKEwsnyAE8c
         Gc1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681207754; x=1683799754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bwleV0CUAeGT8tuXPsQz1019CH9QCgOOPQO59NHIIRw=;
        b=OmAGpvKVk9frhFglPt1WmEAHxds7hIYibMxtVfvTq0qWvh11sDswHhp8gvsDgfHs3F
         XodzZ/n5A/cKdnmuZJOwDeYyZOWK6bsHP2wSpstKDcHRHrkZ15/8oHpjJuU0bfYONzLy
         gs1+7cP5qnhAAVvIZYnvECdARWiQdDMgapQcdmWG/+3GDsigqqmWurQyn0/rv1b466Vd
         ob1tLmYXZLuWQkmyXIfsxpTlsO+rI6jZCm6LcmDuaUbt4qBAP8Xcn/ps1+k9H+BTJEDa
         kBNq6GUOKDfTE20bbaWD7SidqSWjVnxfuEujDVmkeYtS/cLabpzgfPq6nfG8VN2MBICl
         iv7w==
X-Gm-Message-State: AAQBX9eQcP0q3n5Ik27hKQ8sHusvsIKA2fx25TwVyJTdn0yqNvvUpduR
        w97yYEcq7KRJiN3+Hn9XiuJfaaqStbM=
X-Google-Smtp-Source: AKy350btViDBPpoHkPC4lScvfYpmg0cCX0/vWXAhc1HACNR4t2sBzJL/nVAa70Z3Fg9wM1TlNydyYA==
X-Received: by 2002:a05:651c:897:b0:298:a8bc:b4d4 with SMTP id d23-20020a05651c089700b00298a8bcb4d4mr3116350ljq.4.1681207754304;
        Tue, 11 Apr 2023 03:09:14 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id e22-20020a2e9e16000000b0029df8e31785sm2634849ljk.107.2023.04.11.03.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 03:09:14 -0700 (PDT)
Date:   Tue, 11 Apr 2023 13:09:11 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Michael Roth <michael.roth@amd.com>
Subject: Re: [PATCH v12 5/6] KVM: x86: Introduce vm_type to differentiate
 default VMs from confidential VMs
Message-ID: <20230411130911.000070ed.zhi.wang.linux@gmail.com>
In-Reply-To: <fa6b8135913c7ad7c616da1dba162c860c246dfb.1677632938.git.isaku.yamahata@intel.com>
References: <b17eee6a7d5379bf16419c0b38ed99433afbf62f.1677632938.git.isaku.yamahata@intel.com>
        <fa6b8135913c7ad7c616da1dba162c860c246dfb.1677632938.git.isaku.yamahata@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Feb 2023 17:19:15 -0800
isaku.yamahata@intel.com wrote:

> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Unlike default VMs, confidential VMs (Intel TDX and AMD SEV-ES) don't allow
> some operations (e.g., memory read/write, register state access, etc).
> 
> Introduce vm_type to track the type of the VM to x86 KVM.  Other arch KVMs
> already use vm_type, KVM_INIT_VM accepts vm_type, and x86 KVM callback
> vm_init accepts vm_type.  So follow them.  Further, a different policy can
> be made based on vm_type.  Define KVM_X86_DEFAULT_VM for default VM as
> default and define KVM_X86_TDX_VM for Intel TDX VM.  The wrapper function
> will be defined as "bool is_td(kvm) { return vm_type == VM_TYPE_TDX; }"
> 

Where is the KVM_X86_TDX_VM? It seems the comments are out of date. I guess
KVM_X86_PROTECTED_VM means a generic CC VM now, not specifically to SNP
or TDX.

Is it possible to have an additional vendor (TDX/SNP) VM type besides
KVM_X86_PROTECTED_VM? Although QEMU knows if SEV driver is existing or not
in a system by checking "/dev/sev", the only way it can know if KVM supports
SNP is to check KVM_X86_PROTECTED_VM through the KVM_CAP_VM_TYPES. For TDX,
QEMU only sees KVM_X86_PROTECTED_VM is set and !SEV_DRIVER. This doesn't
seems very clear to QEMU.

Is it better to split the bits in vm_type into two parts of bit fields: a.
generic part: (KVM_X86_{DEFAULT,PROTECTED}_VM). b. vendor part:
KVM_X86_{TDX,SNP}_PROTECTED_VM?

The KVM can still use KVM_X86_PROTECTED_VM in the code flow to deal with non-
vendor specific matter.

When QEMU queries the KVM_CAP_VM_TYPES, besides checking the vm_type in kvm_x86_is_vm_type_supported, KVM also let the vendor callback to set the
KVM_X86_{TDX,SNP}_PROTECTED_VM in the vendor part. Then QEMU would receive a
cap return value with (KVM_X86_PROTECTED_VM | KVM_X86_{TDX,SNP}_PROTECTED_VM)
and immediately know which bunch of the ioctls {TDX/SNP} are available in KVM.

> Add a capability KVM_CAP_VM_TYPES to effectively allow device model,
> e.g. qemu, to query what VM types are supported by KVM.  This (introduce a
> new capability and add vm_type) is chosen to align with other arch KVMs
> that have VM types already.  Other arch KVMs use different names to query
> supported vm types and there is no common name for it, so new name was
> chosen.
> 
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  Documentation/virt/kvm/api.rst        | 4 +++-
>  arch/x86/include/asm/kvm-x86-ops.h    | 1 +
>  arch/x86/include/asm/kvm_host.h       | 1 +
>  arch/x86/kvm/svm/svm.c                | 7 +++++++
>  arch/x86/kvm/vmx/main.c               | 1 +
>  arch/x86/kvm/vmx/vmx.c                | 5 +++++
>  arch/x86/kvm/vmx/x86_ops.h            | 1 +
>  arch/x86/kvm/x86.c                    | 8 +++++++-
>  arch/x86/kvm/x86.h                    | 2 ++
>  tools/arch/x86/include/uapi/asm/kvm.h | 3 +++
>  tools/include/uapi/linux/kvm.h        | 1 +
>  11 files changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 191aabc3af8c..fbff5cd6e404 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -150,7 +150,9 @@ You probably want to use 0 as machine type.
>  X86:
>  ^^^^
>  
> -Supported X86 VM types can be queried via KVM_CAP_VM_TYPES.
> +Supported X86 VM types can be queried via KVM_CAP_VM_TYPES, which returns the
> +bitmap of supported vm types. The 1-setting of bit @n means vm type with value
> +@n is supported.
>  
>  S390:
>  ^^^^^
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 8dc345cc6318..eac4b65d1b01 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -20,6 +20,7 @@ KVM_X86_OP(hardware_disable)
>  KVM_X86_OP(hardware_unsetup)
>  KVM_X86_OP(has_emulated_msr)
>  KVM_X86_OP(vcpu_after_set_cpuid)
> +KVM_X86_OP(is_vm_type_supported)
>  KVM_X86_OP(vm_init)
>  KVM_X86_OP_OPTIONAL(vm_destroy)
>  KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 8344945dece3..ffb85c35cacc 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1546,6 +1546,7 @@ struct kvm_x86_ops {
>  	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
>  	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
>  
> +	bool (*is_vm_type_supported)(unsigned long vm_type);
>  	unsigned int vm_size;
>  	int (*vm_init)(struct kvm *kvm);
>  	void (*vm_destroy)(struct kvm *kvm);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 8ed7e177e73d..d0b01956e420 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4682,6 +4682,12 @@ static void svm_vm_destroy(struct kvm *kvm)
>  	sev_vm_destroy(kvm);
>  }
>  
> +static bool svm_is_vm_type_supported(unsigned long type)
> +{
> +	/* FIXME: Check if CPU is capable of SEV. */
> +	return __kvm_is_vm_type_supported(type);
> +}
> +
>  static int svm_vm_init(struct kvm *kvm)
>  {
>  	if (!pause_filter_count || !pause_filter_thresh)
> @@ -4710,6 +4716,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>  	.vcpu_free = svm_vcpu_free,
>  	.vcpu_reset = svm_vcpu_reset,
>  
> +	.is_vm_type_supported = svm_is_vm_type_supported,
>  	.vm_size = sizeof(struct kvm_svm),
>  	.vm_init = svm_vm_init,
>  	.vm_destroy = svm_vm_destroy,
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index d21a7c7d18ea..e1bbe06517b7 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -45,6 +45,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>  	.hardware_disable = vmx_hardware_disable,
>  	.has_emulated_msr = vmx_has_emulated_msr,
>  
> +	.is_vm_type_supported = vmx_is_vm_type_supported,
>  	.vm_size = sizeof(struct kvm_vmx),
>  	.vm_init = vmx_vm_init,
>  	.vm_destroy = vmx_vm_destroy,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index bddbdd2988f4..5bfdfc6f2190 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7470,6 +7470,11 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
>  	return err;
>  }
>  
> +bool vmx_is_vm_type_supported(unsigned long type)
> +{
> +	return type == KVM_X86_DEFAULT_VM;
> +}
> +
>  #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
>  #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
>  
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 0f200aead411..e4dae9842550 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -32,6 +32,7 @@ void vmx_hardware_unsetup(void);
>  int vmx_check_processor_compat(void);
>  int vmx_hardware_enable(void);
>  void vmx_hardware_disable(void);
> +bool vmx_is_vm_type_supported(unsigned long type);
>  int vmx_vm_init(struct kvm *kvm);
>  void vmx_vm_destroy(struct kvm *kvm);
>  int vmx_vcpu_precreate(struct kvm *kvm);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 45330273bad6..589844a27349 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4352,12 +4352,18 @@ static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> -static bool kvm_is_vm_type_supported(unsigned long type)
> +bool __kvm_is_vm_type_supported(unsigned long type)
>  {
>  	return type == KVM_X86_DEFAULT_VM ||
>  	       (type == KVM_X86_PROTECTED_VM &&
>  	        IS_ENABLED(CONFIG_KVM_PROTECTED_VM) && tdp_enabled);
>  }
> +EXPORT_SYMBOL_GPL(__kvm_is_vm_type_supported);
> +
> +static bool kvm_is_vm_type_supported(unsigned long type)
> +{
> +	return static_call(kvm_x86_is_vm_type_supported)(type);
> +}
>  
>  int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  {
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 9de72586f406..888f34224bba 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -8,6 +8,8 @@
>  #include "kvm_cache_regs.h"
>  #include "kvm_emulate.h"
>  
> +bool __kvm_is_vm_type_supported(unsigned long type);
> +
>  struct kvm_caps {
>  	/* control of guest tsc rate supported? */
>  	bool has_tsc_control;
> diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
> index e48deab8901d..53ce363ba5fe 100644
> --- a/tools/arch/x86/include/uapi/asm/kvm.h
> +++ b/tools/arch/x86/include/uapi/asm/kvm.h
> @@ -529,4 +529,7 @@ struct kvm_pmu_event_filter {
>  #define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
>  #define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
>  
> +#define KVM_X86_DEFAULT_VM	0
> +#define KVM_X86_PROTECTED_VM	1
> +
>  #endif /* _ASM_X86_KVM_H */
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index 55155e262646..63474f72ea34 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -1175,6 +1175,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
>  #define KVM_CAP_S390_PROTECTED_ASYNC_DISABLE 224
>  #define KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP 225
> +#define KVM_CAP_VM_TYPES 227
>  
>  #ifdef KVM_CAP_IRQ_ROUTING
>  

