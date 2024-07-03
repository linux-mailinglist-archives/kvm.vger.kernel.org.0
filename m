Return-Path: <kvm+bounces-20886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 62213925399
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 08:25:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16C471F240C1
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 06:25:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8248130ACF;
	Wed,  3 Jul 2024 06:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CuNCfp4U"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAF212FB2F;
	Wed,  3 Jul 2024 06:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719987897; cv=none; b=ISHUCxXRqbKwmFyPXqvR82fTXE6Ymh4T7xUi23BxlNJ7B/GYOarBsrR6xh3+SSIEKBBlWJGaLEXg9UIzgHDo36fsCmWgcGHU4mi4Ha8/SGYemp5sbS0cEpGFuubvhi+Wibpn1vq+ihHC7vqx0z6CDnBNK6LIVu9+w1y3KwHTWHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719987897; c=relaxed/simple;
	bh=gpVnu/Rr7w0UXXS2ukTjyVwS9ckAbMI6Cs8ZHqish5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dK5Wz1vyDVvE5KDSBTK+T3T7qHZ5nV3ARNHO6gXiFuLyeyj1td6miEKZEE45pNDDuonji4AiSrUZlx8v+ryDF/yBLvHqdeBQxviLjMFLCLQPLt3cBV5Gr3DICfVB9Io01El5Pki5RqLiuPOVcCQp3AnlESQ0LVmZC7fiSLOUexQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CuNCfp4U; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABDEEC32781;
	Wed,  3 Jul 2024 06:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719987897;
	bh=gpVnu/Rr7w0UXXS2ukTjyVwS9ckAbMI6Cs8ZHqish5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CuNCfp4UDt5L8b7EVQy2OLvYODcFrpoQhqpokUKQ8AtaiDZ6BxrC8hvdW82VwafcO
	 YfQDFGT7It9eB2Ar4Qaw+hH7OmJuEo0EpT7SRf7Hztpv/urp3KoYJEFmqiEiWvARp0
	 7xwFvjQGGIXdpxWILFzXs5lrtnVmYFDnfZWrd4LkGdkEaviE7hXZxltpj5bMGEAPFo
	 GiO5plj++/KaziclCtd/1TsOkH40awMsdnBgZZwrywNauG7/Xe398uuTtOIa0kmvz6
	 hM/pomSVeJkJVUZWbutqIk6QD4+avxrSPsQOWpFhAji1OXeG5Cj4l0K1Y2Ws3tNCLs
	 RROVTfx1MlsIw==
Date: Tue, 2 Jul 2024 23:24:55 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Alexandre Chartre <alexandre.chartre@oracle.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	daniel.sneddon@linux.intel.com, pawan.kumar.gupta@linux.intel.com,
	tglx@linutronix.de, konrad.wilk@oracle.com, peterz@infradead.org,
	seanjc@google.com, andrew.cooper3@citrix.com,
	dave.hansen@linux.intel.com, nik.borisov@suse.com,
	kpsingh@kernel.org, longman@redhat.com, bp@alien8.de,
	pbonzini@redhat.com
Subject: Re: [PATCH v2] x86/bhi: BHI mitigation can trigger warning in #DB
 handler
Message-ID: <20240703062455.ncak7idh2e3fv6sq@treble>
References: <20240524070459.3674025-1-alexandre.chartre@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240524070459.3674025-1-alexandre.chartre@oracle.com>

On Fri, May 24, 2024 at 09:04:59AM +0200, Alexandre Chartre wrote:
> When BHI mitigation is enabled, if sysenter is invoked with the TF flag
> set then entry_SYSENTER_compat uses CLEAR_BRANCH_HISTORY and calls the
> clear_bhb_loop() before the TF flag is cleared. This causes the #DB
> handler (exc_debug_kernel) to issue a warning because single-step is
> used outside the entry_SYSENTER_compat function.

Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>

-- 
Josh

