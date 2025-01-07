Return-Path: <kvm+bounces-34706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 720ECA04A06
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 20:19:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D6621887A72
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 19:19:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 585971F542A;
	Tue,  7 Jan 2025 19:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="bTRFZ6vH"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01C82C187;
	Tue,  7 Jan 2025 19:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736277531; cv=none; b=Ik6A51YNXG/X7DG4g92DMi0//fil9liWRZAc5JjFEDaJ23WnGPx75zRQ/LfRznHSg/ivWodOO76W8cEKsmqa9M7we8g071HcXuEHAyOodnZEIvRAG3dfALbyYEirtVKgBxk/WpIVlBNO9GWyzM7VSyLnUEz/eGNX18YKqDtvoIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736277531; c=relaxed/simple;
	bh=pf4T1KA9dyIQI6FLSJMWMXKrzTRr4aVg3C4YFsxG3xo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nb894qsanUEIq/tD5fnXgBfW9nLPLMNuINaQYtVPJclFuGlw5kps8T3oL0mM5AT1LfNwazIFo3r1IeZPFam1DLXcn16WZvrgWmP7u9BFozOZ+WfoF101Nn1ZKDexyxnsWRm01PtdUfA14Aur9KNoS1NYR5aU1jA5Dlf0gTzvGK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=bTRFZ6vH; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4823B40E0163;
	Tue,  7 Jan 2025 19:18:46 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id vhzHL-mDcHIy; Tue,  7 Jan 2025 19:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1736277516; bh=FkNommxVzqbl2dZNSZu6OCTTXjE/iHqycqmlNCUTG+0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bTRFZ6vHlCSXiFG6TCORqYwE2fUXxiZAv0F6BuY8o6w4Y9ubBOCMwWtIgr7NDzFKK
	 xcyu9BNelyGVKSd7AaAwKtFKKNyJAYUIN9hI4aeR+cuSIdsY9Aiyja5fdduHA3WeqC
	 i4zaWY0yMFr0DT9aK5ihA1m0GJt+Ncf6qy70nqfh3C6BEhTwYL75fSmjUh6+IfK/T7
	 kO/AXt0IqoTSsjqH+RBW/BpViWwcpnH7g46/GcoRkwr8IfFEemFqZvry4PuBowEEVV
	 G2/j52LO1lSbGy94Qiaf2sS6vHZj5p+Y7NO87+3fG5C+LVew2Cv6rg/EKH0pN5W/al
	 5kC1QIe+D1OShn+rV1mLroQBRzann4tD2Lw+G7lzCx/51T8js9O6uwSfxxoGGel6Aw
	 8kFCOQMqU9YMkutXezhcS5p6kn5Nm7WfAbL4XBAgVYKmasrbnb37l/rDgIStVgJBvx
	 Vvn3C9ZgaQI7qQaVu1IAkIMGUSq+iMQ9SwhycdHsRsFO5hiCe3f/sbxZtQzZMB+lx3
	 bZO1mtNrcDx/11FOVVyyzGWW3sZ8CYZCsaVdT9zhKPIaf/OSvNr4rLPaT34W64Ltea
	 coan1bWOkUhATv6yOw8+K9bA6afEu1UXjF71sy3+ed1jIAZd1M0DZ2MKEn2N6SMJvU
	 bGnqNraDCGmNyR8yn0xlcvd8=
Received: from zn.tnic (p200300EA971F9314329c23ffFEA6A903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:9314:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0D6F940E01C5;
	Tue,  7 Jan 2025 19:18:24 +0000 (UTC)
Date: Tue, 7 Jan 2025 20:18:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com,
	tglx@linutronix.de, dave.hansen@linux.intel.com, pgonda@google.com,
	seanjc@google.com, pbonzini@redhat.com, francescolavra.fl@gmail.com
Subject: Re: [PATCH v16 05/13] x86/sev: Add Secure TSC support for SNP guests
Message-ID: <20250107191817.GFZ319-V7lsrjBU8Tj@fat_crate.local>
References: <20250106124633.1418972-1-nikunj@amd.com>
 <20250106124633.1418972-6-nikunj@amd.com>
 <20250107104227.GEZ30FE1kUWP2ArRkD@fat_crate.local>
 <465c5636-d535-453b-b1ea-4610a0227715@amd.com>
 <20250107123711.GEZ30f9_OzOcJSF10o@fat_crate.local>
 <32359d64-357b-2104-59e8-4d3339a2197c@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <32359d64-357b-2104-59e8-4d3339a2197c@amd.com>

On Tue, Jan 07, 2025 at 12:53:26PM -0600, Tom Lendacky wrote:
> Yes, but from a readability point of view this makes it perfectly clear
> that Secure TSC is only for SNP guests.

That would mean that we need to check SNP with every SNP-specific feature
which would be just silly. And all SNP feature bits have "SNP" in the same
so...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

