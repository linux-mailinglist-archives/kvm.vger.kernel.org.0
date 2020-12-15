Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08342DAECA
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 15:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgLOOUZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 09:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727227AbgLOOUO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 09:20:14 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84008C06179C;
        Tue, 15 Dec 2020 06:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=n3MIZt3/znb4uRxmCaPyGVKsSFg4njtwCHLsmpqHHtc=; b=j5aJJbiLj/qdgQPvO1H9cZO69S
        cghj1tVt1MmeFUvrTyb7sI8SjpJMY/zf9c3AF09ZpaS3kpNRMq7Qcza+a+4SVPftUg92+de3j06ij
        TpvnEmE1F1M9N0xpaIyBwLxOwyzPMjM1Fuu/184ceVPJZHJ8yc8/CxeiHpKLfHNVY2JdoHHrZrv/6
        52/R56RdCA7sZvOvf5pukk87Nrmwsfm/qV5Ymb9hkIGZ805z6H/EQBg+eqwMVq1zBU/Ekh8ZN0Wyq
        bkHOj3MQ8RLBs8mNaGQ8LQey8vYZ+0uPL6pOynf1wFmF5Sb2xwez3kwxSkQndlTWxEbDpMaIXx+2n
        SfEy17IQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kpB9x-0007Qz-Vq; Tue, 15 Dec 2020 14:18:38 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C214A300446;
        Tue, 15 Dec 2020 15:18:34 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A8CE3200CFB30; Tue, 15 Dec 2020 15:18:34 +0100 (CET)
Date:   Tue, 15 Dec 2020 15:18:34 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org, luto@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Deep Shah <sdeep@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2 00/12] x86: major paravirt cleanup
Message-ID: <20201215141834.GG3040@hirez.programming.kicks-ass.net>
References: <20201120114630.13552-1-jgross@suse.com>
 <20201120125342.GC3040@hirez.programming.kicks-ass.net>
 <20201123134317.GE3092@hirez.programming.kicks-ass.net>
 <6771a12c-051d-1655-fb3a-cc45a3c82e29@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <6771a12c-051d-1655-fb3a-cc45a3c82e29@suse.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 15, 2020 at 12:42:45PM +0100, J=FCrgen Gro=DF wrote:
> Peter,
>=20
> On 23.11.20 14:43, Peter Zijlstra wrote:
> > On Fri, Nov 20, 2020 at 01:53:42PM +0100, Peter Zijlstra wrote:
> > > On Fri, Nov 20, 2020 at 12:46:18PM +0100, Juergen Gross wrote:
> > > >   30 files changed, 325 insertions(+), 598 deletions(-)
> > >=20
> > > Much awesome ! I'll try and get that objtool thing sorted.
> >=20
> > This seems to work for me. It isn't 100% accurate, because it doesn't
> > know about the direct call instruction, but I can either fudge that or
> > switching to static_call() will cure that.
> >=20
> > It's not exactly pretty, but it should be straight forward.
>=20
> Are you planning to send this out as an "official" patch, or should I
> include it in my series (in this case I'd need a variant with a proper
> commit message)?

Ah, I was waiting for Josh to have an opinion (and then sorta forgot
about the whole thing again). Let me refresh and provide at least a
Changelog.
