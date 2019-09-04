Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C092FA9489
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 23:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730546AbfIDVK3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 17:10:29 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37767 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbfIDVK2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 17:10:28 -0400
Received: by mail-ot1-f66.google.com with SMTP id s28so414337otd.4
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2019 14:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wPMWwNSvV9eb5rCu0YMNtiK3/0cR200eFpdZP8tToms=;
        b=cr/2pcTab+KUWoDNVNzO2zJ+8zFyfJbc3u75JTwJU8kJ7gWl3gxzG5ENnPPSyVrSCq
         SuBqAQ8RzhaV2a/HxduSt7ppLV/eWGTtUx/a6wNjIODvqE88o+7S1ZWGc6I6GW/lWSco
         ugSco9IMYbUbbhVhb7LB51QAUisJGNylBc2XTRY+ofuMS4mtW7yB+nBDwcC8Eflg+DIh
         C47efgC6cD78+M5RvB3gTx+JoWSmjAvaaa2GqDhJjsgLFt59c15hiEh1Ur3QDfAToi1y
         ZJezHfiZrelD2BcNYDQu3jmZ72RSuDo/vns5bY+ZuJ10WxhXfVOcTURaAUZLAfLH4A1T
         NulQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wPMWwNSvV9eb5rCu0YMNtiK3/0cR200eFpdZP8tToms=;
        b=V3oeTMgc3FRdFYLnCgDJHQRRusVzbwvBpxtgdtemtFZppgNqw+sRgC8CDI1stUF4Ej
         Ep36w7157nYiLxm5rzijWqYZx0wMISD+zQ5MFkuCKttNjTuxSqCCm3pEx8X5vilMGUG1
         qL+2hmpyq5YpE/z0G+HsqvfGs/ZaakKjoJiyQ9U3ekf0AdUfjklRU/KmI5NllrTdv294
         4GXH4g1+zYYDfA/wtpsw4kQCQNdUfLTcXdWZlo6tWwXPlUtINlgcGySQu6p2VqsAAGP3
         M7h2mGG8YGjSju6AHzvFQWazSVfFVszYahuHOah7PaYU2LQIWPY+1m6UB5dzpzcd6/11
         LUhg==
X-Gm-Message-State: APjAAAUunHlUzFHMTu36uGiqLqhxga2Ch0VcstJoCAH84zoMzj+VYrf5
        6xFYUHoSzRZvmNu70eI0k3Nzhti9qdlUAAyVnPtHvw==
X-Google-Smtp-Source: APXvYqzFh8uueHK+qUmQpwTm/TlKG431AzcbA3p2O6x4cql8knUN37kiD/jGqwHTO7K8qxaIQLqXw5St076KjdfoMnU=
X-Received: by 2002:a9d:6d15:: with SMTP id o21mr9381251otp.363.1567631427871;
 Wed, 04 Sep 2019 14:10:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190904150920.13848.32271.stgit@localhost.localdomain> <20190904151030.13848.25822.stgit@localhost.localdomain>
In-Reply-To: <20190904151030.13848.25822.stgit@localhost.localdomain>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 4 Sep 2019 14:10:17 -0700
Message-ID: <CAPcyv4jZVoztoRA7hEq5xzbwg0QJ+UVASuk5XQmB5KHQrvAmfA@mail.gmail.com>
Subject: Re: [PATCH v7 1/6] mm: Adjust shuffle code to allow for future coalescing
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

On Wed, Sep 4, 2019 at 8:10 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>
> Move the head/tail adding logic out of the shuffle code and into the
> __free_one_page function since ultimately that is where it is really
> needed anyway. By doing this we should be able to reduce the overhead
> and can consolidate all of the list addition bits in one spot.
>
> While changing out the code I also opted to go for a bit more thread safe
> approach to getting the boolean value. This way we can avoid possible cache
> line bouncing of the batched entropy between CPUs.

The original version of this patch just did the movement, but now the
patch also does the percpu optimization. At this point it warrants
being split into a "move" patch and then "rework". Otherwise the bulk
of the patch is not really well described by the patch title. With the
split there's a commit id for each of the performance improvement
claims.

Other than that the percpu logic changes look good to me.
