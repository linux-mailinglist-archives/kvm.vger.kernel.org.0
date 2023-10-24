Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8F87D4B5F
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 10:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbjJXI7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 04:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbjJXI7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 04:59:41 -0400
Received: from out-196.mta1.migadu.com (out-196.mta1.migadu.com [95.215.58.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25FF110
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 01:59:38 -0700 (PDT)
Date:   Tue, 24 Oct 2023 08:59:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698137975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=D6TYYpqy8N97kO8tVC2Cc3XTS86qRouwgud2Yw4OPK4=;
        b=oFd6EYkL7idjhlxEaG6UTiY53c5RjtDdeG3QcRHlcOHPEzg95lcPHSAzMzHXNHO0bq+jwH
        S0AjNrrfYFkVGFRIKIhvXqcpVLF/ujPhdmZwVQbJY99KGSuW/VvDTLLF9tS9aslIs6AP4R
        wBfV8EFFpLCr8xGx0f3ThQAbDEldEms=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>,
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
Subject: Re: [PATCH v8 05/13] KVM: arm64: Add {get,set}_user for
 PM{C,I}NTEN{SET,CLR}, PMOVS{SET,CLR}
Message-ID: <ZTeHcj97B8sLw6oI@linux.dev>
References: <20231020214053.2144305-1-rananta@google.com>
 <20231020214053.2144305-6-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231020214053.2144305-6-rananta@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023 at 09:40:45PM +0000, Raghavendra Rao Ananta wrote:
> For unimplemented counters, the bits in PM{C,I}NTEN{SET,CLR} and
> PMOVS{SET,CLR} registers are expected to RAZ. To honor this,
> explicitly implement the {get,set}_user functions for these
> registers to mask out unimplemented counters for userspace reads
> and writes.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/kvm/sys_regs.c | 91 ++++++++++++++++++++++++++++++++++++---
>  1 file changed, 85 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index faf97878dfbbb..2e5d497596ef8 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -987,6 +987,45 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	return true;
>  }
>  
> +static void set_pmreg_for_valid_counters(struct kvm_vcpu *vcpu,
> +					  u64 reg, u64 val, bool set)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	mutex_lock(&kvm->arch.config_lock);
> +
> +	/* Make the register immutable once the VM has started running */

This is a considerable change from the existing behavior and lacks
justification. These registers, or rather the state that these aliases
update, is mutable from the guest. I see no reason for excluding
userspace from this behavior.

> +	if (kvm_vm_has_ran_once(kvm)) {
> +		mutex_unlock(&kvm->arch.config_lock);
> +		return;
> +	}
> +
> +	val &= kvm_pmu_valid_counter_mask(vcpu);
> +	mutex_unlock(&kvm->arch.config_lock);

I'm not entirely sold on taking the config_lock here.

 - If userspace is doing these ioctls in parallel then it cannot guarantee
   ordering in the first place, even w/ locking under the hood. Any
   garbage values will be discarded by KVM_REQ_RELOAD_PMU.

 - If the VM has already started PMCR.N is immutable, so there is no
   race.

-- 
Thanks,
Oliver
