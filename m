Return-Path: <kvm+bounces-33336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C05539EA082
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 21:44:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2851E1666B8
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 20:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FB4519C54B;
	Mon,  9 Dec 2024 20:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xaxti/5y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588F119AA72;
	Mon,  9 Dec 2024 20:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733777057; cv=none; b=ChuDCXIYsuJ+C44LAYpqaDooY2xM24TbTl0qL8ddsUKPnCiEVMXiYQSYp/QlHR0LwGb3RgDy4e0z4XlkFsA3B7WEjjVXOBNmutXwcqnGxwF8QfdI91VSWAgCIuIIgC+fVlWEyOCa0QwLtLsjcJWLgVtP0UNzi1olukESVi7o9Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733777057; c=relaxed/simple;
	bh=uM90HJj3dP9t3BA/NFsy4tPH6dCS3rNSQ5ewIopquRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rdqu0thyLbSBmSw8k2emzRtmpa/qjV3+EpC17zqYMj2wcObrHPkfRfLy0X4Ieaq4sUokpuYR+FZkiv8nGhCdZsYv1zLiXtqIU2/nPOaex7OkrQl4NnmD2hjDwOKNZmNkqE0P7OeKeZrurbKwixkJV6GupCrvRVZMxiY9Fn+ELQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xaxti/5y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C97C4CED1;
	Mon,  9 Dec 2024 20:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733777056;
	bh=uM90HJj3dP9t3BA/NFsy4tPH6dCS3rNSQ5ewIopquRE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xaxti/5yeeMbfPmKH5GZL5db7nJfWAitfhF2dRLs1hUDNaO/FrUXiOrNVakb/ntLn
	 i15JtQFxZz6hAtAiWKv1yzi81L3S30t4SY9LdMFVyN2ODFN/QFCKpEpvNMF5YeylaT
	 Ryqe43MnhgKKb+y949NnbIqhbzoFOqv6ou/JqnJbn79MnmFauMUc5PqT1olBZy+CLd
	 knt6C7oKYnGFCtLF2xbDMoHlLtb6d1zq0cDTcoVjuZYBwQGpt5KLpps6en7KOKKZQf
	 96InQf5/xc9Uq49F98UB/rSxNI9EotR98sNyiEtn1Wr3mLEYTT5mY9czrcrUW+6kbH
	 p2HaeyU7kBtkA==
Date: Mon, 9 Dec 2024 12:44:14 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, Kim Phillips <kim.phillips@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: Hitting AUTOIBRS WARN_ON_ONCE() in init_amd() booting 32-bit
 kernel under KVM
Message-ID: <20241209204414.psmh3yyllnwbrc4y@jpoimboe>
References: <20241205220604.GA2054199@thelio-3990X>
 <Z1MkNofJjt7Oq0G6@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z1MkNofJjt7Oq0G6@google.com>

On Fri, Dec 06, 2024 at 08:20:06AM -0800, Sean Christopherson wrote:
> From: Sean Christopherson <seanjc@google.com>
> Date: Fri, 6 Dec 2024 08:14:45 -0800
> Subject: [PATCH] x86/CPU/AMD: WARN when setting EFER.AUTOIBRS if and only if
>  the WRMSR fails
> 
> When ensuring EFER.AUTOIBRS is set, WARN only on a negative return code
> from msr_set_bit(), as '1' is used to indicate the WRMSR was successful
> ('0' indicates the MSR bit was already set).
> 
> Fixes: 8cc68c9c9e92 ("x86/CPU/AMD: Make sure EFER[AIBRSE] is set")
> Reported-by: Nathan Chancellor <nathan@kernel.org>
> Closes: https://lore.kernel.org/all/20241205220604.GA2054199@thelio-3990X
> Signed-off-by: Sean Christopherson <seanjc@google.com>

LGTM, but please post as a proper patch in its own thread so the -tip
maintainers are more likely to see it.

-- 
Josh

