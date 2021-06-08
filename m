Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26DD39EAB3
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 02:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhFHAco (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 20:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbhFHAcn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 20:32:43 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C72BC061574;
        Mon,  7 Jun 2021 17:30:40 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id i12-20020a05683033ecb02903346fa0f74dso18601779otu.10;
        Mon, 07 Jun 2021 17:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xoUB7E0rhgyrtTh314wlLP8BH8N4shqndYrHMc1LScU=;
        b=TodGq3kIFaqpAdnU4+17cEAcmbkUPEqr1PWEaFpZ4e5/weQugF0btp8HLBMHvH1U81
         EU4/v8F6wcU6D2O9gMd4jK5julVDBQ8VMaUtobU0TegqfbwM9pt25nl2TCfUiXKYb39E
         nCp67OGd1ic7vVxIyYPE4FTM6h2MZ5KNC18H+kWwQxUxRNdCOeFhj3MGL2xZHJ0nTPMo
         QLTvs/9gMHq8ZFBIR39DEf/uWrWLphdy8nP4WLP69ijlCDxz6M77XuCkbmEnN7dVuDed
         X9ndo+V6rjqsqyy410ItCSogRXearJHVDF1EHLbOR1PUPwC+v5nhswPxiloYpTV/aCNB
         NVUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xoUB7E0rhgyrtTh314wlLP8BH8N4shqndYrHMc1LScU=;
        b=C4hCsTIXbSd/UIwXT4ViriIC8kk0+6OsYeoAvn3UI9vUp65zHqC11cZdjvQvW10Qfg
         7qcVJf4SPLIYcyqgQALWig+Qz3MLekBiQGI9dR8cOvYzrd5bGDqpfq/evPfKnsvz2yzj
         a5mXd6cty3HFDfe7qUV+6wD4afwTLygJPeseN2UAD5b98i+3Jc0UhyKYctzb6nCpcKCC
         7l4r27MGWwJrVmls2CI/F4QGUA/mbi0Luy0eyOzDXGtd8VLkUayjsrrgtO6c4L3j+KPx
         sRNVhyHwl+KOdeBHTBz+hKTN7GSvNEvJUQ6q2NA2ZboeIdPCeW8DXotPHUNFp8j5ap2y
         ZVmA==
X-Gm-Message-State: AOAM533ngrH/o6ulT2yEml89Baq7H4FtRDlya9qLMdUNEtqgJc0yYUGC
        ErQQ6NkmRG1mj4jQebBzZpxR29eqh/DHp7fvMNE=
X-Google-Smtp-Source: ABdhPJz4YiQfYwm25QPzKlI8Xy6ZhDG9CiScXQ4LY3iZOx9/l0+5MibPrQICrOkR3K3anfhpHy0V6s7vObi7M7tgGh0=
X-Received: by 2002:a9d:5786:: with SMTP id q6mr15748398oth.56.1623112239557;
 Mon, 07 Jun 2021 17:30:39 -0700 (PDT)
MIME-Version: 1.0
References: <1622710841-76604-1-git-send-email-wanpengli@tencent.com>
 <YLjzJ59HPqGfhhvm@google.com> <CANRm+CxSAD9+050j-1e1_f3g1QEwrSaee6=2cB6qseBXfDkgPA@mail.gmail.com>
 <YLpIni1VKYYfUE8D@google.com>
In-Reply-To: <YLpIni1VKYYfUE8D@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Tue, 8 Jun 2021 08:30:27 +0800
Message-ID: <CANRm+CzMNctK1nWfTf10ch2TDB-6Trh4JSOGqONm4zjnctoP-g@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: LAPIC: write 0 to TMICT should also cancel
 vmx-preemption timer
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 4 Jun 2021 at 23:37, Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Jun 04, 2021, Wanpeng Li wrote:
> > On Thu, 3 Jun 2021 at 23:20, Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Thu, Jun 03, 2021, Wanpeng Li wrote:
> > > > From: Wanpeng Li <wanpengli@tencent.com>
> > > >
> > > > According to the SDM 10.5.4.1:
> > > >
> > > >   A write of 0 to the initial-count register effectively stops the local
> > > >   APIC timer, in both one-shot and periodic mode.
> > > >
> > > > The lapic timer oneshot/periodic mode which is emulated by vmx-preemption
> > > > timer doesn't stop since vmx->hv_deadline_tsc is still set.
> > >
> > > But the VMX preemption timer is only used for deadline, never for oneshot or
> > > periodic.  Am I missing something?
> >
> > Yes, it is upstream.
>
> Huh.  I always thought 'tscdeadline' alluded to the timer being in deadline mode
> and never looked closely at the arming code.  Thanks!
>
> Maybe name the new helper cancel_apic_timer() to align with start_apic_timer()
> and restart_apic_timer()?  With that:
>
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Do it in v2, thanks.

    Wanpeng
