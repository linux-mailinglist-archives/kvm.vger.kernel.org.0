Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8089E49C91
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 11:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729161AbfFRJDc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 05:03:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53656 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728754AbfFRJDc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jun 2019 05:03:32 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 591633092664;
        Tue, 18 Jun 2019 09:03:23 +0000 (UTC)
Received: from work-vm (ovpn-117-76.ams2.redhat.com [10.36.117.76])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CCCE82A35;
        Tue, 18 Jun 2019 09:03:20 +0000 (UTC)
Date:   Tue, 18 Jun 2019 10:03:17 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, mtosatti@redhat.com,
        rth@twiddle.net, ehabkost@redhat.com, kvm@vger.kernel.org,
        jmattson@google.com, maran.wilson@oracle.com,
        Nikita Leshenko <nikita.leshchenko@oracle.com>
Subject: Re: [QEMU PATCH v3 7/9] KVM: i386: Add support for save and restore
 nested state
Message-ID: <20190618090316.GC2850@work-vm>
References: <20190617175658.135869-1-liran.alon@oracle.com>
 <20190617175658.135869-8-liran.alon@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617175658.135869-8-liran.alon@oracle.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 18 Jun 2019 09:03:31 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Liran Alon (liran.alon@oracle.com) wrote:
> Kernel commit 8fcc4b5923af ("kvm: nVMX: Introduce KVM_CAP_NESTED_STATE")
> introduced new IOCTLs to extract and restore vCPU state related to
> Intel VMX & AMD SVM.
> 
> Utilize these IOCTLs to add support for migration of VMs which are
> running nested hypervisors.
> 
> Reviewed-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  accel/kvm/kvm-all.c   |   8 ++
>  include/sysemu/kvm.h  |   1 +
>  target/i386/cpu.h     |   3 +
>  target/i386/kvm.c     |  80 +++++++++++++++++
>  target/i386/machine.c | 196 ++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 288 insertions(+)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 59a3aa3a40da..4fdf5b04b131 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -88,6 +88,7 @@ struct KVMState
>  #ifdef KVM_CAP_SET_GUEST_DEBUG
>      QTAILQ_HEAD(, kvm_sw_breakpoint) kvm_sw_breakpoints;
>  #endif
> +    int max_nested_state_len;
>      int many_ioeventfds;
>      int intx_set_mask;
>      bool sync_mmu;
> @@ -1678,6 +1679,8 @@ static int kvm_init(MachineState *ms)
>      s->debugregs = kvm_check_extension(s, KVM_CAP_DEBUGREGS);
>  #endif
>  
> +    s->max_nested_state_len = kvm_check_extension(s, KVM_CAP_NESTED_STATE);
> +
>  #ifdef KVM_CAP_IRQ_ROUTING
>      kvm_direct_msi_allowed = (kvm_check_extension(s, KVM_CAP_SIGNAL_MSI) > 0);
>  #endif
> @@ -2245,6 +2248,11 @@ int kvm_has_debugregs(void)
>      return kvm_state->debugregs;
>  }
>  
> +int kvm_max_nested_state_length(void)
> +{
> +    return kvm_state->max_nested_state_len;
> +}
> +
>  int kvm_has_many_ioeventfds(void)
>  {
>      if (!kvm_enabled()) {
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index 64f55e519df7..acd90aebb6c4 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -210,6 +210,7 @@ bool kvm_has_sync_mmu(void);
>  int kvm_has_vcpu_events(void);
>  int kvm_has_robust_singlestep(void);
>  int kvm_has_debugregs(void);
> +int kvm_max_nested_state_length(void);
>  int kvm_has_pit_state2(void);
>  int kvm_has_many_ioeventfds(void);
>  int kvm_has_gsi_routing(void);
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 79d9495ceb0c..a6bb71849869 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1350,6 +1350,9 @@ typedef struct CPUX86State {
>  #if defined(CONFIG_KVM) || defined(CONFIG_HVF)
>      void *xsave_buf;
>  #endif
> +#if defined(CONFIG_KVM)
> +    struct kvm_nested_state *nested_state;
> +#endif
>  #if defined(CONFIG_HVF)
>      HVFX86EmulatorState *hvf_emul;
>  #endif
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index f43e2d69859e..5950c3ed0d1c 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -931,6 +931,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      struct kvm_cpuid_entry2 *c;
>      uint32_t signature[3];
>      int kvm_base = KVM_CPUID_SIGNATURE;
> +    int max_nested_state_len;
>      int r;
>      Error *local_err = NULL;
>  
> @@ -1331,6 +1332,24 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      if (has_xsave) {
>          env->xsave_buf = qemu_memalign(4096, sizeof(struct kvm_xsave));
>      }
> +
> +    max_nested_state_len = kvm_max_nested_state_length();
> +    if (max_nested_state_len > 0) {
> +        assert(max_nested_state_len >= offsetof(struct kvm_nested_state, data));
> +        env->nested_state = g_malloc0(max_nested_state_len);
> +
> +        env->nested_state->size = max_nested_state_len;
> +
> +        if (IS_INTEL_CPU(env)) {
> +            struct kvm_vmx_nested_state_hdr *vmx_hdr =
> +                &env->nested_state->hdr.vmx;
> +
> +            vmx_hdr->vmxon_pa = -1ull;
> +            vmx_hdr->vmcs12_pa = -1ull;
> +        }
> +
> +    }
> +
>      cpu->kvm_msr_buf = g_malloc0(MSR_BUF_SIZE);
>  
>      if (!(env->features[FEAT_8000_0001_EDX] & CPUID_EXT2_RDTSCP)) {
> @@ -1352,12 +1371,18 @@ int kvm_arch_init_vcpu(CPUState *cs)
>  int kvm_arch_destroy_vcpu(CPUState *cs)
>  {
>      X86CPU *cpu = X86_CPU(cs);
> +    CPUX86State *env = &cpu->env;
>  
>      if (cpu->kvm_msr_buf) {
>          g_free(cpu->kvm_msr_buf);
>          cpu->kvm_msr_buf = NULL;
>      }
>  
> +    if (env->nested_state) {
> +        g_free(env->nested_state);
> +        env->nested_state = NULL;
> +    }
> +
>      return 0;
>  }
>  
> @@ -3072,6 +3097,52 @@ static int kvm_get_debugregs(X86CPU *cpu)
>      return 0;
>  }
>  
> +static int kvm_put_nested_state(X86CPU *cpu)
> +{
> +    CPUX86State *env = &cpu->env;
> +    int max_nested_state_len = kvm_max_nested_state_length();
> +
> +    if (max_nested_state_len <= 0) {
> +        return 0;
> +    }
> +
> +    assert(env->nested_state->size <= max_nested_state_len);
> +    return kvm_vcpu_ioctl(CPU(cpu), KVM_SET_NESTED_STATE, env->nested_state);
> +}
> +
> +static int kvm_get_nested_state(X86CPU *cpu)
> +{
> +    CPUX86State *env = &cpu->env;
> +    int max_nested_state_len = kvm_max_nested_state_length();
> +    int ret;
> +
> +    if (max_nested_state_len <= 0) {
> +        return 0;
> +    }
> +
> +    /*
> +     * It is possible that migration restored a smaller size into
> +     * nested_state->hdr.size than what our kernel support.
> +     * We preserve migration origin nested_state->hdr.size for
> +     * call to KVM_SET_NESTED_STATE but wish that our next call
> +     * to KVM_GET_NESTED_STATE will use max size our kernel support.
> +     */
> +    env->nested_state->size = max_nested_state_len;
> +
> +    ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_NESTED_STATE, env->nested_state);
> +    if (ret < 0) {
> +        return ret;
> +    }
> +
> +    if (env->nested_state->flags & KVM_STATE_NESTED_GUEST_MODE) {
> +        env->hflags |= HF_GUEST_MASK;
> +    } else {
> +        env->hflags &= ~HF_GUEST_MASK;
> +    }
> +
> +    return ret;
> +}
> +
>  int kvm_arch_put_registers(CPUState *cpu, int level)
>  {
>      X86CPU *x86_cpu = X86_CPU(cpu);
> @@ -3079,6 +3150,11 @@ int kvm_arch_put_registers(CPUState *cpu, int level)
>  
>      assert(cpu_is_stopped(cpu) || qemu_cpu_is_self(cpu));
>  
> +    ret = kvm_put_nested_state(x86_cpu);
> +    if (ret < 0) {
> +        return ret;
> +    }
> +
>      if (level >= KVM_PUT_RESET_STATE) {
>          ret = kvm_put_msr_feature_control(x86_cpu);
>          if (ret < 0) {
> @@ -3194,6 +3270,10 @@ int kvm_arch_get_registers(CPUState *cs)
>      if (ret < 0) {
>          goto out;
>      }
> +    ret = kvm_get_nested_state(cpu);
> +    if (ret < 0) {
> +        goto out;
> +    }
>      ret = 0;
>   out:
>      cpu_sync_bndcs_hflags(&cpu->env);
> diff --git a/target/i386/machine.c b/target/i386/machine.c
> index 225b5d433bc4..95299ebff44a 100644
> --- a/target/i386/machine.c
> +++ b/target/i386/machine.c
> @@ -231,6 +231,15 @@ static int cpu_pre_save(void *opaque)
>          env->segs[R_SS].flags &= ~(env->segs[R_SS].flags & DESC_DPL_MASK);
>      }
>  
> +#ifdef CONFIG_KVM
> +    /* Verify we have nested virtualization state from kernel if required */
> +    if (cpu_has_nested_virt(env) && !env->nested_state) {
> +        error_report("Guest enabled nested virtualization but kernel "
> +                "does not support saving of nested state");
> +        return -EINVAL;
> +    }
> +#endif
> +
>      return 0;
>  }
>  
> @@ -278,6 +287,16 @@ static int cpu_post_load(void *opaque, int version_id)
>      env->hflags &= ~HF_CPL_MASK;
>      env->hflags |= (env->segs[R_SS].flags >> DESC_DPL_SHIFT) & HF_CPL_MASK;
>  
> +#ifdef CONFIG_KVM
> +    if ((env->hflags & HF_GUEST_MASK) &&
> +        (!env->nested_state ||
> +        !(env->nested_state->flags & KVM_STATE_NESTED_GUEST_MODE))) {
> +        error_report("vCPU set in guest-mode inconsistent with "
> +                     "migrated kernel nested state");
> +        return -EINVAL;
> +    }
> +#endif
> +
>      env->fpstt = (env->fpus_vmstate >> 11) & 7;
>      env->fpus = env->fpus_vmstate & ~0x3800;
>      env->fptag_vmstate ^= 0xff;
> @@ -851,6 +870,180 @@ static const VMStateDescription vmstate_tsc_khz = {
>      }
>  };
>  
> +#ifdef CONFIG_KVM
> +
> +static bool vmx_vmcs12_needed(void *opaque)
> +{
> +    struct kvm_nested_state *nested_state = opaque;
> +    return (nested_state->size >
> +            offsetof(struct kvm_nested_state, data.vmx[0].vmcs12));
> +}
> +
> +static const VMStateDescription vmstate_vmx_vmcs12 = {
> +	.name = "cpu/kvm_nested_state/vmx/vmcs12",
> +	.version_id = 1,
> +	.minimum_version_id = 1,
> +	.needed = vmx_vmcs12_needed,
> +	.fields = (VMStateField[]) {
> +	    VMSTATE_UINT8_ARRAY(data.vmx[0].vmcs12,
> +	                        struct kvm_nested_state, 0x1000),

Where did that magic 0x1000 come from?

> +	    VMSTATE_END_OF_LIST()
> +    }
> +};
> +
> +static bool vmx_shadow_vmcs12_needed(void *opaque)
> +{
> +    struct kvm_nested_state *nested_state = opaque;
> +    return (nested_state->size >
> +            offsetof(struct kvm_nested_state, data.vmx[0].shadow_vmcs12));
> +}
> +
> +static const VMStateDescription vmstate_vmx_shadow_vmcs12 = {
> +	.name = "cpu/kvm_nested_state/vmx/shadow_vmcs12",
> +	.version_id = 1,
> +	.minimum_version_id = 1,
> +	.needed = vmx_shadow_vmcs12_needed,
> +	.fields = (VMStateField[]) {
> +	    VMSTATE_UINT8_ARRAY(data.vmx[0].shadow_vmcs12,
> +	                        struct kvm_nested_state, 0x1000),
> +	    VMSTATE_END_OF_LIST()
> +    }
> +};
> +
> +static bool vmx_nested_state_needed(void *opaque)
> +{
> +    struct kvm_nested_state *nested_state = opaque;
> +
> +    return ((nested_state->format == KVM_STATE_NESTED_FORMAT_VMX) &&
> +            ((nested_state->hdr.vmx.vmxon_pa != -1ull) ||
> +             (nested_state->hdr.vmx.smm.flags & KVM_STATE_NESTED_SMM_VMXON)));
> +}
> +
> +static const VMStateDescription vmstate_vmx_nested_state = {
> +	.name = "cpu/kvm_nested_state/vmx",
> +	.version_id = 1,
> +	.minimum_version_id = 1,
> +	.needed = vmx_nested_state_needed,
> +	.fields = (VMStateField[]) {
> +	    VMSTATE_U64(hdr.vmx.vmxon_pa, struct kvm_nested_state),
> +	    VMSTATE_U64(hdr.vmx.vmcs12_pa, struct kvm_nested_state),
> +	    VMSTATE_U16(hdr.vmx.smm.flags, struct kvm_nested_state),
> +	    VMSTATE_END_OF_LIST()
> +    },
> +    .subsections = (const VMStateDescription*[]) {
> +        &vmstate_vmx_vmcs12,
> +        &vmstate_vmx_shadow_vmcs12,
> +        NULL,
> +    }
> +};
> +
> +static bool svm_nested_state_needed(void *opaque)
> +{
> +    struct kvm_nested_state *nested_state = opaque;
> +
> +    return (nested_state->format == KVM_STATE_NESTED_FORMAT_SVM);
> +}
> +
> +static const VMStateDescription vmstate_svm_nested_state = {
> +	.name = "cpu/kvm_nested_state/svm",
> +	.version_id = 1,
> +	.minimum_version_id = 1,
> +	.needed = svm_nested_state_needed,
> +	.fields = (VMStateField[]) {
> +	    VMSTATE_END_OF_LIST()
> +    }
> +};
> +
> +static bool nested_state_needed(void *opaque)
> +{
> +    X86CPU *cpu = opaque;
> +    CPUX86State *env = &cpu->env;
> +
> +    return (env->nested_state &&
> +            (vmx_nested_state_needed(env->nested_state) ||
> +             svm_nested_state_needed(env->nested_state)));
> +}
> +
> +static int nested_state_post_load(void *opaque, int version_id)
> +{
> +    X86CPU *cpu = opaque;
> +    CPUX86State *env = &cpu->env;
> +    struct kvm_nested_state *nested_state = env->nested_state;
> +    int min_nested_state_len = offsetof(struct kvm_nested_state, data);
> +    int max_nested_state_len = kvm_max_nested_state_length();
> +
> +    /*
> +     * If our kernel don't support setting nested state
> +     * and we have received nested state from migration stream,
> +     * we need to fail migration
> +     */
> +    if (max_nested_state_len <= 0) {
> +        error_report("Received nested state when kernel cannot restore it");
> +        return -EINVAL;
> +    }
> +
> +    /*
> +     * Verify that the size of received nested_state struct
> +     * at least cover required header and is not larger
> +     * than the max size that our kernel support
> +     */
> +    if (nested_state->size < min_nested_state_len) {
> +        error_report("Received nested state size less than min: "
> +                     "len=%d, min=%d",
> +                     nested_state->size, min_nested_state_len);
> +        return -EINVAL;
> +    }
> +    if (nested_state->size > max_nested_state_len) {
> +        error_report("Recieved unsupported nested state size: "
> +                     "nested_state->size=%d, max=%d",
> +                     nested_state->size, max_nested_state_len);
> +        return -EINVAL;
> +    }
> +
> +    /* Verify format is valid */
> +    if ((nested_state->format != KVM_STATE_NESTED_FORMAT_VMX) &&
> +        (nested_state->format != KVM_STATE_NESTED_FORMAT_SVM)) {
> +        error_report("Received invalid nested state format: %d",
> +                     nested_state->format);
> +        return -EINVAL;
> +    }
> +
> +    return 0;
> +}
> +
> +static const VMStateDescription vmstate_kvm_nested_state = {
> +    .name = "cpu/kvm_nested_state",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .fields = (VMStateField[]) {
> +        VMSTATE_U16(flags, struct kvm_nested_state),
> +        VMSTATE_U16(format, struct kvm_nested_state),
> +        VMSTATE_U32(size, struct kvm_nested_state),
> +        VMSTATE_END_OF_LIST()
> +    },
> +    .subsections = (const VMStateDescription*[]) {
> +        &vmstate_vmx_nested_state,
> +        &vmstate_svm_nested_state,
> +        NULL
> +    }
> +};
> +
> +static const VMStateDescription vmstate_nested_state = {
> +    .name = "cpu/nested_state",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .needed = nested_state_needed,
> +    .post_load = nested_state_post_load,
> +    .fields = (VMStateField[]) {
> +        VMSTATE_STRUCT_POINTER(env.nested_state, X86CPU,
> +                               vmstate_kvm_nested_state,
> +                               struct kvm_nested_state),
> +        VMSTATE_END_OF_LIST()
> +    }
> +};
> +
> +#endif
> +
>  static bool mcg_ext_ctl_needed(void *opaque)
>  {
>      X86CPU *cpu = opaque;
> @@ -1089,6 +1282,9 @@ VMStateDescription vmstate_x86_cpu = {
>          &vmstate_msr_intel_pt,
>          &vmstate_msr_virt_ssbd,
>          &vmstate_svm_npt,
> +#ifdef CONFIG_KVM
> +        &vmstate_nested_state,
> +#endif
>          NULL
>      }
>  };
> -- 
> 2.20.1
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
