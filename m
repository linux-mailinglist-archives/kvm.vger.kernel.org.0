Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFA3257FA0
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 19:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgHaRa0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 13:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728907AbgHaRaZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 13:30:25 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45313C061573;
        Mon, 31 Aug 2020 10:30:25 -0700 (PDT)
Received: from zn.tnic (p200300ec2f085000329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:5000:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B3FAD1EC046E;
        Mon, 31 Aug 2020 19:30:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1598895023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=NdaGU+Hkbaybz0GoT3aHi/t/rgpmP7RP+3/Ipunfh/s=;
        b=SOAc1nvrUv0yGPmWnySfFR0uzO5RbSckRMdNlvPmn1cdv1ZopXZOW0MyVLNbsVS9+SRuF+
        k9HZkAUK1eDERF9CLBEUW8pC9MIKsTgAPgA+HnghQ8Pcc3wvNuGXCQ/ik4+hD7oRG1a9nF
        sKuNteWGs2emV5F6vs97T6ZZj0FlPi4=
Date:   Mon, 31 Aug 2020 19:30:24 +0200
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
Subject: Re: [PATCH v6 48/76] x86/entry/64: Add entry code for #VC handler
Message-ID: <20200831173024.GN27517@zn.tnic>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-49-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200824085511.7553-49-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 24, 2020 at 10:54:43AM +0200, Joerg Roedel wrote:
> @@ -674,6 +675,56 @@ asmlinkage __visible noinstr struct pt_regs *sync_regs(struct pt_regs *eregs)
>  	return regs;
>  }
>  
> +#ifdef CONFIG_AMD_MEM_ENCRYPT
> +asmlinkage __visible noinstr struct pt_regs *vc_switch_off_ist(struct pt_regs *eregs)
> +{
> +	unsigned long sp, *stack;
> +	struct stack_info info;
> +	struct pt_regs *regs;
> +
> +	/*
> +	 * In the SYSCALL entry path the RSP value comes from user-space - don't
> +	 * trust it and switch to the current kernel stack
> +	 */
> +	if (eregs->ip >= (unsigned long)entry_SYSCALL_64 &&
> +	    eregs->ip <  (unsigned long)entry_SYSCALL_64_safe_stack) {
> +		sp = this_cpu_read(cpu_current_top_of_stack);
> +		goto sync;
> +	}
> +
> +	/*
> +	 * From here on the the RSP value is trusted - more RSP sanity checks
			^^^^^^^

Fished out one valid warning from the confused blabla checkpatch spits out:

WARNING: Possible repeated word: 'the'
#276: FILE: arch/x86/kernel/traps.c:696:
+        * From here on the the RSP value is trusted - more RSP sanity checks

IOW, as I tell other submitters:

Please integrate scripts/checkpatch.pl into your patch creation
workflow. Some of the warnings/errors *actually* make sense.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
