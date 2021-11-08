Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71C21449B7D
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 19:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbhKHSRG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 13:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbhKHSRF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 13:17:05 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1617EC061570;
        Mon,  8 Nov 2021 10:14:21 -0800 (PST)
Received: from zn.tnic (p200300ec2f3311008f2ddbd2a2570897.dip0.t-ipconnect.de [IPv6:2003:ec:2f33:1100:8f2d:dbd2:a257:897])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 3AAEC1EC03F0;
        Mon,  8 Nov 2021 19:14:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1636395258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=+HGdXgtqs75JzplHr1fw8l9R7E0Ax8B0+CMXZj7tYjw=;
        b=JOTcUpAORtYs0vDLl0qwwB7gRevj19RPVQHhG0QnjV5H/+dFLUvZBr9eW8eD4MBeAbTe8q
        N1UJwyZcsZojb6gTtwokrIVzEF5ZNpa4bsRYBo2kogWFnFZ3eJK+CGqccZzTKdVImeb73m
        cRq530yqjggDJ4iaaeEGU22Nz6iYaRk=
Date:   Mon, 8 Nov 2021 19:14:12 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Eric Biederman <ebiederm@xmission.com>,
        kexec@lists.infradead.org, Joerg Roedel <jroedel@suse.de>,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 06/12] x86/sev: Cache AP Jump Table Address
Message-ID: <YYlo9IhvDNr2FvK4@zn.tnic>
References: <20210913155603.28383-1-joro@8bytes.org>
 <20210913155603.28383-7-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210913155603.28383-7-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021 at 05:55:57PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Store the physical address of the AP Jump Table in kernel memory so
> that it does not need to be fetched from the Hypervisor again.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/kernel/sev.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
> index 5d3422e8b25e..eedba56b6bac 100644
> --- a/arch/x86/kernel/sev.c
> +++ b/arch/x86/kernel/sev.c
> @@ -42,6 +42,9 @@ static struct ghcb boot_ghcb_page __bss_decrypted __aligned(PAGE_SIZE);
>   */
>  static struct ghcb __initdata *boot_ghcb;
>  
> +/* Cached AP Jump Table Address */
> +static phys_addr_t sev_es_jump_table_pa;

This is static, so "jump_table_pa" should be enough.

Also, to the prefixes, everything which is not SEV-ES only, should be
simply prefixed with "sev_" if externally visible.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
