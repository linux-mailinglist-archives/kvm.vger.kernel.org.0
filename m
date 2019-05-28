Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D67772CE4E
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 20:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbfE1SOZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 14:14:25 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43907 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727766AbfE1SOZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 14:14:25 -0400
Received: by mail-ed1-f65.google.com with SMTP id w33so29739197edb.10
        for <kvm@vger.kernel.org>; Tue, 28 May 2019 11:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NrgcPgHYGkaYgv7K/Tp1YWUKuygAmk8ZPyKQdnHtMXo=;
        b=T3/gJAXzSCD9ylg1zjwPF62H6wUuPSS2GpBRyhduNWz1LC2jLHVRN93Q4ebs4CfPIM
         ASMkGU8jM3dbdxifPr+cEGlU1N7KgjE8NkNvFIoCq2lviEfWs6ZeYrxrFVLerX7VhKV2
         ChqB6Gr39Cyw+nxO0labgQACSdXhjmnJ36Kw96T2G107InanNTWZMZ78McjRmPgQ9oYJ
         5Nzut0vDWIdfph0sYGa+YGahu/xk88dxzDtSJ+FCGHtWfZKDydFeJOYNxwEHCvbkgfm0
         myOtABdWdGbXHLoksGcwCqDETiW26zmkHEEPkWo+M+k5y7Rph/Azitux+7x5zMrDcVg9
         QXhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NrgcPgHYGkaYgv7K/Tp1YWUKuygAmk8ZPyKQdnHtMXo=;
        b=SKeychWrLnRln1FE/hpfnB+1y7Bztdt60gwUiXGX6QNS2y5Qla2jw0VFY2/v+izPh7
         MHHz4qTqNvHXGmMfTFOaIAvQRYe/UnaTArZwOfsd410EpWuqezEG9XQZZOxEOXLrn2hQ
         uIaYu4mYPhDSxAbSj4NQPqBBQH1Q/IUVN2ZEJt/KE+v6zjsiLC2DzdFp2nRo6MUKguL1
         gz32T3eNJYLXq+cxhAqsVNKAAZ6i3+ZsIvl9cRiqlAdcwTrG6ZIyBHQWlWg/ZQJyw/Jj
         c4jymzMFmxde47SZMKCAu0PN32yfOE3KwPL6aT1ZZgQ9BvlMCFsPBBhAwVCzC+cxb6S9
         ++KA==
X-Gm-Message-State: APjAAAVGwaJuFt1SxWCKUJvXeS1Iw3VMtNZl85tr9TOrLj/sxrwG6eh7
        WRqMLKNmuOScJWJF2zSZBmIi6k98VrNAKcjNbubJcTKoFvQ=
X-Google-Smtp-Source: APXvYqzFgO874P6bYJZYu69xKIPKaNaCUI+QjzjRTExNmXTK3TI/bPou4lz2KNrfLNk12Bh1gl7jLRuPGMvixxUR+mk=
X-Received: by 2002:aa7:c391:: with SMTP id k17mr131122962edq.166.1559067263524;
 Tue, 28 May 2019 11:14:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAOyeoRWfPNmaWY6Lifdkdj3KPPM654vzDO+s3oduEMCJP+Asow@mail.gmail.com>
 <5CEC9667.30100@intel.com>
In-Reply-To: <5CEC9667.30100@intel.com>
From:   Eric Hankland <ehankland@google.com>
Date:   Tue, 28 May 2019 11:14:12 -0700
Message-ID: <CAOyeoRWhfyuuYdguE6Wrzd7GOdow9qRE4MZ4OKkMc5cdhDT53g@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: x86: PMU Whitelist
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 27, 2019 at 6:56 PM Wei Wang <wei.w.wang@intel.com> wrote:
>
> On 05/23/2019 06:23 AM, Eric Hankland wrote:
> > - Add a VCPU ioctl that can control which events the guest can monitor.
> >
> > Signed-off-by: ehankland <ehankland@google.com>
> > ---
> > Some events can provide a guest with information about other guests or the
> > host (e.g. L3 cache stats); providing the capability to restrict access
> > to a "safe" set of events would limit the potential for the PMU to be used
> > in any side channel attacks. This change introduces a new vcpu ioctl that
> > sets an event whitelist. If the guest attempts to program a counter for
> > any unwhitelisted event, the kernel counter won't be created, so any
> > RDPMC/RDMSR will show 0 instances of that event.
>
> The general idea sounds good to me :)
>
> For the implementation, I would have the following suggestions:
>
> 1) Instead of using a whitelist, it would be better to use a blacklist to
> forbid the guest from counting any core level information. So by default,
> kvm maintains a list of those core level events, which are not supported to
> the guest.
>
> The userspace ioctl removes the related events from the blacklist to
> make them usable by the guest.
>
> 2) Use vm ioctl, instead of vcpu ioctl. The blacklist-ed events can be
> VM wide
> (unnecessary to make each CPU to maintain the same copy).
> Accordingly, put the pmu event blacklist into kvm->arch.
>
> 3) Returning 1 when the guest tries to set the evetlsel msr to count an
> event which is on the blacklist.
>
> Best,
> Wei

Thanks for the feedback. I have a couple concerns with a KVM
maintained blacklist. First, I'm worried it will be difficult to keep
such a list up to date and accurate (both coming up with the initial
list since there are so many events, and updating it whenever any new
events are published or vulnerabilities are discovered). Second, users
may want to differentiate between whole-socket and sub-socket VMs
(some events may be fine for the whole-socket case) - keeping a single
blacklist wouldn't allow for this. Let me know what you think. I'll
try implementing the other suggestions.
-Eric
