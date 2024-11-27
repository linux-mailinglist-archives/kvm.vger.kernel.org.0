Return-Path: <kvm+bounces-32553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F37AC9DA286
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 07:55:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6E82DB221A7
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 06:55:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E0CD149E13;
	Wed, 27 Nov 2024 06:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="Z6rAP/ZC"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2128C13BAE4;
	Wed, 27 Nov 2024 06:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732690537; cv=none; b=WUUO4pGZ2pa0HBUTg7qH4ILq81eA4VbuE2N0I22ig5SJcK2i0HRPz8qu/qPrzN6FOU2C9jNrk7g40GtTsaRjZwttxFGco2W7aqqWSi+URPJLI3xYqyxvTew3rwSkirF2BYh1E4j92IE7Qjf+oMb+z1EFA1KKq7xwkfcF011QbnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732690537; c=relaxed/simple;
	bh=UB1y1AA0qmWXHxMam6cy0LFVwd0LvVorrbc6xiz7mOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BwGQCh3z03mGUTlyajpOpY6v9crGGro4i1CfVU3ZDUCpOoM2tUHgSb19c/yyVnhYS2OgbLIj1xsLgy9TACzYaVPxx57lcYbH1o9vGTbPn8/Vcpeb5LKtVeyrnpsC7HJa4/naO0XZ2E7EEfan/9iWWCKyvVzaUR+6uSSV8MUJfR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=Z6rAP/ZC; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4140A40E015E;
	Wed, 27 Nov 2024 06:55:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id hhQ5_UjZPbXo; Wed, 27 Nov 2024 06:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1732690527; bh=NgGatvZw6gjPA40roIhorBC9q4pXK57dJ3T9T+thf6Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z6rAP/ZCcdKlf6Zm7J1yfXHs3V4A3idxKW7S7Ta7WuP3WamlypjvFoANTkEPLMbAV
	 BMlvyt9DLpjWv/gh+JT0+VRpWD+BnrLC4wSm0zApat6IA9wSHB7J/h+9eW5CWqlVpF
	 mgRmohTAyyUsHqGlwvtkGttkuoyscp4xPZlLWbfX8IPh9uttI884saa8aMATIvHPdg
	 bLc9nzkcGdgy7sUqN2AYrCcm61PLPUz2wp1DVdzIxtv2yB4tZTXt7dY3VKjkqizN8G
	 BOKBszT2R7EeOxsSbWZY0ms0zhsWY32w9qtNpaSW/kOCoh3vA47s0Cp2QWt7pUDpjz
	 iaP3GHNOksNCEefN3His8z3bpVokA2NWytPqWXP+1+0Sbp9cR/u6NAuYvx/ZSnSJmv
	 aLwHAjmy7eSOax8zUWhmuCnOhkv/jXYip9hJ9MHwIYUF5rjuawd2Dmt/7ZlXFVE4RE
	 ZnqX27vN9/ENmeXjwaMcNSVzN7VAResHbQ87fhn+7kOYSZvi4EGTszNsYmMvkXfQ3T
	 YYPO/9jSIJNifLxvHdE4Guc5/zueQKhspwUIEwvYOlLuAkZss0orEq1bwZ02xpB8Nd
	 qNKrpMr6zxIfxD3D+UMeNwRLj+K5AA15kQrxiqezRab2N5yrWgeh+szMuV3uwkIS/p
	 NR5VrcDjxafOQZezYUdqjBso=
Received: from zn.tnic (pd9530b86.dip0.t-ipconnect.de [217.83.11.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B351A40E0163;
	Wed, 27 Nov 2024 06:55:11 +0000 (UTC)
Date: Wed, 27 Nov 2024 07:55:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Xin Li <xin@zytor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
	corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com
Subject: Re: [PATCH v3 09/27] KVM: VMX: Do not use
 MAX_POSSIBLE_PASSTHROUGH_MSRS in array definition
Message-ID: <20241127065510.GBZ0bCTl8hptbdph2p@fat_crate.local>
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-10-xin@zytor.com>
 <20241126180253.GAZ0YNTdXH1UGeqsu6@fat_crate.local>
 <e7f6e7c2-272a-4527-ba50-08167564e787@zytor.com>
 <20241126200624.GDZ0YqQF96hKZ99x_b@fat_crate.local>
 <f2fa87d7-ade8-42e2-8b2b-dba6f050d8c2@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f2fa87d7-ade8-42e2-8b2b-dba6f050d8c2@zytor.com>

On Tue, Nov 26, 2024 at 10:46:09PM -0800, Xin Li wrote:
> Right.  It triggered me to look at the code further, though, I think the
> existing code could be written in a better way no matter whether I need
> to add more MSRs.  And whoever wants to add more won't need to increase
> MAX_POSSIBLE_PASSTHROUGH_MSRS (ofc unless overflow 64).

But do you see what I mean?

This patch is "all over the place": what are you actually fixing?

And more importantly, why is it part of this series?

Questions over questions.

So can you pls concentrate and spell out for me what is going on here...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

