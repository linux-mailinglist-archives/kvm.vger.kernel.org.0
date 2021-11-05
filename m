Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40758445FAC
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 07:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhKEG2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 02:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhKEG2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 02:28:17 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A5AC061714
        for <kvm@vger.kernel.org>; Thu,  4 Nov 2021 23:25:38 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id x64so8057848pfd.6
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 23:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=83I8KWJOKgy+kYsvOfvG78wBhuMiPl6vZLrWNC92y68=;
        b=f0zOuYJ0R/98fpq8DKHySf+sIvIHFTfBCgK4n/d1EoCYiWKyKR4aA9jyvDyhdxbmfr
         YHMxJQyuINQTM1ibyysDpCkDj4+38zSsX2BREDDSfg58sWjoxCBvGIz30WjMfr09FIAx
         qUoe6oDOD8Oo3CD6/eTDmaXtgyRP9SgtmzHX2pwZrY/K+2PJzt9HGdnYXg42zZ2nKvms
         q6HtKdspaQ14CR3pB6ICiUM7gOtLAjb6TUNmxUnX6kWrrDE5YPGoO4Dr0iPtg4EyQkoo
         l6+OfBra1fHrmBAWTk3hgQc6MY8RjVhsDu8IBTxpH/Tsc3unRhpAoM2z143bLz6nMVOk
         wD8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=83I8KWJOKgy+kYsvOfvG78wBhuMiPl6vZLrWNC92y68=;
        b=6B/Pfax8Yxj5GcSK0h6vlWkuUYyOuEtXjB3BlYupXqXwLmh/EOziONIwKK0MLqFKKG
         8JrK6ReVC0To4xigQRmsHL304h5aqshGekRL9IxK+dfVA1d0wblfNfkfvgqKbLiNr3BL
         dlbk9P4TY5/vH9eUyE20u6iZIn8KbnKzJQQ//LeXjv54TRyIiNvi4Ubz8rKAOPLzdVYG
         3FvXCxwV4NIDx7g0kC6fQVHwJBGw1Zy/6KhhhmD5meUfvMeP/P/VL5VAd1Zd8C5ORl32
         5tcIBDsMwZFQrSO5TUvEN1PMeBaPXwzdGRjEpNCE44qh78TVNqlcFyQdrU46fGjfWzsT
         Sp2Q==
X-Gm-Message-State: AOAM532N93spcFoPsNxXhaNW3Sf4ml+qd8ETPTkJlOotHvuzP7zSAbce
        w9d3a1K8g8HY/ulu9ClWP+5Yg1qtyvbIPZdNalpVhg==
X-Google-Smtp-Source: ABdhPJxw9VnfnHe9u50el4lnxVAR9qUrlhodBzmSVS92D4DmQlKkuRP7Li6Zcj7Slw2kIxX2GwblXLsXIsFv3YBquzU=
X-Received: by 2002:aa7:8246:0:b0:44b:4870:1b09 with SMTP id
 e6-20020aa78246000000b0044b48701b09mr58421337pfn.82.1636093537523; Thu, 04
 Nov 2021 23:25:37 -0700 (PDT)
MIME-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com> <20211103062520.1445832-3-reijiw@google.com>
 <YYQG6fxRVEsJ9w2d@google.com> <CAAeT=FzTxpmnGJ4a=eGiE1xxvbQR2HqrtRA3vymwdJobN99eQA@mail.gmail.com>
In-Reply-To: <CAAeT=FzTxpmnGJ4a=eGiE1xxvbQR2HqrtRA3vymwdJobN99eQA@mail.gmail.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Thu, 4 Nov 2021 23:25:21 -0700
Message-ID: <CAAeT=FxqonCJHuv55jj0DR7n164yJaJHYU1XpQk3r4kWaXjyPw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 02/28] KVM: arm64: Save ID registers' sanitized
 value per vCPU
To:     Oliver Upton <oupton@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 4, 2021 at 2:39 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Oliver,
>
> On Thu, Nov 4, 2021 at 9:14 AM Oliver Upton <oupton@google.com> wrote:
> >
> > Hi Reiji,
> >
> > On Tue, Nov 02, 2021 at 11:24:54PM -0700, Reiji Watanabe wrote:
> > > Extend sys_regs[] of kvm_cpu_context for ID registers and save ID
> > > registers' sanitized value in the array for the vCPU at the first
> > > vCPU reset. Use the saved ones when ID registers are read by
> > > userspace (via KVM_GET_ONE_REG) or the guest.
> >
> > Based on my understanding of the series, it appears that we require the
> > CPU identity to be the same amongst all vCPUs in a VM. Is there any
> > value in keeping a single copy in kvm_arch?
>
> Yes, that's a good point.
> It reminded me that the idea bothered me after we discussed a similar
> case about your counter offset patches, but I didn't seriously
> consider that.
>
> Thank you for bringing this up.
> I will look into keeping it per VM in kvm_arch.

I just remembered that I made the prototype that kept ID registers
per VM as the option B (, which introduced per VM ID register
configuration API though...).

Anyway, I've noticed that requiring the consistency of ID registers
amongst vCPUs in a VM affects KVM_ARM_VCPU_INIT API, with which
userspace can currently configure different features for each vCPUs.
I'm not sure if any existing userspace program practically does that
though.

Now, I think I should rather remove that consistency requirement...
(at least for features that can be configured by KVM_ARM_VCPU_INIT)

Thanks,
Reiji
