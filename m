Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24BA44EF12
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 23:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233569AbhKLWKG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 17:10:06 -0500
Received: from mail.skyhub.de ([5.9.137.197]:58186 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232139AbhKLWKF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 17:10:05 -0500
Received: from zn.tnic (p4fed33a9.dip0.t-ipconnect.de [79.237.51.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F0BF71EC0529;
        Fri, 12 Nov 2021 23:07:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1636754833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Rz0bvMnxj1mTcV1uKRokUV4035i6Ep9FMFYlLaZIcRU=;
        b=AzW7bLGwJw3aqcyrd9/ivwlTxGKaefH1BpiKsMx8IFGcyZqfWYKquWAdkBxOnUmm7krQcJ
        pkWiVRpkY+GmCNe0ALHUo9kn7M0dHKnQqRfHKREgQd/E0A7Tm3SKN+JZOuK+3gKwTf3eBS
        Wm6JnlJ8z/W93wrW1L9dOx26Fr5BKwA=
Date:   Fri, 12 Nov 2021 23:04:56 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
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
Message-ID: <YY7lCGB21gqp2Zah@zn.tnic>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com>
 <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
 <YY7I6sgqIPubTrtA@zn.tnic>
 <YY7Qp8c/gTD1rT86@google.com>
 <YY7USItsMPNbuSSG@zn.tnic>
 <CAMkAt6o909yYq3NfRboF3U3V8k-2XGb9p_WcQuvSjOKokmMzMA@mail.gmail.com>
 <869622df-5bf6-0fbb-cac4-34c6ae7df119@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <869622df-5bf6-0fbb-cac4-34c6ae7df119@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021 at 01:20:53PM -0800, Andy Lutomirski wrote:
> Can you clarify what type of host bug you're talking about here?  We're
> talking about the host kernel reading or writing guest private memory
> through the direct map or kmap, right?  It seems to me that the way this
> happens is:
> 
> struct page *guest_page = (get and refcount a guest page);
> 
> ...
> 
> guest switches the page to private;
> 
> ...
> 
> read or write the page via direct map or kmap.

Maybe I don't understand your example properly but on this access here,
the page is not gonna be validated anymore in the RMP table, i.e., on
the next access, the guest will get a #VC.

Or are you talking about a case where the host gets a reference to a
guest page and the guest - in the meantime - PVALIDATEs that page and
thus converts it into a private page?

So that case is simple: if the guest really deliberately gave that page
to the host to do stuff to it and it converted it to private in the
meantime, guest dies.

That's why it would make sense to have explicit consensus between guest
and host which pages get shared. Everything else is not going to be
allowed and the entity at fault pays the consequences.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
