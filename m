Return-Path: <kvm+bounces-31811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96D9C9C7DB8
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 22:38:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CD0D28260E
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 21:38:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F5D518BB84;
	Wed, 13 Nov 2024 21:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="jvNdBQLx"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF18A1885A0;
	Wed, 13 Nov 2024 21:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731533896; cv=none; b=TY1RmMtL/Emi9C6hls/ZDMUHONRmgbbeYlHX4bnf9+2jeY4ZMtFvuhKBh69Air2KydOm7Gn2dZ2fE5ZtSGR1LJYVn2X2w7b34mAXPowXPlYC+C1DG5A2wc7fdqavvqfkN1+IQGCy0xcF15lCVnnp88ej+KnnTuAkqN5tGwDJir0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731533896; c=relaxed/simple;
	bh=8L8J70hf2Y/mAspTSsmcFL255gESOKlAA65yLG0uyTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DJJ3dmq05sRmlqy/CkfC/E3ButbTvMvlj9MSW83wDYQK9KnYowMZjcXG/GokzfZyavWcHxa06Rmlk1XAnDI1edqMooS+fMXX2NvSWUD1jt73GUfFr47j4wTrc6xuOnxWRGMZr69wO6eJoWm7EekBVd4laX7gYjAxLlBYuJRMsq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=jvNdBQLx; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id EB5C840E015E;
	Wed, 13 Nov 2024 21:38:03 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id yFzOMRc6JvpF; Wed, 13 Nov 2024 21:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1731533878; bh=NZCMLtfVZdHoMFJ0ejzOMzzP2EZVeEmj1gX1lmvPPwU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jvNdBQLxh6OZ3lk3MJqxIZO1sdjCbFDAGcp+PRjptEojiz+RVfQ2DaXE3sp1BPbJG
	 K+W5yoJCgSPBRIQyOBbcwDfLU7Oti76XChecSmCBboGrfw0h5D9RpCdREoZp7N7yEe
	 EnGfuyCBtKYvAovJ59aqp9o6VahvQQiXDynbKV7WAoeeMBOpcSkuWlge8ZQTL4yB7+
	 U0S0mnxiUcEQqcOtXgd86mUS4NYcPNeDDz4q/8qVFLMY5MWTkfTeZllZftGleBAeYK
	 V8epK4sM+R4PyR7OVgT34PtjFH0VvVmXd/eFJf3pB2zIGnSvwwo0BJFFh2oz65CDnO
	 aw6/La3LwL+97P2PA74bm7Vn43qEKLy9GlgW5DITBOG8UqvgWI0D6DOV7muFZaXMF3
	 AhMQktbvhT2SYAnacegQ/r7tr2/DoMc756SRlsfNCykhZCtKxVV8uf8eQQJp+1F4Il
	 JOUHm0pyUhEfZ8YmHcOKA70xBHhK35cWTLjjqV+a3XECWfy3jZJGupUxkGlv/DGfkv
	 vvKQlysMbJNU+nKtQofC8ndbqTd3TvGyETwVAWRt2ZZlQo9unTkkrAX5nqTJDLN8nA
	 b4L8QcYDxBaJVfEgaY2jGECoGP690tp8g5/9EPTb2B+6ZB2sZcJNqWgDQiJvwlLcgn
	 k7uJmVLtEegGMkcQb3hsoNQg=
Received: from zn.tnic (p200300ea973a31a9329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:973a:31a9:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C031240E015F;
	Wed, 13 Nov 2024 21:37:32 +0000 (UTC)
Date: Wed, 13 Nov 2024 22:37:24 +0100
From: Borislav Petkov <bp@alien8.de>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, Amit Shah <amit@kernel.org>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
	linux-doc@vger.kernel.org, amit.shah@amd.com,
	thomas.lendacky@amd.com, tglx@linutronix.de, peterz@infradead.org,
	pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com,
	kai.huang@intel.com, sandipan.das@amd.com,
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
	david.kaplan@amd.com, dwmw@amazon.co.uk
Subject: Re: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Message-ID: <20241113213724.GJZzUcFKUHCiqGLRqp@fat_crate.local>
References: <20241111163913.36139-1-amit@kernel.org>
 <20241111163913.36139-2-amit@kernel.org>
 <20241111193304.fjysuttl6lypb6ng@jpoimboe>
 <564a19e6-963d-4cd5-9144-2323bdb4f4e8@citrix.com>
 <20241112014644.3p2a6te3sbh5x55c@jpoimboe>
 <20241112115811.GAZzNC08WU5h8bLFcf@fat_crate.local>
 <20241113212440.slbdllbdvbnk37hu@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241113212440.slbdllbdvbnk37hu@jpoimboe>

On Wed, Nov 13, 2024 at 01:24:40PM -0800, Josh Poimboeuf wrote:
> There are a lot of subtle details to this $#!tstorm, and IMO we probably
> wouldn't be having these discussions in the first place if the comment
> lived in the docs, as most people seem to ignore them...

That's why I'm saying point to the docs from the code. You can't have a big
fat comment in the code about this but everything else in the hw-vuln docs.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

