Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E51645075B
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 15:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbhKOOpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 09:45:53 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:58152 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232156AbhKOOpo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 09:45:44 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E53D3212BE;
        Mon, 15 Nov 2021 14:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636987367; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CurHMBKJtGDElStoPcZcZiFRey4p43QkUhyCC85DQy8=;
        b=pxkXvCMQv5Aw/Dwj11Q1Yc61t5roI2OFQiwgMiOI56i7+CFiexIBAJMvBvB1/+c5/vhE/Y
        s58fOGRNhnOL9UQXVl4FmLw4iXuSY4HwqmtGcxuz5wr/kSfudc/1zFe6x5vr/TCVFhwS+O
        Pd+yrrNxBVpVig+F0x26RzQJeuoky8E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636987367;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CurHMBKJtGDElStoPcZcZiFRey4p43QkUhyCC85DQy8=;
        b=CX/tmvhzVt1su/AdrYGXZ7EY04Z2tin5GBffGXKCePBskL8D1T22oMvRd4mX1yEX2nzdJs
        b6ak9mMTuAoFh5Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 87AC713A66;
        Mon, 15 Nov 2021 14:42:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vTH+HuZxkmGXMQAAMHmgww
        (envelope-from <jroedel@suse.de>); Mon, 15 Nov 2021 14:42:46 +0000
Date:   Mon, 15 Nov 2021 15:42:44 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
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
Message-ID: <YZJx5PcBZ/izVg8L@suse.de>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com>
 <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com>
 <YZJTA1NyLCmVtGtY@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZJTA1NyLCmVtGtY@work-vm>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 12:30:59PM +0000, Dr. David Alan Gilbert wrote:
> Still; I wonder if it's best to kill the guest - maybe it's best for
> the host to kill the guest and leave behind diagnostics of what
> happened; for someone debugging the crash, it's going to be less useful
> to know that page X was wrongly accessed (which is what the guest would
> see), and more useful to know that it was the kernel's vhost-... driver
> that accessed it.

I is best to let the guest #VC on the page when this happens. If it
happened because of a guest bug all necessary debugging data is in the
guest and only the guest owner can obtain it.

Then the guest owner can do a kdump on this unexpected #VC and collect
the data to debug the issue. With just killing the guest from the host
side this data would be lost.

Regards,

	Joerg
