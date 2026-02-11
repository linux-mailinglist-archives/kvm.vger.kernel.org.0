Return-Path: <kvm+bounces-70894-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6ODKL57pjGmtvAAAu9opvQ
	(envelope-from <kvm+bounces-70894-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 21:42:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 288431277DA
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 21:42:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 62269304EAA9
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 20:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6F623587A4;
	Wed, 11 Feb 2026 20:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pwf/KsPy"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78E92288CB
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 20:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770842443; cv=none; b=jU7XSK6oo14wVBSCGSSvMQ824J+s/SpySWYJNepvKcfeMxwdnNWIiWQOcKnCuZXGbefR/f61JH+snlSCB3nEwrA/vcq8F7dwUF1XSbZTVCe6d9fVIQuwGlSBAR9Z8brp9Fy+mA+caf6kbRxjvkCxWE3Dn3NKWnQS66ZQczJI+8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770842443; c=relaxed/simple;
	bh=Mw+wHeaUnmrCvwdKENxBAPYQYjDGHL6xLe1IV5goNEc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n/cTUBa7Z3Ck6aOfWDVcnwuv/Zm9+Nql+b377w0VXIjYP87gdjQTWt/A2CS3csU2gu0dEVQ24U3sxRgeNCCDPZf/6R3dsVLdEU1EEnrFAPLMGGtdmGvUEkt8m/U0caFaBH877kX88yWiYG11HwhFshFWP6JcVn7rm6a61L8jTOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pwf/KsPy; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 11 Feb 2026 20:40:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770842439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=naAIMrM3awAHmSo0Jbxr6cOTY4DIPA17g6LI2+SBttQ=;
	b=pwf/KsPyiMBEQLJTpo8ldMXIoVBKi93OZp6l7CVLZuKYn568Ihf79TslNgd8MriEFZk0Yi
	fIEdLSlC0eef42+11/LNSLYojoQUTAZbTdQUZ3DFUcUVLTIQYRLxud+3hm29zySFEKim4Q
	qMcRNxSAX8BHzwD2QjNO4ekNpqQmo9s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nSVM: Use vcpu->arch.cr2 when updating vmcb12 on
 nested #VMEXIT
Message-ID: <rncblgei6isym2hsbw2jwgfpxwmpp5xbvfgoeut3fmvkbzzucj@eat3nisvyyoo>
References: <20260203011320.1314791-1-yosry.ahmed@linux.dev>
 <aYIebtv3nNnsqUiZ@google.com>
 <i4xpbma5acebgissizta7abydnwdn2hbdhgqxnb5gyxsjnx6q7@5ayraj5trdtl>
 <aYI4d0zPw3K5BedW@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYI4d0zPw3K5BedW@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70894-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linux.dev:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:dkim]
X-Rspamd-Queue-Id: 288431277DA
X-Rspamd-Action: no action

 
> So, with all of that in mind, I believe the best we can do is fully defer delivery
> of the exception until it's actually injected, and then apply the quirk to the
> relevant GET APIs.
> 
> ---
>  arch/x86/kvm/x86.c | 62 +++++++++++++++++++++++++++++-----------------
>  1 file changed, 39 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b0112c515584..e000521dfc8b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -864,9 +864,6 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu, unsigned int nr,
>  		vcpu->arch.exception.error_code = error_code;
>  		vcpu->arch.exception.has_payload = has_payload;
>  		vcpu->arch.exception.payload = payload;
> -		if (!is_guest_mode(vcpu))
> -			kvm_deliver_exception_payload(vcpu,
> -						      &vcpu->arch.exception);
>  		return;
>  	}
>  
> @@ -5532,18 +5529,8 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
>  	return 0;
>  }
>  
> -static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
> -					       struct kvm_vcpu_events *events)
> +static struct kvm_queued_exception *kvm_get_exception_to_save(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_queued_exception *ex;
> -
> -	process_nmi(vcpu);
> -
> -#ifdef CONFIG_KVM_SMM
> -	if (kvm_check_request(KVM_REQ_SMI, vcpu))
> -		process_smi(vcpu);
> -#endif
> -
>  	/*
>  	 * KVM's ABI only allows for one exception to be migrated.  Luckily,
>  	 * the only time there can be two queued exceptions is if there's a
> @@ -5554,21 +5541,46 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
>  	if (vcpu->arch.exception_vmexit.pending &&
>  	    !vcpu->arch.exception.pending &&
>  	    !vcpu->arch.exception.injected)
> -		ex = &vcpu->arch.exception_vmexit;
> -	else
> -		ex = &vcpu->arch.exception;
> +		return &vcpu->arch.exception_vmexit;
> +
> +	return &vcpu->arch.exception;
> +}
> +
> +static void kvm_handle_exception_payload_quirk(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_queued_exception *ex = kvm_get_exception_to_save(vcpu);
>  
>  	/*
> -	 * In guest mode, payload delivery should be deferred if the exception
> -	 * will be intercepted by L1, e.g. KVM should not modifying CR2 if L1
> -	 * intercepts #PF, ditto for DR6 and #DBs.  If the per-VM capability,
> -	 * KVM_CAP_EXCEPTION_PAYLOAD, is not set, userspace may or may not
> -	 * propagate the payload and so it cannot be safely deferred.  Deliver
> -	 * the payload if the capability hasn't been requested.
> +	 * If KVM_CAP_EXCEPTION_PAYLOAD is disabled, then (prematurely) deliver
> +	 * the pending exception payload when userspace saves *any* vCPU state
> +	 * that interacts with exception payloads to avoid breaking userspace.
> +	 *
> +	 * Architecturally, KVM must not deliver an exception payload until the
> +	 * exception is actually injected, e.g. to avoid losing pending #DB
> +	 * information (which VMX tracks in the VMCS), and to avoid clobbering
> +	 * state if the exception is never injected for whatever reason.  But
> +	 * if KVM_CAP_EXCEPTION_PAYLOAD isn't enabled, then userspace may or
> +	 * may not propagate the payload across save+restore, and so KVM can't
> +	 * safely defer delivery of the payload.
>  	 */
>  	if (!vcpu->kvm->arch.exception_payload_enabled &&
>  	    ex->pending && ex->has_payload)
>  		kvm_deliver_exception_payload(vcpu, ex);
> +}
> +
> +static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
> +					       struct kvm_vcpu_events *events)
> +{
> +	struct kvm_queued_exception *ex = kvm_get_exception_to_save(vcpu);
> +
> +	process_nmi(vcpu);
> +
> +#ifdef CONFIG_KVM_SMM
> +	if (kvm_check_request(KVM_REQ_SMI, vcpu))
> +		process_smi(vcpu);
> +#endif
> +
> +	kvm_handle_exception_payload_quirk(vcpu);
>  
>  	memset(events, 0, sizeof(*events));
>  
> @@ -5747,6 +5759,8 @@ static int kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
>  	    vcpu->arch.guest_state_protected)
>  		return -EINVAL;
>  
> +	kvm_handle_exception_payload_quirk(vcpu);
> +
>  	memset(dbgregs, 0, sizeof(*dbgregs));
>  
>  	BUILD_BUG_ON(ARRAY_SIZE(vcpu->arch.db) != ARRAY_SIZE(dbgregs->db));
> @@ -12123,6 +12137,8 @@ static void __get_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>  	if (vcpu->arch.guest_state_protected)
>  		goto skip_protected_regs;
>  
> +	kvm_handle_exception_payload_quirk(vcpu);
> +

Hmm looking at this again, I realized it also affects the code path from
store_regs(), I think we don't want to prematurely deliver exception
payloads in that path. So maybe it's best to move this to
kvm_arch_vcpu_ioctl_get_sregs() and kvm_arch_vcpu_ioctl()?

The other option is to plumb a boolean that is only set to true in the
ioctl code path.

>  	kvm_get_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
>  	kvm_get_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
>  	kvm_get_segment(vcpu, &sregs->es, VCPU_SREG_ES);
> 
> base-commit: 55671237401edd1ec59276b852b9361cc170915b
> --

