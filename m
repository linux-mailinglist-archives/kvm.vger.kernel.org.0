Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 781B1205A97
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 20:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387453AbgFWS3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 14:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387450AbgFWS3F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 14:29:05 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623DEC061573
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 11:29:05 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id w9so6462775ilk.13
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 11:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kW7bHoJy2eydKQuJspEklH4sgRSrZPo4WoIA+jXitmY=;
        b=XMyihuOqezP7lc+3GIKDIdAieGFnertNTxoddty9EZCnTQfHpxx89PFT7gEJCDBp4h
         vKp24hlm48laShnapoIoc9YBmBXBYzwG31WNtXB29/JL2QsKaaqFJ0nrO136xf/z5BqS
         ZhT8gp9OK7R79HfdA0PC5niaR3xPJnP6RVOFIkB9y7ndXsAqpZFljE5UVqdapEAt2U+0
         NgqYgqjG0gKvvNMhAfmkCyDhg9K5+sY+HdWe2WPatuFNHH2la+TfuYgJDu7JMRw6QmVB
         8dCMZBB+5/DtnCF54FO93utyUcdz0dObuMiezZ7rnYodmjZRHIyfeNG9jVUW6WIZVYcb
         MC3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kW7bHoJy2eydKQuJspEklH4sgRSrZPo4WoIA+jXitmY=;
        b=NJ81fy/asoc5lWelaFBrvDdnlO4pUwgebq7Nk4IpKYAAhQNCGk0wUKSnISco9E3eOt
         JHlQ2DC48+CnhzAtuQHQtqPMEV+utbeCTXkI3SJCQd2hta8TE1KJXNVYUc5YF+kGXhZn
         qaU4SYp0jNG4CAPhpimou64bssPuu0K5oo0bdzAKZYhngkMGPE3iJriXYbT0Ntc78gwZ
         VUI93fm0dXxRiaB6NuwUob/16UvUtndup4Poben0NytJcL5GJmJ5GsqdYiVr0cJO0odE
         jMl0z1m8jC6Ab8Ot/mMAiJIroN5ISlsCPSuhyDxx24GdCjczywFL1POAsV/mhbEvvBxQ
         IWbA==
X-Gm-Message-State: AOAM531jTWcpk43qTvz24uQ6OFjCT4CF+q5xgEz61ZsG57lomRHaLvIP
        gDJu+bEEp3ljddEvBpPra3w+n6Rwr6SxqI/ZFg0i+g==
X-Google-Smtp-Source: ABdhPJzYzfJFwYCufH8bK8NRCWv1SuQFiY+qsOqtFU/BZeSXCUnjAO1MdZxCpsL1DmC50lN2TLu2SeWLuOZ9wYTnJKI=
X-Received: by 2002:a05:6e02:de6:: with SMTP id m6mr11915866ilj.296.1592936944587;
 Tue, 23 Jun 2020 11:29:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200623084132.36213-1-namit@vmware.com>
In-Reply-To: <20200623084132.36213-1-namit@vmware.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 23 Jun 2020 11:28:53 -0700
Message-ID: <CALMp9eRf8=F02bB-XBKRrONER8GUi10P4ANZVXMxXzvse38j0Q@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Initialize segment selectors
To:     Nadav Amit <namit@vmware.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 23, 2020 at 1:44 AM Nadav Amit <namit@vmware.com> wrote:
>
> Currently, the BSP's segment selectors are not initialized in 32-bit
> (cstart.S). As a result the tests implicitly rely on the segment
> selector values that are set by the BIOS. If this assumption is not
> kept, the task-switch test fails.
>
> Fix it by initializing them.
>
> Signed-off-by: Nadav Amit <namit@vmware.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
