Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E57336A6B
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 04:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhCKDJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 22:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbhCKDIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 22:08:49 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF27EC061574;
        Wed, 10 Mar 2021 19:08:49 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id j8so185052otc.0;
        Wed, 10 Mar 2021 19:08:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DpjsV6DgfrzVz3csQVFdnTPnpXnXN7Ul8q7EgQp2fS8=;
        b=lkpaktUOCZV9Z1Wq1EhtbYH/keQdx3AoWUQCdEl0daqO+5M4kGCzk6R03k38tjA3oD
         iyfiNcIgrG/pcLs3NiRmUsNzz0wB7UX9OD3G+oQyT5R2a/NVf1irkN8R0qVvMA6SwgGr
         7QTXTX7nGXK4IUgTexfb8t1HoXLZfvmkuSpGUJ5RyCbe0vVgsoS0GFtcwA/C7gxl+epc
         7P05pR6Jgrg1B1mQGKuCZcHgkldQOV3oK4iRiLHqopMmJaG8aOuH0JhRSh7+q98PQ0Xv
         +29nxXk17TErHKroJvBf3jLsMdKVhp4lOCOQ43Jpg2JE+bh/qMkGJuPiXEynU1196X6Z
         Wb/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DpjsV6DgfrzVz3csQVFdnTPnpXnXN7Ul8q7EgQp2fS8=;
        b=n/1C30dJ+l5Las1BOBQ0KFD/u6QFapQLxWjpQt9Zkq0xYVrY2jArKRVBrZfmBwp9H0
         BKjcscOqeV6dU+oyTrOuDWkIHTcwLLycTzQXi2dzip2H1ejo2Pz8lLOCO5HEOgVRcS7M
         SonYcYvRqY5fGjgs+eWla32dBWWhXaZhSAakPg+MYeubVlTf+phnwo+/j/6PUHSZRKdG
         kV9z7oCoaWgi8GD1r9G9+hxWNlb8civnkwWDO+cRkyfO3pbXILRS7wxgDdIsr1BS4Om4
         HXCIAOxXliPaNMU9Okfk2tZtfn/gSYYdUr7O+9UZHD+B26S8X9D2Kh8g68vrr50MzPbt
         38gQ==
X-Gm-Message-State: AOAM531eCw28H6Ubt8d2jQWVfkUNXDT+rgPR+0fPA7IvRE55rVhlR/J3
        3IMeBUr14ESJ/R3m72gkbEIWvZSgLUPlvXfl73KegTa7
X-Google-Smtp-Source: ABdhPJzKnF5hpUhqwvtyTKCnkFS8JsrmF93ONq/zj/6d+uU5N2d2YuV3+j3jQKCgy3foXVhZ7/BmxqI60nFE56bkoeY=
X-Received: by 2002:a05:6830:1304:: with SMTP id p4mr5225706otq.185.1615432128924;
 Wed, 10 Mar 2021 19:08:48 -0800 (PST)
MIME-Version: 1.0
References: <1614818118-965-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1614818118-965-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 11 Mar 2021 11:08:37 +0800
Message-ID: <CANRm+CyxVC6gbdakvtqN+NFtDBvrSTShqF9HdB4fanomykd=ww@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: LAPIC: Advancing the timer expiration on guest
 initiated write
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ping, :)
On Thu, 4 Mar 2021 at 08:35, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> Advancing the timer expiration should only be necessary on guest initiated
> writes. When we cancel the timer and clear .pending during state restore,
> clear expired_tscdeadline as well.
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * update patch description
>
>  arch/x86/kvm/lapic.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 45d40bf..f2b6e79 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2595,6 +2595,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>
>         apic_update_ppr(apic);
>         hrtimer_cancel(&apic->lapic_timer.timer);
> +       apic->lapic_timer.expired_tscdeadline = 0;
>         apic_update_lvtt(apic);
>         apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
>         update_divide_count(apic);
> --
> 2.7.4
>
