Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD2893D014
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 17:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387856AbfFKPAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 11:00:22 -0400
Received: from mail-it1-f173.google.com ([209.85.166.173]:33967 "EHLO
        mail-it1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388492AbfFKPAW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 11:00:22 -0400
Received: by mail-it1-f173.google.com with SMTP id k134so2392491ith.1;
        Tue, 11 Jun 2019 08:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zHWTKx49Gq1WGZM8R0zxOjj/6L8rQ+XOzH7iCc71fLE=;
        b=GtnPZ8PcYsev3bUJMl12/qtkurUekBfjoeQRssebXZOd1Vh/pi93n8ri1zQygQkkam
         r8WTW+JTL9BiGEGRAzncEEGlp6DxU+Wf6C2V9i0WKb1evjiRaxPojQAHzyyH12bIRb2t
         Kqu59JOKiBKPoa68P04YsCKCLt8DK68jqC194bjmO9/pYj3rNWjlZ/JvgANl1xHzMRFD
         +AyoM1rc7HhX2brUw+Y+e1zOKJcSibWeh6QvI/zRhKNopr0dvUIYrKDu95u4TumCagdE
         rhyAaksXKga9gX1cvnnYe9+KuF69gvZWgDu4ylj2/conJmU/v9a78ph3waARDlWflKST
         7yZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zHWTKx49Gq1WGZM8R0zxOjj/6L8rQ+XOzH7iCc71fLE=;
        b=Ke55J3ZCuftGF8rQBtcBvMQf2ctc2kADyYRSxAGRlUIIAI94vZTDnZUMcMaETn5RhF
         mrl65xVDSwD+VVvGeziqQLzgeZo/Mm7nFNmfAut387AR2D+6Mvc1Ld/OBiZf4IwA8Vys
         lYyzOp6bIKbgMxOKE79g7qCkgvbRgFMyOXraC0IjtUBsSBGdHMuo/ja2FHYixfFAE8BE
         88Vn/S2180qt/sWLQdh0IjC8C7JmfXUD/Rgc67zfufH92cLq6RirpkqU8HL6+LNP7hvo
         gq4nsUUmKqjnGvpQYcJTDjKKBaWhtts1+YmtlWyu3Jr4qz28ofdN0WVTW+k8wBScA5bs
         RNcQ==
X-Gm-Message-State: APjAAAXucaRCLfYOjUPg7qwJcS+eW7FvxFdjwqqCS7vhtiLO+Y9wkaEg
        IlPmn7EnKK/G7TKfF+0q99iRX/tErIl5aDeB9ts=
X-Google-Smtp-Source: APXvYqz+G5hLirRMGVEg5HuTJI/wTzc5Q/hRbQhchLTgb+mgXtZW3tfRHNTXgv1peMQpp3+2jscWcDy3pmgePdG/+34=
X-Received: by 2002:a24:13d0:: with SMTP id 199mr1095523itz.33.1560265221431;
 Tue, 11 Jun 2019 08:00:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190603170306.49099-1-nitesh@redhat.com> <20190603140304-mutt-send-email-mst@kernel.org>
 <500506fd-7641-c628-533b-7aa178a37f18@redhat.com>
In-Reply-To: <500506fd-7641-c628-533b-7aa178a37f18@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 11 Jun 2019 08:00:10 -0700
Message-ID: <CAKgT0Uem4AJcowHDXPd9yEL8VzA_NciVtWoCiEfsD35q82LF3A@mail.gmail.com>
Subject: Re: [RFC][Patch v10 0/2] mm: Support for page hinting
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Paolo Bonzini <pbonzini@redhat.com>, lcapitulino@redhat.com,
        pagupta@redhat.com, wei.w.wang@intel.com,
        Yang Zhang <yang.zhang.wz@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        David Hildenbrand <david@redhat.com>, dodgen@google.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        dhildenb@redhat.com, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 11, 2019 at 5:19 AM Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
>
> On 6/3/19 2:04 PM, Michael S. Tsirkin wrote:
> > On Mon, Jun 03, 2019 at 01:03:04PM -0400, Nitesh Narayan Lal wrote:
> >> This patch series proposes an efficient mechanism for communicating free memory
> >> from a guest to its hypervisor. It especially enables guests with no page cache
> >> (e.g., nvdimm, virtio-pmem) or with small page caches (e.g., ram > disk) to
> >> rapidly hand back free memory to the hypervisor.
> >> This approach has a minimal impact on the existing core-mm infrastructure.
> > Could you help us compare with Alex's series?
> > What are the main differences?
> Sorry for the late reply, but I haven't been feeling too well during the
> last week.
>
> The main differences are that this series uses a bitmap to track pages
> that should be hinted to the hypervisor, while Alexander's series tracks
> it directly in core-mm. Also in order to prevent duplicate hints
> Alexander's series uses a newly defined page flag whereas I have added
> another argument to __free_one_page.
> For these reasons, Alexander's series is relatively more core-mm
> invasive, while this series is lightweight (e.g., LOC). We'll have to
> see if there are real performance differences.
>
> I'm planning on doing some further investigations/review/testing/...
> once I'm back on track.

BTW one thing I found is that I will likely need to add a new
parameter like you did to __free_one_page as I need to defer setting
the flag until after all of the merges have happened. Otherwise set
the flag on a given page, and then after the merge that page may not
be the one we ultimately add to the free list.

I'll try to have an update with all of my changes ready before the end
of this week.

Thanks.

- Alex
