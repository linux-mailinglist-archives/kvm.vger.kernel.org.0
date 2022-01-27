Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60C149DD2B
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 10:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238121AbiA0JBf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 04:01:35 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:50524 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbiA0JBe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 04:01:34 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 87ABA1F882;
        Thu, 27 Jan 2022 09:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643274093; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uf6L1U20L42jQ06xefiKuwA7v4ertkV/8P81jUSoYis=;
        b=VqCRighSWgCkUFJuLikNgA17cNUdoQJUUMG40XffnG266MZ4zbi84gI2NlZBRuFTgJEaa0
        fELyOdxO5Leeh+/wwz6VwxGtf+BdohVQUq4AQrdEgo3ph2A2b9/RzhSfnndwAtTjMobW1X
        RTKbzaqsHULmA3qdggTQzuSflnpTVG0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643274093;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uf6L1U20L42jQ06xefiKuwA7v4ertkV/8P81jUSoYis=;
        b=vGIapNrOTT3gC/AXlc2MXAoxBVjNtZ5L1hGxECi4SW4qf5MejumWnp/9gYGPfVvWB+VRLl
        rSXoTgEUWwhr6uAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B85E313CFB;
        Thu, 27 Jan 2022 09:01:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7cJPK2xf8mFaEwAAMHmgww
        (envelope-from <jroedel@suse.de>); Thu, 27 Jan 2022 09:01:32 +0000
Date:   Thu, 27 Jan 2022 10:01:31 +0100
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
Subject: Re: [PATCH v2 08/12] x86/sev: Park APs on AP Jump Table with GHCB
 protocol version 2
Message-ID: <YfJfa955Pkg1y6Gv@suse.de>
References: <20210913155603.28383-1-joro@8bytes.org>
 <20210913155603.28383-9-joro@8bytes.org>
 <YY6XQfmvmpmUiIGj@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YY6XQfmvmpmUiIGj@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021 at 05:33:05PM +0100, Borislav Petkov wrote:
> On Mon, Sep 13, 2021 at 05:55:59PM +0200, Joerg Roedel wrote:
> > +		     "ljmpl	*%0" : :
> > +		     "m" (real_mode_header->sev_real_ap_park_asm),
> > +		     "b" (sev_es_jump_table_pa >> 4));
> 
> In any case, this asm needs comments: why those regs, why
> sev_es_jump_table_pa >> 4 in rbx (I found later in the patch why) and so
> on.

Turned out the jump_table_pa is not used in asm code anymore. It was a
left-over from a previous version of the patch, it is removed now.

> > +SYM_INNER_LABEL(sev_ap_park_paging_off, SYM_L_GLOBAL)
> 
> Global symbol but used only in this file. .L-prefix then?

It needs to be a global symbol so the pa_ variant can be generated.

Regards,

-- 
Jörg Rödel
jroedel@suse.de

SUSE Software Solutions Germany GmbH
Maxfeldstr. 5
90409 Nürnberg
Germany
 
(HRB 36809, AG Nürnberg)
Geschäftsführer: Ivo Totev

