Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5912A36CB
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 23:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgKBWyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 17:54:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgKBWyA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 17:54:00 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF98C061A47
        for <kvm@vger.kernel.org>; Mon,  2 Nov 2020 14:54:00 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id t143so4824748oif.10
        for <kvm@vger.kernel.org>; Mon, 02 Nov 2020 14:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gxMXOaWOcX7RWi2XohG/kNHvSy7AhpsjgRQW4jBaDgc=;
        b=P6ng53EdpuHBLplB221LcjZTmll1OcBSb7Gf0ID8ii2ONguufw8ilLp97H3Cgzxq+s
         WaeE7NEBHU8CEqXAQeVIjCGxqBgw+EzNDwnpEiloncZJrkHQ3V/gPqRvyMcVLJXtaFqN
         cEGBZGuow+HoX77Q/NJTmWor7xIJJIy0mTpLHUmGWDCuCxd8mHge6SGZJIbEmtTntV0Z
         tJaFzQrCJ9su2MsqE66AIkQb37McPrsPDjMjpU9Nez+liy0XYHmuvEc7drt3ilOsDTG5
         2neXrfP+P9zYpBmkjez3Es+JgesMX93j8fo8GgKfRIDm3WTI9ziNayKZbsFuap5FOVlH
         ovCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gxMXOaWOcX7RWi2XohG/kNHvSy7AhpsjgRQW4jBaDgc=;
        b=kDJ5l25nXkPP9sMMZQLrFgusGoQWrIqHARC+2HNTJS+GJbge0mLs3h0Pl/uZFJtkDs
         OFK8r14BZ6imIOlPauSmNg5lVJ5uYjshYabzxOottLOiFniri36zdjwzxySArhCVXd4L
         wizXn9ZLQ9eeOn4sxgOlRydvkGxMllZSAlbkqGmwWlpGhyWa6ahxphEOaearZrugk0YR
         LmD6FQI7XZmBcBSzLubRaKO75UJ5mrAOIJvXdZO2GGplvGhjuP737YUC0DZnR6VOaDpz
         HmquqkoGHyXo9EY4xn34gcmfHYOZ4kKijliBW+YnDJ0Udq3VfV6ZttAEhrQiyeXBAN9+
         r0cw==
X-Gm-Message-State: AOAM533Q3eYVBfAIm+IR8nH+HwnLclmfDNbXKJcqvPLiSCcUZnSZXLpF
        t7RmAvuK3L1mUZC5yPEgiaxO+Vv98iR1K7897WQ2/w==
X-Google-Smtp-Source: ABdhPJwiBRkyEJmNyWELvRc7Bv1J3jMYpYigUmhylzmxppC6VnYz3LwIszJXigYZDmgDvhshF0EBhX0xnHRT2G218gw=
X-Received: by 2002:a54:4016:: with SMTP id x22mr283781oie.28.1604357639327;
 Mon, 02 Nov 2020 14:53:59 -0800 (PST)
MIME-Version: 1.0
References: <20201102061445.191638-1-tao3.xu@intel.com>
In-Reply-To: <20201102061445.191638-1-tao3.xu@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 2 Nov 2020 14:53:48 -0800
Message-ID: <CALMp9eTrsz4fq19HXGjfQF3GmsQ7oqGW9GXVnMYXtwnPmJcsOA@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Enable Notify VM exit
To:     Tao Xu <tao3.xu@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Nov 1, 2020 at 10:14 PM Tao Xu <tao3.xu@intel.com> wrote:
>
> There are some cases that malicious virtual machines can cause CPU stuck
> (event windows don't open up), e.g., infinite loop in microcode when
> nested #AC (CVE-2015-5307). No event window obviously means no events,
> e.g. NMIs, SMIs, and IRQs will all be blocked, may cause the related
> hardware CPU can't be used by host or other VM.
>
> To resolve those cases, it can enable a notify VM exit if no
> event window occur in VMX non-root mode for a specified amount of
> time (notify window).
>
> Expose a module param for setting notify window, default setting it to
> the time as 1/10 of periodic tick, and user can set it to 0 to disable
> this feature.
>
> TODO:
> 1. The appropriate value of notify window.
> 2. Another patch to disable interception of #DB and #AC when notify
> VM-Exiting is enabled.
>
> Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Tao Xu <tao3.xu@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>

Do you have test cases?
