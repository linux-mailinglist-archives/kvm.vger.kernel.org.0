Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B7973048B
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 18:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbjFNQFh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 12:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbjFNQFe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 12:05:34 -0400
Received: from out-37.mta0.migadu.com (out-37.mta0.migadu.com [IPv6:2001:41d0:1004:224b::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975FA1FCA
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 09:05:29 -0700 (PDT)
Date:   Wed, 14 Jun 2023 16:05:16 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Joey Gouly <joey.gouly@arm.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Salil Mehta <salil.mehta@huawei.com>, nd@arm.com
Subject: Re: [PATCH kvmtool 00/21] arm64: Handle PSCI calls in userspace
Message-ID: <ZInlPE/J7W/FLX6P@linux.dev>
References: <20230526221712.317287-1-oliver.upton@linux.dev>
 <20230614120503.GA3015626@e124191.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230614120503.GA3015626@e124191.cambridge.arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Joey,

Thanks for the review and taking the patches for a spin.

On Wed, Jun 14, 2023 at 01:05:03PM +0100, Joey Gouly wrote:
> `kvm_cpu__configure_features` in kvmtool is failing because Linux returns an
> error if SVE was already finalised (arch/arm64/kvm/reset.c):
> 
> ```
> int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature)
> {
>         switch (feature) {
>         case KVM_ARM_VCPU_SVE:
>                 if (!vcpu_has_sve(vcpu))
>                         return -EINVAL;
> 
>                 if (kvm_arm_vcpu_sve_finalized(vcpu))
>                         return -EPERM; // <---- returns here
> 
>                 return kvm_vcpu_finalize_sve(vcpu);
>         }
> 
>         return -EINVAL;
> }
> ```
> 
> It's not immediately obvious to me why finalising SVE twice is an error.
> Changing that to `return 0;` gets the test passing, but not sure if there
> are other implications.

This is utterly mindless on my part, apologies. The SVE feature
shouldn't be finalised (again). I'll probably drop patch 8 altogether
and replace its usage with a direct call to KVM_ARM_VCPU_INIT.

-- 
Thanks,
Oliver
