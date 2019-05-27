Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 475002B55B
	for <lists+kvm@lfdr.de>; Mon, 27 May 2019 14:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfE0Mc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 08:32:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39992 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbfE0Mc5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 08:32:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Bb4riJdUbAvU2dFDq22LE6R9qG/UUI43/Y/+y4V6Qvs=; b=c4TDFTpHK0CYd1vWu7R1zqW+/
        2vf2CkvycdZ1TOZgh6586+6hBSUOonS4izJJJLlU/laLZdtRg9vo/tFqP67DP/DrVq5GNeyOXkp8N
        ExSQgN5WmAiXgiz9FXGhkb7sqDhbv1+1n9qPgIj2TuqbkRY8ULdb/xs9kniGA0ESzx0t8DJo/mrAl
        uLK3C6fLgcCbWbFpO9EhXKZtWIcTmu+x6Co60LQwrkDHUOi8//21mfSvFniFvyuP82yQFaVkGwBIf
        aK/OeehLVOOzYZiUm+0l62ODKjdgrXRftiZCRVCOymL15JzQ7yEwGoiNpC9TkUxMutHPzfpYZgiur
        Nuu3rPt0w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hVEnP-0003D7-9F; Mon, 27 May 2019 12:32:07 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 10A95202BF3E2; Mon, 27 May 2019 14:32:06 +0200 (CEST)
Date:   Mon, 27 May 2019 14:32:06 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Juergen Gross <jgross@suse.com>, Nadav Amit <namit@vmware.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-hyperv@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [RFC PATCH 5/6] x86/mm/tlb: Flush remote and local TLBs
 concurrently
Message-ID: <20190527123206.GC2623@hirez.programming.kicks-ass.net>
References: <20190525082203.6531-1-namit@vmware.com>
 <20190525082203.6531-6-namit@vmware.com>
 <08b21fb5-2226-7924-30e3-31e4adcfc0a3@suse.com>
 <20190527094710.GU2623@hirez.programming.kicks-ass.net>
 <e9c0dc1f-799a-b6e3-8d41-58f0a6b693cd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9c0dc1f-799a-b6e3-8d41-58f0a6b693cd@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 27, 2019 at 12:21:59PM +0200, Paolo Bonzini wrote:
> On 27/05/19 11:47, Peter Zijlstra wrote:

> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -580,7 +580,7 @@ static void __init kvm_apf_trap_init(voi
> >  
> >  static DEFINE_PER_CPU(cpumask_var_t, __pv_tlb_mask);
> >  
> > -static void kvm_flush_tlb_others(const struct cpumask *cpumask,
> > +static void kvm_flush_tlb_multi(const struct cpumask *cpumask,
> >  			const struct flush_tlb_info *info)
> >  {
> >  	u8 state;
> > @@ -594,6 +594,9 @@ static void kvm_flush_tlb_others(const s
> >  	 * queue flush_on_enter for pre-empted vCPUs
> >  	 */
> >  	for_each_cpu(cpu, flushmask) {
> > +		if (cpu == smp_processor_id())
> > +			continue;
> > +
> 
> Even this would be just an optimization; the vCPU you're running on
> cannot be preempted.  You can just change others to multi.

Yeah, I know, but it felt weird so I added the explicit skip. No strong
feelings though.

