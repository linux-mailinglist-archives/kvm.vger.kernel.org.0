Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF77D34AF49
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 20:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbhCZTWf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 15:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhCZTWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 15:22:13 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B9C5C0613AA;
        Fri, 26 Mar 2021 12:22:13 -0700 (PDT)
Received: from zn.tnic (p200300ec2f075f009137b2b45d3c68fe.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:5f00:9137:b2b4:5d3c:68fe])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9D5BD1EC053B;
        Fri, 26 Mar 2021 20:22:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1616786531;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2PK6VlpQ7yr3XeTWBabuXpI2dtKVX7LC4l+bJOdrm2E=;
        b=PqW4Sb8lMqhsFmDJX1/qoKQJ2Ht2id/fUYuzq7SVcF1zJuYIMepXk0Z1gBGJVTE45kdcec
        gQhaLj3R+k1Q0mLzEMytfC2GL8aBOdqkiXGdTpPOKDUFg7gWddtzw1bRF11LAxwxrI+x/S
        F8yd+Fl//rUGXtqxCerzt1fWSh24b1s=
Date:   Fri, 26 Mar 2021 20:22:14 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        ak@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part1 PATCH 03/13] x86: add a helper routine for the
 PVALIDATE instruction
Message-ID: <20210326192214.GK25229@zn.tnic>
References: <20210324164424.28124-1-brijesh.singh@amd.com>
 <20210324164424.28124-4-brijesh.singh@amd.com>
 <20210326143026.GB27507@zn.tnic>
 <9c9773d1-c494-2dfe-cd2a-95e3cfdfa09f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9c9773d1-c494-2dfe-cd2a-95e3cfdfa09f@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 26, 2021 at 10:42:56AM -0500, Brijesh Singh wrote:
> There is no strong reason for a separate sev-snp.h. I will add a
> pre-patch to rename sev-es.h to sev.h and add SNP stuff to it.

Thx.

> I was trying to adhere to existing functions which uses a direct
> instruction opcode.

That's not really always the case:

arch/x86/include/asm/special_insns.h

The "__" prefixed things should mean lower abstraction level helpers and
we drop the ball on those sometimes.

> It's not duplicate error code. The EAX returns an actual error code. The
> rFlags contains additional information. We want both the codes available
> to the caller so that it can make a proper decision.
> 
> e.g.
> 
> 1. A callers validate an address 0x1000. The instruction validated it
> and return success.

Your function returns PVALIDATE_SUCCESS.

> 2. Caller asked to validate the same address again. The instruction will
> return success but since the address was validated before hence
> rFlags.CF will be set to indicate that PVALIDATE instruction did not
> made any change in the RMP table.

Your function returns PVALIDATE_VALIDATED_ALREADY or so.

> You are correct that currently I am using only carry flag. So far we
> don't need other flags. What do you think about something like this:
> 
> * Add a new user defined error code
> 
>  #define PVALIDATE_FAIL_NOUPDATE        255 /* The error is returned if
> rFlags.CF set */

Or that.

> * Remove the rFlags parameters from the __pvalidate()

Yes, it seems unnecessary at the moment. And I/O function arguments are
always yuck.

> * Update the __pvalidate to check the rFlags.CF and if set then return
> the new user-defined error code.

Yap, you can convert all that to pvalidate() return values, methinks,
and then make that function simpler for callers because they should
not have to deal with rFLAGS - only return values to denote what the
function did.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
