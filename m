Return-Path: <kvm+bounces-7930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 00F728484FB
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 10:24:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5D53C1F2A45D
	for <lists+kvm@lfdr.de>; Sat,  3 Feb 2024 09:24:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 034655D724;
	Sat,  3 Feb 2024 09:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I5Xc1opG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9753B5D479
	for <kvm@vger.kernel.org>; Sat,  3 Feb 2024 09:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706952258; cv=none; b=JEIEn4Ar4ea04oByr5c6ueltBqIjq/bvmNPpJH2BIi0cR05SMr3CL8Qa1b9JJ4aFPvMNf4AmR1MvcH9EFQPf+w1GNgzEpYE5+rJdBG+q1f0X+fE5we0Mc6zAL2wlquHhlGCpANHFI6cAdqYRoFNY7sg7Z802RLvFC6POfEi6kiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706952258; c=relaxed/simple;
	bh=kw3OOTRz9AfhneBs+qlsMv0+ql7UK40PdaE6fG3rIDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HqrtpQZCgIesjii+j82VJTVGt+1EPtV6z+qi9TWA8MEP1lxYwziI95FePdj8Eu37uPgrZWNQ1JN07BsYcsp5K/ETuVvE2d+g3XYc1ITNHTxkpiXkko8fwvOmM4+Ut71DmxaETKGeCf7qg6XzptIxVczkz0jfU9LkA8gOG98vKEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I5Xc1opG; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706952257; x=1738488257;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kw3OOTRz9AfhneBs+qlsMv0+ql7UK40PdaE6fG3rIDE=;
  b=I5Xc1opGvHi8aHANUR5mvPSa5Hyj7LjFDPoXa9C6ftYbBWz/b2xE2fnc
   Op8+K5DaPeNSamANcKawnTdUF50dhGEzc37jUZkqqrp3IRM1aroHjJj88
   zf4HApSkHgdrt1idN0yoPODib96jnlIhAlx0OeK5uhyNKy6RrOK8a0RSO
   xzazcdfa+sJUe8fjo40szLYk6NTv/hTxUOmp2ACeO+6E5hVDpzcyTRA4H
   7AWgZyt05UWk7OXy2w7kSwrVZYocrwyqbpEdjisDeGuhMTJGnAjj0h8nD
   edS9SVa4r/Od5qbyiO8oocvYD8yK3sGZ4BbZttXsMuzhsYmTYWfij+Nfg
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10971"; a="209288"
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="209288"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2024 01:24:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,240,1701158400"; 
   d="scan'208";a="4913836"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa004.fm.intel.com with ESMTP; 03 Feb 2024 01:24:13 -0800
Date: Sat, 3 Feb 2024 17:37:45 +0800
From: Zhao Liu <zhao1.liu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Cc: Zhenyu Wang <zhenyu.z.wang@intel.com>,
	Zhuocheng Ding <zhuocheng.ding@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>,
	Yanting Jiang <yanting.jiang@intel.com>,
	Yongwei Ma <yongwei.ma@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [RFC 0/6] Intel Thread Director Virtualization Support in QEMU
Message-ID: <Zb4JaZ+aNzsSsTp2@intel.com>
References: <20240203093054.412135-1-zhao1.liu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240203093054.412135-1-zhao1.liu@linux.intel.com>

On Sat, Feb 03, 2024 at 05:30:48PM +0800, Zhao Liu wrote:
> Date: Sat, 3 Feb 2024 17:30:48 +0800
> From: Zhao Liu <zhao1.liu@linux.intel.com>
> Subject: [RFC 0/6] Intel Thread Director Virtualization Support in QEMU
> X-Mailer: git-send-email 2.34.1
> 
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> Hi list,
> 
> This is our refreshed RFC to support our ITD virtualization patch
> series [1] in KVM, and bases on bd2e12310b18 ("Merge tag
> 'qga-pull-2024-01-30' of https://github.com/kostyanf14/qemu into
> staging").
> 
> ITD is Intel's client specific feature to optimize scheduling on Intel
> hybrid platforms. Though this feature depends on hybrid topology

s/depends/doesn't depend/

Regards,
Zhao

> details, in our parctice on Win11 Guest, ITD works with hyrbid topolohy
> and CPU affinity can achieve the most performance improvement in Win11
> Guest (for example, on i9-13900K, up to 14%+ improvement on
> 3DMARK). More data or details, can be found in [1]. Thus, the ITD for
> Win11 is also a typical use case of hybrid topology.
> 
> 
> Welcome your feedback!
> 
> 
> 1. Background and Motivation
> ============================
> 
> ITD allows the hardware to provide scheduling hints to the OS to help
> optimize scheduling performance, and under the Intel hybrid
> architecture, since Core and Atom have different capabilities
> (performance, energy effency, etc.),  scheduling based on hardware
> hints can take full advantage of this hybrid architecture. This is also
> the most ideal scheduling model for intel hybrid architecture.
> 
> Therefore, we want to virtualize the ITD feature so that ITD can benefit
> performance of the virtual machines on the hybrid machines as well.
> 
> Currently, our ITD virtualization is a software virtualization solution.
> 
> 
> 2. Introduction to HFI and ITD
> ==============================
> 
> Intel provides Hardware Feedback Interface (HFI) feature to allow
> hardware to provide guidance to the OS scheduler to perform optimal
> workload scheduling through a hardware feedback interface structure in
> memory [2]. This hfi structure is called HFI table.
> 
> As for now, the guidance includes performance and energy enficency hints,
> and it could update via thermal interrupt as the actual operating
> conditions of the processor change during run time.
> 
> And Intel Thread Director (ITD) feature extends the HFI to provide
> performance and energy efficiency data for advanced classes of
> instructions.
> 
> The virtual HFI table is maintained in KVM, and for QEMU, we just need
> to handle HFI/ITD/HRESET (and their dependent features: ACPI, TM and
> PTS) related CPUIDs and MSRs.
> 
> 
> 3. Package level MSRs handling
> ==============================
> 
> PTS, HFI and ITD are all have package level features, such as package
> level MSRs and package level HFI tables. But since KVM hasn't
> support msr-topology and it just handle these package-level MSRs and
> HFI table at VM level, in order to avoid potential contention problems
> caused by multiple virtual-packages, we restrict VMs to be able to
> enable PTC/HFI/ITD iff there's only 1 package (and only 1 die for
> ITD/HFI).
> 
> 
> 4. HFI/ITD related info in CPUID
> ================================
> 
> KVM provides some basic HFI info in CPUID.0x06 leaf, which is associated
> with the virtual HFI table in KVM.
> 
> QEMU should configure HFI table index for each vCPU. Here we set the HFI
> table index to vCPU index so that different vCPUs have different HFI
> entries to avoid unnecessary competition problems.
> 
> 
> 5. Compatibility issues
> =======================
> 
> HFI is supported in both server (SPR) and client (ADL/RPL/MTL) platform
> products while ITD is the client specific feature.
> 
> For client platform, ITD (with HFI) could be enabled in Guest to improve
> scheduling, but for server platform, HFI (without ITD) is only useful
> on Host and Guest doesn't need it.
> 
> To simplify the enabling logic and avoid impacting the common topology
> of the Guest, we set PTS, HFI, and ITD as feature bits that are not
> automatically enabled.
> 
> Only when the user actively specifies these features, QEMU will check
> and decide whether to enable them based on the topology constraints and
> the ITD constraints.
> 
> 
> 6. New option "enable-itd"
> ============================
> 
> ITD-related features include PTS, HFI, ITD, and HRESET.
> 
> To make it easier for users to enable ITD for Guest without specifying
> the above feature bits one by one, we provide a new option "enable-itd"
> to set the above feature bits for Guest all at once.
> 
> "enable-itd" does not guarantee that ITD will be enabled for Guest.
> The success of enabling ITD for guest depends on topology constraints,
> platform support, etc., which are checked in QEMU.
> 
> 
> 7. Patch Summary
> ================
> 
> Patch 1: Add support save/load for ACPI feature related thermal MSRs
>          since ACPI feature CPUID has been added in QEMU.
> Patch 2: Add support for PTS (package) thermal MSRs and its CPUID
> Patch 3: Add support for HFI MSRs and its CPUID
> Patch 4: Add support ITD CPUID and MSR_IA32_HW_FEEDBACK_THREAD_CONFIG.
> Patch 5: Add support HRESET CPUID and MSR_IA32_HW_HRESET_ENABLE.
> Patch 6: Add "enable-itd" to help user set ITD related feature bits.
> 
> # 8. References
> 
> [1]: KVM RFC: [RFC 00/26] Intel Thread Director Virtualization
>      https://lore.kernel.org/kvm/20240203091214.411862-1-zhao1.liu@linux.intel.com/T/#t
> [2]: SDM, vol. 3B, section 15.6 HARDWARE FEEDBACK INTERFACE AND INTEL
>      THREAD DIRECTOR
> 
> Thanks and Best Regards,
> Zhao
> ---
> Zhao Liu (2):
>   target/i386: Add support for Intel Thread Director feature
>   i386: Add a new property to set ITD related feature bits for Guest
> 
> Zhuocheng Ding (4):
>   target/i386: Add support for save/load of ACPI thermal MSRs
>   target/i386: Add support for Package Thermal Management feature
>   target/i386: Add support for Hardware Feedback Interface feature
>   target/i386: Add support for HRESET feature
> 
>  target/i386/cpu.c     | 108 ++++++++++++++++++++++++++++++++++++++++--
>  target/i386/cpu.h     |  37 +++++++++++++++
>  target/i386/kvm/kvm.c |  84 ++++++++++++++++++++++++++++++++
>  3 files changed, 225 insertions(+), 4 deletions(-)
> 
> -- 
> 2.34.1
> 

