Return-Path: <kvm+bounces-68276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AAB4DD294C0
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 00:42:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 42A103023D48
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 23:42:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06D3E330D29;
	Thu, 15 Jan 2026 23:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RGONGi9p"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23F9238D27
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 23:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768520523; cv=none; b=kmsfAxsyK8DhCijf0wtqTDlX47XpYudQ2Z96ieh4maozgk6++5JzvRXAyO6dqy4XHSTbDicjuhH43oGEsaRlMqGkNBQVQWiX9bU3jvaUnjz4rnhpLnZrCxXSymE7xcmnFRZWpOWrT+/ZQQTQscGZgaN7qX4fe1SVHFi2l7AaNkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768520523; c=relaxed/simple;
	bh=II1HgiDWoUwozgdsK9v0KGuh44enKV1jVUIh+WyyMP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n2oIqEnAYUnRQ7VxgNRQhIuKItW0uPTq19E3svGkdlyJ0oaNKLcx/NUBOikjrKN8V0EncmzddanRNRkrXozcNCzfbXz+4fIDva9gD9KuAApLczNezkMOqdPYknToILWzSwiitqNBK6GGPZX9D9q0kRZZTx6Kw5IN7NNMbNyT/jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RGONGi9p; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 15 Jan 2026 23:41:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768520518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+0TlDlvfATV+m0PlajFv248tS1/iVTXsMD1A3Ld0Ugg=;
	b=RGONGi9pGkNYl6epyFnovJeRt8h8h61esAm0hjHR8Raefv4Nf/yhOjWQJJS/Co12mRH7uS
	/Q8YEmVK3OixxCMbeuDLrEH4kiqsP/8p3YR0aC8Y9M7Y1jI4UxcsUEeXsSNm2FUzTpfClD
	h4EZ8iAg667+XgOcI8urqHEppkBuCrY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86/svm: Track and handle exit code as an
 unsigned 64-bit value
Message-ID: <cy3wr6cvps3n6egw6hdr5apej6dbt7m2tg5dnjth3eyaxongrz@xluf45hbpkz7>
References: <20251230191342.4052363-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251230191342.4052363-1-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 30, 2025 at 11:13:42AM -0800, Sean Christopherson wrote:
> Track and handle SVM's exit_code as an unsigned 64-bit value.  Per the
> APM, offset 0x70 is a single 64-bit value:
> 
>   070h 63:0 EXITCODE
> 
> And a sane reading of the error values defined in "Table C-1. SVM Intercept
> Codes" is that negative values use the full 64 bits:
> 
>   –1 VMEXIT_INVALID Invalid guest state in VMCB.
>   –2 VMEXIT_BUSYBUSY bit was set in the VMSA
>   –3 VMEXIT_IDLE_REQUIREDThe sibling thread is not in an idle state
>   -4 VMEXIT_INVALID_PMC Invalid PMC state
> 
> And that interpretation is confirmed by testing on Milan and Turin (by
> setting bits in CR0[63:32] to generate VMEXIT_INVALID on VMRUN).
> 
> Furthermore, Xen has treated exitcode as a 64-bit value since HVM support
> was adding in 2006 (see Xen commit d1bd157fbc ("Big merge the HVM
> full-virtualisation abstractions.")).
> 
> Note, the SVM tests will fail when on KVM builds without commit
> f402ecd7a8b6 ("KVM: nSVM: Set exit_code_hi to -1 when synthesizing
> SVM_EXIT_ERR (failed VMRUN)").
> 
> Link: https://lore.kernel.org/all/20251113225621.1688428-1-seanjc@google.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>

