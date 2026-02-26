Return-Path: <kvm+bounces-72069-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qOyFIamaoGlVlAQAu9opvQ
	(envelope-from <kvm+bounces-72069-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 20:10:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 04B681AE365
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 20:10:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5BCDA3029C28
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 19:02:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1FFE44103B;
	Thu, 26 Feb 2026 19:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B8Xuygti"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAA644A711;
	Thu, 26 Feb 2026 19:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772132534; cv=none; b=EJiImlwGX+ogIXbrF0zR435Lo2/D+EH/ttrWomAi83RTZEsRpNH0mBPt1qMkAXDPYIQt5kAe7hb1W4azb05r9r56+yd1qHWkQiHgrKVBTC0to69kI+M6DPrgpaxmOnzW0066bi3rsAVg8/aFl0MJSRZ6lDlJkVblKSZfQqQ7EwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772132534; c=relaxed/simple;
	bh=8h/c/rmrI2gBor80ij92SCLTbObsozh42LUTt8FpIAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oeG2pQrVYlHHo6lngvIypDxxT6kAnCSb531KP4S+KRoQOvcA0Y+ITAgWjg8xJodRn44xmyHyEC3vCxFn6YrdjnsX+tIqRjXH++ouj1+u8MPq8FfaDyvUEPTrStZNqSGhjH7C7pgwE6P1mHOElcwIv2TOZfZAqow7geyM5nfqeJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B8Xuygti; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A23C116C6;
	Thu, 26 Feb 2026 19:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772132533;
	bh=8h/c/rmrI2gBor80ij92SCLTbObsozh42LUTt8FpIAg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B8Xuygti9gTOBGt9jg3ZVz1ODZyaHsVTuIdvOXwKFL1NtTN+phpIijtg1zgL1R3SY
	 3C8HqkP7cwnhbNl25Qg9hVGT/GmJsIYwH++pWvPgHLU8TwvaLjQN6w0q4yHwjfFW+h
	 EgZM78ZttYN8YtFtgKPALonpiLqYqkKNrj9GivIi4OfrxCI4YVfmOy+yDs8L9FBVfN
	 WYTkJZ05Cj44siyXaJ2OssEUsGETqFHimZuFjukHnGKfcwocG0nkx2rKj4oxCokqXU
	 ocEZt9oPpwsrwp7HTian9lMVzKRAlgb7UaBPxeaiGsh7ruKv7qRkE3CLFOrp2gE8Kd
	 aB2z+G2hxiVwg==
Date: Thu, 26 Feb 2026 11:02:13 -0800
From: Kees Cook <kees@kernel.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, daniel@iogearbox.net,
	gustavoars@kernel.org, jgg@ziepe.ca, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: x86: Fix C++ user API for structures with variable
 length arrays
Message-ID: <202602261053.78753BF1C@keescook>
References: <aaa7ac93db25459fa5a629d0da5abf13e93d8301.camel@infradead.org>
 <da02314c-e6da-4d9e-a2c8-cd3ee096bc0c@embeddedor.com>
 <97d40dd0e6abaf28f43d4d8ccf9c547a16c52e33.camel@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <97d40dd0e6abaf28f43d4d8ccf9c547a16c52e33.camel@infradead.org>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72069-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[15];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kees@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,amazon.co.uk:email]
X-Rspamd-Queue-Id: 04B681AE365
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 11:44:21AM +0000, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Commit 94dfc73e7cf4 ("treewide: uapi: Replace zero-length arrays with
> flexible-array members") broke the userspace API for C++. Not just in
> the sense of 'userspace needs to be updated, but UAPI is supposed to be
> stable", but broken in the sense that I can't actually see *how* the
> structures can be used from C++ in the same way that they were usable
> before.
> 
> These structures ending in VLAs are typically a *header*, which can be
> followed by an arbitrary number of entries. Userspace typically creates
> a larger structure with some non-zero number of entries, for example in
> QEMU's kvm_arch_get_supported_msr_feature():
> 
>     struct {
>         struct kvm_msrs info;
>         struct kvm_msr_entry entries[1];
>     } msr_data = {};
> 
> While that works in C, it fails in C++ with an error like:
>  flexible array member ‘kvm_msrs::entries’ not at end of ‘struct msr_data’
> 
> Fix this by using __DECLARE_FLEX_ARRAY() for the VLA, which is a helper
> provided by <linux/stddef.h> that already uses [0] for C++ compilation.

This is likely the best plan for these cases. I had to do similar for
ACPICA upstream, leaving these flex arrays as [0] for the non-GCC (and
Clang) builds:
https://github.com/acpica/acpica/commit/e73b227e8e475c20cc394f237ea35d592fdf9ec3

> Also put the header fields into a struct_group() to provide (in C) a
> separate struct (e.g 'struct kvm_msrs_hdr') without the trailing VLA.

Right, my only worry is if C++ would want those header structs too. In
that case, you'd probably want to use a macro to include them (since not
all compilers are supporting transparent struct members yet):

#define __kvm_msrs_hdr	\
	__u32 nmsrs; /* number of msrs in entries */	\
	__u32 pad

struct kvm_msrs_hdr {
	__kvm_msrs_hdr;
};

struct kvm_msrs {
	__kvm_msrs_hdr;
	__DECLARE_FLEX_ARRAY(struct kvm_msr_entry, entries);
};

> Fixes: 94dfc73e7cf4 ("treewide: uapi: Replace zero-length arrays with flexible-array members")
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>

Regardless:

Reviewed-by: Kees Cook <kees@kernel.org>


-- 
Kees Cook

