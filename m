Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F6423277F
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 00:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgG2WRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 18:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgG2WRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 18:17:54 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262A9C061794
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 15:17:54 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id l17so26221171iok.7
        for <kvm@vger.kernel.org>; Wed, 29 Jul 2020 15:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pBUbpHMrOzLkTRO1VgnWvJTXTiC0psLpW17xVwkMvZk=;
        b=HjswJK9z3OCMr3E84OQrrTlnUI+in5Bf7kAqFPkDWECbZpo+b5Rw9dDWCE6DvaQg3W
         3TNRWRWu/422ORMp15P/yzlWaMc3d4wSEZdSwasGlVZDvOpLJ6Y5/jSJUaNgm9/DAQMw
         lQ8Tp/y64LPWZsXwn8Lf54v3lJ/ck5BU4ojJ3IH377iKtEeBZc+WOT70LAfpaHgdm5yY
         2RioRkZqcdrQrtz2AcIOAwO21XLC1vO05P/GiW/vc3ERcNjBfZVRiqIYfqQvydD8gmdt
         SCHY8tVID4+C9rVoEETryRqeKlSYZKMbWMyHPkmxddJLtpDu+GeEStffJUWFmDIra9l6
         C9Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pBUbpHMrOzLkTRO1VgnWvJTXTiC0psLpW17xVwkMvZk=;
        b=ponqgz+zhhWJ7XiZp+/2UrgJbzrH4IbzdaUWJqQxJaK0abHgiP0ehFh4a9u6lccqzP
         B/GpGdXhkuW5ZW5Vc7z2z1elnv1XMhXaYfeX8PVDLqbc+rbERsGG/X22oGgN9av0Rqtt
         GoWgOF3JbMmXo8O7zov8pvtmioUSjvVrzK2eb9MFPgTZVRaM4Zapk+yInvRm8qvJK5zY
         iY6jPOZqz/QWXTUP6sFwJceSe2XWnEINIjtYSvTa+fhp/++oika8mHnDBRsxPhjWHPSg
         DXgSwlL+WvrdLXM5eQeiLc+fGMQXhYEB4WU+rGA7bskPWfef9d6sc1F+JYI/YE+Ak/5m
         fLKg==
X-Gm-Message-State: AOAM530YD+nY+qDCMG47VHu4Z099vTqvjoQC6QYU8+TcQc25U1f7dLp+
        7BIGSpQXCyG1/phPeVEoquIJaCoH7B37CTcbY0jibg==
X-Google-Smtp-Source: ABdhPJxe6ROlG1A5mJ7AYQwm7PIFzAKasC8m2xiJlm4UqwYsToWY9DPIQf9/kQ6A+YxE02236Ql5MvlXPzwBucSkncY=
X-Received: by 2002:a6b:b4d1:: with SMTP id d200mr33823109iof.70.1596061073142;
 Wed, 29 Jul 2020 15:17:53 -0700 (PDT)
MIME-Version: 1.0
References: <159597929496.12744.14654593948763926416.stgit@bmoger-ubuntu> <159597952647.12744.15718760666138643079.stgit@bmoger-ubuntu>
In-Reply-To: <159597952647.12744.15718760666138643079.stgit@bmoger-ubuntu>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 29 Jul 2020 15:17:41 -0700
Message-ID: <CALMp9eQtvodpmE07DkQBu+zqE8yvrigw4N6dMQQoiEetRPFA_Q@mail.gmail.com>
Subject: Re: [PATCH v3 09/11] KVM: SVM: Remove set_exception_intercept and clr_exception_intercept
To:     Babu Moger <babu.moger@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 28, 2020 at 4:38 PM Babu Moger <babu.moger@amd.com> wrote:
>
> Remove set_exception_intercept and clr_exception_intercept.
> Replace with generic set_intercept and clr_intercept for these calls.
>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
