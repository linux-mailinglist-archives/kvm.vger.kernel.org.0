Return-Path: <kvm+bounces-32539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D0669D9D13
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 19:03:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEAD7281B6E
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 18:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6919A1DD88E;
	Tue, 26 Nov 2024 18:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Zidi2ytE"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53B2BA3F;
	Tue, 26 Nov 2024 18:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732644205; cv=none; b=DbilFGQsX9kmu70Nv1avLhVkLadldexoBKmSV33uGtIREOp+RK3VhFdAAyimojTcEK9ob9W+UrJJdYpfvEMao1O+s56YXKWCaLLDRuOdvhZpOS9HgrCAnX31XMXuV5J8HloNM3O3iz8kJ+eRNpgxRRSAbZy+2TWfttLSSMIPfYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732644205; c=relaxed/simple;
	bh=pdTTYo9kWZLupUThwzWLuDxQW1iSfan8aDIdO59wlHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Emp2do7jzZt3Zm1E5EN2pJOkooo//OJ1n7Kg7Gp9I4QmzMV3cQEIqYre59xwq03t/E7eEsjr4oMGi+vQU0Fq138rFJH/D2qLGLUur9itukJS84bNmytTn3w9boD8D3YB0VabsMTHeAbatRpsK9s4qKASUF3G6TD3dcKXao7utYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Zidi2ytE; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0D33440E021C;
	Tue, 26 Nov 2024 18:03:20 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id f21JIecHF2Fy; Tue, 26 Nov 2024 18:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1732644195; bh=Bsaddr8mpxbj3IJtqOhkqhnOoXM0E17G8MEuaDojGgE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zidi2ytEhPpWQcHKUSX8k4v//KDnDq+1A7lILhnoHDD82yxmurlw3wsUwKCKvGadX
	 BJHnNhX9vjnnL2lXTavQ2A9GkxXUChuQ+tUMMof0JnL/tGKvnPHi5dxEB+o7vZYH/2
	 hM101JTChjbT7fvWRckcwj1c0NM1ZLrkwuedb3gYQ4WtN7ZD/WEALcRsZGb4k5ifcp
	 3uBk9lYqd9H9ZFZq7x3Vj97IbhfLa6I6NYkHw5zR8wM4AX7NQ5aAb4d1XZvKjjKviy
	 X0H5RP4h2tvDoXxgH8lkdWY+ezJSExpEm2d8KH0joDt+Qhhud6IkcT9phY/scZABG8
	 4+dOWfwJnNhWztZ+iC2cDLBKoOAiCzzdgUAPIugzUQMj6qN335cVlF/7Hzb9cluRY/
	 kmORErgng+wwhs6iBn+vpPg5Pyu2iiCN1k0NiKsncyQSJ5zWYL6y9PHymUsLHZrpAc
	 EOhc4VRzep6tHukAX3OZaYzd4ogPcEXyecInHuUIauPGTaisd8mYeWtlb1saX68DRJ
	 b3wGKvUgrDUSV2Cz7gQmx3UI67K3bhF1Hcxs7DcquXJgpzWzMS5DtHsR7TH1wzDKnL
	 fz07IlPkpJPw0dKDNISrwdh88526n64ur20yV79VFXG7AleySGeO8L56NPncC/LKM3
	 0bRAmvpTyg+vELArFUkKhNJY=
Received: from zn.tnic (pd9530b86.dip0.t-ipconnect.de [217.83.11.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C0C1740E01A8;
	Tue, 26 Nov 2024 18:02:59 +0000 (UTC)
Date: Tue, 26 Nov 2024 19:02:53 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
	corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com
Subject: Re: [PATCH v3 09/27] KVM: VMX: Do not use
 MAX_POSSIBLE_PASSTHROUGH_MSRS in array definition
Message-ID: <20241126180253.GAZ0YNTdXH1UGeqsu6@fat_crate.local>
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-10-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241001050110.3643764-10-xin@zytor.com>

On Mon, Sep 30, 2024 at 10:00:52PM -0700, Xin Li (Intel) wrote:
> No need to use MAX_POSSIBLE_PASSTHROUGH_MSRS in the definition of array
> vmx_possible_passthrough_msrs, as the macro name indicates the _possible_
> maximum size of passthrough MSRs.
> 
> Use ARRAY_SIZE instead of MAX_POSSIBLE_PASSTHROUGH_MSRS when the size of
> the array is needed and add a BUILD_BUG_ON to make sure the actual array
> size does not exceed the possible maximum size of passthrough MSRs.

This commit message needs to talk about the why - not the what. Latter should
be visible from the diff itself.

What you're not talking about is the sneaked increase of
MAX_POSSIBLE_PASSTHROUGH_MSRS to 64. Something you *should* mention because
the array is full and blablabla...

> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index e0d76d2460ef..e7409f8f28b1 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -356,7 +356,7 @@ struct vcpu_vmx {
>  	struct lbr_desc lbr_desc;
>  
>  	/* Save desired MSR intercept (read: pass-through) state */
> -#define MAX_POSSIBLE_PASSTHROUGH_MSRS	16
> +#define MAX_POSSIBLE_PASSTHROUGH_MSRS	64
						^^^

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

