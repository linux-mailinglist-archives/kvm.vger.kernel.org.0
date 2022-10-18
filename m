Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE1E602602
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 09:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbiJRHlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 03:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiJRHlO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 03:41:14 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A92830F7B
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 00:41:07 -0700 (PDT)
Date:   Tue, 18 Oct 2022 10:40:56 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1666078865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mBwSmebRgZr9pERgfGvEjiw17+IImIBucB6CN9w8FnU=;
        b=LCi0wup+YvjODnvNHWGuXMhl44lVnl/p+Ca5/Ik2Tg5FD9xDbikIjaTOYLcFHvpEiePv/U
        rFcdXD1sWCNiRMsinbCyqhL9j8UYMCIotNY4JXwCAaIG3Pif7CgrLnKTIlU0EjRiDzS2G4
        NSQ58KXqH4VVHu4oK79WvsohYNaugdc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, catalin.marinas@arm.com,
        andrew.jones@linux.dev, dmatlack@google.com, will@kernel.org,
        shan.gavin@gmail.com, bgardon@google.com, kvmarm@lists.linux.dev,
        pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
Message-ID: <Y05YiFgffF6rS1Hv@google.com>
References: <Yz86gEbNflDpC8As@x1n>
 <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com>
 <Y0A4VaSwllsSrVxT@x1n>
 <Y0SoX2/E828mbxuf@google.com>
 <Y0SvexjbHN78XVcq@xz-m1.local>
 <Y0SxnoT5u7+1TCT+@google.com>
 <Y0S2zY4G7jBxVgpu@xz-m1.local>
 <Y0TDCxfVVme8uPGU@google.com>
 <Y0mUh5dEErRVtfjl@x1n>
 <Y05X4o1TxxkvES9E@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y05X4o1TxxkvES9E@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,URI_DOTEDU autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 18, 2022 at 10:38:10AM +0300, Oliver Upton wrote:
> On Fri, Oct 14, 2022 at 12:55:35PM -0400, Peter Xu wrote:
> > On Tue, Oct 11, 2022 at 01:12:43AM +0000, Oliver Upton wrote:
> > > The VMM must know something about the architecture it is running on, as
> > > it calls KVM_DEV_ARM_ITS_SAVE_TABLES after all...
> > 
> > IIUC this is still a kernel impl detail to flush data into guest pages
> > within this ioctl, or am I wrong?
> 
> Somewhat...
> 
> The guest is assigning memory from the IPA space to back the ITS tables,
> but KVM maintains its own internal representation. It just so happens
> that we've conditioned userspace to be aware that ITS emulation is
> incoherent w.r.t. the guest memory that backs the tables.
> 
> > For example, I'm assuming it's safe to change KVM_DEV_ARM_ITS_SAVE_TABLES
> > impl one day to not flush data to guest memories, then the kernel should
> > also disable the ALLOW_BITMAP cap in the same patch, so that any old qemu
> > binary that supports arm64 dirty ring will naturally skip all the bitmap
> > ops and becoming the same as what it does with x86 when running on that new
> > kernel.  With implicit approach suggested, we need to modify QEMU.
> > 
> > Changing impl of KVM_DEV_ARM_ITS_SAVE_TABLES is probably not a good
> > example.. but just want to show what I meant.  Fundamentally it sounds
> > cleaner if it's the kernel that tells the user "okay you collected the
> > ring, but that's not enough; you need to collect the bitmap too", rather
> > than assuming the user app will always know what kvm did in details.  No
> > strong opinion though, as I could also have misunderstood how arm works.
> 
> I think the SAVE_TABLES ioctl is likely here to stay given the odd quirk
> that it really is guest memory, so we'll probably need the bitmap on
> arm64 for a long time. Even if we were to kill it, userspace would need
> to take a change anyway to switch to a new ITS migration mechanism.
> 
> If we ever get to the point that we can relax this restriction i think a
> flag on the BITMAP_WITH_TABLE cap that says "I don't actually set any

BITMAP_WITH_RING

> bits in the bitmap" would do. We shouldn't hide the cap entirely, as
> that would be ABI breakage for VMMs that expect bitmap+ring.
> 
> Thoughts?
> 
> --
> Thanks,
> Oliver
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
