Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E473421AE42
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 06:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgGJE6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 00:58:21 -0400
Received: from mga04.intel.com ([192.55.52.120]:22339 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgGJE6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 00:58:20 -0400
IronPort-SDR: 4LwEiUcUnmrH2Ggn2gGw30ia7ld6V7rP//wHc2zS/yoSKbmetB6g/Tr4Zbi+FWI9X1zeRoItPJ
 P6OOn4mon7yA==
X-IronPort-AV: E=McAfee;i="6000,8403,9677"; a="145645382"
X-IronPort-AV: E=Sophos;i="5.75,334,1589266800"; 
   d="scan'208";a="145645382"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2020 21:58:19 -0700
IronPort-SDR: iYtFy0YA4DZG08J4aL8gUwJX3Js0JS9r5dOKli8Uxl0HiAdTCX9cdDov+oZpXeD+ouz1Oj0nXV
 w3RNzE3LHCwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,334,1589266800"; 
   d="scan'208";a="298307698"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga002.jf.intel.com with ESMTP; 09 Jul 2020 21:58:19 -0700
Date:   Thu, 9 Jul 2020 21:58:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/2] KVM: X86: Move ignore_msrs handling upper the stack
Message-ID: <20200710045819.GB24919@linux.intel.com>
References: <20200626180732.GB175520@xz-x1>
 <20200626181820.GG6583@linux.intel.com>
 <47b90b77-cf03-6087-b25f-fcd2fd313165@redhat.com>
 <20200630154726.GD7733@linux.intel.com>
 <20200709182220.GG199122@xz-x1>
 <20200709192440.GD24919@linux.intel.com>
 <20200709210919.GI199122@xz-x1>
 <20200709212652.GX24919@linux.intel.com>
 <20200709215046.GJ199122@xz-x1>
 <610241d9-b2ab-8643-1ede-3f957573dff3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <610241d9-b2ab-8643-1ede-3f957573dff3@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 10, 2020 at 12:11:54AM +0200, Paolo Bonzini wrote:
> On 09/07/20 23:50, Peter Xu wrote:
> >> Sean: Objection your honor.
> >> Paolo: Overruled, you're wrong.
> >> Sean: Phooey.
> >>
> >> My point is that even though I still object to this series, Paolo has final
> >> say.
> >
> > I could be wrong, but I feel like Paolo was really respecting your input, as
> > always.
> 
> I do respect Sean's input

Ya, my comments were in jest.  Sorry if I implied I was grumpy about Paolo
taking this patch, because I'm not.  Just stubborn :-)

> but I also believe that in this case there's three questions:
> 
> a) should KVM be allowed to use the equivalent of rdmsr*_safe() on guest
> MSRs?  I say a mild yes, Sean says a strong no.

It's more that I don't think host_initiated=true is the equivalent of
rdmsr_safe().  It kind of holds true for rdmsr, but that's most definitely
not the case for wrmsr where host_initiated=true completely changes what
is/isn't allow.  And if using host_initiated=true for rdmsr is allowed,
then logically using it for wrmsr is also allowed.

> b) is it good to separate the "1" and "-EINVAL" results so that
> ignore_msrs handling can be moved out of the MSR access functions?  I
> say yes because KVM should never rely on ignore_msrs; Sean didn't say
> anything (it's not too relevant if you answer no to the first question).
> 
> c) is it possible to reimplement TSX_CTRL_MSR to avoid using the
> equivalent of rdmsr*_safe()?  Sean says yes and it's not really possible
> to argue against that, but then it doesn't really matter if you answer
> yes to the first two questions.
> 
> Sean sees your patch mostly as answering "yes" to the question (a), and
> therefore disagrees with it.  I see your patch mostly as answering "yes"
> to question (b), and therefore like it.  I would also accept a patch
> that reimplements TSX_CTRL_MSR (question c), but I consider your patch
> to be an improvement anyway (question b).
> 
> > It's just as simple as a 2:1 vote, isn't it? (I can still count myself
> > in for the vote, right? :)
> 
> I do have the final say but I try to use that as little as possible (or
> never).  And then it happens that ever so rare disagreements cluster in
> the same week!
> 
> The important thing is to analyze the source of the disagreement.
> Usually when that happens, it's because a change has multiple purposes
> and people see it in a different way.
> 
> In this case, I'm happy to accept this patch (and overrule Sean) not
> because he's wrong on question (a), but because in my opinion the actual
> motivation of the patch is question (b).
> 
> To be fair, I would prefer it if ignore_msrs didn't apply to
> host-initiated MSR accesses at all (only guest accesses).  That would
> make this series much much simpler.  It wouldn't solve the disagremement
> on question (a), but perhaps it would be a patch that Sean would agree on.

I think I could get behind that.  It shoudn't interfere with my crusade to
vanquish host_initiated :-)
