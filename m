Return-Path: <kvm+bounces-70022-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iGmRHW8ggmlIPgMAu9opvQ
	(envelope-from <kvm+bounces-70022-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 17:21:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C7140DBD55
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 17:21:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 87E143182856
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 16:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7BAB3C1992;
	Tue,  3 Feb 2026 16:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u4+jdEvz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00E4284B36
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 16:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770135154; cv=none; b=Vpk42R+/jxsHeSs9X9fGZ3wKIi0yaUvUOfWbGlLfT3S7Ls3TpAkx9995GJMTla3mZBlbixCbr1trIDac2BBSYd/0ZW6XjDe1+AUr2q5J2O7i954b9St1O9Ge0wxpcUN4vmxGsgjdejAyD1VLqLYMxxCBDKHwI2jW+Slcs8zpnRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770135154; c=relaxed/simple;
	bh=Yd2EkrPOWBIh5sieJ9w4GFdrcxzWfK0mtEpSnKEEryw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lUeCTDFHyz3hI5ymQ0SK3KWtoh8+SBYga2LXOWHL+/lC9Vp9YFq2cR1wa4kxCJckJMf0grovd4M+cVlodUNy+Xvrg1mP2Y3KT0szBPvSe4ZfwV1AlJoLpUciNGMuOFWn3W85iViz17Qh5vHoOtSkoHxHXPEf00JSqNq7k4qCBA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u4+jdEvz; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c43f8ef9bso1037790a91.1
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 08:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770135152; x=1770739952; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NB+8obLGNKPyqkpofCkeQcVUNj7V6EcZxKGJs5/Qvlg=;
        b=u4+jdEvzBYR2/l/fhJMBbzW03QlIMhqDXWkGKsF31rDQhqpPs+JIu5bjfsagJxELsy
         TQwIm8oWu4BKlo6cLqBbSEoEsSpDL1M6/XGlyaLduMAzTTvfUbSnAXa9m+XSDwaw2cRa
         0ranGv2WcwQ80cqLdqN25v2Q5PPlTGpCCGuBjedbZ5HVG0HLWMvpseG2pnQk+e2c13dp
         R2t0QRGfWiC48peE8yZp/4WVMdi9/+esqIW0GCQtMP3yfue57qbzFWod8sV2VGgnB8sK
         yj8dXbESaT8hUZO73z1/BP/5aWvp5RmngYZGl1NgwoTd1oJFV+ln25BzAbZRKK4a1pZj
         B8kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770135152; x=1770739952;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NB+8obLGNKPyqkpofCkeQcVUNj7V6EcZxKGJs5/Qvlg=;
        b=chDdpzX2H4tfZBMlHuWOZafQBCMWtuIB4WV7G3FqdwR3sIBNsMm/wTP6NujC3YzGxy
         qtlhsBr8raOZx5wuqnhgwwRHrnJRsOJiQ1Qqd0A2L1EtZL2RmqisbRLPu6c8AeXBs7RC
         2vgr32oyNUuLRw+QQIzzJqc0QSj7QpjdVuutnqfqp+gWOZxwQgm53aItVIFrJqmqiBp2
         07OLQIXX0kaeAG5cei7ic+dxv01BO+KX7ByXA2kX55of6wfYBMWTJHOw+9Z8y2RpsYh9
         Wezrh5VylYTZAJ2dlVNsSHz4sk93zEuVuctdq5SNSjp7dV9pPc5VRWU0U7M2nbyGJ6Gb
         nb/g==
X-Forwarded-Encrypted: i=1; AJvYcCXrR48R3j83zp/mN7T3x7c+FaVaTlYxNDBOpyR64AOHak3kf83poMJWRF3QySEkN1WuKgU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf+6xflWmV+D9tVXjpU6OcOOh0/3UHokEH9yibhtwA9HwfZ/BM
	BahAolIZOpDpDIwaMrylGgJlTgxftvYX8iIBgbWFyq6o5AWX+k35Mw9uwT5zr9e6SA1lle4AuxF
	dSi1PCQ==
X-Received: from pjtw2.prod.google.com ([2002:a17:90a:c982:b0:352:925c:a29c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f87:b0:343:3898:e7c7
 with SMTP id 98e67ed59e1d1-3547775f293mr2970102a91.12.1770135151989; Tue, 03
 Feb 2026 08:12:31 -0800 (PST)
Date: Tue, 3 Feb 2026 08:12:30 -0800
In-Reply-To: <20260203011320.1314791-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260203011320.1314791-1-yosry.ahmed@linux.dev>
Message-ID: <aYIebtv3nNnsqUiZ@google.com>
Subject: Re: [PATCH] KVM: nSVM: Use vcpu->arch.cr2 when updating vmcb12 on
 nested #VMEXIT
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70022-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C7140DBD55
X-Rspamd-Action: no action

On Tue, Feb 03, 2026, Yosry Ahmed wrote:
> KVM currently uses the value of CR2 from vmcb02 to update vmcb12 on
> nested #VMEXIT. Use the value from vcpu->arch.cr2 instead.
> 
> The value in vcpu->arch.cr2 is sync'd to vmcb02 shortly before a VMRUN
> of L2, and sync'd back to vcpu->arch.cr2 shortly after. The value are
> only out-of-sync in two cases: after migration, and after a #PF is

Nit, instead of "migration", talk about state save/restore, and then list live
migration as an example.  Most of the time it's fairly obvious that "migration"
in KVM means "live migration", but not always.  E.g. task migration often comes
into play, as does page migration.

And more importantly, the above statement is wrong when state is saved/restored
for something other than migration.  E.g. if userspace is restoring a snapshot
for reasons other than migrating a VM.

> injected into L2.
> 
> After migration, the value of CR2 in vmcb02 is uninitialized (i.e.

save/restore

> zero),

This isn't guaranteed.  E.g. if state is restored into a vCPU that was already
running, vmcb02.save.cr2 could hold any number of things.

> as KVM_SET_SREGS restores CR2 value to vcpu->arch.cr2. Using
> vcpu->arch.cr2 to update vmcb12 is the right thing to do.
> 
> The #PF injection case is more nuanced. It occurs if KVM injects a #PF
> into L2, then exits to L1 before it actually runs L2. Although the APM
> is a bit unclear about when CR2 is written during a #PF, the SDM is more
> clear:
> 
> 	Processors update CR2 whenever a page fault is detected. If a
> 	second page fault occurs while an earlier page fault is being
> 	delivered, the faulting linear address of the second fault will
> 	overwrite the contents of CR2 (replacing the previous address).
> 	These updates to CR2 occur even if the page fault results in a
> 	double fault or occurs during the delivery of a double fault.
> 
> KVM injecting the exception surely counts as the #PF being "detected".

Heh, "detected" is definitely poor wording in the SDM.

> More importantly, when an exception is injected into L2 at the time of a
> synthesized #VMEXIT, KVM updates exit_int_info in vmcb12 accordingly,
> such that an L1 hypervisor can re-inject the exception. If CR2 is not
> written at that point, the L1 hypervisor have no way of correctly
> re-injecting the #PF. Hence, using vcpu->arch.cr2 is also the right
> thing to write in vmcb12 in this case.
> 
> Note that KVM does _not_ update vcpu->arch.cr2 when a #PF is pending for
> L2, only when it is injected. The distinction is important, because only
> injected exceptions are propagated to L1 through exit_int_info. It would
> be incorrect to update CR2 in vmcb12 for a pending #PF, as L1 would
> perceive an updated CR2 value with no #PF. Update the comment in
> kvm_deliver_exception_payload() to clarify this.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c | 2 +-
>  arch/x86/kvm/x86.c        | 7 +++++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index de90b104a0dd5..9031746ce2db1 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -1156,7 +1156,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  	vmcb12->save.efer   = svm->vcpu.arch.efer;
>  	vmcb12->save.cr0    = kvm_read_cr0(vcpu);
>  	vmcb12->save.cr3    = kvm_read_cr3(vcpu);
> -	vmcb12->save.cr2    = vmcb02->save.cr2;
> +	vmcb12->save.cr2    = vcpu->arch.cr2;
>  	vmcb12->save.cr4    = svm->vcpu.arch.cr4;
>  	vmcb12->save.rflags = kvm_get_rflags(vcpu);
>  	vmcb12->save.rip    = kvm_rip_read(vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index db3f393192d94..1015522d0fbd7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -864,6 +864,13 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu, unsigned int nr,
>  		vcpu->arch.exception.error_code = error_code;
>  		vcpu->arch.exception.has_payload = has_payload;
>  		vcpu->arch.exception.payload = payload;
> +		/*
> +		 * Only injected exceptions are propagated to L1 in
> +		 * vmcb12/vmcs12 on nested #VMEXIT. Hence, do not deliver the

Nit, #VMEXIT is SVM specific terminology.  VM-Exit is more vendor agnostic.

> +		 * exception payload for L2 until the exception is injected.
> +		 * Otherwise, L1 would perceive the updated payload without a
> +		 * corresponding exception.

Huh.  I'm fairly certain this code is now at best unnecessary, and at worst
actively harmful.  Because the more architectural way to document this code is:

		/*
		 * If L2 is active, defer delivery of the payload until the
		 * exception is actually injected to avoid clobbering state if
		 * L1 wants to intercept the exception (the architectural state
		 * is NOT updated if the exeption is morphed to a VM-Exit).
		 */

But thanks to commit 7709aba8f716 ("KVM: x86: Morph pending exceptions to pending
VM-Exits at queue time"), KVM already *knows* the exception won't be morphed to a
VM-Exit.

Ugh, and I'm pretty sure I botched kvm_vcpu_ioctl_x86_get_vcpu_events() in that
commit.  Because invoking kvm_deliver_exception_payload() when the exception was
morphed to a VM-Exit is wrong.  Oh, wait, this is the !exception_payload_enabled
case.  So never mind, that's simply an unfixable bug, as the second comment alludes
to.

	/*
	 * KVM's ABI only allows for one exception to be migrated.  Luckily,
	 * the only time there can be two queued exceptions is if there's a
	 * non-exiting _injected_ exception, and a pending exiting exception.
	 * In that case, ignore the VM-Exiting exception as it's an extension
	 * of the injected exception.
	 */
	if (vcpu->arch.exception_vmexit.pending &&
	    !vcpu->arch.exception.pending &&
	    !vcpu->arch.exception.injected)
		ex = &vcpu->arch.exception_vmexit;
	else
		ex = &vcpu->arch.exception;

	/*
	 * In guest mode, payload delivery should be deferred if the exception
	 * will be intercepted by L1, e.g. KVM should not modifying CR2 if L1
	 * intercepts #PF, ditto for DR6 and #DBs.  If the per-VM capability,
	 * KVM_CAP_EXCEPTION_PAYLOAD, is not set, userspace may or may not
	 * propagate the payload and so it cannot be safely deferred.  Deliver
	 * the payload if the capability hasn't been requested.
	 */
	if (!vcpu->kvm->arch.exception_payload_enabled &&
	    ex->pending && ex->has_payload)
		kvm_deliver_exception_payload(vcpu, ex);

So yeah, I _think_ we could drop the is_guest_mode() check.  However, even better
would be to drop this call *entirely*, i.e.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b0112c515584..00a39c95631d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -864,9 +864,6 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu, unsigned int nr,
                vcpu->arch.exception.error_code = error_code;
                vcpu->arch.exception.has_payload = has_payload;
                vcpu->arch.exception.payload = payload;
-               if (!is_guest_mode(vcpu))
-                       kvm_deliver_exception_payload(vcpu,
-                                                     &vcpu->arch.exception);
                return;
        }
 
Because KVM really shouldn't update CR2 until the excpetion is actually injected
(or the state is at risk of being lost because exception_payload_enabled==false).
E.g. in the (extremely) unlikely (and probably impossible to configure reliably)
scenario that userspace deliberately drops a pending exception, arch state shouldn't
be updated.

> +		 */
>  		if (!is_guest_mode(vcpu))
>  			kvm_deliver_exception_payload(vcpu,
>  						      &vcpu->arch.exception);
> -- 
> 2.53.0.rc2.204.g2597b5adb4-goog
> 

