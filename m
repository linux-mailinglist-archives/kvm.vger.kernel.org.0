Return-Path: <kvm+bounces-31989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C19EB9CFEBA
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 13:11:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 771391F239CD
	for <lists+kvm@lfdr.de>; Sat, 16 Nov 2024 12:11:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2477192B85;
	Sat, 16 Nov 2024 12:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="d6aaOxeJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9812D12C470;
	Sat, 16 Nov 2024 12:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731759082; cv=none; b=RlmoJCg0XVHGpZhqnxxCYGzVPiULb0qQocgxV9bagykzBb2q7vAvZ3+3EIxt0djf3CGsYilZF9APjgAD4KRXA3cvQ1nmcHCAsoHXBoFo948e4HPdcIXTj1EDTsUHbvZETBnXrriJxWePIAGgl0clOXTt+9Y7nQP1ggfuV/1HPho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731759082; c=relaxed/simple;
	bh=egQwIpjuW/D5jhfmjl0METYf/VduR4/1nUQkptqc3fU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d00lqP7d2Sg6UqSD3Lto3uCYvSgFIGr+Psaio0yXhOPjRHS50p7ZWn7k4uNzhLM+Pdsy93DOfJyAm2K222nKz8zK7RqVVmyXZg6jdlVdkEXAe8DMRKITJTLiCF28QiGY77rl0Yw8mr/3rGFZ5pkh6VLcfPgUSxfrowmQ5JiDYfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=d6aaOxeJ; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1376C40E0220;
	Sat, 16 Nov 2024 12:11:17 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id zYrIag-FvatP; Sat, 16 Nov 2024 12:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1731759071; bh=/FV3qTwRs7dOV8QYsBXwilOpUzqkxkccQB0xUkgyk+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d6aaOxeJ+AkFzCwKstKs79CbRsYgYzl+zA0X2N1q2TB+XfBD/5kKefHLu5nSD49Rf
	 urATdBC45fsgPFC3piBIZccSDEs39uobqebQ4XN1v+SN3WS8r09LqQIS/lyBfl1kbC
	 TD7C8vfP1sngqU8WyHeoOe6vLtglmdLGdF8J2f7TRqUCe/BTvJ6OEt7lzf/WeA67f7
	 9nJPufr5BH1U35qOhhqb3FE/CPrzVbMH8xE76mk6f2fUs7VGVYHbLCqutoRAntRHMd
	 HUqpsA0xBmUQD67SLylTT3ZedL4jJqvOEAw1bI9g79OofF2+CBPiPpSOfFKs2WWEfP
	 5HNnQKwMA+ea5DECtTUz0fbckHmIS8Z9Jtv4vLm9xUoUedZ26pOPB6soJMoeGdYbs1
	 FzW7ZriQj1SBm/PFnJHFeAmvG6Jl/B8JbF9JOeZcueI79KQ7c0uO7gsyDZr/E7uGJK
	 O6K+4e+jrFQyNcgmtyhll4JmvI0/N0j6bhtjrI6LWr1IiUcW7H86oEwj65Wcy2wcJ/
	 /tYLeHThYiZJQcDO98PKKd7M3Rn4aWgACLHflo+rk7t5bV1tfPFs91dbpudbXYWBCV
	 WiRu8P/R/f4dwCDEqMzC6va7pvQNbEVzzrbas9JJ4w2gJYUHULV+eNb0+WcnQLBv4c
	 tYQU3OfLLACdcO4zOAkGe3MU=
Received: from zn.tnic (p200300ea9736a13e329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9736:a13e:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E8A8240E0208;
	Sat, 16 Nov 2024 12:10:58 +0000 (UTC)
Date: Sat, 16 Nov 2024 13:10:53 +0100
From: Borislav Petkov <bp@alien8.de>
To: Maksim Davydov <davydov-max@yandex-team.ru>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, babu.moger@amd.com,
	x86@kernel.org, seanjc@google.com, sandipan.das@amd.com,
	mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	hpa@zytor.com, pbonzini@redhat.com
Subject: Re: [PATCH 0/2] x86: KVM: Add missing AMD features
Message-ID: <20241116121053.GBZziLzfKuQ7lyTrdX@fat_crate.local>
References: <20241113133042.702340-1-davydov-max@yandex-team.ru>
 <20241116114754.GAZziGausNsHqPnr3j@fat_crate.local>
 <4d58d221-5327-4090-926e-a9c21c334ed4@yandex-team.ru>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4d58d221-5327-4090-926e-a9c21c334ed4@yandex-team.ru>

On Sat, Nov 16, 2024 at 03:02:47PM +0300, Maksim Davydov wrote:
> Yes, BTC_NO and AMD_IBPB_RET are used by guests while choosing mitigations.

How?

Basically what the current code does to do retbleed or IBPB on entry? Where
latter means the HV allows writes to MSR_IA32_PRED_CMD...?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

