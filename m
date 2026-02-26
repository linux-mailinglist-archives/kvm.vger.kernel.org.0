Return-Path: <kvm+bounces-72057-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6DIeEmWFoGkakgQAu9opvQ
	(envelope-from <kvm+bounces-72057-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 18:39:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id EE78D1ACA0D
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 18:39:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8FE40317BFB8
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:53:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C6D3426EBB;
	Thu, 26 Feb 2026 16:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k424bkQP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6AF40FD9C;
	Thu, 26 Feb 2026 16:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772123787; cv=none; b=cBfwR9HILUOHq5qHMWZ+sK01qbKt/yjIH5LvsaCDXRiDtJTjh9bReqONPskTbjArRPxv7P1ObMaHS0ra7hiNIfzH5T2TT40ssLdISVBLNu5jnF5ixBcmHNbmqbsb5HjMY3D6/8nihV+2QJwW+PewU61mahavbkxSGKlC2JiIqCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772123787; c=relaxed/simple;
	bh=v2kPCtvs4DuiDoqOgu+RK9gwVP8cHeKhzVZ4Rj4JAJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eb5p5b5KLBQETdHLiLMB+iU0EJkPAUp6AlzovydXw3HK2LpVAtcecUTq1eBKdT6qV6FYFdV3vQMhnO80DxjTrTFRv2OBgjsY4Tx9quNWHNOO6ffXE/xj/sW1FYixRLm/lxy3fcW1KP7R+mJk5mayd5uBeynLTDEovb2nIBtYGY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k424bkQP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44212C116C6;
	Thu, 26 Feb 2026 16:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772123787;
	bh=v2kPCtvs4DuiDoqOgu+RK9gwVP8cHeKhzVZ4Rj4JAJY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k424bkQPVtbYvPetNET1H8m9GM1yEbVMwlqJBrK6eEdMVajQ7W96PgnNZq4DckPQC
	 0r0QZnK1ZvtkJgqniOtQsXUyM607i9+K+pNIeKuraco6vVPSkWJbpPzQWDBhkQljNt
	 DsufcGssx62tT6vl5eIcYljfYZVp+niyhmL/348tEGx1N6sAHWtO/xZl6Uyh02XmBZ
	 lr4OE2m+3kHoApNW1zlLZ7LT/SWOv2tjMI5tlEigouWWGOgYZLPCb6OKE0kiiVFEiP
	 ANACetKdtnhHyy91Ab4udGVwWVarXMpU7qlA1RVrSFrUqQHresVvJ+Aecft+/aDaA8
	 gvb827rKCepEQ==
Date: Thu, 26 Feb 2026 16:36:25 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: SVM: Triple fault L1 on unintercepted
 EFER.SVME clear by L2
Message-ID: <txfn2izdpaavep6yrcujlxkqrqf2gwk2ccb6dplwcfnsstdnie@lgx74e27nus7>
References: <20260209195142.2554532-1-yosry.ahmed@linux.dev>
 <20260209195142.2554532-2-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209195142.2554532-2-yosry.ahmed@linux.dev>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72057-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,linux.dev:email]
X-Rspamd-Queue-Id: EE78D1ACA0D
X-Rspamd-Action: no action

On Mon, Feb 09, 2026 at 07:51:41PM +0000, Yosry Ahmed wrote:
> KVM tracks when EFER.SVME is set and cleared to initialize and tear down
> nested state. However, it doesn't differentiate if EFER.SVME is getting
> toggled in L1 or L2+. If L2 clears EFER.SVME, and L1 does not intercept
> the EFER write, KVM exits guest mode and tears down nested state while
> L2 is running, executing L1 without injecting a proper #VMEXIT.
> 
> According to the APM:
> 
>     The effect of turning off EFER.SVME while a guest is running is
>     undefined; therefore, the VMM should always prevent guests from
>     writing EFER.
> 
> Since the behavior is architecturally undefined, KVM gets to choose what
> to do. Inject a triple fault into L1 as a more graceful option that
> running L1 with corrupted state.
> 
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/svm.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 5f0136dbdde6..ccd73a3be3f9 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -216,6 +216,17 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
>  
>  	if ((old_efer & EFER_SVME) != (efer & EFER_SVME)) {
>  		if (!(efer & EFER_SVME)) {
> +			/*
> +			 * Architecturally, clearing EFER.SVME while a guest is
> +			 * running yields undefined behavior, i.e. KVM can do
> +			 * literally anything.  Force the vCPU back into L1 as
> +			 * that is the safest option for KVM, but synthesize a
> +			 * triple fault (for L1!) so that KVM at least doesn't
> +			 * run random L2 code in the context of L1.
> +			 */
> +			if (is_guest_mode(vcpu))
> +				kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> +

Sigh, I think this is not correct in all cases:

1. If userspace restores a vCPU with EFER.SVME=0 to a vCPU with
EFER.SVME=1 (e.g. restoring a vCPU running to a vCPU running L2).
Typically KVM_SET_SREGS is done before KVM_SET_NESTED_STATE, so we may
set EFER.SVME = 0 before leaving guest mode.

2. On vCPU reset, we clear EFER. Hmm, this one is seemingly okay tho,
looking at kvm_vcpu_reset(), we leave nested first:

	/*
	 * SVM doesn't unconditionally VM-Exit on INIT and SHUTDOWN, thus it's
	 * possible to INIT the vCPU while L2 is active.  Force the vCPU back
	 * into L1 as EFER.SVME is cleared on INIT (along with all other EFER
	 * bits), i.e. virtualization is disabled.
	 */
	if (is_guest_mode(vcpu))
		kvm_leave_nested(vcpu);

	...

	kvm_x86_call(set_efer)(vcpu, 0);

So I think the only problematic case is (1). We can probably fix this by
plumbing host_initiated through set_efer? This is getting more
complicated than I would have liked..


>  			svm_leave_nested(vcpu);
>  			/* #GP intercept is still needed for vmware backdoor */
>  			if (!enable_vmware_backdoor)
> -- 
> 2.53.0.rc2.204.g2597b5adb4-goog
> 

