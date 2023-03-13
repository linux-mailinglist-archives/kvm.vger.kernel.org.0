Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75AE36B84AE
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 23:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjCMWVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 18:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCMWVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 18:21:47 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABC21ABC8;
        Mon, 13 Mar 2023 15:21:41 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id e21so10591826oie.1;
        Mon, 13 Mar 2023 15:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678746101;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fgbx+G1VuVvdcoDypfrTksbqvojX7c9u8OaeQTCHp+c=;
        b=dBMG8unBS9QSzLmDbpSL9dtXEBefXalSxk+of102VftGEkwkc78Bfmb/I2u1Swgxfy
         DTytpkB8DI7XElDTWjKh+2QIg4pxax1/euhtAnBwJYy4+z1umo3xEzNb1ig2MIY/IiLD
         57u6Z/J/SPblUVzttzRp7+qdV2t9ANCaoWZil9Jx21lNxv30dHk8XxLC9TujIIYdV5rf
         Rr46VHqP+a2UkGOqYtKNtfSH05kYdfGB/2xoTtjbqFQamNuRv4uYPa0PzQOWeFEKDH5v
         AEa8Fds9uz8AcAZBbnVSvEGZYK1AKaVTTE6sEz8ZM6fSIltIlOwuBsfq9S3ho/ta/4ov
         8Kkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678746101;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fgbx+G1VuVvdcoDypfrTksbqvojX7c9u8OaeQTCHp+c=;
        b=0L0qkNNcxkOxBKTEi+qHdk0IrgmjhVv/34Z6tb2Dx0x4FFTmpKmK6okeC6kxTbrvVZ
         OR5AghiNIVUNIxRz3XaBrVctvofiQLnSRqrPwldOOUBptZS9SjnVFSkyTfZObm9vW361
         p81Ek7uP2+PFSSRU/hINqa7kZg7SApCCQ7822b8rA8K8V1aZ/KpWh1TwrmeZfx2KJKdf
         0Fu+tGoZsbLhduqGDTxa41R22AFIIqTDUBe3JnHzVOAyngtYPUtPE6EYgRoHB1lzx1cQ
         OGxDHGYjVzXH+wgrYPOC49I3nGF67pUHk+XnPGvvpNGfW8MB+D9ZOAgAgmniYXL3AFdi
         RnDg==
X-Gm-Message-State: AO0yUKWs24LPDQH1yy5HUfRdQzkNsRKl7n6k58E4mJ2xzK8FKVaiZ/CL
        U2N//2RzF1ULHw+gc3hTGWVwopy9cH70wgAgMA==
X-Google-Smtp-Source: AK7set/33w9YJuxg5L8xT3YGzQvuJq59gpvfncDw0aJqIauMDFaBDwmtkQg9+SmV9XMMn9+ddCx95rjo8gMy8ImjGz4=
X-Received: by 2002:aca:d19:0:b0:384:d02d:5f07 with SMTP id
 25-20020aca0d19000000b00384d02d5f07mr8962119oin.10.1678746101065; Mon, 13 Mar
 2023 15:21:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230308171328.1562857-1-usama.arif@bytedance.com> <20230308171328.1562857-10-usama.arif@bytedance.com>
In-Reply-To: <20230308171328.1562857-10-usama.arif@bytedance.com>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Mon, 13 Mar 2023 18:21:29 -0400
Message-ID: <CAMzpN2iz4UzQh7YGOo6vGB2qmpogiCUCTfYpvdeP=_Dm=66BwA@mail.gmail.com>
Subject: Re: [PATCH v14 09/12] x86/smpboot: Support parallel startup of
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
        David Woodhouse <dwmw@amazon.co.uk>,
        "Guilherme G . Piccoli" <gpiccoli@igalia.com>
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

On Wed, Mar 8, 2023 at 12:13=E2=80=AFPM Usama Arif <usama.arif@bytedance.co=
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
>  arch/x86/kernel/cpu/topology.c                |  2 +-
>  arch/x86/kernel/head_64.S                     | 64 +++++++++++++++++++
>  arch/x86/kernel/smpboot.c                     | 50 ++++++++++++++-
>  arch/x86/realmode/init.c                      |  3 +
>  arch/x86/realmode/rm/trampoline_64.S          | 27 ++++++--
>  11 files changed, 161 insertions(+), 9 deletions(-)
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
> index 5e868b62a7c4..1dc20f4dfa6e 100644
> --- a/arch/x86/kernel/cpu/topology.c
> +++ b/arch/x86/kernel/cpu/topology.c
> @@ -32,7 +32,7 @@ EXPORT_SYMBOL(__max_die_per_package);
>  /*
>   * Check if given CPUID extended topology "leaf" is implemented
>   */
> -static int check_extended_topology_leaf(int leaf)
> +int check_extended_topology_leaf(int leaf)
>  {
>         unsigned int eax, ebx, ecx, edx;
>
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index 6a8238702eab..c35f7c173832 100644
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
> @@ -293,6 +347,14 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_=
L_GLOBAL)
>         shrq    $32, %rdx
>         wrmsr
>
> +       /* Drop the realmode protection. For the boot CPU the pointer is =
NULL! */
> +       movq    trampoline_lock(%rip), %rax
> +       testq   %rax, %rax
> +       jz      .Lsetup_idt
> +       lock
> +       btrl    $0, (%rax)
> +
> +.Lsetup_idt:

Now that the lock only protects the realmode stack, releasing it can
happen right after the switch to the idle task stack..

--
Brian Gerst
