Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9119A41F162
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 17:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbhJAPmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 11:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbhJAPlz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 11:41:55 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D53C061775
        for <kvm@vger.kernel.org>; Fri,  1 Oct 2021 08:40:10 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id i25so40300601lfg.6
        for <kvm@vger.kernel.org>; Fri, 01 Oct 2021 08:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iOLU+PCShJG7mENHHZDmXfBtA4qSABTxjGLw2vfUX2M=;
        b=FTPMXgWBWfgF0X587P8+s1ivBN5zQ86AEsMZsPqUhkAqpZfSYc01006geCHMsZrYSS
         /BlxSbkGJ2vpnZ+l+ytY+WRa6dTr09YIVuzOENTgTGtsDXx+3BrNnUV1if8FkhPXh1CX
         Epao7cmUnjwYPTQLUyKy2S7Dfg+J7Fsb6JY7sEuAP6soByMYDsDn4c/n31GS6u+/40/X
         SPmXvA4hFk37oLYnJI/xMnWxUdgKOQYPVH6zASRx+HECat6x0G8GV2JrS4PdBqBwiB1/
         Qralg04VhqUHVAMGM+7ur0MoRrKfP5OB3J6LpSrEgQDkfc/jQrFwocXgzQjTOUj0tGRM
         PAJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iOLU+PCShJG7mENHHZDmXfBtA4qSABTxjGLw2vfUX2M=;
        b=eo3a0iyJOvdj3WULuD1HXv8dXaP71isgtXYphgJ4mqBxwiRe+tqNORYwyuwNCUc6cP
         ewb77vVQ9nxqA/3iKisJ/C91cZUbydKYQPwRxnIgRD0U13Fy6hV3a5CIt4V6NyQqQIKZ
         fEtiUWk8+IvFKD64QAKcED74N7U2y53Scv1RlAy4BnOnCAXZ/wQG5vXgfwkxdxKmrBdr
         uXpRVc0hYxe8R/0mjJLbNgxEFID3fi5Qk2YC/YOVbI/M594aTFr8fb3Yk9A5g7X/ZDNk
         +KpTvuEEBT8m+8+O3eWE65y7wEGu24F0DKZD9StPfGh6//Itk1JU9oHvLn2Sy1sN75DM
         ARQg==
X-Gm-Message-State: AOAM533MIn7E0wafHTp4zJ6HgR8lQEgykx/H7/bDI6pppCW2RqjYNQGK
        0xO4iKjPbrPgFlQFLIUwuQAxhw+cAWlQHz5CqvEDvQ==
X-Google-Smtp-Source: ABdhPJyIyzUImniAS1WPH/aukNvZr9uNqVUOpo4zsi5GOyk1J8bsugXgDuozoLPp9qcCmCzvYTBMvavb9Z+NJVInTA4=
X-Received: by 2002:a2e:95cc:: with SMTP id y12mr12643770ljh.337.1633102808495;
 Fri, 01 Oct 2021 08:40:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210916181538.968978-1-oupton@google.com> <20210916181538.968978-5-oupton@google.com>
 <d88dae38-6e03-9d93-95fc-8c064e6fbb98@redhat.com> <746cfc82-ee7c-eba2-4443-7faf53baf083@redhat.com>
In-Reply-To: <746cfc82-ee7c-eba2-4443-7faf53baf083@redhat.com>
From:   Oliver Upton <oupton@google.com>
Date:   Fri, 1 Oct 2021 08:39:57 -0700
Message-ID: <CAOQ_QsgmpsjKD7SVzX4ftOUkDtMF+egorOyNwG8wpYqw2h44pw@mail.gmail.com>
Subject: Re: [PATCH v8 4/7] KVM: x86: Report host tsc and realtime values in KVM_GET_CLOCK
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 1, 2021 at 7:41 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 01/10/21 16:39, Paolo Bonzini wrote:
> > On 16/09/21 20:15, Oliver Upton wrote:
> >> +    if (data.flags & ~KVM_CLOCK_REALTIME)
> >>           return -EINVAL;
> >
> > Let's accept KVM_CLOCK_HOST_TSC here even though it's not used; there
> > may be programs that expect to send back to KVM_SET_CLOCK whatever they
> > got from KVM_GET_CLOCK.
>
> Nevermind, KVM_SET_CLOCK is already rejecting KVM_CLOCK_TSC_STABLE so no
> need to do that!

Yeah, I don't know the story on the interface but it is really odd
that userspace needs to blow away flags to successfully write the
clock structure.

--
Thanks,
Oliver
