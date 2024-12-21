Return-Path: <kvm+bounces-34277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 92D709F9F94
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2024 10:14:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C1D1188598F
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2024 09:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 077511F190A;
	Sat, 21 Dec 2024 09:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="DKFenMMX"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F021EE7D8;
	Sat, 21 Dec 2024 09:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734772425; cv=none; b=Ax/PHLoDVNxSNTIIZ1xGbr6HGJ0o6CaISOBJ/6E/VKA+xMButJQaW7zwQCsvWHKmHjC2L04R9WU17eht6OGZNQZj26do4XxEiBQ3fdjsvHWaNnuR95PYWxZUzDIZ2LV0ApDywcJ61yERXpmfTSrzFk7wrsCFJKKA7i3BTQHwz60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734772425; c=relaxed/simple;
	bh=jwhbVVy5x9KOUNzFAy26thYoNFh2zn5o9tfZg3OUQxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oxPI8dCNIOIskA+ca6Pparib9/BhfbP3jnLKaRmM0E/qiyOkHS8u4U1hupo2z2OHLdOWU23o9UfGiZEcvXua651wZTzePDbULd/TpbAQiN4W7DR9cWeyVh9MejKsHMmjtEbEjLp3NZaPdG6XN/ZO+2JHOYi+LBjVBbVpDxqFFxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=DKFenMMX; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 94B7140E015F;
	Sat, 21 Dec 2024 09:13:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id xkmdq_0uuHUI; Sat, 21 Dec 2024 09:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1734772417; bh=GBbnq6RLYfEGx3TrrPKpgrWKUH1pskvqzUeFhNPscNY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DKFenMMX/ateXnZ1lW+mj4YQKofF8uD7yWAIdSOcdAEa8QH4cdAzhQ4uXLeQOfxTu
	 rPmkhMcMDD4eTHOGL8IHrXBKW2rL9P9Why2UtdhM+iZDwY1lS/bVdaN23mcifWKP+Q
	 TlIicCGS7WomKvMKygrugCFNQVw15YWtTwzuCI6iIIlj2p05H/q3WqNTTssL93/QaW
	 rlHcWGISPYTLj7DgrtKw3ytFR3VG0/+FQW9iJtjNB8Om3A2Xe/XEx/87qo964qv0v/
	 gyxYVq7QtgHFsTXAY/Uqo7RAN8KUiXDsPSsXjAWv0iG9X7QHz1aJ9r5NRjT60HB+xW
	 fVavqy4UxnmGXqJz8FmmkEeBrQoEJqLbbFOnG+RMMPKAA8vQv1HnMU9pKr1S1urUVf
	 hH9g3A6rBW6zkCm3HP9aywkZZ9lAZpLUmi/9EzODNXs/v/9hs39YfcV2ecyrxUWXQt
	 T5fyeqe0+3ugL5GwV4+50/G9N7XQUNdhb5pt7jpMmR8ot3PvkSACdrYUV4mWqvQHA7
	 MyzdEeg9cCGmH/HwpMTFTvQkNw0njffC3fsPGGpVWIac2oG2FhJuq8kdPZLOM+bR9r
	 VqOsIWC8U76PvqXZUOZ7HTC/iyLeirhNSRkMHatb0D4DJp3+VCnzopK1O2HNsFhDAc
	 jXetpNsfh3my1JH2r4pejhSI=
Received: from nazgul.tnic (dynamic-176-005-148-127.176.5.pool.telefonica.de [176.5.148.127])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F1D5B40E02C1;
	Sat, 21 Dec 2024 09:13:12 +0000 (UTC)
Date: Sat, 21 Dec 2024 10:13:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, amit@kernel.org, kvm@vger.kernel.org,
	amit.shah@amd.com, thomas.lendacky@amd.com, tglx@linutronix.de,
	peterz@infradead.org, corbet@lwn.net, mingo@redhat.com,
	dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, daniel.sneddon@linux.intel.com,
	kai.huang@intel.com, sandipan.das@amd.com,
	boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
	david.kaplan@amd.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com
Subject: Re: [PATCH v2 1/2] x86/bugs: Don't fill RSB on VMEXIT with
 eIBRS+retpoline
Message-ID: <20241221091311.GCZ2aGp1JeqKBL_PzL@fat_crate.local>
References: <cover.1732219175.git.jpoimboe@kernel.org>
 <9bd7809697fc6e53c7c52c6c324697b99a894013.1732219175.git.jpoimboe@kernel.org>
 <20241130153125.GBZ0svzaVIMOHBOBS2@fat_crate.local>
 <20241202233521.u2bygrjg5toyziba@desk>
 <20241203112015.GBZ07pb74AGR-TDWt7@fat_crate.local>
 <20241205231207.ywcruocjqtyjsvxx@jpoimboe>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241205231207.ywcruocjqtyjsvxx@jpoimboe>

On Thu, Dec 05, 2024 at 03:12:07PM -0800, Josh Poimboeuf wrote:
> Ok, I'll try to write up a document.  I'm thinking it should go in its
> own return-based-attacks.rst file rather than spectre.rst, which is more
> of an outdated historical document at this point.

Thanks!

> And we want this document to actually be read (and kept up to date) by
> developers instead of mostly ignored like the others.

Good idea.

Now how do we enforce this?

We could add a rule to checkpatch or to some other patch checking script
like mine here for example :-)

https://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git/log/?h=vp

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

