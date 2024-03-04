Return-Path: <kvm+bounces-10825-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 09ECE870B38
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 21:11:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F9041F2164A
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 20:11:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BECC7A73C;
	Mon,  4 Mar 2024 20:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g5Ea6CWf"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82117A12E
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 20:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709583040; cv=none; b=PdrlyeAHE5X6DrRJMg67icrrq54WTzr0M/VeQ/Ev/VrEw9MzzXjaViwueETlGhwrGekx4w6WvxypAnMfFPQghNCPOnXWiBJLiYmzFegNIlN34xIdEQpvruIwFBajN3QVC3gsvn8Xw5vXJ7Afawq5wSSc1x4JFUoD0SjcjPq4SJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709583040; c=relaxed/simple;
	bh=CiWclHM92CxPgn9s8RDVTkFk5yMmG0gjX7Az/URkYxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QrMYgeFSHCLuHkuKcmZMDOiVX7rUlku+aSSQat6fKz3LEgC22SH2M5H04aXRpfj+m+uUydGQ019wPBeZpyJni6CKT/gjf7lV7QPMt1FIQD8u8PJkTUq3tgA94uhAKdRTXswwWvptWXnI7Hdwawdan/HPqCMFI+RRxRQ46EVfQHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=g5Ea6CWf; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 4 Mar 2024 20:10:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709583037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8c/7pMLh+RQyjtRpA/nPZD6CNVBcAA8WYXxa3p6I4O8=;
	b=g5Ea6CWfdTANFc8SPnRnu872E2/sniqlKhhEx8TEiRQVu3vs2xSZ8o/5+6Cqm0dDTk9Pbo
	BjwFZE9X4g448f+0+hWZ8+UAQhsQCyH0NDrYwhoW8uwRjeNWqqSTbT65mQVZnukjHKWqNd
	d06kZFYmFiqzirM/LZtcD5jVYOH58zE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Anish Moorthy <amoorthy@google.com>
Cc: seanjc@google.com, maz@kernel.org, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, robert.hoo.linux@gmail.com,
	jthoughton@google.com, dmatlack@google.com,
	axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
	isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Subject: Re: [PATCH v7 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO
 and annotate fault in the stage-2 fault handler
Message-ID: <ZeYqt86yVmCu5lKP@linux.dev>
References: <20240215235405.368539-1-amoorthy@google.com>
 <20240215235405.368539-9-amoorthy@google.com>
 <ZeYoSSYtDxKma-gg@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZeYoSSYtDxKma-gg@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 04, 2024 at 08:00:15PM +0000, Oliver Upton wrote:
> On Thu, Feb 15, 2024 at 11:53:59PM +0000, Anish Moorthy wrote:
> 
> [...]
> 
> > +	if (is_error_noslot_pfn(pfn)) {
> > +		kvm_prepare_memory_fault_exit(vcpu, gfn * PAGE_SIZE, PAGE_SIZE,
> > +					      write_fault, exec_fault, false);
> 
> Hmm... Reinterpreting the fault context into something that wants to be
> arch-neutral might make this a bit difficult for userspace to
> understand.
> 
> The CPU can take an instruction abort on an S1PTW due to missing write
> permissions, i.e. hardware cannot write to the stage-1 descriptor for an
> AF or DBM update. In this case HPFAR points to the IPA of the stage-1
> descriptor that took the fault, not the target page.
> 
> It would seem this gets expressed to userspace as an intent to write and
> execute on the stage-1 page tables, no?

Duh, kvm_vcpu_trap_is_exec_fault() (not to be confused with
kvm_vcpu_trap_is_iabt()) filters for S1PTW, so this *should*
shake out as a write fault on the stage-1 descriptor.

With that said, an architecture-neutral UAPI may not be able to capture
the nuance of a fault. This UAPI will become much more load-bearing in
the future, and the loss of granularity could become an issue.

Marc had some ideas about forwarding the register state to userspace
directly, which should be the right level of information for _any_ fault
taken to userspace.

-- 
Thanks,
Oliver

