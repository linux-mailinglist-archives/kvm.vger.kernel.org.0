Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9208A3641BA
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 14:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239097AbhDSMdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 08:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233780AbhDSMdH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 08:33:07 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F43C06174A;
        Mon, 19 Apr 2021 05:32:37 -0700 (PDT)
Received: from zn.tnic (p200300ec2f078100b366c1e70d1e8d9d.dip0.t-ipconnect.de [IPv6:2003:ec:2f07:8100:b366:c1e7:d1e:8d9d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8511C1EC0283;
        Mon, 19 Apr 2021 14:32:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1618835552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=vCGEvRMDH0rrbCfjQ2X9p8m5Gtw0cPGam+h/egSoMNc=;
        b=V9ZPCIFlhpbQYkPk+sI9Ccev1lyvF0iMPPx+SDbLMYnc/NuDaeFjwuEOyLqkJygh7yI/89
        UsE6ZYHOwz7TKQM8F6Ns47UmU3QrEWMTFGsEuhE4vShqSNPf80gu7eIhPfwNb7MPIY3C3y
        wvsVoBdF0qrw9nA/FqH1ZNqRBN7uv0E=
Date:   Mon, 19 Apr 2021 14:32:26 +0200
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
        Sean Christopherson <seanjc@google.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [RFC Part2 PATCH 04/30] x86/mm: split the physmap when adding
 the page in RMP table
Message-ID: <20210419123226.GC9093@zn.tnic>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-5-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210324170436.31843-5-brijesh.singh@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021 at 12:04:10PM -0500, Brijesh Singh wrote:
> A write from the hypervisor goes through the RMP checks. When the
> hypervisor writes to pages, hardware checks to ensures that the assigned
> bit in the RMP is zero (i.e page is shared). If the page table entry that
> gives the sPA indicates that the target page size is a large page, then
> all RMP entries for the 4KB constituting pages of the target must have the
> assigned bit 0.

Hmm, so this is important: I read this such that we can have a 2M
page table entry but the RMP table can contain 4K entries for the
corresponding 512 4K pages. Is that correct?

If so, then there's a certain discrepancy here and I'd expect that if
the page gets split/collapsed, depending on the result, the RMP table
should be updated too, so that it remains in sync.

For example:

* mm decides to group all 512 4K entries into a 2M entry, RMP table gets
updated in the end to reflect that

* mm decides to split a page, RMP table gets updated too, for the same
reason.

In this way, RMP table will be always in sync with the pagetables.

I know, I probably am missing something but that makes most sense to
me instead of noticing the discrepancy and getting to work then, when
handling the RMP violation.

Or?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
