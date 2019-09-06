Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 996CCABED1
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 19:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395212AbfIFRdz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 13:33:55 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:43260 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbfIFRdy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 13:33:54 -0400
Received: by mail-oi1-f194.google.com with SMTP id t84so5604681oih.10
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2019 10:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qpDnR/GYJ/XrBLmzSIYUWPDpRlqXVwU8hq/PPEapHXQ=;
        b=B5lMPpGHxIofgZL10Pn92uDG8MnE3nHQtXDzubuDNUxCRt56k31Zr5/4pBbkv4ywfp
         k2B9yLhvs+CQZolGYvrtvi/f3xzxDtXhUuaaFUh5Dvv21CfjE/LNyLRZb+x7i5PmiS1D
         ZIUPTbM+K/3hH0G5jF0Ehvp/Yz/ZSAz34z7I9miMnRsfe9zcMJiYCJBadW8maOBNVufF
         LcFtXZOm1s1HhJLXNF5PKER+f1vQe8CZv1SdFAlPsTrPBHjyL4m5sSnEEtuWzr+dME/d
         yPglC9Vp78a/MAqamkHBU5HxSM1bZk6G1BF35zRlxhELkYuQGhMHkWrK/kqOJOKhXYXT
         WCAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qpDnR/GYJ/XrBLmzSIYUWPDpRlqXVwU8hq/PPEapHXQ=;
        b=Dffwm2/fTF02J4Oua+9EVllHU6Wngep/uz3aE4Ml/Ep+1irCpWkN4VCyqBVYdTZFiq
         CadTsF0TQf5FcTys9nSUqaaAl6u0zKJjpN0Nsb2gnul1GO/i7PcTzn/Uv3FJ9AbK8oj6
         2dmCyFIiC6E/uqa9ZR6t2YtnPFHqGn/2/+wqyMLUQVsqFl4LcXNFy8TaJxx2FMUFN7CA
         IAZRzMDkF3qCj8z8gdwkjdKLpH1W89znMe3JgFKrBb32nXzFrpH0TkwhKIUUc1l5jIqp
         miSSfJcFUrLbOUFtVMlgUtWO8Z1GruV+9J1DQSb9Kqrha1IwMSNVxeoVdFRk1eMlUgeR
         Mx7A==
X-Gm-Message-State: APjAAAV5OAm2zkYx69YaRs29NYmNq2E8U8xqk5cIpFUKiU/9pTqyVeP8
        kIBCn0GanN6ElyOQ2ZH43n+iTCGBv14S7nkiI6J6BQ==
X-Google-Smtp-Source: APXvYqxs26WaI4nMH81FCrmErnLZVB0v+f8/lt+3MTncxWG87yVQW0BSOxASyAFc+69JKSrfI3WlFVqe6CUueDct1rs=
X-Received: by 2002:aca:5dc3:: with SMTP id r186mr7672240oib.73.1567791233988;
 Fri, 06 Sep 2019 10:33:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190906145213.32552.30160.stgit@localhost.localdomain> <20190906145327.32552.39455.stgit@localhost.localdomain>
In-Reply-To: <20190906145327.32552.39455.stgit@localhost.localdomain>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 6 Sep 2019 10:33:42 -0700
Message-ID: <CAPcyv4i_LPrYvenhzcM_Ji6nviZWHqTDWQDDusv5pCXv0Bi7QA@mail.gmail.com>
Subject: Re: [PATCH v8 1/7] mm: Add per-cpu logic to page shuffling
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     nitesh@redhat.com, KVM list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        virtio-dev@lists.oasis-open.org,
        Oscar Salvador <osalvador@suse.de>, yang.zhang.wz@gmail.com,
        Pankaj Gupta <pagupta@redhat.com>,
        Rik van Riel <riel@surriel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        lcapitulino@redhat.com, "Wang, Wei W" <wei.w.wang@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 6, 2019 at 7:53 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>
> Change the logic used to generate randomness in the suffle path so that we
> can avoid cache line bouncing. The previous logic was sharing the offset
> and entropy word between all CPUs. As such this can result in cache line
> bouncing and will ultimately hurt performance when enabled.
>
> To resolve this I have moved to a per-cpu logic for maintaining a unsigned
> long containing some amount of bits, and an offset value for which bit we
> can use for entropy with each call.
>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
