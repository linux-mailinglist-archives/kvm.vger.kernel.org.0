Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7052231709
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 03:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731034AbgG2BAf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 21:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729867AbgG2BAf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jul 2020 21:00:35 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4690C061794;
        Tue, 28 Jul 2020 18:00:34 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id s144so9355860oie.3;
        Tue, 28 Jul 2020 18:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JEhRoCG/lU8vWInqRMMLeNwglqgQ2Y0GNTOKaudATQY=;
        b=mZiqc0JDiQd0utiAotGRCqhWVhmGENNGKibl4o6mA0ZcZIh3vES80oGDaeiifU3nIj
         aHjPz2s4b1HQ3pir663dSykzgBJOL2Mo3Kg5X3sMY2aC1dpie6aBKg/MwfpKlOp7kohi
         YDTMTXh+KqhY0YQlQrcH0Ae/ETipl53oLxq6S9Imr9LW2Ded8MLHgzMv5/+ZBoagZSv6
         3p13ohlK0wHL6MIkLg1D/2vHtPfSARjp1yAMjZafPyG5U+oMWtaAwrSy9Ntj1fRdTsTh
         YXaHSl/SOHGs2ywZAvgK8A90ysn/HBMvCQKyHdIbjUmiHU9wKGP+cVzxLTvBTFTp2brD
         5pJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JEhRoCG/lU8vWInqRMMLeNwglqgQ2Y0GNTOKaudATQY=;
        b=Q5GILY+oGnEB84mgl7kTeMKosE6Oj9/Ci//AECCVo6gDlaC0g9x6Jy0Qx28S14XLRW
         t/Th9v5Q02JgFTOA2S1EHIysmK5IjKA1qAYp2GqkSkY0/4mI74dimd0ewlX4KH9xDbDF
         3b/z2JtghY2UaNi09IOYDDjKONJrCQ3dVPsiEWvZwh3I7M6GVnG2av4Q8VAGWyiliI2E
         Jre/cT9rMgnhvuMTnnpwFqIz35ehvpUZie8g/y5JwjNDx8KnXNRjNO1OnRv5IKQUskle
         j0B5eJfcfuzxjpobNjEZBUd44B8NzMCaMMm/uiSsyxiypC+3en7DcpgaR9hvi2c6Flia
         ff8Q==
X-Gm-Message-State: AOAM5328EUscnGd+OdCYr/ZLZ98KMHTK15RSKIf4jtfnd1epkVkH0UVD
        G4o+ODe6tuS4846NFaQwZoLtdaEaMY/OwYaXa5Y=
X-Google-Smtp-Source: ABdhPJxWiV+84QJPgzngtJ4MAvLN1Yz/zUFEzfrUSVeUkCplsdRKVw/5aYHM0fGz2cuRgFgHt6mxOMS342usxvkB3ZQ=
X-Received: by 2002:aca:5594:: with SMTP id j142mr5781232oib.33.1595984434290;
 Tue, 28 Jul 2020 18:00:34 -0700 (PDT)
MIME-Version: 1.0
References: <ece36eb1-253a-8ec6-c183-309c10bb35d5@redhat.com>
In-Reply-To: <ece36eb1-253a-8ec6-c183-309c10bb35d5@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 29 Jul 2020 09:00:22 +0800
Message-ID: <CANRm+Cywhi1p5gYLfG=JcyTdYuWK+9bGqF6HD-LiBJM9Q5ykNQ@mail.gmail.com>
Subject: Re: WARNING: suspicious RCU usage - while installing a VM on a CPU
 listed under nohz_full
To:     Nitesh Narayan Lal <nitesh@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        "frederic@kernel.org" <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Juri Lelli <juri.lelli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Jul 2020 at 22:40, Nitesh Narayan Lal <nitesh@redhat.com> wrote:
>
> Hi,
>
> I have recently come across an RCU trace with the 5.8-rc7 kernel that has the
> debug configs enabled while installing a VM on a CPU that is listed under
> nohz_full.
>
> Based on some of the initial debugging, my impression is that the issue is
> triggered because of the fastpath that is meant to optimize the writes to x2APIC
> ICR that eventually leads to a virtual IPI in fixed delivery mode, is getting
> invoked from the quiescent state.

I still can reproduce this after removing the ipi/timer fastpath
codes, anyway, I will have a look.
