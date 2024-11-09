Return-Path: <kvm+bounces-31350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 286919C2E7B
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 17:28:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B383D28288B
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 16:28:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A0DC19DF48;
	Sat,  9 Nov 2024 16:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="SP5coBqn"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87927146A71;
	Sat,  9 Nov 2024 16:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731169694; cv=none; b=l61P4EWAaQOkDFqfTF1Z8rz86OOJBucQjy++j6eQNoLm+1YBKGzLdUzcwuFPkG/e7aSXQf96XkTONMe0PbzoknqZ5Ev/jkvyhsuepSAR+4ZNDgzAh1LDw5Z7QrZKjzvFc1b2GicBePOPfKxD7goVKieQwCyVFFqLlz92N30r0AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731169694; c=relaxed/simple;
	bh=FsB/uJvsk77XxQnBA9+9NYrW0crm3GsDVdbMrdKw11g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GVqdEkPcUXojXw7Jj983qtGJvUR/bvKuOeVe1Vt3bNAjN6Raed8iZQxphIlp2lsuJpN8gz60mYMFWlrr/HZzBc012wae4wrejfwkpgNIEgG1dhzgKX82Us8hyVM4vHWsrICdwzQiACzqgiO4B2uj6VE0lheyQKstqqhI1UNL83U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=SP5coBqn; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id ADD1D40E0261;
	Sat,  9 Nov 2024 16:28:08 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id x2ld8cygtb42; Sat,  9 Nov 2024 16:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1731169684; bh=Y0OF5xcevUmOfjwq3LJoOJPjZWofHl0+X/BbmolJS1c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SP5coBqnm/HhLVfRXxe77NGXqKQSs4fcXwwswqb5xg5vJ1XraiXcRj5xUyKtXvHuQ
	 4J68gp+ZykhLWpcsmoc7Z/cJkNBEDBog+3NXHEpX+RP7ZTGWmLg8WtLqU55HtjOR6i
	 peD/nVzHrzSEerkyIARLcpERgr2hE11l3vMvR4F8C4MU/FSPJSv+U2vLs1t3KUcW8O
	 drH4SQ/xhEonHMtYmwnbxlI3giem7jc7ivXLUOq33rWEHmInUB/DyWu1egUfJoF2a2
	 MLFPJyfLkQ1BUPjLre2NBMb5d0N8AIlV9Seprmk6Pj0j2295oME+RmtFw4gaQMdNhS
	 rteeZIOUgN8NC5iyN4ay38NUg1+sNkoTCBqzGr06rwXKaQkNUXt6UmmFSyCADQdtxB
	 pq0PES+gT6yDu3Ts0ocguEa0JgOswJgrXAqNUkX6zDUPbvKFTGVEPS8XOHktUBnGUU
	 /7QzQ7YA8UD0Ior6lpFQOlyy2q7q7QRq4C+ZOQVsdC2CawzeHffTREWc6bX/i7ZgO2
	 CEl7x7K64P9c/RGN2wNQHaPhLlKFnwgfVIXpkJFnm/dpqiB62BGsIYFKjfkg+6jsiM
	 pvOrbaurRfD5UvW+CtxtfRYkHqmDPrQj3hhGaOTHg5Fy0v/XWJsDLQDgIlK2Zyka2f
	 55mDGDCHOQdlIsaUE8Go9JLY=
Received: from zn.tnic (p5de8e8eb.dip0.t-ipconnect.de [93.232.232.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0E9D840E0191;
	Sat,  9 Nov 2024 16:27:47 +0000 (UTC)
Date: Sat, 9 Nov 2024 17:27:41 +0100
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [RFC 04/14] x86/apic: Initialize APIC backing page for Secure
 AVIC
Message-ID: <20241109162741.GCZy-NfVcTfOLNwzkT@fat_crate.local>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-5-Neeraj.Upadhyay@amd.com>
 <20241107152831.GZZyzcn2Tn2eIrMlzq@fat_crate.local>
 <4af5212d-a6db-4f14-ace7-c6deb6d0f676@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4af5212d-a6db-4f14-ace7-c6deb6d0f676@amd.com>

On Fri, Nov 08, 2024 at 11:38:15PM +0530, Neeraj Upadhyay wrote:
> As sev_ghcb_msr_read() work with any msr and is not limited to reading
> x2apic msrs, I created a global sev function for it.

That can happen when the functionality is needed somewhere else too.

> Ok sure, I will leave generalizing this to future use cases (if/when they come up)

Yap.

> and provide a secure avic specific function here (will do the same for
> sev_ghcb_msr_write(), which comes later in this series).
> 
> "x2avic" terminology is not used in guest code. As this function only has secure
> avic user, does secure_avic_ghcb_msr_read() work?

That or "savic_..."

> >> +enum lapic_lvt_entry {
> > 
> > What's that enum for?
> 
> It's used in init_backing_page()

Then use it properly:

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 99151be4e173..1753c4a71b50 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -200,8 +200,8 @@ static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, in
 
 static void init_backing_page(void *backing_page)
 {
+	enum lapic_lvt_entry i;
 	u32 val;
-	int i;
 
 	val = read_msr_from_hv(APIC_LVR);
 	set_reg(backing_page, APIC_LVR, val);

> >> +		pr_err("Secure AVIC msr (%#llx) read returned error (%d)\n", msr, ret);
> > 
> > Prepend "0x" to the format specifier.
> > 
> 
> Using '#' prepends "0x". Am I missing something here?

Let's use the common thing pls even if the alternate form works too:

$ git grep "\"%#" | wc -l
411
$ git grep "\"0x" | wc -l
112823

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

