Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 532C74D0331
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 16:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241110AbiCGPpp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 10:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232892AbiCGPpn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 10:45:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAD27E082
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 07:44:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12E2BB815DE
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 15:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB323C340E9;
        Mon,  7 Mar 2022 15:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646667886;
        bh=46Iuh4M0Yx711/ZCyonyh49TOCQRaLzY7EfynwAiaHA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IT8TsGWLhuSy48KFENgmaLmx/UWUclb7gvL3aECCq9RbXVKZlugBUSzl2We/YcyJt
         s+mSEffy4c/N27MQSVwG2Uc23xMos0gjA1WVu4LvUjCdWnXZGdH76+juZOfg7KKefB
         2A+0LqoEo2dlS4cxWaTMRAFoVewSwhwRVUjr1CJoeDUmxZDobUIufbIRwmJyMOMEue
         mTmnkgk2nlaLQboEJbecW+uKs6Tjx6VfbPT5hmHQSRjc8RS6a5SOuXZ8UJvMH1LGKk
         moKQbarCusJnyG66j2u8Q7VSptFUCdNBIIrC22xuJQXjVrl8DbMhN94msfl5aqzcYU
         wnAlI74y2Qwzg==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nRFXQ-00CpTa-D8; Mon, 07 Mar 2022 15:44:44 +0000
MIME-Version: 1.0
Date:   Mon, 07 Mar 2022 15:44:43 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: Re: [PATCH v6 43/64] KVM: arm64: nv: arch_timer: Support hyp timer
 emulation
In-Reply-To: <YiYjdHbS3WeDMipR@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-44-maz@kernel.org>
 <YiYjdHbS3WeDMipR@monolith.localdoman>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <503754e615b9bc7605c379dd7f2549a1@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com, miguel.luis@oracle.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-03-07 15:23, Alexandru Elisei wrote:
> Hi,
> 
> On Fri, Jan 28, 2022 at 12:18:51PM +0000, Marc Zyngier wrote:
>> From: Christoffer Dall <christoffer.dall@arm.com>
>> 
>> Emulating EL2 also means emulating the EL2 timers. To do so, we expand
>> our timer framework to deal with at most 4 timers. At any given time,
>> two timers are using the HW timers, and the two others are purely
>> emulated.
>> 
>> The role of deciding which is which at any given time is left to a
>> mapping function which is called every time we need to make such a
>> decision.
>> 
>> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
>> [maz: added CNTVOFF support, general reworking for v4.8]
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/include/asm/kvm_host.h |   4 +
>>  arch/arm64/kvm/arch_timer.c       | 165 
>> ++++++++++++++++++++++++++++--
>>  arch/arm64/kvm/sys_regs.c         |   7 +-
>>  arch/arm64/kvm/trace_arm.h        |   6 +-
>>  arch/arm64/kvm/vgic/vgic.c        |  15 +++
>>  include/kvm/arm_arch_timer.h      |   8 +-
>>  include/kvm/arm_vgic.h            |   1 +
>>  7 files changed, 194 insertions(+), 12 deletions(-)
>> 
> [..]
>> @@ -1301,6 +1445,7 @@ static void set_timer_irqs(struct kvm *kvm, int 
>> vtimer_irq, int ptimer_irq)
>>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>>  		vcpu_vtimer(vcpu)->irq.irq = vtimer_irq;
>>  		vcpu_ptimer(vcpu)->irq.irq = ptimer_irq;
>> +		/* TODO: Add support for hv/hp timers */
>>  	}
>>  }
>> 
>> @@ -1311,6 +1456,8 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu 
>> *vcpu, struct kvm_device_attr *attr)
>>  	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>>  	int irq;
>> 
>> +	/* TODO: Add support for hv/hp timers */
> 
> Is the patch unfinished?

Just like the rest of the kernel.

         M.
-- 
Jazz is not dead. It just smells funny...
