Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E303A8BDA
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 00:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhFOWcw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 18:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhFOWcv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 18:32:51 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B00C06175F
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 15:30:45 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id i12-20020a05683033ecb02903346fa0f74dso485921otu.10
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 15:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YZakAu6vDnZNEmPvqktyn2oZMAH5BhmuwRP0pEeDFUA=;
        b=jCY7GJXJiumTS0wWAuQQNTFjKplqBjVFn5buIpNjm5wqI4A+WpuvrapJtp7KIemCr1
         ilDivDkTGRUrU7giBkX6lSYiPmOoc15w01fLye2zsTaDR58bMphtwzZDbHXUBx7i/MHq
         +3fi7VdsRBbVX0BFYKIa0P7EeemGUMbadQ5cpHI2Hs0lGUJyxKeUvGflJr45yWAkGZSb
         BE6S3o63B1gyBCepO8lcFAUu9ZgiZuNZBe8V25Dhu2JJNJPc5LUUXe5IhUQDXIlFLk/p
         VauRSOl5CgYVqMZHQt/w7pgfPfGlMVrxZZPvLm4nAawjrpM0LcDEdwj6Wmg9OIl28zLG
         dYlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YZakAu6vDnZNEmPvqktyn2oZMAH5BhmuwRP0pEeDFUA=;
        b=OSX0P09Q5Ki81MGahhhvXff2jNVOjo050Hil1koIGDW9eP6Rz5F3T01w9TTbPxWcG+
         l8Urf2r66A/VAY10A+mIlh8+p7S5Tn0zEF6fl4VMqH60Wa3ch5tu26QwsGKOZ8SSC4kA
         aAbtpZd0RvWWAN9yqhSKLlZNLw8mY1HywdXZPzMlq4KFfjEDTtpXq4ChHCIydxaLh5PZ
         UTy/E5+8bTQSVHbBbY0sfw2aCBGw3c2+j5PimRNKDtR65WQdlW54vGwYZJwLTfZxx/TA
         dsnn3PWYjidnP2ZcujLRdL1eiVQzug2ok04XfJxGRv8UGFsE5mtZHPBAocUbXCjnwnSo
         zt+Q==
X-Gm-Message-State: AOAM532JdOUnPX3BbA+sIq4o6TzYKP8UntVP7DdCcxMz0a0DyyoOBnT6
        /nY9sbqGzFaNyzcJ3q6s4YD2UyCC6GdgP0l0mG0alw==
X-Google-Smtp-Source: ABdhPJw/Imo0I1H0GN748qZZF4Cxgl5NMwVkBTCnbMJblZ3I/aaEBWHp2gzzrASSJ8HmI4myycopyDKSEeTrK++4s/0=
X-Received: by 2002:a05:6830:124d:: with SMTP id s13mr1175538otp.241.1623796244796;
 Tue, 15 Jun 2021 15:30:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210615164535.2146172-1-seanjc@google.com> <20210615164535.2146172-3-seanjc@google.com>
In-Reply-To: <20210615164535.2146172-3-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 15 Jun 2021 15:30:33 -0700
Message-ID: <CALMp9eRxA0zk9abXp-YwGJwO2QX-EvPfkS=CCCeLKFAcPx7soQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] KVM: SVM: Refuse to load kvm_amd if NX support is not available
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 9:45 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Refuse to load KVM if NX support is not available.  Shadow paging has
> assumed NX support since commit 9167ab799362 ("KVM: vmx, svm: always run
> with EFER.NXE=1 when shadow paging is active"), and NPT has assumed NX
> support since commit b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation").
> While the NX huge pages mitigation should not be enabled by default for
> AMD CPUs, it can be turned on by userspace at will.
>
> Unlike Intel CPUs, AMD does not provide a way for firmware to disable NX
> support, and Linux always sets EFER.NX=1 if it is supported.  Given that
> it's extremely unlikely that a CPU supports NPT but not NX, making NX a
> formal requirement is far simpler than adding requirements to the
> mitigation flow.
>
> Fixes: 9167ab799362 ("KVM: vmx, svm: always run with EFER.NXE=1 when shadow paging is active")
> Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
