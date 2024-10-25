Return-Path: <kvm+bounces-29705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2748B9B017F
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 13:42:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A97B0B21D5E
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 11:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C308201016;
	Fri, 25 Oct 2024 11:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="VUvvfTl3"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4498A1B2188;
	Fri, 25 Oct 2024 11:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729856517; cv=none; b=jrxdEwe7DG8h5+D2Gukogr84ShN2i6qsjwuqV+gkWvA7xcfvwGmptKFE+GwbEHK9t7LsRo+Au+M/KGxL/JBbv7iKHC0KXEoRmlVQJTeEb4/aIncxtl2a8sE774XBfIXzUSqfBLrnfAgqfzEYkIpXLARFPgyVCWKVa0Xx1hhgg5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729856517; c=relaxed/simple;
	bh=Xvqkf/asTk+xvugY/Synw1frFp3ETPl8Vv3kSv7+P6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IbK5ZQZ67UhofOKVLMYrV13pnetgjCD6iaubGdJxKFIhC64AwUUo1T2YmP5UkcUGoNqhXg2UrEpmy2rf/bkGENTnOzbG3JLfKXEIa0ZV5/MfX7coHxPmZ6HjUDQ4EZmm4dwY0MnvBM+mNrAknHOBqDAm18cHWb7BOjdsniHGHQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=VUvvfTl3; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 9CFA640E0169;
	Fri, 25 Oct 2024 11:41:52 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 7weFIKA90ptE; Fri, 25 Oct 2024 11:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1729856507; bh=W0DVzmPMFN972kQ5XLuL9QZ110lUVLY1NfnDbsO27vM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VUvvfTl36/iLQrTzO5mk38ABMVHvX7D1AlYONVrY9//XOjKpvM3njLYRHkgJaguEB
	 C8WucBdKQreWh75tuPNXus5lOR0V8ou3Zn6xouq5uk42zdLdL2I91MRk1HupN8XYiU
	 Xxw9QIY3r5zG7CJ8N7SXit6dvzKUSk8h0HIOu+bwvgs9odmtLxo1tvJOPG85zUF5Iv
	 yj+bhvNt/OncsG5Ywdxk40l2OoJdOxD5pOMCNz+ix/9o8+bq5wlyMNHUaRcxXKbXh2
	 JWf3b/tezuCnzTuXJrAb9CQFE4PUT7K9Vpw5+np0qRGW8ysfyUDzyujapMwulKBk1R
	 bANta0GGBwopuR8trRMHKGEohjMN8XTwD1Qaua0FJSU0wRBgTxE6ucnXL1x+RvBOax
	 YRTYE6JWAXnnAegxJxhYc8r6aNVMnykeeaGj92ZeAIEHH/5IE+y+/2CFSvL8a6Py7S
	 UA0GYeYYVOB85aT4YYQV1jJlCF8KbJj+JEBrlcblpiUtpcd0IsIdvrWj5S/FDe9iCa
	 sYPtIH7SluBZpS3+Ej9kpuhMSdP/MtWYaP2rpLEVY1ADKUOCx5+V0W6YBCXAkiFwwU
	 v1wxze11USbY5gLRrt01ii+E0eqIIdvQewW8uoZw+qn2jHIoKdD6VVLUkJiHwK78Mt
	 AshtcaC+ocOAcj8yqhmbTdEE=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3CDC440E0192;
	Fri, 25 Oct 2024 11:41:06 +0000 (UTC)
Date: Fri, 25 Oct 2024 13:41:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: Brendan Jackman <jackmanb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexandre Chartre <alexandre.chartre@oracle.com>,
	Liran Alon <liran.alon@oracle.com>,
	Jan Setje-Eilers <jan.setjeeilers@oracle.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mgorman@suse.de>, Lorenzo Stoakes <lstoakes@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>,
	Khalid Aziz <khalid.aziz@oracle.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Paul Turner <pjt@google.com>, Reiji Watanabe <reijiw@google.com>,
	Junaid Shahid <junaids@google.com>,
	Ofir Weisse <oweisse@google.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Patrick Bellasi <derkling@google.com>,
	KP Singh <kpsingh@google.com>,
	Alexandra Sandulescu <aesa@google.com>,
	Matteo Rizzo <matteorizzo@google.com>, Jann Horn <jannh@google.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH 01/26] mm: asi: Make some utility functions noinstr
 compatible
Message-ID: <20241025113455.GMZxuCX2Tzu8ulwN3o@fat_crate.local>
References: <20240712-asi-rfc-24-v1-0-144b319a40d8@google.com>
 <20240712-asi-rfc-24-v1-1-144b319a40d8@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240712-asi-rfc-24-v1-1-144b319a40d8@google.com>

On Fri, Jul 12, 2024 at 05:00:19PM +0000, Brendan Jackman wrote:
> +/*
> + * Can be used for functions which themselves are not strictly noinstr, but
> + * may be called from noinstr code.
> + */
> +#define inline_or_noinstr						\

Hmm, this is confusing. So is it noinstr or is it getting inlined?

I'd expect you either always inline the small functions - as you do for some
aleady - or mark the others noinstr. But not something in between.

Why this?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

