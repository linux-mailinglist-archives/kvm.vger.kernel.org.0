Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 913ADBBF57
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 02:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503581AbfIXAYq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 20:24:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41108 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729276AbfIXAYq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 20:24:46 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0FEAE368E2;
        Tue, 24 Sep 2019 00:24:46 +0000 (UTC)
Received: from mail (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4FA2810013A1;
        Tue, 24 Sep 2019 00:24:43 +0000 (UTC)
Date:   Mon, 23 Sep 2019 20:24:42 -0400
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/17] KVM: monolithic: x86: handle the
 request_immediate_exit variation
Message-ID: <20190924002442.GA2975@redhat.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-4-aarcange@redhat.com>
 <20190923223526.GQ18195@linux.intel.com>
 <20190923230626.GF19996@redhat.com>
 <20190923234500.GR18195@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923234500.GR18195@linux.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Tue, 24 Sep 2019 00:24:46 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 04:45:00PM -0700, Sean Christopherson wrote:
> With a straight rename to kvm_x86_<function>() instead of wrappers, we
> shouldn't need kvm_ops.c.  kvm_ops.h might be helpful, but it'd be just
> as easy to keep them in kvm_host.h and would likely yield a more
> insightful diff[*].

Yes, I already commented about this change Paolo asked.

> Hmm, I was thinking more along the lines of extending the kvm_host.h
> pattern down into vendor specific code, e.g. arch/x86/kvm/vmx/kvm_host.h.
> Probably with a different name though, two of those is confusing enough.
> 
> It'd still need Makefile changes, but we wouldn't litter the code with
> #ifdefs.  Future enhancments can also take advantage of the per-vendor
> header to inline other things.  Such a header would also make it possible
> to fully remove kvm_x86_ops in this series (I think).

It's common in include/linux/* to include the same .h file that just
implements the inlines depending on some #ifdef, but in this case it's
simpler to have different .h files to keep the two versions more
separated as they may be maintained by different groups, so including
different .h file sounds better than -D__VMX__ -D__VMX__ agreed.

> [*] Tying into the thought above, if we go for a straight rename and
>     eliminate the conditionally-implemented kvm_x86_ops ahead of time,
>     e.g. with inlines that return -EINVAL or something, then the
>     conversion to direct calls can be a straight replacement of
>     "kvm_x86_ops->" with "kvm_x86_" at the same time the declarations
>     are changed from members of kvm_x86_ops to externs.
> 
> Actually, typing out the above made me realize the immediate exit code
> can be:
> 
> 	if (req_immediate_exit) {
> 		kvm_make_request(KVM_REQ_EVENT, vcpu);
> 		if (kvm_x86_request_immediate_exit(vcpu))
> 			smp_send_reschedule(vcpu->cpu);
> 	}
> 
> Where kvm_x86_request_immediate_exit() returns 0 on success, e.g. the SVM
> implementation can be "return -EINVAL" or whatever is appropriate, which
> I assume the compiler can optimize out.  Or maybe a boolean return is
> better in this case?

While the final cleanup of kvm_x86_ops doesn't strictly require the
inlining Makefile tricks to be functional just yet, it would be
beneficial to remove some branch at runtime from non frequently
invoked methods and to get the final optimal implementation sorted out
during the initial cleanup of the structure, this should reduce the
number of patches to get to the most optimal possible end result. So I
think making the inline work in the Makefile as a dependency to remove
kvm_x86_ops is a fine plan.

Thanks,
Andrea
