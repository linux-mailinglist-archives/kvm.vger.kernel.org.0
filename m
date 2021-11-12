Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E90344ECAA
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 19:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbhKLSiV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 13:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235510AbhKLSiU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 13:38:20 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E879C061766;
        Fri, 12 Nov 2021 10:35:28 -0800 (PST)
Received: from zn.tnic (p200300ec2f10ce00d687ada8c7fa1c88.dip0.t-ipconnect.de [IPv6:2003:ec:2f10:ce00:d687:ada8:c7fa:1c88])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id A5E241EC03AD;
        Fri, 12 Nov 2021 19:35:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1636742126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=JmA2cfYq/RSf+0ammQvVqrSmh6MfYoVev6SVnovd+no=;
        b=ECPlX/c1Pahyqr2/in+oog3PPH5hgi86QxIT/3FK6k2C1LOWpJ48d8oSC02yYxCr0jhJpC
        Zotq7GNmwIX01kKhehALvprcqEpVGp8V42oRd4RF5oNa3hrFQAHydUx41Fv9E/GGctyuyp
        VNaqgHj42R1Ut+uwWiG6v4Pp6CoP96g=
Date:   Fri, 12 Nov 2021 19:35:19 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <YY6z5/0uGJmlMuM6@zn.tnic>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021 at 09:59:46AM -0800, Dave Hansen wrote:
> Or, is there some mechanism that prevent guest-private memory from being
> accessed in random host kernel code?

So I'm currently under the impression that random host->guest accesses
should not happen if not previously agreed upon by both.

Because, as explained on IRC, if host touches a private guest page,
whatever the host does to that page, the next time the guest runs, it'll
get a #VC where it will see that that page doesn't belong to it anymore
and then, out of paranoia, it will simply terminate to protect itself.

So cloud providers should have an interest to prevent such random stray
accesses if they wanna have guests. :)

> This sounds like a _possible_ opportunity for the guest to do some extra
> handling.  It's also quite possible that this #VC happens in a place
> that the guest can't handle.

How? It'll get a #VC when it first touches that page.

I'd say the #VC handler should be able to deal with it...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
