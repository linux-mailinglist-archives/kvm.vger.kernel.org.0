Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2B475BE6E8
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 15:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiITNUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 09:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiITNUx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 09:20:53 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E8F91BEB0
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 06:20:52 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF2FB1042;
        Tue, 20 Sep 2022 06:20:58 -0700 (PDT)
Received: from e121798.cambridge.arm.com (e121798.cambridge.arm.com [10.1.196.158])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E56B3F73D;
        Tue, 20 Sep 2022 06:20:51 -0700 (PDT)
Date:   Tue, 20 Sep 2022 14:20:48 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 05/19] lib/alloc_phys: Remove locking
Message-ID: <Yym+MOMK68K7abiQ@e121798.cambridge.arm.com>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-6-alexandru.elisei@arm.com>
 <20220920084553.734jvkqpognzgfpr@kamzik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920084553.734jvkqpognzgfpr@kamzik>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Tue, Sep 20, 2022 at 10:45:53AM +0200, Andrew Jones wrote:
> On Tue, Aug 09, 2022 at 10:15:44AM +0100, Alexandru Elisei wrote:
> > With powerpc moving the page allocator, there are no architectures left
> > which use the physical allocator after the boot setup:  arm, arm64,
> > s390x and powerpc drain the physical allocator to initialize the page
> > allocator; and x86 calls setup_vm() to drain the allocator for each of
> > the tests that allocate memory.
> 
> Please put the motivation for this change in the commit message. I looked
> ahead at the next patch to find it, but I'm not sure I agree with it. We
> should be able to keep the locking even when used early, since we probably
> need our locking to be something we can use early elsewhere anyway.

You are correct, the commit message doesn't explain why locking is removed,
which makes the commit confusing. I will try to do a better job for the
next iteration (if we decide to keep this patch).

I removed locking because the physical allocator by the end of the series
will end up being used only by arm64 to create the idmap, which is done on
the boot CPU and with the MMU off. After that, the translation table
allocator functions will use the page allocator, which can be used
concurrently.

Looking at the spinlock implementation, spin_lock() doesn't protect from
the concurrent accesses when the MMU is disabled (lock->v is
unconditionally set to 1). Which means that spin_lock() does not work (in
the sense that it doesn't protect against concurrent accesses) on the boot
path, which doesn't need a spinlock anyway, because no secondaries are
online secondaries. It also means that spinlocks don't work when
AUXINFO_MMU_OFF is set. So for the purpose of simplicity I preferred to
drop it entirely.

Thanks,
Alex

> 
> Thanks,
> drew
