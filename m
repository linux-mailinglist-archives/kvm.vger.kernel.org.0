Return-Path: <kvm+bounces-8822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF8C5856E60
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 21:13:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E2A62881C2
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 20:13:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59FD613AA41;
	Thu, 15 Feb 2024 20:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="l0gOqppm"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F5441A81
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 20:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708027989; cv=none; b=vFbtEP4RqIsZTzpotBbfdzeSmc4gjvcrQVcPfQxfuCICoD9H4Uy/AvMY9/DLHygiQIB0LlcUy2tqPzAkfTMnydQlYj7Ij/5vXMxladH4hcZZ2bw0Ve3xiJN4zsfIqvRpBTQVYF8pEMeDiuOdqjSmvhW8fzCaefGjnldKs6Tp55Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708027989; c=relaxed/simple;
	bh=qOqvElTaarBcrxNDQK0w6KO5cXuq7tPFNungF5/n584=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GvCoBBBOk842rW6CwigIlxnzwZM6iiwE2NF6DRahPwOCUBUdw1TOfpCrrwoI0g6t3RrREvJCGyBrsNPz5+/XU7ztX7JSCxWh3u00YWFBFstYre+6mCyfMH8O7cP2218szfpkTnDiOE/aD8TIqZbPlMMcHt9pMCFSyGVpgD5G6BQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=l0gOqppm; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 15 Feb 2024 20:13:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708027985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gKIub81Sc4Nl7uCdniCI0jeJfd0LuO+w541ahUUiUW4=;
	b=l0gOqppm1Q6KVADGlmEX/Qv2lrl2UtknDOpK8InCI9cnIPEVogV/zsySi6pGfUM6W71ZCQ
	izbiieMZAhkmttwc4s6yZju8UGSEbkW7dAeOfDdt2lb9m7e9QgHkZW08JeoV5HYKX0hMMh
	KnmJrgqQgGxD4R4SvUTJ5H8PQq/CEAU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
	Pasha Tatashin <tatashin@google.com>,
	Michael Krebs <mkrebs@google.com>
Subject: Re: [PATCH 2/2] KVM: selftests: Test forced instruction emulation in
 dirty log test (x86 only)
Message-ID: <Zc5wTHuphbg3peZ9@linux.dev>
References: <20240215010004.1456078-1-seanjc@google.com>
 <20240215010004.1456078-3-seanjc@google.com>
 <Zc3JcNVhghB0Chlz@linux.dev>
 <Zc5c7Af-N71_RYq0@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zc5c7Af-N71_RYq0@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 15, 2024 at 10:50:20AM -0800, Sean Christopherson wrote:
> Yeah, the funky flow I concocted was done purely to have the "no emulation" path
> fall through to the common "*mem = val".  I don't have a strong preference, I
> mentally flipped a coin on doing that versus what you suggested, and apparently
> chose poorly :-)

Oh, I could definitely tell this was intentional :) But really if folks
are going to add more flavors of emulated instructions to the x86
implementation (which they should) then it might make sense to just have
an x86-specific function.

But again, it's selftests, who cares! /s

-- 
Thanks,
Oliver

