Return-Path: <kvm+bounces-33327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D4C99E9AFD
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 16:57:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5C1C11885D7C
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 15:57:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 329BC139D05;
	Mon,  9 Dec 2024 15:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="QRs1yS55"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AB4132C38;
	Mon,  9 Dec 2024 15:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733759864; cv=none; b=G48ngoKYlWI5SvJDh1ra7xgbg9eeOMsFeYmnAV3Wy1V6P9j+qYTlLi4qcn53y34syZiT9EDxY36USzoUiQCpvKuvgjxxhyeO2ukawJG/RIicD1U7bqQVmdxtvo+yjx010vEXJJSnxIRCI2MTgN2uJeJifHGiCChnv0iYzF02IRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733759864; c=relaxed/simple;
	bh=o8XP06lcYRfWQzEQkKfdzPtBj+LUgBM2Y1u/K1ZzrDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rdrKsnQKcAKn+Vzyc9kEKK5hId60nQvHLMrMImxokIZkt7Ro0SPsSrvBUmAaPK6EL3hj0jFsygxnbzmiJ4R87WgCsLG6vLUoqfvA5PNBQYOCGAaE+VEblyr8BndhNvbpDtmFQgL/In+jAmVu48Weoa8cBvSLF5Mv5466BnqlGw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=QRs1yS55; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 568D940E0288;
	Mon,  9 Dec 2024 15:57:40 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id uVLnYd3n6KR8; Mon,  9 Dec 2024 15:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1733759856; bh=6wjva+XHkq9WUs9GVSDQBIaFuXyCphV3M7jzddUXB7w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QRs1yS55QCziw5MZ2uTCQFmkttF4+NM8N3gvI686lroGLEj2vFTGAWDzdfVEGSbFd
	 VNAKUQJUT1SmQedrYmsm4yQ2UiY9FuDpnspn3hMMUT/ywYR58gYYXLQjCCsW3CdE/a
	 vewklC69c67GbpsICI2DfzJLqEwwfbVgf7I6U0Z640vHY6TAcoZgsr3mp8YKgmd9G0
	 viZaLaDVb6R/y2K4jr4/faaf3B18YQPIIYLdYnE6X8NBWJm/q4ogjjV3sZz0MZ2Lov
	 F+wL+4T8uxGWRyCIXG5QzqBFWGN5PBpHWEpANykv9wS9KCmcr7AFVgd1habVjWuXae
	 YPzVzwwk2wYPhdEE76tgKHDCQ3P+Zuk6XR2QX3qYMVIgmNqbIdF4itdVRb1cWegfE2
	 7GiQNVhVZeFUnPdCEgewDN6H/Ax5g6QR9kXLxPzrihX3h7cWW4KIsyp/YS+AMSoXBL
	 VsfuMck4pU6Eswq5ZEX9oniEH4+f72lRx9ZFP/xV3O7SRs+sGBtCTtAlkjfj0DRipA
	 BE0wCUUeZOXoY2b1IPIVL3MgmuNuBKbYy9MMusQXDdNyTTiSSwUFTbAQJzG3V/iozR
	 X3KmAAxm+M0Y9sAWtscJQGx78ZmCrVTMtd5UtQ5HFyeZsfcUqpKjB+2ruo11I0dyGH
	 9mVd9re+n0z/psRCLjrslIcU=
Received: from zn.tnic (p200300EA971F9307329c23FFFeA6a903.dip0.t-ipconnect.de [IPv6:2003:ea:971f:9307:329c:23ff:fea6:a903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7A82740E015F;
	Mon,  9 Dec 2024 15:57:25 +0000 (UTC)
Date: Mon, 9 Dec 2024 16:57:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 04/13] x86/sev: Change TSC MSR behavior for Secure
 TSC enabled guests
Message-ID: <20241209155718.GBZ1cTXp2XsgtvUzHm@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-5-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241203090045.942078-5-nikunj@amd.com>

On Tue, Dec 03, 2024 at 02:30:36PM +0530, Nikunj A Dadhania wrote:
> Secure TSC enabled guests should not write to MSR_IA32_TSC(10H) register as
> the subsequent TSC value reads are undefined.

What does that mean exactly?

I'd prefer if we issued a WARN_ONCE() there on the write to catch any
offenders.

*NO ONE* should be writing the TSC MSR but that's a different story.

IOW, something like this ontop of yours?

---

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index c22cb2ea4b99..050170eb28e6 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1443,9 +1443,15 @@ static enum es_result __vc_handle_msr_tsc(struct pt_regs *regs, bool write)
 {
 	u64 tsc;
 
-	if (write)
-		return ES_OK;
+	if (!(sev_status & MSR_AMD64_SNP_SECURE_TSC))
+		goto read_tsc;
+
+	if (write) {
+		WARN_ONCE(1, "TSC MSR writes are verboten!\n");
+		return ES_UNSUPPORTED;
+	}
 
+read_tsc:
 	tsc = rdtsc_ordered();
 	regs->ax = lower_32_bits(tsc);
 	regs->dx = upper_32_bits(tsc);
@@ -1462,11 +1468,14 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	/* Is it a WRMSR? */
 	write = ctxt->insn.opcode.bytes[1] == 0x30;
 
-	if (regs->cx == MSR_SVSM_CAA)
+	switch(regs->cx) {
+	case MSR_SVSM_CAA:
 		return __vc_handle_msr_caa(regs, write);
-
-	if (regs->cx == MSR_IA32_TSC && (sev_status & MSR_AMD64_SNP_SECURE_TSC))
+	case MSR_IA32_TSC:
 		return __vc_handle_msr_tsc(regs, write);
+	default:
+		break;
+	}
 
 	ghcb_set_rcx(ghcb, regs->cx);
 	if (write) {

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

