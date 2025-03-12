Return-Path: <kvm+bounces-40810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 89E42A5D3EA
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 02:14:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5A101724C7
	for <lists+kvm@lfdr.de>; Wed, 12 Mar 2025 01:14:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 706133595E;
	Wed, 12 Mar 2025 01:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dmDlqUoQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29DC8634D
	for <kvm@vger.kernel.org>; Wed, 12 Mar 2025 01:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741742044; cv=none; b=BYF0bZZ1mOyVG5v3JZ7sh16ur0mQfXhAymjrj8fEfOtZuk71wiImy4p3igntA3WzS0qSGddW0N9qsdr6sGsFXHmWrN7R6e32m3JJYF1m3zQ1iposoyqy2mf5o34FCwzHZ7U5NuYK/cZJJOn6tR+FHQwgn+pjlxiREZnVLyxg/Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741742044; c=relaxed/simple;
	bh=cw+bu3HxlbNj06nDNyIU+XJthNYzbbahBS9eBPqp78Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oiaOlVqTAqznyuRbZHVkMTcU7WKjhp81mWo0g8gMMhX+Kx/OoCTX2Mddgx0UV+mmRek+Pv6V4ei2Ls+Urt1i/hdSkVuOPB1a3UjAkef93xlu9dVhDmFLxERWfBndDeeFMXaa3HIcT2MOSc8hvpjQsattjSpysQdo63fnZSumMm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dmDlqUoQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741742041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GTQ6FqeSGJWa4gXakFBln2Ru3c0CV8pFrUsBtR+Ub9U=;
	b=dmDlqUoQCbnCFZ7Hi4JHHqDnN1Eb7lrkfTEJEVUnDVU+8hIpqHhhlMOhGJHhcYn96EC3ie
	3BKBFvqy5SNJ6XCylrsFE/8NVWHuXscEXh03IUuySSwNS+L8o4aV+xbZnipfE20Evz69r/
	frh0IRNfIb836TLHlJIB/3KLIMu9Gd4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-498-34Xi6h_tNNSo5Tb8LP3Huw-1; Tue,
 11 Mar 2025 21:13:56 -0400
X-MC-Unique: 34Xi6h_tNNSo5Tb8LP3Huw-1
X-Mimecast-MFC-AGG-ID: 34Xi6h_tNNSo5Tb8LP3Huw_1741742034
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0DA7019560B4;
	Wed, 12 Mar 2025 01:13:54 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.2])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C1A881955BCB;
	Wed, 12 Mar 2025 01:13:52 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 67841400DCFE8; Tue, 11 Mar 2025 22:13:30 -0300 (-03)
Date: Tue, 11 Mar 2025 22:13:30 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com,
	Sean Christopherson <seanjc@google.com>, chao.gao@intel.com,
	rick.p.edgecombe@intel.com, yan.y.zhao@intel.com,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Nikunj A Dadhania <nikunj@amd.com>
Subject: Re: [PATCH 0/2] KVM: kvm-coco-queue: Support protected TSC
Message-ID: <Z9DfurM5LwR5fwX4@tpad>
References: <cover.1728719037.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1728719037.git.isaku.yamahata@intel.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Sat, Oct 12, 2024 at 12:55:54AM -0700, Isaku Yamahata wrote:
> This patch series is for the kvm-coco-queue branch.  The change for TDX KVM is
> included at the last.  The test is done by create TDX vCPU and run, get TSC
> offset via vCPU device attributes and compare it with the TDX TSC OFFSET
> metadata.  Because the test requires the TDX KVM and TDX KVM kselftests, don't
> include it in this patch series.

OK, previous results were incorrect. In fact, this patches (which apply
cleanly to current kvm-coco-queue) reduce cyclictest latency from:

Max Latencies: 00167 00160
Max Latencies: 00132 00151
Max Latencies: 00138 00142
Max Latencies: 02512 02582
Max Latencies: 00139 00140
Max Latencies: 00128 00131
Max Latencies: 00131 00132
Max Latencies: 00131 00134
Max Latencies: 00136 00147
Max Latencies: 00153 00135
Max Latencies: 00138 00138

to:

Max Latencies: 00134 00131                                                                                  
Max Latencies: 00130 00129                                                                                  
Max Latencies: 00126 00141                                                                                 
Max Latencies: 00137 00138                                                                                  
Max Latencies: 00123 00115                                                                                  
Max Latencies: 00119 00127                                                                                  
Max Latencies: 00131 00104                                                                                  
Max Latencies: 00137 00127                                                                                  
Max Latencies: 00135 00126                                                                                  
Max Latencies: 00128 00142                                                                                  
Max Latencies: 00135 00138         

> 
> 
> Background
> ----------
> X86 confidential computing technology defines protected guest TSC so that the
> VMM can't change the TSC offset/multiplier once vCPU is initialized and the
> guest can trust TSC.  The SEV-SNP defines Secure TSC as optional.  TDX mandates
> it.  The TDX module determines the TSC offset/multiplier.  The VMM has to
> retrieve them.
> 
> On the other hand, the x86 KVM common logic tries to guess or adjust the TSC
> offset/multiplier for better guest TSC and TSC interrupt latency at KVM vCPU
> creation (kvm_arch_vcpu_postcreate()), vCPU migration over pCPU
> (kvm_arch_vcpu_load()), vCPU TSC device attributes (kvm_arch_tsc_set_attr()) and
> guest/host writing to TSC or TSC adjust MSR (kvm_set_msr_common()).
> 
> 
> Problem
> -------
> The current x86 KVM implementation conflicts with protected TSC because the
> VMM can't change the TSC offset/multiplier.  Disable or ignore the KVM
> logic to change/adjust the TSC offset/multiplier somehow.
> 
> Because KVM emulates the TSC timer or the TSC deadline timer with the TSC
> offset/multiplier, the TSC timer interrupts are injected to the guest at the
> wrong time if the KVM TSC offset is different from what the TDX module
> determined.
> 
> Originally the issue was found by cyclic test of rt-test [1] as the latency in
> TDX case is worse than VMX value + TDX SEAMCALL overhead.  It turned out that
> the KVM TSC offset is different from what the TDX module determines.
> 
> 
> Solution
> --------
> The solution is to keep the KVM TSC offset/multiplier the same as the value of
> the TDX module somehow.  Possible solutions are as follows.
> - Skip the logic
>   Ignore (or don't call related functions) the request to change the TSC
>   offset/multiplier.
>   Pros
>   - Logically clean.  This is similar to the guest_protected case.
>   Cons
>   - Needs to identify the call sites.
> 
> - Revert the change at the hooks after TSC adjustment
>   x86 KVM defines the vendor hooks when the TSC offset/multiplier are
>   changed.  The callback can revert the change.
>   Pros
>   - We don't need to care about the logic to change the TSC offset/multiplier.
>   Cons:
>   - Hacky to revert the KVM x86 common code logic.
> 
> Choose the first one.  With this patch series, SEV-SNP secure TSC can be
> supported.
> 
> 
> Patches:
> 1: Preparation for the next patch
> 2: Skip the logic to adjust the TSC offset/multiplier in the common x86 KVM logic
> 
> [1] https://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git
> 
> Changes for TDX KVM
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 8785309ccb46..969da729d89f 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -694,8 +712,6 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>  	vcpu->arch.cr0_guest_owned_bits = -1ul;
>  	vcpu->arch.cr4_guest_owned_bits = -1ul;
>  
> -	vcpu->arch.tsc_offset = kvm_tdx->tsc_offset;
> -	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
>  	/*
>  	 * TODO: support off-TD debug.  If TD DEBUG is enabled, guest state
>  	 * can be accessed. guest_state_protected = false. and kvm ioctl to
> @@ -706,6 +722,13 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>  	 */
>  	vcpu->arch.guest_state_protected = true;
>  
> +	/* VMM can't change TSC offset/multiplier as TDX module manages them. */
> +	vcpu->arch.guest_tsc_protected = true;
> +	vcpu->arch.tsc_offset = kvm_tdx->tsc_offset;
> +	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
> +	vcpu->arch.tsc_scaling_ratio = kvm_tdx->tsc_multiplier;
> +	vcpu->arch.l1_tsc_scaling_ratio = kvm_tdx->tsc_multiplier;
> +
>  	if ((kvm_tdx->xfam & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE)
>  		vcpu->arch.xfd_no_write_intercept = true;
>  
> @@ -2674,6 +2697,7 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
>  		goto out;
>  
>  	kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_OFFSET);
> +	kvm_tdx->tsc_multiplier = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_MULTIPLIER);
>  	kvm_tdx->attributes = td_params->attributes;
>  	kvm_tdx->xfam = td_params->xfam;
>  
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index 614b1c3b8483..c0e4fa61cab1 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -42,6 +42,7 @@ struct kvm_tdx {
>  	bool tsx_supported;
>  
>  	u64 tsc_offset;
> +	u64 tsc_multiplier;
>  
>  	enum kvm_tdx_state state;
>  
> diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> index 861c0f649b69..be4cf65c90a8 100644
> --- a/arch/x86/kvm/vmx/tdx_arch.h
> +++ b/arch/x86/kvm/vmx/tdx_arch.h
> @@ -69,6 +69,7 @@
>  
>  enum tdx_tdcs_execution_control {
>  	TD_TDCS_EXEC_TSC_OFFSET = 10,
> +	TD_TDCS_EXEC_TSC_MULTIPLIER = 11,
>  };
>  
>  enum tdx_vcpu_guest_other_state {
> 
> ---
> Isaku Yamahata (2):
>   KVM: x86: Push down setting vcpu.arch.user_set_tsc
>   KVM: x86: Don't allow tsc_offset, tsc_scaling_ratio to change
> 
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/x86.c              | 21 ++++++++++++++-------
>  2 files changed, 15 insertions(+), 7 deletions(-)
> 
> 
> base-commit: 909f9d422f59f863d7b6e4e2c6e57abb97a27d4d
> -- 
> 2.45.2
> 
> 


