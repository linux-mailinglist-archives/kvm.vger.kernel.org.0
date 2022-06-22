Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 860E25547FF
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357645AbiFVLTn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 07:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357574AbiFVLTR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 07:19:17 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604AE3CA47;
        Wed, 22 Jun 2022 04:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655896689; x=1687432689;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hTMxv5ATBtehYuUZfbLQ0w47uiDhHQy1BjaByM3jchE=;
  b=A5bvEOt75outqNKvaj/S5Wca7/Lla6OkdkPz2Z2nD2ilmn3tnLhweeJH
   tXoQlfSyJm0VQw5Pdol3VFB6MJRsNg/wcIRV3VkmFgFv2M78+XF2BQOmI
   NelPGI3KmTOcsdOP2qZx7tX/GLGwAoLhhMeongQ0521urvhHkfeDrpjsw
   +J0JT6qWAFLRtUeW5HHwKhXdKrpX3XvmXdU1UKPgmsL0wmvuDL9rmsRdF
   I3Q8/xYCMOO7nsXuM2tsdY5gtdnTigDniqPmVcJgWOWzHP7eA+JHfm31v
   T+jCXZH0XHZsCOO2hPxN5qZNeOgh0pR7rS6S3URdsadSF0ahdgxXfJw8x
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="366713447"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="366713447"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:18:08 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="834065982"
Received: from jmatsis-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.209.178.197])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:18:05 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com,
        len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com, peterz@infradead.org, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        isaku.yamahata@intel.com, kai.huang@intel.com
Subject: [PATCH v5 22/22] Documentation/x86: Add documentation for TDX host support
Date:   Wed, 22 Jun 2022 23:17:50 +1200
Message-Id: <0712bc0b05a0c6c42437fba68f82d9268ab3113e.1655894131.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655894131.git.kai.huang@intel.com>
References: <cover.1655894131.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add documentation for TDX host kernel support.  There is already one
file Documentation/x86/tdx.rst containing documentation for TDX guest
internals.  Also reuse it for TDX host kernel support.

Introduce a new level menu "TDX Guest Support" and move existing
materials under it, and add a new menu for TDX host kernel support.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 Documentation/x86/tdx.rst | 190 +++++++++++++++++++++++++++++++++++---
 1 file changed, 179 insertions(+), 11 deletions(-)

diff --git a/Documentation/x86/tdx.rst b/Documentation/x86/tdx.rst
index b8fa4329e1a5..6c6b09ca6ba4 100644
--- a/Documentation/x86/tdx.rst
+++ b/Documentation/x86/tdx.rst
@@ -10,6 +10,174 @@ encrypting the guest memory. In TDX, a special module running in a special
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
+To enable TDX, BIOS configures SEAMRR and TDX private KeyIDs consistently
+across all CPU packages.  TDX doesn't trust BIOS.  The MCHECK verifies
+all configurations from BIOS are correct and enables SEAMRR.
+
+After TDX is enabled in BIOS, the TDX module needs to be loaded into the
+SEAMRR range and properly initialized, before it can be used to create
+and run protected VMs.
+
+The TDX architecture doesn't require BIOS to load the TDX module, but
+current kernel assumes it is loaded by BIOS (i.e. either directly or by
+some UEFI shell tool) before booting to the kernel.  Current kernel
+detects TDX and initializes the TDX module.
+
+TDX boot-time detection
+-----------------------
+
+Kernel detects TDX and the TDX private KeyIDs during kernel boot.  User
+can see below dmesg if TDX is enabled by BIOS:
+
+|  [..] tdx: SEAMRR enabled.
+|  [..] tdx: TDX private KeyID range: [16, 64).
+|  [..] tdx: TDX enabled by BIOS.
+
+TDX module detection and initialization
+---------------------------------------
+
+There is no CPUID or MSR to detect whether the TDX module.  The kernel
+detects the TDX module by initializing it.
+
+The kernel talks to the TDX module via the new SEAMCALL instruction.  The
+TDX module implements SEAMCALL leaf functions to allow the kernel to
+initialize it.
+
+Initializing the TDX module consumes roughly ~1/256th system RAM size to
+use it as 'metadata' for the TDX memory.  It also takes additional CPU
+time to initialize those metadata along with the TDX module itself.  Both
+are not trivial.  Current kernel doesn't choose to always initialize the
+TDX module during kernel boot, but provides a function tdx_init() to
+allow the caller to initialize TDX when it truly wants to use TDX:
+
+        ret = tdx_init();
+        if (ret)
+                goto no_tdx;
+        // TDX is ready to use
+
+Initializing the TDX module requires all logical CPUs being online and
+are in VMX operation (requirement of making SEAMCALL) during tdx_init().
+Currently, KVM is the only user of TDX.  KVM always guarantees all online
+CPUs are in VMX operation when there's any VM.  Current kernel doesn't
+handle entering VMX operation in tdx_init() but leaves this to the
+caller.
+
+User can consult dmesg to see the presence of the TDX module, and whether
+it has been initialized.
+
+If the TDX module is not loaded, dmesg shows below:
+
+|  [..] tdx: TDX module is not loaded.
+
+If the TDX module is initialized successfully, dmesg shows something
+like below:
+
+|  [..] tdx: TDX module: vendor_id 0x8086, major_version 1, minor_version 0, build_date 20211209, build_num 160
+|  [..] tdx: 65667 pages allocated for PAMT.
+|  [..] tdx: TDX module initialized.
+
+If the TDX module failed to initialize, dmesg shows below:
+
+|  [..] tdx: Failed to initialize TDX module.  Shut it down.
+
+TDX Interaction to Other Kernel Components
+------------------------------------------
+
+CPU Hotplug
+~~~~~~~~~~~
+
+TDX doesn't work with ACPI CPU hotplug.  To guarantee the security MCHECK
+verifies all logical CPUs for all packages during platform boot.  Any
+hot-added CPU is not verified thus cannot support TDX.  A non-buggy BIOS
+should never deliver ACPI CPU hot-add event to the kernel.  Such event is
+reported as BIOS bug and the hot-added CPU is rejected.
+
+TDX requires all boot-time verified logical CPUs being present until
+machine reset.  If kernel receives ACPI CPU hot-removal event, assume the
+kernel cannot continue to work normally so just BUG().
+
+Note TDX works with CPU logical online/offline, thus the kernel still
+allows to offline logical CPU and online it again.
+
+Memory Hotplug
+~~~~~~~~~~~~~~
+
+The TDX module reports a list of "Convertible Memory Region" (CMR) to
+indicate which memory regions are TDX-capable.  Those regions are
+generated by BIOS and verified by the MCHECK so that they are truly
+present during platform boot and can meet security guarantee.
+
+This means TDX doesn't work with ACPI memory hot-add.  A non-buggy BIOS
+should never deliver ACPI memory hot-add event to the kernel.  Such event
+is reported as BIOS bug and the hot-added memory is rejected.
+
+TDX also doesn't work with ACPI memory hot-removal.  If kernel receives
+ACPI memory hot-removal event, assume the kernel cannot continue to work
+normally so just BUG().
+
+Also, the kernel needs to choose which TDX-capable regions to use as TDX
+memory and pass those regions to the TDX module when it gets initialized.
+Once they are passed to the TDX module, the TDX-usable memory regions are
+fixed during module's lifetime.
+
+To avoid having to modify the page allocator to distinguish TDX and
+non-TDX memory allocation, current kernel guarantees all pages managed by
+the page allocator are TDX memory.  This means any hot-added memory to
+the page allocator will break such guarantee thus should be prevented.
+
+There are basically two memory hot-add cases that need to be prevented:
+ACPI memory hot-add and driver managed memory hot-add.  The kernel
+rejectes the driver managed memory hot-add too when TDX is enabled by
+BIOS.  For instance, dmesg shows below error when using kmem driver to
+add a legacy PMEM as system RAM:
+
+|  [..] tdx: Unable to add memory [0x580000000, 0x600000000) on TDX enabled platform.
+|  [..] kmem dax0.0: mapping0: 0x580000000-0x5ffffffff memory add failed
+
+However, adding new memory to ZONE_DEVICE should not be prevented as
+those pages are not managed by the page allocator.  Therefore,
+memremap_pages() variants are still allowed although they internally
+also uses memory hotplug functions.
+
+Kexec()
+~~~~~~~
+
+TDX (and MKTME) doesn't guarantee cache coherency among different KeyIDs.
+If the TDX module is ever initialized, the kernel needs to flush dirty
+cachelines associated with any TDX private KeyID, otherwise they may
+slightly corrupt the new kernel.
+
+Similar to SME support, the kernel uses wbinvd() to flush cache in
+stop_this_cpu().
+
+The current TDX module architecture doesn't play nicely with kexec().
+The TDX module can only be initialized once during its lifetime, and
+there is no SEAMCALL to reset the module to give a new clean slate to
+the new kernel.  Therefore, ideally, if the module is ever initialized,
+it's better to shut down the module.  The new kernel won't be able to
+use TDX anyway (as it needs to go through the TDX module initialization
+process which will fail immediately at the first step).
+
+However, there's no guarantee CPU is in VMX operation during kexec(), so
+it's impractical to shut down the module.  Current kernel just leaves the
+module in open state.
+
+TDX Guest Support
+=================
 Since the host cannot directly access guest registers or memory, much
 normal functionality of a hypervisor must be moved into the guest. This is
 implemented using a Virtualization Exception (#VE) that is handled by the
@@ -20,7 +188,7 @@ TDX includes new hypercall-like mechanisms for communicating from the
 guest to the hypervisor or the TDX module.
 
 New TDX Exceptions
-==================
+------------------
 
 TDX guests behave differently from bare-metal and traditional VMX guests.
 In TDX guests, otherwise normal instructions or memory accesses can cause
@@ -30,7 +198,7 @@ Instructions marked with an '*' conditionally cause exceptions.  The
 details for these instructions are discussed below.
 
 Instruction-based #VE
----------------------
+~~~~~~~~~~~~~~~~~~~~~
 
 - Port I/O (INS, OUTS, IN, OUT)
 - HLT
@@ -41,7 +209,7 @@ Instruction-based #VE
 - CPUID*
 
 Instruction-based #GP
----------------------
+~~~~~~~~~~~~~~~~~~~~~
 
 - All VMX instructions: INVEPT, INVVPID, VMCLEAR, VMFUNC, VMLAUNCH,
   VMPTRLD, VMPTRST, VMREAD, VMRESUME, VMWRITE, VMXOFF, VMXON
@@ -52,7 +220,7 @@ Instruction-based #GP
 - RDMSR*,WRMSR*
 
 RDMSR/WRMSR Behavior
---------------------
+~~~~~~~~~~~~~~~~~~~~
 
 MSR access behavior falls into three categories:
 
@@ -73,7 +241,7 @@ trapping and handling in the TDX module.  Other than possibly being slow,
 these MSRs appear to function just as they would on bare metal.
 
 CPUID Behavior
---------------
+~~~~~~~~~~~~~~
 
 For some CPUID leaves and sub-leaves, the virtualized bit fields of CPUID
 return values (in guest EAX/EBX/ECX/EDX) are configurable by the
@@ -93,7 +261,7 @@ not know how to handle. The guest kernel may ask the hypervisor for the
 value with a hypercall.
 
 #VE on Memory Accesses
-======================
+----------------------
 
 There are essentially two classes of TDX memory: private and shared.
 Private memory receives full TDX protections.  Its content is protected
@@ -107,7 +275,7 @@ entries.  This helps ensure that a guest does not place sensitive
 information in shared memory, exposing it to the untrusted hypervisor.
 
 #VE on Shared Memory
---------------------
+~~~~~~~~~~~~~~~~~~~~
 
 Access to shared mappings can cause a #VE.  The hypervisor ultimately
 controls whether a shared memory access causes a #VE, so the guest must be
@@ -127,7 +295,7 @@ be careful not to access device MMIO regions unless it is also prepared to
 handle a #VE.
 
 #VE on Private Pages
---------------------
+~~~~~~~~~~~~~~~~~~~~
 
 An access to private mappings can also cause a #VE.  Since all kernel
 memory is also private memory, the kernel might theoretically need to
@@ -145,7 +313,7 @@ The hypervisor is permitted to unilaterally move accepted pages to a
 to handle the exception.
 
 Linux #VE handler
-=================
+-----------------
 
 Just like page faults or #GP's, #VE exceptions can be either handled or be
 fatal.  Typically, an unhandled userspace #VE results in a SIGSEGV.
@@ -167,7 +335,7 @@ While the block is in place, any #VE is elevated to a double fault (#DF)
 which is not recoverable.
 
 MMIO handling
-=============
+-------------
 
 In non-TDX VMs, MMIO is usually implemented by giving a guest access to a
 mapping which will cause a VMEXIT on access, and then the hypervisor
@@ -189,7 +357,7 @@ MMIO access via other means (like structure overlays) may result in an
 oops.
 
 Shared Memory Conversions
-=========================
+-------------------------
 
 All TDX guest memory starts out as private at boot.  This memory can not
 be accessed by the hypervisor.  However, some kernel users like device
-- 
2.36.1

