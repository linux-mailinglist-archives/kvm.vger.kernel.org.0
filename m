Return-Path: <kvm+bounces-67192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 79817CFB6A3
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 01:05:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8E9FF303A008
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 00:05:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBD242A1BF;
	Wed,  7 Jan 2026 00:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KjxoEpH6"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B1B800
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 00:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767744314; cv=none; b=SJrekqiqZL+qx9R63waDqofBwdsrZHMCv7NbANM43etdR5G0ZY3TyaFweSIuuhEDhQaAGHtMkylNNm/rabnhl7pgkUqgiKnkN5+6X/9dhpdryHlxHRrZxNCIYtSYaRt3S4CClBAsxjfKKa9+JRNEwNSsoQwtTeKcbntl1lSKr0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767744314; c=relaxed/simple;
	bh=pQibhUCBcK8qg9sF0XPRN2O0VnT354q4M18nAAQC6iE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a/ykvb7gckuQXHXN2dZIIhyT3cgeyP4zghbRVS0lvfBMgkwu7RPQMyQUOSdpCPl2zeaMPet+S7aCUlWJSmMW2s23sYK5qLY+nlIXJ8rIqKlxog4HgzvkAG3tbRkMJ66mCpFIwwgxZ6pXfII9Hv/dGIRpTLRfc05xq/hEPBsEcwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KjxoEpH6; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 7 Jan 2026 00:04:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767744297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JQijrdS0w2dE3uQhhfizvvkC97S/i7UwHLjeXjKpBME=;
	b=KjxoEpH6VUG6ME1i7qEekfW3BTybECcMiuXDA7kf3fBQI9TmU60IJneq20xpNVkc9lylWO
	FWfVm3o2v6rS/MZACdL2+XgNhhEUYgGmGlPFdA+sEeVjbTkdUM6ny1T+TDWgQjm8iG0LwS
	pMZKex/dEy06AQoVayZLfFgjPGVBwYI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Kevin Cheng <chengkev@google.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: SVM: Generate #UD for certain instructions when
 SVME.EFER is disabled
Message-ID: <vfzsx35yfz2rlyx2bc4fxwnrcyvshagf3lgzhef4pqrahpyigp@356wdo7gmbfw>
References: <20260106041250.2125920-1-chengkev@google.com>
 <20260106041250.2125920-2-chengkev@google.com>
 <aV1StCzKWxAQ-B93@google.com>
 <5uwzlb3jvmebvienef5tw7cd6r4wgvtb5m5gu3wcaxh5sery3o@crh6m6cpuaqy>
 <aV2fVaLBrtUsccHJ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV2fVaLBrtUsccHJ@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Jan 06, 2026 at 03:48:37PM -0800, Sean Christopherson wrote:
> On Tue, Jan 06, 2026, Yosry Ahmed wrote:
> > On Tue, Jan 06, 2026 at 10:21:40AM -0800, Sean Christopherson wrote:
> > > So rather than manually handle the intercepts in svm_set_efer() and fight recalcs,
> > > trigger KVM_REQ_RECALC_INTERCEPTS and teach svm_recalc_instruction_intercepts()
> > > about EFER.SVME handling.
> > > 
> > > After the dust settles, it might make sense to move the #GP intercept logic into
> > > svm_recalc_intercepts() as well, but that's not a priority.
> > 
> > Unrelated question about the #GP intercept logic, it seems like if
> > enable_vmware_backdoor is set, the #GP intercept will be set, even for
> > SEV guests, which goes against the in svm_set_efer():
> > 
> > 	/*
> > 	 * Never intercept #GP for SEV guests, KVM can't
> > 	 * decrypt guest memory to workaround the erratum.
> > 	 */
> > 	if (svm_gp_erratum_intercept && !sev_guest(vcpu->kvm))
> > 		set_exception_intercept(svm, GP_VECTOR);
> > 
> > I initially thought if userspace sets enable_vmware_backdoor and runs
> > SEV guests it's shooting itself in the foot, but given that
> > enable_vmware_backdoor is a module parameter (i.e. global), isn't it
> > possible that the host runs some SEV and some non-SEV VMs, where the
> > non-SEV VMs require the vmware backdoor?
> 
> Commit 29de732cc95c ("KVM: SEV: Move SEV's GP_VECTOR intercept setup to SEV")
> moved the override to sev_init_vmcb():
> 
> 	/*
> 	 * Don't intercept #GP for SEV guests, e.g. for the VMware backdoor, as
> 	 * KVM can't decrypt guest memory to decode the faulting instruction.
> 	 */
> 	clr_exception_intercept(svm, GP_VECTOR);
> 
> I.e. init_vmcb() will set the #GP intercept, then sev_init_vmcb() will immediately
> clear it.

That's not confusing at all :P

