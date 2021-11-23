Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F64845996D
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 01:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhKWAzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 19:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbhKWAzX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 19:55:23 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA08DC061756
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 16:52:00 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id z6so17649629pfe.7
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 16:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U8wVUqAGerxKdyql8K3cQpZeIXWsZUSoHk+rQSQu8dQ=;
        b=lGN8M+8oQF0Hjs4njXU12qJ0QTEbrLTpdd9PGYmqJsG+hVHBDnY0wLf/3ow5s17ApQ
         4p0nPHvvB49y+9AC6f3x7F9CqWBJW7GLmN42yml1mvQ5ItTxYmEtSugGIKSyAe/jLLKl
         j0qtH2g1/MkWlltsehxN3jKJyhXaGg85cNQaJEX5onIL59dJqtEjl7vJbvxzcWpAKBMf
         C07Tez1lwA1jq4p8ZoaP8CwwXJHAOIIC4F57STxdUDow6OVt0esTkiVGAuG9If4uZyOd
         H4YYvSM87+z6xufGwEmMFxTWljQDXtDoyKkS2FqS00upycbkwBAxMPy7KMeGtX+yGhCn
         i+Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U8wVUqAGerxKdyql8K3cQpZeIXWsZUSoHk+rQSQu8dQ=;
        b=1F0s3Dii4Q5GenbmS71FDP96hQ3/1vdErAM8j+5VAKlJRcYiA95woSBBqHE9K75p6A
         zy+v2rsorayzCBKdIa8E3gKTVd14I7J/p+PiCrkfWxZiGXcK+H7UZ/1KlO977VCXive0
         fxIHUzumxsmeqnxCwGqNZvo0nYOvRbI9/+1Sk0YKR1tXN6ixoD8YHSv6L6N2bARzyqjn
         4JvCrCeBry2OeZAgm2B7z8eH0XLDISBe6GZAhDAc2day/8s1L9cKjwxCGKcTuYaEfgjC
         79P9JI56zWbUco9LuyZEvMxtHQpDWYFJznZKOK42Ch+SL206ZZKyYB99+lB7rg5HmrW4
         k7+w==
X-Gm-Message-State: AOAM533WtCx0qt7T/4URPjBA3yrVToRNiaoKnjJYuHoUniTyi6TzRYgA
        NcM+DCKwkV+MVPLYk5KmVjrQj8yVKfWsHjAur1CD7w==
X-Google-Smtp-Source: ABdhPJyubfAEVgA+QQrnFhtEtO0iS8FLlQEPm5gaAFwunjtCJUIDZnMl618fjlYHTqqeIy4H0Mr1zygLiMBuKOx1xWU=
X-Received: by 2002:a63:6ec7:: with SMTP id j190mr855827pgc.395.1637628719955;
 Mon, 22 Nov 2021 16:51:59 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <20211117064359.2362060-2-reijiw@google.com>
 <87mtlxsn1l.wl-maz@kernel.org>
In-Reply-To: <87mtlxsn1l.wl-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 22 Nov 2021 16:51:44 -0800
Message-ID: <CAAeT=Fy2XudkVuLJwwvDop7cWeXdaMevjbCAyMd5O6Y5DcHwcg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/29] KVM: arm64: Add has_reset_once flag for vcpu
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
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

On Sun, Nov 21, 2021 at 4:36 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 17 Nov 2021 06:43:31 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Introduce 'has_reset_once' flag in kvm_vcpu_arch, which indicates
> > if the vCPU reset has been done once, for later use.
>
> It would be nice if you could at least hint at what this flag is going
> to be used for, as being able to reset a vcpu as often as userspace
> wants it is part of the KVM ABI.

I will update the description.


> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Reviewed-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 2 ++
> >  arch/arm64/kvm/reset.c            | 4 ++++
> >  2 files changed, 6 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 2a5f7f38006f..edbe2cb21947 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -385,6 +385,7 @@ struct kvm_vcpu_arch {
> >               u64 last_steal;
> >               gpa_t base;
> >       } steal;
> > +     bool has_reset_once;
>
> Why can't this be a new flag (part of the vcpu->arch.flags set) rather
> than a discrete bool?

Thank you for the suggestion ! I will fix it to use vcpu->arch.flags.

Regards,
Reiji
