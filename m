Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A88645328B
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 14:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbhKPNFO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 08:05:14 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:57862 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbhKPNFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 08:05:13 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B5E1C212C3;
        Tue, 16 Nov 2021 13:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637067729; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HZbn//2jHoLXpUwrCvvkW6DSHLSoB+3INvS/r2/24sc=;
        b=FYRTscp/uk3I5t9ARhqDS+oQtcnEQmCncTzGPO3Hv9HK0a/NVU4TCKluaVO5R/7cGPqGbW
        LEx7IOGROGGptHOqKmq0pFGJfJkdtNfSh5LJ0HAz9Fwe6SfxQtUxJJ6h3bEnl8NYqni85w
        fHUT8gn/GEU0ASDMIXnyfZqwO8Oq4AI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637067729;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HZbn//2jHoLXpUwrCvvkW6DSHLSoB+3INvS/r2/24sc=;
        b=Ldn19b969Jzd4AIEqkaYx8K4ZPFYTGGbLwIV0KErqmeO5oTXcggS3KFfP/xdUBfurLUSgP
        B8CPXQUhz4RySSAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7D46E13BA3;
        Tue, 16 Nov 2021 13:02:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HRJfHNCrk2HmbwAAMHmgww
        (envelope-from <jroedel@suse.de>); Tue, 16 Nov 2021 13:02:08 +0000
Date:   Tue, 16 Nov 2021 14:02:06 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
Message-ID: <YZOrziJfGWHnBh++@suse.de>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com>
 <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
 <YZJTA1NyLCmVtGtY@work-vm>
 <YZKmSDQJgCcR06nE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YZKmSDQJgCcR06nE@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 06:26:16PM +0000, Sean Christopherson wrote:
> No, because as Andy pointed out, host userspace must already guard against a bad
> GPA, i.e. this is just a variant of the guest telling the host to DMA to a GPA
> that is completely bogus.  The shared vs. private behavior just means that when
> host userspace is doing a GPA=>HVA lookup, it needs to incorporate the "shared"
> state of the GPA.  If the host goes and DMAs into the completely wrong HVA=>PFN,
> then that is a host bug; that the bug happened to be exploited by a buggy/malicious
> guest doesn't change the fact that the host messed up.

The thing is that the usual checking mechanisms can't be applied to
guest-private pages. For user-space the GPA is valid if it fits into the
guest memory layout user-space set up before. But whether a page is
shared or private is the guests business. And without an expensive
reporting/query mechanism user-space doesn't have the information to do
the check.

A mechanism to lock pages to shared is also needed, and that creates the
next problems:

	* Who can release the lock, only the process which created it or
	  anyone who has the memory mapped?

	* What happens when a process has locked guest regions and then
	  dies with SIGSEGV, will its locks on guest memory be released
	  stay around forever?

And this is only what comes to mind immediatly, I sure there are more
problematic details in such an interface.

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

