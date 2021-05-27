Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E05392D14
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 13:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbhE0Luq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 07:50:46 -0400
Received: from mail.skyhub.de ([5.9.137.197]:54910 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233633AbhE0Lup (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 07:50:45 -0400
Received: from zn.tnic (p200300ec2f0f02008ae29220a5f6f448.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:200:8ae2:9220:a5f6:f448])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C06C21EC01DF;
        Thu, 27 May 2021 13:49:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1622116151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=4hf7uF3C3I8f6GPjngHoeAScPG99btQaF7u7u7H1D/A=;
        b=Sgaak1NAhP9i6jE1h6KeI0CFwvsb66ueQKL0EFfIisNKKFKCoTW1tpdbkI7bXxWcuy/MCK
        80H09PtaLz2sMTfzm5E9z7fMJcu+d/OVcF8V0Bywzlm2RLd5hoiasH2O0YGO4vm7DOsPPZ
        I7YCb5bhulGA5S2gyslVXUGbksoe9/Y=
Date:   Thu, 27 May 2021 13:49:05 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        tglx@linutronix.de, jroedel@suse.de, thomas.lendacky@amd.com,
        pbonzini@redhat.com, mingo@redhat.com, dave.hansen@intel.com,
        rientjes@google.com, seanjc@google.com, peterz@infradead.org,
        hpa@zytor.com, tony.luck@intel.com
Subject: Re: [PATCH Part1 RFC v2 16/20] x86/kernel: Validate rom memory
 before accessing when SEV-SNP is active
Message-ID: <YK+HMZIgZWwCYKzq@zn.tnic>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
 <20210430121616.2295-17-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210430121616.2295-17-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 07:16:12AM -0500, Brijesh Singh wrote:
> +	/*
> +	 * The ROM memory is not part of the E820 system RAM and is not pre-validated
> +	 * by the BIOS. The kernel page table maps the ROM region as encrypted memory,
> +	 * the SEV-SNP requires the encrypted memory must be validated before the
> +	 * access. Validate the ROM before accessing it.
> +	 */
> +	n = ((system_rom_resource.end + 1) - video_rom_resource.start) >> PAGE_SHIFT;
> +	early_snp_set_memory_private((unsigned long)__va(video_rom_resource.start),
> +			video_rom_resource.start, n);

From last review:

I don't like this sprinkling of SNP-special stuff that needs to be done,
around the tree. Instead, pls define a function called

        snp_prep_memory(unsigned long pa, unsigned int num_pages, enum operation);

or so which does all the manipulation needed and the callsites only
simply unconditionally call that function so that all detail is
extracted and optimized away when not config-enabled.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
