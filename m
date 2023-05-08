Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C93C6F9D41
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 03:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbjEHBNU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 May 2023 21:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbjEHBNJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 May 2023 21:13:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76B710E7
        for <kvm@vger.kernel.org>; Sun,  7 May 2023 18:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683508341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=crOvUhwjWMe5ldALZcK+bWVRsIvTigamFdYJnvRCc+k=;
        b=aRk/WZUiE5H4wcfwsnFjLEJcZXCejW2pW+fyf1Yhb2NYukb2H5bWtNkghZ0DYHwDNXAL8g
        /mEqnGHXWXgVsQZ6KhHdXq+IZNzNtuTp7kEZsUDL54p5oy7IM97LfA6m3sj0gz2sPEVNke
        Yyw1+QMGxmn3waHnIkQQR0oZP4vziDY=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-d2E6MXI1NmKwRW_xMWsCZA-1; Sun, 07 May 2023 21:12:20 -0400
X-MC-Unique: d2E6MXI1NmKwRW_xMWsCZA-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-517bfdf53faso381670a12.1
        for <kvm@vger.kernel.org>; Sun, 07 May 2023 18:12:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683508339; x=1686100339;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=crOvUhwjWMe5ldALZcK+bWVRsIvTigamFdYJnvRCc+k=;
        b=lb236lO0f53lDEp5BNs2r2pIKUdUozRzTU5jKqw46kk44/1/89lPiuaDfNOtn16ezB
         T7e+oDCnwe2e3zXdTlxLCWfOr/oYIQmXP6M6QTB5juMp5cip6hhDk0jnDmxeKZLfQdxg
         N/Afp14ItTABAuJouFOWfLaEu8Vf7Oyl/GML6ZvVneUSjONm5ccK47NySoYShBUm2cm0
         xoD4T9DH563+YnEkdIcoGskcc8tTo6si37b4KbA/HJTnhKhCYh3ASQ9f2jRT5rHLcWTo
         e4MxNw34o1x7VAhGwFOHmF31Y8SU7y357QZr/h53RY7o4VkJYW/ZZ0AwDJ2H3+kChxQe
         465A==
X-Gm-Message-State: AC+VfDzOB4OdjE9oTfYP/CqIogd+PZnL7eugKfeTyX784opCsjzMnJlE
        2Ygx77EgmBvM3f3+9/38d+TQ1KDUQn3UIksnPEWI4VOHF+s+ExQFuVYi4fQHPF3oH8YIxnjt7g+
        OX9RbB0OpmwXU
X-Received: by 2002:a17:902:f547:b0:1a6:cf4b:4d7d with SMTP id h7-20020a170902f54700b001a6cf4b4d7dmr10938697plf.2.1683508339148;
        Sun, 07 May 2023 18:12:19 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4OMuP9/L3QvkgPezFjxbEVSdfVj4hTA3JWpTR4p0g9C8dPFEy31LGZPHS04LcqDo5xOhUGsA==
X-Received: by 2002:a17:902:f547:b0:1a6:cf4b:4d7d with SMTP id h7-20020a170902f54700b001a6cf4b4d7dmr10938674plf.2.1683508338774;
        Sun, 07 May 2023 18:12:18 -0700 (PDT)
Received: from x1n ([64.114.255.114])
        by smtp.gmail.com with ESMTPSA id w4-20020a170902904400b001aaed82b824sm5740946plz.144.2023.05.07.18.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 May 2023 18:12:18 -0700 (PDT)
Date:   Sun, 7 May 2023 21:12:17 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Anish Moorthy <amoorthy@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, maz@kernel.org,
        oliver.upton@linux.dev, James Houghton <jthoughton@google.com>,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        kvm <kvm@vger.kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 00/22] Improve scalability of KVM + userfaultfd live
 migration via annotated memory faults.
Message-ID: <ZFhMcS/bLnpW/R4+@x1n>
References: <CAF7b7mo78e2YPHU5YrhzuORdpGXCVRxXr6kSyMa+L+guW8jKGw@mail.gmail.com>
 <84DD9212-31FB-4AF6-80DD-9BA5AEA0EC1A@gmail.com>
 <CAF7b7mr-_U6vU1iOwukdmOoaT0G1ttyxD62cv=vebnQeXL3R0w@mail.gmail.com>
 <ZErahL/7DKimG+46@x1n>
 <CAF7b7mqaxk6w90+9+5UkEAE13vDTmBMmCO_ZdAEo6pD8_--fZA@mail.gmail.com>
 <ZFLPlRReglM/Vgfu@x1n>
 <ZFLRpEV09lrpJqua@x1n>
 <ZFLVS+UvpG5w747u@google.com>
 <ZFLyGDoXHQrN1CCD@x1n>
 <8ED96522-B4A5-4106-B30B-8BE635B5DA7A@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8ED96522-B4A5-4106-B30B-8BE635B5DA7A@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Nadav,

On Fri, May 05, 2023 at 01:05:02PM -0700, Nadav Amit wrote:
> > ./demand_paging_test -b 512M -u MINOR -s shmem -v 32 -c 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32
> > 
> > It seems to me for some reason the scheduler ate more than I expected..
> > Maybe tomorrow I can try two more things:
> > 
> >  - Do cpu isolations, and
> >  - pin reader threads too (or just leave the readers on housekeeping cores)
> 
> For the record (and I hope I do not repeat myself): these scheduler overheads
> is something that I have encountered before.
> 
> The two main solutions I tried were:
> 
> 1. Optional polling on the faulting thread to avoid context switch on the
>    faulting thread.
> 
> (something like https://lore.kernel.org/linux-mm/20201129004548.1619714-6-namit@vmware.com/ )
> 
> and 
> 
> 2. IO-uring to avoid context switch on the handler thread.
> 
> In addition, as I mentioned before, the queue locks is something that can be
> simplified.

Right, thanks for double checking on that.  Though do you think these are
two separate issues to be looked into?

One thing on reducing context switch overhead with a static configuration,
which I think is what can be resolved by what you mentioned above, and the
iouring series.

One thing on the possibility of scaling userfaultfd over splitting guest
memory into a few chunks (literally demand paging test with no -a).
Logically I think it should scale if with pcpu pinning on vcpu threads to
avoid kvm bottlenecks around.

Side note: IIUC none of above will resolve the problem right now if we
assume we can only have 1 uffd to register to the guest mem.

However I'm curious on testing multi-uffd because I wanted to make sure
there's no other thing stops the whole system from scaling with threads,
hence I'd expect to get higher fault/sec overall if we increase the cores
we use in the test.

If it already cannot scale for whatever reason then it means a generic
solution may not be possible at least for kvm use case.  While OTOH if
multi-uffd can scale well, then there's a chance of general solution as
long as we can remove the single-queue contention over the whole guest mem.

PS: Nadav, I think you mentioned twice on avoiding taking two locks for the
fault queue, which sounds reasonable.  Do you have plan to post a patch?

Thanks,

-- 
Peter Xu

