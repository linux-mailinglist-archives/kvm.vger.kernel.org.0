Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF456A247E
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 23:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjBXWvI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 17:51:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjBXWvH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 17:51:07 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A011B2D6
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:51:05 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id cy6so3279729edb.5
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XetVmJJp94Tm+T8Ok6omBAdD9XAfcZ6uupziRkiZMk4=;
        b=O992ZC0d4Fin+fSMDEuc/r4oFcV7GuLj9xW5Jaak+IJxNIGgsgHvuvCcZiaX+GMlBS
         N776OX1MKa2ocMIExB/CvqrGqgUncIQxhKN3EjfIdflSlixcjzb9Pf0PvLdScnculsFz
         Jb+JalT+9UXEQKhI1dBBcBnwv7Q14O8TVsOwU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XetVmJJp94Tm+T8Ok6omBAdD9XAfcZ6uupziRkiZMk4=;
        b=3sM+Dk7miYmwW05dpkZckD6jPDkZVRl9/oJHLxDdRRxNhKbzhs8cRZ6sm+UXapsQAk
         UScsWZKv5kg9Rs9ITDXSHz0MMmpOs1TlRELVslPmc9X4mssO6xr8b4A05GKso12Od/qK
         hmO2fqH73J2VJe3O/6YttSQ4TK4g7qlpE5Rl3YFf4mYE9Cb5LL3jKde6+Qb704+R/qYA
         vXGgP5Qp593ozObppXnm7rlx3wE49gx/f6zki6g2Q3gmlms6BZe8PhlFyXLD9mj47HwZ
         bdb+aB6PQck5vm8oJorZNAxYtQ9SCrfDQdLQHR/eqf5aeArdBYgnf6B28lzzz1h/Zkbh
         LNpQ==
X-Gm-Message-State: AO0yUKVPrr1eIAYQJ4vZCmgRae4HtSXkLk2cViK9DdLc//uFuCboj8m+
        WczAlMa4Fs6/upsZ9PYTBw8CyiDK8bdXcqH2vsSg/w==
X-Google-Smtp-Source: AK7set+JUJGS4taTF2L4iG7qSnErZT/B9l94aSS+gXotcCJFECvjzbG6kwXbbzPZjNqKXP8t1enfOw==
X-Received: by 2002:a17:906:9f19:b0:879:ec1a:4ac with SMTP id fy25-20020a1709069f1900b00879ec1a04acmr33104346ejc.76.1677279063456;
        Fri, 24 Feb 2023 14:51:03 -0800 (PST)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id m9-20020a170906234900b008d85435f914sm91320eja.98.2023.02.24.14.51.02
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 14:51:02 -0800 (PST)
Received: by mail-ed1-f45.google.com with SMTP id ee7so3349454edb.2
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 14:51:02 -0800 (PST)
X-Received: by 2002:a50:9fae:0:b0:4ab:4d34:9762 with SMTP id
 c43-20020a509fae000000b004ab4d349762mr8258013edf.5.1677279062350; Fri, 24 Feb
 2023 14:51:02 -0800 (PST)
MIME-Version: 1.0
References: <Y/Tlx8j3i17n5bzL@nvidia.com>
In-Reply-To: <Y/Tlx8j3i17n5bzL@nvidia.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 24 Feb 2023 14:50:45 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiy2XRdvxchyuVYJJ618sAcGiPPam14z8yAW+kyCzgPmA@mail.gmail.com>
Message-ID: <CAHk-=wiy2XRdvxchyuVYJJ618sAcGiPPam14z8yAW+kyCzgPmA@mail.gmail.com>
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 21, 2023 at 7:39 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> iommufd for 6.3
>
> Some polishing and small fixes for iommufd:

Hmm. About half the patches seem to not be about iommufd, but about
'isolated_msi', which isn't even mentioned in the pull request at all
(well, it's there in the shortlog, but not in the actual "this is what
happened")

I already merged it, and am not sure what I would add to the commit
message, but I really would have liked to see that mentioned,
considering that it wasn't some small part of it all.

              Linus
