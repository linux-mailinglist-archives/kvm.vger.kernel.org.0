Return-Path: <kvm+bounces-9357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1340385F1E8
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 08:29:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3737A1C21C73
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 07:29:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 895DB179BC;
	Thu, 22 Feb 2024 07:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XFabzWpX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B9D17981;
	Thu, 22 Feb 2024 07:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708586955; cv=none; b=dh28JDIK5NLMuLOqT71EcQj4GrJukAQ2p7UVB1IkF754JwO1aj+ZQGSf0NYPYIDCDaLzkbof2m8ikEI8J/d/o14Lj/eBWcQTuuzUyxcu9t+bOldUvC/noGkHL2AQuGT43QIK59N+W2dwEWmIK/loXNjYa8anW+9jQ1i35SR1Z/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708586955; c=relaxed/simple;
	bh=HbqC86JIqhrWdaMhZ9wBgAWcY5evAdGhTvMcwdIOF2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UHhzFHc4hAVx9duspac4Z+/fqlcwvHrDdokKrS52ZgDMO4RYPOaubWRSMg/UyLZomstXQPDg9ysfAlVCQTxWw+lViA0cFCmbWPwR/5u+o29xQWgJYAPcDr3cfaaOWWSuaMSVrAO/Ktr0T50X29VRy0+kEF2ids/Hk9D17FMG+lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XFabzWpX; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708586953; x=1740122953;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HbqC86JIqhrWdaMhZ9wBgAWcY5evAdGhTvMcwdIOF2M=;
  b=XFabzWpXC0F3BpV1t/hVK3Es6dCOBvrR/Uec6nmpY0o2Al4hPohReC9r
   QVEdoba9+I/N9BcaFs0Hhc0qr3iIIbDtaq4OjV+HBmqOdZG/SLeEGn52Q
   KIw1aMz69416NuK5mXe8rEDtmWznFPe84jBx8q/OuUs7PwsS/hP8lFqZ1
   mlcD/3OnHagL9zqzsnSQFi5dKp3hbF9GUHWoV2E8ghNkUJN85lQPVPfWl
   2ch9/qHGoS7ABd6hyqkXoDGa4RWJQ3vbAFQhvUBZAyhuhCp7/5I6Ynv6V
   N0/zjOXiPk7F40qX3mpgZ3eq7mL25vf94+hK4tyX2hLXb/pdOmULcBR09
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10991"; a="2655714"
X-IronPort-AV: E=Sophos;i="6.06,177,1705392000"; 
   d="scan'208";a="2655714"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2024 23:29:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,177,1705392000"; 
   d="scan'208";a="5725651"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by orviesa007.jf.intel.com with ESMTP; 21 Feb 2024 23:29:03 -0800
Date: Thu, 22 Feb 2024 15:42:42 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: "Rafael J . Wysocki" <rafael@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
	Len Brown <len.brown@intel.com>, Zhang Rui <rui.zhang@intel.com>,
	Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yanting Jiang <yanting.jiang@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>,
	Vineeth Pillai <vineeth@bitbyteword.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@google.com>,
	David Dai <davidai@google.com>,
	Saravana Kannan <saravanak@google.com>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [RFC 00/26] Intel Thread Director Virtualization
Message-ID: <Zdb68uUMUdQS2Scw@intel.com>
References: <20240203091214.411862-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240203091214.411862-1-zhao1.liu@linux.intel.com>

Ping Paolo & Sean,

Do you have any comment? Or do you think ITD virtualization is
appropriate to discuss at PUCK?

Thanks,
Zhao

On Sat, Feb 03, 2024 at 05:11:48PM +0800, Zhao Liu wrote:
> Date: Sat, 3 Feb 2024 17:11:48 +0800
> From: Zhao Liu <zhao1.liu@linux.intel.com>
> Subject: [RFC 00/26] Intel Thread Director Virtualization
> X-Mailer: git-send-email 2.34.1
> 
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> Hi list,
> 
> This is our RFC to virtualize Intel Thread Director (ITD) feature for
> Guest, which is based on Ricardo's patch series about ITD related
> support in HFI driver ("[PATCH 0/9] thermal: intel: hfi: Prework for the
> virtualization of HFI" [1]).
> 
> In short, the purpose of this patch set is to enable the ITD-based
> scheduling logic in Guest so that Guest can better schedule Guest tasks
> on Intel hybrid platforms.
> 
> Currently, ITD is necessary for Windows VMs. Based on ITD virtualization
> support, the Windows 11 Guest could have significant performance
> improvement (for example, on i9-13900K, up to 14%+ improvement on
> 3DMARK).
> 
> Our ITD virtualization is not bound to VMs' hybrid topology or vCPUs'
> CPU affinity. However, in our practice, the ITD scheduling optimization
> for win11 VMs works best when combined with hybrid topology and CPU
> affinity (this is related to the specific implementation of Win11
> scheduling). For more details, please see the Section.1.2 "About hybrid
> topology and vCPU pinning".
> 
> To enable ITD related scheduling optimization in Win11 VM, some other
> thermal related support is also needed (HWP, CPPC), but we could emulate
> it with dummy value in the VMM (We'll also be sending out extra patches
> in the future for these).
> 
> Welcome your feedback!
> 
> 
> 1. Background and Motivation
> ============================
> 
> 1.1. Background
> ^^^^^^^^^^^^^^^
> 
> We have the use case to run games in the client Windows VM as the cloud
> gaming solution.
> 
> Gaming VMs are performance-sensitive VMs on Client, so that they usually
> have two characteristics to ensure interactivity and performance:
> 
> i) There will be vCPUs equal to or close to the number of Host pCPUs.
> 
> ii) The vCPUs of Gaming VM are often bound to the pCPUs to achieve
> exclusive resources and avoid the overhead of migration.
> 
> In this case, Host can't provide effective scheduling for Guest, so we
> need to deliver more hardware-assisted scheduling capabilities to Guest
> to enhance Guest's scheduling.
> 
> Windows 11 (and future Windows products) is heavily optimized for the
> Intel hybrid platform. To get the best performance, we need to
> virtualize hybrid scheduling features (HFI/ITD) for Windows Guest.
> 
> 
> 1.2. About hybrid topology and vCPU pinning
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Our ITD virtualization can support most vCPU topologies (except multiple
> packages/dies, see details in 3.5 Restrictions on Guest Topology), and
> can also support the case of non-pinning vCPUs (i.e. it can handle vCPU
> thread migration).
> 
> The following is our performance measuremnt on an i9-13900K machine
> (2995Mhz, 24Cores, 32Thread(8+16) RAM: 14GB (16GB Physical)), with
> iGPU passthrough, running 3DMARK in Win11 Professional Guest:
> 
> 
> compared with smp topo case       smp topo        smp topo        smp topo      hybrid topo       hybrid topo     hybrid topo     hybrid topo
>                                 + affinity      + ITD           + ITD                           + affinity      + ITD           + ITD
>                                                                 + affinity                                                      + affinity
> Time Spy - Overall                0.179%        -0.250%           0.179%        -0.107%           0.143%        -0.179%         -0.107%
> Graphics score                    0.124%        -0.249%           0.124%        -0.083%           0.124%        -0.166%         -0.249%
> CPU score                         0.916%        -0.485%           1.149%        -0.076%           0.722%        -0.324%         11.915%
> Fire Strike Extreme - Overall     0.149%         0.000%           0.224%        -1.021%          -3.361%        -1.319%         -3.361%
> Graphics score                    0.100%         0.050%           0.150%        -1.376%          -3.427%        -1.676%         -3.652%
> Physics score                     5.060%         0.759%           0.518%        -2.907%         -10.914%        -0.897%         14.638%
> Combined  score                   0.120%        -0.179%           0.418%         0.060%          -2.929%        -0.179%         -2.809%
> Fire Strike - Overall             0.350%        -0.085%           0.193%        -1.377%          -1.365%        -1.509%         -1.787%
> Graphics score                    0.256%        -0.047%           0.210%        -1.527%          -1.376%        -1.504%         -2.320%
> Physics score                     3.695%        -2.180%           0.629%        -1.581%          -6.846%        -1.444%         14.100%
> Combined  score                   0.415%        -0.128%           0.128%        -0.957%          -1.052%        -1.594%         -0.957%
> CPU Profile Max Threads           1.836%         0.298%           1.786%        -0.069%           1.545%         0.025%          9.472%
> 16 Threads                        4.290%         0.989%           3.588%         0.595%           1.580%         0.848%         11.295%
> 8 Threads                       -22.632%        -0.602%         -23.167%        -0.988%          -1.345%        -1.340%          8.648%
> 4 Threads                       -21.598%         0.449%         -21.429%        -0.817%           1.951%        -0.832%          2.084%
> 2 Threads                       -12.912%        -0.014%         -12.006%        -0.481%          -0.609%        -0.595%          1.161%
> 1 Threads                        -3.793%        -0.137%          -3.793%        -0.495%          -3.189%        -0.495%          1.154%
> 
> 
> Based on the above result, we can find exposing only HFI/ITD to win11
> VMs without hybrid topology or CPU affinity (case "smp topo + ITD")
> won't hurt performance, but would also not get any performance
> improvement.
> 
> Setting both hybrid topology and CPU affinity for ITD, then win11 VMs
> get significate performance improvement (up to 14%+, compared with the
> case setting smp topology without CPU affinity).
> 
> Not only the numerical results of 3DMARK, but in practice, there is an
> significate improvement in the frame rate of the games.
> 
> Also, the more powerful the machine, the more significate the
> performance gains!
> 
> Therefore, the best practice for enabling ITD scheduling optimization
> is to set up both CPU affinity and hybrid topology for win11 Guest while
> enabling our ITD virtualization.
> 
> Our earlier QEMU prototype RFC [2] presented the initial hybrid
> topology support for VMs. And currently our another proposal about
> "QOM topology" [3] has been raised in the QEMU community, which is the
> first step towards the hybrid topology implementation based on QOM
> approach.
> 
> 
> 2. Introduction of HFI and ITD
> ==============================
> 
> Intel provides Hardware Feedback Interface (HFI) feature to allow
> hardware to provide guidance to the OS scheduler to perform optimal
> workload scheduling through a hardware feedback interface structure in
> memory [4]. This HFI structure is called HFI table.
> 
> For now, the guidance includes performance and energy efficiency
> hints, and it could be update via thermal interrupt as the actual
> operating conditions of the processor change during run time.
> 
> Intel Thread Director (ITD) feature extends the HFI to provide
> performance and energy efficiency data for advanced classes of
> instructions.
> 
> Since ITD is an extension of HFI, our ITD virtualization also
> virtualizes the native HFI feature.
> 
> 
> 3. Dependencies of ITD
> ======================
> 
> ITD is a thermal FEATURE that requires:
> * PTM (Package Thermal Management, alias, PTS)
> * HFI (Hardware Feedback Interface)
> 
> In order to support the notification mechanism of ITD/HFI dynamic
> update, we also need to add thermal interrupt related support,
> including the following two features:
> * ACPI (Thermal Monitor and Software Controlled Clock Facilities)
> * TM (Thermal Monitor, alias, TM1/ACC)
> 
> Therefore, we must also consider support for the emulation of all
> the above dependencies.
> 
> 
> 3.1. ACPI emulation
> ^^^^^^^^^^^^^^^^^^^
> 
> For both ACPI, we can support it by emulating the RDMSR/WRMSR of the
> associated MSRs and adding the ability to inject thermal interrupts.
> But in fact, we don't really inject termal interrupts into Guest for
> the termal conditions corresponding to ACPI. Here the termal interrupt
> is prepared for the subsequent HFI/ITD.
> 
> 
> 3.2. TM emulation
> ^^^^^^^^^^^^^^^^^
> 
> TM is a hardware feature and its CPUID bit only indicates the presence
> of the automatic thermal monitoring facilities. For TM, there's no
> interactive interface between OS and hardware, but its flag is one of
> the prerequisites for the OS to enable thermal interrupt.
> 
> Thereby, as the support for TM, it is enough for us to expose its CPUID
> flag to Guest.
> 
> 
> 3.3. PTM emulation
> ^^^^^^^^^^^^^^^^^^
> 
> PTM is a package-scope feature that includes package-level MSR and
> package-level thermal interrupt. Unfortunately, KVM currently only
> supports thread-scope MSR handling, and also doesn't care about the
> specific Guest's topology.
> 
> But considering that our purpose of supporting PTM in KVM is to further
> support ITD, and the current platforms with ITD are all 1 package, so we
> emulate the MSRs of the package scope provided by PTM at the VM level.
> 
> In this way, the VMM is required to set only one package topology for
> the PTM. In order to alleviate this limitation, we only expose the PTM
> feature bit to Guest when ITD needs to be supported.
> 
> 
> 3.4. HFI emulation
> ^^^^^^^^^^^^^^^^^^
> 
> ITD is the extension of HFI, so both HFI and ITD depend on HFI table.
> HFI itself is used on the Host for power-related management control, so
> we should only expose HFI to Guest when we need to enable ITD.
> 
> HFI also relies on PTM interrupt control, so it also has requirements
> for package topology, and we also emulate HFI (including ITD) at the VM
> level.
> 
> In addition, because the HFI driver allocates HFI instances per die,
> this also affects HFI (and ITD) and must limit the Guest to only set one
> die.
> 
> 
> 3.5. Restrictions on Guest Topology
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Due to KVM's incomplete support for MSR topology and the requirement for
> HFI instance management in the kernel, PTM, HFI, and ITD limit the
> topology of the Guest (mainly restricting the topology types created on
> the VMM side).
> 
> Therefore, we only expose PTM, HFI, and ITD to userspace when we need to
> support ITD. At the same time, considering that currently, ITD is only
> used on the client platform with 1 package and 1 die, such temporary
> restrictions will not have too much impact.
> 
> 
> 4. Overview of ITD (and HFI) virtualization
> ===========================================
> 
> The main tasks of ITD (including HFI) virtualization are:
> * maintain a virtual HFI table for VM.
> * inject thermal interrupt when HFI table updates.
> * handle related MSRs' emulation and adjust HFI table based on MSR's
>   control bits.
> * expose ITD/HFI configuration info in related CPUID leaves.
> 
> The most important of these is the maintenance of the virtual HFI table.
> Although the HFI table should also be per package, since ITD/HFI related
> MSRs are treated as per VM in KVM, we also treat the virtual HFI table
> as per VM.
> 
> 
> 4.1. HFI table building
> ^^^^^^^^^^^^^^^^^^^^^^^
> 
> HFI table contains a table header and many table entries. Each table
> entry is identified by an hfi table index, and each CPU corresponds to
> one of the hfi table indexes.
> 
> ITD and HFI features both depend on the HFI table, but their HFI table
> are a little different. The HFI table provided by the ITD feature has
> more classes (in terms of more columns in the table) than the HFI table
> of native HFI feature.
> 
> The virtual HFI table in KVM is built based on the actual HFI table,
> which is maintained by HFI instance in HFI driver. We extract the HFI
> data of the pCPUs, which vCPUs are running on, to form a virtual HFI
> table.
> 
> 
> 4.2. HFI table index
> ^^^^^^^^^^^^^^^^^^^^
> 
> There are many entries in the HFI table, and the vCPU will be assigned
> an HFI table index to specify the entry it maps. KVM will fill the
> pCPU's HFI data (the pCPU that vCPU is running on) into the entry
> corresponding to the HFI table index of the vCPU in the vcitual HFI
> table.
> 
> This index is set by VMM in CPUID.
> 
> 
> 4.3. HFI table updating
> ^^^^^^^^^^^^^^^^^^^^^^^
> 
> On some platforms, the HFI table will be dynamically updated with
> thermal interrupts. In order to update the virtual HFI table in time, we
> added the per-VM notifier to the HFI driver to notify KVM to update the
> virtual HFI table for the VM, and then inject thermal interrupt into the
> VM to notify the Guest.
> 
> There is another case that needs to update the virtual HFI table, that
> is, when the vCPU is migrated, the pCPU where it is located is changed,
> and the corresponding virtual HFI data should also be updated to the new
> pCPU's data. In this case, in order to reduce overhead, we can only
> update the data of a single vPCU without traversing the entire virtual
> HFI table.
> 
> 
> 5. Patch Summary
> ================
> 
> Patch 01-03: Prepare the bit definition, the hfi helpers and hfi data
>              structures that KVM needs.
> Patch 04-05: Add the sched_out arch hook and reset the classification
>              history at sched_in()/schedu_out().
> Patch 06-10: Add emulations of ACPI, TM and PTM, mainly about CPUID and
>              related MSRs.
> Patch 11-20: Add the emulation support for HFI, including maintaining
>              the HFI table for VM.
> Patch 21-23: Add the emulation support for ITD, including extending HFI
>              to ITD and passing through the classification MSRs.
> Patch 24-25: Add HRESET emulation support, which is also used by IPC
>              classes feature.
> Patch 26:    Add the brief doc about the per-VM lock - pkg_therm_lock.
> 
> 
> 6. References
> =============
> 
> [1]: [PATCH 0/9] thermal: intel: hfi: Prework for the virtualization of HFI
>      https://lore.kernel.org/lkml/20240203040515.23947-1-ricardo.neri-calderon@linux.intel.com/
> [2]: [RFC 00/52] Introduce hybrid CPU topology,
>      https://lore.kernel.org/qemu-devel/20230213095035.158240-1-zhao1.liu@linux.intel.com/
> [3]: [RFC 00/41] qom-topo: Abstract Everything about CPU Topology,
>      https://lore.kernel.org/qemu-devel/20231130144203.2307629-1-zhao1.liu@linux.intel.com/
> [4]: SDM, vol. 3B, section 15.6 HARDWARE FEEDBACK INTERFACE AND INTEL
>      THREAD DIRECTOR
> 
> 
> Thanks and Best Regards,
> Zhao
> ---
> Zhao Liu (17):
>   thermal: Add bit definition for x86 thermal related MSRs
>   KVM: Add kvm_arch_sched_out() hook
>   KVM: x86: Reset hardware history at vCPU's sched_in/out
>   KVM: VMX: Add helpers to handle the writes to MSR's R/O and R/WC0 bits
>   KVM: x86: cpuid: Define CPUID 0x06.eax by kvm_cpu_cap_mask()
>   KVM: VMX: Introduce HFI description structure
>   KVM: VMX: Introduce HFI table index for vCPU
>   KVM: x86: Introduce the HFI dynamic update request and kvm_x86_ops
>   KVM: VMX: Allow to inject thermal interrupt without HFI update
>   KVM: VMX: Emulate HFI related bits in package thermal MSRs
>   KVM: VMX: Emulate the MSRs of HFI feature
>   KVM: x86: Expose HFI feature bit and HFI info in CPUID
>   KVM: VMX: Extend HFI table and MSR emulation to support ITD
>   KVM: VMX: Pass through ITD classification related MSRs to Guest
>   KVM: x86: Expose ITD feature bit and related info in CPUID
>   KVM: VMX: Emulate the MSR of HRESET feature
>   Documentation: KVM: Add description of pkg_therm_lock
> 
> Zhuocheng Ding (9):
>   thermal: intel: hfi: Add helpers to build HFI/ITD structures
>   thermal: intel: hfi: Add HFI notifier helpers to notify HFI update
>   KVM: VMX: Emulate ACPI (CPUID.0x01.edx[bit 22]) feature
>   KVM: x86: Expose TM/ACC (CPUID.0x01.edx[bit 29]) feature bit to VM
>   KVM: VMX: Emulate PTM/PTS (CPUID.0x06.eax[bit 6]) feature
>   KVM: VMX: Support virtual HFI table for VM
>   KVM: VMX: Sync update of Host HFI table to Guest
>   KVM: VMX: Update HFI table when vCPU migrates
>   KVM: x86: Expose HRESET feature's CPUID to Guest
> 
>  Documentation/virt/kvm/locking.rst  |  13 +-
>  arch/arm64/include/asm/kvm_host.h   |   1 +
>  arch/mips/include/asm/kvm_host.h    |   1 +
>  arch/powerpc/include/asm/kvm_host.h |   1 +
>  arch/riscv/include/asm/kvm_host.h   |   1 +
>  arch/s390/include/asm/kvm_host.h    |   1 +
>  arch/x86/include/asm/hfi.h          |  28 ++
>  arch/x86/include/asm/kvm-x86-ops.h  |   3 +-
>  arch/x86/include/asm/kvm_host.h     |   2 +
>  arch/x86/include/asm/msr-index.h    |  54 +-
>  arch/x86/kvm/cpuid.c                | 201 +++++++-
>  arch/x86/kvm/irq.h                  |   1 +
>  arch/x86/kvm/lapic.c                |   9 +
>  arch/x86/kvm/svm/svm.c              |   8 +
>  arch/x86/kvm/vmx/vmx.c              | 751 +++++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/vmx.h              |  79 ++-
>  arch/x86/kvm/x86.c                  |  18 +
>  drivers/thermal/intel/intel_hfi.c   | 212 +++++++-
>  drivers/thermal/intel/therm_throt.c |   1 -
>  include/linux/kvm_host.h            |   1 +
>  virt/kvm/kvm_main.c                 |   1 +
>  21 files changed, 1343 insertions(+), 44 deletions(-)
> 
> -- 
> 2.34.1
> 

