Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFBAF67A180
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 19:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233815AbjAXSl1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 13:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbjAXSlQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 13:41:16 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CD54F847
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 10:40:48 -0800 (PST)
Date:   Tue, 24 Jan 2023 18:40:24 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1674585628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wlJ1IheQ/nmg2y4yFCWkxNqXkOOpQZCoSwAptM2xy2k=;
        b=PcT10gEzU7Gw8ykJLFMRP0yM/eFLupvs98UON+UER4leMXr7aBmh0rX+IPPGn2q6ZsxaLR
        2uZT9mhxBHz2VoDWjr49Hcuanz8qiVGXYJKRhl5DfMxJkw+URzPVVjeSFasHwnC9nyG6oB
        nm1D8pl8ubzG05JjK2XCjKluGHciQ5U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, pbonzini@redhat.com, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        yuzenghui@huawei.com
Subject: Re: [PATCH 1/4] KVM: selftests: aarch64: Relax userfaultfd read vs.
 write checks
Message-ID: <Y9AmGHMjx6BZX0gy@google.com>
References: <20230110022432.330151-1-ricarkol@google.com>
 <20230110022432.330151-2-ricarkol@google.com>
 <Y88TLcuetXMSYyfD@google.com>
 <Y9AErXchOZFuKL05@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9AErXchOZFuKL05@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ricardo,

On Tue, Jan 24, 2023 at 08:17:49AM -0800, Ricardo Koller wrote:
> On Mon, Jan 23, 2023 at 11:07:25PM +0000, Oliver Upton wrote:
> > On Tue, Jan 10, 2023 at 02:24:29AM +0000, Ricardo Koller wrote:
> > > Only Stage1 Page table walks (S1PTW) writing a PTE on an unmapped page
> > > should result in a userfaultfd write. However, the userfaultfd tests in
> > > page_fault_test wrongly assert that any S1PTW is a PTE write.
> > > 
> > > Fix this by relaxing the read vs. write checks in all userfaultfd handlers.
> > > Note that this is also an attempt to focus less on KVM (and userfaultfd)
> > > behavior, and more on architectural behavior. Also note that after commit
> > > "KVM: arm64: Fix S1PTW handling on RO memslots" the userfaultfd fault
> > > (S1PTW with AF on an unmaped PTE page) is actually a read: the translation
> > > fault that comes before the permission fault.
> > 
> > I certainly agree that we cannot make assertions about read v. write
> > when registering uffd in 'missing' mode. We probably need another test
> > to assert that we get write faults for hardware AF updates when using
> > uffd in write protect mode.
> 
> I can do that. Only question, do you prefer having them in this series
> with fixes, or another one?

Oh, don't worry about it for this series as I'd like to grab it sooner
rather than later. Just making a note of some additional improvements to
the test :)

--
Thanks,
Oliver
