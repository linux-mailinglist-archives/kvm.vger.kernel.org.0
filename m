Return-Path: <kvm+bounces-6968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 94E5183B851
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:35:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 176A71F263F3
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:35:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CAB9175BF;
	Thu, 25 Jan 2024 03:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Db97TZCk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB41417575
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153492; cv=none; b=s0KmqCDOBYwSmS9BMwTUPdvoBZs4N00oCnKgDA7lvZFmsqZttyCZz1W2+7yZNw2VJwGdK9f8JoM5ZaafWEGI/m9MmuzrHh5iRAE27dTXDhMaaOaBNj/T1vxpDITkWprNYQe7YAIrRPIbizYel6NP0w/u9Tx/XIBlw3JunsL2gQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153492; c=relaxed/simple;
	bh=klfzRXQXY4gU48ZNC2oRdXZ/A2KblsfGhFWWh4dKX9U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KTkoyDNU/8uocOjMtR183+FdLVBhUGXmArhiSgOXPjksdMA40zYUJo/Jknkc9jsi1F8h6fOW6Nw+W9s/PiJbUH9z9UxZuF8Qy9avd8b2yeHMha/V4yJH9nrHMoYE1gDuk34BOyzQAmJc44BO7CAFBOaf9ETvSoH3/oP3Xx6KI9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Db97TZCk; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153491; x=1737689491;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=klfzRXQXY4gU48ZNC2oRdXZ/A2KblsfGhFWWh4dKX9U=;
  b=Db97TZCkRqYJrRJ/GOT4C6LTiThm0Ra+gJBzSFYbAgBzSiOLM/VCfheP
   pWnqFQTSCMCCndR8hBRe2hbkYrluGP+MS4U98GGyaJ58+LnPQ9QXcc6LV
   1PdT+JC0k4vcc+CwJHxRndUEEc84Ztt22LdwoIIyDDJSSdThHf8JPU3Qg
   r2cM192jTWo9Wv18CP9k73edVTW4mqz2A4x+gOHlXTemLYUQzwiehTP4K
   MnE9oEkX9a3Atwdsi/kNvnmyiYsaEiVhnvEssLf4zOpFUiqcoWqy4PUzu
   DlnYP/KX2+9saAWGziPH7Ih88mwf5dJe1jbE11RygWxhwxyeWJ9jBI8Hs
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9430599"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9430599"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:29:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2086811"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:29:32 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v4 66/66] docs: Add TDX documentation
Date: Wed, 24 Jan 2024 22:23:28 -0500
Message-Id: <20240125032328.2522472-67-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125032328.2522472-1-xiaoyao.li@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add docs/system/i386/tdx.rst for TDX support, and add tdx in
confidential-guest-support.rst

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

---
Changes since v1:
 - Add prerequisite of private gmem;
 - update example command to launch TD;

Changes since RFC v4:
 - add the restriction that kernel-irqchip must be split
---
 docs/system/confidential-guest-support.rst |   1 +
 docs/system/i386/tdx.rst                   | 113 +++++++++++++++++++++
 docs/system/target-i386.rst                |   1 +
 3 files changed, 115 insertions(+)
 create mode 100644 docs/system/i386/tdx.rst

diff --git a/docs/system/confidential-guest-support.rst b/docs/system/confidential-guest-support.rst
index 0c490dbda2b7..66129fbab64c 100644
--- a/docs/system/confidential-guest-support.rst
+++ b/docs/system/confidential-guest-support.rst
@@ -38,6 +38,7 @@ Supported mechanisms
 Currently supported confidential guest mechanisms are:
 
 * AMD Secure Encrypted Virtualization (SEV) (see :doc:`i386/amd-memory-encryption`)
+* Intel Trust Domain Extension (TDX) (see :doc:`i386/tdx`)
 * POWER Protected Execution Facility (PEF) (see :ref:`power-papr-protected-execution-facility-pef`)
 * s390x Protected Virtualization (PV) (see :doc:`s390x/protvirt`)
 
diff --git a/docs/system/i386/tdx.rst b/docs/system/i386/tdx.rst
new file mode 100644
index 000000000000..1872e4f5a8be
--- /dev/null
+++ b/docs/system/i386/tdx.rst
@@ -0,0 +1,113 @@
+Intel Trusted Domain eXtension (TDX)
+====================================
+
+Intel Trusted Domain eXtensions (TDX) refers to an Intel technology that extends
+Virtual Machine Extensions (VMX) and Multi-Key Total Memory Encryption (MKTME)
+with a new kind of virtual machine guest called a Trust Domain (TD). A TD runs
+in a CPU mode that is designed to protect the confidentiality of its memory
+contents and its CPU state from any other software, including the hosting
+Virtual Machine Monitor (VMM), unless explicitly shared by the TD itself.
+
+Prerequisites
+-------------
+
+To run TD, the physical machine needs to have TDX module loaded and initialized
+while KVM hypervisor has TDX support and has TDX enabled. If those requirements
+are met, the ``KVM_CAP_VM_TYPES`` will report the support of ``KVM_X86_TDX_VM``.
+
+Trust Domain Virtual Firmware (TDVF)
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Trust Domain Virtual Firmware (TDVF) is required to provide TD services to boot
+TD Guest OS. TDVF needs to be copied to guest private memory and measured before
+a TD boots.
+
+The VM scope ``MEMORY_ENCRYPT_OP`` ioctl provides command ``KVM_TDX_INIT_MEM_REGION``
+to copy the TDVF image to TD's private memory space.
+
+Since TDX doesn't support readonly memslot, TDVF cannot be mapped as pflash
+device and it actually works as RAM. "-bios" option is chosen to load TDVF.
+
+OVMF is the opensource firmware that implements the TDVF support. Thus the
+command line to specify and load TDVF is ``-bios OVMF.fd``
+
+KVM private gmem
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+TD's memory (RAM) needs to be able to be transformed between private and shared.
+And its BIOS (OVMF/TDVF) needs to be mapped as private. Thus QEMU needs to
+allocate private gmem for them via KVM's IOCTL (KVM_CREATE_GUEST_MEMFD), which
+requires KVM is newer enough that reports KVM_CAP_GUEST_MEMFD.
+
+Feature Control
+---------------
+
+Unlike non-TDX VM, the CPU features (enumerated by CPU or MSR) of a TD is not
+under full control of VMM. VMM can only configure part of features of a TD on
+``KVM_TDX_INIT_VM`` command of VM scope ``MEMORY_ENCRYPT_OP`` ioctl.
+
+The configurable features have three types:
+
+- Attributes:
+  - PKS (bit 30) controls whether Supervisor Protection Keys is exposed to TD,
+  which determines related CPUID bit and CR4 bit;
+  - PERFMON (bit 63) controls whether PMU is exposed to TD.
+
+- XSAVE related features (XFAM):
+  XFAM is a 64b mask, which has the same format as XCR0 or IA32_XSS MSR. It
+  determines the set of extended features available for use by the guest TD.
+
+- CPUID features:
+  Only some bits of some CPUID leaves are directly configurable by VMM.
+
+What features can be configured is reported via TDX capabilities.
+
+TDX capabilities
+~~~~~~~~~~~~~~~~
+
+The VM scope ``MEMORY_ENCRYPT_OP`` ioctl provides command ``KVM_TDX_CAPABILITIES``
+to get the TDX capabilities from KVM. It returns a data structure of
+``struct kvm_tdx_capabilites``, which tells the supported configuration of
+attributes, XFAM and CPUIDs.
+
+Launching a TD (TDX VM)
+-----------------------
+
+To launch a TDX guest, below are new added and required:
+
+.. parsed-literal::
+
+    |qemu_system_x86| \\
+        -object tdx-guest,id=tdx0 \\
+        -machine ...,kernel-irqchip=split,confidential-guest-support=tdx0 \\
+        -bios OVMF.fd \\
+
+Debugging
+---------
+
+Bit 0 of TD attributes, is DEBUG bit, which decides if the TD runs in off-TD
+debug mode. When in off-TD debug mode, TD's VCPU state and private memory are
+accessible via given SEAMCALLs. This requires KVM to expose APIs to invoke those
+SEAMCALLs and resonponding QEMU change.
+
+It's targeted as future work.
+
+restrictions
+------------
+
+ - kernel-irqchip must be split;
+
+ - No readonly support for private memory;
+
+ - No SMM support: SMM support requires manipulating the guset register states
+   which is not allowed;
+
+Live Migration
+--------------
+
+TODO
+
+References
+----------
+
+- `TDX Homepage <https://www.intel.com/content/www/us/en/developer/articles/technical/intel-trust-domain-extensions.html>`__
diff --git a/docs/system/target-i386.rst b/docs/system/target-i386.rst
index 1b8a1f248abb..4d58cdbc4e06 100644
--- a/docs/system/target-i386.rst
+++ b/docs/system/target-i386.rst
@@ -29,6 +29,7 @@ Architectural features
    i386/kvm-pv
    i386/sgx
    i386/amd-memory-encryption
+   i386/tdx
 
 OS requirements
 ~~~~~~~~~~~~~~~
-- 
2.34.1


