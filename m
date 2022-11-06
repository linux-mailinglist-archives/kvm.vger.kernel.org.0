Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4189E61E364
	for <lists+kvm@lfdr.de>; Sun,  6 Nov 2022 17:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiKFQXg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 11:23:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiKFQXf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 11:23:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7686386
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 08:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667751754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H20v1cqeTFlHUSZvF7zpeNTQPp+u9jgZyQm6uqb6iO8=;
        b=WxZKXm8Z+MMHJaJh7i21cPPajvueLZ1t2Zv6RwJLHJ+t46Hl8uFwUNqYkJ9m8pH0MHj1OR
        bdBn/3w3q0q30ANccYb36AyJVKtxD8IS+D3PeotYMsZB7F30sLf6i1aSaPMOWGuSquWnlG
        dl6Dzjails/2PK/pl/ohhAXv9T1KDhM=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-410-4QYZ4xZANvWjjARXrnVcZg-1; Sun, 06 Nov 2022 11:22:32 -0500
X-MC-Unique: 4QYZ4xZANvWjjARXrnVcZg-1
Received: by mail-qk1-f198.google.com with SMTP id bq13-20020a05620a468d00b006fa5a75759aso8370103qkb.13
        for <kvm@vger.kernel.org>; Sun, 06 Nov 2022 08:22:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H20v1cqeTFlHUSZvF7zpeNTQPp+u9jgZyQm6uqb6iO8=;
        b=1azzWjG3S29ft2VfoaRVEOk7O6czNxE7LyydcELQsZEGAnbUm236KlN5ZLruyBc5+i
         pLLWZyF3D4ItZLCxWv0KjnjursVyMfX+dS07x8IJUNIImMFRhSe4whJEAZ7lqp0BTfmy
         L56v3/y9TY3rZso3Ar1iGCehUzw87wq0DbxrqJSK0F9upt9NAK+3dZ/51QjJxlrOCZ3V
         9HvjcyufdrPG07QsszjP4YjYDAbsqrHomj1KqiQQJMOwtiDM4zS+qCQddl1ySsw1ZMCR
         MIlzNaSb0Su0qeJ6tM3Kv8MJZ/2QSBnKu8FvliA+HEkwUwBI3E9GTOf7ZwxOBjjUXoZu
         p5Dw==
X-Gm-Message-State: ACrzQf06OrgBp8oDSIWdJWCq99+ONuKRBvfaApgy4IG1kYglBrexbhBK
        HE5qr2o2QkG4P1mQ3p62Vtat3JxKr+qHLxMqQ7wBz39soktmeAgo0Rp6krCTkZ8Xb6bseqF6yDP
        0Uv4tgDADKZPB
X-Received: by 2002:ad4:5be4:0:b0:4bb:e947:c664 with SMTP id k4-20020ad45be4000000b004bbe947c664mr35673918qvc.122.1667751752349;
        Sun, 06 Nov 2022 08:22:32 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4qXfWU3rRVYOMwffAULeycyo0cR3quhzthJX0gEGzox/PFp3S4akUblLJhi8FVLsZsWmuQug==
X-Received: by 2002:ad4:5be4:0:b0:4bb:e947:c664 with SMTP id k4-20020ad45be4000000b004bbe947c664mr35673894qvc.122.1667751752071;
        Sun, 06 Nov 2022 08:22:32 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id x18-20020a05620a259200b006e42a8e9f9bsm4650486qko.121.2022.11.06.08.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Nov 2022 08:22:31 -0800 (PST)
Date:   Sun, 6 Nov 2022 11:22:29 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        shuah@kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
        ajones@ventanamicro.com, bgardon@google.com, dmatlack@google.com,
        will@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, seanjc@google.com, oliver.upton@linux.dev,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v8 3/7] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2ffRYoqlQOxgVtk@x1n>
References: <20221104234049.25103-1-gshan@redhat.com>
 <20221104234049.25103-4-gshan@redhat.com>
 <87o7tkf5re.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87o7tkf5re.wl-maz@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Marc,

On Sun, Nov 06, 2022 at 03:43:17PM +0000, Marc Zyngier wrote:
> > +Note that the bitmap here is only a backup of the ring structure, and
> > +normally should only contain a very small amount of dirty pages, which
> 
> I don't think we can claim this. It is whatever amount of memory is
> dirtied outside of a vcpu context, and we shouldn't make any claim
> regarding the number of dirty pages.

The thing is the current with-bitmap design assumes that the two logs are
collected in different windows of migration, while the dirty log is only
collected after the VM is stopped.  So collecting dirty bitmap and sending
the dirty pages within the bitmap will be part of the VM downtime.

It will stop to make sense if the dirty bitmap can contain a large portion
of the guest memory, because then it'll be simpler to just stop the VM,
transfer pages, and restart on dest node without any tracking mechanism.

[1]

> 
> > +needs to be transferred during VM downtime. Collecting the dirty bitmap
> > +should be the very last thing that the VMM does before transmitting state
> > +to the target VM. VMM needs to ensure that the dirty state is final and
> > +avoid missing dirty pages from another ioctl ordered after the bitmap
> > +collection.
> > +
> > +To collect dirty bits in the backup bitmap, the userspace can use the
> > +same KVM_GET_DIRTY_LOG ioctl. KVM_CLEAR_DIRTY_LOG shouldn't be needed
> > +and its behavior is undefined since collecting the dirty bitmap always
> > +happens in the last phase of VM's migration.
> 
> It isn't clear to me why KVM_CLEAR_DIRTY_LOG should be called out. If
> you have multiple devices that dirty the memory, such as multiple
> ITSs, why shouldn't userspace be allowed to snapshot the dirty state
> multiple time? This doesn't seem like a reasonable restriction, and I
> really dislike the idea of undefined behaviour here.

I suggested the paragraph because it's very natural to ask whether we'd
need to CLEAR_LOG for this special GET_LOG phase, so I thought this could
be helpful as a reference to answer that.

I wanted to make it clear that we don't need CLEAR_LOG at all in this case,
as fundamentally clear log is about re-protect the guest pages, but if
we're with the restriction of above (having the dirty bmap the last to
collect and once and for all) then it'll make no sense to protect the guest
page at all at this stage since src host shouldn't run after the GET_LOG
then the CLEAR_LOG will be a vain effort.

I used "undefined" here just to be loose on the interface, also a hint that
we should never do that for this specific GET_LOG.  If we want, we can
ignore CLEAR_LOG in the future with ALLOW_BITMAP, and the undefined also
provides the flexibility, but that's not really that important.

The wording could definitely be improved, or maybe even avoid mentioning
the CLEAR_LOG might help, but IIUC the major thing to reach the consensus
is not CLEAR_LOG itself but on whether we can have that assumption [1] and
whether such a design of using dirty bmap is acceptable in general.

Thanks,

-- 
Peter Xu

