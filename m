Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C771D72E7
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 10:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgERIXX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 04:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgERIXX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 04:23:23 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1096FC061A0C;
        Mon, 18 May 2020 01:23:23 -0700 (PDT)
Received: from zn.tnic (p200300EC2F06E800ECDCE19D4A51D977.dip0.t-ipconnect.de [IPv6:2003:ec:2f06:e800:ecdc:e19d:4a51:d977])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0AB141EC0295;
        Mon, 18 May 2020 10:23:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1589790200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=NRH8oUNhkxpcUz5rd9LcRTM109aECD+/gUl0zIMTl5w=;
        b=EmRutMjnTt3s/OCgVTsnLs5lE1J795LjE9ueGF2jckGBoi40V3GjCQ465iK19AYHmDM2Ns
        WS9YUgSW70oUTt9Jx7wyuf4vUyYmw5ddYxHDzc4pdOHplM0R13+b4syehDAXt8GPNlMRLR
        nqaFEm49nhK7F0ahvS00kE5h7VwuMV4=
Date:   Mon, 18 May 2020 10:23:13 +0200
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
Subject: Re: [PATCH v3 31/75] x86/head/64: Install boot GDT
Message-ID: <20200518082313.GA25034@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-32-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200428151725.31091-32-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 28, 2020 at 05:16:41PM +0200, Joerg Roedel wrote:
> @@ -480,6 +500,22 @@ SYM_DATA_LOCAL(early_gdt_descr_base,	.quad INIT_PER_CPU_VAR(gdt_page))
>  SYM_DATA(phys_base, .quad 0x0)
>  EXPORT_SYMBOL(phys_base)
>
> +/* Boot GDT used when kernel addresses are not mapped yet */
> +SYM_DATA_LOCAL(boot_gdt_descr,		.word boot_gdt_end - boot_gdt)
> +SYM_DATA_LOCAL(boot_gdt_base,		.quad 0)
> +SYM_DATA_START(boot_gdt)
> +	.quad	0
> +	.quad   0x00cf9a000000ffff	/* __KERNEL32_CS */
> +	.quad   0x00af9a000000ffff	/* __KERNEL_CS */
> +	.quad   0x00cf92000000ffff	/* __KERNEL_DS */
> +	.quad	0			/* __USER32_CS - unused */
> +	.quad	0			/* __USER_DS   - unused */
> +	.quad	0			/* __USER_CS   - unused */
> +	.quad	0			/* unused */
> +	.quad   0x0080890000000000	/* TSS descriptor */
> +	.quad   0x0000000000000000	/* TSS continued */

Any chance you could use macros ala GDT_ENTRY_INIT() for those instead
of the naked values?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
