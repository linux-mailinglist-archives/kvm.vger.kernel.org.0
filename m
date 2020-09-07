Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B28B25F19D
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 04:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgIGCLj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Sep 2020 22:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgIGCLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Sep 2020 22:11:36 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 585BAC061573
        for <kvm@vger.kernel.org>; Sun,  6 Sep 2020 19:11:36 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id h17so10298194otr.1
        for <kvm@vger.kernel.org>; Sun, 06 Sep 2020 19:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HL0k4kMdfvZxDwLf6N4dmzkByACpLy1eRBZOqEBNzqM=;
        b=CF2Xz33tBkHD3aHGNlh3qUuoyRA0nmaktu9SseHoFydfJHr+WFhCJ+faYoHp8rKmw5
         e41nsRSOBABAZ5tqaUxFPC1gSk+Edg0EKTxuSDxA8e73xtV2IkJDrBGDnziSes0fSjI8
         XrKRPiv1b9ZZkgqE3ROlhgNS5Mf45dgUwEG1U02H3vA0o2k3jPKluC8bTit95mpcKMse
         HiyP5hZ0kMk1YxnT5ljOJQKY3HgnY0f5DUu2xvfxy2MLMYQ8rNV/Fir0gOcVSb05fpVT
         48vFvGdpUGV/CccL7MMIvZ8L6Q0AUC09Bgt7QU+DIHhG4OwPa2B6ffDtdapTTtmkCyKB
         xMNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HL0k4kMdfvZxDwLf6N4dmzkByACpLy1eRBZOqEBNzqM=;
        b=HHIjueuYBVuKxy/JQNxWvCI9moMlF98vtUMATqOMh/AZBI/IpVgpdjRuqBYCTrWZqa
         cB4CNxdBGd4RzKophXed5pH562NjQNrztzKFx5BzrtPW5RKFrOsJXozeEKuknVKaBAKA
         pXqGyYnPwPjHRU1BNjtzzGbvNuxA4TKrKsAaBAqI0BO8ezp0Xm5WXKYJmKH9AW4sF6GT
         w9OjLRo5JkYVZWK/xkNOvwPzFmK4U6nVZkF/PrfQkSEurva6h+cnXNX+xM15MtyXH+g1
         5o5pVOtFuOOQINFDJNV9B4jJLu6HgEqL4djU/YJvD0P9IJd49F85ux6+Rn729HcOVHpt
         yhdg==
X-Gm-Message-State: AOAM530lxOsV0tmW45Xk4ubYDI/loTg8hEWpXqzqKX5cVrp2b1ZCPSJ/
        Dq8jN+T7gvKne0BqHBPnIbSzJQI4JFcwIp5uxzk=
X-Google-Smtp-Source: ABdhPJzNqGyj7ASP3iKZY3WltImqNC/S09BkwPcOj0mH62IJhCbbbXcgr1jzVsl6GgtIxcvE3k95FM8Z+gxbMu5Dxuw=
X-Received: by 2002:a05:6830:10c4:: with SMTP id z4mr9070440oto.254.1599444695710;
 Sun, 06 Sep 2020 19:11:35 -0700 (PDT)
MIME-Version: 1.0
References: <0C23CC2D-B770-43D0-8215-20CE591F2E8F@bytedance.com>
In-Reply-To: <0C23CC2D-B770-43D0-8215-20CE591F2E8F@bytedance.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 7 Sep 2020 10:11:24 +0800
Message-ID: <CANRm+CwOqy-peT45u7QQ6QpQOttgVKGTzSJhbBA64bc_CdratA@mail.gmail.com>
Subject: Re: [RFC] KVM: X86: implement Passthrough IPI
To:     =?UTF-8?B?6YKT5qGl?= <dengqiao.joey@bytedance.com>
Cc:     kvm <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Yang Zhang <yang.zhang.wz@gmail.com>, zhouyibo@bytedance.com,
        zhanghaozhong@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 5 Sep 2020 at 20:22, =E9=82=93=E6=A1=A5 <dengqiao.joey@bytedance.co=
m> wrote:
>
> This patch paravirtualize the IPI sending process in guest by exposing
> posted interrupt capability to guest directly . Since there is no VM Exit
> and VM Entry when sending IPI, the overhead is therefore reduced.
>
> The basic idea is that:
> Exposing the PI_DESC  and msr.icr to guest. When sending a IPI, set
> the PIR of destination VCPU=E2=80=99s PI_DESC from guest directly and wri=
te
> the ICR with notification vector and destination PCPU which are got
> from hypervisor.
>
> This mechanism only handle the normal IPI. For SIPI/NMI/INIT, still
> goes to legacy way but which write a new msr instead msr.icr.
>
> The cost is reduced from 7k cycles to 2k cycles, which is 1500 cycles
> on the host.
>
> However it may increase the risk in the system since the guest could
> decide to send IPI to any processor.
>
> This patch is based on Linux-5.0 and we can rebase it on latest tree if t=
he idea
> is accepted. We will introduce this idea at KVM Forum 2020.

Hmm, this idea is not new,
https://dl.acm.org/doi/abs/10.1145/3381052.3381317 Anyway, it is more
suitable to be played in the private cloud for my security concern.

    Wanpeng
