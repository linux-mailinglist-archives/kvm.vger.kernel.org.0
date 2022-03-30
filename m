Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC9C4EB7BA
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 03:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241591AbiC3BUf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 21:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234408AbiC3BUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 21:20:34 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C18847384;
        Tue, 29 Mar 2022 18:18:50 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-2e5e176e1b6so202247447b3.13;
        Tue, 29 Mar 2022 18:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SnZBSyZar3/cpU2H1RzHZf2a0uvetUDmC7HqxBo+h7A=;
        b=dfr0ZWv4GAasLPKufTMYblXVd1edCvaJVrOyVpf1oXqqJ7o1OgHvvSnaz3BYt4Q429
         iddtQlNar88/RztYNbULqaXccn7FvhGCSo1Zick3THkFdquBL2zCmLy864qplc4wtOka
         4CXqvaXr5tilv9RWkpb6pyviGYxMBXijxdWPyrZ0+7fHn2dEwBjgf3lWPWQIOfUYpvCu
         niRX668YjBFEonkVt6Ws4Exd6kH41c5qN6v4tDna/ysf6kELSBg3zLfuLeEA1TM5aCEz
         vRDbSIU2Uh/i/F3I8OhimUhM0B7FJiICBWfS8aUHgEUc2nO36kNVwOVSfDXiszgY4Ync
         ChBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SnZBSyZar3/cpU2H1RzHZf2a0uvetUDmC7HqxBo+h7A=;
        b=l9Q5/egDumr1MovoPq3SLrKyVABX9cEznbgJxxZflib/Tn4oaweuJpZYZk2Hor7OXi
         ZiaeV4CI8ayG4Y34yq8NsDCAmmF1G+IHmAgk1Tbbh9G7fxNH9XTOZvcdlE1ZHR2RrD2s
         i2a46b4N0uQJoUPSq1KdwCBzizhRrWWVLAXTCf7MOImbpa1wSIfcfuV24SuwqfFoj3+u
         UDrwO0dWPgkyEgWuL6KDbOeRmGGGEDJbvWHF0pleRwpuN3AZsqsphUEMhDjl5eITmZYm
         1FG3BRl+GCD5Z8b0deHkY86Pu1Aw2uPlLuVZ3qIbT8tJjjf/4JF7Exg8EA1l46MXeka8
         ujGQ==
X-Gm-Message-State: AOAM5314aRIs5H7QqxP/DoI33eWG6+JnOq7oI3qwyBS5CK2Q4nfQvUBE
        PrG+91cddeLIkQyk+s9ncWae44+y8Yi1nQ/h5yepbw8a
X-Google-Smtp-Source: ABdhPJyqmuGbxulZVwamMCOfGf1zB8iFlPgQdWct/ZOfcEeEfhURZrR42hOqo7G4JAKbNvQn/Yj4I5Rh6VkVrMOu9sc=
X-Received: by 2002:a81:1704:0:b0:2e5:d98b:e185 with SMTP id
 4-20020a811704000000b002e5d98be185mr34019442ywx.354.1648603129650; Tue, 29
 Mar 2022 18:18:49 -0700 (PDT)
MIME-Version: 1.0
References: <1648216709-44755-1-git-send-email-wanpengli@tencent.com>
 <1648216709-44755-4-git-send-email-wanpengli@tencent.com> <YkOfJeXm8MiMOEyh@google.com>
In-Reply-To: <YkOfJeXm8MiMOEyh@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 30 Mar 2022 09:18:38 +0800
Message-ID: <CANRm+CxtyyGvBKMt2XpqvWwukAmZHvE7-SBKc7wLcYLR5D7v9g@mail.gmail.com>
Subject: Re: [PATCH RESEND 3/5] KVM: X86: Boost vCPU which is in critical section
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 30 Mar 2022 at 08:07, Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Mar 25, 2022, Wanpeng Li wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 425fd7f38fa9..6b300496bbd0 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10375,6 +10375,28 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
> >       return r;
> >  }
> >
> > +static int kvm_vcpu_non_preemptable(struct kvm_vcpu *vcpu)
>
> s/preemtable/preemptible
>
> And I'd recommend inverting the return, and also return a bool, i.e.
>
> static bool kvm_vcpu_is_preemptible(struct kvm_vcpu *vcpu)

Good suggestion.

>
> > +{
> > +     int count;
> > +
> > +     if (!vcpu->arch.pv_pc.preempt_count_enabled)
> > +             return 0;
> > +
> > +     if (!kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.pv_pc.preempt_count_cache,
> > +         &count, sizeof(int)))
> > +             return (count & ~PREEMPT_NEED_RESCHED);
>
> This cements PREEMPT_NEED_RESCHED into KVM's guest/host ABI.  I doubt the sched
> folks will be happy with that.
>
> > +
> > +     return 0;
> > +}
> > +
