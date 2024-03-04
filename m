Return-Path: <kvm+bounces-10823-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A454C870B17
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 21:00:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 454011F239E6
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 20:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF8EB7A14D;
	Mon,  4 Mar 2024 20:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xCtRhKDX"
X-Original-To: kvm@vger.kernel.org
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952567995F
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 20:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709582419; cv=none; b=ZO8QaN+JXBm/EZ4q8gM0zkOHGP0ZuBCSmIy/seb8Ua4Sr4MYi6++F2J4xa4UYCI21Jx0/I/Oz7DUxkSEu6laVHffy4pTMnHJrwURkhAPnnp5L2LUA1hjIKen+DhrPDrWUkzvBHeLXKMagQkVKQvSox6GBQWMAaNb+6Q4j/qv2p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709582419; c=relaxed/simple;
	bh=PwswC2QLgrfGkqvGJv5hVy5xAgaXNLvrQ1PnKfrapGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OlWXz0QHX5GHy/Gy8yDzFJcmjPEw6IQIgFw1GM3Kwg5kVvUZjklTYcKa9GyDbDtY3yZy4nYBhTL0Ai1GLKgSTYA1wOaP7uHtCwOz3p/uKDpqQU0oiYxLtlTmesEL8E5U0+Tp7iV5/ccQVyKoQGs7kMHsuT28BzwPQ/GQGwNAm4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xCtRhKDX; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 4 Mar 2024 20:00:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709582415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XxJdQM9M8oSJx2poffbncc5kqBv+MVDtqlApqur8M/Q=;
	b=xCtRhKDXkGmhyRTyD7OJzgZUEK3tlqvB6S5yysaKAkG8DWMPf2NiHcf1f4oLoQinspRh0d
	hEuhzXeXZBnkGIBAag+W0QAyxwW2AvlMdB7Y1QunewULzkMjxHPh0Ebbbvz6qnc8tKpdZd
	hbixfhz+jID8YGZM8gWc05QrPcOlw/I=
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
Message-ID: <ZeYoSSYtDxKma-gg@linux.dev>
References: <20240215235405.368539-1-amoorthy@google.com>
 <20240215235405.368539-9-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240215235405.368539-9-amoorthy@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 15, 2024 at 11:53:59PM +0000, Anish Moorthy wrote:

[...]

> +	if (is_error_noslot_pfn(pfn)) {
> +		kvm_prepare_memory_fault_exit(vcpu, gfn * PAGE_SIZE, PAGE_SIZE,
> +					      write_fault, exec_fault, false);

Hmm... Reinterpreting the fault context into something that wants to be
arch-neutral might make this a bit difficult for userspace to
understand.

The CPU can take an instruction abort on an S1PTW due to missing write
permissions, i.e. hardware cannot write to the stage-1 descriptor for an
AF or DBM update. In this case HPFAR points to the IPA of the stage-1
descriptor that took the fault, not the target page.

It would seem this gets expressed to userspace as an intent to write and
execute on the stage-1 page tables, no?

-- 
Thanks,
Oliver

