Return-Path: <kvm+bounces-32541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 310959D9DCC
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 20:05:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFF5B16881A
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 19:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 560491DE3DE;
	Tue, 26 Nov 2024 19:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="MAYnPjo0"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146271DD88E;
	Tue, 26 Nov 2024 19:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732647921; cv=none; b=ur7JEBGLqjX3nwzF84EO5kBdTllxDGNWhIYrFO9ks8X7OLJdT77gETVGYe91uWokUrDz20nPjbyj4bglB3tj2/HzCID/U3H5PNRBagE+42jtpKOJCpeExgX6a3smgTTzbQxdJAf67xWy+yN/QOadWuWV6OMCWq2TyOI0D3t5nLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732647921; c=relaxed/simple;
	bh=B/zcRTujLsW/VkO9PiY4m3dGPvpntJBVz+tlHcfNb64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YtJMSgWTDOFH6KoDvnyJxiLT/0TAUQZnDP1l+D8HYHt1BLZD0ySuNshATFedHub8RR7EjPaDYG63l2EBllNymcljtNkivow6OW4suEDboiwQmWxrvxZ0eqYHkSjWS05pQetUAY5trWmz/BV1nq7fJGG7oHwavF5COtEPL8z6RhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=MAYnPjo0; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3D4B140E015E;
	Tue, 26 Nov 2024 19:05:16 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 3jZrDcgUY59t; Tue, 26 Nov 2024 19:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1732647911; bh=KXq8e1dhskd/45vcolUOcVJX3TmXOUzD9iPElXgvT8c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MAYnPjo0vve2LTsftkKYPtRcImDwc/4PTOWzOSS2V4M3E0arRODlepFpu6ioIbiay
	 TRxyues1NxxvnLCLO29FddeoD1kG7r7MdygGx1PoXV7Fh+ZGuEOvW4KBuCfC5BFxuk
	 +z23CgKB6ZwQRA6Mk5NzR0rvs1/5lM/n0J5gNuymCOg1o7sLwn6iwDnyiZU7RoCgBS
	 UXvPwRQ86DvLQeMAFH4kji6sm2rlejWZZthqF/OUKjjDNGEYa9krcZjpNvoZ9XGCh9
	 1PVFyUNNRXDQ2M/DsrN/4KLfPpykfkoG20+4xIsBw+BmdUmeel/2nI6uKFxOFkZyic
	 PoAk24IvXgYsGQhaDZ7eXMHzd9c2X1V5TTnfyj7SqddXKko8A1dzHrZ12kw8IYrNmt
	 /LBiEBJ6D8csmcvU+VjhF0W3qnVgrWLAKOYdJn/OOlLUtBc6+usG9zrLU01xCuVnQn
	 fSWJIoCfLQPVb5132YZkAy+DXZw+DvyjkqaBQ9LF/qhYon0ulG8XHrb//Yg97k/qIr
	 EttUIsqtltBViyTkCK6no9YepDuWNv94dCDsmmS9iCuCLE/bGw4b7evlXLwHObroR9
	 UjY3ZHYW3XMMKa3Th6+s3KwXCdmkyi9xvnqkOxpk1OkqZIMubpLfZgY77EXhNbeksp
	 ogB/WRlYR2CGpZEq5dRmX7js=
Received: from zn.tnic (pd9530b86.dip0.t-ipconnect.de [217.83.11.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4297F40E0163;
	Tue, 26 Nov 2024 19:04:56 +0000 (UTC)
Date: Tue, 26 Nov 2024 20:04:49 +0100
From: Borislav Petkov <bp@alien8.de>
To: Xin Li <xin@zytor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
	corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com
Subject: Re: [PATCH v3 05/27] KVM: VMX: Disable FRED if FRED consistency
 checks fail
Message-ID: <20241126190449.GCZ0Yb0SOt09XD4e0d@fat_crate.local>
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-6-xin@zytor.com>
 <20241126153259.GAZ0XqK92lqgV7a475@fat_crate.local>
 <81ad0623-8d9b-4f74-afd5-1ecaaa92ec77@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <81ad0623-8d9b-4f74-afd5-1ecaaa92ec77@zytor.com>

On Tue, Nov 26, 2024 at 10:53:17AM -0800, Xin Li wrote:
> Already done based on your reply to other patches.

Thx.

> There is a lot of boot_cpu_has() in arch/x86/kvm/, and someone needs to
> replace them :-P

There are such all over the tree and it'll happen eventually.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

