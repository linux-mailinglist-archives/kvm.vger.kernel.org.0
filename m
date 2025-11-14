Return-Path: <kvm+bounces-63190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6984FC5C289
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 10:07:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B33794F0BFE
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 09:03:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 159243016FB;
	Fri, 14 Nov 2025 09:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PrKyPU9e"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EF22C326F;
	Fri, 14 Nov 2025 09:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763111019; cv=none; b=p+Qh57pJU7VZBY4GUecaIDzBJ/U8a7NqTMeE0ueTcZOQd8LOJionDAVEMh2MA/UbPAsFhPCnB3L2LLOcPLZXnG20WvsWDTIWiKLim6QfhiIYEX2Z2ApfXW8hGMoxbwDH8FOTcYQZ4iwmXbzQd4wiAja7SsyZcI+SPDHavimzAAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763111019; c=relaxed/simple;
	bh=CHHcVWP7+azq7U8bx2c9snKg7BzuRKMTEfKak29g+SQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZDuzLH1ndto/5IzyYhDcljKTajp/XQ56ijr5T/zW7zdQQHKiQSNtm9gczG1AK5Od++CatWVvq6E58rXvZwYYxO9N3bIFCUaj+XeU7SsEnodN1DQsCVI9S+AhI9XvIt8S7ZFC/NhurOBAl6jwPBKN7t8n79yRQPpc/z/wITMQCIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PrKyPU9e; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=isqvQ2KBi8Wgtu2oWNPjHlRemcfKWwu1gUel1sa3XZk=; b=PrKyPU9eI3TivS1fIA96M3CQEy
	l+PjKPIFDXbdHhk3I9sqEQb4IPMXJs3gVUagfrf+uBvwZzVPvWwsIJSXkmzk0ySznn+9IFhkYhu8f
	H9RJNTzTs8hItc1d9l9MMN2it5IZi4Tw54el219kiGuTkrcyX9EtxAYAdNU7KG26qPA7+bHQq2Hpm
	qkSUA2swvgD1DzoH2uT+0Y8DvE3A0zYn0CUn+m1w3bkaXT4bUu6Qp7Ipy7kcpFNdPjmChI2Vm0jkb
	u1CfgsvLsYVvULFeDxQfiuNUP831SUgpz8X9JjQ08xXWwEA3mQYcAXtH6xGH2xFMjQYf+UcC91hTx
	/V9Zw+ZA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJoqg-000000028bs-2k1l;
	Fri, 14 Nov 2025 08:08:03 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E24F530029E; Fri, 14 Nov 2025 10:03:28 +0100 (CET)
Date: Fri, 14 Nov 2025 10:03:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	"Kirill A. Shutemov" <kas@kernel.org>, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, kvm@vger.kernel.org,
	linux-sgx@vger.kernel.org, linux-coco@lists.linux.dev,
	Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH 0/4] x86: Restrict KVM-induced symbol exports to KVM
Message-ID: <20251114090328.GS278048@noisy.programming.kicks-ass.net>
References: <20251112173944.1380633-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112173944.1380633-1-seanjc@google.com>

On Wed, Nov 12, 2025 at 09:39:40AM -0800, Sean Christopherson wrote:
> Leverage and extend KVM's macro shenanigans to export symbols for KVM if
> and only if kvm{,-amd,intel}.ko is being built as a module, and only for
> the KVM modules that are being built.
> 
> Note, this approach isn't 100% precise, as exports that are only strictly
> necessary for one of KVM's modules will get exported for all KVM modules.
> But I don't see any value in being super precise as it's not like kvm.ko is
> any more trustworthy tha kvm-{amd,intel}.ko (and it's easy to circumvent
> "for module" exports by abusing module names (in out-of-tree code)).  And
> maintaining precise exports would likely be a nightmare (as would writing
> the macros to get the exports right).
> 
> Patches 1-3 drop superfluous exports that I found while digging around for
> KVM-only exports.
> 
> Sean Christopherson (4):
>   x86/bugs: Drop unnecessary export of "x86_spec_ctrl_base"
>   x86/mtrr: Drop unnecessary export of "mtrr_state"
>   x86/mm: Drop unnecessary export of "ptdump_walk_pgd_level_debugfs"
>   x86: Restrict KVM-induced symbol exports to KVM modules where
>     obvious/possible

Nice!

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

