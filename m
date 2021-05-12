Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C157337B2E2
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 02:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbhELADU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 20:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhELADU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 20:03:20 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E85C061574;
        Tue, 11 May 2021 17:02:13 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id h9-20020a4a94090000b02901f9d4f64172so4583571ooi.5;
        Tue, 11 May 2021 17:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KNr65iV0ydSb6KWIC4+XbRnV1TP02oNLnyMxFYz+vSk=;
        b=Fb0H96Vss8faMT+Q3ACe1H6L9YzhreOK5Zbk+iJolwhxJkIgtcloStW/jfq0Z2KzMm
         ElLLhfBrlBWPyBzLEKuWFbDRvMfpbeqqm9yyqp848mRq/983cwS0q2nOM7fku7dafN83
         pzvPbxB1zjCsC4MyzO4a8dwcxtaPOvgUhPJNJsXCf2o7WN47Ve0zpS8yFFJIf5zLdAd4
         fvDpeROP0sf0t3x9GlwT+5eQ9RUAIeAdg34Q/Dsw52xClJ54QVSgrrnFG1MZITlRhZ5j
         OgEkTAp8bdYqNJZWR45PcLXcxw7T/NJAjvjHF3u+F+/f8qJNHlRReeKbclvXTMerAxjX
         SV5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KNr65iV0ydSb6KWIC4+XbRnV1TP02oNLnyMxFYz+vSk=;
        b=DjgjYWaIBeuiTTJgB8fLUG3IEjdQqzf7jKmyABs/wKVDX8fBETAlb+DTo30RkV/pW6
         7Nnd1jOtgqP2ocz7zMzU0yN+kblU/dMqWynMuteudakKVkt6ha05yTcLkzL44uoBYhJn
         RG1HwSTA5Iu6RCF0hqGei+tR6dRIDJ59hv4Ix5yfNk/t+KmZYo/8rxlHoiTK99l3kpSE
         jO4GW08IN2MZbCBfziQxAShsMDBR4nhwt1TGcyloEs/QohGl7B9lB0D1ngTb/6b6JaI9
         pRsn4pJ/nq1bN20oLKECq1bt6ZF46aoRylB/2OsE0wBgfQ7tAvfAq1EkTGMKPPVNAbOB
         gMbg==
X-Gm-Message-State: AOAM531FYWrM+uIPZkytbo/B4T9UxObyfTi317P6YwcxInuGxLdSQQ4A
        FozJ0B3LG3njlTHIgZOaUx4/IiK+Xddx5XXhRER0d6qomX8=
X-Google-Smtp-Source: ABdhPJzjN2WktcSN6/IyxNyB3/zoq61qk4K0zYIEQL8Y7IEzhRbREvcSwCCWhS03WvYQ7HMAQZtNmkvsMdwAZx39giQ=
X-Received: by 2002:a4a:8706:: with SMTP id z6mr7736545ooh.41.1620777732651;
 Tue, 11 May 2021 17:02:12 -0700 (PDT)
MIME-Version: 1.0
References: <1620466310-8428-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1620466310-8428-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 12 May 2021 08:02:02 +0800
Message-ID: <CANRm+Cwq9F+yBTy8By0VgX3aA1NeVn0COAoRnYLr0jXe6QMOWA@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: PPC: Book3S HV: exit halt polling on
 need_resched() as well
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Ben Segall <bsegall@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cc more guys,
On Sat, 8 May 2021 at 17:32, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> Inspired by commit 262de4102c7bb8 (kvm: exit halt polling on need_resched()
> as well), due to PPC implements an arch specific halt polling logic, we should
> add the need_resched() checking there as well.
>

Update the patch description:

Inspired by commit 262de4102c7bb8 (kvm: exit halt polling on need_resched()
as well), CFS_BANDWIDTH throttling will use resched_task() when there is just
one task to get the task to block. It was likely allowing VMs to overrun their
quota when halt polling. Due to PPC implements an arch specific halt polling
logic, we should add the need_resched() checking there as well.

> Cc: Paul Mackerras <paulus@ozlabs.org>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/powerpc/kvm/book3s_hv.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 28a80d2..6199397 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -3936,7 +3936,8 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
>                                 break;
>                         }
>                         cur = ktime_get();
> -               } while (single_task_running() && ktime_before(cur, stop));
> +               } while (single_task_running() && !need_resched() &&
> +                        ktime_before(cur, stop));
>
>                 spin_lock(&vc->lock);
>                 vc->vcore_state = VCORE_INACTIVE;
> --
> 2.7.4
>
