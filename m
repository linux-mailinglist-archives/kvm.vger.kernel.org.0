Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F079135A40A
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 18:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbhDIQxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 12:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233332AbhDIQxT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 12:53:19 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E5AC061760;
        Fri,  9 Apr 2021 09:53:05 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0be10039b183a609a7c35d.dip0.t-ipconnect.de [IPv6:2003:ec:2f0b:e100:39b1:83a6:9a7:c35d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A72A01EC04DA;
        Fri,  9 Apr 2021 18:53:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617987182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=qdhoxtp2hGKBHLadXtcjDz2Xk4ANRTM4V96sSJKs0Co=;
        b=iOEa9+FKd6sLuv6pyKuvUjDiJ8WGjQcvG8KP/XP7G0xhZEynfEcEyidCPCCpxkOFqhQig0
        Td+afS0yDyoCjXjTfNHdHCW+34HrRLiYLWbEVR71iDwkkSSTZB2PoYq0TwgkCKEgXxKP4F
        nKES18Shk5z2cMnSUlza4lXbW/htbuM=
Date:   Fri, 9 Apr 2021 18:53:02 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 11/13] x86/kernel: validate rom memory before
 accessing when SEV-SNP is active
Message-ID: <20210409165302.GF15567@zn.tnic>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-12-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210324164424.28124-12-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021 at 11:44:22AM -0500, Brijesh Singh wrote:
> +	/*
> +	 * The ROM memory is not part of the E820 system RAM and is not prevalidated by the BIOS.
> +	 * The kernel page table maps the ROM region as encrypted memory, the SEV-SNP requires
> +	 * the all the encrypted memory must be validated before the access.
> +	 */
> +	if (sev_snp_active()) {
> +		unsigned long n, paddr;
> +
> +		n = ((system_rom_resource.end + 1) - video_rom_resource.start) >> PAGE_SHIFT;
> +		paddr = video_rom_resource.start;
> +		early_snp_set_memory_private((unsigned long)__va(paddr), paddr, n);
> +	}

I don't like this sprinkling of SNP-special stuff that needs to be done,
around the tree. Instead, pls define a function called

	snp_prep_memory(unsigned long pa, unsigned int num_pages, enum operation);

or so which does all the manipulation needed and the callsites only
simply unconditionally call that function so that all detail is
extracted and optimized away when not config-enabled.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
