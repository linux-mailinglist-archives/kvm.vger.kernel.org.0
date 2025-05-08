Return-Path: <kvm+bounces-45958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F005AAAFEC3
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:15:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44106188DBF0
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA61B288532;
	Thu,  8 May 2025 15:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="djGRNcOo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168B928851E
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716867; cv=none; b=hPASPrSmdw+yktAbYYFPCg7UAEj5F/M0w0G6RoFZEnnWQSHQXFljcXmKXHdbKtZb6FrX5jOoYuxcGFs5ptqiPaE2CrNnJLau+JpEQ4yTB3gIS+iwdySVWIlfhudlTQIGXw6DyMnczYSKehUd5sB7TrjRlbKt3qs4QWNY80wIT2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716867; c=relaxed/simple;
	bh=8Sytcbe51Jr1Rfoh9/l3eww/oXXV/6gn0LTn37b+jC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qahhkRTagxd/TA6G+OWIb9GqFybhLiaPni8dKMiDODOmnrP4e3FpqyEemV/jk8reyOPMZy8i8xmJAIbgxKGUDrPq4tbyebm/T+5BZLf8s9UowYO90e31xUda7Bc/z2wUjDmCp1ZHQjaw/7Q5SVeC69kOxZM9qsykVyf6dFCiLVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=djGRNcOo; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716865; x=1778252865;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8Sytcbe51Jr1Rfoh9/l3eww/oXXV/6gn0LTn37b+jC8=;
  b=djGRNcOoWlhZbcSFeSRb38r42Yw2lpsM4Xo4iSI5jGBZQMyKcnUTCOwf
   nyxLuIlHZRE5xFmcb/R2Dee5ytju5xLGOQJlspWjQ0uA593ZkERlQIKXX
   bdV2H2Pd5V2F08FJF4NBmvnpJP5O1Qm33BprkfC1G0QfcPmlNHR+f9fV+
   Ze6nKLRgdZDjmUkCBZTRvh8kzIJCJ/HmhKq8Y0gmd+AcDRprlg8JlNvOn
   E7Er3z0NBrjbUyWru1nC/+X58s1SCcpzy2xpYZp4YdxsPOXGEFA6zLqdV
   yh91VWQfQwqpJA3ihz1FMmYDyj6NwTEvFSU6AIjPbS4/38d5hf7EMEP1Z
   w==;
X-CSE-ConnectionGUID: H1Fs3BgsSpmV8ZDoIia9Lw==
X-CSE-MsgGUID: c6tznfGeRQCCZ96W3o+CFg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="58716590"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="58716590"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:07:45 -0700
X-CSE-ConnectionGUID: qoX4RgmGTiSwG8M5yTvtaw==
X-CSE-MsgGUID: WPd0NhotQSy4rUtB8MKJqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440598"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:07:42 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 55/55] docs: Add TDX documentation
Date: Thu,  8 May 2025 11:00:01 -0400
Message-ID: <20250508150002.689633-56-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
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
Changes in v6:
 - Add more information of "Feature configuration"
 - Mark TD Attestation as future work because KVM now drops the support
   of it.

Changes in v5:
 - Add TD attestation section and update the QEMU parameter;

Changes since v1:
 - Add prerequisite of private gmem;
 - update example command to launch TD;

Changes since RFC v4:
 - add the restriction that kernel-irqchip must be split
---
 docs/system/confidential-guest-support.rst |   1 +
 docs/system/i386/tdx.rst                   | 161 +++++++++++++++++++++
 docs/system/target-i386.rst                |   1 +
 3 files changed, 163 insertions(+)
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
index 000000000000..8131750b64b3
--- /dev/null
+++ b/docs/system/i386/tdx.rst
@@ -0,0 +1,161 @@
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
+the TD boots.
+
+KVM vcpu ioctl ``KVM_TDX_INIT_MEM_REGION`` can be used to populate the TDVF
+content into its private memory.
+
+Since TDX doesn't support readonly memslot, TDVF cannot be mapped as pflash
+device and it actually works as RAM. "-bios" option is chosen to load TDVF.
+
+OVMF is the opensource firmware that implements the TDVF support. Thus the
+command line to specify and load TDVF is ``-bios OVMF.fd``
+
+Feature Configuration
+---------------------
+
+Unlike non-TDX VM, the CPU features (enumerated by CPU or MSR) of a TD are not
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
+``struct kvm_tdx_capabilities``, which tells the supported configuration of
+attributes, XFAM and CPUIDs.
+
+TD attributes
+~~~~~~~~~~~~~
+
+QEMU supports configuring raw 64-bit TD attributes directly via "attributes"
+property of "tdx-guest" object. Note, it's users' responsibility to provide a
+valid value because some bits may not supported by current QEMU or KVM yet.
+
+QEMU also supports the configuration of individual attribute bits that are
+supported by it, via properties of "tdx-guest" object.
+E.g., "sept-ve-disable" (bit 28).
+
+MSR based features
+~~~~~~~~~~~~~~~~~~
+
+Current KVM doesn't support MSR based feature (e.g., MSR_IA32_ARCH_CAPABILITIES)
+configuration for TDX, and it's a future work to enable it in QEMU when KVM adds
+support of it.
+
+Feature check
+~~~~~~~~~~~~~
+
+QEMU checks if the final (CPU) features, determined by given cpu model and
+explicit feature adjustment of "+featureA/-featureB", can be supported or not.
+It can produce feature not supported warning like
+
+  "warning: host doesn't support requested feature: CPUID.07H:EBX.intel-pt [bit 25]"
+
+It can also produce warning like
+
+  "warning: TDX forcibly sets the feature: CPUID.80000007H:EDX.invtsc [bit 8]"
+
+if the fixed-1 feature is requested to be disabled explicitly. This is newly
+added to QEMU for TDX because TDX has fixed-1 features that are forcibly enabled
+by TDX module and VMM cannot disable them.
+
+Launching a TD (TDX VM)
+-----------------------
+
+To launch a TD, the necessary command line options are tdx-guest object and
+split kernel-irqchip, as below:
+
+.. parsed-literal::
+
+    |qemu_system_x86| \\
+        -accel kvm \\
+        -cpu host \\
+        -object tdx-guest,id=tdx0 \\
+        -machine ...,confidential-guest-support=tdx0 \\
+        -bios OVMF.fd \\
+
+Restrictions
+------------
+
+ - kernel-irqchip must be split;
+
+   This is set by default for TDX guest if kernel-irqchip is left on its default
+   'auto' setting.
+
+ - No readonly support for private memory;
+
+ - No SMM support: SMM support requires manipulating the guest register states
+   which is not allowed;
+
+Debugging
+---------
+
+Bit 0 of TD attributes, is DEBUG bit, which decides if the TD runs in off-TD
+debug mode. When in off-TD debug mode, TD's VCPU state and private memory are
+accessible via given SEAMCALLs. This requires KVM to expose APIs to invoke those
+SEAMCALLs and corresonponding QEMU change.
+
+It's targeted as future work.
+
+TD attestation
+--------------
+
+In TD guest, the attestation process is used to verify the TDX guest
+trustworthiness to other entities before provisioning secrets to the guest.
+
+TD attestation is initiated first by calling TDG.MR.REPORT inside TD to get the
+REPORT. Then the REPORT data needs to be converted into a remotely verifiable
+Quote by SGX Quoting Enclave (QE).
+
+It's a future work in QEMU to add support of TD attestation since it lacks
+support in current KVM.
+
+Live Migration
+--------------
+
+Future work.
+
+References
+----------
+
+- `TDX Homepage <https://www.intel.com/content/www/us/en/developer/articles/technical/intel-trust-domain-extensions.html>`__
+
+- `SGX QE <https://github.com/intel/SGXDataCenterAttestationPrimitives/tree/master/QuoteGeneration>`__
diff --git a/docs/system/target-i386.rst b/docs/system/target-i386.rst
index ab7af1a75d6e..43b09c79d6be 100644
--- a/docs/system/target-i386.rst
+++ b/docs/system/target-i386.rst
@@ -31,6 +31,7 @@ Architectural features
    i386/kvm-pv
    i386/sgx
    i386/amd-memory-encryption
+   i386/tdx
 
 OS requirements
 ~~~~~~~~~~~~~~~
-- 
2.43.0


