Return-Path: <kvm+bounces-1549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BEBFD7E94E4
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 03:32:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 25761B20AF2
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 02:32:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 766118BFC;
	Mon, 13 Nov 2023 02:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="SId8SUDD"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD1BC8EA
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 02:31:59 +0000 (UTC)
Received: from smtp-bc0f.mail.infomaniak.ch (smtp-bc0f.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc0f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B13F111
	for <kvm@vger.kernel.org>; Sun, 12 Nov 2023 18:31:52 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
	by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4STCsl0DVFzMpxDR;
	Mon, 13 Nov 2023 02:23:55 +0000 (UTC)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4STCsh0MRRz3X;
	Mon, 13 Nov 2023 03:23:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1699842234;
	bh=QstzL659XZU/a3hZMMg1cmFJi2RvIaC6fMPseN83m0M=;
	h=From:To:Cc:Subject:Date:From;
	b=SId8SUDDjGS4ilSlm6/Pkxn50JMX8rN5A0J19+k5Z7U0f5g3RMEFuTj4LuXwhl51f
	 uz/08SVk3UPEMsk+u+nhSLZAYOz1i2JTxJNvxBoejEGh9N/tL7cC67R7XIwJ6IGl7j
	 ycdiY3+IzqpsdG1N1xJQyhX8gYSu03NvmPb7whks=
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Kees Cook <keescook@chromium.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Alexander Graf <graf@amazon.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Forrest Yuan Yu <yuanyu@google.com>,
	James Gowans <jgowans@amazon.com>,
	James Morris <jamorris@linux.microsoft.com>,
	John Andersen <john.s.andersen@intel.com>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Marian Rotariu <marian.c.rotariu@gmail.com>,
	=?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
	=?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
	Thara Gopinath <tgopinath@microsoft.com>,
	Trilok Soni <quic_tsoni@quicinc.com>,
	Wei Liu <wei.liu@kernel.org>,
	Will Deacon <will@kernel.org>,
	Yu Zhang <yu.c.zhang@linux.intel.com>,
	Zahra Tarkhani <ztarkhani@microsoft.com>,
	=?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
	dev@lists.cloudhypervisor.org,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	qemu-devel@nongnu.org,
	virtualization@lists.linux-foundation.org,
	x86@kernel.org,
	xen-devel@lists.xenproject.org
Subject: [RFC PATCH v2 00/19] Hypervisor-Enforced Kernel Integrity
Date: Sun, 12 Nov 2023 21:23:07 -0500
Message-ID: <20231113022326.24388-1-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

Hi,

This patch series is a proof-of-concept that implements new KVM features
(guest memory attributes, MBEC support, CR pinning) and defines a new
API to protect guest VMs. You can find related resources, including the
related commits here: https://github.com/heki-linux
We'll talk about this work and the related LVBS project at LPC:
* https://lpc.events/event/17/contributions/1486/
* https://lpc.events/event/17/contributions/1515/

The main idea being that kernel self-protection mechanisms should be
delegated to a more privileged part of the system, that is the
hypervisor.  It is still the role of the guest kernel to request such
restrictions according to its configuration. The high-level security
guarantees provided by the hypervisor are semantically the same as a
subset of those the kernel already enforces on itself (CR pinning
hardening and memory protections), but with much higher guarantees.

We'd like the mainline kernel to support such hardening features
leveraging virtualization. We're looking for reviews and comments that
can help mainline these two parts: the KVM implementation and the guest
kernel API layer designed to support different hypervisors. The guest
kernel API layer contains a global struct heki_hypervisor to share data
and functions between the common code and the hypervisor support code.
The struct heki_hypervisor enables to plug in different backend
implementations that are initialized with the heki_early_init() and
heki_late_init() calls. This RFC is a call for collaboration. There is a
lot to do, either on hypervisors, guest kernels or VMMs sides.

We took inspiration from previous patches, mainly the KVMI [1] [2] and
KVM CR-pinning [3] series, revamped and simplified relevant parts to fit
well with our goal, added support for MBEC, added two hypercalls, and
created a kernel API for VMs to request protection in a generic way that
can be leveraged by any hypervisor.

This patch series is based on the kvm-x86's guest_memfd branch [4] [5],
and requires the host to support MBEC. This can easily be checked with:
grep ept_mode_based_exec /proc/cpuinfo You can test it by enabling
CONFIG_HEKI, CONFIG_HEKI_TEST, CONFIG_KUNIT_DEFAULT_ENABLED, and adding
the heki_test=N boot argument to the guest as explained in the last
patch.

# Main changes since v1

We replaced the KVM's page tracking mechanism with the new per-page
attributes patch series [5]. The main difference is that the Heki
per-page attributes should be set by the guest instead of the host.
Indeed, the security policy is defined by the guest and the host should
only be able to enforce it on its side (e.g. device drivers).
Furthermore, the host may not be trusted by the guest
(i.e., confidential computing).

The main previous limitation was the statically enforced permissions.
Mechanisms that dynamically impact kernel executable memory are now
handled (e.g., kernel modules, tracepoints, eBPF JIT) but not
authenticated yet (see Current limitations).

This version supports dynamic kernel memory permissions.  However, the
kernel does not know about all the pages that have been assigned to the
guest. It knows only about the memory that has been passed to it. The
VMM is the one that knows about all the pages. In a future version, the
VMM will be enhanced to set the memory attributes for the pages that are
not known to the kernel. The kernel will then set permissions for the
pages that are actually mapped in its address space. Other pages are
left alone. In order to set EPT permissions for a page, KVM can lookup
the memory attributes for the page. If the attributes are not present,
KVM can use a default of read-write. This will make it efficient as
memory attributes need to be set only for the pages that the kernel
actually maps. Also, this will serve to implement a deny-by-default
policy for execute permissions.

We implemented a mechanism to dynamically synchronize the guest's memory
permissions with KVM. The original KVM_HC_LOCK_MEM_PAGE_RANGES hypercall
contained support for statically defined sections (text, rodata, etc).
It has been redesigned like this:

- The previous version accepted an array of physically contiguous
  ranges. This is appropriate for statically defined sections which are
  loaded in contiguous memory.  But, for other cases like module
  loading, the pages would be discontinuous. The current version of the
  hypercall accepts a page list to fix this.

- The previous version passed permission combinations. E.g.,
  HEKI_MEM_ATTR_EXEC would imply R_X. The current version passes
  permissions as memory attributes and each of the permissions must be
  separately specified. E.g., for text, (MEM_ATTR_READ | MEM_ATTR_EXEC)
  must be passed.

- The previous version locked down the permissions for guest pages so
  that once the permissions are set, they cannot be changed. In this
  version, permissions can be either immutable (MEM_ATTR_IMMUTABLE) or
  can be changed dynamically.  So, the hypercall has been renamed to
  KVM_HC_PROTECT_MEMORY. The dynamic setting of permissions is needed
  by the following features (probably not a complete list):
  - Kprobes and Optprobes
  - Static call optimization
  - Jump Label optimization
  - Ftrace and Livepatch
  - Module loading and unloading
  - eBPF JIT
  - Kexec
  - Kgdb

Examples:
- A text page can be made writable very briefly to install a probe or a
  trace.
- eBPF JIT can populate a writable page with code and make it
  read-execute.
- Module load can load read-only data into a writable page and make the
  page read-only.
- When pages are unmapped, their permissions in the EPT must revert to
  read-write.

KVM now sends a GP fault if a guest attempts to change its pinned CRs.

Because the VMM needs to be involved (e.g. device driver mapping memory)
and to know the guests' requested memory permissions, we implemented two
new kind of VM exits to be able to notify the VMM about guests' Heki
configurations and policy violations. Indeed, forwarding such signals to
the VMM could help improve attack detection, and react to such attempt
(e.g. log events, stop the VM).  Giving visibility to the VMM would also
enable to migrate VMs.

# Threat model

The main threat model is a malicious user space process exploiting a
kernel vulnerability to gain more privileges or to bypass the
access-control system.  This threat also covers attacks coming from
network or storage data (e.g., malformed network packet, inconsistent
drive content).

An extended threat model, following pKVM (and partially confidential
computing) efforts, is to protect as much as possible against the VMM.
This means that the security policy should mainly be defined and
requested by the guest to the hypervisor.  The limit of this approach is
the VMM's resources (e.g. exposed memory), which should also be
protected from the guest.

Considering all potential ways to compromise a kernel, Heki's goal is to
harden a sane kernel before a runtime attack to make it more difficult,
and potentially to cause such an attack to fail. We consider the kernel
itself to be partially malicious during its lifetime e.g., because a ROP
attack that could disable kernel self-protection mechanisms and make
kernel exploitation much easier. Indeed, an exploit is often split into
several stages, each bypassing some security measures. Getting the
guarantee that new kernel executable code is not possible increases the
cost of an attack, hopefully to the point that it is not worth it.

To protect against persistent attacks, complementary security mechanisms
should be used (e.g., kernel module signing, IMA, IPE, Lockdown).

# Prerequisites

For this set of features to be useful, guest kernels must be trusted by
the VM owners at boot time, before launching any user space processes
nor receiving potentially malicious network packets. It is then required
to have a security mechanism to provide or check this initial trust
(e.g., secure boot, kernel module signing).

# How does it work?

This implementation mainly leverages KVM capabilities to control the
Second Layer Address Translation (or the Two Dimensional Paging e.g.,
Intel's EPT or AMD's RVI/NPT) and Mode Based Execution Control (Intel's
MBEC) introduced with the Kaby Lake (7th generation) architecture. This
allows to set permissions on memory pages in a complementary way to the
guest kernel's managed memory permissions. If any permissions are set as
immutable, they are locked and there is no way back.

The KVM_HC_PROTECT_MEMORY hypercall enables the guest kernel to enforce
boot time mapped pages with the MEM_ATTR_{READ,WRITE,EXEC} attributes.

The current implementation walks the kernel address space and requests
permission enforcement according to the mappings present.  For instance,
it sets its .rodata (i.e., any const or __ro_after_init variables, which
includes critical security data such as LSM parameters) and .text
sections as non-writable, and the .text section is the only one where
kernel execution is initially allowed.  This is possible thanks to the
new MBEC support implemented by this series (otherwise the vDSO would
have to be executable). Thanks to this hardware support (VT-x, EPT and
MBEC), the performance impact of such guest protection is negligible at
run time.

A page can be mapped to multiple VAs. Each mapping can have different
permissions. Also each mapping may have a different page size. The
collective permissions across all the mappings must be applied in the
EPT. To make this possible, the implementation maintains permissions
counters for each 4K page (one counter each for read, write and
execute). The kernel address space is walked, the mappings are
identified, the counters are updated and the EPT permissions are set
based on the counters. Currently, the overhead from this whole process
can be visible during boot, especially with debugging features such as
KASAN.  We have some ideas that we will try out for a next series. We
welcome any suggestions to improve this part.

The KVM_HC_LOCK_CR_UPDATE hypercall enables guests to pin some of its
CPU control register flags (e.g., X86_CR0_WP, X86_CR4_SMEP,
X86_CR4_SMAP), which is another complementary hardening mechanism.

Two new kinds of VM exits are implemented: one for a guest Heki request
(i.e. hypercall), and another for a guest attempt to change its pinned
CRs. We haven't implemented such VM exit for memory-related events yet,
that will be part of a next series if the designed is approved.

When the guest attempts to update pinned CRs or to access memory in a
way that is not allowed, the VMM can then be notified and react to such
attack attempt. After that, if the VM is still running, KVM sends either
a GP fault or a page fault to the guest. The guest could then send a
signal to the user space process that triggered this policy violation
(not implemented).

Heki can be enabled with the heki=1 boot command argument.

# Similar implementations

Here is a non-exhaustive list of similar implementations that we looked
at and took some ideas from. Linux mainline doesn't support such
security features, let's change that!

Windows's Virtualization-Based Security is a proprietary technology
that provides a superset of this kind of security mechanism, relying on
Hyper-V and Virtual Trust Levels which enables to have light and secure
VM enforcing restrictions on a full guest VM. This includes several
components such as HVCI for code authenticity, or HyperGuard for
monitoring and protecting kernel code and data.

Samsung's Real-time Kernel Protection (RKP) and Huawei Hypervisor
Execution Environment (HHEE) rely on proprietary hypervisors to protect
some Android devices. They monitor critical kernel data (e.g., page
tables, credentials, selinux_enforcing).

The iOS Kernel Patch Protection (KPP/Watchtower) is a proprietary
solution running in EL3 that monitors and protects critical parts of the
kernel. It is now replaced with a hardware-based mechanism: KTTR/RoRgn.

Bitdefender's Hypervisor Memory Introspection (HVMI) is an open-source
(but out of tree) set of components leveraging virtualization. HVMI
implementation is very complex, and this approach implies potential
semantic gap issues (i.e., kernel data structures may change from one
version to another).

Linux Kernel Runtime Guard is an open-source kernel module that can
detect some kernel data illegitimate modifications. Because it is the
same kernel as the compromised one, an attacker could also bypass or
disable these checks.

Intel's Virtualization Based Hardening [6] [7] is an open-source
proof-of-concept of a thin hypervisor dedicated to guest protection. As
such, it cannot be used to manage several VMs.

# Similar Linux patches

The VM introspection [1] [2] patch series proposed a set of features to
put probes and introspect VMs for debugging and security reasons. We
changed and included the prewrite page tracking and the fault_gva parts.
Heki is much simpler because it focuses on guest hardening, not
introspection.

Paravirtualized Control Register pinning [3] added a set of KVM IOCTLs
to restrict some flags to be set. Heki doesn't implement such user space
interface, but only a dedicated hypercall to lock such registers. A
superset of these flags is configurable with Heki.

The Hypervisor Based Integrity patches [8] [9] only contain a generic
IPC mechanism (KVM_HC_UCALL hypercall) to request protection to the VMM.
The idea was to extend the KVM_SET_USER_MEMORY_REGION IOCTL to support
more permission than read-only.

# Current limitations

The main limitation of this patch series is that the executable kernel
data (e.g. kernel module) is only authenticated by the guest, not by the
hypervisor nor the VMM.  Because the hypervisor is highly privileged and
critical to the security of all the VMs, we don't want to implement a
code authentication mechanism in the hypervisor itself but delegate this
verification to something much less privileged. We are thinking of two
ways to solve this: implement this verification in the VMM or spawn a
dedicated special VM (similar to Windows's VBS). There are pros on cons
to each approach: complexity, verification code ownership (guest's or
VMM's), access to guest memory (i.e., confidential computing).

In this version, the immutable attribute is set on kernel text. So, it
is not possible to use ftrace, Kprobes, etc on kernel text (these are
still possible on module text). The immutable attribute is needed
because we do not have authentication in place yet.

All permissions changes must be authenticated. For changes that happen
during module loading, the module signature can be used for
authentication. But for intrinsic kernel features such as ftrace and
Kprobes, what do we use to authenticate a request? How do we make sure
that it is legitimate? We are looking for ideas in this area.

Also, each authentication involves a round trip from the guest to the
VMM and the hypervisor. This overhead could be significant. We welcome
ideas on improving this as well.

We currently use static address ranges to configure protections at boot
(see heki_arch_early_init). This is not compatible with KASLR yet, but
this will be handled in a next patch series.

Because the guest's virtual address translation is not protected by the
hypervisor, a compromised kernel could map existing physical pages into
arbitrary virtual addresses. The new Intel's Hypervisor-Managed Linear
Address Translation [10] (HLAT) could be used to extend the current
protection and cover this case.

ROP is not covered by this patch series. Guest kernels can still jump to
arbitrary executable pages according to their control-flow integrity
protection.

# Future work

New dynamic restrictions could enable to improve the protected data by
including security-sensitive data such as LSM states, seccomp filters,
keyrings... This requires support outside of the hypervisor.

An execute-only mode could also be useful (cf. XOM for KVM [11] [12]).

Extending register pinning (e.g., MSRs).

For now, MBEC is only supported on a bare metal machine as KVM host;
nested virtualization is not supported yet.  Being able to protect
nested guests might be possible but we need to figure out the potential
security implications.

Protecting the host would be useful, but that doesn't really fit with
the KVM model. The Protected KVM project is a first step to help in this
direction [13].

We only tested this with an Intel CPU, but this approach should work the
same with an AMD CPU starting with the Zen 2 generation and their Guest
Mode Execute Trap (GMET) capability.

We also kept some TODOs to highlight missing checks and code sharing
issues, and some pr_warn() calls to help understand how it works. Tests
need to be improved (e.g., invalid hypercall arguments).

We'll present this work at the Linux Plumbers Conference next week.

[1] https://lore.kernel.org/all/20211006173113.26445-1-alazar@bitdefender.com/
[2] https://www.linux-kvm.org/images/7/72/KVMForum2017_Introspection.pdf
[3] https://lore.kernel.org/all/20200617190757.27081-1-john.s.andersen@intel.com/
[4] https://github.com/kvm-x86/linux
[5] https://lore.kernel.org/all/20231027182217.3615211-1-seanjc@google.com/
[6] https://github.com/intel/vbh
[7] https://sched.co/TmwN
[8] https://sched.co/eE3f
[9] https://lore.kernel.org/all/20200501185147.208192-1-yuanyu@google.com/
[10] https://sched.co/eE4F
[11] https://lore.kernel.org/kvm/20191003212400.31130-1-rick.p.edgecombe@intel.com/
[12] https://lpc.events/event/4/contributions/283/
[13] https://sched.co/eE24

Please reach out to us by replying to this thread, we're looking for
people to join and collaborate on this project!

Previous version:
v1: https://lore.kernel.org/r/20230505152046.6575-1-mic@digikod.net

Regards,

Madhavan T. Venkataraman (9):
  virt: Introduce Hypervisor Enforced Kernel Integrity (Heki)
  KVM: x86: Add new hypercall to set EPT permissions
  x86: Implement the Memory Table feature to store arbitrary per-page
    data
  heki: Implement a kernel page table walker
  heki: x86: Initialize permissions counters for pages mapped into KVA
  heki: x86: Initialize permissions counters for pages in
    vmap()/vunmap()
  heki: x86: Update permissions counters when guest page permissions
    change
  heki: x86: Update permissions counters during text patching
  heki: x86: Protect guest kernel memory using the KVM hypervisor

Mickaël Salaün (10):
  KVM: x86: Add new hypercall to lock control registers
  KVM: x86: Add notifications for Heki policy configuration and
    violation
  heki: Lock guest control registers at the end of guest kernel init
  KVM: VMX: Add MBEC support
  KVM: x86: Add kvm_x86_ops.fault_gva()
  KVM: x86: Make memory attribute helpers more generic
  KVM: x86: Extend kvm_vm_set_mem_attributes() with a mask
  KVM: x86: Extend kvm_range_has_memory_attributes() with match_all
  KVM: x86: Implement per-guest-page permissions
  virt: Add Heki KUnit tests

 Documentation/virt/kvm/x86/hypercalls.rst |  31 +++
 Kconfig                                   |   2 +
 arch/x86/Kconfig                          |   1 +
 arch/x86/include/asm/kvm-x86-ops.h        |   1 +
 arch/x86/include/asm/kvm_host.h           |   2 +
 arch/x86/include/asm/vmx.h                |  11 +-
 arch/x86/include/asm/x86_init.h           |   1 +
 arch/x86/include/uapi/asm/kvm_para.h      |   2 +
 arch/x86/kernel/alternative.c             |   5 +
 arch/x86/kernel/cpu/common.c              |   4 +-
 arch/x86/kernel/cpu/hypervisor.c          |   1 +
 arch/x86/kernel/kvm.c                     |  67 +++++
 arch/x86/kernel/setup.c                   |   2 +
 arch/x86/kvm/Kconfig                      |   2 +
 arch/x86/kvm/Makefile                     |   4 +-
 arch/x86/kvm/mmu.h                        |   3 +-
 arch/x86/kvm/mmu/mmu.c                    | 114 ++++++--
 arch/x86/kvm/mmu/mmutrace.h               |  11 +-
 arch/x86/kvm/mmu/paging_tmpl.h            |  19 +-
 arch/x86/kvm/mmu/spte.c                   |  19 +-
 arch/x86/kvm/mmu/spte.h                   |  15 +-
 arch/x86/kvm/svm/svm.c                    |   9 +
 arch/x86/kvm/vmx/capabilities.h           |   7 +
 arch/x86/kvm/vmx/nested.c                 |   7 +
 arch/x86/kvm/vmx/vmx.c                    |  45 +++-
 arch/x86/kvm/vmx/vmx.h                    |   1 +
 arch/x86/kvm/x86.c                        | 310 ++++++++++++++++++++++
 arch/x86/kvm/x86.h                        |  23 ++
 arch/x86/mm/Makefile                      |   2 +
 arch/x86/mm/heki.c                        | 135 ++++++++++
 arch/x86/mm/pat/set_memory.c              |  51 ++++
 include/linux/heki.h                      | 195 ++++++++++++++
 include/linux/kvm_host.h                  |  11 +-
 include/linux/kvm_mem_attr.h              |  32 +++
 include/linux/mem_table.h                 |  55 ++++
 include/uapi/linux/kvm.h                  |  27 ++
 include/uapi/linux/kvm_para.h             |   2 +
 init/main.c                               |   3 +
 kernel/Makefile                           |   2 +
 kernel/mem_table.c                        | 219 +++++++++++++++
 mm/mm_init.c                              |   1 +
 mm/vmalloc.c                              |   7 +
 virt/Makefile                             |   1 +
 virt/heki/Kconfig                         |  42 +++
 virt/heki/Makefile                        |   6 +
 virt/heki/common.h                        |  16 ++
 virt/heki/counters.c                      | 274 +++++++++++++++++++
 virt/heki/main.c                          | 155 +++++++++++
 virt/heki/tests.c                         | 207 +++++++++++++++
 virt/heki/walk.c                          | 140 ++++++++++
 virt/kvm/kvm_main.c                       |  65 +++--
 virt/lib/kvm_permissions.c                | 104 ++++++++
 52 files changed, 2401 insertions(+), 70 deletions(-)
 create mode 100644 arch/x86/mm/heki.c
 create mode 100644 include/linux/heki.h
 create mode 100644 include/linux/kvm_mem_attr.h
 create mode 100644 include/linux/mem_table.h
 create mode 100644 kernel/mem_table.c
 create mode 100644 virt/heki/Kconfig
 create mode 100644 virt/heki/Makefile
 create mode 100644 virt/heki/common.h
 create mode 100644 virt/heki/counters.c
 create mode 100644 virt/heki/main.c
 create mode 100644 virt/heki/tests.c
 create mode 100644 virt/heki/walk.c
 create mode 100644 virt/lib/kvm_permissions.c


base-commit: 881375a408c0f4ea451ff14545b59216d2923881
-- 
2.42.1


