Return-Path: <kvm+bounces-62349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C2EBC415FE
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 20:01:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B86AA4EF533
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 19:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C85B2F746D;
	Fri,  7 Nov 2025 19:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="kn1tNMs/"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D28E2D739A;
	Fri,  7 Nov 2025 19:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762542013; cv=none; b=dK9jmP5DtbW4o6lN5EOQmUVf1CAuI1kRug4KTkFuSfrzNQvdJCiZ7fySKhwZkGXB0X+nk4LdMzphdM/DxBHLhOStbOEccPxnDgZWhm35vZWh0kJJ4vSQCLDIWSAhTOab8gJE4bqI61aM+BxFvzcb4qnBWUuU/PCqh4/s6ZeOTsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762542013; c=relaxed/simple;
	bh=RmkBsbgzw/bsgShYE9MlNR3ay/KZUzgJqdKDOICgbyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AOeNVowav7UmuWWPWgDQuhCOAGp/tLj65oOtEaF1Umc+YQVBXqW3GAwu/nbrXaYaNFLbKspsHdwoEvCEeEInHSRw3SRI7p8ItxcRAGUmx6t7l8phI7fcgEEaPIClhlKQOITJgcPNn9VkNbjk0YZhX6Slzg5mQCiOPvm2LeWKKmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=kn1tNMs/; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 93B5D40E0191;
	Fri,  7 Nov 2025 19:00:02 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id yO9KQnm9Y2Y1; Fri,  7 Nov 2025 18:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1762541996; bh=i0A/KoHm13SotTlocGnmigjkzV2u9vbAdXzGl0tfG90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kn1tNMs/6kJiAKfUE1XF2XvFcfVWFbrbnmvW1BNNe+3Z9GdzCs6wgLquE8bey0VtM
	 PCYUnM5yKV1jasz3R5TstspdpBSeZB92eWqnxEAd6YoUvx26I1suQ3p7jd/TbuVWyt
	 jePHyku8Yit67w0grZ+Y+zt9u9bHua8iFausd+iJ1YdJ7ZdEWIRps+7nMgfabPD6y1
	 iYfCEc0jdSk+J95O429DnKQN8hmOQjpIfa5VkkyEZW8nW5XosRsD0zGMzVJ5D3ZR5Z
	 61GtXe+g/812YTI4aRnU9l/twm2NWt1u9Ro3+7a3fsiuL/Qlcqr8CG0vEcYDh/jj+e
	 6GiE6oEw4asQAYhYJCgaj6yPD6nXbtUcwDdEgn3soEtx9Eu+zCJpy3fnkXf1TsWgFb
	 Hp3zjAXa6+czzbzKjqEtTiAzQA6+ho9723c8Qoh4/enOCDuefZAiqL1gizb+UkMhwA
	 +ov7d7UazI+gGMXeSf/26Q0eGzcaneflgvL4qTE9q+24dWnGWkkAKMITyLGHI/OJ/c
	 ZPVjHT/wStzhHvyXrlTCQeDOgoP6tCjHlNUpgLChVrz80FFb+Pr3d9iP/iqf2U+QGA
	 f1yNktPa6cYtEnXtskgLV/g0vCb5+UfcegQe9U/kmgTr0XODY0UE1dY7JqHKL9xMIf
	 Zy34HWpjy1IwtJlV4wsZVHxY=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id ADDB640E01A5;
	Fri,  7 Nov 2025 18:59:47 +0000 (UTC)
Date: Fri, 7 Nov 2025 19:59:41 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 1/8] x86/bugs: Use VM_CLEAR_CPU_BUFFERS in VMX as well
Message-ID: <20251107185941.GSaQ5BnYzN_X9J3Qa0@fat_crate.local>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251031003040.3491385-2-seanjc@google.com>

On Thu, Oct 30, 2025 at 05:30:33PM -0700, Sean Christopherson wrote:
> From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> 
> TSA mitigation:
> 
>   d8010d4ba43e ("x86/bugs: Add a Transient Scheduler Attacks mitigation")
> 
> introduced VM_CLEAR_CPU_BUFFERS for guests on AMD CPUs. Currently on Intel
> CLEAR_CPU_BUFFERS is being used for guests which has a much broader scope
> (kernel->user also).
> 
> Make mitigations on Intel consistent with TSA. This would help handling the

"consistent" as in "use the VM-specific buffer clearing variant in VMX too"?

In any case:

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

