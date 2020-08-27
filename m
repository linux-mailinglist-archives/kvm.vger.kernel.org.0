Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B2F25428E
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 11:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgH0Jgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 05:36:54 -0400
Received: from mail.skyhub.de ([5.9.137.197]:35744 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbgH0Jgy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 05:36:54 -0400
Received: from zn.tnic (p200300ec2f1045007cf9313b25892ea2.dip0.t-ipconnect.de [IPv6:2003:ec:2f10:4500:7cf9:313b:2589:2ea2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 6CB081EC037C;
        Thu, 27 Aug 2020 11:36:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1598521012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=rwtDHHfiouipWty6o59Fe2PscF08QBczZyo5miFFKr0=;
        b=a4ec/EYCvKRS1JSxVRYSp3Flhd6Q/yeMEqdmJJAMUCy1FA0FEVUUjztCgyK6EI0QIhMUvf
        CLVOCKWZp+oON7tq2VvCNybGGPw+Ie0Ax+fXiRPLJ9CB03ogfq3iYPxDtBBaeuyUVXK56Z
        aL3jV/cI3fI3+mNYBD7acUKehQL1utw=
Date:   Thu, 27 Aug 2020 11:36:49 +0200
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
Subject: Re: [PATCH v6 20/76] x86/boot/compressed/64: Call
 set_sev_encryption_mask earlier
Message-ID: <20200827093649.GA30897@zn.tnic>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-21-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200824085511.7553-21-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 24, 2020 at 10:54:15AM +0200, Joerg Roedel wrote:

Just minor style issues to be fixed by committer or in case you have to
send a new version:

Subject: Re: [PATCH v6 20/76] x86/boot/compressed/64: Call set_sev_encryption_mask earlier

set_sev_encryption_mask() <- it is a function.

> From: Joerg Roedel <jroedel@suse.de>
> 
> Call set_sev_encryption_mask() while still on the stage 1 #VC-handler,
> because the stage 2 handler needs our own page-tables to be set up, to

"... needs the kernel's own page tables to be set up... "

"we" is almost always ambiguous and should be avoided by formulating the
commit message in passive voice.

> which calling set_sev_encryption_mask() is a prerequisite.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> Link: https://lore.kernel.org/r/20200724160336.5435-20-joro@8bytes.org
> ---
>  arch/x86/boot/compressed/head_64.S      | 8 +++++++-
>  arch/x86/boot/compressed/ident_map_64.c | 3 ---
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
> index 013b29921836..c7fcf60cbd08 100644
> --- a/arch/x86/boot/compressed/head_64.S
> +++ b/arch/x86/boot/compressed/head_64.S
> @@ -533,9 +533,15 @@ SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated)
>  	rep	stosq
>  
>  /*
> - * Load stage2 IDT and switch to our own page-table
> + * If running as an SEV guest, the encryption mask is required in the
> + * page-table setup code below. When the guest also has SEV-ES enabled
> + * set_sev_encryption_mask() will cause #VC exceptions, but the stage2
> + * handler can't map its GHCB because the page-table is not set up yet.
> + * So set up the encryption mask here while still on the stage1 #VC
> + * handler. Then load stage2 IDT and switch to our own page-table.

	... to the kernel's own page table."

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
