Return-Path: <kvm+bounces-1342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E48797E6A24
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 12:58:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 42D78B20E69
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 11:58:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E56171DA35;
	Thu,  9 Nov 2023 11:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H3SmWPsP"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D819E1DA20
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 11:58:40 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD903251;
	Thu,  9 Nov 2023 03:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699531121; x=1731067121;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S8k31sQJcwrbWSda49ADoHS4K9UVoQOMkuJARurWsC4=;
  b=H3SmWPsPkkc1Mvwgf3x2vSBae7HKKgRdQonIZik2ksuj1oNpHxDYWaVQ
   VEDd35EhoVpQF9AjhRYAldrpYBnWEDV40hYg5NLWC6pnYzVswkQUKRv0c
   OxKzx0SfL7nd1c32ucfFTrs+HDI67AgY/cNNl5tpAtX5B/awc7n/ezyjk
   GkCFgHwYRLAH2f1Ndpzf3uSxA+UyiU9Xyvcju5i7K3F9mF9Ezu0bt1SFv
   SiOKkk5wyJHcfo5fwoysukKE8yjBoS2MnYEcfJn85JKbzJeE6S48Nwvs/
   SOqJ52FLGkzdZl3z/64m2fADZE9619fM6CN3P3f31Xt7+LgD0nixSCrZq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="2936850"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="2936850"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:58:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10888"; a="766977119"
X-IronPort-AV: E=Sophos;i="6.03,289,1694761200"; 
   d="scan'208";a="766977119"
Received: from shadphix-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.83.35])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2023 03:58:33 -0800
From: Kai Huang <kai.huang@intel.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: x86@kernel.org,
	dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	peterz@infradead.org,
	tony.luck@intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	rafael@kernel.org,
	david@redhat.com,
	dan.j.williams@intel.com,
	len.brown@intel.com,
	ak@linux.intel.com,
	isaku.yamahata@intel.com,
	ying.huang@intel.com,
	chao.gao@intel.com,
	sathyanarayanan.kuppuswamy@linux.intel.com,
	nik.borisov@suse.com,
	bagasdotme@gmail.com,
	sagis@google.com,
	imammedo@redhat.com,
	kai.huang@intel.com
Subject: [PATCH v15 23/23] Documentation/x86: Add documentation for TDX host support
Date: Fri, 10 Nov 2023 00:56:00 +1300
Message-ID: <a9adc748ba9c222f4e1b7b5d5651544aa6284a5f.1699527082.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1699527082.git.kai.huang@intel.com>
References: <cover.1699527082.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add documentation for TDX host kernel support.  There is already one
file Documentation/x86/tdx.rst containing documentation for TDX guest
internals.  Also reuse it for TDX host kernel support.

Introduce a new level menu "TDX Guest Support" and move existing
materials under it, and add a new menu for TDX host kernel support.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---

v14 -> v15:
 - Removed the dmesg shows TDX module version (not printed anymore).

v13 -> v14:
 - Added new sections for "Erratum" and "TDX vs S3/hibernation"


---
 Documentation/arch/x86/tdx.rst | 222 +++++++++++++++++++++++++++++++--
 1 file changed, 211 insertions(+), 11 deletions(-)

diff --git a/Documentation/arch/x86/tdx.rst b/Documentation/arch/x86/tdx.rst
index dc8d9fd2c3f7..8969675568d0 100644
--- a/Documentation/arch/x86/tdx.rst
+++ b/Documentation/arch/x86/tdx.rst
@@ -10,6 +10,206 @@ encrypting the guest memory. In TDX, a special module running in a special
 mode sits between the host and the guest and manages the guest/host
 separation.
 
+TDX Host Kernel Support
+=======================
+
+TDX introduces a new CPU mode called Secure Arbitration Mode (SEAM) and
+a new isolated range pointed by the SEAM Ranger Register (SEAMRR).  A
+CPU-attested software module called 'the TDX module' runs inside the new
+isolated range to provide the functionalities to manage and run protected
+VMs.
+
+TDX also leverages Intel Multi-Key Total Memory Encryption (MKTME) to
+provide crypto-protection to the VMs.  TDX reserves part of MKTME KeyIDs
+as TDX private KeyIDs, which are only accessible within the SEAM mode.
+BIOS is responsible for partitioning legacy MKTME KeyIDs and TDX KeyIDs.
+
+Before the TDX module can be used to create and run protected VMs, it
+must be loaded into the isolated range and properly initialized.  The TDX
+architecture doesn't require the BIOS to load the TDX module, but the
+kernel assumes it is loaded by the BIOS.
+
+TDX boot-time detection
+-----------------------
+
+The kernel detects TDX by detecting TDX private KeyIDs during kernel
+boot.  Below dmesg shows when TDX is enabled by BIOS::
+
+  [..] virt/tdx: BIOS enabled: private KeyID range: [16, 64)
+
+TDX module initialization
+---------------------------------------
+
+The kernel talks to the TDX module via the new SEAMCALL instruction.  The
+TDX module implements SEAMCALL leaf functions to allow the kernel to
+initialize it.
+
+If the TDX module isn't loaded, the SEAMCALL instruction fails with a
+special error.  In this case the kernel fails the module initialization
+and reports the module isn't loaded::
+
+  [..] virt/tdx: module not loaded
+
+Initializing the TDX module consumes roughly ~1/256th system RAM size to
+use it as 'metadata' for the TDX memory.  It also takes additional CPU
+time to initialize those metadata along with the TDX module itself.  Both
+are not trivial.  The kernel initializes the TDX module at runtime on
+demand.
+
+Besides initializing the TDX module, a per-cpu initialization SEAMCALL
+must be done on one cpu before any other SEAMCALLs can be made on that
+cpu.
+
+The kernel provides two functions, tdx_enable() and tdx_cpu_enable() to
+allow the user of TDX to enable the TDX module and enable TDX on local
+cpu respectively.
+
+Making SEAMCALL requires VMXON has been done on that CPU.  Currently only
+KVM implements VMXON.  For now both tdx_enable() and tdx_cpu_enable()
+don't do VMXON internally (not trivial), but depends on the caller to
+guarantee that.
+
+To enable TDX, the caller of TDX should: 1) temporarily disable CPU
+hotplug; 2) do VMXON and tdx_enable_cpu() on all online cpus; 3) call
+tdx_enable().  For example::
+
+        cpus_read_lock();
+        on_each_cpu(vmxon_and_tdx_cpu_enable());
+        ret = tdx_enable();
+        cpus_read_unlock();
+        if (ret)
+                goto no_tdx;
+        // TDX is ready to use
+
+And the caller of TDX must guarantee the tdx_cpu_enable() has been
+successfully done on any cpu before it wants to run any other SEAMCALL.
+A typical usage is do both VMXON and tdx_cpu_enable() in CPU hotplug
+online callback, and refuse to online if tdx_cpu_enable() fails.
+
+User can consult dmesg to see whether the TDX module has been initialized.
+
+If the TDX module is initialized successfully, dmesg shows something
+like below::
+
+  [..] virt/tdx: 262668 KBs allocated for PAMT
+  [..] virt/tdx: module initialized
+
+If the TDX module failed to initialize, dmesg also shows it failed to
+initialize::
+
+  [..] virt/tdx: module initialization failed ...
+
+TDX Interaction to Other Kernel Components
+------------------------------------------
+
+TDX Memory Policy
+~~~~~~~~~~~~~~~~~
+
+TDX reports a list of "Convertible Memory Region" (CMR) to tell the
+kernel which memory is TDX compatible.  The kernel needs to build a list
+of memory regions (out of CMRs) as "TDX-usable" memory and pass those
+regions to the TDX module.  Once this is done, those "TDX-usable" memory
+regions are fixed during module's lifetime.
+
+To keep things simple, currently the kernel simply guarantees all pages
+in the page allocator are TDX memory.  Specifically, the kernel uses all
+system memory in the core-mm "at the time of TDX module initialization"
+as TDX memory, and in the meantime, refuses to online any non-TDX-memory
+in the memory hotplug.
+
+Physical Memory Hotplug
+~~~~~~~~~~~~~~~~~~~~~~~
+
+Note TDX assumes convertible memory is always physically present during
+machine's runtime.  A non-buggy BIOS should never support hot-removal of
+any convertible memory.  This implementation doesn't handle ACPI memory
+removal but depends on the BIOS to behave correctly.
+
+CPU Hotplug
+~~~~~~~~~~~
+
+TDX module requires the per-cpu initialization SEAMCALL must be done on
+one cpu before any other SEAMCALLs can be made on that cpu.  The kernel
+provides tdx_cpu_enable() to let the user of TDX to do it when the user
+wants to use a new cpu for TDX task.
+
+TDX doesn't support physical (ACPI) CPU hotplug.  During machine boot,
+TDX verifies all boot-time present logical CPUs are TDX compatible before
+enabling TDX.  A non-buggy BIOS should never support hot-add/removal of
+physical CPU.  Currently the kernel doesn't handle physical CPU hotplug,
+but depends on the BIOS to behave correctly.
+
+Note TDX works with CPU logical online/offline, thus the kernel still
+allows to offline logical CPU and online it again.
+
+Kexec()
+~~~~~~~
+
+There are two problems in terms of using kexec() to boot to a new kernel
+when the old kernel has enabled TDX: 1) Part of the memory pages are
+still TDX private pages; 2) There might be dirty cachelines associated
+with TDX private pages.
+
+The first problem doesn't matter.  KeyID 0 doesn't have integrity check.
+Even the new kernel wants use any non-zero KeyID, it needs to convert
+the memory to that KeyID and such conversion would work from any KeyID.
+
+However the old kernel needs to guarantee there's no dirty cacheline
+left behind before booting to the new kernel to avoid silent corruption
+from later cacheline writeback (Intel hardware doesn't guarantee cache
+coherency across different KeyIDs).
+
+Similar to AMD SME, the kernel does wbinvd() to flush cache before
+booting to the new kernel.
+
+Erratum
+~~~~~~~
+
+The first few generations of TDX hardware have an erratum.  A partial
+write to a TDX private memory cacheline will silently "poison" the
+line.  Subsequent reads will consume the poison and generate a machine
+check.
+
+A partial write is a memory write where a write transaction of less than
+cacheline lands at the memory controller.  The CPU does these via
+non-temporal write instructions (like MOVNTI), or through UC/WC memory
+mappings.  Devices can also do partial writes via DMA.
+
+Theoretically, a kernel bug could do partial write to TDX private memory
+and trigger unexpected machine check.  What's more, the machine check
+code will present these as "Hardware error" when they were, in fact, a
+software-triggered issue.  But in the end, this issue is hard to trigger.
+
+If the platform has such erratum, the kernel does additional things:
+1) resetting TDX private pages using MOVDIR64B in kexec before booting to
+the new kernel; 2) Printing additional message in machine check handler
+to tell user the machine check may be caused by kernel bug on TDX private
+memory.
+
+Interaction vs S3 and deeper states
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+TDX cannot survive from S3 and deeper states.  The hardware resets and
+disables TDX completely when platform goes to S3 and deeper.  Both TDX
+guests and the TDX module get destroyed permanently.
+
+The kernel uses S3 for suspend-to-ram, and use S4 and deeper states for
+hibernation.  Currently, for simplicity, the kernel chooses to make TDX
+mutually exclusive with S3 and hibernation.
+
+The kernel disables TDX during early boot when hibernation support is
+available::
+
+  [..] virt/tdx: initialization failed: Hibernation support is enabled
+
+Add 'nohibernate' kernel command line to disable hibernation in order to
+use TDX.
+
+ACPI S3 is disabled during kernel early boot if TDX is enabled.  The user
+needs to turn off TDX in the BIOS in order to use S3.
+
+TDX Guest Support
+=================
 Since the host cannot directly access guest registers or memory, much
 normal functionality of a hypervisor must be moved into the guest. This is
 implemented using a Virtualization Exception (#VE) that is handled by the
@@ -20,7 +220,7 @@ TDX includes new hypercall-like mechanisms for communicating from the
 guest to the hypervisor or the TDX module.
 
 New TDX Exceptions
-==================
+------------------
 
 TDX guests behave differently from bare-metal and traditional VMX guests.
 In TDX guests, otherwise normal instructions or memory accesses can cause
@@ -30,7 +230,7 @@ Instructions marked with an '*' conditionally cause exceptions.  The
 details for these instructions are discussed below.
 
 Instruction-based #VE
----------------------
+~~~~~~~~~~~~~~~~~~~~~
 
 - Port I/O (INS, OUTS, IN, OUT)
 - HLT
@@ -41,7 +241,7 @@ Instruction-based #VE
 - CPUID*
 
 Instruction-based #GP
----------------------
+~~~~~~~~~~~~~~~~~~~~~
 
 - All VMX instructions: INVEPT, INVVPID, VMCLEAR, VMFUNC, VMLAUNCH,
   VMPTRLD, VMPTRST, VMREAD, VMRESUME, VMWRITE, VMXOFF, VMXON
@@ -52,7 +252,7 @@ Instruction-based #GP
 - RDMSR*,WRMSR*
 
 RDMSR/WRMSR Behavior
---------------------
+~~~~~~~~~~~~~~~~~~~~
 
 MSR access behavior falls into three categories:
 
@@ -73,7 +273,7 @@ trapping and handling in the TDX module.  Other than possibly being slow,
 these MSRs appear to function just as they would on bare metal.
 
 CPUID Behavior
---------------
+~~~~~~~~~~~~~~
 
 For some CPUID leaves and sub-leaves, the virtualized bit fields of CPUID
 return values (in guest EAX/EBX/ECX/EDX) are configurable by the
@@ -93,7 +293,7 @@ not know how to handle. The guest kernel may ask the hypervisor for the
 value with a hypercall.
 
 #VE on Memory Accesses
-======================
+----------------------
 
 There are essentially two classes of TDX memory: private and shared.
 Private memory receives full TDX protections.  Its content is protected
@@ -107,7 +307,7 @@ entries.  This helps ensure that a guest does not place sensitive
 information in shared memory, exposing it to the untrusted hypervisor.
 
 #VE on Shared Memory
---------------------
+~~~~~~~~~~~~~~~~~~~~
 
 Access to shared mappings can cause a #VE.  The hypervisor ultimately
 controls whether a shared memory access causes a #VE, so the guest must be
@@ -127,7 +327,7 @@ be careful not to access device MMIO regions unless it is also prepared to
 handle a #VE.
 
 #VE on Private Pages
---------------------
+~~~~~~~~~~~~~~~~~~~~
 
 An access to private mappings can also cause a #VE.  Since all kernel
 memory is also private memory, the kernel might theoretically need to
@@ -145,7 +345,7 @@ The hypervisor is permitted to unilaterally move accepted pages to a
 to handle the exception.
 
 Linux #VE handler
-=================
+-----------------
 
 Just like page faults or #GP's, #VE exceptions can be either handled or be
 fatal.  Typically, an unhandled userspace #VE results in a SIGSEGV.
@@ -167,7 +367,7 @@ While the block is in place, any #VE is elevated to a double fault (#DF)
 which is not recoverable.
 
 MMIO handling
-=============
+-------------
 
 In non-TDX VMs, MMIO is usually implemented by giving a guest access to a
 mapping which will cause a VMEXIT on access, and then the hypervisor
@@ -189,7 +389,7 @@ MMIO access via other means (like structure overlays) may result in an
 oops.
 
 Shared Memory Conversions
-=========================
+-------------------------
 
 All TDX guest memory starts out as private at boot.  This memory can not
 be accessed by the hypervisor.  However, some kernel users like device
-- 
2.41.0


