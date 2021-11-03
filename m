Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6EE2444541
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 17:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbhKCQHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 12:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbhKCQHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 12:07:48 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9626C061714;
        Wed,  3 Nov 2021 09:05:11 -0700 (PDT)
Received: from zn.tnic (p200300ec2f132900b6e7f8d38363ddad.dip0.t-ipconnect.de [IPv6:2003:ec:2f13:2900:b6e7:f8d3:8363:ddad])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 28F7F1EC0521;
        Wed,  3 Nov 2021 17:05:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1635955510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=hczvJZzWas23wFyZUVNmvw9Zj8/3CUViJtfJTHijkGQ=;
        b=WuWqnChJtaZfbIdyIaFRlTP9ebA7RI0nBVfGARrUjHnzHhhAdFqR2tPRRtiG8E7t+2syA9
        itIB92r5S6cLtEFpG2guTyITWprCY3GkvFvecGQssemG8oGFgu2Jlb8pOLgjKUw2ria9Fd
        51DxGVfysKW9auz+L2byXY0CXAmsoXM=
Date:   Wed, 3 Nov 2021 17:05:04 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
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
Subject: Re: [PATCH v2 05/12] x86/sev: Use GHCB protocol version 2 if
 supported
Message-ID: <YYKzMMyhI1M72YIQ@zn.tnic>
References: <20210913155603.28383-1-joro@8bytes.org>
 <20210913155603.28383-6-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210913155603.28383-6-joro@8bytes.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021 at 05:55:56PM +0200, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Check whether the hypervisor supports GHCB version 2 and use it if
> available.
> 
> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/boot/compressed/sev.c | 10 ++++++++--
>  arch/x86/include/asm/sev.h     |  4 ++--
>  arch/x86/kernel/sev-shared.c   | 17 ++++++++++++++---
>  3 files changed, 24 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
> index 101e08c67296..7f8416f76be7 100644
> --- a/arch/x86/boot/compressed/sev.c
> +++ b/arch/x86/boot/compressed/sev.c
> @@ -119,16 +119,22 @@ static enum es_result vc_read_mem(struct es_em_ctxt *ctxt,
>  /* Include code for early handlers */
>  #include "../../kernel/sev-shared.c"
>  
> +static unsigned int ghcb_protocol;

I guess you need to sync up with Brijesh on what to use:

https://lore.kernel.org/r/20211008180453.462291-7-brijesh.singh@amd.com

And if ghcb_version there is __ro_after_init I think that's perfectly
fine and doesn't need an accessor...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
