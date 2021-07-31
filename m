Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726A73DC464
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 09:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbhGaHTB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Jul 2021 03:19:01 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:45656 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbhGaHS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 31 Jul 2021 03:18:57 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C982C221EC;
        Sat, 31 Jul 2021 07:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1627715930; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WYXKdOA0fBvv3pT9/gbt1KAOZlZXQo7vqAE3CEoQmhc=;
        b=SIZqtvPzmOG/Ra46XoIlPdRUWTuUFNuTDrzOMC50MSV4nxIMkY5X4fyufS4wSZ25YIqksq
        KyNFHPZL6TJLku52OIdWlXz7sly68sLZKaWjTRandjx8g52RO0N39dvaz7FAIO7aMWMavo
        qmJJ/cdDK69bA4jpapVwzUKN0oEkU74=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1627715930;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WYXKdOA0fBvv3pT9/gbt1KAOZlZXQo7vqAE3CEoQmhc=;
        b=W5JnI93AVF4zlV18NHpo6fRUwu6MQgLRiKthCmKHv0li9fxNDaTCx2VrYtLlIcSEbgagVh
        1LnIRyxI9ZxFaTAA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 0524B1368F;
        Sat, 31 Jul 2021 07:18:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id eWMiO1n5BGG4OQAAGKfGzw
        (envelope-from <jroedel@suse.de>); Sat, 31 Jul 2021 07:18:49 +0000
Date:   Sat, 31 Jul 2021 09:18:48 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Eric Biederman <ebiederm@xmission.com>,
        kexec@lists.infradead.org, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
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
Subject: Re: [PATCH 04/12] x86/sev: Do not hardcode GHCB protocol version
Message-ID: <YQT5WPANjqXSytPR@suse.de>
References: <20210721142015.1401-1-joro@8bytes.org>
 <20210721142015.1401-5-joro@8bytes.org>
 <1eef6235-a8d0-1012-969e-ef6f0804d054@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1eef6235-a8d0-1012-969e-ef6f0804d054@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tom,

On Wed, Jul 21, 2021 at 04:17:38PM -0500, Tom Lendacky wrote:
> On 7/21/21 9:20 AM, Joerg Roedel wrote:
> >  	/* Fill in protocol and format specifiers */
> > -	ghcb->protocol_version = GHCB_PROTOCOL_MAX;
> > +	ghcb->protocol_version = sev_get_ghcb_proto_ver();
> 
> So this probably needs better clarification in the spec, but the GHCB
> version field is for the GHCB structure layout. So if you don't plan to
> use the XSS field that was added for version 2 of the layout, then you
> should report the GHCB structure version as 1.

Yeah, this makes sense, exept for the struct field-name ;) But anyway, I
keep the version field at 1 for now.

Regards,

	Joerg
