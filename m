Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948006C392E
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 19:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbjCUS3T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 14:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbjCUS3J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 14:29:09 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB77F172F;
        Tue, 21 Mar 2023 11:28:30 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-5416698e889so295829237b3.2;
        Tue, 21 Mar 2023 11:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679423310;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UIdpfSxmJYCkpNMIM562CRwblghzNfrCH8Znt15LNC0=;
        b=qqnQqmeqFP+DWopEpewSm0PGE30t8YaP+DdN6uySAfx3JED/MyMRl1jkiSiVZOoeYc
         OcvuLRGAxZHHV2/jVDGCQRLCMhs4G4J/pSPFS6VBS9fqEhSbaVHrsulfNeBZRrQWSDqg
         bmD5th1hepxfWFVPLgv1LVo4NGeN6z678AuumBI0JnHHm+K6jiNteshJXprLch5gfz2Z
         tKOILC8tYFAjylEY3OQ0LgDZ4nlPpYbufZUbWLkvP/NumPi0qNKQf0Q1x3kw9dLDxiRq
         BB3mpaTnbTqnU/SNPNeikQ/oxq78NwzBr4hQzPNAOR6dTT2xWW47VKF2tFjgzWnm0RnJ
         VnLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679423310;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UIdpfSxmJYCkpNMIM562CRwblghzNfrCH8Znt15LNC0=;
        b=BE+tKHlNR07OWdZTuvQaaOBl41LOKhzgllG/4qibslVjw1EhYpaTpLC3WirbldETog
         gCn39S1Cc2VGvlYSdIgTvxxq1uf4Rqsg4ZBuQvLYNEHVlV/deSPHy6dLnQom0wvsNLB+
         UOIzxZQVlitPMew2clgiC0y75XiDbwGc1oWv1nOaGkZHbuNuttK5nI8TylHAoa3/79Qr
         pVTtMPqfLMOjx1ZT6kPTUS6STm1c1kCAHFoip31qQfBXwmrxjD7PuYOmreZ+Rc9tQVlS
         8GNnBHj+E6SMD30/kFcjY7j401m8tbIbxYtPllzd2biLPzLqNEYb6DlsNHSN/hYl4NBN
         MXnQ==
X-Gm-Message-State: AAQBX9eD2BdJzWVPwj2b0iQdXuG3eK+iHJB7bBtCgATkN5l/8fIu9pWy
        tzBLNqsueU3+lUV3olnUIz/YWnXHATspq/34Ow==
X-Google-Smtp-Source: AKy350ZSbNZkoIOKOLf/00pr7muRyukY8d2LbQOH796fxqgN/2w3D6XqlRwdIvVaeF4X8n1O7iEnz6ZwiCGOsXuqJUE=
X-Received: by 2002:a81:ad11:0:b0:544:51f7:83c5 with SMTP id
 l17-20020a81ad11000000b0054451f783c5mr1765941ywh.1.1679423310042; Tue, 21 Mar
 2023 11:28:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230316222109.1940300-1-usama.arif@bytedance.com> <20230316222109.1940300-10-usama.arif@bytedance.com>
In-Reply-To: <20230316222109.1940300-10-usama.arif@bytedance.com>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Tue, 21 Mar 2023 14:28:19 -0400
Message-ID: <CAMzpN2jMyLP9h5o_wwdThHipAns2_dx3Nf8JYhj5pEqaeWXqYg@mail.gmail.com>
Subject: Re: [PATCH v15 09/12] x86/smpboot: Support parallel startup of
 secondary CPUs
To:     Usama Arif <usama.arif@bytedance.com>
Cc:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com,
        piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        gpiccoli@igalia.com, David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023 at 6:21=E2=80=AFPM Usama Arif <usama.arif@bytedance.co=
m> wrote:
>
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> Rework the real-mode startup code to allow for APs to be brought up in
> parallel. This is in two parts:
>
> 1. Introduce a bit-spinlock to prevent them from all using the real
>    mode stack at the same time.
>
> 2. Avoid needing to use the global smpboot_control variable to pass
>    each AP its CPU#.
>
> To achieve the latter, export the cpuid_to_apicid[] array so that each
> AP can find its own CPU# by searching therein based on its APIC ID.
>
> Introduce flags in the top bits of smpboot_control which indicate methods
> by which an AP should find its CPU#. For a serialized bringup, the CPU#
> is explicitly passed in the low bits of smpboot_control as before. For
> parallel mode there are flags directing the AP to find its APIC ID in
> CPUID leaf 0x0b (for X2APIC mode) or CPUID leaf 0x01 where 8 bits are
> sufficient, then perform the cpuid_to_apicid[] lookup with that.
>
> Parallel startup may be disabled by a command line option, and also if:
>  =E2=80=A2 AMD SEV-ES is in use, since the AP may not use CPUID that earl=
y.
>  =E2=80=A2 X2APIC is enabled, but CPUID leaf 0xb is not present and corre=
ct.
>  =E2=80=A2 X2APIC is not enabled but not even CPUID leaf 0x01 exists.
>
> Aside from the fact that APs will now look up their CPU# via the
> newly-exported cpuid_to_apicid[] table, there is no behavioural change
> intended yet, since new parallel CPUHP states have not =E2=80=94 yet =E2=
=80=94 been
> added.
>
> [ tglx: Initial proof of concept patch with bitlock and APIC ID lookup ]
> [ dwmw2: Rework and testing, commit message, CPUID 0x1 and CPU0 support ]
> [ seanc: Fix stray override of initial_gs in common_cpu_up() ]
> [ Oleksandr Natalenko: reported suspend/resume issue fixed in
>   x86_acpi_suspend_lowlevel ]
> Co-developed-by: Thomas Gleixner <tglx@linutronix.de>
> Co-developed-by: Brian Gerst <brgerst@gmail.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Signed-off-by: Usama Arif <usama.arif@bytedance.com>
> Tested-by: Paul E. McKenney <paulmck@kernel.org>
> Tested-by: Kim Phillips <kim.phillips@amd.com>
> Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |  3 +
>  arch/x86/include/asm/cpu.h                    |  1 +
>  arch/x86/include/asm/realmode.h               |  3 +
>  arch/x86/include/asm/smp.h                    |  6 ++
>  arch/x86/kernel/acpi/sleep.c                  |  9 ++-
>  arch/x86/kernel/apic/apic.c                   |  2 +-
>  arch/x86/kernel/cpu/topology.c                |  3 +-
>  arch/x86/kernel/head_64.S                     | 65 +++++++++++++++++++
>  arch/x86/kernel/smpboot.c                     | 50 +++++++++++++-
>  arch/x86/realmode/init.c                      |  3 +
>  arch/x86/realmode/rm/trampoline_64.S          | 27 ++++++--
>  11 files changed, 163 insertions(+), 9 deletions(-)
>
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentat=
ion/admin-guide/kernel-parameters.txt
> index 6cfa6e3996cf..7bb7020f97e2 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -3819,6 +3819,9 @@
>
>         nomodule        Disable module load
>
> +       no_parallel_bringup
> +                       [X86,SMP] Disable parallel bring-up of secondary =
cores.
> +
>         nopat           [X86] Disable PAT (page attribute table extension=
 of
>                         pagetables) support.
>
> diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
> index 78796b98a544..ef8ba318dca1 100644
> --- a/arch/x86/include/asm/cpu.h
> +++ b/arch/x86/include/asm/cpu.h
> @@ -97,5 +97,6 @@ static inline bool intel_cpu_signatures_match(unsigned =
int s1, unsigned int p1,
>  extern u64 x86_read_arch_cap_msr(void);
>  int intel_find_matching_signature(void *mc, unsigned int csig, int cpf);
>  int intel_microcode_sanity_check(void *mc, bool print_err, int hdr_type)=
;
> +int check_extended_topology_leaf(int leaf);
>
>  #endif /* _ASM_X86_CPU_H */
> diff --git a/arch/x86/include/asm/realmode.h b/arch/x86/include/asm/realm=
ode.h
> index f6a1737c77be..87e5482acd0d 100644
> --- a/arch/x86/include/asm/realmode.h
> +++ b/arch/x86/include/asm/realmode.h
> @@ -52,6 +52,7 @@ struct trampoline_header {
>         u64 efer;
>         u32 cr4;
>         u32 flags;
> +       u32 lock;
>  #endif
>  };
>
> @@ -64,6 +65,8 @@ extern unsigned long initial_stack;
>  extern unsigned long initial_vc_handler;
>  #endif
>
> +extern u32 *trampoline_lock;
> +
>  extern unsigned char real_mode_blob[];
>  extern unsigned char real_mode_relocs[];
>
> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> index bf2c51df9e0b..1cf4f1e57570 100644
> --- a/arch/x86/include/asm/smp.h
> +++ b/arch/x86/include/asm/smp.h
> @@ -203,4 +203,10 @@ extern unsigned int smpboot_control;
>
>  #endif /* !__ASSEMBLY__ */
>
> +/* Control bits for startup_64 */
> +#define STARTUP_APICID_CPUID_0B        0x80000000
> +#define STARTUP_APICID_CPUID_01        0x40000000
> +
> +#define STARTUP_PARALLEL_MASK (STARTUP_APICID_CPUID_01 | STARTUP_APICID_=
CPUID_0B)
> +
>  #endif /* _ASM_X86_SMP_H */
> diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
> index 1328c221af30..6dfecb27b846 100644
> --- a/arch/x86/kernel/acpi/sleep.c
> +++ b/arch/x86/kernel/acpi/sleep.c
> @@ -16,6 +16,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/realmode.h>
>  #include <asm/hypervisor.h>
> +#include <asm/smp.h>
>
>  #include <linux/ftrace.h>
>  #include "../../realmode/rm/wakeup.h"
> @@ -127,7 +128,13 @@ int x86_acpi_suspend_lowlevel(void)
>          * value is in the actual %rsp register.
>          */
>         current->thread.sp =3D (unsigned long)temp_stack + sizeof(temp_st=
ack);
> -       smpboot_control =3D smp_processor_id();
> +       /*
> +        * Ensure the CPU knows which one it is when it comes back, if
> +        * it isn't in parallel mode and expected to work that out for
> +        * itself.
> +        */
> +       if (!(smpboot_control & STARTUP_PARALLEL_MASK))
> +               smpboot_control =3D smp_processor_id();
>  #endif
>         initial_code =3D (unsigned long)wakeup_long64;
>         saved_magic =3D 0x123456789abcdef0L;
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 20d9a604da7c..ac1d7e5da1f2 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -2377,7 +2377,7 @@ static int nr_logical_cpuids =3D 1;
>  /*
>   * Used to store mapping between logical CPU IDs and APIC IDs.
>   */
> -static int cpuid_to_apicid[] =3D {
> +int cpuid_to_apicid[] =3D {
>         [0 ... NR_CPUS - 1] =3D -1,
>  };
>
> diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topolog=
y.c
> index 5e868b62a7c4..4373442e500a 100644
> --- a/arch/x86/kernel/cpu/topology.c
> +++ b/arch/x86/kernel/cpu/topology.c
> @@ -9,6 +9,7 @@
>  #include <asm/apic.h>
>  #include <asm/memtype.h>
>  #include <asm/processor.h>
> +#include <asm/cpu.h>
>
>  #include "cpu.h"
>
> @@ -32,7 +33,7 @@ EXPORT_SYMBOL(__max_die_per_package);
>  /*
>   * Check if given CPUID extended topology "leaf" is implemented
>   */
> -static int check_extended_topology_leaf(int leaf)
> +int check_extended_topology_leaf(int leaf)
>  {
>         unsigned int eax, ebx, ecx, edx;
>
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index 6a8238702eab..65bca47d84a1 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -25,6 +25,7 @@
>  #include <asm/export.h>
>  #include <asm/nospec-branch.h>
>  #include <asm/fixmap.h>
> +#include <asm/smp.h>
>
>  /*
>   * We are not able to switch in one step to the final KERNEL ADDRESS SPA=
CE
> @@ -234,8 +235,61 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_=
L_GLOBAL)
>         ANNOTATE_NOENDBR // above
>
>  #ifdef CONFIG_SMP
> +       /*
> +        * For parallel boot, the APIC ID is retrieved from CPUID, and th=
en
> +        * used to look up the CPU number.  For booting a single CPU, the
> +        * CPU number is encoded in smpboot_control.
> +        *
> +        * Bit 31       STARTUP_APICID_CPUID_0B flag (use CPUID 0x0b)
> +        * Bit 30       STARTUP_APICID_CPUID_01 flag (use CPUID 0x01)
> +        * Bit 0-24     CPU# if STARTUP_APICID_CPUID_xx flags are not set
> +        */
>         movl    smpboot_control(%rip), %ecx
> +       testl   $STARTUP_APICID_CPUID_0B, %ecx
> +       jnz     .Luse_cpuid_0b
> +       testl   $STARTUP_APICID_CPUID_01, %ecx
> +       jnz     .Luse_cpuid_01
> +       andl    $0x0FFFFFFF, %ecx
> +       jmp     .Lsetup_cpu
> +
> +.Luse_cpuid_01:
> +       mov     $0x01, %eax
> +       cpuid
> +       mov     %ebx, %edx
> +       shr     $24, %edx
> +       jmp     .Lsetup_AP
>
> +.Luse_cpuid_0b:
> +       mov     $0x0B, %eax
> +       xorl    %ecx, %ecx
> +       cpuid
> +
> +.Lsetup_AP:
> +       /* EDX contains the APIC ID of the current CPU */
> +       xorq    %rcx, %rcx
> +       leaq    cpuid_to_apicid(%rip), %rbx
> +
> +.Lfind_cpunr:
> +       cmpl    (%rbx,%rcx,4), %edx
> +       jz      .Lsetup_cpu
> +       inc     %ecx
> +#ifdef CONFIG_FORCE_NR_CPUS
> +       cmpl    $NR_CPUS, %ecx
> +#else
> +       cmpl    nr_cpu_ids(%rip), %ecx
> +#endif
> +       jb      .Lfind_cpunr
> +
> +       /*  APIC ID not found in the table. Drop the trampoline lock and =
bail. */
> +       movq    trampoline_lock(%rip), %rax
> +       lock
> +       btrl    $0, (%rax)
> +
> +1:     cli
> +       hlt
> +       jmp     1b
> +
> +.Lsetup_cpu:
>         /* Get the per cpu offset for the given CPU# which is in ECX */
>         movq    __per_cpu_offset(,%rcx,8), %rdx
>  #else
> @@ -264,6 +318,14 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_=
L_GLOBAL)
>         lgdt    (%rsp)
>         addq    $16, %rsp
>
> +       /* Drop the realmode protection. For the boot CPU the pointer is =
NULL! */
> +       movq    trampoline_lock(%rip), %rax
> +       testq   %rax, %rax
> +       jz      .Lsetup_data_segments
> +       lock
> +       btrl    $0, (%rax)
> +
> +.Lsetup_data_segments:
>         /* set up data segments */
>         xorl %eax,%eax
>         movl %eax,%ds

This can still go earlier, right after "movq TASK_threadsp(%rax),
%rsp".  The GDT descriptor is placed on the idle thread stack, so it's
safe to drop the lock before it.

--
Brian Gerst
