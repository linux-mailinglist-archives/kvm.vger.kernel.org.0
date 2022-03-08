Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A543A4D14B1
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 11:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345816AbiCHK2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 05:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345820AbiCHK2x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 05:28:53 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC39963E0
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 02:27:53 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EFDC21FB;
        Tue,  8 Mar 2022 02:27:52 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CC43C3F66F;
        Tue,  8 Mar 2022 02:27:51 -0800 (PST)
Date:   Tue, 8 Mar 2022 10:28:17 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Sebastian Ene <sebastianene@google.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, will@kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH kvmtool v8 1/3] aarch64: Populate the vCPU struct before
 target->init()
Message-ID: <YicvwRlojrgSSrdU@monolith.localdoman>
References: <20220307144243.2039409-1-sebastianene@google.com>
 <20220307144243.2039409-2-sebastianene@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307144243.2039409-2-sebastianene@google.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Mon, Mar 07, 2022 at 02:42:42PM +0000, Sebastian Ene wrote:
> Move the vCPU structure initialisation before the target->init() call to
>  keep a reference to the kvm structure during init().
> This is required by the pvtime peripheral to reserve a memory region
> while the vCPU is beeing initialised.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>

I think you're missing Marc's Reviewed-by tag.

Thanks,
Alex

> ---
>  arm/kvm-cpu.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
> index 6a2408c..84ac1e9 100644
> --- a/arm/kvm-cpu.c
> +++ b/arm/kvm-cpu.c
> @@ -116,6 +116,13 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
>  			die("Unable to find matching target");
>  	}
>  
> +	/* Populate the vcpu structure. */
> +	vcpu->kvm		= kvm;
> +	vcpu->cpu_id		= cpu_id;
> +	vcpu->cpu_type		= vcpu_init.target;
> +	vcpu->cpu_compatible	= target->compatible;
> +	vcpu->is_running	= true;
> +
>  	if (err || target->init(vcpu))
>  		die("Unable to initialise vcpu");
>  
> @@ -125,13 +132,6 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
>  		vcpu->ring = (void *)vcpu->kvm_run +
>  			     (coalesced_offset * PAGE_SIZE);
>  
> -	/* Populate the vcpu structure. */
> -	vcpu->kvm		= kvm;
> -	vcpu->cpu_id		= cpu_id;
> -	vcpu->cpu_type		= vcpu_init.target;
> -	vcpu->cpu_compatible	= target->compatible;
> -	vcpu->is_running	= true;
> -
>  	if (kvm_cpu__configure_features(vcpu))
>  		die("Unable to configure requested vcpu features");
>  
> -- 
> 2.35.1.616.g0bdcbb4464-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
