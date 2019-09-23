Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF7FBBAA7
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 19:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407651AbfIWRmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 13:42:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44512 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407617AbfIWRmt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 13:42:49 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CADE010CC1F4;
        Mon, 23 Sep 2019 17:42:48 +0000 (UTC)
Received: from mail (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 868F360BFB;
        Mon, 23 Sep 2019 17:42:45 +0000 (UTC)
Date:   Mon, 23 Sep 2019 13:42:44 -0400
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
Message-ID: <20190923174244.GA19996@redhat.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-16-aarcange@redhat.com>
 <87o8zb8ik1.fsf@vitty.brq.redhat.com>
 <20190923163746.GE18195@linux.intel.com>
 <24dc5c23-eed8-22db-fd15-5a165a67e747@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24dc5c23-eed8-22db-fd15-5a165a67e747@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.65]); Mon, 23 Sep 2019 17:42:49 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 06:53:10PM +0200, Paolo Bonzini wrote:
> On 23/09/19 18:37, Sean Christopherson wrote:
> >> Would it be too much if we get rid of
> >> kvm_vmx_exit_handlers completely replacing this code with one switch()?
> > Hmm, that'd require redirects for nVMX functions since they are set at
> > runtime.  That isn't necessarily a bad thing.  The approach could also be
> > used if Paolo's idea of making kvm_vmx_max_exit_handlers const allows the
> > compiler to avoid retpoline.
> 
> But aren't switch statements also retpolin-ized if they use a jump table?

See commit a9d57ef15cbe327fe54416dd194ee0ea66ae53a4.

We disabled that feature or the kernel would potentially suffer the
downsides of the exit handlers through pointer to functions for every
switch statement in the kernel.

In turn you can't make it run any faster by converting my "if" to a
"switch" at least the "if" can deterministic control the order of what
is more likely that we should also re-review, but the order of secondary
effect, the important thing is to reduce the retpolines to zero during
normal hrtimer guest runtime.
