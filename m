Return-Path: <kvm+bounces-63179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 15D17C5B68C
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 06:47:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 53ECF34DAC9
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 05:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA64627F005;
	Fri, 14 Nov 2025 05:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lOUwraf7"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515B7946C
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 05:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763099215; cv=none; b=Q8RCdvM7V0MJsu3DIQWIJ2hw4avvfmDula+XmkSYYttAF9UnULacFxm3YA6M7qoQnBCczgk5nmLeqCJitpOpnPjocA2k9hPhCNoK8Q2eJy09RQooyzhcEWDs01wcnZM58D2nHLCjC0JDmGBCFGAsmZdPmQdQJw++mxHOhGpBjaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763099215; c=relaxed/simple;
	bh=vm7AmlGsOJ7d/tMF3LpWFf98urOUFz13N8HMTQ7FSqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kPL4Agk9L8aYb4vlZ0FvC946BB3vMqgJ0m1+mZMngw7TglUe/0KeCoQWVS2WExYrwN6dNshgzPMyitg4n7SOvm09/J1DF4AsDQemhAmiDmDfhWiQWoohCZTzurWYee9N3p1nhB5ExJEV95v9FJPY5wEKYlEHkqzN56V+3Ljrnyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lOUwraf7; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 14 Nov 2025 05:46:37 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763099201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vF7d+45mwikMfP1PmDvHVD2soM4BMtXRWSBT54xa91c=;
	b=lOUwraf7SxR7x2gOSjygyQxtOHuVP4hr2u1NdEMef4Hl2JeY7URrCrLH36i+ka3677tcng
	bLzykClNljk5QB/ckV1c/Z/uNaBzWbEUK02I6OGCcIWsG0N3vuU1YAuCOnAWiziusSn49F
	e2rPjS2f022iO+x375KZNrVnN8FodFQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kevin Cheng <chengkev@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 09/14] x86/svm: Deflake svm_tsc_scale_test
Message-ID: <fqzv25ycu2tpvg7ljfsl7mzqulu7qkjc2vqjdh6hxhyn4svrd5@46fo2mlsysyx>
References: <20251110232642.633672-1-yosry.ahmed@linux.dev>
 <20251110232642.633672-10-yosry.ahmed@linux.dev>
 <aRZ5G6GSMnbHxx_K@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRZ5G6GSMnbHxx_K@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 13, 2025 at 04:34:35PM -0800, Sean Christopherson wrote:
> On Mon, Nov 10, 2025, Yosry Ahmed wrote:
> > On an AMT Turin (EPYC Zen 5), svm_tsc_scale_test flakes on the last test
> > case with 0.0001 TSC scaling ratio, even with the 24-bit shift for
> > stability. On failure, the actual value is 49 instead of the expected
> > 50.
> > 
> > Use a higher scaling ratio, 0.001, which makes the test pass
> > consistently.
> 
> Top-tier analysis right here :-D

Not my proudest moment :P

I saw the test is already using some arbitrary numbers and I was too
lazy to do what Jim did. I initially had a patch that allows for a
certain % error instead, like the selftest, but I opted for the simple
change :P

In my defense, I did call it not-so-sophisticated in the cover letter!

> 
> I'm going to take Jim's version instead of papering over the bug.
> 
> https://lore.kernel.org/all/CALMp9eQep3H-OtqmLe3O2MsOT-Vx4y0-LordKgN+pkp04VLSWw@mail.gmail.com

I am actually glad there's a better patch than mine :)

