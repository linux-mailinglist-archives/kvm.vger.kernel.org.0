Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEC86F85C1
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 17:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232867AbjEEPaM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 11:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232948AbjEEP3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 11:29:48 -0400
Received: from smtp-190f.mail.infomaniak.ch (smtp-190f.mail.infomaniak.ch [185.125.25.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63E116081
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 08:29:34 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4QCZD24pG9zMqLbT;
        Fri,  5 May 2023 17:21:54 +0200 (CEST)
Received: from unknown by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4QCZCy4M9gzMpqZ9;
        Fri,  5 May 2023 17:21:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1683300114;
        bh=Qvc7SESfj28DhibUMOxF8XDC2Dv9Nk03svVhSexGCDo=;
        h=From:To:Cc:Subject:Date:From;
        b=sdjSaTf+L8uD2OtYxlVlBp2/RF9APLo7BFa1o6O4wpLqtYohS60n6C+Xb7KWY8oWN
         1ThaIncVJDSPEINsOmIciOHlJQ5lHfvGTzMJwRq9cC3H70enX0j5qGVkDZEv5T8RHU
         X7DMszBWczedvVBKFSwCEr6PDfJcgmy7Hfrc8dOE=
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        Alexander Graf <graf@amazon.com>,
        Forrest Yuan Yu <yuanyu@google.com>,
        James Morris <jamorris@linux.microsoft.com>,
        John Andersen <john.s.andersen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        Thara Gopinath <tgopinath@microsoft.com>,
        Will Deacon <will@kernel.org>,
        Zahra Tarkhani <ztarkhani@microsoft.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        dev@lists.cloudhypervisor.org, kvm@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: [RFC PATCH v1 0/9] Hypervisor-Enforced Kernel Integrity
Date:   Fri,  5 May 2023 17:20:37 +0200
Message-Id: <20230505152046.6575-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

This patch series is a proof-of-concept that implements new KVM features
(extended page tracking, MBEC support, CR pinning) and defines a new API to
protect guest VMs. No VMM (e.g., Qemu) modification is required.

The main idea being that kernel self-protection mechanisms should be delegated
to a more privileged part of the system, hence the hypervisor. It is still the
role of the guest kernel to request such restrictions according to its
configuration. The high-level security guarantees provided by the hypervisor
are semantically the same as a subset of those the kernel already enforces on
itself (CR pinning hardening and memory page table protections), but with much
higher guarantees.

We'd like the mainline kernel to support such hardening features leveraging
virtualization. We're looking for reviews and comments that can help mainline
these two parts: the KVM implementation and the guest kernel API layer designed
to support different hypervisors. The struct heki_hypervisor enables to plug in
different backend implementations that are initialized with the
heki_early_init() and heki_late_init() calls. This RFC is an initial
call for collaboration. There is a lot to do, either on hypervisors,
guest kernels or VMMs sides.

We took inspiration from previous patches, mainly the KVMI [1] [2] and KVM
CR-pinning [3] series, revamped and simplified relevant parts to fit well with
our goal, added support for MBEC to enable a deny-by-default kernel execution
policy (e.g., write xor execute), added two hypercalls, and created a kernel
API for VMs to request protection in a generic way that can be leveraged by any
hypervisor.

This proof-of-concept is named Hypervisor-Enforced Kernel Integrity (Heki),
which reflects the goal to empower guest kernels to protect themselves. This
name is new to the kernel, and it enables to easily identify new code required
for this set of features.

This patch series is based on Linux 6.2 and requires the host to support
MBEC. This can easily be checked with:
grep ept_mode_based_exec /proc/cpuinfo
You can test it by enabling CONFIG_HEKI, CONFIG_HEKI_TEST,
CONFIG_KUNIT_DEFAULT_ENABLED, and adding the heki_test=N boot argument
to the guest as explained in the last patch. Another way to test it is
to try to load a kernel module in the guest: you'll see KVM creating
synthetic page faults. This only works using a bare metal machine as KVM
host; nested virtualization is not supported yet.

# Threat model

The initial threat model is a malicious user space process exploiting a kernel
vulnerability to gain more privileges or to bypass the access-control system.
An extended threat model could include attacks coming from network or storage
data (e.g., malformed network packet, inconsistent drive content).

Considering all potential ways to compromise a kernel, Heki's goal is to harden
a sane kernel before a runtime attack to make it more difficult, and
potentially to make such an attack failed. We consider the kernel itself to be
partially malicious during its lifetime e.g., because a ROP attack that could
disable kernel self-protection mechanisms and make kernel exploitation much
easier. Indeed, an exploit is often split into several stages, each bypassing
some security measures. Getting the guarantee that new kernel executable code
is not possible increases the cost of an attack, hopefully to the point that it
is not worth it.

To protect against persistent attacks, complementary security mechanisms should
be used (e.g., kernel module signing, IMA, IPE, Lockdown).

# Prerequisites

For this set of features to be useful, guest kernels must be trusted by the VM
owners at boot time, before launching any user space processes nor receiving
potentially malicious network packets. It is then required to have a security
mechanism to provide or check this initial trust (e.g., secure boot, kernel
module signing).

# How does it work?

This implementation mainly leverages KVM capabilities to control the Second
Layer Address Translation (or the Two Dimensional Paging e.g., Intel's EPT or
AMD's RVI/NPT) and Mode Based Execution Control (Intel's MBEC) introduced with
the Kaby Lake (7th generation) architecture. This allows to set permissions on
memory pages in a complementary way to the guest kernel's managed memory
permissions. Once these permissions are set, they are locked and there is no
way back.

A first KVM_HC_LOCK_MEM_PAGE_RANGES hypercall enables the guest kernel to lock
a set of its memory page ranges with either the HEKI_ATTR_MEM_NOWRITE or the
HEKI_ATTR_MEM_EXEC attribute. The first one denies write access to a specific
set of pages (allow-list approach), and the second only allows kernel execution
for a set of pages (deny-list approach).

The current implementation sets the whole kernel's .rodata (i.e., any const or
__ro_after_init variables, which includes critical security data such as LSM
parameters) and .text sections as non-writable, and the .text section is the
only one where kernel execution is allowed. This is possible thanks to the new
MBEC support also brough by this series (otherwise the vDSO would have to be
executable). Thanks to this hardware support (VT-x, EPT and MBEC), the
performance impact of such guest protection is negligible.

The second KVM_HC_LOCK_CR_UPDATE hypercall enables guests to pin some of its
CPU control register flags (e.g., X86_CR0_WP, X86_CR4_SMEP, X86_CR4_SMAP),
which is another complementary hardening mechanism.

Heki can be enabled with the heki=1 boot command argument.

# Similar implementations

Here is a non-exhaustive list of similar implementations that we looked at and
took some ideas. Linux mainline doesn't support such security features, let's
change that!

Windows's Virtualization-Based Security is a proprietary technology relying
that provides a superset of this kind of security mechanism, relying on Hyper-V
and Virtual Trust Levels which enables to have light and secure VM enforcing
restrictions on a full guest VM. This includes several components such as HVCI
which is in charge of code authenticity, or HyperGuard which monitors and
protects kernel code and data.

Samsung's Real-time Kernel Protection (RKP) and Huawei Hypervisor Execution
Environment (HHEE) rely on proprietary hypervisors to protect some Android
devices. They monitor critical kernel data (e.g., page tables, credentials,
selinux_enforcing).

The iOS Kernel Patch Protection is a proprietary solution that relies on a
secure enclave (dedicated hardware component) to monitor and protect critical
parts of the kernel.

Bitdefender's Hypervisor Memory Introspection (HVMI) is an open-source (but out
of tree) set of components leveraging virtualization. HVMI implementation is
very complex, and this approach implies potential semantic gap issues (i.e.,
kernel data structures may change from one version to another).

Linux Kernel Runtime Guard is an open-source kernel module that can detect some
kernel data illegitimate modifications. Because it is the same kernel as the
compromised one, an attacker could also bypass or disable these checks.

Intel's Virtualization Based Hardening [4] [5] is an open-source
proof-of-concept of a thin hypervisor dedicated to guest protection. As such,
it cannot be used to manage several VMs.

# Similar Linux patches

The VM introspection [1] [2] patch series proposed a set of features to
put probes and introspect VMs for debugging and security reasons. We
changed and included the prewrite page tracking and the fault_gva parts.
Heki is much simpler because it focuses on guest hardening, not
introspection.

Paravirtualized Control Register pinning [3] added a set of KVM IOCTLs to
restrict some flags to be set. Heki doesn't implement such user space
interface, but only a dedicated hypercall to lock such registers. A superset of
these flags is configurable with Heki.

The Hypervisor Based Integrity patches [6] [7] only contain a generic IPC
mechanism (KVM_HC_UCALL hypercall) to request protection to the VMM. The idea
was to extend the KVM_SET_USER_MEMORY_REGION IOCTL to support more permission
than read-only.

# Current limitations

The main limitation of this patch series is the statically enforced
permissions. This is not an issue for kernels without module but this needs to
be addressed.  Mechanisms that dynamically impact kernel executable memory are
not handled for now (e.g., kernel modules, tracepoints, eBPF JIT), and such
code will need to be authenticated.  Because the hypervisor is highly
privileged and critical to the security of all the VMs, we don't want to
implement a code authentication mechanism in the hypervisor itself but delegate
this verification to something much less privileged. We are thinking of two
ways to solve this: implement this verification in the VMM or spawn a dedicated
special VM (similar to Windows's VBS). There are pros on cons to each approach:
complexity, verification code ownership (guest's or VMM's), access to guest
memory (i.e., confidential computing).

Because the guest's virtual address translation is not protected by the
hypervisor, a compromised kernel could map existing physical pages into
arbitrary virtual addresses. The new Intel's Hypervisor-Managed Linear Address
Translation [8] (HLAT) could be used to extend the current protection and cover
this case.

ROP is not covered by this patch series. Guest kernels can still jump to
arbitrary executable pages according to their control-flow integrity
protection.

# Future work

We think this kind of restrictions can be leveraged to log attempts of
forbidden actions. Forwarding such signals to the VMM could help improve attack
detection.

Giving visibility to the VMM would also enable to migrate VMs.

New dynamic restrictions could enable to improve the protected data by
including security-sensitive data such as LSM states, seccomp filters,
keyrings... This requires support outside of the hypervisor.

An execute-only mode could also be useful (cf. XOM for KVM [9] [10]).

Extending register pinning (e.g., MSRs).

Being able to protect nested guests might be possible but we need to figure out
the potential security implications.

Protecting the host would be useful, but that doesn't really fit with the KVM
model. The Protected KVM project is a first step to help in this direction
[11].

We only tested this with an Intel CPU, but this approach should work the same
with an AMD CPU starting with the Zen 2 generation and their Guest Mode Execute
Trap (GMET) capability.

We also kept some TODOs to highlight missing checks and code sharing issues,
and some pr_warn() calls to help understand how it works. Tests need to be
improved (e.g., invalid hypercall arguments).

We'll present this work at the Linux Security Summit North America next week.

[1] https://lore.kernel.org/all/20211006173113.26445-1-alazar@bitdefender.com/
[2] https://www.linux-kvm.org/images/7/72/KVMForum2017_Introspection.pdf
[3] https://lore.kernel.org/all/20200617190757.27081-1-john.s.andersen@intel.com/
[4] https://github.com/intel/vbh
[5] https://sched.co/TmwN
[6] https://sched.co/eE3f
[7] https://lore.kernel.org/all/20200501185147.208192-1-yuanyu@google.com/
[8] https://sched.co/eE4F
[9] https://lore.kernel.org/kvm/20191003212400.31130-1-rick.p.edgecombe@intel.com/
[10] https://lpc.events/event/4/contributions/283/
[11] https://sched.co/eE24

Please reach out to us by replying to this thread, we're looking for
people to join and collaborate on this project!

Regards,

Madhavan T. Venkataraman (2):
  virt: Implement Heki common code
  KVM: x86: Add Heki hypervisor support

Mickaël Salaün (7):
  KVM: x86: Add kvm_x86_ops.fault_gva()
  KVM: x86/mmu: Add support for prewrite page tracking
  KVM: x86: Add new hypercall to set EPT permissions
  KVM: x86: Add new hypercall to lock control registers
  KVM: VMX: Add MBEC support
  KVM: x86/mmu: Enable guests to lock themselves thanks to MBEC
  virt: Add Heki KUnit tests

 Documentation/virt/kvm/x86/hypercalls.rst |  34 +++
 Kconfig                                   |   2 +
 arch/x86/Kconfig                          |   1 +
 arch/x86/include/asm/kvm-x86-ops.h        |   1 +
 arch/x86/include/asm/kvm_host.h           |   2 +
 arch/x86/include/asm/kvm_page_track.h     |  12 +
 arch/x86/include/asm/sections.h           |   4 +
 arch/x86/include/asm/vmx.h                |  11 +-
 arch/x86/include/asm/x86_init.h           |   2 +
 arch/x86/kernel/cpu/common.c              |   2 +-
 arch/x86/kernel/cpu/hypervisor.c          |   1 +
 arch/x86/kernel/kvm.c                     |  72 +++++
 arch/x86/kernel/setup.c                   |  49 +++
 arch/x86/kernel/x86_init.c                |   1 +
 arch/x86/kvm/Kconfig                      |   1 +
 arch/x86/kvm/mmu.h                        |   3 +-
 arch/x86/kvm/mmu/mmu.c                    | 105 ++++++-
 arch/x86/kvm/mmu/mmutrace.h               |  11 +-
 arch/x86/kvm/mmu/page_track.c             |  33 +-
 arch/x86/kvm/mmu/paging_tmpl.h            |  16 +-
 arch/x86/kvm/mmu/spte.c                   |  29 +-
 arch/x86/kvm/mmu/spte.h                   |  15 +-
 arch/x86/kvm/mmu/tdp_mmu.c                |  73 +++++
 arch/x86/kvm/mmu/tdp_mmu.h                |   4 +
 arch/x86/kvm/svm/svm.c                    |   9 +
 arch/x86/kvm/vmx/capabilities.h           |   7 +
 arch/x86/kvm/vmx/nested.c                 |   7 +
 arch/x86/kvm/vmx/vmx.c                    |  48 ++-
 arch/x86/kvm/vmx/vmx.h                    |   1 +
 arch/x86/kvm/x86.c                        | 352 +++++++++++++++++++++-
 arch/x86/kvm/x86.h                        |  23 ++
 include/linux/heki.h                      |  90 ++++++
 include/linux/kvm_host.h                  |  20 ++
 include/uapi/linux/kvm_para.h             |   2 +
 init/main.c                               |   3 +
 virt/Makefile                             |   1 +
 virt/heki/Kconfig                         |  41 +++
 virt/heki/Makefile                        |   3 +
 virt/heki/heki.c                          | 321 ++++++++++++++++++++
 virt/kvm/kvm_main.c                       |   5 +
 40 files changed, 1377 insertions(+), 40 deletions(-)
 create mode 100644 include/linux/heki.h
 create mode 100644 virt/heki/Kconfig
 create mode 100644 virt/heki/Makefile
 create mode 100644 virt/heki/heki.c


base-commit: c9c3395d5e3dcc6daee66c6908354d47bf98cb0c
-- 
2.40.1

