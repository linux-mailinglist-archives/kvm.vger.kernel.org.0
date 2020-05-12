Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82311D0026
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 23:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgELVIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 17:08:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:39584 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726324AbgELVIU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 17:08:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7EB6CB02C;
        Tue, 12 May 2020 21:08:19 +0000 (UTC)
Date:   Tue, 12 May 2020 23:08:12 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Borislav Petkov <bp@alien8.de>
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
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 23/75] x86/boot/compressed/64: Setup GHCB Based VC
 Exception handler
Message-ID: <20200512210812.GF8135@suse.de>
References: <20200428151725.31091-1-joro@8bytes.org>
 <20200428151725.31091-24-joro@8bytes.org>
 <20200512181157.GD6859@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512181157.GD6859@zn.tnic>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 12, 2020 at 08:11:57PM +0200, Borislav Petkov wrote:
> > +# sev-es.c inludes generated $(objtree)/arch/x86/lib/inat-tables.c
> 
> 	      "includes"
> 
> > +CFLAGS_sev-es.o += -I$(objtree)/arch/x86/lib/
> 
> Does it?
> 
> I see
> 
> #include "../../lib/inat.c"
> #include "../../lib/insn.c"
> 
> only and with the above CFLAGS-line removed, it builds still.
> 
> Leftover from earlier?

No, this is a recent addition, otherwise this breaks out-of-tree builds
(make O=/some/path ...) because inat-tables.c (included from inat.c) is
generated during build and ends up in the $(objtree).

> > +	insn_init(&ctxt->insn, buffer, MAX_INSN_SIZE, 1);
> > +	insn_get_length(&ctxt->insn);
> > +
> > +	ret = ctxt->insn.immediate.got ? ES_OK : ES_DECODE_FAILED;
> 
> Why are we checking whether the immediate? insn_get_length() sets
> insn->length unconditionally while insn_get_immediate() can error out
> and not set ->got... ?

Because the immediate is the last part of the instruction which is
decoded (even if there is no immediate). The .got field is set when
either the immediate was decoded successfully or, in case the
instruction has no immediate, when the rest of the instruction was
decoded successfully. So testing immediate.got is the indicator whether
decoding was successful.

> 
> > +
> > +	return ret;
> > +}
> 
> ...
> 
> > +static bool sev_es_setup_ghcb(void)
> > +{
> > +	if (!sev_es_negotiate_protocol())
> > +		sev_es_terminate(GHCB_SEV_ES_REASON_PROTOCOL_UNSUPPORTED);
> > +
> > +	if (set_page_decrypted((unsigned long)&boot_ghcb_page))
> > +		return false;
> > +
> > +	/* Page is now mapped decrypted, clear it */
> > +	memset(&boot_ghcb_page, 0, sizeof(boot_ghcb_page));
> > +
> > +	boot_ghcb = &boot_ghcb_page;
> > +
> > +	/* Initialize lookup tables for the instruction decoder */
> > +	inat_init_tables();
> 
> Yeah, that call doesn't logically belong in this function AFAICT as this
> function should setup the GHCB only. You can move it to the caller.

Probably better rename the function, it also does the sev-es protocol
version negotiation and all other related setup tasks. Maybe
sev_es_setup() is a better name?

> > +	if (set_page_encrypted((unsigned long)&boot_ghcb_page))
> > +		error("Can't map GHCB page encrypted");
> 
> Is that error() call enough?
> 
> Shouldn't we BUG_ON() here or mark that page Reserved or so, so that
> nothing uses it during the system lifetime and thus avoid the strange
> cache effects?

If the above call fails its the end of the systems lifetime, because we
can't continue to boot an SEV-ES guest when we have no GHCB.

BUG_ON() and friends are also not available in the pre-decompression
boot stage.

> 
> ...
> 
> > +static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
> > +					  struct es_em_ctxt *ctxt,
> > +					  u64 exit_code, u64 exit_info_1,
> > +					  u64 exit_info_2)
> > +{
> > +	enum es_result ret;
> > +
> > +	/* Fill in protocol and format specifiers */
> > +	ghcb->protocol_version = GHCB_PROTOCOL_MAX;
> > +	ghcb->ghcb_usage       = GHCB_DEFAULT_USAGE;
> > +
> > +	ghcb_set_sw_exit_code(ghcb, exit_code);
> > +	ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
> > +	ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
> > +
> > +	sev_es_wr_ghcb_msr(__pa(ghcb));
> > +	VMGEXIT();
> > +
> > +	if ((ghcb->save.sw_exit_info_1 & 0xffffffff) == 1) {
> 					^^^^^^^^^^^
> 
> (1UL << 32) - 1
> 
> I guess.

Or lower_32_bits(), probably. I'll change it.

Thanks,

	Joerg

