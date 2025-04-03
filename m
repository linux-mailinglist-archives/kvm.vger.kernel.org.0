Return-Path: <kvm+bounces-42535-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 302DFA799EC
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 04:18:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21A8C1892DFE
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 02:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F12D155A21;
	Thu,  3 Apr 2025 02:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i8urFoSL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332B15228;
	Thu,  3 Apr 2025 02:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743646685; cv=none; b=T7DazfI9yQyeRXdD9rH2G8CiUbXg1+XGV4LbvnW7EWXFDwLfdLwfK31b3HaYvbnPx8AQTPhrL4h7z0GzcfCNl4bAmJEj6Drbul5hg3xxHoxmb7ALZnLsivro0EZNjRuf82sV0MdrVx6Dnn17oMoUNHS0KNJxO2Gs3z45VnX6LIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743646685; c=relaxed/simple;
	bh=8ICGtbE/ZcNzqyF8BOQXqUOUJU/RX5gHRr3/MMgoD+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q0g5P0PBKIk7byngCku4SHzezMCqdi9h3CscxoPGiTcZbhfQGlnUbFwgTpNpN51pTHdI8T6lWMvUqFYlYIbp1mb8RLOmVIf1QPmwTQHucFWY6tMpcEFXPH5TKXeXkTQFez4g432wf8r43uKSii+UVYIIR1C4BlAEOL/wqRPAz/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i8urFoSL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD3BC4CEE9;
	Thu,  3 Apr 2025 02:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743646684;
	bh=8ICGtbE/ZcNzqyF8BOQXqUOUJU/RX5gHRr3/MMgoD+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i8urFoSL0f+VB54QH3iCEki4Yc1p5SMbtCofPvgeaVVfyGhHNWwsRbfyoO+XahaDV
	 LAe3QH/R8UeA3pOyWXjrvg1iI06Sj5K4ppJkr1LJztS07XttL30Mnm5nbD08fpp9kj
	 SaTw6pbTuR3awlovAXBaDvWqXTD9vY5ykrDpwjKZAAlXlQMuosfIZTAqHn8yT5xv/1
	 Vgw6ECZI/sfR40+EUBJdVeIaY1b/IhXoBgJiQpCZomHCdyDZYktL5sPJGZAHVhtf+k
	 sMovMtwgOnxePo2NzKSMSs69WvfBVsVjut8hnjqI58DRwvnPPQJEfIbx7bwsbImQ8U
	 Flsxw8vMVr85g==
Date: Wed, 2 Apr 2025 19:17:59 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Jim Mattson <jmattson@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, amit@kernel.org, 
	kvm@vger.kernel.org, amit.shah@amd.com, thomas.lendacky@amd.com, bp@alien8.de, 
	tglx@linutronix.de, peterz@infradead.org, pawan.kumar.gupta@linux.intel.com, 
	corbet@lwn.net, mingo@redhat.com, dave.hansen@linux.intel.com, hpa@zytor.com, 
	seanjc@google.com, pbonzini@redhat.com, daniel.sneddon@linux.intel.com, 
	kai.huang@intel.com, sandipan.das@amd.com, boris.ostrovsky@oracle.com, 
	Babu.Moger@amd.com, david.kaplan@amd.com, dwmw@amazon.co.uk, 
	andrew.cooper3@citrix.com
Subject: Re: [PATCH v3 2/6] x86/bugs: Use SBPB in __write_ibpb() if applicable
Message-ID: <fqkt676ogwaagsdcscpdw3p5i3nkp2ka5vf4hlkxtd6qq7j35y@vsnt3nrgmmo5>
References: <cover.1743617897.git.jpoimboe@kernel.org>
 <df47d38d252b5825bc86afaf0d021b016286bf06.1743617897.git.jpoimboe@kernel.org>
 <CALMp9eTGU5edP8JsV59Sktc1_pE+MSyCXw7jFxPs6+kDKBW6iQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMp9eTGU5edP8JsV59Sktc1_pE+MSyCXw7jFxPs6+kDKBW6iQ@mail.gmail.com>

On Wed, Apr 02, 2025 at 02:04:04PM -0700, Jim Mattson wrote:
> On Wed, Apr 2, 2025 at 11:20 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > __write_ibpb() does IBPB, which (among other things) flushes branch type
> > predictions on AMD.  If the CPU has SRSO_NO, or if the SRSO mitigation
> > has been disabled, branch type flushing isn't needed, in which case the
> > lighter-weight SBPB can be used.
> 
> When nested SVM is not supported, should KVM "promote"
> SRSO_USER_KERNEL_NO on the host to SRSO_NO in KVM_GET_SUPPORTED_CPUID?
> Or is a Linux guest clever enough to do the promotion itself if
> CPUID.80000001H:ECX.SVM[bit 2] is clear?

I'm afraid that question is beyond my pay grade, maybe some AMD or virt
folks can chime in.

-- 
Josh

