Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE2B357520
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 21:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355721AbhDGTqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 15:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355666AbhDGTqB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 15:46:01 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028F9C06175F;
        Wed,  7 Apr 2021 12:45:52 -0700 (PDT)
Received: from zn.tnic (p200300ec2f08fb0020f55c189e926593.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:fb00:20f5:5c18:9e92:6593])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 804211EC027D;
        Wed,  7 Apr 2021 21:45:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1617824750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=4Puw/f2inG+ZQu4nlRXPJ5moZ3IcdquuqTQWZAcVWIU=;
        b=gdd2RqFQWYXI38oSYUTTo5LfHOTbS35aTqj65jtabpOkJoK3i4WB3xNmfTAmuwawYJgpSL
        0EGfryo6eHPgaGf5luSn4GwxKs7zEfaDNpv8zpPgLjSoZO8+12H4HNFwYsrmci9tG8eGU8
        Zg+M/6Y1oq24+p/OEcqvg36xmHotEpw=
Date:   Wed, 7 Apr 2021 21:45:50 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 06/13] x86/compressed: rescinds and validate
 the memory used for the GHCB
Message-ID: <20210407194550.GO25319@zn.tnic>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-7-brijesh.singh@amd.com>
 <20210406103358.GL17806@zn.tnic>
 <c9f60432-2484-be1e-7b08-86dae5aa263f@amd.com>
 <67f92f5c-780c-a4c6-241a-6771558e81a3@amd.com>
 <20210407112555.GB25319@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210407112555.GB25319@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 07, 2021 at 01:25:55PM +0200, Borislav Petkov wrote:
> On Tue, Apr 06, 2021 at 02:42:43PM -0500, Tom Lendacky wrote:
> > The GHCB spec only defines the "0" reason code set. We could provide Linux
> > it's own reason code set with some more specific reason codes for
> > failures, if that is needed.
> 
> Why Linux only?
> 
> Don't we want to have a generalized set of error codes which say what
> has happened so that people can debug?

To quote Tom from IRC - and that is perfectly fine too, AFAIC:

<tlendacky> i'm ok with it, but i don't think it should be something dictated by the spec.  the problem is if you want to provide a new error code then the spec has to be updated constantly
<tlendacky> that's why i said, pick a "reason code set" value and say those are what Linux will use. We could probably document them in Documentation/
<tlendacky> the error code thing was an issue when introduced as part of the first spec.  that's why only a small number of reason codes are specified

Yap, makes sense. What we should do in the spec, though, is say: "This
range is for vendor-specific error codes".

Also, is GHCBData[23:16] big enough and can we extend it simply? Or do
we need the spec to at least dictate some ranges so that it can use some bits
above, say, bit 32 or whatever the upper range of the extension is...

Hmmm.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
