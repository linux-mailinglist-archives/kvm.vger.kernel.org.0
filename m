Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454311D0B5F
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 10:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732191AbgEMI7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 04:59:33 -0400
Received: from mail.skyhub.de ([5.9.137.197]:59242 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730346AbgEMI7d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 04:59:33 -0400
Received: from zn.tnic (p200300EC2F0AC300894BCC9D04A5BD62.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:c300:894b:cc9d:4a5:bd62])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 785EA1EC0136;
        Wed, 13 May 2020 10:59:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1589360371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=4RZP0ufoz0xMdedmQ7FLg1ube16OaxgtjtyO0/udpG4=;
        b=Ykl2eku9gh8We+iYJnEuPaVAtAldLdXec6XrV0ltQtY6KsotghDRc6vJeOjQWYoMa5V/6y
        GA9bgjT+0Qn3nJJKizmzG1/EFRpGmgTYGmVtCDkiUCJTwatg6sRc3Ytbw3JnpHP9FQrJjS
        jAjTuAZ7aEXCouJy7lJfRAd9pmNGn8w=
Date:   Wed, 13 May 2020 10:59:28 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Joerg Roedel <jroedel@suse.de>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
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
        Mike Stunes <mstunes@vmware.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 23/75] x86/boot/compressed/64: Setup GHCB Based VC
 Exception handler
Message-ID: <20200513085928.GB4025@zn.tnic>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-24-joro@8bytes.org>
 <20200512181157.GD6859@zn.tnic>
 <20200512210812.GF8135@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200512210812.GF8135@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 12, 2020 at 11:08:12PM +0200, Joerg Roedel wrote:
> No, this is a recent addition, otherwise this breaks out-of-tree builds
> (make O=/some/path ...) because inat-tables.c (included from inat.c) is
> generated during build and ends up in the $(objtree).

Please add a blurb about this above it otherwise no one would have a
clue why it is there.

> Because the immediate is the last part of the instruction which is
> decoded (even if there is no immediate). The .got field is set when
> either the immediate was decoded successfully or, in case the
> instruction has no immediate, when the rest of the instruction was
> decoded successfully. So testing immediate.got is the indicator whether
> decoding was successful.

Hm, whether the immediate was parsed correctly or it wasn't there and
using that as the sign whether the instruction was decoded successfully
sounds kinda arbitrary.

@Masami: shouldn't that insn_get_length() thing return a value to denote
whether the decode was successful or not instead of testing arbitrary
fields?

Pasting for you the code sequence again:

	...
        insn_get_length(&ctxt->insn);

        ret = ctxt->insn.immediate.got ? ES_OK : ES_DECODE_FAILED;
	...

I wonder if one would be able to do instead:

	if (insn_get_length(&ctxt->insn))
		return ES_OK;

	return ES_DECODE_FAILED;

to have it straight-forward...

> Probably better rename the function, it also does the sev-es protocol
> version negotiation and all other related setup tasks. Maybe
> sev_es_setup() is a better name?

Sure.

> If the above call fails its the end of the systems lifetime, because we
> can't continue to boot an SEV-ES guest when we have no GHCB.
> 
> BUG_ON() and friends are also not available in the pre-decompression
> boot stage.

Oh ok, error() does hlt the system.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
