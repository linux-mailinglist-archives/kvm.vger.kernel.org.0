Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37BA455CC6
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 02:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfFZAEd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 20:04:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:45807 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726402AbfFZAEc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 20:04:32 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jun 2019 17:04:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,417,1557212400"; 
   d="scan'208";a="188466243"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by fmsmga002.fm.intel.com with ESMTP; 25 Jun 2019 17:04:30 -0700
Date:   Tue, 25 Jun 2019 16:54:47 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
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
Subject: Re: [PATCH v9 03/17] x86/split_lock: Align x86_capability to
 unsigned long to avoid split locked access
Message-ID: <20190625235447.GB245468@romley-ivt3.sc.intel.com>
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
 <1560897679-228028-4-git-send-email-fenghua.yu@intel.com>
 <746b5a8752cc40b1b954913f786ed9a6@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <746b5a8752cc40b1b954913f786ed9a6@AcuMS.aculab.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 24, 2019 at 03:12:49PM +0000, David Laight wrote:
> From: Fenghua Yu
> > Sent: 18 June 2019 23:41
> > 
> > set_cpu_cap() calls locked BTS and clear_cpu_cap() calls locked BTR to
> > operate on bitmap defined in x86_capability.
> > 
> > Locked BTS/BTR accesses a single unsigned long location. In 64-bit mode,
> > the location is at:
> > base address of x86_capability + (bit offset in x86_capability / 64) * 8
> > 
> > Since base address of x86_capability may not be aligned to unsigned long,
> > the single unsigned long location may cross two cache lines and
> > accessing the location by locked BTS/BTR introductions will cause
> > split lock.
> > 
> > To fix the split lock issue, align x86_capability to size of unsigned long
> > so that the location will be always within one cache line.
> > 
> > Changing x86_capability's type to unsigned long may also fix the issue
> > because x86_capability will be naturally aligned to size of unsigned long.
> > But this needs additional code changes. So choose the simpler solution
> > by setting the array's alignment to size of unsigned long.
> 
> As I've pointed out several times before this isn't the only int[] data item
> in this code that gets passed to the bit operations.
> Just because you haven't got a 'splat' from the others doesn't mean they don't
> need fixing at the same time.

As Thomas suggested in https://lkml.org/lkml/2019/4/25/353, patch #0017
in this patch set implements WARN_ON_ONCE() to audit possible unalignment
in atomic bit ops.

This patch set just enables split lock detection first. Fixing ALL split
lock issues might be practical after the patch is upstreamed and used widely.

> 
> > Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> > ---
> >  arch/x86/include/asm/processor.h | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> > index c34a35c78618..d3e017723634 100644
> > --- a/arch/x86/include/asm/processor.h
> > +++ b/arch/x86/include/asm/processor.h
> > @@ -93,7 +93,9 @@ struct cpuinfo_x86 {
> >  	__u32			extended_cpuid_level;
> >  	/* Maximum supported CPUID level, -1=no CPUID: */
> >  	int			cpuid_level;
> > -	__u32			x86_capability[NCAPINTS + NBUGINTS];
> > +	/* Aligned to size of unsigned long to avoid split lock in atomic ops */
> 
> Wrong comment.
> Something like:
> 	/* Align to sizeof (unsigned long) because the array is passed to the
> 	 * atomic bit-op functions which require an aligned unsigned long []. */

The problem we try to fix here is not because "the array is passed to the
atomic bit-op functions which require an aligned unsigned long []".

The problem is because of the possible split lock issue. If it's not because
of split lock issue, there is no need to have this patch.

So I would think my comment is right to point out explicitly why we need
this alignment.

> 
> > +	__u32			x86_capability[NCAPINTS + NBUGINTS]
> > +				__aligned(sizeof(unsigned long));
> 
> It might be better to use a union (maybe unnamed) here.

That would be another patch. This patch just simply fixes the split lock
issue.

Thanks.

-Fenghua
