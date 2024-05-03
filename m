Return-Path: <kvm+bounces-16504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A43D8BAD89
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 15:20:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 942A11F2284B
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 13:20:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81029154423;
	Fri,  3 May 2024 13:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="pqC5bnOX"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-42ae.mail.infomaniak.ch (smtp-42ae.mail.infomaniak.ch [84.16.66.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BE415357D
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 13:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.16.66.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714742364; cv=none; b=qoA+3fAjrLkQflSyl8RG5XlNHU95cjGq3KEButfYf3bsxeTTRs/STaBRjNwoL9B3HzbdNebqjN38BmM+Aq0QfU5gb9p+u7RHLzgssgVwkHqNYgHwFCCj6M5LxgsEaCcSJvwB9paNXgHFYfJnByhBnaq/mCQfv4TY7zjQkNKWkkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714742364; c=relaxed/simple;
	bh=tHNEADY7nUlqkaLY/BU1vFawJAcOU9Jd1B14MfEsU3g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FwaAppC6CwmbpUCZ1G31oFwsjW/aFlqQkVmx2LmV2mZUrZ/otBH8VGNMM4kvK68yn2Vxhnxv6Xx8kQX1OgDldb0i7ajLgx0lqz4hWvB7zeseGWgsoESadSXqefYYho0ySVN0QOqDmU9unqAjjWcWjuGf1YkduxYPGEUs3sCBTSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=pqC5bnOX; arc=none smtp.client-ip=84.16.66.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-4-0001.mail.infomaniak.ch (smtp-4-0001.mail.infomaniak.ch [10.7.10.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4VWBGb01yhzPm8;
	Fri,  3 May 2024 15:19:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1714742358;
	bh=tHNEADY7nUlqkaLY/BU1vFawJAcOU9Jd1B14MfEsU3g=;
	h=From:To:Cc:Subject:Date:From;
	b=pqC5bnOXSMYl6cDukE7A0UKRhT7LQYSKJf2OTKKA1+szdGStmWJsMTAeo8dyxqnpg
	 QwcAnPcYKS+divRw8dAghSFyO/xO9AmY+H03rDDSeG3bCQA3YIqzsYijS39CyKQSg+
	 TI9U6B0vwRusuOQxqe43g5kbuVsb+pRQFz/+RSE8=
Received: from unknown by smtp-4-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4VWBGX3sC9zSyt;
	Fri,  3 May 2024 15:19:16 +0200 (CEST)
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
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Alexander Graf <graf@amazon.com>,
	Angelina Vu <angelinavu@linux.microsoft.com>,
	Anna Trikalinou <atrikalinou@microsoft.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
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
Subject: [RFC PATCH v3 0/5] Hypervisor-Enforced Kernel Integrity - CR pinning
Date: Fri,  3 May 2024 15:19:05 +0200
Message-ID: <20240503131910.307630-1-mic@digikod.net>
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

This patch series implements control-register (CR) pinning for KVM and
provides an hypervisor-agnostic API to protect guests.  It includes the
guest interface, the host interface, and the KVM implementation.

It's not ready for mainline yet (see the current limitations), but we
think the overall design and interfaces are good and we'd like to have
some feedback on that.

# Changes since previous version

We choose to remove as much as possible from the previous version of
this patch series to only keep the CR pinning feature and the API.  This
makes the patches simpler and brings the foundation for future
enhancement.  This will also enables us to quickly iterate on new
versions.  We are still working on memory protection but that should be
part of another patch series, if possible once this one land.

We implemented proper KUnit tests and we are also improving the test
framework to make it easier to run tests (and another series is planed):
https://lore.kernel.org/r/20240408074625.65017-1-mic@digikod.net
It makes sense to use KUnit for hypervisor-agnostic features.

This series is rebased on top of v6.9-rc6 . guest_memfd is now merged
in mainline, which will help upcoming memory-related changes.

# Overview

The main idea being that kernel self-protection mechanisms should be
delegated to a more privileged part of the system, that is the
hypervisor (see the Threat model below for more details).  It is still
the role of the guest kernel to request such restrictions according to
its configuration. The high-level security guarantees provided by the
hypervisor are semantically the same as a subset of those the kernel
already enforces on itself (CR pinning hardening), but with much strong
guarantees.

The guest kernel API layer contains a global struct heki_hypervisor to
share data and functions between the common code and the hypervisor
support code.  The struct heki_hypervisor enables to plug in different
backend implementations that are initialized with the heki_early_init()
and heki_late_init() calls.

We took inspiration from previous patches, mainly the KVMI [1] [2] and
KVM CR-pinning [3] series, revamped and simplified relevant parts to fit
well with our goal, added one hypercall, and created a kernel API for
VMs to request protection in a generic way that can be leveraged by any
hypervisor.

When a guest request to change one of its previously protected CR, KVM
creates a GP fault.

Because the VMM needs to be involved and know the guests' requested
memory permissions, we implemented two new kind of VM exits to be able
to notify the VMM about guests' Heki configurations and policy
violations.  Indeed, forwarding such signals to the VMM could help
improve attack detection, and react to such attempt (e.g. log events,
stop the VM).  Giving visibility to the VMM would also enable us to
migrate VMs.

# Threat model

The main threat model is a malicious user space process exploiting a
kernel vulnerability to gain more privileges or to bypass the
access-control system.  This threat also covers attacks coming from
network or storage data (e.g., malformed network packet, inconsistent
drive content).

Considering all potential ways to compromise a kernel, Heki's goal is to
harden a sane kernel before a runtime attack to make it more difficult,
and potentially to cause such an attack to fail. Because current attack
mitigations are only mitigations, we consider the kernel itself to be
partially malicious during its lifetime e.g., because a ROP attack that
could disable kernel self-protection mechanisms and make kernel
exploitation much easier. Indeed, an exploit is often split into several
stages, each bypassing some security measures (including CFI).

CR pinning should already be enforced by the guest kernel and the reason
to pin such registers is the same.  With this patch series it
significantly improve such protection.

Getting the guarantee that these control registers cannot be changed
increases the cost of an attack.

# Prerequisites

For this new security layer to be effective, guest kernels must be
trusted by the VM owners at boot time, before launching any user space
processes nor receiving potentially malicious network packets. It is
then required to have a security mechanism to provide or check this
initial trust (e.g., secure boot, kernel module signing).  To protect
against persistent attacks, complementary security mechanisms should be
used (e.g., IMA, IPE, Lockdown).

# How does it work?

The KVM_HC_LOCK_CR_UPDATE hypercall enables guests to pin some of its
CPU control register flags (e.g., X86_CR0_WP, X86_CR4_SMEP,
X86_CR4_SMAP).

Two new kinds of VM exits are implemented: one for a guest Heki request
(i.e. hypercall), and another for a guest attempt to change its pinned
CRs.  When the guest attempts to update pinned CRs or to access memory
in a way that is not allowed, the VMM can then be notified and react to
such attack attempt. After that, if the VM is still running, KVM sends
a GP fault to the guest. The guest could then send a signal to the user
space process that triggered this policy violation (not implemented).

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

Intel's Virtualization Based Hardening [4] [5] is an open-source
proof-of-concept of a thin hypervisor dedicated to guest protection. As
such, it cannot be used to manage several VMs.

# Similar Linux patches

Paravirtualized Control Register pinning [3] added a set of KVM IOCTLs
to restrict some flags to be set. Heki doesn't implement such user space
interface, but only a dedicated hypercall to lock such registers. A
superset of these flags is configurable with Heki.

The Hypervisor Based Integrity patches [6] [7] only contain a generic
IPC mechanism (KVM_HC_UCALL hypercall) to request protection to the VMM.
The idea was to extend the KVM_SET_USER_MEMORY_REGION IOCTL to support
more permission than read-only.

# Current limitations

This patch series doesn't handle VM reboot, kexec, nor hybernate yet.
We'd like to leverage the realated feature from KVM CR-pinning patch
series [3].  Help appreciated!

We noticed that the KUnit tests don't work on AMD because the exception
table seems to not be properly handled (i.e. a double fault is
received).  Any reason why this would differ from an Intel's CPU?

What about extending register pinning to MSRs?  This should first be
implemented as a kernel self-protection though.

This patch series is also a call for collaboration. There is a lot to
do, either on hypervisors, guest kernels or VMMs sides.

# Resources

You can find related resources, including previous versions, and
conference talks about this work and the related LVBS project here:
https://github.com/heki-linux

[1] https://lore.kernel.org/all/20211006173113.26445-1-alazar@bitdefender.com/
[2] https://www.linux-kvm.org/images/7/72/KVMForum2017_Introspection.pdf
[3] https://lore.kernel.org/all/20200617190757.27081-1-john.s.andersen@intel.com/
[4] https://github.com/intel/vbh
[5] https://sched.co/TmwN
[6] https://sched.co/eE3f
[7] https://lore.kernel.org/all/20200501185147.208192-1-yuanyu@google.com/

Please reach out to us by replying to this thread, we're looking for
people to join and collaborate on this project!

Previous versions:
v2: https://lore.kernel.org/r/20231113022326.24388-1-mic@digikod.net
v1: https://lore.kernel.org/r/20230505152046.6575-1-mic@digikod.net

Regards,

Madhavan T. Venkataraman (1):
  virt: Introduce Hypervisor Enforced Kernel Integrity (Heki)

Mickaël Salaün (4):
  KVM: x86: Add new hypercall to lock control registers
  KVM: x86: Add notifications for Heki policy configuration and
    violation
  heki: Lock guest control registers at the end of guest kernel init
  virt: Add Heki KUnit tests

 Documentation/virt/kvm/x86/hypercalls.rst |  17 ++
 Kconfig                                   |   2 +
 arch/x86/Kconfig                          |   1 +
 arch/x86/include/asm/x86_init.h           |   1 +
 arch/x86/include/uapi/asm/kvm_para.h      |   2 +
 arch/x86/kernel/cpu/common.c              |   7 +-
 arch/x86/kernel/cpu/hypervisor.c          |   1 +
 arch/x86/kernel/kvm.c                     |  56 +++++++
 arch/x86/kvm/Kconfig                      |   1 +
 arch/x86/kvm/vmx/vmx.c                    |   6 +
 arch/x86/kvm/x86.c                        | 180 ++++++++++++++++++++++
 arch/x86/kvm/x86.h                        |  23 +++
 include/linux/heki.h                      |  54 +++++++
 include/linux/kvm_host.h                  |   7 +
 include/uapi/linux/kvm.h                  |  22 +++
 include/uapi/linux/kvm_para.h             |   1 +
 init/main.c                               |   3 +
 mm/mm_init.c                              |   1 +
 virt/Makefile                             |   1 +
 virt/heki/.kunitconfig                    |   9 ++
 virt/heki/Kconfig                         |  43 ++++++
 virt/heki/Makefile                        |   4 +
 virt/heki/common.h                        |  16 ++
 virt/heki/heki-test.c                     | 114 ++++++++++++++
 virt/heki/main.c                          |  68 ++++++++
 25 files changed, 638 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/heki.h
 create mode 100644 virt/heki/.kunitconfig
 create mode 100644 virt/heki/Kconfig
 create mode 100644 virt/heki/Makefile
 create mode 100644 virt/heki/common.h
 create mode 100644 virt/heki/heki-test.c
 create mode 100644 virt/heki/main.c


base-commit: e67572cd2204894179d89bd7b984072f19313b03
-- 
2.45.0


