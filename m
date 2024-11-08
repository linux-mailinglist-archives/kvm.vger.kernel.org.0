Return-Path: <kvm+bounces-31317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D89889C2550
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 20:03:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A07482845BF
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 19:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0AC71AA1DB;
	Fri,  8 Nov 2024 19:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IrHHirVr"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CB9233D80;
	Fri,  8 Nov 2024 19:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731092622; cv=none; b=D4VJVg+pIUwv7da6J22n7WT8ui6GHPjNfnk/XvPniiOV6ElojZSonC72TieuWGWVjfDv0/H6N8Fn0+h8H7fXgXdpZfo+efWNQ7Vdu4I880wzFWclXTAuHM/GhbRojv05MYE/Eu2V0EXdA6Jq9TuCAHq3Zl3TN4mcgiHBFdYbNZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731092622; c=relaxed/simple;
	bh=Vc+It44rnvsd8SN/33MzeG10nJs7XAhLqnpj1GkG1/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GEZYSGDWpZhspeNJYaMK+6W4dq4m9NhxZgtc/pZs7+JI0uMK5EZ2xUSHiYgasWTmDXyWcYJXa/6VszHCkGdoJbizN4fpzMflAa5bBgizjux7WIwizznHRr5Pb2PVNinMjuLhboS3SOH/Mg2K2bhIhs+7BaAfegckpJglqHjYEHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IrHHirVr; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RuBlv2VOyF1R3bO3plu7ki21Z1Ln2a55IM7vJZ7vxyM=; b=IrHHirVrd1Mbarn13fF2L24IOC
	z8xLdCumFkD9yfyh36aC62vGyNYGYe6baS+Wtf3gyleVfVqhXa+pvkozF9DwywWsZQlOcb7uTUESs
	D14WMnOQIg18qirnQIOJv2YoOhEFo/ptW2Tni5D3G9cvwYoZiqk3h6s7SD/XR7ba7f2X9eUIRlOQT
	BJpSCIyP2V9Xduwbn6e7pUrvFU8x4CDCaXG6dDHcm6sEQ59ATgVLKFQggYGLIP79WgyiDFo6WwNDx
	YjGej4gTca/9FS1JwPPuvvYJkvQKX2baOxYzuhun4cUEw3/f0qTCbwWHrfeprrv8tPWoZq7Y4Z9uK
	wmIo5PHQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t9UGf-0000000CMXS-2k8M;
	Fri, 08 Nov 2024 19:03:37 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 4948330049D; Fri,  8 Nov 2024 20:03:37 +0100 (CET)
Date: Fri, 8 Nov 2024 20:03:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
	nathan@kernel.org, ndesaulniers@google.com, morbo@google.com,
	justinstitt@google.com, llvm@lists.linux.dev
Subject: Re: [PATCH 01/11] objtool: Generic annotation infrastructure
Message-ID: <20241108190337.GB38972@noisy.programming.kicks-ass.net>
References: <20231204093702.989848513@infradead.org>
 <20231204093731.356358182@infradead.org>
 <20241108141600.GB6497@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108141600.GB6497@noisy.programming.kicks-ass.net>

On Fri, Nov 08, 2024 at 03:16:00PM +0100, Peter Zijlstra wrote:

> From an LLVM=-19 build we can see that:
> 
> $ readelf -WS tmp-build/arch/x86/kvm/vmx/vmenter.o | grep annotate
>   [13] .discard.annotate PROGBITS        0000000000000000 00028c 000018 08   M  0   0  1
> 
> $ readelf -WS tmp-build/arch/x86/kvm/kvm-intel.o | grep annotate
>   [ 3] .discard.annotate PROGBITS        0000000000000000 069fe0 0089d0 00   M  0   0  1
> 
> Which tells us that the translation unit itself has a sh_entsize of 8,
> while the linked object has sh_entsize of 0.
> 
> This then completely messes up the indexing objtool does, which relies
> on it being a sane number.
> 
> GCC/binutils very much does not do this, it retains the 8.

Anyway, for now I've added:

+       if (sec->sh.sh_entsize != 8) {
+               static bool warn = false;
+               if (!warn) {
+                       WARN("%s: dodgy linker, sh_entsize != 8", sec->name);
+                       warn = true;
+               }
+               sec->sh.sh_entsize = 8;
+       }

To objtool, this allows it function correctly and prints this reminder
to for us to figure out the linker story.

