Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4240745095F
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 17:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbhKOQTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 11:19:51 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:37430 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbhKOQTh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 11:19:37 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DFA26212BF;
        Mon, 15 Nov 2021 16:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636992993; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7b7eH+fwmM30RusUMjRrdf/DCj90saq7UtYZ8DAMnVE=;
        b=PK/wWoUiH56BbJbfG6JFCeIiStKIJWdxb5ZDv/piXk065YE6yywS9Bfdk2pqZ5Euf6DbkX
        iB1AudlevlB2SVlVd2wuW6+GgrPSLyXciMm7fJ8HZNPJz1A0KlynGFhnfHpkHg/lm/xk5P
        eM2Mla4Kct4DF1At+fRfQSrNczrqeQg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636992993;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7b7eH+fwmM30RusUMjRrdf/DCj90saq7UtYZ8DAMnVE=;
        b=EtSwPakln53v33h6PvPpBNHLN4ca1UjxiDmIwWirzpQeCkMCqu/6QcQ5xnLJChPfnaFUzl
        nYjnxcD5gyDk3+DA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B510A139EC;
        Mon, 15 Nov 2021 16:16:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VwdfKuCHkmH+eAAAMHmgww
        (envelope-from <jroedel@suse.de>); Mon, 15 Nov 2021 16:16:32 +0000
Date:   Mon, 15 Nov 2021 17:16:31 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Borislav Petkov <bp@alien8.de>,
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
Message-ID: <YZKH35J2GjIZ9JXS@suse.de>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com>
 <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YY7FAW5ti7YMeejj@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021 at 07:48:17PM +0000, Sean Christopherson wrote:
> Yes, but IMO inducing a fault in the guest because of _host_ bug is wrong.

And what is the plan with handling this host bug? Can it be handled in a
way that keeps the guest running?

IMO the best way to handle this is to do it the way Peter proposed:

	* Convert the page from private to shared on host write access
	  and log this event on the host side (e.g. via a trace event)
	* The guest will notice what happened and can decide on its own
	  what to do, either poison the page or panic with doing a
	  kdump that can be used for bug analysis by guest and host
	  owner

At the time the fault happens we can not reliably find the reason. It
can be a host bug, a guest bug (or attack), or whatnot. So the best that
can be done is collecting debug data without impacting other guests.

This also saves lots of code for avoiding these faults when the outcome
would be the same: A dead VM.

> I disagree, this would require "new" ABI in the sense that it commits KVM to
> supporting SNP without requiring userspace to initiate any and all conversions
> between shared and private.  Which in my mind is the big elephant in the room:
> do we want to require new KVM (and kernel?) ABI to allow/force userspace to
> explicitly declare guest private memory for TDX _and_ SNP, or just TDX?

No, not for SNP. User-space has no say in what guest memory is private
and shared, that should fundamentally be the guests decision. The host
has no idea about the guests workload and how much shared memory it
needs. It might be that the guest temporarily needs to share more
memory. I see no reason to cut this flexibility out for SNP guests.

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

