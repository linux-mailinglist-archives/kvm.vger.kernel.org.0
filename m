Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99744BA188
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 14:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241210AbiBQNlY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 08:41:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241192AbiBQNlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 08:41:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3D42AF935
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 05:40:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35963B821A6
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 13:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4782C340E9;
        Thu, 17 Feb 2022 13:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645105255;
        bh=Ss67S13WIbOTQNO32Um4TEuBFG3UFPz44UqCkkF0YeY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tNXUrNV6GCVRn8Exm/tkHGSQNU2vydVaAUyZUS4vmCWuVjZSKfQgFNoktfJ0yncsC
         wNjmdHax6vkMTfzCSQiVAXfhQN4hFOJ+ddKZwLCBKqtnqug/N1GNd/7UDPTkrqjDOP
         1NJ+wpj+kiIan6fWo+4irQpE2/THtRLB3VQ3d40wNA+EETfw+1pCg9/q2tSMF/v2fX
         omlbfcmxXlVFxvI5cfyhiPFGlOJIfjufhhlVsZ+vwbV+4+jcrr7ch2xSmBthbPx6Cr
         0Qe7O57eRV9tqgTfcxmZoLId0d+ZYasoidhx6mwm6+DcPcg6kgu+tcwqVKSN+iNIaL
         uZ+CYoBONIcUA==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nKh1h-008a8W-Hp; Thu, 17 Feb 2022 13:40:53 +0000
MIME-Version: 1.0
Date:   Thu, 17 Feb 2022 13:40:53 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: arm64: Don't miss pending interrupts for suspended
 vCPU
In-Reply-To: <20220217101242.3013716-1-oupton@google.com>
References: <20220217101242.3013716-1-oupton@google.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <aa6851d90aeb0dfade28527687253219@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: oupton@google.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, pshier@google.com, ricarkol@google.com, reijiw@google.com, pbonzini@redhat.com, seanjc@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-02-17 10:12, Oliver Upton wrote:
> In order to properly emulate the WFI instruction, KVM reads back
> ICH_VMCR_EL2 and enables doorbells for GICv4. These preparations are
> necessary in order to recognize pending interrupts in
> kvm_arch_vcpu_runnable() and return to the guest. Until recently, this
> work was done by kvm_arch_vcpu_{blocking,unblocking}(). Since commit
> 6109c5a6ab7f ("KVM: arm64: Move vGIC v4 handling for WFI out arch
> callback hook"), these callbacks were gutted and superseded by
> kvm_vcpu_wfi().
> 
> It is important to note that KVM implements PSCI CPU_SUSPEND calls as
> a WFI within the guest. However, the implementation calls directly into
> kvm_vcpu_halt(), which skips the needed work done in kvm_vcpu_wfi()
> to detect pending interrupts. Fix the issue by calling the WFI helper.
> 
> Fixes: 6109c5a6ab7f ("KVM: arm64: Move vGIC v4 handling for WFI out
> arch callback hook")
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/kvm/psci.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 3eae32876897..2ce60fecd861 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -46,8 +46,7 @@ static unsigned long kvm_psci_vcpu_suspend(struct
> kvm_vcpu *vcpu)
>  	 * specification (ARM DEN 0022A). This means all suspend states
>  	 * for KVM will preserve the register state.
>  	 */
> -	kvm_vcpu_halt(vcpu);
> -	kvm_clear_request(KVM_REQ_UNHALT, vcpu);
> +	kvm_vcpu_wfi(vcpu);
> 
>  	return PSCI_RET_SUCCESS;
>  }

Thanks for picking this up, I kept forgetting about fixing it.
I'll merge it once I'm back home.

         M.
-- 
Jazz is not dead. It just smells funny...
