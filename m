Return-Path: <kvm+bounces-47535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 973A3AC2031
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:53:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D71161B64379
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:53:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 843B0226D08;
	Fri, 23 May 2025 09:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dTsv/Kd4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07FE32F3E;
	Fri, 23 May 2025 09:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747994005; cv=none; b=SK+X4xrTWbHZoP11m77ZUYdMXkJEYbOYW6C1Hjsn+eeIjUFqUAlIRVbK0Qhq7gjPj+fINSfquJjQDnfEIZ3h+suwnyDjhDc+bcrNV7M9i5a2JIUwRDjIKzr1GTKAkUF/o297fFJJQqjoyp4/pL6ThpteVkXUV5P0zf9gBxffXV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747994005; c=relaxed/simple;
	bh=8GgZdS0arjitol2wnmXzM/E6GCJ/KJ9aP+1wybfiEgc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MXrfJHnSiM0Mvth87bcei62/0IOq7Cb3E9AT9kGkOj3TbdZsPqCEsaSFlYCuIPMoF3InmODskJzfP3WxB5CRr9iYuM9Rxte88dhrk4S2BOcam11x7hwQjSSVvVFFRXhc8R+j1i6O70dLIffxo9+BeQYeHrXdwS47asyt8LnRKEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dTsv/Kd4; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747994004; x=1779530004;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8GgZdS0arjitol2wnmXzM/E6GCJ/KJ9aP+1wybfiEgc=;
  b=dTsv/Kd4+5T5t1s4Rmb8d8huRnZpWrKyrl3LL1e6QuQBrPYz3YEglHz7
   MwHNjNeNrlvctUSRQpxcmIVE7It4dBi/Dfm1x5HjnnoESfb2J2ehCgU/Z
   31nG/N7wVzFJCq5wnNe4Pn7HCS0/7x1c7g/tgJLh3HQaTYUayFH9T1l86
   wi7BTQ3EzdGvK0+cuTl9a73Ak77XTRO4yxLHFIhPtWqsHE2VtGamptMsl
   irmySN4/9wKKIvYAjrC4YnIRjKgOGJf4AjRH6F7Ns9WYCLBFCaKyUXdFh
   PvKh5avtZuwaVOzSSJTDSEJsmhtlv0Lvw203yOKdXwu5cRBTkubE41S68
   w==;
X-CSE-ConnectionGUID: 9DVEgStcSv2HR5MJjcOJNg==
X-CSE-MsgGUID: laK31A5wTB6SPEbdRBFv5Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="75444083"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="75444083"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:23 -0700
X-CSE-ConnectionGUID: SEBZ5RgNQxOBfzoRx2KyTw==
X-CSE-MsgGUID: Npj90ApiSh2VGqCqQjMXqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="164315031"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:22 -0700
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	x86@kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	eddie.dong@intel.com,
	kirill.shutemov@intel.com,
	dave.hansen@intel.com,
	dan.j.williams@intel.com,
	kai.huang@intel.com,
	isaku.yamahata@intel.com,
	elena.reshetova@intel.com,
	rick.p.edgecombe@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 00/20] TD-Preserving updates
Date: Fri, 23 May 2025 02:52:23 -0700
Message-ID: <20250523095322.88774-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Reviewers,

This series adds support for runtime TDX module updates that preserve
running TDX guests (a.k.a, TD-Preserving updates). The goal is to gather
feedback on the feature design. Please pay attention to the following items:

1. TD-Preserving updates are done in stop_machine() context. it copy-pastes
   part of multi_cpu_stop() to guarantee step-locked progress on all CPUs.
   But, there are a few differences between them. I am wondering whether
   these differences have reached a point where abstracting a common
   function might do more harm than good. See more details in patch 10.

2. P-SEAMLDR seamcalls (specificially SEAMRET from P-SEAMLDR) clear current
   VMCS pointers, which may disrupt KVM. To prevent VMX instructions in IRQ
   context from encountering NULL current-VMCS pointers, P-SEAMLDR
   seamcalls are called with IRQ disabled. I'm uncertain if NMIs could
   cause a problem, but I believe they won't. See more information in patch 3.

3. Two helpers, cpu_vmcs_load() and cpu_vmcs_store(), are added in patch 3
   to save and restore the current VMCS. KVM has a variant of cpu_vmcs_load(),
   i.e., vmcs_load(). Extracting KVM's version would cause a lot of code
   churn, and I don't think that can be justified for reducing ~16 LoC
   duplication. Please let me know if you disagree.

== Background ==

Intel TDX isolates Trusted Domains (TDs), or confidential guests, from the
host. A key component of Intel TDX is the TDX module, which enforces
security policies to protect the memory and CPU states of TDs from the
host. However, the TDX module is software that require updates, it is not
device firmware in the typical sense.

== Problems ==

Currently, the TDX module is loaded by the BIOS at boot time, and the only
way to update it is through a reboot, which results in significant system
downtime. Users expect the TDX module to be updatable at runtime without
disrupting TDX guests.

== Solution ==

On TDX platforms, P-SEAMLDR[1] is a component within the protected SEAM
range. It is loaded by the BIOS and provides the host with functions to
install a TDX module at runtime.

Implement a TDX Module update facility via the fw_upload mechanism. Given
that there is variability in which module update to load based on features,
fix levels, and potentially reloading the same version for error recovery
scenarios, the explicit userspace chosen payload flexibility of fw_upload
is attractive.

This design allows the kernel to accept a bitstream instead of loading a
named file from the filesystem, as the module selection and policy
enforcement for TDX modules are quite complex (see more in patch 8). By
doing so, much of this complexity is shifted out of the kernel. The kernel
need to expose information, such as the TDX module version, to userspace.
The userspace tool must understand the TDX module versioning scheme and
update policy to select the appropriate TDX module (see "TDX Module
Versioning" below).

In the unlikely event the update fails, for example userspace picks an
incompatible update image, or the image is otherwise corrupted, all TDs
will experience SEAMCALL failures and be killed. The recovery of TD
operation from that event requires a reboot.

Given there is no mechanism to quiesce SEAMCALLs, the TDs themselves must
pause execution over an update. The most straightforward way to meet the
'pause TDs while update executes' constraint is to run the update in
stop_machine() context. All other evaluated solutions export more
complexity to KVM, or exports more fragility to userspace.

== How to test this series ==

 # git clone https://github.com/intel/tdx-module-binaries
 # cd tdx-module-binaries
 # python version_select_and_load.py --update


This series is based on Sean's kvm-x86/next branch

  https://github.com/kvm-x86/linux.git next


== Other information relevant to TD-Preserving updates == 

=== TDX module versioning ===

Each TDX module is assigned a version number x.y.z, where x represents the
"major" version, y the "minor" version, and z the "update" version.

TD-Preserving updates are restricted to Z-stream releases.

Note that Z-stream releases do not necessarily guarantee compatibility. A
new release may not be compatible with all previous versions. To address this,
Intel provides a separate file containing compatibility information, which
specifies the minimum module version required for a particular update. This
information is referenced by the tool to determine if two modules are
compatible.

=== TCB Stability ===

Updates change the TCB as viewed by attestation reports. In TDX there is a
distinction between launch-time version and current version where TD-preserving
updates cause that latter version number to change, subject to Z-stream
constraints. The need for runtime updates and the implications of that version
change in the attestation was previously discussed in [3].

=== TDX Module Distribution Model ===

At a high level, Intel publishes all TDX modules on the github [2], along with
a mapping_file.json which documents the compatibility information about each
TDX module and a script to install the TDX module. OS vendors can package
these modules and distribute them. Administrators install the package and
use the script to select the appropriate TDX module and install it via the
interfaces exposed by this series.

[1]: https://cdrdv2.intel.com/v1/dl/getContent/733584
[2]: https://github.com/intel/tdx-module-binaries
[3]: https://lore.kernel.org/all/5d1da767-491b-4077-b472-2cc3d73246d6@amazon.com/


Chao Gao (20):
  x86/virt/tdx: Print SEAMCALL leaf numbers in decimal
  x86/virt/tdx: Prepare to support P-SEAMLDR SEAMCALLs
  x86/virt/seamldr: Introduce a wrapper for P-SEAMLDR SEAMCALLs
  x86/virt/tdx: Introduce a "tdx" subsystem and "tsm" device
  x86/virt/tdx: Export tdx module attributes via sysfs
  x86/virt/seamldr: Add a helper to read P-SEAMLDR information
  x86/virt/tdx: Expose SEAMLDR information via sysfs
  x86/virt/seamldr: Implement FW_UPLOAD sysfs ABI for TD-Preserving
    Updates
  x86/virt/seamldr: Allocate and populate a module update request
  x86/virt/seamldr: Introduce skeleton for TD-Preserving updates
  x86/virt/seamldr: Abort updates if errors occurred midway
  x86/virt/seamldr: Shut down the current TDX module
  x86/virt/tdx: Reset software states after TDX module shutdown
  x86/virt/seamldr: Install a new TDX module
  x86/virt/seamldr: Handle TD-Preserving update failures
  x86/virt/seamldr: Do TDX cpu init after updates
  x86/virt/tdx: Establish contexts for the new module
  x86/virt/tdx: Update tdx_sysinfo and check features post-update
  x86/virt/seamldr: Verify availability of slots for TD-Preserving
    updates
  x86/virt/seamldr: Enable TD-Preserving Updates

 Documentation/ABI/testing/sysfs-devices-tdx |  32 ++
 MAINTAINERS                                 |   1 +
 arch/x86/Kconfig                            |  12 +
 arch/x86/include/asm/tdx.h                  |  20 +-
 arch/x86/include/asm/tdx_global_metadata.h  |  12 +
 arch/x86/virt/vmx/tdx/Makefile              |   1 +
 arch/x86/virt/vmx/tdx/seamldr.c             | 443 ++++++++++++++++++++
 arch/x86/virt/vmx/tdx/seamldr.h             |  16 +
 arch/x86/virt/vmx/tdx/tdx.c                 | 248 ++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h                 |  12 +
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c |  29 ++
 arch/x86/virt/vmx/vmx.h                     |  40 ++
 12 files changed, 862 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-tdx
 create mode 100644 arch/x86/virt/vmx/tdx/seamldr.c
 create mode 100644 arch/x86/virt/vmx/tdx/seamldr.h
 create mode 100644 arch/x86/virt/vmx/vmx.h

-- 
2.47.1


