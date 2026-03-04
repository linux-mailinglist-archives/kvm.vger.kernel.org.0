Return-Path: <kvm+bounces-72634-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UDmMK+WHp2nOiAAAu9opvQ
	(envelope-from <kvm+bounces-72634-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 02:16:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3490B1F929E
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 02:16:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D48F130AF5AF
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 01:15:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8187630AAA9;
	Wed,  4 Mar 2026 01:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ub8wCfY/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72481A58D;
	Wed,  4 Mar 2026 01:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772586949; cv=none; b=oOlZCsztQGA7/LrpcNETDim6s0VNLk+swOmu/DttUsLAdQ6bKQg7g5AdS/czD9dEIGRSdqNDdXOQJI/UGSLE9Xu8zZ312hYE5yENmgL3T0JbwNC+bQKvvrDqb1RNm9u1GQr3khsgpoHGwdaf4uvwBx8K/D5EiC5js107T40M1Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772586949; c=relaxed/simple;
	bh=w4qGZsyfOVMjw3enYMUoTAJUu0SyHbxkF+jE4quULNY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sMbUYFE59vcMLN3OmMdLjgGn82mw/zUnFTn6pzSsQo56/SEcfCYpIsh+v1nF7etNVNTjU73ei9cmTE4raj7EecGSKQKo9+ZTw3sUJE+HNliMrmLjiz7rNL+gn4/mUVphOUV15Y4Cjusv1nCKWFMuVpuxhS6XP00HwhBy3KCeI6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ub8wCfY/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E636C116C6;
	Wed,  4 Mar 2026 01:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772586949;
	bh=w4qGZsyfOVMjw3enYMUoTAJUu0SyHbxkF+jE4quULNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ub8wCfY/vToQAh7c0balC2VooCk88NfHf0Yxm7Apg2CcSZKRHV0OrsRroe/NUGwsN
	 zq1VRtHwszxg4i5VeE00I9yPEkuNi1DNZm/UAOVAzEt08COedqyzS+g4i1WCK4ul7e
	 NYbClJJwHXanUBW/mTdt5D/L2RmUIWhNL35UvfEOsMzteODGw7v8CkBgr30InQAGlY
	 4dHX/Stzz7Rulajzvzkc1KJGnhj+YR/2RjB1tcHI+PoTW5fxza7i6XXyhcmI/XPLNK
	 HW5Gvaa6fWOYLLluKitQm2AhdnZQMaDT3FiPGazDZpf39XdH2KpfIx92bTBfIu7pyC
	 H2cEF3M67BgMQ==
Date: Wed, 4 Mar 2026 01:15:46 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Cheng <chengkev@google.com>
Subject: Re: [PATCH v5 2/2] KVM: nSVM: Always intercept VMMCALL when L2 is
 active
Message-ID: <j4t4v6n6hg5d7qxz722yecwtafphf55xgyrs5bnyowwa7emzfp@ceajjnpem4vk>
References: <20260304002223.1105129-1-seanjc@google.com>
 <20260304002223.1105129-3-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304002223.1105129-3-seanjc@google.com>
X-Rspamd-Queue-Id: 3490B1F929E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72634-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Action: no action

On Tue, Mar 03, 2026 at 04:22:23PM -0800, Sean Christopherson wrote:
> Always intercept VMMCALL now that KVM properly synthesizes a #UD as
> appropriate, i.e. when L1 doesn't want to intercept VMMCALL, to avoid
> putting L2 into an infinite #UD loop if KVM_X86_QUIRK_FIX_HYPERCALL_INSN
> is enabled.
> 
> By letting L2 execute VMMCALL natively and thus #UD, for all intents and
> purposes KVM morphs the VMMCALL intercept into a #UD intercept (KVM always
> intercepts #UD).  When the hypercall quirk is enabled, KVM "emulates"
> VMMCALL in response to the #UD by trying to fixup the opcode to the "right"
> vendor, then restarts the guest, without skipping the VMMCALL.  As a
> result, the guest sees an endless stream of #UDs since it's already
> executing the correct vendor hypercall instruction, i.e. the emulator
> doesn't anticipate that the #UD could be due to lack of interception, as
> opposed to a truly undefined opcode.
> 
> Fixes: 0d945bd93511 ("KVM: SVM: Don't allow nested guest to VMMCALL into host")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/hyperv.h | 4 ----
>  arch/x86/kvm/svm/nested.c | 7 -------
>  2 files changed, 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
> index 9af03970d40c..f70d076911a6 100644
> --- a/arch/x86/kvm/svm/hyperv.h
> +++ b/arch/x86/kvm/svm/hyperv.h
> @@ -51,10 +51,6 @@ static inline bool nested_svm_is_l2_tlb_flush_hcall(struct kvm_vcpu *vcpu)
>  void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
>  #else /* CONFIG_KVM_HYPERV */
>  static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu) {}
> -static inline bool nested_svm_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
> -{
> -	return false;
> -}

Why is this dropped? We still need it for vmmcall_interception under
!CONFIG_KVM_HYPERV, right?

