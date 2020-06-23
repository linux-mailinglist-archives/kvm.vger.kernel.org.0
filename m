Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5682056DC
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 18:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732610AbgFWQOM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 12:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732253AbgFWQOM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 12:14:12 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B63FC061573;
        Tue, 23 Jun 2020 09:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2ZeuviZXPtyZ/aF+IWZIvBCFWEao8ngk72TsRFpdUlQ=; b=ATjsWIR5mScsdXgmjIWTkFg1Wk
        j3PvAh/3jFwmTPn+cKufy4YfwEAVTB5Q+YDKJxIFA/YBf8QnuKGZB6iBvijGNLqsyu010C+STY8WW
        LAB3d9puouEtlsYWgQtJ+x3DVKMIoh/RG/cNY63fcTwbR+z6FfaHoyxaXbpm9V+Gsr6kNlqXZaL0H
        Ea0iQWyFLSV4klNOb2ksXlD1PlNyImPPRPhFq5Tv2I6Q3BeNur0uGK7mHwgDTiWh9oUuj3yijj6Sy
        VY7TJOMc0JboU8lVaX9JX8xVVicMeVSgx92/mx8HMv+xWWnNs0kZMIoGwIGEnFy0KFzU+Hif8FPzi
        gviDAAUA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jnlYR-0006db-JS; Tue, 23 Jun 2020 16:13:47 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D6622306E5C;
        Tue, 23 Jun 2020 18:13:45 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C4847234EBA51; Tue, 23 Jun 2020 18:13:45 +0200 (CEST)
Date:   Tue, 23 Jun 2020 18:13:45 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Joerg Roedel <jroedel@suse.de>,
        Andy Lutomirski <luto@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
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
Message-ID: <20200623161345.GQ4817@hirez.programming.kicks-ass.net>
References: <20200623120433.GB14101@suse.de>
 <20200623125201.GG4817@hirez.programming.kicks-ass.net>
 <20200623134003.GD14101@suse.de>
 <20200623135916.GI4817@hirez.programming.kicks-ass.net>
 <20200623145344.GA117543@hirez.programming.kicks-ass.net>
 <20200623145914.GF14101@suse.de>
 <20200623152326.GL4817@hirez.programming.kicks-ass.net>
 <56af2f70-a1c6-aa64-006e-23f2f3880887@citrix.com>
 <20200623155204.GO4817@hirez.programming.kicks-ass.net>
 <dae40b7b-e584-1ab4-2ebe-13526cdec946@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dae40b7b-e584-1ab4-2ebe-13526cdec946@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 09:03:56AM -0700, Dave Hansen wrote:
> On 6/23/20 8:52 AM, Peter Zijlstra wrote:
> > Isn't current #MC unconditionally fatal from kernel? But yes, I was
> > sorta aware people want that changed.
> 
> Not unconditionally.  copy_to_iter_mcsafe() is a good example of one
> thing we _can_ handle.

Urgh, I thought that stuff was still pending.

Anyway, the important thing is that it is fatal if we hit early NMI.
Which I think still holds.
