Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81AB436AAED
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 05:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhDZDDN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 25 Apr 2021 23:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhDZDDL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 25 Apr 2021 23:03:11 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B532AC061574;
        Sun, 25 Apr 2021 20:02:30 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id v6so27355415oiv.3;
        Sun, 25 Apr 2021 20:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4xPUGZimDzNyY7GGh6V9V3dfSgDQQTvrLy245+n3qqE=;
        b=lUEBP+gSyEWrtjrL81MzStFV99XkFqJRmIMg8NNphYiGZMcXrcWOpSo3/szyGzDefK
         OrK0i+/Cfa1UHoA9NZiQQZkdyromvBdmGy3DI7+79pqoc6qXK26FwtTEkS/rX3Gw9/od
         cfYvLAErx/rs7XzvKrrGWanvo+gY/HTS71I/xX2wC+jBsRgbwab2S8i6ZXd/FKDqgwLa
         ZVSeQqWmkHRCd8JHXsvX+zdI8slqp1p1ybLbwBLgBpWY+qhZKIhCQ26ACc7jtTn8V7cR
         zWIyAUceGMAidNXquDsVrarpQjJNJReU4eAf+H2G0DRYdhL57GpM+CUPCMBHRM1t6zKQ
         itow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4xPUGZimDzNyY7GGh6V9V3dfSgDQQTvrLy245+n3qqE=;
        b=KVBSqSR5ja29JeOyaRhFE6TNURBlXcIoZSnxUkZVjpY+UQZYWxg6PNMm6mLFPq+6gE
         TLMxvZqElhy+SM1d9YkaAQzess9U7oMBG5qyklY0xsXW4AZYikFqlz3kalbsP+j1p5m6
         Ijp43t1TWNumpcWrEd0YgHcZj8c/0fSqXef7ZFEoubA91fNJM477ISR6Zwb09iwfRNOJ
         IJc+P6bQYv5f0wZ09F/dSQQEmQLqO0T6Xgb5KpYWflYvr+D66qVXayi2SDwfBvCVzc9a
         dlS2rCbyGmyY6FFhUJK28dk3ugII1Y52tDjcTV0Vt7bS1rxsy1Os97P8+y8GN1ipgpvo
         lRKw==
X-Gm-Message-State: AOAM531tFFWYteV+vEeZ/iAN+59Y0oKoYwahGg1FaZM66fkSVbZsNgph
        SllOXUOofjdzr1sV+qf/xX7/gqXHnSYJAuOHWoM=
X-Google-Smtp-Source: ABdhPJxRuv/1tGMRar3jx3XrNhXpMdL06sFnMVPMDkxTPwhdgRglyCvo15dnePO5mq3VZTHLsBWoOdrCu3P8Uj3yETI=
X-Received: by 2002:aca:bb09:: with SMTP id l9mr10617660oif.33.1619406150187;
 Sun, 25 Apr 2021 20:02:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210421150831.60133-1-kentaishiguro@sslab.ics.keio.ac.jp>
 <YIBQmMih1sNb5/rg@google.com> <CANRm+CxMf=kwDRQE-BNbhgCARuV3fuKpDbEV2oWTeKuGhUYd+w@mail.gmail.com>
 <CAOOWTGJvFB_hgSUzaqNaNigdkRXFcaK37F9V7kmL3nCG+bFz5Q@mail.gmail.com>
In-Reply-To: <CAOOWTGJvFB_hgSUzaqNaNigdkRXFcaK37F9V7kmL3nCG+bFz5Q@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 26 Apr 2021 11:02:19 +0800
Message-ID: <CANRm+CzoS=HhiHg6w6dy8P+r3POeP3uMZqFvJr4oHMa1aNJqxg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] Mitigating Excessive Pause-Loop Exiting in
 VM-Agnostic KVM
To:     Kenta Ishiguro <kentaishiguro@sslab.ics.keio.ac.jp>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pierre-Louis Aublin <pl@sslab.ics.keio.ac.jp>,
        =?UTF-8?B?5rKz6YeO5YGl5LqM?= <kono@sslab.ics.keio.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 26 Apr 2021 at 10:56, Kenta Ishiguro
<kentaishiguro@sslab.ics.keio.ac.jp> wrote:
>
> Dear all,
>
> Thank you for the insightful feedback.
>
> Does Sean's suggested version of Wanpeng's patch mark a running vCPU as an IPI
> receiver? If it's right, I think the candidate set of vCPUs for boost is
> slightly different between using kvm_arch_interrupt_delivery and using boolean
> ipi_received. In the version of using boolean ipi_received, vCPUs which
> receive IPI while running are also candidates for a boost.
> However, they likely have already responded to their IPI before they exit.

             if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
+                !READ_ONCE(vcpu->ipi_received) &&

There is a vcpu->preempted checking here.

    Wanpeng
