Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0F04532C8
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 14:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236671AbhKPNYz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 08:24:55 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:59814 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbhKPNYv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 08:24:51 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id F3BD92171F;
        Tue, 16 Nov 2021 13:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637068913; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bj8OHCgSrbq+V/cw6sxiyhHVBBsU+2OM597MpAb5BZg=;
        b=FvHU/jl2199AE2bExbH95cSBnVBc0A0DFymdn7Ycad6qFhI0sckwmP/6PpgjWav9JyM27A
        RcUhTulu5ISAeqWUEJXqB8r5VKYA1gaSFuU/IIWwjEAU3ARxJmRHUhhDFakcU8RGjUc3gD
        Ye9KJCcqExc1c8jC8bVb3SxpPKRMwX8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637068913;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bj8OHCgSrbq+V/cw6sxiyhHVBBsU+2OM597MpAb5BZg=;
        b=W+CsR+ED9QoPp02iJkTfQhcpL4p4plyUvfGYY2ay2mfW7qf5xMIFb0wnBh/E6eCKTShf51
        2yy6k64D1S2MMQBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id ACDB313C1B;
        Tue, 16 Nov 2021 13:21:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OyV6KG+wk2EDeQAAMHmgww
        (envelope-from <jroedel@suse.de>); Tue, 16 Nov 2021 13:21:51 +0000
Date:   Tue, 16 Nov 2021 14:21:50 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Marc Orr <marcorr@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-coco@lists.linux.dev,
        linux-mm@kvack.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <YZOwbjGVEfa/wLaS@suse.de>
References: <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com>
 <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
 <YZJTA1NyLCmVtGtY@work-vm>
 <YZKmSDQJgCcR06nE@google.com>
 <CAA03e5E3Rvx0t8_ZrbNMZwBkjPivGKOg5HCShSFYwfkKDDHWtA@mail.gmail.com>
 <YZKxuxZurFW6BVZJ@google.com>
 <CAA03e5GBajwRJBuTJLPjji7o8QD2daEUJU7DpPJBxtWsf-DE8g@mail.gmail.com>
 <8a244d34-2b10-4cf8-894a-1bf12b59cf92@www.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8a244d34-2b10-4cf8-894a-1bf12b59cf92@www.fastmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 09:14:14PM -0800, Andy Lutomirski wrote:
> It’s time to put on my maintainer hat. This is solidly in my
> territory, and NAK.  A kernel privilege fault, from who-knows-what
> context (interrupts off? NMI? locks held?) that gets an RMP violation
> with no exception handler is *not* going to blindly write the RMP and
> retry.  It’s not going to send flush IPIs or call into KVM to “fix”
> things.  Just the locking issues alone are probably showstopping, even
> ignoring the security and sanity issues.

RMP faults are expected from two contexts:

	* User-space
	* KVM running in task context

The only situation where RMP faults could happen outside of these
contexts is when running a kexec'ed kernel, which was launched while SNP
guests were still running (that needs to be taken care of as well).

And from the locking side, which lock does the #PF handler need to take?
Processors supporting SNP also have hardware support for flushing remote
TLBs, so locks taken in the flush path are not strictly required.

Calling into KVM is another story and needs some more thought, I agree
with that.

> Otherwise can we please get on with designing a reasonable model for
> guest-private memory please?

It is fine to unmap guest-private memory from the host kernel, even if
it is not required by SNP. TDX need to do that because of the #MC thing
that happens otherwise, but that is also just a way to emulate an
RMP-like fault with TDX.

But as Marc already pointed out, the kernel needs a plan B when an RMP
happens anyway due to some bug.

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

