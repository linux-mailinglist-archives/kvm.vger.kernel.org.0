Return-Path: <kvm+bounces-62874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DE3A5C523CB
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 13:23:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3CF0D4F0D58
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 12:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 220C3328258;
	Wed, 12 Nov 2025 12:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="aa54lqoP"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8766D328248;
	Wed, 12 Nov 2025 12:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762949770; cv=none; b=mFmjqJVR5OlEbaOjB7H5CIoNDQAle9ZF2yNQTYKJlw2m5DLY2fOtDpWisxhRHutPVAZdryngWe6rtDbOPCedTJIxIj2tMZ5GAVo3ToeiFPYJQ90MwcSoPUcpmz2sENl25uXOvn0Rmz1YXn2+8wYjXvIboTkWRGWi3FI0kfX9CQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762949770; c=relaxed/simple;
	bh=z3pfXsws2Ib9I7QE66cd5SFRXKq2E3h+YcEe/sqNmik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T/uCRHsnS988WWML633rphcH34OwAn3Dih7anCKiVzoDQlkFASDHf1aJqU89lmCYU7uFlPYeC7uqcSB6thzbNVxwifUzb+dChFgLYbSLtuxb34HUyMoyX4wjTuwGeZsCe1kJNtZgkewSQYVr0mJ/M6EeFZZih3SnzLirH+OA5RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=aa54lqoP; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D934940E0225;
	Wed, 12 Nov 2025 12:16:03 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id lvXydyObwiS8; Wed, 12 Nov 2025 12:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1762949760; bh=0NzF56AgALMOOTOrc5WVJq9Jcj4PcG8F8jd49jZ76Ro=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aa54lqoPTbTHTc+c3KPV9IJ8b8nmZF7+yJZn7MsjsJwl+FX3rDgYtwBe4wJhXg7Lc
	 gm6i7uoRajC1W6+jD+B27LX5O3QQCHL22BTJHzrY/sp+hazOH+JHKV1QWQQxklx6ps
	 Mc7wRIGPl3Yh9eYhjmdKdE+03PpzztTH37kyLrIvPFHyL7B0EDlvkfFEOwv0C3vk5L
	 8/FSIrEDX6yHueEZ13P0aszzNHlOL971swI78lc+gY8S/uWJiyTIYQK4d3fHdfaZQQ
	 h6n3x/EXbTyUN0XgjkLSNgfVBEkKZw1gsn9c+QGXLWZPEvgMExDog13o9oe10cNP5C
	 BuzVN7jWCYXf2oaOt28RtMyNEDGFASCoanPe/G9ccAcdek3UWmnIl+fLpu1cbiuc+6
	 xFLd7089E97Y1B4w9A6Bomlx6FFyCfhLqguJ5an9sc8RM3iZV1e2LCTCGji1ZV1F1y
	 JMr1Z2lGCWYXOfWFIs9q/cQbLv86dHrtvZPH1Lp/ySfdD5royEGWx+AknGgIce8xYY
	 vPRSpjd9FvVMSfJ2PHbE1NQNqViviruMUixYLbCZhEVO0SjsT5seEcW2xF474HI7k3
	 hqOp6rUrkOSnT5o8lQGSgSTKUq3Bz0+ukZDX8J5fnXrFEOmwG6S/b6z8myEDf/evhf
	 8CXFg9NMRGqg6cylh2oErZOw=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 5B9C440E0191;
	Wed, 12 Nov 2025 12:15:51 +0000 (UTC)
Date: Wed, 12 Nov 2025 13:15:50 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sean Christopherson <seanjc@google.com>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v4 2/8] x86/bugs: Decouple ALTERNATIVE usage from VERW
 macro definition
Message-ID: <20251112121550.GYaRR6dh590G2TP578@fat_crate.local>
References: <20251031003040.3491385-1-seanjc@google.com>
 <20251031003040.3491385-3-seanjc@google.com>
 <20251101041324.k2crtjvwqaxhkasr@desk>
 <aQjfwARMXlb1GGLJ@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aQjfwARMXlb1GGLJ@google.com>

On Mon, Nov 03, 2025 at 09:00:48AM -0800, Sean Christopherson wrote:
> > Or better yet, can we name the actual instruction define to VERW_SEQ, 
> 
> Works for me.

Just call it VERW. If a separate x86-insn-like macro wants to appear, we can
disambiguate then.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

