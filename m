Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 186C1372F36
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 19:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhEDRvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 13:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbhEDRvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 13:51:18 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F6EC06174A
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 10:50:22 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id l6so9598901oii.1
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 10:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DCkRHCN61kfizqWJXP1PWNpclqjzIE2ZjByqn8qit3M=;
        b=TJ5hcE62aB70t3wRgov2kIHjvIshRaIKwKhsS6AKdPP57RDYO/z30LoU/rF67pU0XU
         IX8UJLBud9zuRfHTIlVO/nC7FH2uePijzicdHzldgmLPR59XrR5NnW8i/dr6td/UiKEe
         +2l5dD8yXCQ14uQwkasfUugjgt3fHHCqDtcmA4+c0Nx9+AsX+DWmpKYLE7ndkYCluTGP
         Ff/X1Cz7eEwgxJONcOl06k3gXPXPGY3nmZXgc4RpwISc5vPk4pewq0R4oddwgpc43Kxu
         igyvApR6auWvoSXDFL3RbIDTX4Q1sGlY/YD01BsPMY3+n+ohgtbTvxm91vcssZbXIWUP
         Fi5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DCkRHCN61kfizqWJXP1PWNpclqjzIE2ZjByqn8qit3M=;
        b=GZq9arXkBn1IJfdFTB0eiKmRspIIx/pk1K2Man3RsbcSagQ+0Q49ujYT0FteKgAXe7
         UiEcr/PeL4GLGV16EpniUu7/IbA5NuH7dAbSt1ftk4JDnMXQnn0wRT2B8pqkVt3/VYDq
         xHY9XuEwUtVSGxPs/gZwFR7FGFCcOQo1tN0T82SzqavekJNW8MdQZspWY12zDM8IHtFJ
         QQtHKNdU+N2f5l3QWKpGZdAN6PfXbwYHkwDaWqh/NGm7uPiYdjoIvaXk66lxAsjbrpT1
         XxuwKl2YdHPOgJjxiwgmT/pXZLjHQEbxOurvKc6wDjSCQo8Xv9xticaJ4xilLA4T8XU3
         bGtA==
X-Gm-Message-State: AOAM532npLGZhTbJ5gmMOxXYtiLyGKwUH8jEGXwZxRPMLPYYHf9XBog5
        IpVfz7Yj7XfkTTLjPOxvKg4/szzbRtKR49G8fVAnPw==
X-Google-Smtp-Source: ABdhPJzF70u/lwIhgpkw/qWojuBy7ba9HmvvzYL4q9yPwPYvQ7BSZD6+KuS92/zihXTjnwbz8wZQPTVc2liKABG/L08=
X-Received: by 2002:aca:3cd6:: with SMTP id j205mr18533711oia.28.1620150621183;
 Tue, 04 May 2021 10:50:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com> <20210504171734.1434054-3-seanjc@google.com>
In-Reply-To: <20210504171734.1434054-3-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 4 May 2021 10:50:10 -0700
Message-ID: <CALMp9eTqoiiwDdXZQ=MYpaEp-g1z=1SeAqqk6TNU9MFeRJayWQ@mail.gmail.com>
Subject: Re: [PATCH 02/15] KVM: x86: Emulate RDPID only if RDTSCP is supported
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 4, 2021 at 10:17 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Do not advertise emulation support for RDPID if RDTSCP is unsupported.
> RDPID emulation subtly relies on MSR_TSC_AUX to exist in hardware, as
> both vmx_get_msr() and svm_get_msr() will return an error if the MSR is
> unsupported, i.e. ctxt->ops->get_msr() will fail and the emulator will
> inject a #UD.
>
> Note, RDPID emulation also relies on RDTSCP being enabled in the guest,
> but this is a KVM bug and will eventually be fixed.
>
> Fixes: fb6d4d340e05 ("KVM: x86: emulate RDPID")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed by: Jim Mattson <jmattson@google.com>
