Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EC5388506
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 04:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352928AbhESC70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 22:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237536AbhESC70 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 22:59:26 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F988C06175F;
        Tue, 18 May 2021 19:58:07 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id z3so11798653oib.5;
        Tue, 18 May 2021 19:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aVwaDci8IvJdC0IW3jQEcy/PyvNGH7SvAZ6GA9NzV4E=;
        b=bt4Fg0aJFXVhCiQGTtTOAVrtI9JL88Llaxnp6O/VkDtR1PVaa26mB4x1K1TCgDARJ/
         CkX91VKVBObiJ9QaUhdrOgKjoD2k5zlhc/YkvtlxAK+NCsiJ0AAu1UIqpw+RePePeber
         cpeLYOKQhHrXaBaiKxz7yi5woRRkp1lIyQa1ccLAGzWzIe+zfSQcQIQj2eAAmDCkGQvr
         ULMCHY5R0GsN1M38/ycY7V8cY1jIVMvYil0Qx6bXWMqh4R8SfgsSWbmQiA5uoz0CYjFP
         o0JQqB+15REvOXW/g6SwpUsa7Im/tycHhKdhZgpNd5OHK5+mAUjZLiuHZViH64l5ZSwW
         qDow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aVwaDci8IvJdC0IW3jQEcy/PyvNGH7SvAZ6GA9NzV4E=;
        b=h3HYeThhcne+KDISd0AbrMeKR8aeCTwzy32SI37dZOCjvu9vGDKMC/Q7YsSQGr0Rb9
         ayE782uah4VeHojJ8k7EAqpQGq3KY4RQR7mxRP2Ljt4wTRFVytM5kYqVU9lR0QvWDONd
         hrFW1TCiwsFZHn6HzVw6mZrfVPEez+L2Wcxc9MHCxMWuApWsasDIVHQgzH/lA7ork/hR
         4f8qbboWu6J4nSMRdm1XbiE6G2EWUrlgL9yYFSefUD9iIuapC9uzqLeJfXT8rX98yajV
         +Gyrub+VVSA5QQakqOad37Da+7xqM1SFGWZMGeCtPVT7TgSouaor0+z4OvYHIAFu8rOz
         p7ag==
X-Gm-Message-State: AOAM530ZlobhgxQAKtesEq0D+DB5bD/gNbOupEOyvp6pxRM8TJBIvebg
        T3CaLPW4qL/EGzMpXA4cURrKSvEwMNNisgNptPs=
X-Google-Smtp-Source: ABdhPJwcBw5hmOytDrrgv97Pc6k0Vb6PM/MsfiRivQxDUkkUJKHhxr6A/SgveV6gh4h7n+L8pkebIzlRyh5qSWITVG4=
X-Received: by 2002:a05:6808:206:: with SMTP id l6mr5624080oie.5.1621393086738;
 Tue, 18 May 2021 19:58:06 -0700 (PDT)
MIME-Version: 1.0
References: <1621339235-11131-1-git-send-email-wanpengli@tencent.com>
 <1621339235-11131-2-git-send-email-wanpengli@tencent.com> <YKQTx381CGPp7uZY@google.com>
In-Reply-To: <YKQTx381CGPp7uZY@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 19 May 2021 10:57:55 +0800
Message-ID: <CANRm+Cy_D3cBBEYQ9ApKMNC6p0dpTBQYQXs+dv5vrFedVkOy2w@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] KVM: X86: Bail out of direct yield in case of
 under-committed scenarios
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

On Wed, 19 May 2021 at 03:21, Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, May 18, 2021, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > In case of under-committed scenarios, vCPU can get scheduling easily,
> > kvm_vcpu_yield_to add extra overhead, we can observe a lot of race
> > between vcpu->ready is true and yield fails due to p->state is
> > TASK_RUNNING. Let's bail out in such scenarios by checking the length
> > of current cpu runqueue, it can be treated as a hint of under-committed
> > instead of guarantee of accuracy. The directed_yield_successful/attempted
> > ratio can be improved from 50+% to 80+% in the under-committed scenario.
>
> The "50+% to 80+%" comment will be a bit confusing for future readers now that
> the single_task_running() case counts as an attempt.  I think the new comment
> would be something like "30%+ of directed-yield attempts can avoid the expensive
> lookups in kvm_sched_yield() in an under-committed scenario."  That would also
> provide the real justification, as bumping the success ratio isn't the true goal
> of this path.

Looks good. Hope Paolo can update the patch description when applying. :)

"In case of under-committed scenarios, vCPU can get scheduling easily,
kvm_vcpu_yield_to add extra overhead, we can observe a lot of races
between vcpu->ready is true and yield fails due to p->state is
TASK_RUNNING. Let's bail out in such scenarios by checking the length
of current cpu runqueue, it can be treated as a hint of under-committed
instead of guaranteeing accuracy. 30%+ of directed-yield attempts can
avoid the expensive lookups in kvm_sched_yield() in an under-committed
scenario. "
