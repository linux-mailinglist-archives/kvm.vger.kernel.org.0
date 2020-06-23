Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8AA52052D5
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 14:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732665AbgFWMrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 08:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732604AbgFWMrv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 08:47:51 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E21C061573;
        Tue, 23 Jun 2020 05:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jkxt7OeaBk/EwjAl7ixAPt2rC0deom9YDh1Xj9i6T3I=; b=fwRVdhQduSHsV4mqq0/FXOiPMS
        s0dHtMx1repRu6um7Uv/eCz+/1x0FzPev4WyvUhJe2f3EWmihYfJtP+kzCbDMxjWU8sDYGdhaBGiu
        H4LPSJdLsH6YIRcWVt9wom1Naz+buOKFzMeygtvDVDTo18unOPSJsTmuINEFYLM3ZHkQ244xmgUFb
        g13p8m+y9d8/1oB8QdUUaNGQfGCxekVXA56UtzDP4LK7l3UdgC6nZof0yg61zT3j6y5OmAUbpfIw5
        sAiDHVxix5EYCPoRuvxjNyyYzMVVyY+S+9w9jqXuIWMGEzx7wLRqtdSdp7mLTil5iMfPBpignDOEC
        IaJTvNgQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jniKX-0002Qr-RG; Tue, 23 Jun 2020 12:47:13 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 964B6300F28;
        Tue, 23 Jun 2020 14:47:12 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7ACB52370FA3D; Tue, 23 Jun 2020 14:47:12 +0200 (CEST)
Date:   Tue, 23 Jun 2020 14:47:12 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Joerg Roedel <jroedel@suse.de>, Andy Lutomirski <luto@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        Mike Stunes <mstunes@vmware.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Juergen Gross <JGross@suse.com>,
        Jiri Slaby <jslaby@suse.cz>, Kees Cook <keescook@chromium.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        X86 ML <x86@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: Should SEV-ES #VC use IST? (Re: [PATCH] Allow RDTSC and RDTSCP
 from userspace)
Message-ID: <20200623124712.GF4817@hirez.programming.kicks-ass.net>
References: <20200425191032.GK21900@8bytes.org>
 <910AE5B4-4522-4133-99F7-64850181FBF9@amacapital.net>
 <20200425202316.GL21900@8bytes.org>
 <CALCETrW2Y6UFC=zvGbXEYqpsDyBh0DSEM4NQ+L=_pp4aOd6Fuw@mail.gmail.com>
 <CALCETrXGr+o1_bKbnre8cVY14c_76m8pEf3iB_i7h+zfgE5_jA@mail.gmail.com>
 <20200428075512.GP30814@suse.de>
 <20200623110706.GB4817@hirez.programming.kicks-ass.net>
 <20200623113007.GH31822@suse.de>
 <8413fe52-04ee-f4e1-873c-17595110856a@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8413fe52-04ee-f4e1-873c-17595110856a@citrix.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 12:51:03PM +0100, Andrew Cooper wrote:

> There are cases which are definitely non-recoverable.
> 
> For both ES and SNP, a malicious hypervisor can mess with the guest
> physmap to make the the NMI, #VC and #DF stacks all alias.
> 
> For ES, this had better result in the #DF handler deciding that crashing
> is the way out, whereas for SNP, this had better escalate to Shutdown.

> Crashing out hard if the hypervisor is misbehaving is acceptable.

Then I'm thinking the only sensible option is to crash hard for any SNP
#VC from kernel mode.

Sadly that doesn't help with #VC needing to be IST :-( IST is such a
frigging nightmare.
