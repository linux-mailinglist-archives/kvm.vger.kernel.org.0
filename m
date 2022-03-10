Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEC54D4665
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 13:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241843AbiCJMC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 07:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241837AbiCJMC6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 07:02:58 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20312145ADA
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 04:01:57 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-2db569555d6so54656807b3.12
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 04:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H/7T7n7J54EKw3oUolg3f7j6poaaunPmy+9YPRhmhjE=;
        b=N8jFLNEGCBDr4ygzQs0uXr+lqtgYWBoJ+Kyrn83FSoFn2rGE2i+P5TOUgEzehCo9eF
         M3nQgvshhah+08FYtCUCwwrNIh2mEY6WOXasryB2K//MYyjoCTYjRLjZtLtPHTE8+diM
         EURtg3Zodu0m9Gv7vwMgoLej4hMUeWjxUpRPzDg1L9cdk4YxGf1NCmmJlZnLRyQvG+NH
         Y/Fy5v1+RCNg7gwXKr5v7Ge5ZtEYA13njjs3YUZmCqFePxgq/BmltpdgrC72bsKcYHug
         EIL44/sCx2hHpqovIukwhYOgBVaSfXmvVzzpDusxkHf/NgXhCezsHBP4wNmf/UA8bz2T
         fD4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H/7T7n7J54EKw3oUolg3f7j6poaaunPmy+9YPRhmhjE=;
        b=HcQDK+7Tpy0AHNWZ2smpGZnoZkPGj19/TLSO0OZPw1gV8hGIZ0D34mZMqA9nyr9+Bc
         qtjJyOADNjbzuBuCVMZydWvITUP3san2Myzd+fbvzhF2yWaMJaEd+nMVwBNH7qxh+1JM
         g3xwIAscAtr5uP1IhnGg21ZS0bfzU3+z754eiCSNeCesATM3MD/8aIwwdFDZajDmtVbA
         nWEQ8fsNtQMm23sXgSj2/MZcayWE2Q8oMmsZ29VNM5qCluo16730uiC0WJcKHUxZYagE
         kr0Yye6hWk5ZAJMaUUO1dB+PPQwYogcKe228Y6u0fKdzYq6FTyg2SFMN69AXSdPTDY1B
         URog==
X-Gm-Message-State: AOAM531+uAt+5NhTdEjXEMHa9DbavNe2pJ4MTvKaMmO411dbd9B4CVLr
        hWtLeRWYvhnlY7Lj/dz+bxLUQDt2SzfrhRnHXm9mzA==
X-Google-Smtp-Source: ABdhPJwTI9Oi3f0kPhKsaVmF4VrANleM5nwDNL0QRoHvu350nGwPWqvFW1tSHFL8xHZbqbJGSo1RP5FBZP0a27Szfz8=
X-Received: by 2002:a81:4f96:0:b0:2dc:2e67:6b73 with SMTP id
 d144-20020a814f96000000b002dc2e676b73mr3489458ywb.352.1646913715396; Thu, 10
 Mar 2022 04:01:55 -0800 (PST)
MIME-Version: 1.0
References: <20220310081854.2487280-1-jiyong@google.com> <20220310085931.cpgc2cv4yg7sd4vu@sgarzare-redhat>
 <CALeUXe6heGD9J+5fkLs9TJ7Mn0UT=BSdGNK_wZ4gkor_Ax_SqA@mail.gmail.com> <20220310110036.fgy323c4hvk3mziq@sgarzare-redhat>
In-Reply-To: <20220310110036.fgy323c4hvk3mziq@sgarzare-redhat>
From:   Jiyong Park <jiyong@google.com>
Date:   Thu, 10 Mar 2022 21:01:18 +0900
Message-ID: <CALeUXe5bVk5P9s-4YFVtUtrvWBYRMmtMrx+BOv4AMHVn1Kvv=A@mail.gmail.com>
Subject: Re: [PATCH] vhost/vsock: reset only the h2g connections upon release
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, adelva@google.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> I see your point, and it makes sense to keep KMI on stable branches, but
> mainline I would like to have the proposed approach since all transports
> use it to cycle on their sockets.
>
> So we could do a series with 2 patches:
> - Patch 1 fixes the problem in all transports by checking the transport
>    in the callback (here we insert the fixes tag so we backport it to the
>    stable branches)
> - Patch 2 moves the check in vsock_for_each_connected_socket() removing
>    it from callbacks so it is less prone to errors and we merge it only
>    mainline
>
> What do you think?
>
> Thanks,
> Stefano
>

That sounds like a plan. Will submit a new series soon.
