Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1598ABBF77
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 02:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391823AbfIXAv5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 20:51:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57220 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390912AbfIXAv5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 20:51:57 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D28A110C0940;
        Tue, 24 Sep 2019 00:51:56 +0000 (UTC)
Received: from mail (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A398B10013A1;
        Tue, 24 Sep 2019 00:51:53 +0000 (UTC)
Date:   Mon, 23 Sep 2019 20:51:52 -0400
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/17] KVM: monolithic: x86: drop the kvm_pmu_ops
 structure
Message-ID: <20190924005152.GA4658@redhat.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-14-aarcange@redhat.com>
 <057fc5f2-7343-943f-ed86-59f1ad5122e5@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <057fc5f2-7343-943f-ed86-59f1ad5122e5@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Tue, 24 Sep 2019 00:51:56 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 12:21:43PM +0200, Paolo Bonzini wrote:
> On 20/09/19 23:25, Andrea Arcangeli wrote:
> > Cleanup after this was finally left fully unused.
> > 
> > Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  3 ---
> >  arch/x86/kvm/pmu.h              | 19 -------------------
> >  arch/x86/kvm/pmu_amd.c          | 15 ---------------
> >  arch/x86/kvm/svm.c              |  1 -
> >  arch/x86/kvm/vmx/pmu_intel.c    | 15 ---------------
> >  arch/x86/kvm/vmx/vmx.c          |  2 --
> >  6 files changed, 55 deletions(-)
> 
> Is there any reason not to do the same for kvm_x86_ops?

This was covered in the commit header of patch 2:

To reduce the rejecting parts while tracking upstream, this doesn't
attempt to entirely remove the kvm_x86_ops structure yet, that is
meant for a later cleanup. The pmu ops have been already cleaned up in
this patchset because it was left completely unused right after the
conversion from pointer to functions to external functions.

Lot more patches are needed to get rid of kvm_x86_ops entirely because
there are lots of places checking the actual value of the method
before making the indirect call. I tried to start that, but then it
got into potentially heavily rejecting territory, so I thought it was
simpler to start with what I had, considering from a performance
standpoint it's optimal already as far as retpolines are concerned.

> (As an aside, patch 2 is not copying over the comments in the struct
> kvm_x86_ops declarations.  Granted there aren't many, but we should not
> lose the few that exist).

Yes sorry, this was actually unintentional and the comment need to be
retained in the header declaration.

Thanks,
Andrea
