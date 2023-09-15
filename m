Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12517A2832
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 22:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237154AbjIOUgd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 16:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237275AbjIOUgZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 16:36:25 -0400
Received: from out-226.mta1.migadu.com (out-226.mta1.migadu.com [95.215.58.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69C0F3
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 13:36:16 -0700 (PDT)
Date:   Fri, 15 Sep 2023 20:36:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694810174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jh8wxRtaCDmNfJKXz9NRQ7CZIQMzCI29C3PoTr8TsLs=;
        b=v0fuP40FaFR3ghn7RXIwy67Q0K0A9PV4x7M7qmiJj74u7uqOJcrmJy/NRsbpejjUsPsPU4
        o8NKRojsEw1KDsPIIQzBTZ71ljSVKKl4nchWZXeaA7gfwOJFxk7ZY/eqk94xQwimORQ6yv
        FbOt19DOumNoGkOOaXU99v5XYPYZOhU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Shaoqin Huang <shahuang@redhat.com>
Cc:     Raghavendra Rao Ananta <rananta@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 08/12] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
Message-ID: <ZQTAOcTsGPos/mBD@linux.dev>
References: <20230817003029.3073210-1-rananta@google.com>
 <20230817003029.3073210-9-rananta@google.com>
 <6dc460d2-c7fb-e299-b0a3-55b43de31555@redhat.com>
 <CAJHc60whpvOHYCFueqh0Q=SbmmeRBG_x90QOvX+vOun73ttjPA@mail.gmail.com>
 <e479914b-7ba2-3a9a-2b07-9965532cbcfa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e479914b-7ba2-3a9a-2b07-9965532cbcfa@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 22, 2023 at 11:26:23AM +0800, Shaoqin Huang wrote:

[...]

> > > > +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
> > > > +                 u64 val)
> > > > +{
> > > > +     struct kvm *kvm = vcpu->kvm;
> > > > +     u64 new_n, mutable_mask;
> > > > +     int ret = 0;
> > > > +
> > > > +     new_n = FIELD_GET(ARMV8_PMU_PMCR_N, val);
> > > > +
> > > > +     mutex_lock(&kvm->arch.config_lock);
> > > > +     if (unlikely(new_n != kvm->arch.pmcr_n)) {
> > > > +             /*
> > > > +              * The vCPU can't have more counters than the PMU
> > > > +              * hardware implements.
> > > > +              */
> > > > +             if (new_n <= kvm->arch.pmcr_n_limit)
> > > > +                     kvm->arch.pmcr_n = new_n;
> > > > +             else
> > > > +                     ret = -EINVAL;
> > > > +     }
> > > 
> > > Since we have set the default value of pmcr_n, if we want to set a new
> > > pmcr_n, shouldn't it be a different value?
> > > 
> > > So how about change the checking to:
> > > 
> > > if (likely(new_n <= kvm->arch.pmcr_n_limit)
> > >          kvm->arch.pmcr_n = new_n;
> > > else
> > >          ret = -EINVAL;
> > > 
> > > what do you think?
> > > 
> > Sorry, I guess I didn't fully understand your suggestion. Are you
> > saying that it's 'likely' that userspace would configure the correct
> > value?
> > 
> It depends on how userspace use this api to limit the number of pmcr. I
> think what you mean in the code is that userspace need to set every vcpu's
> pmcr to the same value, so the `unlikely` here is right, only one vcpu can
> change the kvm->arch.pmcr.n, it saves the cpu cycles.
> 
> What suggest above might be wrong. Since I think when userspace want to
> limit the number of pmcr, it may just set the new_n on one vcpu, since the
> kvm->arch.pmcr_n is a VM-local value, every vcpu can see it, so it's
> `likely` the (new_n <= kvm->arch.pmcr_n_limit), it can decrease one checking
> statement.

How about we just do away with branch hints in the first place? This is
_not_ a hot path.

-- 
Thanks,
Oliver
