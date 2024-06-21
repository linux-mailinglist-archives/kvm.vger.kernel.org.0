Return-Path: <kvm+bounces-20273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB920912605
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:53:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 760A82893EE
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:53:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2D8A155736;
	Fri, 21 Jun 2024 12:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="fFm4GIaD"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3D115530F;
	Fri, 21 Jun 2024 12:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718974352; cv=none; b=TC3u6y06EwASRQg+FVtqD55g658OYeA0UBtzUjzJOgHzUyc+XbRvKkB5HL91GzAA5qhHL08ZduaNrVUMTeIYiFQhlpA+mIAzLOackn/3Z8eAmGTqFuu4m789XeiqiIvoxNA/LVcQ55MaTd5DfzgAVSkqny4IvaWvMTZGQkHVet0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718974352; c=relaxed/simple;
	bh=sy67VyX+6tFDFqZPNJ6vHwDoUQkPVK7jzqNQ/cPNonI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eY0r263RZtM+3/J4karid3GVAIjRxkMfNv2xgkrBV1aPIs6pCqRjzWu++z3/mqklxJB0X84shuO79uiS57M7afIHXX9kpTcK7Aomk8vFkFZN08Yo3+Fn88frVAOhV5x3oPGh49YoFOpIcWSVY7zdJvfOnqeWajKe9RpkZHhRNkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=fFm4GIaD; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9C11840E021B;
	Fri, 21 Jun 2024 12:52:21 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id kwK4-fyUVF0Q; Fri, 21 Jun 2024 12:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1718974337; bh=kC3oXF4sjVIYJp+MXXYTe61sDbC5YEW3qf5CpMsG//8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fFm4GIaDaoAtB6sPLaqsK/9tlG0UrHgH0g5FzmWcKaxpINfx+YKSugCFLlQVZ82ID
	 29lt0ywXC6DMZ9dlbiav1oCOr1NSViy3y4EnIEKpFmIORxjwyBaG7vCFh9JotyER1J
	 QGlegpX9py5SBU7QaQOvZ+/HhIAkDoFwXIaj4RvTHF4ZEzLCh3TA7KrErJpZTPeNOI
	 BGyrsI65e1O0teO/dDqo1LHOnrdlWsdlO1ObilQc8vcAY9dUf6dm98KGX1PSu3ssUJ
	 xijPtw4zFjOkbK6kOHy9VWBJjUDcySZqH2zPOpIau8t5VNh07ZccpNGLEnbMqzFE2S
	 Bqnc0iTzm9bNKhDCNexopnHdnbN+SKY4aeW3v2sOpiECtaaEF+V1Sz2dZaEEBb+6Mc
	 tVaAmUtN08uC1CoMOVYwgrbyHxKayySxxxeGlthFQIpkNv15SRgJHFWdz9knAiqoJ9
	 lCyjh2xTfA7WzEVhWWyq0ow7ZR6MdEqsIibRHZeNgGO3vPueiyM7mcWzGe9SWJ+gH0
	 lJw2V07FHCJfp+5VckJejlnpbPXEnsxJ92AlxqhliqpSyaLqsoL3+iRj8jtteyLRdo
	 dPNXQsdoHqHZGvGGgHVZWFA9yIgs2BT8I42VbEDdl6Pfpu5RFHTfwKQshYs6OgW6Jq
	 k1q4LnZrXO/R+a7mnkC/zoN0=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 741EF40E01A5;
	Fri, 21 Jun 2024 12:52:04 +0000 (UTC)
Date: Fri, 21 Jun 2024 14:51:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: Amit Shah <amit@kernel.org>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	amit.shah@amd.com, seanjc@google.com, pbonzini@redhat.com,
	tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	hpa@zytor.com, kim.phillips@amd.com, david.kaplan@amd.com
Subject: Re: [PATCH] KVM: SVM: let alternatives handle the cases when rsb
 filling is required
Message-ID: <20240621125159.GDZnV3b-eqbkGTB7YD@fat_crate.local>
References: <20240621120743.59330-1-amit@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240621120743.59330-1-amit@kernel.org>

On Fri, Jun 21, 2024 at 02:07:43PM +0200, Amit Shah wrote:
> From: Amit Shah <amit.shah@amd.com>
> 
> This patch removes superfluous RSB filling after a VMEXIT when the CPU

s/This patch removes/Remove/

> already has flushed the RSB after a VMEXIT.

... because AutoIBRS flushes the RSB on VMEXIT."

I'd like to be stated clearly that AutoIBRS does that.

Otherwise, looks ok to me.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

