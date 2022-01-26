Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A394649C648
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 10:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239136AbiAZJ12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 04:27:28 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:50074 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239117AbiAZJ11 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 04:27:27 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8BD54212BF;
        Wed, 26 Jan 2022 09:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643189245; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KYpEiGK3ZZrbGlIMn1GiimLekwuOkP30FhRWgFzfNL4=;
        b=KUrcZW+ZrP3PWs1LyFoOmANdJw2sANUUe/xOvO841e19zsRGMrBBr3/yXceRmChglTXu7K
        j7EDr7CNbv3L4xOWSrU2DDR11kUZvuxMMLkJBLMso6kwFM9sNkL8XRHnawtahVhu0RNpFT
        P+Aq7sNAD8s0hO0OtUuqsvHU4k0QIa8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643189245;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KYpEiGK3ZZrbGlIMn1GiimLekwuOkP30FhRWgFzfNL4=;
        b=eYr7rT7lf9/jXwUJ98PIDo/BEVJVr14oyJxBGtdFFewNToNpRUVXbAWv+agYKUkvuwKGlY
        VN7deTaKrjC3WpAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BBEBA13B2B;
        Wed, 26 Jan 2022 09:27:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CNwsLPwT8WFmSQAAMHmgww
        (envelope-from <jroedel@suse.de>); Wed, 26 Jan 2022 09:27:24 +0000
Date:   Wed, 26 Jan 2022 10:27:23 +0100
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
Subject: Re: [PATCH v2 03/12] x86/sev: Save and print negotiated GHCB
 protocol version
Message-ID: <YfET+7amPSKLnZWu@suse.de>
References: <20210913155603.28383-1-joro@8bytes.org>
 <20210913155603.28383-4-joro@8bytes.org>
 <YYKcS2OIzAV+MTzr@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YYKcS2OIzAV+MTzr@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 03, 2021 at 03:27:23PM +0100, Borislav Petkov wrote:
> On Mon, Sep 13, 2021 at 05:55:54PM +0200, Joerg Roedel wrote:
> > From: Joerg Roedel <jroedel@suse.de>
> > 
> > Save the results of the GHCB protocol negotiation into a data structure
> > and print information about versions supported and used to the kernel
> > log.
> 
> Which is useful for?

For easier debugging, I added a sentence about that to the changelog.

> > +struct sev_ghcb_protocol_info {
> 
> Too long a name - ghcb_info is perfectly fine.

Changed, thanks.

-- 
Jörg Rödel
jroedel@suse.de

SUSE Software Solutions Germany GmbH
Maxfeldstr. 5
90409 Nürnberg
Germany
 
(HRB 36809, AG Nürnberg)
Geschäftsführer: Ivo Totev

