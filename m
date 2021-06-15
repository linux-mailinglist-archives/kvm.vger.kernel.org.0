Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087AA3A8BD7
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 00:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhFOW2u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 18:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbhFOW2t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Jun 2021 18:28:49 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55770C061574
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 15:26:43 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id l15-20020a05683016cfb02903fca0eacd15so491659otr.7
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 15:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FsiIJ6gH+cU3t60sFGR1DbzvdELnSg+yPMk5670wQXo=;
        b=Q0ofkRTFT3ZDOnLZVY81r3O4q6S/NA+MJPZJyS+9u2Wmk/gMwjefLFQD9jzG1+EAWG
         ASYilro20kQ3DTU+4XhNFViaqKSfYHL3FXGLFRx251gh3kWGW6BXVsOXavgVUpCt5gLR
         5O9czH5I8/sb0SEohtAVK4oUTERJ3TRpyPuO/SezbrnelMyRJIqagkavgRo3ir1SoqUq
         CmFcQkffAZfuWktrzyof5vcrUN7Br7c8Z4FgERElv36W1u3VzvTgAHCzzAldcmp93pwl
         Or3pN7A5ispeSPdvHYooDwj4ifekDi2EUOwE3dR2GWqU+owXzqzqmh+FIGBpMWhhlfla
         PgdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FsiIJ6gH+cU3t60sFGR1DbzvdELnSg+yPMk5670wQXo=;
        b=cg7oQsuM0kTCRVfnyuGj3Y+UoigQ1lRhUSRvdRwfLObpFOkIv8V1ntdQW2wgXGk2FG
         425TqP1+oMr/q/tP07OylmTXdoMvlF4fK1HkioswiSiu6YSujVzD93dkSZ4+WNQdvSAD
         zMyTrQhjBjT729l8dRkhrXn44XdnVg3F2+IQJAJlkdP43JXm00q2T/maFtGT4W0CCaZy
         UEwKsviI0wZkTdTK5EGkczMi6lpzH8q+p8nIAJ2e8WzAKl1odjKY5oUgfaC8PaEcKYyJ
         gwn6Fv+jrXQkaax1R7YyairTDe+o8xOSqWzHTuFpJYoT1N98NI8+rbUgr8cUpuwxA1td
         Kwbg==
X-Gm-Message-State: AOAM533yAiNWUaBwgSgYbqUaL3MuMpA66ODAuLsiLyxVozX9SJU5bM24
        wWSampkqkTIr04XESpXwSfDWC0yadAkYwwjP/NQTJg==
X-Google-Smtp-Source: ABdhPJxjzOP1d/z0YZzl/rWoWGhPgD57DFtqJMJ9o7bNgqRLegLC4LRLdyYe7A4Hx7rgPx1ytOs2uhlPmRKSDxHtpZs=
X-Received: by 2002:a05:6830:2011:: with SMTP id e17mr1143000otp.295.1623796002490;
 Tue, 15 Jun 2021 15:26:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210615164535.2146172-1-seanjc@google.com> <20210615164535.2146172-2-seanjc@google.com>
In-Reply-To: <20210615164535.2146172-2-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 15 Jun 2021 15:26:31 -0700
Message-ID: <CALMp9eR8mos-HrkBO_hdbH6YmEKfFHAzYtRzhfGaq8hEwM-LVg@mail.gmail.com>
Subject: Re: [PATCH 1/4] KVM: VMX: Refuse to load kvm_intel if EPT and NX are disabled
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
> Refuse to load KVM if NX support is not available and EPT is not enabled.
> Shadow paging has assumed NX support since commit 9167ab799362 ("KVM:
> vmx, svm: always run with EFER.NXE=1 when shadow paging is active"), so
> for all intents and purposes this has been a de facto requirement for
> over a year.
>
> Do not require NX support if EPT is enabled purely because Intel CPUs let
> firmware disable NX support via MSR_IA32_MISC_ENABLES.  If not for that,
> VMX (and KVM as a whole) could require NX support with minimal risk to
> breaking userspace.
>
> Fixes: 9167ab799362 ("KVM: vmx, svm: always run with EFER.NXE=1 when shadow paging is active")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
