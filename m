Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A97A4304D8
	for <lists+kvm@lfdr.de>; Sat, 16 Oct 2021 21:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244460AbhJPT4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Oct 2021 15:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234499AbhJPT4m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 Oct 2021 15:56:42 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9EFC061765
        for <kvm@vger.kernel.org>; Sat, 16 Oct 2021 12:54:34 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id v20so8564696plo.7
        for <kvm@vger.kernel.org>; Sat, 16 Oct 2021 12:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7Bg6TGOLAavtW0s4J/kZZMV1bnJwdYuD4TGepUNX/tY=;
        b=AmqmWsOfoRoUoz+WTi74gAe9rN4hcVK8XFoVdL+M8NRmib/RrP1Z1AdbG2lOogb1Wt
         1W8+dQ6xJKWyXh2UgWICoXnk8BsDVfVn/6c0mtGveFqfGlCxffbRim8qKyPbE2RIwHkX
         D96Dz46VL/Y3G+ooYKS0GmL1ICXlJCdvFWJatzq9jr5r7YKwvg5jJ1ui1wpZ5zq4Haay
         YPknnmtgflDrWaqTepv0noQ2UXBDtt8oCluxFZ4duhKt/rCcXtd0EC3POAPwOHE5VmV8
         Xx9VeRn2rzEPhE1h+Nm5huLq6DIS/w9+bohPezxLHhxxa9UmJamkUfPXbwj7eeFOR3eP
         rFjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7Bg6TGOLAavtW0s4J/kZZMV1bnJwdYuD4TGepUNX/tY=;
        b=MzaviYd/MgXCQcHv38/4vX8CHrlGUh3d+E5fGXls3O41aoo++3CU0+n35JzT7a2GTd
         XPrGCvLORiQ1FGVV115gkZtaxj0RxzYbFiXvhL8eMDM83NTJZfGAdN0RtEZ+n8thui4h
         /u+7tpTPf0NaoZ7ht17kTxwNL78jMndcyugQWWh2yoR3U3X80yJ7K+nF/gOw466YWtwz
         AI9AXeeDwlUXcLqDNQN+pX3yfSjz/x2N7vGBAcuVC9nfcl4ihAQgOzPkRbTr58c0kCU/
         6H/wuGr0DOIU1WYxtQz6om746QU18RyAHqrbrkXgQLU2t1dl6EhZJZSRH2T4oZ5NSm5N
         pPQg==
X-Gm-Message-State: AOAM532jIRJl1qClO5wRT7O+mvEF+sDO9kuSxQC1sHtEfkwQ4V27dGfF
        YxhlMIqwswbJMOYiVvFWxerPFPuKlzKEyS7ct8tYYA==
X-Google-Smtp-Source: ABdhPJy8Zqegj2FjeexRUCd5FvBZlqkWIK73RiHjvMhow6D+8ObsSPjfF+SGKLlFtZcHDY002b/ddFUmLDeOv6QcUxk=
X-Received: by 2002:a17:90a:bd04:: with SMTP id y4mr22202191pjr.9.1634414073731;
 Sat, 16 Oct 2021 12:54:33 -0700 (PDT)
MIME-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com> <20211012043535.500493-2-reijiw@google.com>
 <20211015101259.4lmlgk5ll2mrnohd@gator>
In-Reply-To: <20211015101259.4lmlgk5ll2mrnohd@gator>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Sat, 16 Oct 2021 12:54:18 -0700
Message-ID: <CAAeT=Fy13Y9AJPvk3EovX9_-mo7D=kRaN6-gHA9q9o99r3qhog@mail.gmail.com>
Subject: Re: [RFC PATCH 01/25] KVM: arm64: Add has_reset_once flag for vcpu
To:     Andrew Jones <drjones@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andrew,

On Fri, Oct 15, 2021 at 3:13 AM Andrew Jones <drjones@redhat.com> wrote:
>
> On Mon, Oct 11, 2021 at 09:35:11PM -0700, Reiji Watanabe wrote:
> > Introduce 'has_reset_once' flag in kvm_vcpu_arch, which indicates
> > if the vCPU reset has been done once, for later use.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 2 ++
> >  arch/arm64/kvm/reset.c            | 4 ++++
> >  2 files changed, 6 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index f8be56d5342b..9b5e7a3b6011 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -384,6 +384,7 @@ struct kvm_vcpu_arch {
> >               u64 last_steal;
> >               gpa_t base;
> >       } steal;
> > +     bool has_reset_once;
> >  };
> >
> >  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> > @@ -449,6 +450,7 @@ struct kvm_vcpu_arch {
> >
> >  #define vcpu_has_sve(vcpu) (system_supports_sve() &&                 \
> >                           ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
> > +#define      vcpu_has_reset_once(vcpu) ((vcpu)->arch.has_reset_once)
> >
> >  #ifdef CONFIG_ARM64_PTR_AUTH
> >  #define vcpu_has_ptrauth(vcpu)                                               \
> > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > index 5ce36b0a3343..4d34e5c1586c 100644
> > --- a/arch/arm64/kvm/reset.c
> > +++ b/arch/arm64/kvm/reset.c
> > @@ -305,6 +305,10 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
> >       if (loaded)
> >               kvm_arch_vcpu_load(vcpu, smp_processor_id());
> >       preempt_enable();
> > +
> > +     if (!ret && !vcpu->arch.has_reset_once)
> > +             vcpu->arch.has_reset_once = true;
> > +
> >       return ret;
> >  }
> >
> > --
> > 2.33.0.882.g93a45727a2-goog
> >
>
> Hi Reiji,
>
> Can't we use kvm_vcpu_initialized(vcpu)? vcpu->arch.target should
> only be >= when we've successfully reset the vcpu at least once.

Thank you for reviewing the patch (and other patches as well) !

As you already noticed, we can't simply use kvm_vcpu_initialized()
because vcpu->arch.target is currently set earlier than the first
vcpu reset.

Thanks,
Reiji
