Return-Path: <kvm+bounces-38791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B32EA3E615
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 21:47:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B517519C0AA9
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 20:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12D902638B8;
	Thu, 20 Feb 2025 20:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jMptXPPg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C02685C5E;
	Thu, 20 Feb 2025 20:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740084447; cv=none; b=fsU0homzqIGoNK4BNFzk/9ijf6SjnZvraplrN90e3fL6VSo5xmiOFAU1m4HIVLDNW1x1PdBNYE95J98shqvJ7VXPurVwJ8/7zVATeyqQzdaDTnz4FHWEVX5iC6oAYVaIiTdjl/mcmHoF/Gr8QLO6jAxQ0DqQNhzmY9mBY6KgYfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740084447; c=relaxed/simple;
	bh=CrXK0+0OmxoERLdSHiIWG9AZoYNkPYFvl35Gfargr10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sohxPuoIPlhBS8iuzPaD7zP17EmQUpfMgn+x3X3vVlXwjeqWfRiP1A0XK03A95EhRfQc5Apa7giFmwr1cDlwRcZFO9kiUasX7o/tsspoft4Wtvbn9wwSc0d17wZLRbOfP4wabo+JjTbp8uqCwBH4ffiwu6tHBoOjBtdLvJe8raE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jMptXPPg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D12BC4CED1;
	Thu, 20 Feb 2025 20:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740084446;
	bh=CrXK0+0OmxoERLdSHiIWG9AZoYNkPYFvl35Gfargr10=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jMptXPPg+wfTTdCSVE0mFPfYuuhi9Gj9c3rEW5KPvLCYB5DbDucJwmb56GmtytNUZ
	 ytNEDxbScNMmTaFM0VPGLkgJNgVnPArRuhQBgiPhuB8AG81oSXUXfx/nslkWWJiIki
	 Rte0m8xqIH16hOiT3gI3p3Y2Ygdm++gZoqpvTHkekB3RlFhOLAw9AKrUC0OYXB+LHO
	 IUutUsf1E/9ovDRmCJc4YuEMrzHC2xHOXFfa8ZO9STIZeKNFFqU7vQB6y3bDSFq/Mc
	 C2zduM+1I95JYWHbT77DgQ5uF9jex+iTz0AgTZ5s0uZ7+l88slxIxrl1ZutJoY1uHn
	 StRCvPdraNDpQ==
Date: Thu, 20 Feb 2025 12:47:24 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] IBPB cleanups and a fixup
Message-ID: <20250220204724.y3b6wx7y2ks3fuct@jpoimboe>
References: <20250219220826.2453186-1-yosry.ahmed@linux.dev>
 <20250220190444.7ytrua37fszvuouy@jpoimboe>
 <Z7eJurYbxS2kAzvk@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z7eJurYbxS2kAzvk@google.com>

On Thu, Feb 20, 2025 at 07:59:54PM +0000, Yosry Ahmed wrote:
> > static inline void indirect_branch_prediction_barrier(void)
> > {
> > 	asm volatile(ALTERNATIVE("", "call write_ibpb", X86_FEATURE_IBPB)
> > 		     : ASM_CALL_CONSTRAINT
> > 		     : : "rax", "rcx", "rdx", "memory");
> > }
> > 
> > I also renamed "entry_ibpb" -> "write_ibpb" since it's no longer just
> > for entry code.
> 
> Do you want me to add this in this series or do you want to do it on top
> of it? If you have a patch lying around I can also include it as-is.

Your patches are already an improvement and can be taken as-is:

Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>

I'll try to dust off my patches soon and rebase them on yours.

-- 
Josh

