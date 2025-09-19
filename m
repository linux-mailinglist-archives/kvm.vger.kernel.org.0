Return-Path: <kvm+bounces-58129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 98713B88746
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 10:42:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C9F516B0FA
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 08:42:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A34EA3064B0;
	Fri, 19 Sep 2025 08:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="OEUgKbSC"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869A62ECD01
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 08:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758271350; cv=none; b=EiRqXMiXhrVO/5HjhAnx8j097S+k51SCwUSpedxlMjpDry0UxYySk4Y4wjmKrDKxciIkfo5SNALKyPjj/NoTnqIJQ0GppgyoWdwBu33GpbBh2RFHlEo4aBZcgIITC9T8vuAlJ3wIclXqlopUqjjr4+2y3NFK76P4cak3FLoyStE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758271350; c=relaxed/simple;
	bh=VZ9GLE8CQrwaLb6HQQgn1jGg2RUB5ExPy7xc+vPrvJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HAGNX6A1oXYDTrgMBjoYLWuspwHZ4xUJIUmoNI74Pcntr5jVYnfxlY4HKMDxclG+EsAINm3b/JfOtfSPsvhXiSEMpcF8V2kxZc2vFgG5UEyxKu2//9j6JUjjYL8Rg/0kHhwOOl4PQ2qk/aOPcHU4NdNG8CApnQElYI3v4875cNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=OEUgKbSC; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id CF94C40E00DA;
	Fri, 19 Sep 2025 08:42:22 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id hc2InsbnWdpE; Fri, 19 Sep 2025 08:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1758271337; bh=rmUHoZB1a+cRd3OVIKGGA+K7bttMG+4/nzQZAIt8fcI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OEUgKbSC1hDXTwPDI0Ib7WY0gXWaWpnojbjafd0C5flvO782XB3L/bruq0uUQWVyY
	 Rl/5fKuhqv8AtwevcuwYYg/6ryHgaReZgHgrbODtlyXGT+rlDWZXe4E1t62vWJf08F
	 eds6exF7mNkGOXifhCruXgykijEQRwKA3rzwvlmEH/d9ICR7XxtczSMSf2BOXlPeIR
	 FsR4vtgV3eyVzx7yqs8U7Ribnc0fNio9+rYu/5SlxeNvcYVPzb9BW1r2e119dIHWDS
	 Bg73yKATsk570yBbNFBhGTxEaq/QhTCCQe9iSCuu+Mwa0igKZQRj3rJPHHeTyKT6eV
	 m54hm3Y9/H7OrZOaIJDbGMQAet0z3ZFuxkMoRYEyw45vTyPcovTdkuesgUhUtpzfF2
	 mK62UVLdAmUDp/k/bMPUSjRAR+m+PGXINPFCcql8NEtso9pPv7N9PiHKRtBh0qp5v8
	 +IXlLRAEw3Yy6HdLrb/jTbpesXCKiOOQ76w7Pc+K7EZdRDh8JfpAHeyKYl4cGdLhLf
	 QG7tKngr5cwWQFhfb7GXFiCrPrTaH6Ebjy97lQqUF8B7I5YteFdZU4/cHkpUVbFq+t
	 c6h2FITzRKrJ3TlHBNqDx+qWFGtKJdy6MnXiphYa0tT953uwDvWIjOHBZBjk0NZPZ4
	 Zvgql4X4jT+bydHvs4kvH49g=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 514BC40E01A3;
	Fri, 19 Sep 2025 08:42:00 +0000 (UTC)
Date: Fri, 19 Sep 2025 10:41:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N Rao (AMD)" <naveen@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [RESEND v4 6/7] x86/cpufeatures: Add X86_FEATURE_X2AVIC_EXT
Message-ID: <20250919084152.GAaM0XUOqXs-nwUk7T@fat_crate.local>
References: <cover.1757009416.git.naveen@kernel.org>
 <e5c9c471ab99a130bf9b728b77050ab308cf8624.1757009416.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e5c9c471ab99a130bf9b728b77050ab308cf8624.1757009416.git.naveen@kernel.org>

On Fri, Sep 05, 2025 at 12:03:06AM +0530, Naveen N Rao (AMD) wrote:
> Add CPUID feature bit for x2AVIC extension that enables AMD SVM to
> support up to 4096 vCPUs in x2AVIC mode. The primary change is in the
> size of the AVIC Physical ID table, which can now go up to 8 contiguous
> 4k pages. The number of pages allocated is controlled by the maximum
> APIC ID for a guest, and that controls the number of pages to allocate
> for the AVIC Physical ID table. AVIC hardware is enhanced to look up
> Physical ID table entries for vCPUs > 512 for locating the target APIC
> backing page and the host APIC ID of the physical core on which the
> guest vCPU is running.
> 
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
> ---
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/kernel/cpu/scattered.c    | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 8738bd783de2..92cbf2d8d7b1 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -497,6 +497,7 @@
>  #define X86_FEATURE_TSA_L1_NO		(21*32+12) /* AMD CPU not vulnerable to TSA-L1 */
>  #define X86_FEATURE_CLEAR_CPU_BUF_VM	(21*32+13) /* Clear CPU buffers using VERW before VMRUN */
>  #define X86_FEATURE_MSR_IMM		(21*32+14) /* MSR immediate form instructions */
> +#define X86_FEATURE_X2AVIC_EXT		(21*32+15) /* AMD SVM x2AVIC support for 4k vCPUs */

This number will need to be refreshed when applying/merging but in principle:

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

