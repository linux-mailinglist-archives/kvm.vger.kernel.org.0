Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1E9557167
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 21:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfFZTPq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 15:15:46 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50165 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZTPq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 15:15:46 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hgDO8-00049Y-OG; Wed, 26 Jun 2019 21:15:24 +0200
Date:   Wed, 26 Jun 2019 21:15:23 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Fenghua Yu <fenghua.yu@intel.com>
cc:     David Laight <David.Laight@ACULAB.COM>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Christopherson Sean J <sean.j.christopherson@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v9 03/17] x86/split_lock: Align x86_capability to unsigned
 long to avoid split locked access
In-Reply-To: <20190625235447.GB245468@romley-ivt3.sc.intel.com>
Message-ID: <alpine.DEB.2.21.1906262109200.32342@nanos.tec.linutronix.de>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com> <1560897679-228028-4-git-send-email-fenghua.yu@intel.com> <746b5a8752cc40b1b954913f786ed9a6@AcuMS.aculab.com> <20190625235447.GB245468@romley-ivt3.sc.intel.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Jun 2019, Fenghua Yu wrote:
> On Mon, Jun 24, 2019 at 03:12:49PM +0000, David Laight wrote:
> > > @@ -93,7 +93,9 @@ struct cpuinfo_x86 {
> > >  	__u32			extended_cpuid_level;
> > >  	/* Maximum supported CPUID level, -1=no CPUID: */
> > >  	int			cpuid_level;
> > > -	__u32			x86_capability[NCAPINTS + NBUGINTS];
> > > +	/* Aligned to size of unsigned long to avoid split lock in atomic ops */
> > 
> > Wrong comment.
> > Something like:
> > 	/* Align to sizeof (unsigned long) because the array is passed to the
> > 	 * atomic bit-op functions which require an aligned unsigned long []. */
> 
> The problem we try to fix here is not because "the array is passed to the
> atomic bit-op functions which require an aligned unsigned long []".
> 
> The problem is because of the possible split lock issue. If it's not because
> of split lock issue, there is no need to have this patch.
> 
> So I would think my comment is right to point out explicitly why we need
> this alignment.

The underlying problem why you need that alignemnt is that the invocation
of the bitops does a type cast. And that's independent of split lock. Split
lock makes the problem visible. So the alignment papers over that. And
while this 'works' in x86 it's fundamentaly broken on big endian. So no,
your comment is not right to the point because it gives the wrong
information.

> > 
> > > +	__u32			x86_capability[NCAPINTS + NBUGINTS]
> > > +				__aligned(sizeof(unsigned long));
> > 
> > It might be better to use a union (maybe unnamed) here.
> 
> That would be another patch. This patch just simply fixes the split lock
> issue.

Why? That's a straight forward and obvious fix and way better than these
alignment games. It's still wrong for BE....

So anyway, this wants a comment which explains the underlying issue and not
a comment which blurbs about split locks.

Thanks,

	tglx
