Return-Path: <kvm+bounces-70962-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KIG5JG/ljWms8QAAu9opvQ
	(envelope-from <kvm+bounces-70962-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:36:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E3C7B12E480
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:36:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9C0543055431
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 14:36:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEA3835C1B8;
	Thu, 12 Feb 2026 14:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KG/HmNj5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057972D2387;
	Thu, 12 Feb 2026 14:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770906973; cv=none; b=su3+osjbVU/F9Jwf9/yphjevt1IqOsOME1kjIMQVF2A/+9pLSQWK+4dPX0EJzRT/kQEgd64Jv18bYoI3yWElGbrD5b+iW21kJjaes9evuJWMltjnGByelHA9EPIrRNtydqT0vAMV1u3z+Q7yLCdIwXs60VP8ZQEb17+DBuxjV7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770906973; c=relaxed/simple;
	bh=se3wtvzJ1Bwg0vok3lW8cwzlOUlGj2BYT5+p2lxIDfo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=K85ExIEpR5YJGSzT1SFTUOeRTad86OGfIoNaF5fTTEty5u57UyctqbMfYyYqtKjkWboK6hoKIIb0fbL8X8QivSnw5p9Umo5YtcuMg+NvhORRK27O5gVeq1wjzLrl7xv3QMX4FsJ4jB8T01QMIYil0hi6/+bFE1NcHRPQ7YMbUEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KG/HmNj5; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770906971; x=1802442971;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=se3wtvzJ1Bwg0vok3lW8cwzlOUlGj2BYT5+p2lxIDfo=;
  b=KG/HmNj5xtnk3XIs4yTcSAUTnbRZVLG3lEY3JPb0/Nn374owAnjphZw3
   GkoQeUUJRr6L/UdPAXtTN5qWF0ZeXdnwV95H1U6hjXlDWxM8lYOBC+eXz
   5o1T5lT+HqsAYz99UQSFUU6ZJfc0Qf2++gnzKBNOGh+ssDwMfHjRI/HOi
   1ra8C6zzCVyRcSVOT2VN0lfVofydEPlBUdo9DuBYqWefYMTu3/c+ZOAYF
   KncGwTvR4V5w5ZASUJhnupx+/WjFdWbG1LBU8DRIlYz+vJkE+Ia1M5ccI
   h/io1kSNzPIabfc2FuHgQJTGOtHfvhlwe8M14I7cg1rQioU8Urp1CH0eG
   Q==;
X-CSE-ConnectionGUID: bVTdXMqVQAGFgJeQMRjyYg==
X-CSE-MsgGUID: h2YQu4csTySiFFNKY6hRVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="89662733"
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="89662733"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:36:10 -0800
X-CSE-ConnectionGUID: s/m0FLHDQuu1zLy2JIHp/w==
X-CSE-MsgGUID: 1h4Z85wwR0q5aLrsJYsoZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="211428184"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:36:09 -0800
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-doc@vger.kernel.org
Cc: reinette.chatre@intel.com,
	ira.weiny@intel.com,
	kai.huang@intel.com,
	dan.j.williams@intel.com,
	yilun.xu@linux.intel.com,
	sagis@google.com,
	vannapurve@google.com,
	paulmck@kernel.org,
	nik.borisov@suse.com,
	zhenzhong.duan@intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com,
	kas@kernel.org,
	dave.hansen@linux.intel.com,
	vishal.l.verma@intel.com,
	binbin.wu@linux.intel.com,
	tony.lindgren@linux.intel.com,
	Chao Gao <chao.gao@intel.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH v4 00/24] Runtime TDX Module update support
Date: Thu, 12 Feb 2026 06:35:03 -0800
Message-ID: <20260212143606.534586-1-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[29];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70962-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: E3C7B12E480
X-Rspamd-Action: no action

Hi Reviewers,

With this posting, I'm hoping to collect more Reviewed-by or Acked-by tags.
In the last round of review, the first 6 patches received thorough reviews
from Dave and others. I believe they are in good shape after incorporating
all feedback, so I'm hoping to get more reviews on patch 7 and beyond.

Kai, please take a look at patch 10, which has been updated per your
suggestions.

Note that like v3, this v4 is not based on Sean's VMXON series to make this
series more reviewable.

For transparency, I should note that I used an Intel-operated AI tool to
help proofread this cover-letter and commit messages.

Changelog:
v3->v4:
 - Drop INTEL_TDX_MODULE_UPDATE kconfig [Dave]
 - Drop two unnecessary cleanup patches [Dave]
 - Drop VMCS save/restore across P-SEAMLDR calls [Dave]
   (We are pursuing microcode changes to preserve the current VMCS
    across P-SEAMLDR calls. Until then, we still need the last patch in
    this series which wraps P-SEAMLDR calls with VMCS save/restore for
    testing)
 - Don't handle P-SEAMLDR's "no_entropy" error [Dave]
 - Put seamldr_info on stack and change seamldr attributes permission
   to 0x400 [Dave]
 - Correct copyright notices [Dave]
 - Document TDX Module updates in tdx.rst 
 - Improve changelogs and comments [Dave, Kai]
 - Rename the TDX Module update sysfs directory from "seamldr_upload" to
 "tdx_module" [Cedric]
 - Merge the patch that support 16KB sigstruct to a previous patch [Kai]
 - Update tdx_blob definition to match this series' implementation [Kai]
 - Remove tdx_blob checksum verification as it is really optional
 - Don't support update canceling [Yilun]
 - Other minor code changes and changelog improvements
 - Collect review tags from Tony and Yilun
 - v3: https://lore.kernel.org/kvm/20260123145645.90444-1-chao.gao@intel.com/

This series adds support for runtime TDX Module updates that preserve
running TDX guests. It is also available at:

  https://github.com/gaochaointel/linux-dev/commits/tdx-module-updates-v4/

== Background ==

Intel TDX isolates Trusted Domains (TDs), or confidential guests, from the
host. A key component of Intel TDX is the TDX Module, which enforces
security policies to protect the memory and CPU states of TDs from the
host. However, the TDX Module is software that require updates.

== Problems ==

Currently, the TDX Module is loaded by the BIOS at boot time, and the only
way to update it is through a reboot, which results in significant system
downtime. Users expect the TDX Module to be updatable at runtime without
disrupting TDX guests.

== Solution ==

On TDX platforms, P-SEAMLDR[1] is a component within the protected SEAM
range. It is loaded by the BIOS and provides the host with functions to
install a TDX Module at runtime.

Implement a TDX Module update facility via the fw_upload mechanism. Given
that there is variability in which module update to load based on features,
fix levels, and potentially reloading the same version for error recovery
scenarios, the explicit userspace chosen payload flexibility of fw_upload
is attractive.

This design allows the kernel to accept a bitstream instead of loading a
named file from the filesystem, as the module selection and policy
enforcement for TDX Modules are quite complex (see more in patch 8). By
doing so, much of this complexity is shifted out of the kernel. The kernel
need to expose information, such as the TDX Module version, to userspace.
Userspace must understand the TDX Module versioning scheme and update
policy to select the appropriate TDX Module (see "TDX Module Versioning"
below).

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

First, load kvm-intel.ko and tdx-host.ko if they haven't been loaded:

 # modprobe -r kvm_intel
 # modprobe kvm_intel tdx=1
 # modprobe tdx-host

Then, use the userspace tool below to select the appropriate TDX module and
install it via the interfaces exposed by this series:

 # git clone https://github.com/intel/tdx-module-binaries
 # cd tdx-module-binaries
 # python version_select_and_load.py --update

this version changes the firmware directory name from seamldr_upload to
tdx_module, so, below change should be applied to version_select_and_load.py:

diff --git a/version_select_and_load.py b/version_select_and_load.py
index 2193bd8..6a3b604 100644
--- a/version_select_and_load.py
+++ b/version_select_and_load.py
@@ -38,7 +38,7 @@ except ImportError:
     print("Error: cpuid module is not installed. Please install it using 'pip install cpuid'")
     sys.exit(1)

-FIRMWARE_PATH = "/sys/class/firmware/seamldr_upload"
+FIRMWARE_PATH = "/sys/class/firmware/tdx_module"
 MODULE_PATH = "/sys/devices/faux/tdx_host"
 SEAMLDR_PATH = "/sys/devices/faux/tdx_host/seamldr"
 allow_debug = False


== Other information relevant to Runtime TDX Module updates == 

=== TDX Module versioning ===

Each TDX Module is assigned a version number x.y.z, where x represents the
"major" version, y the "minor" version, and z the "update" version.

Runtime TDX Module updates are restricted to Z-stream releases.

Note that Z-stream releases do not necessarily guarantee compatibility. A
new release may not be compatible with all previous versions. To address this,
Intel provides a separate file containing compatibility information, which
specifies the minimum module version required for a particular update. This
information is referenced by the tool to determine if two modules are
compatible.

=== TCB Stability ===

Updates change the TCB as viewed by attestation reports. In TDX there is
a distinction between launch-time version and current version where
runtime TDX Module updates cause that latter version number to change,
subject to Z-stream constraints.

The concern that a malicious host may attack confidential VMs by loading
insecure updates was addressed by Alex in [3]. Similarly, the scenario
where some "theoretical paranoid tenant" in the cloud wants to audit
updates and stop trusting the host after updates until audit completion
was also addressed in [4]. Users not in the cloud control the host machine
and can manage updates themselves, so they don't have these concerns.

See more about the implications of current TCB version changes in
attestation as summarized by Dave in [5].

=== TDX Module Distribution Model ===

At a high level, Intel publishes all TDX Modules on the github [2], along
with a mapping_file.json which documents the compatibility information
about each TDX Module and a userspace tool to install the TDX Module. OS
vendors can package these modules and distribute them. Administrators
install the package and use the tool to select the appropriate TDX Module
and install it via the interfaces exposed by this series.

[1]: https://cdrdv2.intel.com/v1/dl/getContent/733584
[2]: https://github.com/intel/tdx-module-binaries
[3]: https://lore.kernel.org/all/665c5ae0-4b7c-4852-8995-255adf7b3a2f@amazon.com/
[4]: https://lore.kernel.org/all/5d1da767-491b-4077-b472-2cc3d73246d6@amazon.com/
[5]: https://lore.kernel.org/all/94d6047e-3b7c-4bc1-819c-85c16ff85abf@intel.com/

Chao Gao (23):
  coco/tdx-host: Introduce a "tdx_host" device
  coco/tdx-host: Expose TDX Module version
  x86/virt/seamldr: Introduce a wrapper for P-SEAMLDR SEAMCALLs
  x86/virt/seamldr: Retrieve P-SEAMLDR information
  coco/tdx-host: Expose P-SEAMLDR information via sysfs
  coco/tdx-host: Implement firmware upload sysfs ABI for TDX Module
    updates
  x86/virt/seamldr: Block TDX Module updates if any CPU is offline
  x86/virt/seamldr: Check update limit before TDX Module updates
  x86/virt/seamldr: Allocate and populate a module update request
  x86/virt/seamldr: Introduce skeleton for TDX Module updates
  x86/virt/seamldr: Abort updates if errors occurred midway
  x86/virt/seamldr: Shut down the current TDX module
  x86/virt/tdx: Reset software states during TDX Module shutdown
  x86/virt/seamldr: Log TDX Module update failures
  x86/virt/seamldr: Install a new TDX Module
  x86/virt/seamldr: Do TDX per-CPU initialization after updates
  x86/virt/tdx: Restore TDX Module state
  x86/virt/tdx: Update tdx_sysinfo and check features post-update
  x86/virt/tdx: Enable TDX Module runtime updates
  x86/virt/tdx: Avoid updates during update-sensitive operations
  coco/tdx-host: Document TDX Module update expectations
  x86/virt/tdx: Document TDX Module updates
  [NOT-FOR-REVIEW] x86/virt/seamldr: Save and restore current VMCS

Kai Huang (1):
  x86/virt/tdx: Move low level SEAMCALL helpers out of <asm/tdx.h>

 .../ABI/testing/sysfs-devices-faux-tdx-host   |  82 ++++
 Documentation/arch/x86/tdx.rst                |  34 ++
 arch/x86/include/asm/seamldr.h                |  37 ++
 arch/x86/include/asm/special_insns.h          |  22 ++
 arch/x86/include/asm/tdx.h                    |  66 +---
 arch/x86/include/asm/tdx_global_metadata.h    |   5 +
 arch/x86/kvm/vmx/tdx_errno.h                  |   2 -
 arch/x86/virt/vmx/tdx/Makefile                |   2 +-
 arch/x86/virt/vmx/tdx/seamcall_internal.h     | 107 ++++++
 arch/x86/virt/vmx/tdx/seamldr.c               | 360 ++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.c                   | 153 +++++---
 arch/x86/virt/vmx/tdx/tdx.h                   |  11 +-
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c   |  15 +
 drivers/virt/coco/Kconfig                     |   2 +
 drivers/virt/coco/Makefile                    |   1 +
 drivers/virt/coco/tdx-host/Kconfig            |  12 +
 drivers/virt/coco/tdx-host/Makefile           |   1 +
 drivers/virt/coco/tdx-host/tdx-host.c         | 240 ++++++++++++
 18 files changed, 1050 insertions(+), 102 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-faux-tdx-host
 create mode 100644 arch/x86/include/asm/seamldr.h
 create mode 100644 arch/x86/virt/vmx/tdx/seamcall_internal.h
 create mode 100644 arch/x86/virt/vmx/tdx/seamldr.c
 create mode 100644 drivers/virt/coco/tdx-host/Kconfig
 create mode 100644 drivers/virt/coco/tdx-host/Makefile
 create mode 100644 drivers/virt/coco/tdx-host/tdx-host.c

-- 
2.47.3


