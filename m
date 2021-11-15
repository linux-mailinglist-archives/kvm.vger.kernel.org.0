Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76279450A29
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 17:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbhKOQzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 11:55:06 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:45536 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbhKOQzC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 11:55:02 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5DB8B1FD67;
        Mon, 15 Nov 2021 16:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636995125; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cF6gRwZuLUiNl2xcIEuaWtuAmHNRho9AqC9wCZCdOO8=;
        b=2KJORy1sTUR9wRfGJRyXN1nv07fZ38SBxoGMzZx7j5ZUIZb07k43gywgWn6t5eaokma2eZ
        SEcLIqcap+ac8M6xGtYdBATImFf7P060wRgr3dildxU+BJj9kcIfeXqUf53ODeHzDaXPSz
        Df8u11CzGh0d4gL04sJ103q8h2MjttM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636995125;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cF6gRwZuLUiNl2xcIEuaWtuAmHNRho9AqC9wCZCdOO8=;
        b=3+c573I918+mekzNcqL4MXr9DiRfrPEXE6oGKP4NmbVr/eMLhegZYO4En6CtGo1+4FVTzP
        M0kPCq11m8zgA8Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2AE9F13A66;
        Mon, 15 Nov 2021 16:52:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0yGvCDSQkmFoEwAAMHmgww
        (envelope-from <jroedel@suse.de>); Mon, 15 Nov 2021 16:52:04 +0000
Date:   Mon, 15 Nov 2021 17:52:02 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@intel.com>,
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
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <YZKQMgyebV6NT0P0@suse.de>
References: <YY7FAW5ti7YMeejj@google.com>
 <YY7I6sgqIPubTrtA@zn.tnic>
 <YY7Qp8c/gTD1rT86@google.com>
 <CAA03e5GwHMPYHHq3Nkkq1HnEJUUsw-Vk+5wFCott3pmJY7WuAw@mail.gmail.com>
 <2cb3217b-8af5-4349-b59f-ca4a3703a01a@www.fastmail.com>
 <CAA03e5Fw9cRnb=+eJmzEB+0QmdgaGZ7=fPTUYx7f55mGVXLRMA@mail.gmail.com>
 <CAMkAt6q9Wsw_KYypyZxhA1gkd=kFepk5rC5QeZ6Vo==P6=EAxg@mail.gmail.com>
 <YY8Mi36N/e4PzGP0@google.com>
 <CAA03e5F=7T3TcJBksiJ9ovafX65YfzAc0S+uYu5LjfTQ60yC7w@mail.gmail.com>
 <YZADwHxsx5cZ6m47@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YZADwHxsx5cZ6m47@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 13, 2021 at 06:28:16PM +0000, Sean Christopherson wrote:
> Another issue is that the host kernel, which despite being "untrusted", absolutely
> should be acting in the best interests of the guest.  Allowing userspace to inject
> #VC, e.g. to attempt to attack the guest by triggering a spurious PVALIDATE, means
> the kernel is failing miserably on that front.

Well, no. The kernel is only a part of the hypervisor, KVM userspace is
another. It is possible today for the userspace part(s) to interact in bad
ways with the guest and trick or kill it. Allowing user-space to cause a
#VC in the guest is no different from that.

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

