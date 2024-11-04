Return-Path: <kvm+bounces-30437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 622F39BAC0A
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 06:19:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93DA01C20B96
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 05:19:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5996D186E5F;
	Mon,  4 Nov 2024 05:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="hlFyOMn3"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC1C158D80;
	Mon,  4 Nov 2024 05:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730697583; cv=none; b=K5Q7AREA1tZeDV52xAxBLYCjaeUI2F4FnF9WrDUrcidd591R9SydLmSPn52l86EQJlF2+b12mmv+gW6KtrQluYf6x0K3svNPR2RHnBUvz9wlF6oBALI5cA/hHxjW57qWMCUwzF7kaqt1ABLOP8Ty5cQi8A1ZAgo+TbRrrBe9Ie8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730697583; c=relaxed/simple;
	bh=xoxCS8iKpWugSye0PZV3SEOikbY85j123h7jneBI664=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EFgU8lrk+jPgAeWSNWa+WoXQYK5RysqcCd1dIv2J+9l3k3OsfLWWW9GGWj4kvSC2HKLl5khG+93UBXb7nB2FdyGelVcJt03vAYIFcRcbpXq/qNbO/4h3jUvFExgaoaby0ZbsLb7tsYWcUKIJchiHwkDLP4h22eVkS1a8DYsjCoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=hlFyOMn3; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id B34FA40E0265;
	Mon,  4 Nov 2024 05:19:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id HUB403dSBHRM; Mon,  4 Nov 2024 05:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1730697566; bh=uvRLGH51BTjpJDWX+PnWENMXUIuW2j1cR0NDXCI5sxQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hlFyOMn3B21Vm9sfKaibxSCbdjYu+HVu23itsYF/djgAkuxtAUt4v0KhdJroEFjd9
	 h2Ina0pupP63hYyxlh60f3M+ZoaKpAvTxD4CFz+94PukFjTRSMOfcN1NQh3wh+Nyha
	 tJ9gP//r0QyDJQGdB6agAfUYJzmgbXCW2E87f1vTB5gsHxh8nFkqWyMNX0dA8QFn6x
	 jFx0o4FKgltKf2O5Rx0DWdJ0BNh3o9uu3A9iUpKAWX4mdYIC85hxxgVQIE7ypEtxji
	 kIQdTBnNRkgsYhWbtpPW77gTrQUXKk8GtJ7OHQDyQ+inz6pqInhaWwqNdskyzl1A6E
	 rKPvC8f7RMUiZJy9HgU4Z1QrMtNfg4cmYKMMo1fMZ6Hn0yocUfu9ZnGonlqKNdhNmS
	 irfxGsgKffjf7NoQ0yj9yblMI1GafPg8gNNDfiWPDbYz8CNGJw9uwM4KWxLzyRuoQK
	 hLJnmGZoGHLr+4kQpJKMz6PCNIE5rmo73tVY3NMw94s6AQi0hzXuitHLzuWu20w5az
	 XxEAA8T7siQHG1l+O0w6/HxfsZCx9QKJtKcPvTZjkpnDXKUTSNUfxwkSSVvFmeO7ch
	 tlCKZyLq6rypVV2gdt998UlC0qwr+YaPhwWEBVDwlERd6tjL/uIOoRgS886GN4owoq
	 YIKZ87XunBzon16SsftJdwSY=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 17C1040E0220;
	Mon,  4 Nov 2024 05:19:03 +0000 (UTC)
Date: Mon, 4 Nov 2024 06:18:56 +0100
From: Borislav Petkov <bp@alien8.de>
To: Amit Shah <amit@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
	linux-doc@vger.kernel.org, amit.shah@amd.com,
	thomas.lendacky@amd.com, tglx@linutronix.de, peterz@infradead.org,
	jpoimboe@kernel.org, pawan.kumar.gupta@linux.intel.com,
	corbet@lwn.net, mingo@redhat.com, dave.hansen@linux.intel.com,
	hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
	daniel.sneddon@linux.intel.com, kai.huang@intel.com,
	sandipan.das@amd.com, boris.ostrovsky@oracle.com,
	Babu.Moger@amd.com, david.kaplan@amd.com
Subject: Re: [PATCH 2/2] x86: kvm: svm: add support for ERAPS and
 FLUSH_RAP_ON_VMRUN
Message-ID: <20241104051856.GNZyhZQOvGlcWFn8Ey@fat_crate.local>
References: <20241031153925.36216-1-amit@kernel.org>
 <20241031153925.36216-3-amit@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241031153925.36216-3-amit@kernel.org>

On Thu, Oct 31, 2024 at 04:39:25PM +0100, Amit Shah wrote:
> +	if (boot_cpu_has(X86_FEATURE_ERAPS) && npt_enabled)

s/boot_cpu_has/cpu_feature_enabled/g


-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

