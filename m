Return-Path: <kvm+bounces-40133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E14EFA4F72B
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 07:34:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F0593AACF2
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 06:34:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D110C1DD866;
	Wed,  5 Mar 2025 06:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jFgBxBAT"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E651C8623
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 06:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741156464; cv=none; b=mxUVvosmIEuZimZpuZgbjV65bztU2juRzttGqFQFO9elxqOWULhLsMGzT6H/mYFf/fdK+/RLkjjouSzelLDr1EE6rIuwUyqE4sR8CccGC2RVpvCjGyXcl8vciElAlaCgnxVc382bxIxKxvsR66HMyvZHzUQ6FRVwRb4GcX+e/PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741156464; c=relaxed/simple;
	bh=gUcz5o6Xl3YF+cMmSziTYIl62yrmSgkxKXcYWPUjnKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aWQtomOawADm0oMuknK2/MnDbwSYTd3370m6bjiiOZtULEAI7b3e0uPxVQpl4a6qL6Y9HPif3TKFQ7g4dNjh1/LoBLyjh/BX/t6L2/C81IJgN8yLdI9hYGs2SQCG4157NnZmrUHU7L3xocDlf5N7yclXvEspsVaeyeId5tYbUlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jFgBxBAT; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 5 Mar 2025 06:34:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741156460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G9TYM+zw4VtWnAhmw1afqUYX/q9dbL9GufqEtL6o0jo=;
	b=jFgBxBATyUdIImrdzrARPOh5gy15YNF77E8spfsRRMjbWp6uXvM0URKDRlztlAxOMhj/cs
	W045MeEhhtTmNy3Q+jUw3BsVjZV9196JWERW+ZPh9raJPIM8YFnBmPOqD3zRcQqE6svWD1
	o6+lnkmjK0lUtb6HZUEs/4YqUvm0Rbg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 11/13] KVM: nSVM: Do not reset TLB_CONTROL in VMCB02
 on nested entry
Message-ID: <Z8fwZ-94duaK4c2p@google.com>
References: <20250205182402.2147495-1-yosry.ahmed@linux.dev>
 <20250205182402.2147495-12-yosry.ahmed@linux.dev>
 <a70458e20e98da9cd6dd1d272cc16b71bfdd4842.camel@redhat.com>
 <Z8YpxLONlmy91Eot@google.com>
 <6345e31c7973a2ec32b11ed54cede142a901044e.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6345e31c7973a2ec32b11ed54cede142a901044e.camel@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 04, 2025 at 10:01:25PM -0500, Maxim Levitsky wrote:
> On Mon, 2025-03-03 at 22:14 +0000, Yosry Ahmed wrote:
> > On Fri, Feb 28, 2025 at 09:17:52PM -0500, Maxim Levitsky wrote:
> > > On Wed, 2025-02-05 at 18:24 +0000, Yosry Ahmed wrote:
> > > > TLB_CONTROL is reset to TLB_CONTROL_DO_NOTHING on nested transitions to
> > > > L2. This is unnecessary because it should always be
> > > > TLB_CONTROL_DO_NOTHING at this point.
> > > > 
> > > > The flow for setting TLB_CONTROL is as follows:
> > > > 1. In vcpu_enter_guest(), servicing a TLB flush request may set it to
> > > > TLB_CONTROL_FLUSH_ASID in svm_flush_tlb_asid().
> > > > 2. In svm_vcpu_run() -> pre_svm_run(), it may get upgraded to
> > > > TLB_CONTROL_FLUSH_ALL_ASID when assigning a new ASID.
> > > > 3. In svm_cpu_run(), it gets reset to TLB_CONTROL_DO_NOTHING after the
> > > > guest is run.
> > > > 
> > > > Hence, TLB_CONTROL is reset after each run and there is no need to do it
> > > > again on every nested transition to L2.
> > > > 
> > > > There is a TODO in nested_svm_transition_tlb_flush() about this reset
> > > > crushing pending TLB flushes. Remove it, as the reset is not really
> > > > crushing anything as explained above.
> > > 
> > > I am not sure that we don't crush a pending tlb request: 
> > > 
> > > svm_flush_tlb_asid can also be called by KVM_REQ_TLB_FLUSH
> > > and set the flush request in both vmcbs, thus later the nested_svm_exit_tlb_flush
> > > can crush this request.
> > 
> > How so?
> > 
> > nested_svm_exit_tlb_flush() makes a KVM_REQ_TLB_FLUSH_GUEST request.
> > svm_flush_tlb_asid() is called when servicing KVM_REQ_TLB_* requests.
> 
> I am probably missing something but:
> 
> Suppose KVM_REQ_TLB_FLUSH is raised and then processed while ordinary L1 entry is happening,
> but nested state is allocated.
> 
> (KVM_REQ_TLB_FLUSH can be raised anytime MMU wants a 'big hammer flush everything')
> 
> In this case svm_flush_tlb_all will call svm_flush_tlb_asid on both vmcbs (see patch 8),
> and that will set TLB_CONTROL_FLUSH_ASID in both vmcbs.
> In particular it will be set in vmcb02.
> 
> Later, maybe even hours later in theory, L1 issues VMRUN, we reach nested_vmcb02_prepare_control,
> and crush the value (TLB_CONTROL_FLUSH_ASID) set in vmcb02.
> 
> I think that this is what the removed comment referred to.

When KVM_REQ_TLB_FLUSH is raised, we do not call svm_flush_tlb_all()
immediately. We only call svm_flush_tlb_all() when the request is
serviced in vcpu_enter_guest():

	/*
	 * Note, the order matters here, as flushing "all" TLB entries
	 * also flushes the "current" TLB entries, i.e. servicing the
	 * flush "all" will clear any request to flush "current".
	 */
	if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu))
		kvm_vcpu_flush_tlb_all(vcpu);

	kvm_service_local_tlb_flush_requests(vcpu);

IIUC, vcpu_enter_guest() will be called for L2 after
nested_vmcb02_prepare_control() is called. My understanding is that the
sequence of events is as follows:
- L1 executes VMRUN, which is trapped and emulated by L0.

- KVM executes handles the VM-exit in L0 by calling
  vmrun_interception() to setup VMCB02 in prepartion for running L2.
  This will call nested_svm_vmrun() -> enter_svm_guest_mode() ->
  nested_vmcb02_prepare_control() (setting tlb_ctl to
  TLB_CONTROL_DO_NOTHING).

- Execution will pick up after the VMRUN instruction in L0, eventually
  getting to the loop in vcpu_run(), and calling vcpu_enter_guest()
  for L2. At this point any pending TLB flush requests (e.g.
  KVM_REQ_TLB_FLUSH) will be handled, and svm_flush_tlb_*() functions
  may be called to set tlb_ctl to a non-zero value (e.g.
  TLB_CONTROL_FLUSH_ASID).

- A little bit later in svm_vcpu_run() -> pre_svm_run(), tlb_ctl may be
  upgraded to TLB_CONTROL_FLUSH_ALL_ASID if a new ASID is allocated.
 
- After the guest is run, svm_cpu_run() resets tlb_ctl to TLB_CONTROL_DO_NOTHING.

So nested_vmcb02_prepare_control() setting tlb_ctl to
TLB_CONTROL_DO_NOTHING should have no effect because tlb_ctl is set
after that anyway before L2 is run, and reset back to
TLB_CONTROL_DO_NOTHING after L2 is run.

I tried to clarify this in the commit log, but I don't think it is clear
enough. I will try to add more details in the next version.

Please correct me if I am wrong.

