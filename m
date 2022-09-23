Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A205E81B8
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 20:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbiIWS00 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Sep 2022 14:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiIWS0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Sep 2022 14:26:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518E812167D
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 11:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663957583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sKwAzZec8KipecaZ1JzamS6Z7a4oJagSVbwGtwJhtZs=;
        b=f8LrPrmH21AK1JsXayZzaPrgogaWool1hr7GJhPkOlwUaV5Vnj6YI225eVbrdfATo5PXef
        oCS6hFork37xgXB3QftfD7mM4CL6U/bPu3qjfr+2iR/BgsJUIV3ek59uiP2WynOBiEUaIK
        tt8QVBkxrsWIMWSXxBysG4lhGQK9oTo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-532-PTpC87-zM8-jseGEjT89qA-1; Fri, 23 Sep 2022 14:26:22 -0400
X-MC-Unique: PTpC87-zM8-jseGEjT89qA-1
Received: by mail-qk1-f200.google.com with SMTP id v15-20020a05620a0f0f00b006ceab647023so577429qkl.13
        for <kvm@vger.kernel.org>; Fri, 23 Sep 2022 11:26:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=sKwAzZec8KipecaZ1JzamS6Z7a4oJagSVbwGtwJhtZs=;
        b=wpWghXw29eKRU075hPL+PWZsW+1NRmmFeGggFnYHlkLLH8fei/Fqcfw6YFEGmNjRob
         rj2Kxtgk/3YU1FiPYtDhFkhmfehmh9nHBhKwCp+ikUPoBvuPMHynLvh1n5bwenqNi3P1
         jQroVRT4qhYmzlxKEiQ50ux9hzOjr8XR2a7NuZsxLvJuEUT02dcPQR8KdccMkTJzENd1
         0S5BS/A/uU1qBH8Vyxhj930R7bJw4x9ClLdkC19b7hbWWWUt3omdL9Abx7x5KSu17he2
         NZ+w13OUdImBMdt/KbTmkuE+NaR6CN1nt+ZAZm909oaJ+Kd5YXMWOGQbfverhz23zjtN
         bdFg==
X-Gm-Message-State: ACrzQf0FW5PD8qc1mkBgeSfGGqzo0PxjjNDIUidE+YUY/WQ0xgCi5UCO
        qEygmHHVvFwKft5A9Ls8kBHMEupmuIU+YullS23la8AWUKGI5kDSM2M/HXatMf0vmUZYjEjUKSx
        klRJ9GbAczH0J
X-Received: by 2002:a05:622a:1002:b0:35b:baaf:24bb with SMTP id d2-20020a05622a100200b0035bbaaf24bbmr8450491qte.85.1663957581656;
        Fri, 23 Sep 2022 11:26:21 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5klgSD6rdsCB+xreJDWo2YXT/MOk2drMbEljCnhf9MK11IyCj/1lotbhwRYcmUHZVuWQJ/dw==
X-Received: by 2002:a05:622a:1002:b0:35b:baaf:24bb with SMTP id d2-20020a05622a100200b0035bbaaf24bbmr8450467qte.85.1663957581402;
        Fri, 23 Sep 2022 11:26:21 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id u15-20020a05620a0c4f00b006cf19068261sm6714936qki.116.2022.09.23.11.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 11:26:20 -0700 (PDT)
Date:   Fri, 23 Sep 2022 14:26:18 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, shan.gavin@gmail.com,
        gshan@redhat.com, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 2/6] KVM: Add KVM_CAP_DIRTY_LOG_RING_ORDERED capability
 and config option
Message-ID: <Yy36Stppz4tYBPiP@x1n>
References: <20220922170133.2617189-1-maz@kernel.org>
 <20220922170133.2617189-3-maz@kernel.org>
 <YyzYI/bvp/JnbcxS@xz-m1.local>
 <87czbmjhbh.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87czbmjhbh.wl-maz@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 23, 2022 at 03:28:34PM +0100, Marc Zyngier wrote:
> On Thu, 22 Sep 2022 22:48:19 +0100,
> Peter Xu <peterx@redhat.com> wrote:
> > 
> > On Thu, Sep 22, 2022 at 06:01:29PM +0100, Marc Zyngier wrote:
> > > In order to differenciate between architectures that require no extra
> > > synchronisation when accessing the dirty ring and those who do,
> > > add a new capability (KVM_CAP_DIRTY_LOG_RING_ORDERED) that identify
> > > the latter sort. TSO architectures can obviously advertise both, while
> > > relaxed architectures most only advertise the ORDERED version.
> > > 
> > > Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  include/linux/kvm_dirty_ring.h |  6 +++---
> > >  include/uapi/linux/kvm.h       |  1 +
> > >  virt/kvm/Kconfig               | 14 ++++++++++++++
> > >  virt/kvm/Makefile.kvm          |  2 +-
> > >  virt/kvm/kvm_main.c            | 11 +++++++++--
> > >  5 files changed, 28 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
> > > index 906f899813dc..7a0c90ae9a3f 100644
> > > --- a/include/linux/kvm_dirty_ring.h
> > > +++ b/include/linux/kvm_dirty_ring.h
> > > @@ -27,7 +27,7 @@ struct kvm_dirty_ring {
> > >  	int index;
> > >  };
> > >  
> > > -#ifndef CONFIG_HAVE_KVM_DIRTY_RING
> > > +#ifndef CONFIG_HAVE_KVM_DIRTY_LOG
> > 
> > s/LOG/LOG_RING/ according to the commit message? Or the name seems too
> > generic.
> 
> The commit message talks about the capability, while the above is the
> config option. If you find the names inappropriate, feel free to
> suggest alternatives (for all I care, they could be called FOO, BAR
> and BAZ).

The existing name from David looks better than the new one.. to me.

> 
> > Pure question to ask: is it required to have a new cap just for the
> > ordering?  IIUC if x86 was the only supported anyway before, it means all
> > released old kvm binaries are always safe even without the strict
> > orderings.  As long as we rework all the memory ordering bits before
> > declaring support of yet another arch, we're good.  Or am I wrong?
> 
> Someone will show up with an old userspace which probes for the sole
> existing capability, and things start failing subtly. It is quite
> likely that the userspace code is built for all architectures,

I didn't quite follow here.  Since both kvm/qemu dirty ring was only
supported on x86, I don't see the risk.

Assuming we've the old binary.

If to run on old kernel, it'll work like before.

If to run on new kernel, the kernel will behave stricter on memory barriers
but should still be compatible with the old behavior (not vice versa, so
I'll understand if we're loosing the ordering, but we're not..).

Any further elaboration would be greatly helpful.

Thanks,

> and we
> want to make sure that userspace actively buys into the new ordering
> requirements. A simple way to do this is to expose a new capability,
> making the new requirement obvious. Architectures with relaxed
> ordering semantics will only implement the new one, while x86 will
> implement both.

-- 
Peter Xu

