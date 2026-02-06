Return-Path: <kvm+bounces-70453-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GCqMGJsLhmkRJQQAu9opvQ
	(envelope-from <kvm+bounces-70453-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 16:41:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BB345FFD6A
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 16:41:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3D5AE302978B
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 15:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C65462C0299;
	Fri,  6 Feb 2026 15:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vH7KGJ5V"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AE229D26C
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 15:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770392467; cv=none; b=q8ldxR9l0vGmOP1SO7RS8gu0caUtgZHCYZlG3YNtS6fWeo/4/+6a96dne+FgqcmK5Qyy9fkux6zzCp3VfIikYiEPS2nUzNX8XcmnyMHBcwXqw12zkR8fjjx/oyWE43BQQALF6iK1wIK2wvWOFfhf5FgfX5UPcOFYPdnx6TxL9f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770392467; c=relaxed/simple;
	bh=WbPM+BC0Czo3P2SEQ/68Xv5ugy91btKEIZ2DWWGSzl0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fq2xAaASBdm9bo3StVEekgXylQcvqaSBmDpHkPwGrEjWIxs58w3fTx90uhfBO0gqKTglor+d30MvXjvlvblUjFf5lOHLDuiMA1kBpjGOnjZU2ZGJyAtX4lAueh00ir0idjz/UOyxVmnu9MmlW5gG5pLhUns8fHHxXsrkgn8v7ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vH7KGJ5V; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 6 Feb 2026 15:40:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770392465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sWBkBgFv3nWQCFqC+S6d9enV+5ZhO9+mFYzbbrKChOI=;
	b=vH7KGJ5VPkX5TSEQPvnqUqg8HTGA+jCIMHCRWXPwfVk7moTQJTdkY2/TM0u7GHUoMIjqL4
	uBagej2YmCoWQDu67xuaPMSBFDtSPdsIWMTmoNGB7f/AJKFvHDQRDrFjQKLhalNqZxTnRt
	UpI6L32GJKRXvLcnWOdNh6YBdlmZ/hA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4 13/26] KVM: nSVM: Unify handling of VMRUN failures
 with proper cleanup
Message-ID: <rp3tkueohngrri3fjyibmnzjzfqpyxv73j7i6hvdtrnobuetfd@xilmrwwre6bd>
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
 <20260115011312.3675857-14-yosry.ahmed@linux.dev>
 <aYU6P2qNEpRVWllL@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYU6P2qNEpRVWllL@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70453-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-0.996];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linux.dev:dkim]
X-Rspamd-Queue-Id: BB345FFD6A
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 04:47:59PM -0800, Sean Christopherson wrote:
> On Thu, Jan 15, 2026, Yosry Ahmed wrote:
> > @@ -983,6 +991,8 @@ static void __nested_svm_vmexit(struct vcpu_svm *svm)
> >  	struct vmcb *vmcb01 = svm->vmcb01.ptr;
> >  	struct kvm_vcpu *vcpu = &svm->vcpu;
> >  
> > +	WARN_ON_ONCE(is_guest_mode(vcpu));
> > +
> >  	svm->nested.vmcb12_gpa = 0;
> >  	svm->nested.ctl.nested_cr3 = 0;
> >  
> > @@ -1006,6 +1016,19 @@ static void __nested_svm_vmexit(struct vcpu_svm *svm)
> >  		kvm_queue_exception(vcpu, DB_VECTOR);
> >  }
> >  
> > +static void nested_svm_failed_vmrun(struct vcpu_svm *svm, struct vmcb *vmcb12)
> 
> I don't love the name.  "fail" has very specific meaning in VMX for VMLAUNCH and
> VMRESUME, as VM-Fail is not a VM-Exit, e.g. doesn't load host state from the VMCS.
> 
> I also don't love that the name doesn't capture that this is synthesizing a #VMEXIT.
> Maybe nested_svm_vmrun_error_vmexit()?  I suppose nested_svm_failed_vmrun_vmexit()
> isn't too bad either, as that at least addresses my concerns about conflating it
> with VMX's VM-Fail.

Good point, I think nested_svm_vmrun_error_vmexit() is fine.

> 
> > +{
> > +	WARN_ON(svm->vmcb == svm->nested.vmcb02.ptr);
> 
> WARN_ON_ONCE()
> 
> > +
> > +	leave_guest_mode(vcpu);
> 
> Someone didn't test each patch.  "vcpu" doesn't exist until

I plead the 5th.

> "KVM: nSVM: Restrict mapping VMCB12 on nested VMRUN".  Just pass in @vcpu and
> @vmcb12, i.e. don't pass @svm and then pull @vcpu back out.
> 
> > +	vmcb12->control.exit_code = SVM_EXIT_ERR;
> > +	vmcb12->control.exit_code_hi = -1u;
> > +	vmcb12->control.exit_info_1 = 0;
> > +	vmcb12->control.exit_info_2 = 0;
> > +	__nested_svm_vmexit(svm);
> > +}
> 
> ...
> 
> > @@ -1224,6 +1232,8 @@ void nested_svm_vmexit(struct vcpu_svm *svm)
> >  	if (guest_cpu_cap_has(vcpu, X86_FEATURE_ERAPS))
> >  		vmcb01->control.erap_ctl |= ERAP_CONTROL_CLEAR_RAP;
> >  
> > +	/* VMRUN failures before switching to VMCB02 are handled by nested_svm_failed_vmrun() */
> 
> Please don't add comments that just point elsewhere.  They inevitably become
> stale, and they don't help the reader understand "why" any of this matters.
> 
> E.g. something like
> 
> 	/*
> 	 * This helper is intended for use only when KVM synthesizing a #VMEXIT
> 	 * after a successful nested VMRUN.  All VMRUN consistency checks must
> 	 * be performed before loading guest state, and so should use the inner
> 	 * helper.
> 	 */ 

Will use that, but I will replace "this helper" and "inner helper" with
nested_svm_vmexit() and __nested_svm_vmexit().

