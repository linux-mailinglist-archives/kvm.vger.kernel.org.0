Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE78F27DA54
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 23:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbgI2Vmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 17:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727922AbgI2Vmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Sep 2020 17:42:35 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFE7C061755
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 14:42:33 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id a2so5944195otr.11
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 14:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eMTnP36m1E+SZKGnieI0HqsItuKWPP95HDOa71tExHY=;
        b=sqTAEiApfwK6y3dBXrTBGDsRMlig/5xp1blX9IQ1P9kPMe9P4XPvEmmiuFpI904VBK
         EepRFdv1GLma0uBXS2VxsusDvYSf3+zz5PorEPpzKL62RY9uNsUSgeEXBGhHy7BqB1JS
         rfJp+5szSw+GbzHbv9r/GHUtkSU346hnvdClgtCWjibRoqxArZg7yrb1mbw9Wh4s96vO
         rPxCeWVoowsc1/baJQK4cdWayZC64thgRiD434vEglVOgAKZRDUc/4r3WBPrAxZTBXjP
         aqtD8bnCHDfNMYGomCAJh3XibWqjMrRRNKGgKUbvCuRX5yQtr5fGqdeZM4I+yJGhSAtB
         wh+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eMTnP36m1E+SZKGnieI0HqsItuKWPP95HDOa71tExHY=;
        b=oxyz8LlMaywrjea0q45RUxO6/LIW9OLk8oUORHD8QSNx53kC+l+MJmZIDzjH0eG0Tv
         qi0yldtX1iGiuabv8EWS1taP6gBcYnna8xF0giGfxqLLT9SgnrY+2RgS0IV7cIePllUm
         lKGDofr+LKaXTnWmMcj4CPIqhuOzr3+OaiwDMc78omfcBihDBkzaiw6/DB+cah68UsQh
         jHK90cxH7rjUgFiSDloow29xTpjgBOjSQRfPg7maOvxWI4NRBuzQY3nMKl7T/cs/IzGM
         DiK9/T6jpch5oH2vaw3D4PzLWI30Ak0xI88MU/5/D2qCv4FLg0UQiKs7RjmTVy13VnW3
         5nSw==
X-Gm-Message-State: AOAM532KF4KfTPh9YD+CWZnEX6ZVSMuMRLtE24jJuyS+0RzyKQqMDVXh
        hhnSQceRRLaNTlTxdRbcTvVIi6SyTGqAF2UtIXvBzg==
X-Google-Smtp-Source: ABdhPJx8g4PsvrZ04THmOIZA5Pfv4k842ratMKMN/KX4T+3kFTxK7lR0xZLye4gsjw3mMz0xteoREAsuMU6FHRnds38=
X-Received: by 2002:a05:6830:164e:: with SMTP id h14mr4048466otr.56.1601415752426;
 Tue, 29 Sep 2020 14:42:32 -0700 (PDT)
MIME-Version: 1.0
References: <1599731444-3525-1-git-send-email-wanpengli@tencent.com> <1599731444-3525-5-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1599731444-3525-5-git-send-email-wanpengli@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 29 Sep 2020 14:42:21 -0700
Message-ID: <CALMp9eRpo0pJ3sO-xGoEZf7ktWb07BvNoDJyaH0pQkE5EY_Yaw@mail.gmail.com>
Subject: Re: [PATCH v2 4/9] KVM: VMX: Don't freeze guest when event delivery
 causes an APIC-access exit
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 10, 2020 at 2:51 AM Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> According to SDM 27.2.4, Event delivery causes an APIC-access VM exit.
> Don't report internal error and freeze guest when event delivery causes
> an APIC-access exit, it is handleable and the event will be re-injected
> during the next vmentry.
>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>

I'm curious if you have a test case for this.
