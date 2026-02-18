Return-Path: <kvm+bounces-71204-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0BOFKJUQlWmkKgIAu9opvQ
	(envelope-from <kvm+bounces-71204-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 02:06:29 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C24815273A
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 02:06:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 356C63030760
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 01:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2F392C0F7F;
	Wed, 18 Feb 2026 01:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D5l4Ckqq"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26851F419A
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 01:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771376781; cv=none; b=Wv/dvqoR6l8/Yik85F1tj7Za7TP0lgBim3xfMAeRJrCWk/7B66eRQUpXF7pnv+Tjq3Xkw8Sd0pPI6TLgu3A1VnCaZB6L+aD6Xzce5V1groI6/CH9SCEnKK9B5lwwCgugNrsrrl3/stNOHuRjVw3Zjg7Q0KtbK+UGijB2XvPNgds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771376781; c=relaxed/simple;
	bh=pFebw0e5EP9sZWberN1AwtREJTX4o0XpXxAKScwj8Tg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G6kpPPe+d1D8SWv15M1efmvc6S+Xlf24vTej+HKGrgyc/OlPIu06ql0N51nBIgoaVNJFrktMsZuI0/l4NrvK4H/mbklSwVHb7yKm9L7xrovQuea2H5KA+3DsVOvChanmlEfH5l5YwXJ0dxU4t+EXsxmRKchHTjjwTkCZ6qTuLzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D5l4Ckqq; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 18 Feb 2026 01:06:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771376777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/9xPD9/VH4UZvSoyd0fJ4iT3ND9BhUQ0JqFNhcmPusg=;
	b=D5l4CkqqdVOWF0oPB4OoHkcyIt5PjMru9cKRS5FDFqMFnPWV/JCAAlL6JF5MbClY41Y0si
	DVxQiV/rFhm5+yLAo2isIqJJ9JlR0qfY43WD5NwyereCFVKlEXBLezTt5X9TtL0FFKrC3c
	AdGkn4SysQIYUJks/0T0jfS8KHCsds0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Defer non-architectural deliver of exception
 payload to userspace read
Message-ID: <ne6k7f3muebxvmarc76t4sydhy6qslkai4arncmbpdhvorqati@cbegez4tsn22>
References: <20260218005438.2619063-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218005438.2619063-1-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71204-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linux.dev:email,linux.dev:dkim]
X-Rspamd-Queue-Id: 1C24815273A
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 04:54:38PM -0800, Sean Christopherson wrote:
> When attempting to play nice with userspace that hasn't enabled
> KVM_CAP_EXCEPTION_PAYLOAD, defer KVM's non-architectural delivery of the
> payload until userspace actually reads relevant vCPU state, and more
> importantly, force delivery of the payload in *all* paths where userspace
> saves relevant vCPU state, not just KVM_GET_VCPU_EVENTS.
> 
> Ignoring userspace save/restore for the moment, delivering the payload
> before the exception is injected is wrong regardless of whether L1 or L2
> is running.  To make matters even more confusing, the flaw *currently*
> being papered over by the !is_guest_mode() check isn't even the same bug
> that commit da998b46d244 ("kvm: x86: Defer setting of CR2 until #PF
> delivery") was trying to avoid.
> 
> At the time of commit da998b46d244, KVM didn't correctly handle exception
> intercepts, as KVM would wait until VM-Entry into L2 was imminent to check
> if the queued exception should morph to a nested VM-Exit.  I.e. KVM would
> deliver the payload to L2 and then synthesize a VM-Exit into L1.  But the
> payload was only the most blatant issue, e.g. waiting to check exception
> intercepts would also lead to KVM incorrectly escalating a
> should-be-intercepted #PF into a #DF.
> 
> That underlying bug was eventually fixed by commit 7709aba8f716 ("KVM: x86:
> Morph pending exceptions to pending VM-Exits at queue time"), but in the
> interim, commit a06230b62b89 ("KVM: x86: Deliver exception payload on
> KVM_GET_VCPU_EVENTS") came along and subtly added another dependency on
> the !is_guest_mode() check.
> 
> While not recorded in the changelog, the motivation for deferring the
> !exception_payload_enabled delivery was to fix a flaw where a synthesized
> MTF (Monitor Trap Flag) VM-Exit would drop a pending #DB and clobber DR6.
> On a VM-Exit, VMX CPUs save pending #DB information into the VMCS, which
> is emulated by KVM in nested_vmx_update_pending_dbg() by grabbing the
> payload from the queue/pending exception.  I.e. prematurely delivering the
> payload would cause the pending #DB to not be recorded in the VMCS, and of
> course, clobber L2's DR6 as seen by L1.
> 
> Jumping back to save+restore, the quirked behavior of forcing delivery of
> the payload only works if userspace does KVM_GET_VCPU_EVENTS *before*
> CR2 or DR6 is saved, i.e. before KVM_GET_SREGS{,2} and KVM_GET_DEBUGREGS.
> E.g. if userspace does KVM_GET_SREGS before KVM_GET_VCPU_EVENTS, then the
> CR2 saved by userspace won't contain the payload for the exception save by
> KVM_GET_VCPU_EVENTS.
> 
> Deliberately deliver the payload in the store_regs() path, as it's the
> least awful option even though userspace may not be doing save+restore.
> Because if userspace _is_ doing save restore, it could elide KVM_GET_SREGS
> knowing that SREGS were already saved when the vCPU exited.
> 
> Link: https://lore.kernel.org/all/20200207103608.110305-1-oupton@google.com
> Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Seems like this is the same change as the one in
https://lore.kernel.org/kvm/aYI4d0zPw3K5BedW@google.com/, in which case:

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Tested-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> ---
>  arch/x86/kvm/x86.c | 62 +++++++++++++++++++++++++++++-----------------
>  1 file changed, 39 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index db3f393192d9..365ce3ea4a32 100644
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
> @@ -12137,6 +12151,8 @@ static void __get_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
>  	if (vcpu->arch.guest_state_protected)
>  		goto skip_protected_regs;
>  
> +	kvm_handle_exception_payload_quirk(vcpu);
> +
>  	kvm_get_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
>  	kvm_get_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
>  	kvm_get_segment(vcpu, &sregs->es, VCPU_SREG_ES);
> 
> base-commit: 183bb0ce8c77b0fd1fb25874112bc8751a461e49
> -- 
> 2.53.0.335.g19a08e0c02-goog
> 

