Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874AF44D549
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 11:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbhKKKvz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 05:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbhKKKvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 05:51:48 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1771AC061766;
        Thu, 11 Nov 2021 02:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Lk4G/R3I07fhmcAqeSUqtCqNDck8UECisYgW0RP2fZk=; b=AET3uxMt3hHFzdG81TShZLlRhA
        lnzx4x2xkBejjcu8i+MuOlBWGAq82yBnQhP9jNhSKqzutZkvoPrE+DaFRBQ2JOb4j5DojW+YmB1TQ
        EZfc3k1Z3m4KXMajFbDtwS9023NbK50LztQbXevsdQvS6AOv4JY3DBFmFrzKqXOH+RV3M0pyTvPbI
        9sn7wEgLyUpWZTEsemou0MiLDGDeur8Ama9taCLIXAaN6Ru7/xY5zsA5qZdI+ad11Hfx7npvyG54r
        SstAvX6uYL3TOGkFqkoXYIn4TKwOJvn7Eki+iTRy2VOK059F6VHaZNIoBBTll1KF9xSh0wvNlGSuH
        NL6Mf2Yg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ml7ce-002eyR-My; Thu, 11 Nov 2021 10:48:01 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CB96930001B;
        Thu, 11 Nov 2021 11:47:57 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 950042D1ADCA5; Thu, 11 Nov 2021 11:47:57 +0100 (CET)
Date:   Thu, 11 Nov 2021 11:47:57 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Guo Ren <guoren@kernel.org>, Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-csky@vger.kernel.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Like Xu <like.xu@linux.intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: Re: [PATCH v4 01/17] perf: Protect perf_guest_cbs with RCU
Message-ID: <YYz03fcDRV9NZnyA@hirez.programming.kicks-ass.net>
References: <20211111020738.2512932-1-seanjc@google.com>
 <20211111020738.2512932-2-seanjc@google.com>
 <d784dc27-72d0-d64f-e1f4-a2b9a5f86dd4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d784dc27-72d0-d64f-e1f4-a2b9a5f86dd4@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 11, 2021 at 08:26:58AM +0100, Paolo Bonzini wrote:
> On 11/11/21 03:07, Sean Christopherson wrote:

> >   EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks);
> >   int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
> >   {
> > -	perf_guest_cbs = NULL;
> > +	if (WARN_ON_ONCE(rcu_access_pointer(perf_guest_cbs) != cbs))
> > +		return -EINVAL;
> > +
> > +	rcu_assign_pointer(perf_guest_cbs, NULL);
> > +	synchronize_rcu();
> This technically could be RCU_INIT_POINTER but it's not worth a respin.
> There are dozens of other occurrences, and if somebody wanted they
> could use Coccinelle to fix all of them.

I've been pushing the other way, trying to get rid of RCU_INIT_POINTER()
since rcu_assign_pointer(, NULL) actualy DTRT per __builtin_constant_p()
etc.

There's a very few sites where we use RCU_INIT_POINTER() with a !NULL
argument, and those are 'special'.
