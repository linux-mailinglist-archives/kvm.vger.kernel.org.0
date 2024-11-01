Return-Path: <kvm+bounces-30317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4909E9B949C
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 16:41:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1669928200F
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 15:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 860C51C6F70;
	Fri,  1 Nov 2024 15:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="LgLRdBuU"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4ED425634;
	Fri,  1 Nov 2024 15:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730475683; cv=none; b=ndck7yUjTy0dkjUjZjmVwFUdKH36Z1T6XrmCmJ+d/Qd7SISKyqhhOiEvRPsbkTlDZ29I+9k9yUExTpiWP1t6E/oNtJDKUzty7Hz3NdcOjGPigbjl4JhqiIXwhoBHv7zuJibyjTDAsxWwJw+hkI0c8LsvSTF02dtHqTRYPMpAZaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730475683; c=relaxed/simple;
	bh=cGmqoPAClduOyOt6XXt32hAdlqVHl7u7myhZia60Ugs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bpK0tIEtzNEc1Xwx9EOVBa8JnWIqYvU6tZ+YRyZpUYxuX/AM+JM8QUZ5/xSbsmTYNGXtD0NtkeFboGhurqy6QOXxfQ44GYiwA6O0rYAxsQlPtSJ9tI+ayQk8lJVcmaR96P2Fka4a+YeLQch502/kEpIhnhdTVfRtGHBVovaxebk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=LgLRdBuU; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C161240E0219;
	Fri,  1 Nov 2024 15:41:11 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id oFcti8NUH9nU; Fri,  1 Nov 2024 15:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730475666; bh=2WQgbUYhsxZ+e+B0X/oet6pigceEqqN6jbulC7IX3jw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LgLRdBuU00QFUL5OUFiav9RxkYTc4r1N/GUtn/dy3eEubIYz1dzPFqfLtERNlrQQT
	 ombbZqBKAUiwrieogPIRiMRqDptPe1DBw1c9E+/PZ571gYY9yVPFqE9yAOrpM66Z3s
	 lhsLVvRWcMP3C5odi0ja+do3IZk1Lr9242aKCqzPWKrtGV5yTFLmkF7RR9W1QKL+Dp
	 o5aNr4JmBrLgU9+U9GWNEt/hUU2fwUOmVLh9+54YlYq7SbZVZCd0IM+qh4vEiwS6AF
	 CIhB5ONLTjcGqDAq6VhiBKQoNIihFGEilxJeDXjQ+l73at/CA1ul/WyoKW5T2ikjPb
	 RQFdqRHmVgCo+nbGu+R/KmJ//C4XYXqWqmhi3+QpEHBQtTwpcsoi2hRafkfemYLx0z
	 Yd8RycqAVdppVHV9KtlesRene4pmChgA+Gp7giOEROKy3tjjHSDDw4aVLpS2lDtJ02
	 73Nfm+Kcj2Xt71nXGNdrbFm19UW+bfzvES6CzEBTIFZ/pxnijYT5+LradCpESturvM
	 WeoaeJMnJ6CTyFwapQL9lNmIjuilu1hlp7oDPiNjnVNu+JQbHwW2O3lX28ynp/ANJ2
	 BFwk2AyBpNb09mz6dHEe3iS6fwF9WZuC7euNunangNTchn8fbIuWmVsFlddSLNghlH
	 /8iqJRLE4m8b0N6yYEr/x/O8=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5D44340E015F;
	Fri,  1 Nov 2024 15:40:52 +0000 (UTC)
Date: Fri, 1 Nov 2024 16:40:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
	dave.hansen@linux.intel.com, hpa@zytor.com, jpoimboe@kernel.org,
	kai.huang@intel.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
	pawan.kumar.gupta@linux.intel.com, pbonzini@redhat.com,
	sandipan.das@amd.com, tglx@linutronix.de, x86@kernel.org
Subject: Re: [PATCH v5 0/4] Distinguish between variants of IBPB
Message-ID: <20241101153857.GAZyT2EdLXKs7ZmDFx@fat_crate.local>
References: <20241011214353.1625057-1-jmattson@google.com>
 <173039500211.1507616.16831780895322741303.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <173039500211.1507616.16831780895322741303.b4-ty@google.com>

On Thu, Oct 31, 2024 at 12:51:33PM -0700, Sean Christopherson wrote:
> [1/4] x86/cpufeatures: Clarify semantics of X86_FEATURE_IBPB
>       https://github.com/kvm-x86/linux/commit/43801a0dbb38
> [2/4] x86/cpufeatures: Define X86_FEATURE_AMD_IBPB_RET
>       https://github.com/kvm-x86/linux/commit/99d252e3ae3e

ff898623af2e ("x86/cpufeatures: Define X86_FEATURE_AMD_IBPB_RET")

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

