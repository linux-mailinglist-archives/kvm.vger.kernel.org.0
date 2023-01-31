Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A83F682AEE
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 11:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbjAaK6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 05:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjAaK56 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 05:57:58 -0500
X-Greylist: delayed 15946 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 31 Jan 2023 02:57:56 PST
Received: from out-121.mta1.migadu.com (out-121.mta1.migadu.com [IPv6:2001:41d0:203:375::79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540BB7ABC
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 02:57:55 -0800 (PST)
Date:   Tue, 31 Jan 2023 11:57:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675162673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=59SfxHwYp5M/35KJJN/JrWL5wtRNYzzvwWZDK1UbXps=;
        b=k6uYfcBlCo5aa2MBOUutYpHWZFgAFNEfEqdNlg+mC36JYIzy4RXOJ2QgE7rO6X3GStEHv1
        PAUK4G0S/6G1C28RH/tfakGHptqcscpNy4X/pyxnVt5JD5neB+0e5DCUfwT/0M33maV0q3
        fGouyjrFZlRO1osuwaX6OxdqDhO4xnQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Colton Lewis <coltonlewis@google.com>, pbonzini@redhat.com,
        nrb@linux.ibm.com, imbrenda@linux.ibm.com, marcorr@google.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [kvm-unit-tests PATCH v3 1/1] arm: Replace MAX_SMP probe loop in
 favor of reading directly
Message-ID: <20230131105746.yypnggzz7ifjmp4d@orel>
References: <20230130195700.729498-1-coltonlewis@google.com>
 <20230130195700.729498-2-coltonlewis@google.com>
 <20230131063203.67qgjf2ispi2k6hd@orel>
 <03662bf9-1c92-085b-7418-f3a218093051@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03662bf9-1c92-085b-7418-f3a218093051@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 31, 2023 at 08:41:39AM +0100, Thomas Huth wrote:
> On 31/01/2023 07.32, Andrew Jones wrote:
> > On Mon, Jan 30, 2023 at 07:57:00PM +0000, Colton Lewis wrote:
> > > Replace the MAX_SMP probe loop in favor of reading a number directly
> > > from the QEMU error message. This is equally safe as the existing code
> > > because the error message has had the same format as long as it has
> > > existed, since QEMU v2.10. The final number before the end of the
> > > error message line indicates the max QEMU supports. A short awk
> > 
> > awk is not used, despite the comment also being updated to say it's
> > being used.
> > 
> > > program is used to extract the number, which becomes the new MAX_SMP
> > > value.
> > > 
> > > This loop logic is broken for machines with a number of CPUs that
> > > isn't a power of two. This problem was noticed for gicv2 tests on
> > > machines with a non-power-of-two number of CPUs greater than 8 because
> > > tests were running with MAX_SMP less than 8. As a hypthetical example,
> 
> s/hypthetical/hypothetical/
> 
> > > a machine with 12 CPUs will test with MAX_SMP=6 because 12 >> 1 ==
> > > 6. This can, in rare circumstances, lead to different test results
> > > depending only on the number of CPUs the machine has.
> > > 
> > > A previous comment explains the loop should only apply to kernels
> > > <=v4.3 on arm and suggests deletion when it becomes tiresome to
> > > maintian. However, it is always theoretically possible to test on a
> 
> s/maintian/maintain/
> 
> > > machine that has more CPUs than QEMU supports, so it makes sense to
> > > leave some check in place.
> > > 
> > > Signed-off-by: Colton Lewis <coltonlewis@google.com>
> > > ---
> > >   scripts/runtime.bash | 16 +++++++---------
> > >   1 file changed, 7 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> > > index f8794e9a..587ffe30 100644
> > > --- a/scripts/runtime.bash
> > > +++ b/scripts/runtime.bash
> > > @@ -188,12 +188,10 @@ function run()
> > >   # Probe for MAX_SMP, in case it's less than the number of host cpus.
> > >   #
> > >   # This probing currently only works for ARM, as x86 bails on another
> > 
> > It just occurred to me that this code runs on all architectures, even
> > though it only works for Arm. We should wrap this code in $ARCH
> > checks or put it in a function which only Arm calls. That change
> > should be a separate patch though.
> 
> Or we just grep for "max CPUs", since this seems to be used on other
> architectures, too:
> 
> $ qemu-system-x86_64 -smp 12345
> qemu-system-x86_64: Invalid SMP CPUs 12345. The max CPUs supported by
> machine 'pc-i440fx-8.0' is 255
> 
> ?
>

Yes, if we can find an arch-common way to set MAX_SMP, then the variable
could be used in their test configs and gitlab-ci scripts. For example,
afaict, x86 doesn't have any tests that run with more than 4 cpus at the
moment. Being able to bump that up for some tests might increase test
coverage. That said, it might be stretching the scope of this patch a bit
much. How about we keep the grep the same for now and guard with $ARCH.
Other architectures can either share Arm's grep, tweak the grep and share
it, or add their own grep, when/if they want to start using MAX_SMP.

Thanks,
drew
