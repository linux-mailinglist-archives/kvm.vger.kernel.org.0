Return-Path: <kvm+bounces-34354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C496F9FBD08
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 12:54:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2C7137A17EC
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 11:54:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4AC51BD01E;
	Tue, 24 Dec 2024 11:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="dhrSed+k"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AB9192589;
	Tue, 24 Dec 2024 11:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735041262; cv=none; b=s5XIBnq0U/JLnTql4HRb2tVlPHhec3Ke3OR1OnOnwzSVgMvzOiL4s9g+5+B9DXyjTBcMqNexuMfkoJ6M+pZOhr9g6mhjQvEF6gzdaX6HvY4H+YD72i8PeqLBwXvJ8Hfo249NnqqIS46NyKvdfmyegrhqFWmq/K1oX2fSgQ/BkB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735041262; c=relaxed/simple;
	bh=ogq8s7ziVfnw5R/VjKwghiyR7UJFqw5otni3XPYgCjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OCX8CXIFZoiK44efnDqB/3enApcSyTElJDq31mAO49YKioSHNgJWT+O/eC+0w/70TLf0+Kvk3vW1CkaHappBu1ZCSy4HKSVr/lR0IpZA/qh6H4DkKNuMgVS6qPJdl1GCy0seQgGsfn4ByWvQ/ySq6HbImynK8FTT1iEw1HxUeTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=dhrSed+k; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6352440E0286;
	Tue, 24 Dec 2024 11:54:10 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id JtXSZMAogEYI; Tue, 24 Dec 2024 11:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1735041246; bh=ojRkX1Ip1xFGVZMqbTEqhwPKLnSU27bTSsAi9vW5+P8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dhrSed+kK9KmZUUwWx/8yLZEmNFSvlZsy/o90W48AaDNgmfsqHnFnoH14FlXoG48w
	 C4agVH27re/1njqvW9/AC3L4zlenCDzgy2tZZb5VEhhkbi2fgd39Q3wOOTBzWv8pj+
	 tdUgfZpG04gbdpbXBgm5fV0MWVvfPpYFC7d850AP62paV12rCRu4u5bBCw36Ey+cwK
	 2se9rcYkxS3XfAVTxdkSmrjY0Hm34Vjt9nYACBQ3BIUz30uDgzCSa13CLA2KSsHhR7
	 M/eC4LOJcHybYfi695qavZi5X8F2G0JwFk/yolPhIlfUGqVRQpvOJope6FsSdMHmIE
	 eLVtdb7FUm90Wx8n9i+/sBa3M9fQvrujtZ7UcxhQWI6U4pLbKjbQGlH3cznzOB5NvQ
	 LiB6H6tVwl4hlz3X06lWD9zG/ZPbJTapfE4JSCGD9sWcApweli4ePSvVPMRARFIhrR
	 AvRO8grkpsSptSVctj2DU2feZ1458s4oa1FrCUJIfgFIALfz1izW2QyHgIO7n7Cevy
	 BDKuab9vcGPv7llfNJKoEnd9iwNtu8Xxr672uB6uLYOEljJcXxBN4j/8u38gTi52FJ
	 qbR1Jaho8RMZ9x33oJjTj1FagV3pHeHppG0L5pSidQNYTMMCZmggNbEzSjGZbNoRm0
	 1yggOp53iX7YfXUCp238TnB8=
Received: from nazgul.tnic (unknown [IPv6:2a02:3030:60a:ee80:ed53:8b0d:a4f1:4623])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 592A440E0269;
	Tue, 24 Dec 2024 11:53:55 +0000 (UTC)
Date: Tue, 24 Dec 2024 12:53:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
	kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com
Subject: Re: [PATCH v15 06/13] x86/sev: Prevent GUEST_TSC_FREQ MSR
 interception for Secure TSC enabled guests
Message-ID: <20241224115346.GAZ2qgyt3sQmPdbA4V@fat_crate.local>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-7-nikunj@amd.com>
 <20241210121127.GBZ1gv74Q6IRtAS1pl@fat_crate.local>
 <b1d90372-ed95-41ce-976f-3f119735707c@amd.com>
 <20241210171858.GKZ1h4Apb2kWr6KAyL@fat_crate.local>
 <ff7226fa-683f-467b-b777-8a091a83231e@amd.com>
 <20241217105739.GBZ2FZI0V8pAIy-kZ8@fat_crate.local>
 <7a5de2be-4e79-409a-90f2-398815fc59c7@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7a5de2be-4e79-409a-90f2-398815fc59c7@amd.com>

On Wed, Dec 18, 2024 at 10:50:07AM +0530, Nikunj A. Dadhania wrote:
> With the condition inside the function, even tough the MSR is not
> valid in this configuration, I am getting value 0. Is this behavior
> acceptable ?

The whole untested diff, should DTRT this time:

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 10980898c054..96a9ee93f9cb 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1441,10 +1441,25 @@ static enum es_result __vc_handle_msr_caa(struct pt_regs *regs, bool write)
  */
 static enum es_result __vc_handle_msr_tsc(struct pt_regs *regs, bool write)
 {
+	bool sec_tsc = sev_status & MSR_AMD64_SNP_SECURE_TSC;
 	u64 tsc;
 
-	if (write)
-		return ES_OK;
+	/*
+	 * The GUEST_TSC_FREQ MSR should not be intercepted when secure
+	 * TSC is enabled so terminate the guest. For non-secure TSC
+	 * guests, that MSR is #GP(0).
+	 */
+	if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ) {
+		if (sec_tsc)
+			return ES_VMM_ERROR;
+		else
+			return ES_UNSUPPORTED;
+	}
+
+	if (write) {
+		WARN_ONCE(1, "TSC MSR writes are verboten!\n");
+		return ES_UNSUPPORTED;
+	}
 
 	tsc = rdtsc_ordered();
 	regs->ax = lower_32_bits(tsc);
@@ -1462,19 +1477,15 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	/* Is it a WRMSR? */
 	write = ctxt->insn.opcode.bytes[1] == 0x30;
 
-	if (regs->cx == MSR_SVSM_CAA)
+	switch(regs->cx) {
+	case MSR_SVSM_CAA:
 		return __vc_handle_msr_caa(regs, write);
-
-	if (regs->cx == MSR_IA32_TSC && (sev_status & MSR_AMD64_SNP_SECURE_TSC))
+	case MSR_IA32_TSC:
+	case MSR_AMD64_GUEST_TSC_FREQ:
 		return __vc_handle_msr_tsc(regs, write);
-
-	/*
-	 * GUEST_TSC_FREQ should not be intercepted when Secure TSC is
-	 * enabled. Terminate the SNP guest when the interception is enabled.
-	 */
-	if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ && (sev_status & MSR_AMD64_SNP_SECURE_TSC))
-		return ES_VMM_ERROR;
-
+	default:
+		break;
+	}
 
 	ghcb_set_rcx(ghcb, regs->cx);
 	if (write) {

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

