Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E063F62E8
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 18:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbhHXQnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 12:43:32 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:43402 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhHXQnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 12:43:31 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 205B322135;
        Tue, 24 Aug 2021 16:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629823366; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=isWYk1M9QNpuXO9FuRvRqheKfZRsPlpGtIepCxZVGoc=;
        b=ojV0qS4/TobfqUQVIHzqulopYKzhfr7YeAuLUlQffqxwVTww6GuHwASrtXltT8+6v3Q0pX
        QTNQ7O3sCRnuLsoHbOMB8TE9MZ1z3b0YJzG0s6HAaHv1CcduJDAP8p/I35cJHrOA8fYGLD
        r/1kkgOAJYUeoAGOAJfQ8DeBYi7/QGM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629823366;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=isWYk1M9QNpuXO9FuRvRqheKfZRsPlpGtIepCxZVGoc=;
        b=TSjiA3LU1IdqszN3kR75s+E5wZotvKNo0OTMha2vwKDn84PJgVK827o+24QsOPTan+bn6k
        KZ45+rhl2dxSssAg==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id E5B1213A5B;
        Tue, 24 Aug 2021 16:42:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id XsHLNYQhJWFeXQAAGKfGzw
        (envelope-from <jroedel@suse.de>); Tue, 24 Aug 2021 16:42:44 +0000
Date:   Tue, 24 Aug 2021 18:42:43 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 08/45] x86/fault: Add support to handle the RMP
 fault for user address
Message-ID: <YSUhg/87jZPocLDP@suse.de>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-9-brijesh.singh@amd.com>
 <f6d778a0-840d-8c9c-392d-5c9ffcc0bdc6@intel.com>
 <19599ede-9fc5-25e1-dcb3-98aafd8b7e87@amd.com>
 <3f426ef8-060e-ccc9-71b9-2448f2582a30@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f426ef8-060e-ccc9-71b9-2448f2582a30@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 23, 2021 at 07:50:22AM -0700, Dave Hansen wrote:
> It *has* to be done in KVM, IMNHO.
> 
> The core kernel really doesn't know much about SEV.  It *really* doesn't
> know when its memory is being exposed to a virtualization architecture
> that doesn't know how to split TLBs like every single one before it.
> 
> This essentially *must* be done at the time that the KVM code realizes
> that it's being asked to shove a non-splittable page mapping into the
> SEV hardware structures.
> 
> The only other alternative is raising a signal from the fault handler
> when the page can't be split.  That's a *LOT* nastier because it's so
> much later in the process.
> 
> It's either that, or figure out a way to split hugetlbfs (and DAX)
> mappings in a failsafe way.

Yes, I agree with that. KVM needs a check to disallow HugeTLB pages in
SEV-SNP guests, at least as a temporary workaround. When HugeTLBfs
mappings can be split into smaller pages the check can be removed.

Regards,

	Joerg
