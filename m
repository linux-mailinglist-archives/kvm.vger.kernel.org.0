Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE100CF974
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 14:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731256AbfJHMLx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 08:11:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35068 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731226AbfJHMLw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 08:11:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=el0DYGZ+UtD3Q7bf+tloYS3IVTjk0rUS+bONbgMT2Rg=; b=O74tYwgUjbjFkwHNi6ZU+HaR6
        LBkK8REqe9k40pVT68Vf1bZ875QNzej49ZWHpedsMDiJGCyVXElI/WYMpzBequQwZQVxzCvGsqycR
        1Eo3sHvlUSL/B1zyyKLRGDs0KZFQ00BLfbPtTEoQPZFPo2j2OY6DHN/ia/ea4oX4QPXsw5Q2sqE66
        FA2i/hjj6056Mr6HBGA/HW7QvtuWNTBvA8Y9v3TTDYwe8ImhMa7IiT3bARuiUKS7RHE9oYafG+HMr
        q3yB4iMkdE0a6FKcVTvl/5KaggJ8OxdgMRG+Y23uk7kjteTIGJ11T0ySqwJJEPPEdHpYy4PDVnJqr
        0kSH4reeg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHoL9-0007Qk-R3; Tue, 08 Oct 2019 12:11:44 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A8440306C53;
        Tue,  8 Oct 2019 14:10:49 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0714D202A1952; Tue,  8 Oct 2019 14:11:41 +0200 (CEST)
Date:   Tue, 8 Oct 2019 14:11:40 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        ak@linux.intel.com, wei.w.wang@intel.com, kan.liang@intel.com,
        like.xu@intel.com, ehankland@google.com, arbel.moshe@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: x86/vPMU: Add lazy mechanism to release
 perf_event per vPMC
Message-ID: <20191008121140.GN2294@hirez.programming.kicks-ass.net>
References: <20190930072257.43352-1-like.xu@linux.intel.com>
 <20190930072257.43352-4-like.xu@linux.intel.com>
 <20191001082321.GL4519@hirez.programming.kicks-ass.net>
 <e77fe471-1c65-571d-2b9e-d97c2ee0706f@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e77fe471-1c65-571d-2b9e-d97c2ee0706f@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 01, 2019 at 08:33:45PM +0800, Like Xu wrote:
> Hi Peter,
> 
> On 2019/10/1 16:23, Peter Zijlstra wrote:
> > On Mon, Sep 30, 2019 at 03:22:57PM +0800, Like Xu wrote:
> > > +	union {
> > > +		u8 event_count :7; /* the total number of created perf_events */
> > > +		bool enable_cleanup :1;
> > 
> > That's atrocious, don't ever create a bitfield with base _Bool.
> 
> I saw this kind of usages in the tree such as "struct
> arm_smmu_master/tipc_mon_state/regmap_irq_chip".

Because other people do tasteless things doesn't make it right.

> I'm not sure is this your personal preference or is there a technical
> reason such as this usage is not incompatible with union syntax?

Apparently it 'works', so there is no hard technical reason, but
consider that _Bool is specified as an integer type large enough to
store the values 0 and 1, then consider it as a base type for a
bitfield. That's just disguisting.

Now, I suppose it 'works', but there is no actual benefit over just
using a single bit of any other base type.

> My design point is to save a little bit space without introducing
> two variables such as "int event_count & bool enable_cleanup".

Your design is questionable, the structure is _huge_, and your union has
event_count:0 and enable_cleanup:0 as the same bit, which I don't think
was intentional.

Did you perhaps want to write:

	struct {
		u8 event_count : 7;
		u8 event_cleanup : 1;
	};

which has a total size of 1 byte and uses the low 7 bits as count and the
msb as cleanup.

Also, the structure has plenty holes to stick proper variables in
without further growing it.

> By the way, is the lazy release mechanism looks reasonable to you?

I've no idea how it works.. I don't know much about virt.
