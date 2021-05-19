Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55BD388696
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 07:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242557AbhESFfX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 01:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241100AbhESFe7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 01:34:59 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB11C061760
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:33:38 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id s19so6861469pfe.8
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Y3UOQMDJrIHJSBrGqM/NIVAlOdJSyvl9tA8WHC3cmA=;
        b=JynZLQlWZQBwwqP5hYqHmLnoiPN0RNcy6kEBdRtKlCnVUOus8b4BEbWLOq+haYfyBA
         HA/CYS7kpl/VZbidtBOdWm0Tdum8xxFHr6456BP1oZnMBf70tNZ1gQKYWz4w/bI4Ysaq
         WsBdNAF59UxKYmn6KAuA1au6/ZrAhEMNkwlTiWCYRop2uxJ6cWxjTPGfAP3zfIjHQl/w
         8OhCQXf/7yx9Ww1t2oZjDwTPM15QsGF27qtzhAgzVY8JAdO3ysbtxWUZ5x0DL7GpDgHI
         gqp12w3X75qiJJoQqQ+9J7RGHJhFFxCTmSj4rFFoLWbvYWRS2ou0b8XXwzeKzPGxocEm
         VJvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Y3UOQMDJrIHJSBrGqM/NIVAlOdJSyvl9tA8WHC3cmA=;
        b=fD8kvNUkNriQteWzGNDMCNN3PUEfP2fENhVbBdA/ZnyRjYnOZaXugE6wpSZNOHKy2w
         2pcyaqTJPYjfCbSOEvRCMWLP90r7tAiHBQqYQqDTFG0+p19QfrjWSComDDQJ5rVy8Fgz
         9FRvO5tWWcsuxFSbzeQinmvZ9AKXiQIOW0ZtJ6suRmzlJ8JNXNH0IG6mJYgN0OKHi5VE
         Wk2SwQqAtU9EQlFgdHAKVJxoPmXtEJB5NgXYaDdi1pUVzpaBJewi9rVlecuj+wKm8rhi
         FxW41u7D818PqUHv/KjnabVIMeo/xf/1HXidjMBh6yvzydGmsu1FEhMw7MiH0yConDrA
         Ur0g==
X-Gm-Message-State: AOAM530S/bjnlGdCk8hFyKawlS+DmkhhIzMJXgdRitr2LLwHxL8yAkDs
        RmAs0hx8kWM8pEM1abxFmg5XNcA4ZUnXHT6ywuhjnA==
X-Google-Smtp-Source: ABdhPJxEpGdn8uDQgZB68gD6XEM3ujleyCYvAVmHX+ZY3gNi5+YKNX+sOlddWkZtc9R+yRESKvqm6MS+N+5T8M4wqAI=
X-Received: by 2002:a65:61a8:: with SMTP id i8mr9092980pgv.271.1621402418048;
 Tue, 18 May 2021 22:33:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-11-seanjc@google.com>
In-Reply-To: <20210424004645.3950558-11-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 18 May 2021 22:33:22 -0700
Message-ID: <CAAeT=Fxr_xvfVDcW5ivtbDo2jqPSSy8wKTSrg2xVHROaD029sg@mail.gmail.com>
Subject: Re: [PATCH 10/43] KVM: VMX: Move init_vmcs() invocation to vmx_vcpu_reset()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 5:48 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Initialize constant VMCS state in vcpu_vcpu_reset() instead of in
> vmx_vcpu_create(), which allows for the removal of the open coded "vCPU
> load" sequence since ->vcpu_reset() is invoked while the vCPU is properly
> loaded (which is the entire point of vCPU reset...).
>
> Deferring initialization is effectively a nop as it's impossible to
> safely access the VMCS between the current call site and its new home, as
> both the vCPU and the pCPU are put immediately after init_vmcs(), i.e.
> the VMCS isn't guaranteed to be loaded.
>
> Note, task preemption is not a problem as vmx_sched_in() _can't_ touch
> the VMCS as ->sched_in() is invoked before the vCPU, and thus VMCS, is
> reloaded.  I.e. the preemption path also can't consume VMCS state.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
