Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C5539CE8A
	for <lists+kvm@lfdr.de>; Sun,  6 Jun 2021 12:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhFFKMl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Jun 2021 06:12:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229465AbhFFKMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Jun 2021 06:12:40 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB58760FEE;
        Sun,  6 Jun 2021 10:10:51 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lppk1-005kDE-KN; Sun, 06 Jun 2021 11:10:49 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 06 Jun 2021 11:10:49 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        pbonzini@redhat.com, drjones@redhat.com, eric.auger@redhat.com,
        kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH] KVM: selftests: Rename vm_handle_exception in evmcs test
In-Reply-To: <YLqzI9THXBX2dWDE@google.com>
References: <20210604181833.1769900-1-ricarkol@google.com>
 <YLqanpE8tdiNeoaN@google.com> <YLqzI9THXBX2dWDE@google.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <6d1f569a5260612eb0704e31655d168d@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ricarkol@google.com, seanjc@google.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com, eric.auger@redhat.com, oliver.sang@intel.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-06-05 00:11, Ricardo Koller wrote:
> On Fri, Jun 04, 2021 at 09:26:54PM +0000, Sean Christopherson wrote:
>> On Fri, Jun 04, 2021, Ricardo Koller wrote:
>> > Kernel test robot reports this:
>> >
>> > > /usr/bin/ld: tools/testing/selftests/kvm/x86_64/evmcs_test.c:157: undefined reference to `vm_handle_exception'
>> > > /usr/bin/ld: tools/testing/selftests/kvm/x86_64/evmcs_test.c:158: undefined reference to `vm_handle_exception'
>> > > collect2: error: ld returned 1 exit status
>> >
>> > Fix it by renaming vm_handle_exception to vm_install_vector_handler in
>> > evmcs_test.c.
>> >
>> > Fixes: a2bad6a990a4 ("KVM: selftests: Rename vm_handle_exception")
>> 
>> Belated code review...
> 
> Thanks for the review.
> 
>> Can we rename the helper to vm_install_exception_handler()?
>> 
>> In x86, "vector" is the number of the exception and "vectoring" is the 
>> process
>> of determining the resulting vector that gets delivered to software 
>> (e.g. when
>> dealing with contributory faults like #GP->#PF->#DF), but the thing 
>> that's being
>> handled is an exception.
> 
> Got it. What about this renaming:
> 
>   vm_handle_exception(vec) 		-> vm_install_exception_handler(vec)
>   vm_install_exception_handler(vec, ec)	-> vm_install_sync_handler(vec, 
> ec)
> 
>> 
>> arm appears to have similar terminology.  And looking at the arm code, 
>> it's very
>> confusing to have a helper vm_install_vector_handler() install into
>> exception_handlers, _not_ into vector_handlers.  Calling the 
>> vector_handlers
>> "default" handlers is also confusing, as "default" usually implies the 
>> thing can
>> be overwritten.  But in this case, the "default" handler is just 
>> another layer
>> in the routing.
>> 
>> The multiple layers of routing is also confusing and a bit hard to 
>> wade through
>> for the uninitiated.  The whole thing can be made more straightfoward 
>> by doing
>> away with the intermediate routing, whacking ~50 lines of code in the 
>> process.
>> E.g. (definitely not functional code):
> 
> I think that works and it does remove a bunch of code. Just need to 
> play
> with the idea and check that it can cover all cases.
> 
> For now, given that the build is broken, what about this series of
> patches:
> 
> 1. keep this patch to fix x86 kvm selftests
> 2. rename both arm and x86 to vm_install_exception_handler and
> vm_install_sync_handler
> 3. restructure the internals of exception handling in arm
> 
> Alternatively, I can send 1+2 together and then 3. What do you think?

This is becoming a bit messy. I'd rather drop the whole series from
-next, and get something that doesn't break in the middle. Please
resend the series tested on top of -rc4.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
