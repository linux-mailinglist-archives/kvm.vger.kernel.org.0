Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5A8709BF
	for <lists+kvm@lfdr.de>; Mon, 22 Jul 2019 21:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfGVTdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jul 2019 15:33:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37354 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbfGVTdE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jul 2019 15:33:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=zw0OzLY2qkyLgMJYZmR8YfjGW2oVP8VhhsbR5Yd/A7w=; b=TqldDQQlZ5ZIvVudiXOATvg8+6
        99A+Mn8ucymBMPFhYx39j7RhwEqzKlskYs7uBA2fXig+Bxy7FrABNjSPOmH4GIcSvZhdDn6/2+ZsJ
        VUg6cZbX8pBbqtj2bpRyU9Hzp/nnIWZowUX2X0jd2bLQuCjO1IrSHkq7ZpEA2agi1YNRwmTRLLboh
        67TOwpPTag0FdERZ4yZ/3XiWzg/K9OYALvLZ0986XmDMNqvH4LVlmKnnhtNsUUIsaVZ0eY6sn+2NN
        AtPJRQxOZ5Fl/h2Qzpox5vkgD09aPBondQwxq2tWQ+ZSFyHsqkgVr0smD7+AfjWNC6hLNxOuTf5H+
        UtPXJ1DA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hpe3J-0006Hn-Eh; Mon, 22 Jul 2019 19:32:53 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id A1F78980C59; Mon, 22 Jul 2019 21:32:51 +0200 (CEST)
Date:   Mon, 22 Jul 2019 21:32:51 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nadav Amit <namit@vmware.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Juergen Gross <jgross@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH v3 4/9] x86/mm/tlb: Flush remote and local TLBs
 concurrently
Message-ID: <20190722193251.GF6698@worktop.programming.kicks-ass.net>
References: <20190719005837.4150-1-namit@vmware.com>
 <20190719005837.4150-5-namit@vmware.com>
 <20190722191433.GD6698@worktop.programming.kicks-ass.net>
 <58DA0841-33C2-4D16-A671-08064A15001C@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <58DA0841-33C2-4D16-A671-08064A15001C@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 22, 2019 at 07:27:09PM +0000, Nadav Amit wrote:
> > On Jul 22, 2019, at 12:14 PM, Peter Zijlstra <peterz@infradead.org> wrote:

> > But then we can still do something like the below, which doesn't change
> > things and still gets rid of that dual function crud, simplifying
> > smp_call_function_many again.

> Nice! I will add it on top, if you don’t mind (instead squashing it).

Not at all.

> The original decision to have local/remote functions was mostly to provide
> the generality.
> 
> I would change the last argument of __smp_call_function_many() from “wait”
> to “flags” that would indicate whether to run the function locally, since I
> don’t want to change the semantics of smp_call_function_many() and decide
> whether to run the function locally purely based on the mask. Let me know if
> you disagree.

Agreed.
