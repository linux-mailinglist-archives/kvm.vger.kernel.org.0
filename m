Return-Path: <kvm+bounces-10833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 00088870C0C
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 22:04:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B02392831F8
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 21:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C425B10A39;
	Mon,  4 Mar 2024 21:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eYfAnp3q"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F3910A19
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 21:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709586251; cv=none; b=MjDyMjPkAkJRO4HFBFyl2dkU9+RunmoUfnxvN3VEdJyvcaYInFR/MzKeeftH0cg6NNBSoNpq0PDsHt7TIzYepc0dGT/m+8djAFMx741X2PF8vv0u21FY3z97EcBzYhA+7/TSuCGR2kpjBkYp11t/yMhj7gxj9RYHzO+ux0K1VGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709586251; c=relaxed/simple;
	bh=K+toXZHX4cnJrPAxGF67sGLw5frr8g8z2TiRwlyTWyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gxa2t3EWsUUooPOstO1LZPbxc10yggLqqtvrkB/U/3ySRfctCIVvzRg/UXNwpHXE9mKnaQGcgLOnmbARa4ieZLGQcYFRqQ+RDoHHuElu3plBGlef6b9Dtxdogs9L/fOYV6pJGkfaffOSUZIfuxROzk5J9gKNCVtVNR1N/pVTZAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eYfAnp3q; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 4 Mar 2024 21:03:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709586246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ivj8DkeOZEVfgDsGUlJ/GV9AX+PFkQKKCSbdebARHMc=;
	b=eYfAnp3qUekGRGKs9wkqsV1MWWXxJnyI5IvmrOvgoByo0O5zMv6OmnTMwR+welZMMJvcvF
	O10P90Msc2qT6tIhGqamfdHI0+3+dzo6cm0RRm+DujlYXUGZ7jjrwTkRg0sUAwWzq7y5/h
	RFIknAFywCleCU7K48cnIOYjN7JfX+w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Anish Moorthy <amoorthy@google.com>, maz@kernel.org,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	robert.hoo.linux@gmail.com, jthoughton@google.com,
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com,
	nadav.amit@gmail.com, isaku.yamahata@gmail.com,
	kconsul@linux.vnet.ibm.com
Subject: Re: [PATCH v7 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO
 and annotate fault in the stage-2 fault handler
Message-ID: <ZeY3P8Za5Q6pkkQV@linux.dev>
References: <20240215235405.368539-1-amoorthy@google.com>
 <20240215235405.368539-9-amoorthy@google.com>
 <ZeYoSSYtDxKma-gg@linux.dev>
 <ZeYqt86yVmCu5lKP@linux.dev>
 <ZeYv86atkVpVMa2S@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZeYv86atkVpVMa2S@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 04, 2024 at 12:32:51PM -0800, Sean Christopherson wrote:
> On Mon, Mar 04, 2024, Oliver Upton wrote:
> > On Mon, Mar 04, 2024 at 08:00:15PM +0000, Oliver Upton wrote:

[...]

> > Duh, kvm_vcpu_trap_is_exec_fault() (not to be confused with
> > kvm_vcpu_trap_is_iabt()) filters for S1PTW, so this *should*
> > shake out as a write fault on the stage-1 descriptor.
> > 
> > With that said, an architecture-neutral UAPI may not be able to capture
> > the nuance of a fault. This UAPI will become much more load-bearing in
> > the future, and the loss of granularity could become an issue.
> 
> What is the possible fallout from loss of granularity/nuance?  E.g. if the worst
> case scenario is that KVM may exit to userspace multiple times in order to resolve
> the problem, IMO that's an acceptable cost for having "dumb", common uAPI.
> 
> The intent/contract of the exit to userspace isn't for userspace to be able to
> completely understand what fault occurred, but rather for KVM to communicate what
> action userspace needs to take in order for KVM to make forward progress.

For one, the stage-2 page tables can describe permissions beyond RWX.
MTE tag allocation can be controlled at stage-2, which (confusingly)
desribes if the guest can insert tags in an opaque, physical space not
described by HPFAR.

There is a corresponding bit in ESR_EL2 that describes this at the time
of a fault, and R/W/X flags aren't enough to convey the right corrective
action.

> > Marc had some ideas about forwarding the register state to userspace
> > directly, which should be the right level of information for _any_ fault
> > taken to userspace.
> 
> I don't know enough about ARM to weigh in on that side of things, but for x86
> this definitely doesn't hold true.

We tend to directly model the CPU architecture wherever possible, as it
is the only way to create something intelligible. That same rationale
applies to a huge portion of KVM UAPI; it is architecture-dependent by
design.

> E.g. on the x86 side, KVM intentionally sets
> reserved bits in SPTEs for "caching" emulated MMIO accesses, and the resulting
> fault captures the "reserved bits set" information in register state.  But that's
> purely an (optional) imlementation detail of KVM that should never be exposed to
> userspace.

MMIO accesses would show up elsewhere though, right? If these magic
SPTEs were causing -EFAULT exits then something must've gone sideways.

Either way, I have no issues whatsoever if the direction for x86 is to
provide abstracted fault information.

-- 
Thanks,
Oliver

