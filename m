Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8AD91D10E2
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 13:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730975AbgEMLNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 07:13:45 -0400
Received: from mail.skyhub.de ([5.9.137.197]:54730 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730914AbgEMLNp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 07:13:45 -0400
Received: from zn.tnic (p200300ec2f0ac30080c108a4f2a14d75.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:c300:80c1:8a4:f2a1:4d75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5F1231EC0330;
        Wed, 13 May 2020 13:13:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1589368423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=5DShX4VU/NjBWaapSRN6k1YnbaJnNyw9V9LW9QgRqyo=;
        b=aMIw5BMzlTRYeeZXGKDnswten8IxM5kB72e5LQNSHKB8n9TKQgxYCiOaukgz4TjDNwHYqd
        VB77nQc8kaI/me57e0ilGdxFrJg73P5Yv8efy35fj+KJLA815R2nxO+FoBLDGs6L1E4zlC
        f7It7iW/cILUxz3zZgJ3EpqUE3V8VSQ=
Date:   Wed, 13 May 2020 13:13:40 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Joerg Roedel <jroedel@suse.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 24/75] x86/boot/compressed/64: Unmap GHCB page before
 booting the kernel
Message-ID: <20200513111340.GD4025@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-25-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-25-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:16:34PM +0200, Joerg Roedel wrote:
> @@ -302,9 +313,13 @@ void do_boot_page_fault(struct pt_regs *regs, unsigned long error_code)
>  	 *	- User faults
>  	 *	- Reserved bits set
>  	 */
> -	if (error_code & (X86_PF_PROT | X86_PF_USER | X86_PF_RSVD)) {
> +	if (ghcb_fault ||
> +	    error_code & (X86_PF_PROT | X86_PF_USER | X86_PF_RSVD)) {
>  		/* Print some information for debugging */
> -		error_putstr("Unexpected page-fault:");
> +		if (ghcb_fault)
> +			error_putstr("Page-fault on GHCB page:");
> +		else
> +			error_putstr("Unexpected page-fault:");

You could carve out the info dumping into a separate function to
unclutter this if-statement (diff ontop):

diff --git a/arch/x86/boot/compressed/ident_map_64.c b/arch/x86/boot/compressed/ident_map_64.c
index d3771d455249..c1979fc0f853 100644
--- a/arch/x86/boot/compressed/ident_map_64.c
+++ b/arch/x86/boot/compressed/ident_map_64.c
@@ -296,6 +296,22 @@ int set_page_non_present(unsigned long address)
 	return set_clr_page_flags(&mapping_info, address, 0, _PAGE_PRESENT);
 }
 
+static void do_pf_error(const char *msg, unsigned long error_code,
+			unsigned long address, unsigned long ip)
+{
+	error_putstr(msg);
+
+	error_putstr("\nError Code: ");
+	error_puthex(error_code);
+	error_putstr("\nCR2: 0x");
+	error_puthex(address);
+	error_putstr("\nRIP relative to _head: 0x");
+	error_puthex(ip - (unsigned long)_head);
+	error_putstr("\n");
+
+	error("Stopping.\n");
+}
+
 void do_boot_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	unsigned long address = native_read_cr2();
@@ -309,27 +325,15 @@ void do_boot_page_fault(struct pt_regs *regs, unsigned long error_code)
 
 	/*
 	 * Check for unexpected error codes. Unexpected are:
+	 *	- Faults on the GHCB page due to unexpected #VCs
 	 *	- Faults on present pages
 	 *	- User faults
 	 *	- Reserved bits set
 	 */
-	if (ghcb_fault ||
-	    error_code & (X86_PF_PROT | X86_PF_USER | X86_PF_RSVD)) {
-		/* Print some information for debugging */
-		if (ghcb_fault)
-			error_putstr("Page-fault on GHCB page:");
-		else
-			error_putstr("Unexpected page-fault:");
-		error_putstr("\nError Code: ");
-		error_puthex(error_code);
-		error_putstr("\nCR2: 0x");
-		error_puthex(address);
-		error_putstr("\nRIP relative to _head: 0x");
-		error_puthex(regs->ip - (unsigned long)_head);
-		error_putstr("\n");
-
-		error("Stopping.\n");
-	}
+	if (ghcb_fault)
+		do_pf_error("Page-fault on GHCB page:", error_code, address, regs->ip);
+	else if (error_code & (X86_PF_PROT | X86_PF_USER | X86_PF_RSVD))
+		do_pf_error("Unexpected page-fault:", error_code, address, regs->ip);
 
 	/*
 	 * Error code is sane - now identity map the 2M region around

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
