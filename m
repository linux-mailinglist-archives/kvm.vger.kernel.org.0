Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A86622F6A3
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 19:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730808AbgG0R3x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 13:29:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:51132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbgG0R3w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 13:29:52 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 229F920714;
        Mon, 27 Jul 2020 17:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595870992;
        bh=fqWwMELSuy+/qFam4pMh5T7zeLs7KMWf9QveNurGOnU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D5iBwBIKBnxBJrFCHIAlJZ8pGmqz7+/+B3fXLnLR5OCBI+o9EfTdIMCO93+9OJlqz
         GNQnRRmkwWUaCe3jUucrvPQ+eyHjrElHTg0V0jmUIOevFtQYZ+AYKvDMQeYQZd6av6
         6ZRwk6dLx/EEG9ml6CnCBvci3qdgYRYhRr2hY4L0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k06wg-00FNfw-Nz; Mon, 27 Jul 2020 18:29:50 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 27 Jul 2020 18:29:50 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, steven.price@arm.com
Subject: Re: [PATCH 2/5] KVM: arm64: pvtime: Fix potential loss of stolen time
In-Reply-To: <20200711100434.46660-3-drjones@redhat.com>
References: <20200711100434.46660-1-drjones@redhat.com>
 <20200711100434.46660-3-drjones@redhat.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <9044c568f04a2f8e99c548acbb85db4a@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, steven.price@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-07-11 11:04, Andrew Jones wrote:
> We should only check current->sched_info.run_delay once when
> updating stolen time. Otherwise there's a chance there could
> be a change between checks that we miss (preemption disabling
> comes after vcpu request checks).
> 
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/arm64/kvm/pvtime.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/pvtime.c b/arch/arm64/kvm/pvtime.c
> index 2b22214909be..db5ef097a166 100644
> --- a/arch/arm64/kvm/pvtime.c
> +++ b/arch/arm64/kvm/pvtime.c
> @@ -13,6 +13,7 @@
>  void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm *kvm = vcpu->kvm;
> +	u64 last_steal = vcpu->arch.steal.last_steal;
>  	u64 steal;
>  	__le64 steal_le;
>  	u64 offset;
> @@ -24,8 +25,8 @@ void kvm_update_stolen_time(struct kvm_vcpu *vcpu)
> 
>  	/* Let's do the local bookkeeping */
>  	steal = vcpu->arch.steal.steal;
> -	steal += current->sched_info.run_delay - vcpu->arch.steal.last_steal;
>  	vcpu->arch.steal.last_steal = current->sched_info.run_delay;
> +	steal += vcpu->arch.steal.last_steal - last_steal;
>  	vcpu->arch.steal.steal = steal;
> 
>  	steal_le = cpu_to_le64(steal);

Unless you read current->sched_info.run_delay using READ_ONCE,
there is no guarantee that this will do what you want. The
compiler is free to rejig this anyway it wants.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
