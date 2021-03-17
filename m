Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E49833EB05
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 09:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbhCQIFV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 04:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbhCQIFC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 04:05:02 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0831CC06174A
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 01:05:02 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id w125so12361503oib.13
        for <kvm@vger.kernel.org>; Wed, 17 Mar 2021 01:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EI5qglqxsKAU/W0ZKYTsFSvZf8l0B/oXcoORkaxMSD8=;
        b=fb1VA654QtgBN7yjx24Vbsgr8qILHcsfU8IERmXJmGaXai7ib/t/sz/A2+trz33o9V
         +jZ2x+KTzIoXu9ur15pcoOP0mcety3wwVzOYYhW2IDGTduuc/R5KdINLJaadqXnV3Anw
         TPbRuol5s8uvpHLE2zkBMQ0iFY8Iob2xpapBI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EI5qglqxsKAU/W0ZKYTsFSvZf8l0B/oXcoORkaxMSD8=;
        b=YIBKEILxcsVmYgL6TWqcoA13FkWtj8/yl08kbITuBSAhk820PkW2lJCNQJNC1dzgmK
         /T+UmLjACvI7RZYhPLXDMSynJM56+7hrx62dWS/c5HJRKJ9Iv10Jile6uUWPICym88r/
         prOW14OjVKXAdeO3sN8MGcbcpTEyh/DJOIkekrO2Jj7erdwvIlFQi27kk9AlQjlCsDnK
         d6NdzcNY3qskxfFhv6pWr2qiisWXglVc44Bb0mO7sYTKLpWsLjh9iwJHet9tQsSqMGhy
         lo8C0ALQU4RJzFnGXCWcBd6V64qY4HBMVqbUyZF5+NY9UuA/R+iGonK1r9oM+lqZbtCS
         AUbA==
X-Gm-Message-State: AOAM530rUrJODB0d+Ilb336BoGxpL9tb+lFQOT/U7LlkBXCBtZ9mUe4G
        q2RwKl51CtEAlNRRQxjKtC5uQ2Q90fRB2AO809fIww==
X-Google-Smtp-Source: ABdhPJwZYNnRwoTd/kuED1Yfh8EqOUzOIuqMpTc+matmHqjzLk6Tn4x3yBWT0QFOmmnBuxIzgcZ9JwEdKsAutEEaYeo=
X-Received: by 2002:aca:4188:: with SMTP id o130mr1878713oia.101.1615968301447;
 Wed, 17 Mar 2021 01:05:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210316153303.3216674-1-daniel.vetter@ffwll.ch>
 <20210316153303.3216674-3-daniel.vetter@ffwll.ch> <20210316154549.GA60450@infradead.org>
 <CAKMK7uF8Lv0P4TuoctjUiVHtRzAnXf9a50JaYgm0rV+v+7=LFw@mail.gmail.com> <20210317072248.GA284559@infradead.org>
In-Reply-To: <20210317072248.GA284559@infradead.org>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed, 17 Mar 2021 09:04:50 +0100
Message-ID: <CAKMK7uGe4-7EzgYo-rLyhxp5Dft-6V_a610TmL0hRucYTpdmRQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] media/videobuf1|2: Mark follow_pfn usage as unsafe
To:     Christoph Hellwig <hch@infradead.org>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK" 
        <linux-media@vger.kernel.org>, Tomasz Figa <tfiga@chromium.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        "J??r??me Glisse" <jglisse@redhat.com>, Jan Kara <jack@suse.cz>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Laurent Dufour <ldufour@linux.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Michel Lespinasse <walken@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 17, 2021 at 8:22 AM Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Mar 16, 2021 at 04:52:44PM +0100, Daniel Vetter wrote:
> > My understanding is mostly, but with some objections. And I kinda
> > don't want to let this die in a bikeshed and then not getting rid of
> > follow_pfn as a result. There's enough people who acked this, and the
> > full removal got some nack from Mauro iirc.
>
> Hmm, ok I must have missed that.  I defintively prefer your series over
> doing nothing, but killing the dead horse ASAP would be even better.

I have a bunch of slow-burner things I need to fix in this area of
driver mmaps vs get_user_/follow_ conflicts anyway, I'll add a note to
put the horse out of it's misery in due time. We have a few problems
still where things might get pinned or used where it really shouldn't
be.

Can I count that as an ack on the series? You've touched this quite a
bit recently.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
