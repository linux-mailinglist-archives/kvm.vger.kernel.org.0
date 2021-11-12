Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCDB44EEB8
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 22:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235802AbhKLVkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 16:40:45 -0500
Received: from mail.skyhub.de ([5.9.137.197]:54232 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235698AbhKLVko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 16:40:44 -0500
Received: from zn.tnic (p4fed33a9.dip0.t-ipconnect.de [79.237.51.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B53951EC0554;
        Fri, 12 Nov 2021 22:37:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1636753071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=A0iII0qVuog0Us7YryaxXrUyUW2CBNn6Ykbyj7Igh68=;
        b=YZuttsgWwb+WKurJdCNhc5NmHv25S0MaUbJTuzppmjXZ5dM8Uni2tWbVFdStd/xywoMfx+
        +/9Pfb/VS/49AlbSRQyGMxHJ72nLMZG28+TdmLG3H76n816eT7L+S5RoOkum81AS5YwwQm
        wdE1jX0Drz1biV+Y775fQOs2z+IaMhg=
Date:   Fri, 12 Nov 2021 22:35:35 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Marc Orr <marcorr@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Gonda <pgonda@google.com>,
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
        Michael Roth <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <YY7eJ8/tpPL4zJmq@zn.tnic>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com>
 <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
 <CAA03e5EpQZnNzWgRsCAahwwvsd6+QVnRHdiYFM=GhEb2N1W0GQ@mail.gmail.com>
 <ffcf2585-feef-d86c-efbd-8a53f73437ad@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ffcf2585-feef-d86c-efbd-8a53f73437ad@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021 at 01:23:25PM -0800, Andy Lutomirski wrote:
> SEV-SNP, TDX, and any reasonable software solution all require that the host
> know which pages are private and which pages are shared.  Sure, the old
> SEV-ES Linux host implementation was very simple, but it's nasty and
> fundamentally can't support migration.

Right, so at least SNP guests need to track which pages have been
already PVALIDATEd by them so that they don't validate them again. So if
we track that somewhere in struct page or wherever, that same bit can be
used to state, page is private or shared.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
