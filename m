Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A97F5F8AF3
	for <lists+kvm@lfdr.de>; Sun,  9 Oct 2022 13:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiJILps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Oct 2022 07:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiJILpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Oct 2022 07:45:47 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FA92D1F7;
        Sun,  9 Oct 2022 04:45:44 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id l8so5338103wmi.2;
        Sun, 09 Oct 2022 04:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=twlFTPIFExHcgABlKji5EDqvNoVPZc6QckzjgiZRCPw=;
        b=UGKR098vducQiqq4/PQbunNJ2hGfJXz4KQaCyWsRxBICM3PvRHp89/Wj03DvX7+X1K
         fyPh2bgcJVTDMYLpis98gCCI63OLSM69Y92qoDsOtb87P3UELz36TL+5+7E5hZZlZ7L/
         A5Sm2U8Gey5savLqZmNLcy02bc76zBHyTbebi/4scv8tppjnhIOGOa2x+YkjE1XOcqqo
         fR8jORfrTWxatLY96KO4zG3gz00wCjVE5HjLQtCYywp/BKw3tfka4sp/iXm8GpWQ/nO+
         DJpIZuy7W+0hdf3/SLhXewHxwbddjGOve/3uE8hdjmT94pPAGRxZEJ2w/r1jio2x9/rq
         ze+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=twlFTPIFExHcgABlKji5EDqvNoVPZc6QckzjgiZRCPw=;
        b=Q3tr09RHxIScsTQM1Q+MjwtMbZXtv0wioBSGKKwmyZ7qeKWkJscqqYMHstnWJp570O
         X7e6/cDrfN3+Ye0CELS3432hiGT3mW++vs4CEhXyIN4lG/nm8FUnm0YWmTtHJ52jaBvC
         m2ruLeRKMXp5H0h83PMygYhDyRJsnQGttmo1skn5M0Un28hjbuVJM4Nw5HGiOWR/0I77
         kxo2PalqTLUskRFIsq3kiHoqd2Y/RHMNxkY9sMkxVbR69Sh24vPT7xW7xd4hTbfRQgWP
         pYzR5f/V00C2yF3HoHQENqKtuaBxtAdm7G6iamrl5bLru7QAUG/bEwH2WJW+FWGOGisj
         UiRQ==
X-Gm-Message-State: ACrzQf3GY4zuPW1t/R2tsv/aInNRo+wi41C4nqOqM635IOYTEZW46y1K
        AeotJFagoOOAP12D0G+UTNTvoupWcoVhVftLL2DvcrdhjOsp5Q==
X-Google-Smtp-Source: AMsMyM5lCnffgyv0LvPYhcouSYMKqGqi5zv/A7VlpzhurV8UGb9W4EpjQKvmahtrEm9cuk90TeRB5mpxfT+CMN4l7zI=
X-Received: by 2002:a05:600c:474c:b0:3c5:dbf4:ba94 with SMTP id
 w12-20020a05600c474c00b003c5dbf4ba94mr1769939wmo.21.1665315943302; Sun, 09
 Oct 2022 04:45:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAPm50a+aygp3T1mNjzGXtL2nyNm-mHFZ3YO8F7eO0gCxZDuQsA@mail.gmail.com>
 <Y0BeEVxkDkctmTIX@google.com>
In-Reply-To: <Y0BeEVxkDkctmTIX@google.com>
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Sun, 9 Oct 2022 19:45:31 +0800
Message-ID: <CAPm50aLzOLyURhvhYkCyp1hpRagAczFXg9jYbFg_86Qaf5usbg@mail.gmail.com>
Subject: Re: [PATCH] kvm: x86: keep srcu writer side operation mutually exclusive
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 8, 2022 at 1:12 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Sat, Oct 08, 2022, Hao Peng wrote:
> > From: Peng Hao <flyingpeng@tencent.com>
> >
> > Synchronization operations on the writer side of SRCU should be
> > invoked within the mutex.
>
> Why?  Synchronizing SRCU is necessary only to ensure that all previous readers go
> away before the old filter is freed.  There's no need to serialize synchronization
> between writers.  The mutex ensures each writer operates on the "new" filter that's
> set by the previous writer, i.e. there's no danger of a double-free.  And the next
> writer will wait for readers to _its_ "new" filter.
>
Array srcu_lock_count/srcu_unlock_count[] in srcu_data, which is used
alternately to determine
which readers need to wait to get out of the critical area. If  two
synchronize_srcu are initiated concurrently,
there may be a problem with the judgment of gp. But if it is confirmed
that there will be no writer concurrency,
it is not necessary to ensure that synchronize_srcu is executed within
the scope of the mutex lock.
Thanks.
> I think it's a moot point though, as this is a subset of patch I posted[*] to fix
> other issues with the PMU event filter.
>
> [*] https://lore.kernel.org/all/20220923001355.3741194-2-seanjc@google.com
