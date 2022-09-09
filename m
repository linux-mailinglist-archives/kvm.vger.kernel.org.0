Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78AA15B372E
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 14:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiIIMIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 08:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbiIIMIk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 08:08:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84DA13813D
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 05:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662725317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0zXr68Ku17TqRx7WZIlisO7PY+izsxHqFvN1+7uz8BY=;
        b=QMZ2FiByoBlj+vPsnsfERownjLq/39NFmKSRsqAmsObsTIDqvpXUHwFZBZxzCCetYiq31o
        FHCpCFHSc54ueUIoeO+6Gu1Wjqmtu4Jw540km1EN0zoQp3vNaKXKbrmDHkhMe+EPA+3ZTX
        dpPw8QfDTRD1vMWVBYI2mcNp7X11k5M=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-209-9XjLa4tqMDuo8qnebtNdpQ-1; Fri, 09 Sep 2022 08:08:35 -0400
X-MC-Unique: 9XjLa4tqMDuo8qnebtNdpQ-1
Received: by mail-io1-f71.google.com with SMTP id s2-20020a6bdc02000000b006a0cb10e1e8so405722ioc.14
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 05:08:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=0zXr68Ku17TqRx7WZIlisO7PY+izsxHqFvN1+7uz8BY=;
        b=toMYLhxlGmtdGFrZm7BmDIo8niTFzvw/G1DpsQaJ8aC3VMMbbgdYjHgX49dMaVf5k0
         gf9ASAVEf62w2+9WrUVx5mGQji0MG/k2khGA/MBIrhI6qjG2rwbsh6jSjBVHiYyr1Cdr
         FxV0mjQWQL1N+PQb4b31wY0dwqAE2fkefFtZZITWSL4N+/7x3akzo4itheKs3ckxp2CT
         w/hCWGsFt5LXMQ3tWuHS8rG5dw/SVeYSqEB8hqthHsTQ1h0cIgyaMmQnL0mlTQmNGyAb
         97WT64JksvXxX5CY5wh3ELsiWHyylXcQLfu869NRS449kCYTA8wUkyCBsFhpGa+8ExxY
         kSwA==
X-Gm-Message-State: ACgBeo2rc9FYKhsXhAYznaQ3nwMp1rhP5JzpyZUgfIjDUYITihufgRIo
        3hBFWeai773T6IfHxOUESoayTuqmgjlkpWyq2nfzlZweKgUbFDVWz2Zqce4EM4dZXr7ip/Y7fwx
        0R1YWAqMaTg3c
X-Received: by 2002:a05:6602:1691:b0:68d:8e03:197b with SMTP id s17-20020a056602169100b0068d8e03197bmr6694183iow.190.1662725314162;
        Fri, 09 Sep 2022 05:08:34 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5iSRx1+fKzoqaDdK1SGGLBKpq8PLWfkyRCyK8z6gMVXMYQAnQZDmTYSNyT4G7AZUQrY+aZ8g==
X-Received: by 2002:a05:6602:1691:b0:68d:8e03:197b with SMTP id s17-20020a056602169100b0068d8e03197bmr6694175iow.190.1662725313935;
        Fri, 09 Sep 2022 05:08:33 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id g15-20020a05663810ef00b00358422fcc7bsm126205jae.120.2022.09.09.05.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 05:08:33 -0700 (PDT)
Date:   Fri, 9 Sep 2022 06:08:32 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [GIT PULL] VFIO fix for v6.0-rc5
Message-ID: <20220909060832.17f6607f.alex.williamson@redhat.com>
In-Reply-To: <CAHk-=wj3rrkPvPJB_u4qoHK4=PVUuBHKB67f_oZO62EE22pNPQ@mail.gmail.com>
References: <20220909045225.3a572a57.alex.williamson@redhat.com>
        <CAHk-=wj3rrkPvPJB_u4qoHK4=PVUuBHKB67f_oZO62EE22pNPQ@mail.gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 9 Sep 2022 07:53:17 -0400
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Sep 9, 2022 at 6:52 AM Alex Williamson
> <alex.williamson@redhat.com> wrote:
> >
> > VFIO fix for v6.0-rc5
> >
> >  - Fix zero page refcount leak (Alex Williamson)  
> 
> Ugh. This is disgusting.
> 
> Don't get me wrong - I've pulled this, but I think there's some deeper
> problem that made this patch required.
> 
> Why is pin_user_pages_remote() taking a reference to a reserved page?
> Maybe it just shouldn't (and then obviously we should fix the unpin
> case to match too).
> 
> Adding a few GUP people to the participants for comments.
> 
> Anybody?

Yes, David is working on allocating pages rather than pinning the zero
page, however that's going to have some user visible locked memory
accounting changes.  This isn't the long term solution, it's only meant
to close the shared zero page refcount holes we have currently.  Thanks,

Alex

