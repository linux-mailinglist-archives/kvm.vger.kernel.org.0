Return-Path: <kvm+bounces-36482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C536A1B673
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 13:59:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4FC81659A1
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 12:59:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 175EB1C6B4;
	Fri, 24 Jan 2025 12:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="D2lBxthl"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5701156CA;
	Fri, 24 Jan 2025 12:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737723552; cv=none; b=lSCW+PS/PTACJzQ6ZQrvkG2nKlaD/P1dhv3smOhdTQLpTAWf71AHRYw40iJ4hwQhhq1YmmqUIEBhRkKBo+HXjAV4C43V/HqAMtOBdwd6xMFn5lHYcBh7oiGP6h+8g2BY9SA29nF1oRIrzwlhdf54d98jV2cgJp+M/5BQgodLNso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737723552; c=relaxed/simple;
	bh=WNOE5L9XVcA0OGBnETxggcAhv4I3aAppZy29K5Xza98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HIguPRNFIkULlufJaJvks5IfTysCY0nGC3GOsvRp3tgI4Q7Q/J4O5gkGPs+WBx1dR0mKfYnnkSuqhnJhhLxRv177BR+sc6mztR814rWXVg4mKxVWBpmIR9cNtQwF7YlprPV9i185tJfJC2omIL9LpZE38fPxwCpb+BeY/1HUoHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=D2lBxthl; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id EBCF740E021A;
	Fri, 24 Jan 2025 12:59:00 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id KY-nF0UmG7n1; Fri, 24 Jan 2025 12:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1737723537; bh=oSKp5Ib/Esimj14whXkuMMbXkgZMt6m7fwyWK6aaVnc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D2lBxthlDfYIRVYFjB7WqCVTevb2KWixXtgDrfAu/2CgUHd7vmhSTvqRAZWpALLgI
	 ycbVBvU2oTYBawpLaFBBJIDk0Gg/WcjDUO019/ji6JLY+dpeGx0+3x0U0QHWp5JUD1
	 CQHdBbWVqGyn31O2mUOcFVgLoe1RSNHPrmP6HYY0Z/Ry/s567uaWFOgC9/iCBYMMEa
	 i11ABAxQsS0/XA79wZZG97wZiP0+V4oDw32fCRmZAO6ik729JgfCpVqYRztvRiFBOy
	 KN1fxFbGG/+HWsFSscLFT2kK8NbENj4bczwDlXovVyv4ArNOtfmxxgN7QkgH2Br1vB
	 PwMOEGKzqfd8r2cQfkkMe6k0ZY3K1D0S5B2crNFa3m2rnt3Kbtzfu6SCL5C08Wfcnh
	 0hKeuP7XKlgQQSLtqo5wO6lUQh7VaxPHoHKuIjddsRVH1GFFp290CuYXH3Ku2Wnnbf
	 0MWn3DhNrXqC/VV5ZECPuW1RubFUgeGm5SOtu/0MZ6RGsVhoj9GApaygVHhKScQ1Wk
	 UU+nAY2SQzDPa9HQ24YJaZmDyaUjT7tNny+GIoW56Jfi7GEcFBptsa8jMQx7GB7cNb
	 xoZz9bzQ1nXceEah023caqHkxbAM3epWjesTE9OoHxLwxaIlkTbav6QP+bm9flimT0
	 caiCx8goAITe2l4acpKr5+P4=
Received: from zn.tnic (pd953008e.dip0.t-ipconnect.de [217.83.0.142])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0A43E40E015F;
	Fri, 24 Jan 2025 12:58:48 +0000 (UTC)
Date: Fri, 24 Jan 2025 13:58:43 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/bugs: KVM: Add support for SRSO_MSR_FIX
Message-ID: <20250124125843.GBZ5OOg3rWBd9pY3Bx@fat_crate.local>
References: <Z35_34GTLUHJTfVQ@google.com>
 <20250108154901.GFZ36ebXAZMFZJ7D8t@fat_crate.local>
 <Z36zWVBOiBF4g-mW@google.com>
 <20250108181434.GGZ37AiioQkcYbqugO@fat_crate.local>
 <20250111125215.GAZ4Jpf6tbcoS7jCzz@fat_crate.local>
 <Z4qnzwNYGubresFS@google.com>
 <20250118152655.GBZ4vIP44MivU2Bv0i@fat_crate.local>
 <Z5JtbZ-UIBJy2aYE@google.com>
 <20250123170149.GCZ5J1_WovzHQzo0cW@fat_crate.local>
 <Z5KEoepANyswViO_@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Z5KEoepANyswViO_@google.com>

On Thu, Jan 23, 2025 at 10:04:17AM -0800, Sean Christopherson wrote:
> I almost proposed that as well, the only reason I didn't is because I wasn't
> sure what to do with the pr_info() at the end.

Yeah, that came up too while looking at David's patches. We're not really
consistent when issuing the mitigation strings depending on the mitigation or
whether we're affected or not... 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

