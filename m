Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D0C52534F
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 19:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356898AbiELRL4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 13:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356924AbiELRLA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 13:11:00 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F068A27CE7
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 10:10:55 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id n10so11539297ejk.5
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 10:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=loonHWmCtVeGx4aWVVUzPzapZ1t+QIqGsKXmCgmw6z8=;
        b=WD5qjD3n7PQ6Q1+OHYaSBYIXZyE3MSnd14hOsae1gMnqzXVow2TJFjREwN777Ig52q
         V4qfULfCcQ86ni9aAhSi7LjMQHCPkFJi+glv65R1S+sQR6oFUNEhVyq5JADGgBm6h1kT
         2hznSR7F9VZ12haH7nWz1Ev8hTm8abuX+I6D4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=loonHWmCtVeGx4aWVVUzPzapZ1t+QIqGsKXmCgmw6z8=;
        b=FUVBwkskT9rhDSdZA3C2o/KStICY6TH2CbPGV5LofG5xsBYgcM1yW2GUxHT1WNE692
         TXjn2WVjQ9+uSL4e6l26U1SeT74cxHNJZxFuhpZ5szgQDS6y/DCIo1/NfY5HDSjfZ8oV
         W4Op9Jis0LJxnt+s/Bl1WyOx3KGXdyIED1TxpktzBVD0j4Qv/lPnTYOKYi3wwf1MQEiD
         KRJpnMwmtyGovbIRbN5FSokAw2DF0zrltFCSLHT9Kupbr/hyxvYjAI++2oCDlq8kHyl0
         E03IYyTHLn626Kq1jWtG1PSIIT3gJOHGHMvUj5+lqhfpLLdb5gkhU8gz2ptd8F1fu7Bp
         mrbw==
X-Gm-Message-State: AOAM530TnE9ncNeNvF0ERBPbExQDkxglaPRYeQHF57Rv3RfkcF+xo3Lp
        yQPoTziWHkHgfqHPpzYeFDboz5T+jEDWJfMJwqE=
X-Google-Smtp-Source: ABdhPJwaaLSPCzvW580VqFIG9WcUJKXv3LB/aQXcXhd/URhgNMRrE3VsLkCe4gx3t1+95BhO6FxNag==
X-Received: by 2002:a17:907:6297:b0:6da:6388:dc58 with SMTP id nd23-20020a170907629700b006da6388dc58mr830224ejc.472.1652375453361;
        Thu, 12 May 2022 10:10:53 -0700 (PDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id dx18-20020a170906a85200b006f3a8b81ff7sm2341252ejb.3.2022.05.12.10.10.51
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 10:10:51 -0700 (PDT)
Received: by mail-wr1-f41.google.com with SMTP id k2so8180007wrd.5
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 10:10:51 -0700 (PDT)
X-Received: by 2002:a05:6000:2c2:b0:20c:7329:7c10 with SMTP id
 o2-20020a05600002c200b0020c73297c10mr557896wry.193.1652375451235; Thu, 12 May
 2022 10:10:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220510082351-mutt-send-email-mst@kernel.org>
 <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
 <87czgk8jjo.fsf@mpe.ellerman.id.au> <CAHk-=wj9zKJGA_6SJOMPiQEoYke6cKX-FV3X_5zNXOcFJX1kOQ@mail.gmail.com>
 <87mtfm7uag.fsf@mpe.ellerman.id.au>
In-Reply-To: <87mtfm7uag.fsf@mpe.ellerman.id.au>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 12 May 2022 10:10:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgnYGY=10sRDzXCC2bmappjBTRNNbr8owvGLEW-xuV7Vw@mail.gmail.com>
Message-ID: <CAHk-=wgnYGY=10sRDzXCC2bmappjBTRNNbr8owvGLEW-xuV7Vw@mail.gmail.com>
Subject: Re: [GIT PULL] virtio: last minute fixup
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mie@igel.co.jp
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022 at 6:30 AM Michael Ellerman <mpe@ellerman.id.au> wrote:
>
> Links to other random places don't serve that function.

What "function"?

This is my argument. Those Link: things need to have a *reason*.

Saying "they are a change ID" is not a reason. That's just a random
word-salad. You need to have an active reason that you can explain,
not just say "look, I want to add a message ID to every commit".

Here's the thing. There's a difference between "data" and "information".

We should add information to the commits, not random data.

And most definitely not just random data that can be trivially
auto-generated after-the-fact.

                Linus
