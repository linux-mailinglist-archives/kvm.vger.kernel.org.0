Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71C72576CB
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 11:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgHaJps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 05:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbgHaJpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 05:45:47 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E81C061573;
        Mon, 31 Aug 2020 02:45:47 -0700 (PDT)
Received: from zn.tnic (p200300ec2f085000329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:5000:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1C5091EC02F2;
        Mon, 31 Aug 2020 11:45:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1598867145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=ekJdpwvphjOKlQIbAp+8+LkeKmG6PBAegFPKIHvH6zs=;
        b=hDnCxTDT3/Oj4fPBE0hGDA8UVt83lzNbYfBzkn2257MEQfuxFndrFvIi3Yt+02BBUttPxQ
        T0WLfkj3j5FBOZg14SLzJe1sh2+JrPkGiEhW1EeB7GhRBbh2s442flj2V1Bthgr1j/eiJb
        xVte/nnElLdX6F54j7hYn5Y6RzOZZyI=
Date:   Mon, 31 Aug 2020 11:45:41 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     x86@kernel.org, Joerg Roedel <jroedel@suse.de>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v6 42/76] x86/sev-es: Setup early #VC handler
Message-ID: <20200831094541.GD27517@zn.tnic>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-43-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200824085511.7553-43-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 24, 2020 at 10:54:37AM +0200, Joerg Roedel wrote:
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +static void set_early_idt_handler(gate_desc *idt, int n, void *handler)
> +{
> +	struct idt_data data;
> +	gate_desc desc;
> +
> +	init_idt_data(&data, n, handler);
> +	idt_init_desc(&desc, &data);
> +	native_write_idt_entry(idt, n, &desc);
> +}
> +#endif
> +
> +static struct desc_ptr early_idt_descr __initdata = {
> +	.size		= IDT_TABLE_SIZE - 1,
> +	.address	= 0 /* Needs physical address of idt_table - initialized at runtime. */,
> +};
> +
> +void __init early_idt_setup(unsigned long physbase)
> +{
> +	void __maybe_unused *handler;
> +	gate_desc *idt;
> +
> +	idt = fixup_pointer(idt_table, physbase);
> +
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +	/* VMM Communication Exception */
> +	handler = fixup_pointer(vc_no_ghcb, physbase);
> +	set_early_idt_handler(idt, X86_TRAP_VC, handler);

This function is used only once AFAICT - you might just as well add its
three-lined body here and save yourself the function definition and
ifdeffery above...

> +#endif
> +
> +	/* Initialize IDT descriptor and load IDT */
> +	early_idt_descr.address = (unsigned long)idt;
> +	native_load_idt(&early_idt_descr);
> +}
> -- 
> 2.28.0
> 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
