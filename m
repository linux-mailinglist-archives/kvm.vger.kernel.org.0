Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C050765CB23
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 01:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238906AbjADA5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 19:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238892AbjADA5P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 19:57:15 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D5217418
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 16:57:14 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id w4-20020a17090ac98400b002186f5d7a4cso37551029pjt.0
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 16:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gQVRK7Ngr8SadkYqBXZ4ftg4PKrius7yJjVZMNOq7V0=;
        b=gI5MCuz4suKeCXc6+rkrbhXzGRqJM4SOexsYPpeYiM3Xg7RN+pDV4vC5iRMg2ovNto
         jEW4KFNpe3yZ0kPsMEBEBUNCOsLOGocmjJ3QfClkhBj30ZjMxQIYaaA1n0vauvg2vIj6
         /ubVBDgW0KDu9ESqVCsvisfsSqNuBSNqP0oGBraEnA0l3ml1SEwqL9XJPqgNdm7LsMck
         ezJ8/wce8NoTnDgYDc3Dh5ucMfY/hkUccBNwDLrkMS7M0zLq/6O25tTGhqulPgMlJgh3
         4XYuHF3EDf1xM8R9IKGjW37LuLrQOip5zSe0Qt7VkEwnlJpNMbZvc7uI0c9//Q79618j
         I9hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gQVRK7Ngr8SadkYqBXZ4ftg4PKrius7yJjVZMNOq7V0=;
        b=Z5LDRqLHf6RyMTCbFEkQAjl7taqUEb0ylTa7wZKv1kxtX4uBCxwbCdTGWqwo3iee/j
         foeyyphogaiDhvHOD2eoctFErHYsQlELihQ3Vp33p07AjgmUrVxBAiu1+k/14kFU8AUM
         /xJlzNI+aVMUJHJSQgNf8uHCtaTkYsPmUWdb8byyc1L2qasVrCo5ellzRDuTFtCTjOuz
         rO8mXW2GDcs9tF+ELLI5zLmVCYsWRdZ3y0BBY15uomMZgKrzFRE6KUhNOQWZ6w/AEtuz
         3A5gCiJV07OGKNXN7dINz0h33gAQnKZ2slyeNRo2/wV+caSL8pu6yzyPAA80sZj0PjvZ
         LsRg==
X-Gm-Message-State: AFqh2kqI9qjQvL6E88MFVR3HkzS2r6mpNolEDUPAD5JwZP8297BFYO8k
        dcSpZbcQ4fLhOnX8AdXon9+z3A==
X-Google-Smtp-Source: AMrXdXsaAK01peQJRaNXRAdVOSwqllFLN43VZRb2n76/wGrUW5yfrYfsFUNyqSgs7vpv6Q+Xfy2Jiw==
X-Received: by 2002:a05:6a20:7f59:b0:ac:af5c:2970 with SMTP id e25-20020a056a207f5900b000acaf5c2970mr2958492pzk.3.1672793833505;
        Tue, 03 Jan 2023 16:57:13 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o1-20020a63f141000000b00478eb777d18sm19268912pgk.72.2023.01.03.16.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 16:57:13 -0800 (PST)
Date:   Wed, 4 Jan 2023 00:57:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     James Houghton <jthoughton@google.com>
Cc:     David Matlack <dmatlack@google.com>, Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Linux MM <linux-mm@kvack.org>, kvm <kvm@vger.kernel.org>,
        chao.p.peng@linux.intel.com, Oliver Upton <oupton@google.com>
Subject: Re: [RFC] Improving userfaultfd scalability for live migration
Message-ID: <Y7TO5Xxi5RWw1Xa6@google.com>
References: <Y44NylxprhPn6AoN@x1n>
 <CALzav=d=N7teRvjQZ1p0fs6i9hjmH7eVppJLMh_Go4TteQqqwg@mail.gmail.com>
 <Y442dPwu2L6g8zAo@google.com>
 <CADrL8HV_8=ssHSumpQX5bVm2h2J01swdB=+at8=xLr+KtW79MQ@mail.gmail.com>
 <Y46VgQRU+do50iuv@google.com>
 <CADrL8HVM1poR5EYCsghhMMoN2U+FYT6yZr_5hZ8pLZTXpLnu8Q@mail.gmail.com>
 <Y4+DVdq1Pj3k4Nyz@google.com>
 <CADrL8HVftX-B+oHLbjnJCret01yjUpOjQfmHdDa7mYkMenOa+A@mail.gmail.com>
 <CALzav=cyPgsYPZfxsUFMBJ1j33LHxfSY-Bj0ttZqjozDm745Nw@mail.gmail.com>
 <CADrL8HV2K=NAGATdRobq8aMJJwRapiF7gxrJovhz7k-Me3ZFuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADrL8HV2K=NAGATdRobq8aMJJwRapiF7gxrJovhz7k-Me3ZFuw@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 08, 2022, James Houghton wrote:
> - For the no-slow-GUP choice, if someone MADV_DONTNEEDed memory and we
> didn't know about it, we would get stuck in MADV_POPULATE_WRITE. By
> using UFFD_FEATURE_THREAD_ID, we can tell if we got a userfault for a
> thread that is in the middle of a MADV_POPULATE_WRITE, and we can try
> to unblock the thread by doing an extra UFFDIO_CONTINUE.
> 
> - For the PF_NO_UFFD_WAIT choice, if someone MADV_DONTNEEDed memory,
> we would just keep trying to start the vCPU without doing anything (we
> assume some other thread has UFFDIO_CONTINUEd for us). This is
> basically the same as if we were stuck in MADV_POPULATE_WRITE, and we
> can try to unblock the thread in a fashion similar to how we would in
> the other case.
> 
> So really these approaches have similar requirements for what
> userspace needs to track. So I think I prefer the no-slow-GUP approach
> then.

Are you planning on sending a patch (RFC?) for the no-slow-GUP approach?  It sounds
like there's a rough consensus that that's a viable, minimally invasive solution.
