Return-Path: <kvm+bounces-38008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A8638A33914
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 08:42:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 79E11166177
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 07:42:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 112FE20AF97;
	Thu, 13 Feb 2025 07:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="CmIagTw0"
X-Original-To: kvm@vger.kernel.org
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBFDE20AF66;
	Thu, 13 Feb 2025 07:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739432549; cv=none; b=eW58vQG7ytmKyYsNGQzYKhGla1iBrs8QsZCljMRP9GjiFog2voxa5FdlzjhQksjWqJn/yQarwEG2XWhhKAIowpoB1VkAemChdHr13vGmSguIqKGkGzJKi69WDwsMP0hxa1Awi6G1nh3TeKYcsZsQqHYRojhFAgH7eXQSd0pCaQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739432549; c=relaxed/simple;
	bh=IlVYh+wZ/YIFB/UgdqiAswcv4hn7Nfi0gPcL0hnnO3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JK7i6n/4D3/9vjBMiX32faOtxrabs4afqEvsPzBM4nl1WLFgnWeDS6ayZ0pB/S6aT3JQt8a5DfN3XGJCkWKiZlTvx12dnpYSCm3dTsAucIW9cYVsOs0JyMow47OiQfzzadyqx7mYqv/mOSwK74xYLZvgYnIQ3RFLuA8Ll4IMx1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=CmIagTw0; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p4ffe03ae.dip0.t-ipconnect.de [79.254.3.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id D69B642529;
	Thu, 13 Feb 2025 08:42:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1739432540;
	bh=IlVYh+wZ/YIFB/UgdqiAswcv4hn7Nfi0gPcL0hnnO3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CmIagTw072QVKg6X2zF7CjJurHTdhFIIdQEKgjmvrTlWE/dhMXwuw81+d2esttJTW
	 1Y5ahtF8Fh/SNFP1P2RR1sujXeleOSH1HJl/VWQ+xg4ZehSMZVJUiWLJSjesYZK0bO
	 INumkDNROadS9kEyDgL/db6dJo8AvtGeSnYok5/tosCl3G+YJGQOKeyshvdDM2ZcNu
	 xudPDBoXknDJGg3hN5/h/oS5jZh1yx3J563YBU6NemsY4JynKHoKUNrpdeH2lDs9VK
	 7XBBTpmsyUoP0bd2AI13NqcUQzea1IEkVHpYZ4hkviX4l9Nr6eXPw9zpNl1Wi7lDZL
	 r2pcW+wJeNMNQ==
Date: Thu, 13 Feb 2025 08:42:18 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, thomas.lendacky@amd.com,
	john.allen@amd.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, suravee.suthikulpanit@amd.com, will@kernel.org,
	robin.murphy@arm.com, michael.roth@amd.com, dionnaglaze@google.com,
	nikunj@amd.com, ardb@kernel.org, kevinloughlin@google.com,
	Neeraj.Upadhyay@amd.com, vasant.hegde@amd.com,
	Stable@vger.kernel.org, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-coco@lists.linux.dev, iommu@lists.linux.dev
Subject: Re: [PATCH v4 3/3] x86/sev: Fix broken SNP support with KVM module
 built-in
Message-ID: <Z62iWr77bPWsZcDC@8bytes.org>
References: <cover.1739226950.git.ashish.kalra@amd.com>
 <138b520fb83964782303b43ade4369cd181fdd9c.1739226950.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <138b520fb83964782303b43ade4369cd181fdd9c.1739226950.git.ashish.kalra@amd.com>

On Mon, Feb 10, 2025 at 10:54:18PM +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Fix issues with enabling SNP host support and effectively SNP support
> which is broken with respect to the KVM module being built-in.
> 
> SNP host support is enabled in snp_rmptable_init() which is invoked as
> device_initcall(). SNP check on IOMMU is done during IOMMU PCI init
> (IOMMU_PCI_INIT stage). And for that reason snp_rmptable_init() is
> currently invoked via device_initcall() and cannot be invoked via
> subsys_initcall() as core IOMMU subsystem gets initialized via
> subsys_initcall().
> 
> Now, if kvm_amd module is built-in, it gets initialized before SNP host
> support is enabled in snp_rmptable_init() :
> 
> [   10.131811] kvm_amd: TSC scaling supported
> [   10.136384] kvm_amd: Nested Virtualization enabled
> [   10.141734] kvm_amd: Nested Paging enabled
> [   10.146304] kvm_amd: LBR virtualization supported
> [   10.151557] kvm_amd: SEV enabled (ASIDs 100 - 509)
> [   10.156905] kvm_amd: SEV-ES enabled (ASIDs 1 - 99)
> [   10.162256] kvm_amd: SEV-SNP enabled (ASIDs 1 - 99)
> [   10.171508] kvm_amd: Virtual VMLOAD VMSAVE supported
> [   10.177052] kvm_amd: Virtual GIF supported
> ...
> ...
> [   10.201648] kvm_amd: in svm_enable_virtualization_cpu
> 
> And then svm_x86_ops->enable_virtualization_cpu()
> (svm_enable_virtualization_cpu) programs MSR_VM_HSAVE_PA as following:
> wrmsrl(MSR_VM_HSAVE_PA, sd->save_area_pa);
> 
> So VM_HSAVE_PA is non-zero before SNP support is enabled on all CPUs.
> 
> snp_rmptable_init() gets invoked after svm_enable_virtualization_cpu()
> as following :
> ...
> [   11.256138] kvm_amd: in svm_enable_virtualization_cpu
> ...
> [   11.264918] SEV-SNP: in snp_rmptable_init
> 
> This triggers a #GP exception in snp_rmptable_init() when snp_enable()
> is invoked to set SNP_EN in SYSCFG MSR:
> 
> [   11.294289] unchecked MSR access error: WRMSR to 0xc0010010 (tried to write 0x0000000003fc0000) at rIP: 0xffffffffaf5d5c28 (native_write_msr+0x8/0x30)
> ...
> [   11.294404] Call Trace:
> [   11.294482]  <IRQ>
> [   11.294513]  ? show_stack_regs+0x26/0x30
> [   11.294522]  ? ex_handler_msr+0x10f/0x180
> [   11.294529]  ? search_extable+0x2b/0x40
> [   11.294538]  ? fixup_exception+0x2dd/0x340
> [   11.294542]  ? exc_general_protection+0x14f/0x440
> [   11.294550]  ? asm_exc_general_protection+0x2b/0x30
> [   11.294557]  ? __pfx_snp_enable+0x10/0x10
> [   11.294567]  ? native_write_msr+0x8/0x30
> [   11.294570]  ? __snp_enable+0x5d/0x70
> [   11.294575]  snp_enable+0x19/0x20
> [   11.294578]  __flush_smp_call_function_queue+0x9c/0x3a0
> [   11.294586]  generic_smp_call_function_single_interrupt+0x17/0x20
> [   11.294589]  __sysvec_call_function+0x20/0x90
> [   11.294596]  sysvec_call_function+0x80/0xb0
> [   11.294601]  </IRQ>
> [   11.294603]  <TASK>
> [   11.294605]  asm_sysvec_call_function+0x1f/0x30
> ...
> [   11.294631]  arch_cpu_idle+0xd/0x20
> [   11.294633]  default_idle_call+0x34/0xd0
> [   11.294636]  do_idle+0x1f1/0x230
> [   11.294643]  ? complete+0x71/0x80
> [   11.294649]  cpu_startup_entry+0x30/0x40
> [   11.294652]  start_secondary+0x12d/0x160
> [   11.294655]  common_startup_64+0x13e/0x141
> [   11.294662]  </TASK>
> 
> This #GP exception is getting triggered due to the following errata for
> AMD family 19h Models 10h-1Fh Processors:
> 
> Processor may generate spurious #GP(0) Exception on WRMSR instruction:
> Description:
> The Processor will generate a spurious #GP(0) Exception on a WRMSR
> instruction if the following conditions are all met:
> - the target of the WRMSR is a SYSCFG register.
> - the write changes the value of SYSCFG.SNPEn from 0 to 1.
> - One of the threads that share the physical core has a non-zero
> value in the VM_HSAVE_PA MSR.
> 
> The document being referred to above:
> https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/revision-guides/57095-PUB_1_01.pdf
> 
> To summarize, with kvm_amd module being built-in, KVM/SVM initialization
> happens before host SNP is enabled and this SVM initialization
> sets VM_HSAVE_PA to non-zero, which then triggers a #GP when
> SYSCFG.SNPEn is being set and this will subsequently cause
> SNP_INIT(_EX) to fail with INVALID_CONFIG error as SYSCFG[SnpEn] is not
> set on all CPUs.
> 
> Essentially SNP host enabling code should be invoked before KVM
> initialization, which is currently not the case when KVM is built-in.
> 
> Add fix to call snp_rmptable_init() early from iommu_snp_enable()
> directly and not invoked via device_initcall() which enables SNP host
> support before KVM initialization with kvm_amd module built-in.
> 
> Add additional handling for `iommu=off` or `amd_iommu=off` options.
> 
> Note that IOMMUs need to be enabled for SNP initialization, therefore,
> if host SNP support is enabled but late IOMMU initialization fails
> then that will cause PSP driver's SNP_INIT to fail as IOMMU SNP sanity
> checks in SNP firmware will fail with invalid configuration error as
> below:
> 
> [    9.723114] ccp 0000:23:00.1: sev enabled
> [    9.727602] ccp 0000:23:00.1: psp enabled
> [    9.732527] ccp 0000:a2:00.1: enabling device (0000 -> 0002)
> [    9.739098] ccp 0000:a2:00.1: no command queues available
> [    9.745167] ccp 0000:a2:00.1: psp enabled
> [    9.805337] ccp 0000:23:00.1: SEV-SNP: failed to INIT rc -5, error 0x3
> [    9.866426] ccp 0000:23:00.1: SEV API:1.53 build:5
> 
> Fixes: c3b86e61b756 ("x86/cpufeatures: Enable/unmask SEV-SNP CPU feature")
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Vasant Hegde <vasant.hegde@amd.com>
> Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
> Cc: <Stable@vger.kernel.org>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/include/asm/sev.h |  2 ++
>  arch/x86/virt/svm/sev.c    | 23 +++++++----------------
>  drivers/iommu/amd/init.c   | 34 ++++++++++++++++++++++++++++++----
>  3 files changed, 39 insertions(+), 20 deletions(-)

For the IOMMU part:

Acked-by: Joerg Roedel <jroedel@suse.de>


