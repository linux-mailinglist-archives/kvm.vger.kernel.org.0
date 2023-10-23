Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E887D3F35
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 20:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbjJWSZD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 14:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbjJWSZC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 14:25:02 -0400
Received: from out-199.mta0.migadu.com (out-199.mta0.migadu.com [91.218.175.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A2210D;
        Mon, 23 Oct 2023 11:24:59 -0700 (PDT)
Date:   Mon, 23 Oct 2023 18:24:50 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698085497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QChXizP9EOxkwbrFQch52NiZrZiX3EIsRZVyKac4G8c=;
        b=iGsEJTbQ/pmMU0i2n2T//fvlwiheDsxmxNhjnWiFSsNvn4EPsecSVhGKbgbtV895dlfywq
        IFjdHTrBHuojcaQo0vPWHH9hRFTHd4Lqd1F5YmaOKrheubFebH5vabBSjt7EM/OUgS6urb
        MG1CLX6vy1Wu+Y/7MI/oyahdTxTzOPk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Raghavendra Rao Ananta <rananta@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v8 02/13] KVM: arm64: PMU: Set the default PMU for the
 guest before vCPU reset
Message-ID: <ZTa6cigtBpyq5IwD@linux.dev>
References: <20231020214053.2144305-1-rananta@google.com>
 <20231020214053.2144305-3-rananta@google.com>
 <8634y162q5.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8634y162q5.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 11:40:50AM +0100, Marc Zyngier wrote:

[...]

> > +static int kvm_setup_vcpu(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm *kvm = vcpu->kvm;
> > +
> > +	/*
> > +	 * When the vCPU has a PMU, but no PMU is set for the guest
> > +	 * yet, set the default one.
> > +	 */
> > +	if (kvm_vcpu_has_pmu(vcpu) && !kvm->arch.arm_pmu &&
> > +	    kvm_arm_set_default_pmu(kvm))
> > +		return -EINVAL;
> 
> nit: I'm not keen on re-interpreting the error code. If
> kvm_arm_set_default_pmu() returns an error, we should return *that*
> particular error, and not any other. Something like:

The code took this shape because I had an issue with returning ENODEV on
the KVM_ARM_VCPU_INIT ioctl, which is not a documented error code.
Now that the vCPU flags are sanitised early in the ioctl, KVM has
decided at this point that vPMU is a supported feature.

Given that, I think ENODEV is fine now as the unexpected return value
would indicate a bug in KVM.

> Hmmm. Contrary to what the commit message says, the default PMU is not
> picked at reset time, but at the point where the target is set (the
> very first vcpu init). Which is pretty different from reset, which
> happens more than once.
> 
> I also can't say I'm over the moon with yet another function that does
> a very tiny bit of initialisation outside of the rest of the code that
> performs the vcpu init. Following things is an absolute maze...

I'm fine with this being inlined into __kvm_vcpu_set_target() so long as
we maintain the clear distinction between one-time setup and vCPU reset.

-- 
Thanks,
Oliver
