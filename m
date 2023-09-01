Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B0178FA80
	for <lists+kvm@lfdr.de>; Fri,  1 Sep 2023 11:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348730AbjIAJLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 05:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345239AbjIAJLZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 05:11:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8705891
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 02:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693559435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Npb7HHjeN5fjX+Qj/C+KTeBsU8vb8i0pb6C74by2qvY=;
        b=cySqZf5nnonqme4qf4e5ulyZaIuRsRkaeFAAQMaPKAHG5NljKi0ROdjVVjuVmflVHneJHT
        Cc7PW6sKfr0Rx6RKogqOWwhKgfhPcwwmjQ/cKCQvtBRFXJgkjM+VpMJUm9JV4uGR5WyN3r
        KQX0aestDIH+kdV054H8i9GHH0CqAgo=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-258-Tj6ysTc1O6-xu3CCFeDW6Q-1; Fri, 01 Sep 2023 05:10:32 -0400
X-MC-Unique: Tj6ysTc1O6-xu3CCFeDW6Q-1
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-44e84042d04so736832137.3
        for <kvm@vger.kernel.org>; Fri, 01 Sep 2023 02:10:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693559431; x=1694164231;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Npb7HHjeN5fjX+Qj/C+KTeBsU8vb8i0pb6C74by2qvY=;
        b=gFch24ZtEf2NerIBs1hwGKzujEueCgSTheypZpZtF6NNwKc0OG9K444LLn0N0j0AiS
         q0l7tfmAKUrd9KBaLzh71R9CiRN1d4/JWE0LENg3GkRERtpR0rGiUv/nsM4TQBKh9PQ9
         ON/vOzDiMql+PSZnMxQ0ZFLj9Tb+jrnJMBTdTLAn2kGbj9GatClC0jFpxiOjfXY2DGkN
         /5ZZ0KAJDYe/QwzH2drR0uNIXAwnAX4OOaWeu19jtAYOv/djgeoPqf9/QX1qbTa8/UG4
         ZUfoRpVVlCbaxNrazgG/a12/Fe5NLeH+1IkkTPDarbjXi7LMvUF+hQ955g0C3fGfesYu
         uXGg==
X-Gm-Message-State: AOJu0Yz3LY95fXSi/uqOPO2CP3KgqHumnq8Rb5hZE/uCTEK4I4HXeX9y
        LW84yuHDa1tRzPGOGBoOMuVcMTs1EWyl2oetG5Xytn+crfdrA8H/S73gxN+MimhAo5ZPF0mq/qy
        kARhVZDPfgGwocyZ1bNl7nPuEP4+W
X-Received: by 2002:a05:6102:89:b0:44d:41bc:705f with SMTP id t9-20020a056102008900b0044d41bc705fmr2414536vsp.16.1693559431489;
        Fri, 01 Sep 2023 02:10:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFMjkxY54wxRMW3sIgi7Vp5N8QNLOqk6yIG1MtN5b5s07wY8abS7UBuZHmvRpd1eD0Dh7Qzo4ITN1QjU7QKM6M=
X-Received: by 2002:a05:6102:89:b0:44d:41bc:705f with SMTP id
 t9-20020a056102008900b0044d41bc705fmr2414505vsp.16.1693559431201; Fri, 01 Sep
 2023 02:10:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230718234512.1690985-1-seanjc@google.com> <ZOjpIL0SFH+E3Dj4@google.com>
 <20230829091233.GA72470@chaop.bj.intel.com> <ZPDcAuHcoRfU+yRX@google.com> <20230901011711.GA673287@chaop.bj.intel.com>
In-Reply-To: <20230901011711.GA673287@chaop.bj.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Fri, 1 Sep 2023 11:10:18 +0200
Message-ID: <CABgObfZiS+e7oDbwuC1Uycsz8Mjsu-FSfSmu=3R0M71vUhpq_Q@mail.gmail.com>
Subject: Re: [RFC PATCH v11 00/29] KVM: guest_memfd() and per-page attributes
To:     Chao Peng <chao.p.peng@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Fuad Tabba <tabba@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Jorg Rodel <jroedel@suse.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 1, 2023 at 3:28=E2=80=AFAM Chao Peng <chao.p.peng@linux.intel.c=
om> wrote:
> > FYI, I jumped the gun, sounds like Paolo got far enough along to form a=
 strong
> > opinion[*].

Yeah, I still have some crashes here and there :) so I didn't post
anything, but here are some note from the experiment.

The only benefit is that gmem does not need the splitting logic of
__filemap_add_folio, because (I think) there shouldn't be conflicts
with existing entries. Otherwise it's just a bunch of duplicate code
with mm/filemap.c, about 150 lines of code.

One question is whether to use our own xarray (e.g. in the private
inode data) or use i_pages, and likewise for the invalidation lock.
In my patches I did the former for the sake of safety; I skimmed
filemap.c enough to think it would work to use i_pages, but I wasn't
very convinced of which idea is better.

Initially I was most nervous about memory failure, because of the path
identify_page_state -> page_action -> me_pagecache_{clean,dirty} ->
truncate_error_page -> filemap_release_folio. In the end
filemap_release_folio is doing nothing that is filemap-dependent, in
particular it doesn't do anything on the i_pages and the filemap
locks. So a plan could be to just identify filemap functions that
don't use i_pages, and rename them, for example filemap_release_folio
could become folio_release_from_mapping.

Crashes aside, I actually don't have any objection to *not* using the
filemap long term, but right now I don't really see a reason to do it.
We don't know if hugetlbfs support will be easier or harder with the
filemap for example, and given Vlastimil's reply I think the main
objection to using the filemap is gone. If we switch, we should invest
the time in making the filemap and mapping APIs a bit more separate.

Paolo

> Yeah, I see that, that is a good news actually, then we can go ahead with
> the current filemap one. I personally think these mm touchpoints are not
> a big deal when compared to previous versions, most part we are just usin=
g
> the APIs.
>
> >
> > Thanks for volunteering though, much appreciated!
>
> NP, any collaboration is to make this lasting years series merge earlier.
>
> Chao
> >
> > [*] https://lore.kernel.org/all/CABgObfay4FKV=3DfoWLZzAWaC2kVHRnF1ib+6N=
C058QVZVFhGeyA@mail.gmail.com
>

