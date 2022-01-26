Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5DD49CC49
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 15:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242107AbiAZO0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 09:26:09 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:34450 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235227AbiAZO0F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 09:26:05 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3E8002113B;
        Wed, 26 Jan 2022 14:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643207164; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WLyKhfXHS44+Znkmdw5Wkn13IOJ7HmCc2bqdYmRAEVg=;
        b=oxNzeR3EjZyJqfzhIUshnheJ0INLWf66MfyocLgT8F2bMmX9rDhOpeOucc8uVnXkZnlwrL
        N6DmoMYW3MhH5LkEKjNETbnhojlh6h7S2PMJeLFWEUdQHmfizHlU7tRzGWjzCoobQEbKJf
        Ig3Kn6r6NxAW9MfIjTmTj8hdFAJj694=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643207164;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WLyKhfXHS44+Znkmdw5Wkn13IOJ7HmCc2bqdYmRAEVg=;
        b=Zf9Zim80aCa4MDEXnNy318W3kpCJ/XdcZx5iwGuSF2NMAz3RXI1cSFR9dyB9uSO5TpCLIW
        +YTW2Lzh1DdMS1CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5A9AA13E1A;
        Wed, 26 Jan 2022 14:26:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oZl4FPtZ8WHxegAAMHmgww
        (envelope-from <jroedel@suse.de>); Wed, 26 Jan 2022 14:26:03 +0000
Date:   Wed, 26 Jan 2022 15:26:01 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Eric Biederman <ebiederm@xmission.com>,
        kexec@lists.infradead.org, hpa@zytor.com,
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
        Sean Christopherson <seanjc@google.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 07/12] x86/sev: Setup code to park APs in the AP Jump
 Table
Message-ID: <YfFZ+SRutJhDoAkz@suse.de>
References: <20210913155603.28383-1-joro@8bytes.org>
 <20210913155603.28383-8-joro@8bytes.org>
 <YYv1TPawuorQv1PR@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YYv1TPawuorQv1PR@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 10, 2021 at 05:37:32PM +0100, Borislav Petkov wrote:
> On Mon, Sep 13, 2021 at 05:55:58PM +0200, Joerg Roedel wrote:
> >  extern unsigned char real_mode_blob[];
> > diff --git a/arch/x86/include/asm/sev-ap-jumptable.h b/arch/x86/include/asm/sev-ap-jumptable.h
> > new file mode 100644
> > index 000000000000..1c8b2ce779e2
> > --- /dev/null
> > +++ b/arch/x86/include/asm/sev-ap-jumptable.h
> 
> Why a separate header? arch/x86/include/asm/sev.h looks small enough.

The header is included in assembly, so I made a separate one.

> > +void __init sev_es_setup_ap_jump_table_data(void *base, u32 pa)
> 
> Why is this a separate function?
> 
> It is all part of the jump table setup.

Right, but the sev_es_setup_ap_jump_table_blob() function is already
pretty big and I wanted to keep things readable.

> 
> > +		return 0;
> 
> Why are you returning 0 here and below?

This is in an initcall and it returns just 0 when the environment is not
ready to setup the ap jump table. Returning non-zero would create a
warning message in the caller for something that is not a bug in the
kernel.

> > + * This file contains the source code for the binary blob which gets copied to
> > + * the SEV-ES AP Jumptable to park APs while offlining CPUs or booting a new
> 
> I've seen "Jumptable", "Jump Table" and "jump table" at least. I'd say, do
> the last one everywhere pls.

Fair, sorry for my english being too german :) I changed everything to
'jump table'.

> > +	/* Reset remaining registers */
> > +	movl	$0, %esp
> > +	movl	$0, %eax
> > +	movl	$0, %ebx
> > +	movl	$0, %edx
> 
> All 4: use xor

XOR changes EFLAGS, can not use them here.

> > +
> > +	/* Reset CR0 to get out of protected mode */
> > +	movl	$0x60000010, %ecx
> 
> Another magic naked number.

This is the CR0 reset value. I have updated the comment to make this
more clear.

Thanks,

-- 
Jörg Rödel
jroedel@suse.de

SUSE Software Solutions Germany GmbH
Maxfeldstr. 5
90409 Nürnberg
Germany
 
(HRB 36809, AG Nürnberg)
Geschäftsführer: Ivo Totev

