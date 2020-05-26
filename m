Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65A6B1E1FF0
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 12:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731977AbgEZKlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 06:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731859AbgEZKlL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 06:41:11 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A90EC03E97E;
        Tue, 26 May 2020 03:41:11 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id a25so12222493ljp.3;
        Tue, 26 May 2020 03:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Ry+3smoc7mCp1uPcR5k/a7m1osHOU0G7CR8vXULZZQ=;
        b=lOW+HXgzYB42cF/rhFtPrEV1DPp3z0Hcimy87m4EshA1FPzBMHRZg6ifPlxDGpwLaJ
         t7NhZQD7jdSFRRWTIyGXaX4Btb+hsajfJrvgP9QoRe7M5a+jXAIkXcBIOVET15jEprXK
         G94dJhAcGm88QDcosU8LybxInn1bd/YqidEIJR14HDh38uR5ntX/2G4oVZsCuoJI0S+o
         KHsPbh3IgWU23MyKcZFTmovaqJ5PxxaqzbB9nRsPyW5kFTi0b4OtGvpQV+1i8hAjyqeK
         0FyAdNRsuRZddDzsMTJ/Wo8zXD0RGt7SnppeeWspYbVceFkHJrF+89zayNmzIPXEuePH
         +wIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Ry+3smoc7mCp1uPcR5k/a7m1osHOU0G7CR8vXULZZQ=;
        b=NKTHa7gifOETxSdybcBq/yO8qOfT67ce8k45JM6BHb00OuvKeegKouNPtSJYBj+oxk
         HRBDCA1wbf0DwdmqLkw2rmniwl4FXkwrXpEW213vzNrHqcMnxP9d0dqqafJ8hFUscBtH
         3w1DrJYWspKRRmRVWXb9lEz3G4bGFapKGngcqFETe17UNH19EfGYgwq4/ALKkWMtiDwj
         YTySFJFMgqtk86XtiZa+hbUEu68VslB5mlXryu8axrX18ouNo+YXtT/y5kB9OfG4d7mX
         Fea7PV1HTWFoYSj6jlEz4MI2Z9gnQar0On/vB6E0Diu6VKnM+DyLEVxIJSy0EmFCzWy+
         40Xg==
X-Gm-Message-State: AOAM5317byTi+SW2AF8aJY9DlqHu5oEKW17kO8NFzBkp5oKVlHOI06to
        4BBrYQLvcYYnT1GSrCtrZItB7/MzcEcLc4660JJ7Q1PK4LI=
X-Google-Smtp-Source: ABdhPJyV5UNPT5wTZ5V1QRzvrkwK25GB+HGrijYwTV+7vkTwPuUSjO+tP4bYBkO+rleoRruyY3jfSDIh+hlPvjCFCSs=
X-Received: by 2002:a2e:9087:: with SMTP id l7mr318222ljg.430.1590489669805;
 Tue, 26 May 2020 03:41:09 -0700 (PDT)
MIME-Version: 1.0
References: <1590396812-31277-1-git-send-email-jrdr.linux@gmail.com> <20200526075904.GE282305@thinks.paulus.ozlabs.org>
In-Reply-To: <20200526075904.GE282305@thinks.paulus.ozlabs.org>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Tue, 26 May 2020 16:10:43 +0530
Message-ID: <CAFqt6zbC4scJypctv-cWZYyq0TJb0OmB0Fq22-L54KVyoTTruw@mail.gmail.com>
Subject: Re: [linux-next PATCH] mm/gup.c: Convert to use get_user_{page|pages}_fast_only()
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, acme@kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        jolsa@redhat.com, namhyung@kernel.org, pbonzini@redhat.com,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Mike Rapoport <rppt@linux.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, msuchanek@suse.de,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>,
        kvm@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        John Hubbard <jhubbard@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 26, 2020 at 1:29 PM Paul Mackerras <paulus@ozlabs.org> wrote:
>
> On Mon, May 25, 2020 at 02:23:32PM +0530, Souptick Joarder wrote:
> > API __get_user_pages_fast() renamed to get_user_pages_fast_only()
> > to align with pin_user_pages_fast_only().
> >
> > As part of this we will get rid of write parameter.
> > Instead caller will pass FOLL_WRITE to get_user_pages_fast_only().
> > This will not change any existing functionality of the API.
> >
> > All the callers are changed to pass FOLL_WRITE.
> >
> > Also introduce get_user_page_fast_only(), and use it in a few
> > places that hard-code nr_pages to 1.
> >
> > Updated the documentation of the API.
> >
> > Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
>
> The arch/powerpc/kvm bits look reasonable.
>
> Reviewed-by: Paul Mackerras <paulus@ozlabs.org>

Thanks Paul. This patch is merged through mm-tree.
https://lore.kernel.org/kvm/1590396812-31277-1-git-send-email-jrdr.linux@gmail.com/
