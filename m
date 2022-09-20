Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C145A5BE97B
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 16:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbiITO76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 10:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiITO75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 10:59:57 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FB7DF09
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 07:59:55 -0700 (PDT)
Date:   Tue, 20 Sep 2022 16:59:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663685993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2LwbccH/O2V4VvsUvgVZRkPVC+fe/T2RtwTwDrP6Vno=;
        b=SA5a86HzBByQmS+k27ykaLjjUyf1t7gTOZXvPVagDdcsTcYJLjues4zqhV6WyMvVrcU0B8
        G31GRl7N5MgKeT8xDVjzIDzY+9KWSZfPnMtcgO0Syqx9tsQ5x6apg9vUPfgPo4SZP814XE
        I4MZMsJQ+JYylrWDMkRTu//hFZgI43k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 05/19] lib/alloc_phys: Remove locking
Message-ID: <20220920145952.fnftt2v46daigtdt@kamzik>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-6-alexandru.elisei@arm.com>
 <20220920084553.734jvkqpognzgfpr@kamzik>
 <Yym+MOMK68K7abiQ@e121798.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yym+MOMK68K7abiQ@e121798.cambridge.arm.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 20, 2022 at 02:20:48PM +0100, Alexandru Elisei wrote:
> Hi,
> 
> On Tue, Sep 20, 2022 at 10:45:53AM +0200, Andrew Jones wrote:
> > On Tue, Aug 09, 2022 at 10:15:44AM +0100, Alexandru Elisei wrote:
> > > With powerpc moving the page allocator, there are no architectures left
> > > which use the physical allocator after the boot setup:  arm, arm64,
> > > s390x and powerpc drain the physical allocator to initialize the page
> > > allocator; and x86 calls setup_vm() to drain the allocator for each of
> > > the tests that allocate memory.
> > 
> > Please put the motivation for this change in the commit message. I looked
> > ahead at the next patch to find it, but I'm not sure I agree with it. We
> > should be able to keep the locking even when used early, since we probably
> > need our locking to be something we can use early elsewhere anyway.
> 
> You are correct, the commit message doesn't explain why locking is removed,
> which makes the commit confusing. I will try to do a better job for the
> next iteration (if we decide to keep this patch).
> 
> I removed locking because the physical allocator by the end of the series
> will end up being used only by arm64 to create the idmap, which is done on

If only arm, and no unit tests, needs the phys allocator, then it can be
integrated with whatever arm is using it for and removed from the general
lib.

> the boot CPU and with the MMU off. After that, the translation table
> allocator functions will use the page allocator, which can be used
> concurrently.
> 
> Looking at the spinlock implementation, spin_lock() doesn't protect from
> the concurrent accesses when the MMU is disabled (lock->v is
> unconditionally set to 1). Which means that spin_lock() does not work (in
> the sense that it doesn't protect against concurrent accesses) on the boot
> path, which doesn't need a spinlock anyway, because no secondaries are
> online secondaries. It also means that spinlocks don't work when
> AUXINFO_MMU_OFF is set. So for the purpose of simplicity I preferred to
> drop it entirely.

If other architectures or unit tests have / could have uses for the
phys allocator then we should either document that it doesn't have
locks or keep the locks, and arm will just know that they don't work,
but also that they don't need to for its purposes.

Finally, if we drop the locks and arm doesn't have any other places where
we use locks without the MMU enabled, then we can change the lock
implementation to not have the no-mmu fallback - maybe by switching to the
generic implementation as the other architectures have done.

Thanks,
drew
