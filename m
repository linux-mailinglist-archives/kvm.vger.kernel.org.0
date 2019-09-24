Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23FFCBC086
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 04:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408890AbfIXC4b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 22:56:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34482 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408880AbfIXC43 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 22:56:29 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 41EEB30860C8;
        Tue, 24 Sep 2019 02:56:29 +0000 (UTC)
Received: from mail (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 807135C219;
        Tue, 24 Sep 2019 02:56:24 +0000 (UTC)
Date:   Mon, 23 Sep 2019 22:56:23 -0400
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/17] KVM: monolithic: x86: inline more exit handlers in
 vmx.c
Message-ID: <20190924025623.GD4658@redhat.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-15-aarcange@redhat.com>
 <6a1d66a1-74c0-25b9-692f-8875e33b2fae@redhat.com>
 <20190924010056.GB4658@redhat.com>
 <a75d04e1-cfd6-fa2e-6120-1f3956e14153@redhat.com>
 <20190924015527.GC4658@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924015527.GC4658@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 24 Sep 2019 02:56:29 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 09:55:27PM -0400, Andrea Arcangeli wrote:
> This commit I reverted adds literally 3 inlines called by 3 functions,
> in a very fast path, how many bytes of .text difference did you expect
> by dropping some call/ret from a very fast path when you asked me to
> test it? I mean it's just a couple of insn each.
> 
> I thought the question was if gcc was already inlining without the
> hint or not or if it actually grew in size in case I got it wrong and
> there were many callers and it was better off not inline, so now I
> don't get what was the point of this test if with the result that
> confirms it's needed, the patch should be dropped.
> 
> It's possible that this patch may not be relevant anymore with the
> rename in place of the vmx/svm functions, but if this patch is to be
> dropped with the optimal result, then I recommend you to go ahead and
> submit a patch to drop __always_inline from the whole kernel because
> if it's not good to use it here in a extreme fast path like
> handle_external_interrupt and handle_halt, then I don't know what
> __always_inline is good for anywhere else in the kernel.

Thinking more at this I don't think the result of the size check was
nearly enough to come to any conclusion. The only probably conclusion
one can take is that if the size didn't change it was a fail, because
there would be high probability that it wouldn't be beneficial because
it was a noop (even that wouldn't be 100% certain).

One needs to look at why it changed to take any conclusion, and the
reason it got smaller is that all dynamic tracing for ftrace was
dropped, the functions were already inlined fine in the RETPOLINE
case.

Those are tiny functions so it looks a positive thing to make them as
small as possible, there are already proper tracepoints in
kvm_exit/kvm_entry for bpf tracing all all KVM events so there's no
need of the fentry in those tiny functions with just an instruction
that are only ever compiled as static because of the pointer to
function.

This however also means it helps the CONFIG_RETPOLINE=n case and it
doesn't help at all the CONFIG_RETPOLINE=y case, so it's fully
orthogonal to the patchset and can be splitted off but I think it's
worth it.

Thanks,
Andrea
