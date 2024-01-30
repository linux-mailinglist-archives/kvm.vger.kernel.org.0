Return-Path: <kvm+bounces-7482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ED008428C5
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 17:07:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 638371C237E7
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 16:07:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00B7786AC8;
	Tue, 30 Jan 2024 16:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KpjUKYQe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B18A605A6
	for <kvm@vger.kernel.org>; Tue, 30 Jan 2024 16:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.134.136.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706630821; cv=none; b=Gpe4dSudw/9lq6zCsFapEusi4R7JmwHK773FVUaDpL1a3DA/NxYUr5VPxxPdlq0P7eMIsyVEAMxNQX+5K8GS26cTkd/Eue8oy3Oo5jDZy8cV3yNGAdEFXenpXBg+yXAw+ch0z6e7czbp7ehwtGEnl05ILE2SLBsL0U1XmkqcG2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706630821; c=relaxed/simple;
	bh=d078j57A5IFL8Q6Ix3bl+QIPh1qyiuI6nx/+m2oYaAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F7qvCp+ALQ/nkDFfs7b/RtbaSBNRuDFaN1WxDpnhOIiRsu7HE3zbEr/9VlTYUIFnQGAdv99j4VwttaU+GC0QoS8uCTta1n3l5G283eabWnwsBVKE4LYBuQWMTBe7x+PIOcb4i05KuCVLEnYfmIpsMRFT25fjspZXK3faeAlMA20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KpjUKYQe; arc=none smtp.client-ip=134.134.136.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706630818; x=1738166818;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=d078j57A5IFL8Q6Ix3bl+QIPh1qyiuI6nx/+m2oYaAc=;
  b=KpjUKYQeTKmGKm8vZrcv83mO9lfMMBkHIxBx8WG0jgtvuMgmeOBndwkw
   hv2iB/LVrwIn1zrZhe4tvrPqWj6o4rHlspUeGPuj92N3dVm0ixYvXBL6O
   /SFVZ7sPWRQS51fTwGulmWSDBPyoB2ExoTrihB4gEGSMGnWFHEMgFrYtw
   Yg1U8edPET6JXF6CopoW1V7mt12oKhvsUw5QBjNCxwcVR9fqhNdI7URFu
   VR/eBQ6DBCIqTtW+PydcXq7wKQ1Xlay+S0oU8pF4LdS56w0HR8e5gNRlv
   UEXuPdvINa40cmqfD4nYUXY+do0Ge5Y96enflO3zV2QL17ljeFdl82Qc8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="393768799"
X-IronPort-AV: E=Sophos;i="6.05,230,1701158400"; 
   d="scan'208";a="393768799"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 08:06:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,230,1701158400"; 
   d="scan'208";a="29943534"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa002.jf.intel.com with ESMTP; 30 Jan 2024 08:06:48 -0800
Date: Wed, 31 Jan 2024 00:20:17 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	qemu-ppc@nongnu.org, qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony Perard <anthony.perard@citrix.com>,
	Paul Durrant <paul@xen.org>, Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v3 14/29] target/i386: Prefer fast cpu_env() over slower
 CPU QOM cast macro
Message-ID: <ZbkhwXUK39hnH9EN@intel.com>
References: <20240129164514.73104-1-philmd@linaro.org>
 <20240129164514.73104-15-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240129164514.73104-15-philmd@linaro.org>

On Mon, Jan 29, 2024 at 05:44:56PM +0100, Philippe Mathieu-Daudé wrote:
> Date: Mon, 29 Jan 2024 17:44:56 +0100
> From: Philippe Mathieu-Daudé <philmd@linaro.org>
> Subject: [PATCH v3 14/29] target/i386: Prefer fast cpu_env() over slower
>  CPU QOM cast macro
> X-Mailer: git-send-email 2.41.0
> 
> Mechanical patch produced running the command documented
> in scripts/coccinelle/cpu_env.cocci_template header.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  target/i386/hvf/vmx.h                | 13 ++-------
>  hw/i386/fw_cfg.c                     |  3 +-
>  hw/i386/vmmouse.c                    |  6 ++--
>  hw/i386/xen/xen-hvm.c                |  3 +-
>  target/i386/arch_dump.c              | 11 ++------
>  target/i386/arch_memory_mapping.c    |  3 +-
>  target/i386/cpu-dump.c               |  3 +-
>  target/i386/cpu.c                    | 37 ++++++++----------------
>  target/i386/helper.c                 | 42 ++++++++--------------------
>  target/i386/hvf/hvf.c                |  8 ++----
>  target/i386/hvf/x86.c                |  4 +--
>  target/i386/hvf/x86_emu.c            |  6 ++--
>  target/i386/hvf/x86_task.c           | 10 ++-----
>  target/i386/hvf/x86hvf.c             |  9 ++----
>  target/i386/kvm/kvm.c                |  6 ++--
>  target/i386/kvm/xen-emu.c            | 32 +++++++--------------
>  target/i386/tcg/sysemu/bpt_helper.c  |  3 +-
>  target/i386/tcg/sysemu/excp_helper.c |  3 +-
>  target/i386/tcg/tcg-cpu.c            | 14 +++-------
>  target/i386/tcg/user/excp_helper.c   |  6 ++--
>  target/i386/tcg/user/seg_helper.c    |  3 +-
>  21 files changed, 67 insertions(+), 158 deletions(-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>

> 
> diff --git a/target/i386/hvf/vmx.h b/target/i386/hvf/vmx.h
> index 0fffcfa46c..1ad042269b 100644
> --- a/target/i386/hvf/vmx.h
> +++ b/target/i386/hvf/vmx.h
> @@ -175,8 +175,7 @@ static inline void macvm_set_cr4(hv_vcpuid_t vcpu, uint64_t cr4)
>  
>  static inline void macvm_set_rip(CPUState *cpu, uint64_t rip)
>  {
> -    X86CPU *x86_cpu = X86_CPU(cpu);
> -    CPUX86State *env = &x86_cpu->env;
> +    CPUX86State *env = cpu_env(cpu);
>      uint64_t val;
>  
>      /* BUG, should take considering overlap.. */
> @@ -196,10 +195,7 @@ static inline void macvm_set_rip(CPUState *cpu, uint64_t rip)
>  
>  static inline void vmx_clear_nmi_blocking(CPUState *cpu)
>  {
> -    X86CPU *x86_cpu = X86_CPU(cpu);
> -    CPUX86State *env = &x86_cpu->env;
> -
> -    env->hflags2 &= ~HF2_NMI_MASK;
> +    cpu_env(cpu)->hflags2 &= ~HF2_NMI_MASK;
>      uint32_t gi = (uint32_t) rvmcs(cpu->accel->fd, VMCS_GUEST_INTERRUPTIBILITY);
>      gi &= ~VMCS_INTERRUPTIBILITY_NMI_BLOCKING;
>      wvmcs(cpu->accel->fd, VMCS_GUEST_INTERRUPTIBILITY, gi);
> @@ -207,10 +203,7 @@ static inline void vmx_clear_nmi_blocking(CPUState *cpu)
>  
>  static inline void vmx_set_nmi_blocking(CPUState *cpu)
>  {
> -    X86CPU *x86_cpu = X86_CPU(cpu);
> -    CPUX86State *env = &x86_cpu->env;
> -
> -    env->hflags2 |= HF2_NMI_MASK;
> +    cpu_env(cpu)->hflags2 |= HF2_NMI_MASK;
>      uint32_t gi = (uint32_t)rvmcs(cpu->accel->fd, VMCS_GUEST_INTERRUPTIBILITY);
>      gi |= VMCS_INTERRUPTIBILITY_NMI_BLOCKING;
>      wvmcs(cpu->accel->fd, VMCS_GUEST_INTERRUPTIBILITY, gi);
> diff --git a/hw/i386/fw_cfg.c b/hw/i386/fw_cfg.c
> index 7362daa45a..5239cd40fa 100644
> --- a/hw/i386/fw_cfg.c
> +++ b/hw/i386/fw_cfg.c
> @@ -155,8 +155,7 @@ FWCfgState *fw_cfg_arch_create(MachineState *ms,
>  
>  void fw_cfg_build_feature_control(MachineState *ms, FWCfgState *fw_cfg)
>  {
> -    X86CPU *cpu = X86_CPU(ms->possible_cpus->cpus[0].cpu);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(ms->possible_cpus->cpus[0].cpu);
>      uint32_t unused, ebx, ecx, edx;
>      uint64_t feature_control_bits = 0;
>      uint64_t *val;
> diff --git a/hw/i386/vmmouse.c b/hw/i386/vmmouse.c
> index a8d014d09a..f292a14a15 100644
> --- a/hw/i386/vmmouse.c
> +++ b/hw/i386/vmmouse.c
> @@ -74,8 +74,7 @@ struct VMMouseState {
>  
>  static void vmmouse_get_data(uint32_t *data)
>  {
> -    X86CPU *cpu = X86_CPU(current_cpu);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(current_cpu);
>  
>      data[0] = env->regs[R_EAX]; data[1] = env->regs[R_EBX];
>      data[2] = env->regs[R_ECX]; data[3] = env->regs[R_EDX];
> @@ -84,8 +83,7 @@ static void vmmouse_get_data(uint32_t *data)
>  
>  static void vmmouse_set_data(const uint32_t *data)
>  {
> -    X86CPU *cpu = X86_CPU(current_cpu);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(current_cpu);
>  
>      env->regs[R_EAX] = data[0]; env->regs[R_EBX] = data[1];
>      env->regs[R_ECX] = data[2]; env->regs[R_EDX] = data[3];
> diff --git a/hw/i386/xen/xen-hvm.c b/hw/i386/xen/xen-hvm.c
> index f42621e674..61e5060117 100644
> --- a/hw/i386/xen/xen-hvm.c
> +++ b/hw/i386/xen/xen-hvm.c
> @@ -487,8 +487,7 @@ static void regs_to_cpu(vmware_regs_t *vmport_regs, ioreq_t *req)
>  
>  static void regs_from_cpu(vmware_regs_t *vmport_regs)
>  {
> -    X86CPU *cpu = X86_CPU(current_cpu);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(current_cpu);
>  
>      vmport_regs->ebx = env->regs[R_EBX];
>      vmport_regs->ecx = env->regs[R_ECX];
> diff --git a/target/i386/arch_dump.c b/target/i386/arch_dump.c
> index c290910a04..8939ff9fa9 100644
> --- a/target/i386/arch_dump.c
> +++ b/target/i386/arch_dump.c
> @@ -203,7 +203,6 @@ int x86_cpu_write_elf64_note(WriteCoreDumpFunction f, CPUState *cs,
>  int x86_cpu_write_elf32_note(WriteCoreDumpFunction f, CPUState *cs,
>                               int cpuid, DumpState *s)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
>      x86_elf_prstatus prstatus;
>      Elf32_Nhdr *note;
>      char *buf;
> @@ -211,7 +210,7 @@ int x86_cpu_write_elf32_note(WriteCoreDumpFunction f, CPUState *cs,
>      const char *name = "CORE";
>      int ret;
>  
> -    x86_fill_elf_prstatus(&prstatus, &cpu->env, cpuid);
> +    x86_fill_elf_prstatus(&prstatus, cpu_env(cs), cpuid);
>      descsz = sizeof(x86_elf_prstatus);
>      note_size = ELF_NOTE_SIZE(sizeof(Elf32_Nhdr), name_size, descsz);
>      note = g_malloc0(note_size);
> @@ -381,17 +380,13 @@ static inline int cpu_write_qemu_note(WriteCoreDumpFunction f,
>  int x86_cpu_write_elf64_qemunote(WriteCoreDumpFunction f, CPUState *cs,
>                                   DumpState *s)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -
> -    return cpu_write_qemu_note(f, &cpu->env, s, 1);
> +    return cpu_write_qemu_note(f, cpu_env(cs), s, 1);
>  }
>  
>  int x86_cpu_write_elf32_qemunote(WriteCoreDumpFunction f, CPUState *cs,
>                                   DumpState *s)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -
> -    return cpu_write_qemu_note(f, &cpu->env, s, 0);
> +    return cpu_write_qemu_note(f, cpu_env(cs), s, 0);
>  }
>  
>  int cpu_get_dump_info(ArchDumpInfo *info,
> diff --git a/target/i386/arch_memory_mapping.c b/target/i386/arch_memory_mapping.c
> index d1ff659128..c0604d5956 100644
> --- a/target/i386/arch_memory_mapping.c
> +++ b/target/i386/arch_memory_mapping.c
> @@ -269,8 +269,7 @@ static void walk_pml5e(MemoryMappingList *list, AddressSpace *as,
>  bool x86_cpu_get_memory_mapping(CPUState *cs, MemoryMappingList *list,
>                                  Error **errp)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>      int32_t a20_mask;
>  
>      if (!cpu_paging_enabled(cs)) {
> diff --git a/target/i386/cpu-dump.c b/target/i386/cpu-dump.c
> index 40697064d9..5459d84abd 100644
> --- a/target/i386/cpu-dump.c
> +++ b/target/i386/cpu-dump.c
> @@ -343,8 +343,7 @@ void x86_cpu_dump_local_apic_state(CPUState *cs, int flags)
>  
>  void x86_cpu_dump_state(CPUState *cs, FILE *f, int flags)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>      int eflags, i, nb;
>      char cc_op_name[32];
>      static const char *seg_name[6] = { "ES", "CS", "SS", "DS", "FS", "GS" };
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 66345c204a..5d7a266d27 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -5062,8 +5062,7 @@ static void x86_cpuid_version_get_family(Object *obj, Visitor *v,
>                                           const char *name, void *opaque,
>                                           Error **errp)
>  {
> -    X86CPU *cpu = X86_CPU(obj);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(CPU(obj));
>      int64_t value;
>  
>      value = (env->cpuid_version >> 8) & 0xf;
> @@ -5077,8 +5076,7 @@ static void x86_cpuid_version_set_family(Object *obj, Visitor *v,
>                                           const char *name, void *opaque,
>                                           Error **errp)
>  {
> -    X86CPU *cpu = X86_CPU(obj);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(CPU(obj));
>      const int64_t min = 0;
>      const int64_t max = 0xff + 0xf;
>      int64_t value;
> @@ -5104,8 +5102,7 @@ static void x86_cpuid_version_get_model(Object *obj, Visitor *v,
>                                          const char *name, void *opaque,
>                                          Error **errp)
>  {
> -    X86CPU *cpu = X86_CPU(obj);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(CPU(obj));
>      int64_t value;
>  
>      value = (env->cpuid_version >> 4) & 0xf;
> @@ -5117,8 +5114,7 @@ static void x86_cpuid_version_set_model(Object *obj, Visitor *v,
>                                          const char *name, void *opaque,
>                                          Error **errp)
>  {
> -    X86CPU *cpu = X86_CPU(obj);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(CPU(obj));
>      const int64_t min = 0;
>      const int64_t max = 0xff;
>      int64_t value;
> @@ -5140,11 +5136,9 @@ static void x86_cpuid_version_get_stepping(Object *obj, Visitor *v,
>                                             const char *name, void *opaque,
>                                             Error **errp)
>  {
> -    X86CPU *cpu = X86_CPU(obj);
> -    CPUX86State *env = &cpu->env;
>      int64_t value;
>  
> -    value = env->cpuid_version & 0xf;
> +    value = cpu_env(CPU(obj))->cpuid_version & 0xf;
>      visit_type_int(v, name, &value, errp);
>  }
>  
> @@ -5152,8 +5146,7 @@ static void x86_cpuid_version_set_stepping(Object *obj, Visitor *v,
>                                             const char *name, void *opaque,
>                                             Error **errp)
>  {
> -    X86CPU *cpu = X86_CPU(obj);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(CPU(obj));
>      const int64_t min = 0;
>      const int64_t max = 0xf;
>      int64_t value;
> @@ -5173,8 +5166,7 @@ static void x86_cpuid_version_set_stepping(Object *obj, Visitor *v,
>  
>  static char *x86_cpuid_get_vendor(Object *obj, Error **errp)
>  {
> -    X86CPU *cpu = X86_CPU(obj);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(CPU(obj));
>      char *value;
>  
>      value = g_malloc(CPUID_VENDOR_SZ + 1);
> @@ -5186,8 +5178,7 @@ static char *x86_cpuid_get_vendor(Object *obj, Error **errp)
>  static void x86_cpuid_set_vendor(Object *obj, const char *value,
>                                   Error **errp)
>  {
> -    X86CPU *cpu = X86_CPU(obj);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(CPU(obj));
>      int i;
>  
>      if (strlen(value) != CPUID_VENDOR_SZ) {
> @@ -5208,8 +5199,7 @@ static void x86_cpuid_set_vendor(Object *obj, const char *value,
>  
>  static char *x86_cpuid_get_model_id(Object *obj, Error **errp)
>  {
> -    X86CPU *cpu = X86_CPU(obj);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(CPU(obj));
>      char *value;
>      int i;
>  
> @@ -5224,8 +5214,7 @@ static char *x86_cpuid_get_model_id(Object *obj, Error **errp)
>  static void x86_cpuid_set_model_id(Object *obj, const char *model_id,
>                                     Error **errp)
>  {
> -    X86CPU *cpu = X86_CPU(obj);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(CPU(obj));
>      int c, len, i;
>  
>      if (model_id == NULL) {
> @@ -7673,8 +7662,7 @@ static vaddr x86_cpu_get_pc(CPUState *cs)
>  
>  int x86_cpu_pending_interrupt(CPUState *cs, int interrupt_request)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>  
>  #if !defined(CONFIG_USER_ONLY)
>      if (interrupt_request & CPU_INTERRUPT_POLL) {
> @@ -7722,8 +7710,7 @@ static bool x86_cpu_has_work(CPUState *cs)
>  
>  static void x86_disas_set_info(CPUState *cs, disassemble_info *info)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>  
>      info->mach = (env->hflags & HF_CS64_MASK ? bfd_mach_x86_64
>                    : env->hflags & HF_CS32_MASK ? bfd_mach_i386_i386
> diff --git a/target/i386/helper.c b/target/i386/helper.c
> index 2070dd0dda..4c11ef70f0 100644
> --- a/target/i386/helper.c
> +++ b/target/i386/helper.c
> @@ -230,8 +230,7 @@ void cpu_x86_update_cr4(CPUX86State *env, uint32_t new_cr4)
>  hwaddr x86_cpu_get_phys_page_attrs_debug(CPUState *cs, vaddr addr,
>                                           MemTxAttrs *attrs)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>      target_ulong pde_addr, pte_addr;
>      uint64_t pte;
>      int32_t a20_mask;
> @@ -373,8 +372,7 @@ static void emit_guest_memory_failure(MemoryFailureAction action, bool ar,
>  static void do_inject_x86_mce(CPUState *cs, run_on_cpu_data data)
>  {
>      MCEInjectionParams *params = data.host_ptr;
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *cenv = &cpu->env;
> +    CPUX86State *cenv = cpu_env(cs);
>      uint64_t *banks = cenv->mce_banks + 4 * params->bank;
>      g_autofree char *msg = NULL;
>      bool need_reset = false;
> @@ -625,9 +623,7 @@ void cpu_load_efer(CPUX86State *env, uint64_t val)
>  
>  uint8_t x86_ldub_phys(CPUState *cs, hwaddr addr)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> -    MemTxAttrs attrs = cpu_get_mem_attrs(env);
> +    MemTxAttrs attrs = cpu_get_mem_attrs(cpu_env(cs));
>      AddressSpace *as = cpu_addressspace(cs, attrs);
>  
>      return address_space_ldub(as, addr, attrs, NULL);
> @@ -635,9 +631,7 @@ uint8_t x86_ldub_phys(CPUState *cs, hwaddr addr)
>  
>  uint32_t x86_lduw_phys(CPUState *cs, hwaddr addr)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> -    MemTxAttrs attrs = cpu_get_mem_attrs(env);
> +    MemTxAttrs attrs = cpu_get_mem_attrs(cpu_env(cs));
>      AddressSpace *as = cpu_addressspace(cs, attrs);
>  
>      return address_space_lduw(as, addr, attrs, NULL);
> @@ -645,9 +639,7 @@ uint32_t x86_lduw_phys(CPUState *cs, hwaddr addr)
>  
>  uint32_t x86_ldl_phys(CPUState *cs, hwaddr addr)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> -    MemTxAttrs attrs = cpu_get_mem_attrs(env);
> +    MemTxAttrs attrs = cpu_get_mem_attrs(cpu_env(cs));
>      AddressSpace *as = cpu_addressspace(cs, attrs);
>  
>      return address_space_ldl(as, addr, attrs, NULL);
> @@ -655,9 +647,7 @@ uint32_t x86_ldl_phys(CPUState *cs, hwaddr addr)
>  
>  uint64_t x86_ldq_phys(CPUState *cs, hwaddr addr)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> -    MemTxAttrs attrs = cpu_get_mem_attrs(env);
> +    MemTxAttrs attrs = cpu_get_mem_attrs(cpu_env(cs));
>      AddressSpace *as = cpu_addressspace(cs, attrs);
>  
>      return address_space_ldq(as, addr, attrs, NULL);
> @@ -665,9 +655,7 @@ uint64_t x86_ldq_phys(CPUState *cs, hwaddr addr)
>  
>  void x86_stb_phys(CPUState *cs, hwaddr addr, uint8_t val)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> -    MemTxAttrs attrs = cpu_get_mem_attrs(env);
> +    MemTxAttrs attrs = cpu_get_mem_attrs(cpu_env(cs));
>      AddressSpace *as = cpu_addressspace(cs, attrs);
>  
>      address_space_stb(as, addr, val, attrs, NULL);
> @@ -675,9 +663,7 @@ void x86_stb_phys(CPUState *cs, hwaddr addr, uint8_t val)
>  
>  void x86_stl_phys_notdirty(CPUState *cs, hwaddr addr, uint32_t val)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> -    MemTxAttrs attrs = cpu_get_mem_attrs(env);
> +    MemTxAttrs attrs = cpu_get_mem_attrs(cpu_env(cs));
>      AddressSpace *as = cpu_addressspace(cs, attrs);
>  
>      address_space_stl_notdirty(as, addr, val, attrs, NULL);
> @@ -685,9 +671,7 @@ void x86_stl_phys_notdirty(CPUState *cs, hwaddr addr, uint32_t val)
>  
>  void x86_stw_phys(CPUState *cs, hwaddr addr, uint32_t val)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> -    MemTxAttrs attrs = cpu_get_mem_attrs(env);
> +    MemTxAttrs attrs = cpu_get_mem_attrs(cpu_env(cs));
>      AddressSpace *as = cpu_addressspace(cs, attrs);
>  
>      address_space_stw(as, addr, val, attrs, NULL);
> @@ -695,9 +679,7 @@ void x86_stw_phys(CPUState *cs, hwaddr addr, uint32_t val)
>  
>  void x86_stl_phys(CPUState *cs, hwaddr addr, uint32_t val)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> -    MemTxAttrs attrs = cpu_get_mem_attrs(env);
> +    MemTxAttrs attrs = cpu_get_mem_attrs(cpu_env(cs));
>      AddressSpace *as = cpu_addressspace(cs, attrs);
>  
>      address_space_stl(as, addr, val, attrs, NULL);
> @@ -705,9 +687,7 @@ void x86_stl_phys(CPUState *cs, hwaddr addr, uint32_t val)
>  
>  void x86_stq_phys(CPUState *cs, hwaddr addr, uint64_t val)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> -    MemTxAttrs attrs = cpu_get_mem_attrs(env);
> +    MemTxAttrs attrs = cpu_get_mem_attrs(cpu_env(cs));
>      AddressSpace *as = cpu_addressspace(cs, attrs);
>  
>      address_space_stq(as, addr, val, attrs, NULL);
> diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
> index 11ffdd4c69..772578e3f4 100644
> --- a/target/i386/hvf/hvf.c
> +++ b/target/i386/hvf/hvf.c
> @@ -159,10 +159,7 @@ static bool ept_emulation_fault(hvf_slot *slot, uint64_t gpa, uint64_t ept_qual)
>  
>  void hvf_arch_vcpu_destroy(CPUState *cpu)
>  {
> -    X86CPU *x86_cpu = X86_CPU(cpu);
> -    CPUX86State *env = &x86_cpu->env;
> -
> -    g_free(env->hvf_mmio_buf);
> +    g_free(cpu_env(cpu)->hvf_mmio_buf);
>  }
>  
>  static void init_tsc_freq(CPUX86State *env)
> @@ -313,8 +310,7 @@ int hvf_arch_init_vcpu(CPUState *cpu)
>  
>  static void hvf_store_events(CPUState *cpu, uint32_t ins_len, uint64_t idtvec_info)
>  {
> -    X86CPU *x86_cpu = X86_CPU(cpu);
> -    CPUX86State *env = &x86_cpu->env;
> +    CPUX86State *env = cpu_env(cpu);
>  
>      env->exception_nr = -1;
>      env->exception_pending = 0;
> diff --git a/target/i386/hvf/x86.c b/target/i386/hvf/x86.c
> index 80e36136d0..932635232b 100644
> --- a/target/i386/hvf/x86.c
> +++ b/target/i386/hvf/x86.c
> @@ -128,9 +128,7 @@ bool x86_is_real(CPUState *cpu)
>  
>  bool x86_is_v8086(CPUState *cpu)
>  {
> -    X86CPU *x86_cpu = X86_CPU(cpu);
> -    CPUX86State *env = &x86_cpu->env;
> -    return x86_is_protected(cpu) && (env->eflags & VM_MASK);
> +    return x86_is_protected(cpu) && (cpu_env(cpu)->eflags & VM_MASK);
>  }
>  
>  bool x86_is_long_mode(CPUState *cpu)
> diff --git a/target/i386/hvf/x86_emu.c b/target/i386/hvf/x86_emu.c
> index 3a3f0a50d0..0d13b32f91 100644
> --- a/target/i386/hvf/x86_emu.c
> +++ b/target/i386/hvf/x86_emu.c
> @@ -1419,8 +1419,7 @@ static void init_cmd_handler()
>  
>  void load_regs(CPUState *cs)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>  
>      int i = 0;
>      RRX(env, R_EAX) = rreg(cs->accel->fd, HV_X86_RAX);
> @@ -1442,8 +1441,7 @@ void load_regs(CPUState *cs)
>  
>  void store_regs(CPUState *cs)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>  
>      int i = 0;
>      wreg(cs->accel->fd, HV_X86_RAX, RAX(env));
> diff --git a/target/i386/hvf/x86_task.c b/target/i386/hvf/x86_task.c
> index f09bfbdda5..c173e9d883 100644
> --- a/target/i386/hvf/x86_task.c
> +++ b/target/i386/hvf/x86_task.c
> @@ -33,8 +33,7 @@
>  // TODO: taskswitch handling
>  static void save_state_to_tss32(CPUState *cpu, struct x86_tss_segment32 *tss)
>  {
> -    X86CPU *x86_cpu = X86_CPU(cpu);
> -    CPUX86State *env = &x86_cpu->env;
> +    CPUX86State *env = cpu_env(cpu);
>  
>      /* CR3 and ldt selector are not saved intentionally */
>      tss->eip = (uint32_t)env->eip;
> @@ -58,8 +57,7 @@ static void save_state_to_tss32(CPUState *cpu, struct x86_tss_segment32 *tss)
>  
>  static void load_state_from_tss32(CPUState *cpu, struct x86_tss_segment32 *tss)
>  {
> -    X86CPU *x86_cpu = X86_CPU(cpu);
> -    CPUX86State *env = &x86_cpu->env;
> +    CPUX86State *env = cpu_env(cpu);
>  
>      wvmcs(cpu->accel->fd, VMCS_GUEST_CR3, tss->cr3);
>  
> @@ -128,9 +126,7 @@ void vmx_handle_task_switch(CPUState *cpu, x68_segment_selector tss_sel, int rea
>      uint32_t desc_limit;
>      struct x86_call_gate task_gate_desc;
>      struct vmx_segment vmx_seg;
> -
> -    X86CPU *x86_cpu = X86_CPU(cpu);
> -    CPUX86State *env = &x86_cpu->env;
> +    CPUX86State *env = cpu_env(cpu);
>  
>      x86_read_segment_descriptor(cpu, &next_tss_desc, tss_sel);
>      x86_read_segment_descriptor(cpu, &curr_tss_desc, old_tss_sel);
> diff --git a/target/i386/hvf/x86hvf.c b/target/i386/hvf/x86hvf.c
> index be2c46246e..10f79849b3 100644
> --- a/target/i386/hvf/x86hvf.c
> +++ b/target/i386/hvf/x86hvf.c
> @@ -238,8 +238,7 @@ void hvf_get_msrs(CPUState *cs)
>  
>  int hvf_put_registers(CPUState *cs)
>  {
> -    X86CPU *x86cpu = X86_CPU(cs);
> -    CPUX86State *env = &x86cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>  
>      wreg(cs->accel->fd, HV_X86_RAX, env->regs[R_EAX]);
>      wreg(cs->accel->fd, HV_X86_RBX, env->regs[R_EBX]);
> @@ -282,8 +281,7 @@ int hvf_put_registers(CPUState *cs)
>  
>  int hvf_get_registers(CPUState *cs)
>  {
> -    X86CPU *x86cpu = X86_CPU(cs);
> -    CPUX86State *env = &x86cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>  
>      env->regs[R_EAX] = rreg(cs->accel->fd, HV_X86_RAX);
>      env->regs[R_EBX] = rreg(cs->accel->fd, HV_X86_RBX);
> @@ -342,8 +340,7 @@ void vmx_clear_int_window_exiting(CPUState *cs)
>  
>  bool hvf_inject_interrupts(CPUState *cs)
>  {
> -    X86CPU *x86cpu = X86_CPU(cs);
> -    CPUX86State *env = &x86cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>  
>      uint8_t vector;
>      uint64_t intr_type;
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 76a66246eb..e4f1c62888 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -754,8 +754,7 @@ static inline bool freq_within_bounds(int freq, int target_freq)
>  
>  static int kvm_arch_set_tsc_khz(CPUState *cs)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>      int r, cur_freq;
>      bool set_ioctl = false;
>  
> @@ -5369,8 +5368,7 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
>  
>  bool kvm_arch_stop_on_emulation_error(CPUState *cs)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>  
>      kvm_cpu_synchronize_state(cs);
>      return !(env->cr[0] & CR0_PE_MASK) ||
> diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
> index fc2c2321ac..10350a22d1 100644
> --- a/target/i386/kvm/xen-emu.c
> +++ b/target/i386/kvm/xen-emu.c
> @@ -313,10 +313,7 @@ static int kvm_xen_set_vcpu_callback_vector(CPUState *cs)
>  
>  static void do_set_vcpu_callback_vector(CPUState *cs, run_on_cpu_data data)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> -
> -    env->xen_vcpu_callback_vector = data.host_int;
> +    cpu_env(cs)->xen_vcpu_callback_vector = data.host_int;
>  
>      if (kvm_xen_has_cap(EVTCHN_SEND)) {
>          kvm_xen_set_vcpu_callback_vector(cs);
> @@ -325,8 +322,7 @@ static void do_set_vcpu_callback_vector(CPUState *cs, run_on_cpu_data data)
>  
>  static int set_vcpu_info(CPUState *cs, uint64_t gpa)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>      MemoryRegionSection mrs = { .mr = NULL };
>      void *vcpu_info_hva = NULL;
>      int ret;
> @@ -362,8 +358,7 @@ static int set_vcpu_info(CPUState *cs, uint64_t gpa)
>  
>  static void do_set_vcpu_info_default_gpa(CPUState *cs, run_on_cpu_data data)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>  
>      env->xen_vcpu_info_default_gpa = data.host_ulong;
>  
> @@ -375,8 +370,7 @@ static void do_set_vcpu_info_default_gpa(CPUState *cs, run_on_cpu_data data)
>  
>  static void do_set_vcpu_info_gpa(CPUState *cs, run_on_cpu_data data)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>  
>      env->xen_vcpu_info_gpa = data.host_ulong;
>  
> @@ -479,8 +473,7 @@ void kvm_xen_inject_vcpu_callback_vector(uint32_t vcpu_id, int type)
>  /* Must always be called with xen_timers_lock held */
>  static int kvm_xen_set_vcpu_timer(CPUState *cs)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>  
>      struct kvm_xen_vcpu_attr va = {
>          .type = KVM_XEN_VCPU_ATTR_TYPE_TIMER,
> @@ -527,8 +520,7 @@ int kvm_xen_set_vcpu_virq(uint32_t vcpu_id, uint16_t virq, uint16_t port)
>  
>  static void do_set_vcpu_time_info_gpa(CPUState *cs, run_on_cpu_data data)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>  
>      env->xen_vcpu_time_info_gpa = data.host_ulong;
>  
> @@ -538,8 +530,7 @@ static void do_set_vcpu_time_info_gpa(CPUState *cs, run_on_cpu_data data)
>  
>  static void do_set_vcpu_runstate_gpa(CPUState *cs, run_on_cpu_data data)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>  
>      env->xen_vcpu_runstate_gpa = data.host_ulong;
>  
> @@ -549,8 +540,7 @@ static void do_set_vcpu_runstate_gpa(CPUState *cs, run_on_cpu_data data)
>  
>  static void do_vcpu_soft_reset(CPUState *cs, run_on_cpu_data data)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>  
>      env->xen_vcpu_info_gpa = INVALID_GPA;
>      env->xen_vcpu_info_default_gpa = INVALID_GPA;
> @@ -1813,8 +1803,7 @@ uint16_t kvm_xen_get_evtchn_max_pirq(void)
>  
>  int kvm_put_xen_state(CPUState *cs)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>      uint64_t gpa;
>      int ret;
>  
> @@ -1887,8 +1876,7 @@ int kvm_put_xen_state(CPUState *cs)
>  
>  int kvm_get_xen_state(CPUState *cs)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>      uint64_t gpa;
>      int ret;
>  
> diff --git a/target/i386/tcg/sysemu/bpt_helper.c b/target/i386/tcg/sysemu/bpt_helper.c
> index 4d96a48a3c..90d6117497 100644
> --- a/target/i386/tcg/sysemu/bpt_helper.c
> +++ b/target/i386/tcg/sysemu/bpt_helper.c
> @@ -208,8 +208,7 @@ bool check_hw_breakpoints(CPUX86State *env, bool force_dr6_update)
>  
>  void breakpoint_handler(CPUState *cs)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>  
>      if (cs->watchpoint_hit) {
>          if (cs->watchpoint_hit->flags & BP_CPU) {
> diff --git a/target/i386/tcg/sysemu/excp_helper.c b/target/i386/tcg/sysemu/excp_helper.c
> index 5b86f439ad..1afa177551 100644
> --- a/target/i386/tcg/sysemu/excp_helper.c
> +++ b/target/i386/tcg/sysemu/excp_helper.c
> @@ -639,6 +639,5 @@ G_NORETURN void x86_cpu_do_unaligned_access(CPUState *cs, vaddr vaddr,
>                                              MMUAccessType access_type,
>                                              int mmu_idx, uintptr_t retaddr)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    handle_unaligned_access(&cpu->env, vaddr, access_type, retaddr);
> +    handle_unaligned_access(cpu_env(cs), vaddr, access_type, retaddr);
>  }
> diff --git a/target/i386/tcg/tcg-cpu.c b/target/i386/tcg/tcg-cpu.c
> index e1405b7be9..8f8fd6529d 100644
> --- a/target/i386/tcg/tcg-cpu.c
> +++ b/target/i386/tcg/tcg-cpu.c
> @@ -29,8 +29,7 @@
>  
>  static void x86_cpu_exec_enter(CPUState *cs)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>  
>      CC_SRC = env->eflags & (CC_O | CC_S | CC_Z | CC_A | CC_P | CC_C);
>      env->df = 1 - (2 * ((env->eflags >> 10) & 1));
> @@ -40,8 +39,7 @@ static void x86_cpu_exec_enter(CPUState *cs)
>  
>  static void x86_cpu_exec_exit(CPUState *cs)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>  
>      env->eflags = cpu_compute_eflags(env);
>  }
> @@ -65,8 +63,7 @@ static void x86_restore_state_to_opc(CPUState *cs,
>                                       const TranslationBlock *tb,
>                                       const uint64_t *data)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>      int cc_op = data[1];
>      uint64_t new_pc;
>  
> @@ -96,11 +93,8 @@ static void x86_restore_state_to_opc(CPUState *cs,
>  #ifndef CONFIG_USER_ONLY
>  static bool x86_debug_check_breakpoint(CPUState *cs)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> -
>      /* RF disables all architectural breakpoints. */
> -    return !(env->eflags & RF_MASK);
> +    return !(cpu_env(cs)->eflags & RF_MASK);
>  }
>  #endif
>  
> diff --git a/target/i386/tcg/user/excp_helper.c b/target/i386/tcg/user/excp_helper.c
> index b3bdb7831a..9ea5566149 100644
> --- a/target/i386/tcg/user/excp_helper.c
> +++ b/target/i386/tcg/user/excp_helper.c
> @@ -26,8 +26,7 @@ void x86_cpu_record_sigsegv(CPUState *cs, vaddr addr,
>                              MMUAccessType access_type,
>                              bool maperr, uintptr_t ra)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>  
>      /*
>       * The error_code that hw reports as part of the exception frame
> @@ -52,6 +51,5 @@ void x86_cpu_record_sigsegv(CPUState *cs, vaddr addr,
>  void x86_cpu_record_sigbus(CPUState *cs, vaddr addr,
>                             MMUAccessType access_type, uintptr_t ra)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    handle_unaligned_access(&cpu->env, addr, access_type, ra);
> +    handle_unaligned_access(cpu_env(cs), addr, access_type, ra);
>  }
> diff --git a/target/i386/tcg/user/seg_helper.c b/target/i386/tcg/user/seg_helper.c
> index c45f2ac2ba..2f89dbb51e 100644
> --- a/target/i386/tcg/user/seg_helper.c
> +++ b/target/i386/tcg/user/seg_helper.c
> @@ -78,8 +78,7 @@ static void do_interrupt_user(CPUX86State *env, int intno, int is_int,
>  
>  void x86_cpu_do_interrupt(CPUState *cs)
>  {
> -    X86CPU *cpu = X86_CPU(cs);
> -    CPUX86State *env = &cpu->env;
> +    CPUX86State *env = cpu_env(cs);
>  
>      /* if user mode only, we simulate a fake exception
>         which will be handled outside the cpu execution
> -- 
> 2.41.0
> 
> 

