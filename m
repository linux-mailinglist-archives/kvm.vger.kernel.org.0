Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D819194556
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 18:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgCZRVz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 13:21:55 -0400
Received: from mail.skyhub.de ([5.9.137.197]:55626 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgCZRVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 13:21:54 -0400
Received: from zn.tnic (p200300EC2F0A4900B0CADCDCA21F3A81.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:4900:b0ca:dcdc:a21f:3a81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 39C621EC0CAA;
        Thu, 26 Mar 2020 18:21:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1585243313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=sPJE5svxHvBmq51+EaTp3ZPzDgvJ7fIYIPxDB6I8gHI=;
        b=Y5HeB5F6wdw/zJwmecTIz9gJGja20j774c7OHiUiBE2Tt/6vCalxLkOwJviDZMhNw4JOzb
        Hbvi4mk3wJkrxnq2uc5miovGJn3N0ugzYEeSdcrR1lK2u+TTxqk3gYhI+W6kgiyr2GAPGy
        PsSp3C6J5TVm8vUv0cCqjzdLhj9pbzE=
Date:   Thu, 26 Mar 2020 18:21:46 +0100
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
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 06/70] x86/umip: Factor out instruction fetch
Message-ID: <20200326172146.GF11398@zn.tnic>
References: <20200319091407.1481-1-joro@8bytes.org>
 <20200319091407.1481-7-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200319091407.1481-7-joro@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 19, 2020 at 10:13:03AM +0100, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> Factor out the code to fetch the instruction from user-space to a helper
> function.

Add "No functional changes." here.

> Signed-off-by: Joerg Roedel <jroedel@suse.de>
> ---
>  arch/x86/include/asm/insn-eval.h |  2 ++
>  arch/x86/kernel/umip.c           | 26 +++++-----------------
>  arch/x86/lib/insn-eval.c         | 38 ++++++++++++++++++++++++++++++++
>  3 files changed, 46 insertions(+), 20 deletions(-)

...

> +int insn_fetch_from_user(struct pt_regs *regs,
> +			 unsigned char buf[MAX_INSN_SIZE])

No need for that linebreak - fits in 80 cols.

> +{
> +	unsigned long seg_base = 0;
> +	int not_copied;
> +
> +	/*
> +	 * If not in user-space long mode, a custom code segment could be in
> +	 * use. This is true in protected mode (if the process defined a local
> +	 * descriptor table), or virtual-8086 mode. In most of the cases
> +	 * seg_base will be zero as in USER_CS.
> +	 */
> +	if (!user_64bit_mode(regs))
> +		seg_base = insn_get_seg_base(regs, INAT_SEG_REG_CS);
> +
> +	if (seg_base == -1L)
> +		return 0;

This reads strange: seg_base is changed only inside that if test so I
guess we could test it there too:

        if (!user_64bit_mode(regs)) {
                seg_base = insn_get_seg_base(regs, INAT_SEG_REG_CS);
                if (seg_base == -1L)
                        return 0;
        }

which is a small enough change to not require a separate patch.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
