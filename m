Return-Path: <kvm+bounces-27483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF377986594
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 19:28:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CEF71C243C0
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 17:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46EFE57880;
	Wed, 25 Sep 2024 17:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="x40VMY8W";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dZmGLEdK";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="x40VMY8W";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="dZmGLEdK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC57210E9;
	Wed, 25 Sep 2024 17:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727285280; cv=none; b=gSvFo5TKcMca+9fM7ilvPgmYXRJNg/XMeSbCnQa+pf7klR94Y4Px/CrrJIUEWz5Xhto36MIVEVKLfB8xJARAflfebWGH3m834pT4E9/h1yTzJNjwEdP2RjvLM/4mtGm+bC3aYD/+StjZV0AdP5sxEC2JiHw0GE01TZswqDIB+yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727285280; c=relaxed/simple;
	bh=jM92NAr0tspG01nateusrF19Yw58W5D2DlP6X6V/8Pk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NO4H9AdAZuXogrzmlrCQCQ4zA/eCRn8tPD78vuFF+VQVpiyc3hypoW72088HsXA1Mxz7vI01dBugrgSivZ/j8omgc3rTyXBf1/stzGPlvAI+EVe6n8N//AhMcUPqeShy0R2all/2XOZcmK27PWteaesuLf51z728hvgFgljhHyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=x40VMY8W; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dZmGLEdK; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=x40VMY8W; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=dZmGLEdK; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from kitsune.suse.cz (unknown [10.100.12.127])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 97FBC1F814;
	Wed, 25 Sep 2024 17:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727285276; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s9nEIBh9bKtyhxEMUs1oljP3B338usBJA+Fw8kqru4I=;
	b=x40VMY8WljWjgdchHwE5oB5B7HNYeFwxRy4ugQvUe9ScSvDgn5hgo+jBDzBzwl9slGtRGu
	nRblpQAy9a7dnmbfKSPb/nh/xyOqREI5WLHtHK6K3ypJWdbOKALN5VWTs0VkO7OlKWsYlH
	EniUdAnV4uD56KReH1qvsjWXvIa/KW8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727285276;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s9nEIBh9bKtyhxEMUs1oljP3B338usBJA+Fw8kqru4I=;
	b=dZmGLEdKRQ82+qaGqYr5BdUOAyXSNtqmCn1uKdNz9pkA9b4cfGCdaJ8wTt49FREtm9TzfK
	d6+HaefTqO12k+Bw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727285276; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s9nEIBh9bKtyhxEMUs1oljP3B338usBJA+Fw8kqru4I=;
	b=x40VMY8WljWjgdchHwE5oB5B7HNYeFwxRy4ugQvUe9ScSvDgn5hgo+jBDzBzwl9slGtRGu
	nRblpQAy9a7dnmbfKSPb/nh/xyOqREI5WLHtHK6K3ypJWdbOKALN5VWTs0VkO7OlKWsYlH
	EniUdAnV4uD56KReH1qvsjWXvIa/KW8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727285276;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s9nEIBh9bKtyhxEMUs1oljP3B338usBJA+Fw8kqru4I=;
	b=dZmGLEdKRQ82+qaGqYr5BdUOAyXSNtqmCn1uKdNz9pkA9b4cfGCdaJ8wTt49FREtm9TzfK
	d6+HaefTqO12k+Bw==
Date: Wed, 25 Sep 2024 19:27:55 +0200
From: Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To: Jordan Niethe <jniethe5@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org, mikey@neuling.org, sbhat@linux.ibm.com,
	kvm@vger.kernel.org, amachhiw@linux.vnet.ibm.com,
	gautam@linux.ibm.com, npiggin@gmail.com, David.Laight@aculab.com,
	kvm-ppc@vger.kernel.org, sachinp@linux.ibm.com,
	vaibhav@linux.ibm.com, kconsul@linux.vnet.ibm.com
Subject: Re: [PATCH v5 00/11] KVM: PPC: Nested APIv2 guest support
Message-ID: <ZvRIG1LHwqa5_kgP@kitsune.suse.cz>
References: <20230914030600.16993-1-jniethe5@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230914030600.16993-1-jniethe5@gmail.com>
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-0.999];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[gmail.com];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[lists.ozlabs.org,neuling.org,linux.ibm.com,vger.kernel.org,linux.vnet.ibm.com,gmail.com,aculab.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On Thu, Sep 14, 2023 at 01:05:49PM +1000, Jordan Niethe wrote:
> 
> A nested-HV API for PAPR has been developed based on the KVM-specific
> nested-HV API that is upstream in Linux/KVM and QEMU. The PAPR API had
> to break compatibility to accommodate implementation in other
> hypervisors and partitioning firmware. The existing KVM-specific API
> will be known as the Nested APIv1 and the PAPR API will be known as the
> Nested APIv2. 
> 
> The control flow and interrupt processing between L0, L1, and L2 in
> the Nested APIv2 are conceptually unchanged. Where Nested APIv1 is almost
> stateless, the Nested APIv2 is stateful, with the L1 registering L2 virtual
> machines and vCPUs with the L0. Supervisor-privileged register switching
> duty is now the responsibility for the L0, which holds canonical L2
> register state and handles all switching. This new register handling
> motivates the "getters and setters" wrappers to assist in syncing the
> L2s state in the L1 and the L0.

Hello,

are there any machines on which this is supposed to work?

On a 9105-22A with ML1050_fw1050.20 (78) and
Linux 6.11.0-lp155.4.gce149d2-default I get:

[   29.228161] kvm-hv: nestedv2 get capabilities hcall failed, falling back to nestedv1 (rc=-2)
[   29.228168] kvm-hv: Parent hypervisor does not support nesting (rc=-2)

Can the hardware requirements be clarified?

Thanks

Michal


> 
> Broadly, the new hcalls will be used for  creating and managing guests
> by a regular partition in the following way:
> 
>   - L1 and L0 negotiate capabilities with
>     H_GUEST_{G,S}ET_CAPABILITIES
> 
>   - L1 requests the L0 create a L2 with
>     H_GUEST_CREATE and receives a handle to use in future hcalls
> 
>   - L1 requests the L0 create a L2 vCPU with
>     H_GUEST_CREATE_VCPU
> 
>   - L1 sets up the L2 using H_GUEST_SET and the
>     H_GUEST_VCPU_RUN input buffer
> 
>   - L1 requests the L0 runs the L2 vCPU using H_GUEST_VCPU_RUN
> 
>   - L2 returns to L1 with an exit reason and L1 reads the
>     H_GUEST_VCPU_RUN output buffer populated by the L0
> 
>   - L1 handles the exit using H_GET_STATE if necessary
> 
>   - L1 reruns L2 vCPU with H_GUEST_VCPU_RUN
> 
>   - L1 frees the L2 in the L0 with H_GUEST_DELETE
> 
> Further details are available in Documentation/powerpc/kvm-nested.rst.
> 
> This series adds KVM support for using this hcall interface as a regular
> PAPR partition, i.e. the L1. It does not add support for running as the
> L0.
> 
> The new hcalls have been implemented in the spapr qemu model for
> testing.
> 
> This is available at https://github.com/planetharsh/qemu/tree/upstream-0714-kop
> 
> There are scripts available to assist in setting up an environment for
> testing nested guests at https://github.com/iamjpn/kvm-powervm-test
> 
> A tree with this series is available at
> https://github.com/iamjpn/linux/tree/features/kvm-nestedv2-v5
> 
> Thanks to Amit Machhiwal, Kautuk Consul, Vaibhav Jain, Michael Neuling,
> Shivaprasad Bhat, Harsh Prateek Bora, Paul Mackerras and Nicholas
> Piggin.
> 
> Change overview in v5:
>   - KVM: PPC: Add helper library for Guest State Buffers:
>     - Fix mismatched function comments
>   - KVM: PPC: Add support for nestedv2 guests:
>     - Check H_BUSY for {g,s}etting capabilities
>     - Message if plpar_guest_get_capabilities() fails and nestedv1
>       support will be attempted.
>     - Remove unused amor variable
>   - KVM: PPC: Book3S HV: Use accessors for VCPU registers:
>     - Remove unneeded trailing comment for line length
> 
> 
> Change overview in v4:
>   - Split previous "KVM: PPC: Use getters and setters for vcpu register
>     state" into a number of seperate patches
>     - Remove _hv suffix from VCORE wrappers
>     - Do not create arch_compat and lpcr setters, use the existing ones
>     - Use #ifdef ALTIVEC
>   - KVM: PPC: Rename accessor generator macros
>     - Fix typo
>   - KVM: PPC: Book3s HV: Hold LPIDs in an unsigned long
>     - Use u64
>     - Change format strings instead of casting
>   - KVM: PPC: Add support for nestedv2 guests
>     - Batch H_GUEST_GET calls in kvmhv_nestedv2_reload_ptregs()
>     - Fix compile without CONFIG_PSERIES
>     - Fix maybe uninitialized 'trap' in kvmhv_p9_guest_entry()
>     - Extend existing setters for arch_compat and lpcr
> 
> 
> Change overview in v3:
>   - KVM: PPC: Use getters and setters for vcpu register state
>       - Do not add a helper for pvr
>       - Use an expression when declaring variable in case
>       - Squash in all getters and setters
>       - Pass vector registers by reference
>   - KVM: PPC: Rename accessor generator macros
>       - New to series
>   - KVM: PPC: Add helper library for Guest State Buffers
>       - Use EXPORT_SYMBOL_GPL()
>       - Use the kvmppc namespace
>       - Move kvmppc_gsb_reset() out of kvmppc_gsm_fill_info()
>       - Comments for GSID elements
>       - Pass vector elements by reference
>       - Remove generic put and get functions
>   - KVM: PPC: Book3s HV: Hold LPIDs in an unsigned long
>       - New to series
>   - KVM: PPC: Add support for nestedv2 guests
>       - Use EXPORT_SYMBOL_GPL()
>       - Change to kvmhv_nestedv2 namespace
>       - Make kvmhv_enable_nested() return -ENODEV on NESTEDv2 L1 hosts
>       - s/kvmhv_on_papr/kvmhv_is_nestedv2/
>       - mv book3s_hv_papr.c book3s_hv_nestedv2.c
>       - Handle shared regs without a guest state id in the same wrapper
>       - Use a static key for API version
>       - Add a positive test for NESTEDv1
>       - Give the amor a static value
>       - s/struct kvmhv_nestedv2_host/struct kvmhv_nestedv2_io/
>       - Propagate failure in kvmhv_vcpu_entry_nestedv2()
>       - WARN if getters and setters fail
>       - Progagate failure from kvmhv_nestedv2_parse_output()
>       - Replace delay with sleep in plpar_guest_{create,delete,create_vcpu}()
>       - Add logical PVR handling
>       - Replace kvmppc_gse_{get,put} with specific version
>   - docs: powerpc: Document nested KVM on POWER
>       - Fix typos
> 
> 
> Change overview in v2:
>   - Rebase on top of kvm ppc prefix instruction support
>   - Make documentation an individual patch
>   - Move guest state buffer files from arch/powerpc/lib/ to
>     arch/powerpc/kvm/
>   - Use kunit for testing guest state buffer
>   - Fix some build errors
>   - Change HEIR element from 4 bytes to 8 bytes
> 
> Previous revisions:
> 
>   - v1: https://lore.kernel.org/linuxppc-dev/20230508072332.2937883-1-jpn@linux.vnet.ibm.com/
>   - v2: https://lore.kernel.org/linuxppc-dev/20230605064848.12319-1-jpn@linux.vnet.ibm.com/
>   - v3: https://lore.kernel.org/linuxppc-dev/20230807014553.1168699-1-jniethe5@gmail.com/
>   - v4: https://lore.kernel.org/linuxppc-dev/20230905034658.82835-1-jniethe5@gmail.com/
> 
> Jordan Niethe (10):
>   KVM: PPC: Always use the GPR accessors
>   KVM: PPC: Introduce FPR/VR accessor functions
>   KVM: PPC: Rename accessor generator macros
>   KVM: PPC: Use accessors for VCPU registers
>   KVM: PPC: Use accessors for VCORE registers
>   KVM: PPC: Book3S HV: Use accessors for VCPU registers
>   KVM: PPC: Book3S HV: Introduce low level MSR accessor
>   KVM: PPC: Add helper library for Guest State Buffers
>   KVM: PPC: Book3s HV: Hold LPIDs in an unsigned long
>   KVM: PPC: Add support for nestedv2 guests
> 
> Michael Neuling (1):
>   docs: powerpc: Document nested KVM on POWER
> 
>  Documentation/powerpc/index.rst               |   1 +
>  Documentation/powerpc/kvm-nested.rst          | 636 +++++++++++
>  arch/powerpc/Kconfig.debug                    |  12 +
>  arch/powerpc/include/asm/guest-state-buffer.h | 995 ++++++++++++++++++
>  arch/powerpc/include/asm/hvcall.h             |  30 +
>  arch/powerpc/include/asm/kvm_book3s.h         | 220 +++-
>  arch/powerpc/include/asm/kvm_book3s_64.h      |   8 +-
>  arch/powerpc/include/asm/kvm_booke.h          |  10 +
>  arch/powerpc/include/asm/kvm_host.h           |  22 +-
>  arch/powerpc/include/asm/kvm_ppc.h            | 102 +-
>  arch/powerpc/include/asm/plpar_wrappers.h     | 267 ++++-
>  arch/powerpc/kvm/Makefile                     |   4 +
>  arch/powerpc/kvm/book3s.c                     |  38 +-
>  arch/powerpc/kvm/book3s_64_mmu_hv.c           |   7 +-
>  arch/powerpc/kvm/book3s_64_mmu_radix.c        |  31 +-
>  arch/powerpc/kvm/book3s_64_vio.c              |   4 +-
>  arch/powerpc/kvm/book3s_hv.c                  | 358 +++++--
>  arch/powerpc/kvm/book3s_hv.h                  |  76 ++
>  arch/powerpc/kvm/book3s_hv_builtin.c          |  11 +-
>  arch/powerpc/kvm/book3s_hv_nested.c           |  44 +-
>  arch/powerpc/kvm/book3s_hv_nestedv2.c         | 994 +++++++++++++++++
>  arch/powerpc/kvm/book3s_hv_p9_entry.c         |   4 +-
>  arch/powerpc/kvm/book3s_hv_ras.c              |   4 +-
>  arch/powerpc/kvm/book3s_hv_rm_mmu.c           |   8 +-
>  arch/powerpc/kvm/book3s_hv_rm_xics.c          |   4 +-
>  arch/powerpc/kvm/book3s_hv_uvmem.c            |   2 +-
>  arch/powerpc/kvm/book3s_xive.c                |  12 +-
>  arch/powerpc/kvm/emulate_loadstore.c          |   6 +-
>  arch/powerpc/kvm/guest-state-buffer.c         | 621 +++++++++++
>  arch/powerpc/kvm/powerpc.c                    |  76 +-
>  arch/powerpc/kvm/test-guest-state-buffer.c    | 328 ++++++
>  31 files changed, 4672 insertions(+), 263 deletions(-)
>  create mode 100644 Documentation/powerpc/kvm-nested.rst
>  create mode 100644 arch/powerpc/include/asm/guest-state-buffer.h
>  create mode 100644 arch/powerpc/kvm/book3s_hv_nestedv2.c
>  create mode 100644 arch/powerpc/kvm/guest-state-buffer.c
>  create mode 100644 arch/powerpc/kvm/test-guest-state-buffer.c
> 
> -- 
> 2.39.3
> 

