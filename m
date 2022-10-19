Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18434604589
	for <lists+kvm@lfdr.de>; Wed, 19 Oct 2022 14:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbiJSMjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Oct 2022 08:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233501AbiJSMjS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Oct 2022 08:39:18 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C213B466
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 05:20:32 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id o12so19324455lfq.9
        for <kvm@vger.kernel.org>; Wed, 19 Oct 2022 05:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l66+WLbhAlzPkyHFepjJ8VPyMoK+GDU3eUQBN3ZbwNk=;
        b=QfLHua9SUQ3cWtrSq3McnLndCx2mA3ijM5R/zZF0C4k3w7iTfpZiDMJD0dMzR8po7r
         nT12MX7BJ+z+zM1uhGOyUEMQ6LfI7wMqwDZLNgbyVWd6UEUjOINItZKgEiZqYiU27Iq5
         lK8khYGQGBm35jPdTcQndnZluivOIi36+9gQNysUPwL65LwDvnvOZUh75rXUwd6yMD6U
         /xnNP/G2B5RmZp1H3AN3TciuxupqJzz1XHKECOrL1Um2g/tA1R12KxRZihAwGMod7mBV
         vULmqNaidNLc0U27P3UnnAY+Ue5K9e24NPsWmtbT4Eyzlo5HcJQ2VjOBcWQavWyNmqH/
         AEhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l66+WLbhAlzPkyHFepjJ8VPyMoK+GDU3eUQBN3ZbwNk=;
        b=KObAE73PCMk1JVAoDILkmCLJ2pg9LVN4gGGNZpJT+mlqKgca7yWFvAQCVI2u3VFNfG
         akxcVQREXribnH87KIGMpy1rHwhT3k7mWCFQAbRHJs7QBPjIfKnQ1xb+N4YZj8qW7cm5
         jIwoTEIQkm4o1GGoekYKabpK58iwhC8OKGjR9nTUvRW4ou9ILvbd3o0UX6D+fVz6R8By
         cKfHAxQXSPFyvqGgRSRjAVFjBlHCLXuiIkdoHqqlfONeH7RGZUGLVPIE1qc+KPPR6pIq
         Ny2ha/7BrEG4yvsTRFPUnItlGl3XwQ19N9qHYF8NQj3RfhTHj8gnE2KwyOcWYHabneZW
         LEqA==
X-Gm-Message-State: ACrzQf048GSIsVFGyZStmDY3egy+/UKBAEhjpZ0FrOzGJCibv/ELRUlo
        /6ZfrpTvFVP1vavVmxQIUJW/IoIZIBz/zbwnwiKhKQ==
X-Google-Smtp-Source: AMsMyM6QuAQGdziehqyNNg/dYLtJsZNxcgWER/SNrhmNQ9i6DMHJoP1Fx9le0dqEgW94QIKYhJ9aw9jygeYpRtlfJQw=
X-Received: by 2002:ac2:5ca9:0:b0:4a6:f2c:a1f9 with SMTP id
 e9-20020ac25ca9000000b004a60f2ca1f9mr217735lfq.26.1666181939680; Wed, 19 Oct
 2022 05:18:59 -0700 (PDT)
MIME-Version: 1.0
References: <20221017115209.2099-1-will@kernel.org> <20221017115209.2099-13-will@kernel.org>
 <Y07YJvEsUnjSasA0@google.com>
In-Reply-To: <Y07YJvEsUnjSasA0@google.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Wed, 19 Oct 2022 13:18:23 +0100
Message-ID: <CA+EHjTyrBCjJ_=qEs1tQ_4SO+oMq4BTGTnipJa1kDRXVxu0RcA@mail.gmail.com>
Subject: Re: [PATCH v4 12/25] KVM: arm64: Add infrastructure to create and
 track pKVM instances at EL2
To:     Quentin Perret <qperret@google.com>
Cc:     Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
        Sean Christopherson <seanjc@google.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Tue, Oct 18, 2022 at 5:45 PM Quentin Perret <qperret@google.com> wrote:
>
> On Monday 17 Oct 2022 at 12:51:56 (+0100), Will Deacon wrote:
> > +static int find_free_vm_table_entry(struct kvm *host_kvm)
> > +{
> > +     int i, ret = -ENOMEM;
> > +
> > +     for (i = 0; i < KVM_MAX_PVMS; ++i) {
> > +             struct pkvm_hyp_vm *vm = vm_table[i];
> > +
> > +             if (!vm) {
> > +                     if (ret < 0)
> > +                             ret = i;
> > +                     continue;
> > +             }
> > +
> > +             if (unlikely(vm->host_kvm == host_kvm)) {
> > +                     ret = -EEXIST;
> > +                     break;
> > +             }
>
> That would be funny if the host passed the same struct twice, but do we
> care? If the host wants to shoot itself in the foot, it's not our
> problem I guess :) ? Also, we don't do the same check for vCPUs so ...

You're right, the host can shoot itself in the foot if it wants to.
The reason why we don't have it for vcpus is that that code was
factored out later, and as you said, a similar check isn't necessary.

TLDR: we'll remove it :)

Thanks,
/fuad
