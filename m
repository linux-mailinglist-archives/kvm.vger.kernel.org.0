Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68E3A382269
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 02:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhEQA7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 May 2021 20:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbhEQA7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 May 2021 20:59:44 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B7FC061573;
        Sun, 16 May 2021 17:58:28 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id z3so5057118oib.5;
        Sun, 16 May 2021 17:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N871goaSSdA/dHZRX1hFrtYRKni/828JahIgyz5A2aM=;
        b=kItJFM9jLVEaNef4/kLAjaaOLnFfG9EqgSOOGzXHTNg2UPXHOUUDBjK7XSrkEgJCK+
         BVjOBK3a1a4z6KAiLiY8F1xGhYFVphhQmENvi1buPcgbusMMxgANLaO/Ral4XRKVhQcf
         ieo5m9VpVsllIn2u4Hwy/DLoHxqwISDDov3Rwiey4vghkI9+0/em6tA4D65rPhqRtyAV
         +NALy3/4wwdlRQzGXbiDAbRo/crn3LDsMJ/8UUSLbfgZMcvbv1QwhTyIrgDVubF0ZEsV
         fdSUXQZUao00m6rI72Oph26hBG1x9fdQDiuvIlrj3/2zCqyy+qgpeIrz/eedpjuSGY2y
         EhKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N871goaSSdA/dHZRX1hFrtYRKni/828JahIgyz5A2aM=;
        b=rbvwYVze/m7n69X8dyugjcbMKeft3kaQeTgIxb5+XzlQaTQWrAa6e1jIR8phPCqyaY
         5M+6bRjN2QJ2RjizapfchFaPiNS2ejO7VIEu/hW6dhhvPOym4/BG1zisrgTvV743j9Wv
         DxaeninnL3jHufSf4rV8JFJoRicUe5u4lHhNwe0+tUBemR/dHKhc68fwEFGU73yPsckE
         +Sk+1Zuq1FTB/oyVmKbq57tnzBJc6mmdbYNyZ3NcWmKMh9eyCrOeaJNeKtJEw0Q3wkOW
         e0DEuvR/7iP1t/PHjk9jlU66xWVZNIIsMQ4w0FgNk3h7hxnc5VQlEYBspabSPwfaZ064
         RctQ==
X-Gm-Message-State: AOAM532+dYM1bFihKrc5qkXNtVuGhgSVAdyp5Vwf4SA4QGN9YiDxBaJ6
        IgfEvAd0MqRGM1cPQyw5Um0dXaG4pCwCsagp1iq8l7RG
X-Google-Smtp-Source: ABdhPJxRwDTUXiNGb1hh5dhChiuH/mxrWyl3/XMxs6yLhW9IKZILQ/C9hyAiZp5w27HzWQDUJkFHKBoFgvZq5g1Vl54=
X-Received: by 2002:a05:6808:206:: with SMTP id l6mr13191170oie.5.1621213108170;
 Sun, 16 May 2021 17:58:28 -0700 (PDT)
MIME-Version: 1.0
References: <1620871084-4639-1-git-send-email-wanpengli@tencent.com> <CALzav=eTC3HhHyxndHvS3NyCfPiBL2Wb5NvU=-+UsxSoMfmqXA@mail.gmail.com>
In-Reply-To: <CALzav=eTC3HhHyxndHvS3NyCfPiBL2Wb5NvU=-+UsxSoMfmqXA@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 17 May 2021 08:58:17 +0800
Message-ID: <CANRm+CxhnS8QovecA_cW-_kz2JK61+YHRrJBmsMS0Qkd+mFffA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] KVM: PPC: Book3S HV: exit halt polling on
 need_resched() as well
To:     David Matlack <dmatlack@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Segall <bsegall@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Suraj Jitindar Singh <sjitindarsingh@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 15 May 2021 at 05:21, David Matlack <dmatlack@google.com> wrote:
>
> On Wed, May 12, 2021 at 6:58 PM Wanpeng Li <kernellwp@gmail.com> wrote:
> >
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Inspired by commit 262de4102c7bb8 (kvm: exit halt polling on need_resched()
> > as well), CFS_BANDWIDTH throttling will use resched_task() when there is just
> > one task to get the task to block. It was likely allowing VMs to overrun their
> > quota when halt polling. Due to PPC implements an arch specific halt polling
> > logic, we should add the need_resched() checking there as well.
> >
> > Cc: Ben Segall <bsegall@google.com>
> > Cc: Venkatesh Srinivas <venkateshs@chromium.org>
> > Cc: Jim Mattson <jmattson@google.com>
> > Cc: David Matlack <dmatlack@google.com>
> > Cc: Paul Mackerras <paulus@ozlabs.org>
> > Cc: Suraj Jitindar Singh <sjitindarsingh@gmail.com>
> > Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> > ---
> > v1 -> v2:
> >  * update patch description
> >
> >  arch/powerpc/kvm/book3s_hv.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> > index 28a80d2..6199397 100644
> > --- a/arch/powerpc/kvm/book3s_hv.c
> > +++ b/arch/powerpc/kvm/book3s_hv.c
> > @@ -3936,7 +3936,8 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
> >                                 break;
> >                         }
> >                         cur = ktime_get();
> > -               } while (single_task_running() && ktime_before(cur, stop));
> > +               } while (single_task_running() && !need_resched() &&
> > +                        ktime_before(cur, stop));
>
> Consider moving this condition to a helper function that can be shared
> between book3s and the generic halt-polling loop.

Will do in the next version, thanks for review. :)

    Wanpeng
