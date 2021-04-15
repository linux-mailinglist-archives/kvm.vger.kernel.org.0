Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3049361319
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 21:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235030AbhDOTuw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 15:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234226AbhDOTuv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 15:50:51 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B28C061574;
        Thu, 15 Apr 2021 12:50:27 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0ace009d15a56636e5abd2.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:ce00:9d15:a566:36e5:abd2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 063121EC03E4;
        Thu, 15 Apr 2021 21:50:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1618516226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=m+1u7jWekMJzRnPaUKo/hlQMLbQ3pB3EnuCoWlBcJwE=;
        b=gC/HenhFlKg6OxOBD5VmBJE7r2uQnnyrYhzs7L7smfXhCX62Dm4DyBu8DDw9HPr/dclVF7
        tWQhGAdvoTQgF/bnrvyy/Fms2w0qHDXUavv/J2XYx1SjESSCNHXwO0y3Bl6kVdvijQKUWm
        BZCr/BMY883/B+Eclm1Ezk8MUMmxUgY=
Date:   Thu, 15 Apr 2021 21:50:20 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, ak@linux.intel.com,
        herbert@gondor.apana.org.au, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part2 PATCH 02/30] x86/sev-snp: add RMP entry lookup helpers
Message-ID: <20210415195020.GG6318@zn.tnic>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-3-brijesh.singh@amd.com>
 <20210415165711.GD6318@zn.tnic>
 <1813139d-f5f9-3791-dadb-4a684fe1cf46@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1813139d-f5f9-3791-dadb-4a684fe1cf46@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 15, 2021 at 01:08:09PM -0500, Brijesh Singh wrote:
> This is from Family 19h Model 01h Rev B01. The processor which
> introduces the SNP feature. Yes, I have already upload the PPR on the BZ.
> 
> The PPR is also available at AMD: https://www.amd.com/en/support/tech-docs

Please add the link in the bugzilla to the comments here - this is the
reason why stuff is being uploaded in the first place, because those
vendor sites tend to change and those links become stale with time.

> I guess I was trying to shorten the name. I am good with struct rmpentry;

Yes please - typedefs are used only in very specific cases.

> All those magic numbers are documented in the PPR.

We use defines - not magic numbers. For example

#define RMPTABLE_ENTRIES_OFFSET 0x4000

The 8 is probably

PAGE_SHIFT - RMPENTRY_SHIFT

because you have GPA bits [50:12] and an RMP entry is 16 bytes, i.e., 1 << 4.

With defines it is actually clear what the computation is doing - with
naked numbers not really.

> APM does not provide the offset of the entry inside the RMP table.

It does, kinda, but in the pseudocode of those new insns in APM v3. From
PVALIDATE pseudo:

	RMP_ENTRY_PA = RMP_BASE + 0x4000 + (SYSTEM_PA / 0x1000) * 16

and that last

	/ 0x1000 * 16

is actually

	>> 12 - 4

i.e., the >> 8 shift.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
