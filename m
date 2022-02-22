Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296AA4BFAC2
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 15:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbiBVOTL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 09:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiBVOTK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 09:19:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EB3151C66
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 06:18:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38AC061459
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 14:18:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D0AC340E8;
        Tue, 22 Feb 2022 14:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645539522;
        bh=7cw4R3Ol0X8UAb8/9sduQyHakdRsA3bDg2PkrRfxfPo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KoJ7cpFs4vZhHIhc8qtj2sMJEDsc38F61FpYeVrbJ7Ie/EEKeqvYDm8WpDBaSsgVv
         pALQLwfPw+SG7BMI14fn1c4vB6v3Ufv/AZfLb66U2L64qgaRYthdiTfkW6Qu+VJS1J
         RUUxTekZNCAF+2FtepHhyEg4KIUUKBgX69NeX5XTQBG3+E0tg3snCnVoYVQXYPz3ww
         lOwQ63pVdak79dtQmAjWtT/ZswL2abenEGUHWlGDUIZSUUHlNkzwG2l0Ut9G4A8gvo
         ngtbJMe0smPFor9KoPB4QojqAseAsLjBnIMn6bv3Q/a0dyTQdu0//mbRtEHxvbzi+U
         hbw9p45IixcgQ==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nMW00-009Yjv-5w; Tue, 22 Feb 2022 14:18:40 +0000
MIME-Version: 1.0
Date:   Tue, 22 Feb 2022 14:18:40 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Sebastian Ene <sebastianene@google.com>, kvm@vger.kernel.org,
        will@kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH kvmtool v3] aarch64: Add stolen time support
In-Reply-To: <YhTsGfoAh4NDo8+j@monolith.localdoman>
References: <YhS2Htrzwks/allO@google.com>
 <YhTsGfoAh4NDo8+j@monolith.localdoman>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <d5a3d28a964813bd28c79c63e8e3b247@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, sebastianene@google.com, kvm@vger.kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-02-22 13:58, Alexandru Elisei wrote:
> Hi,
> 
> On Tue, Feb 22, 2022 at 10:08:30AM +0000, Sebastian Ene wrote:
>> This patch adds support for stolen time by sharing a memory region
>> with the guest which will be used by the hypervisor to store the 
>> stolen
>> time information. The exact format of the structure stored by the
>> hypervisor is described in the ARM DEN0057A document.
>> 
>> Signed-off-by: Sebastian Ene <sebastianene@google.com>
>> ---
>>  Changelog since v2:
>>  - Moved the AARCH64_PVTIME_* definitions from arm-common/kvm-arch.h 
>> to
>>    arm64/pvtime.c as pvtime is only available for arm64.
>> 
>>  Changelog since v1:
>>  - Removed the pvtime.h header file and moved the definitions to 
>> kvm-cpu-arch.h
>>    Verified if the stolen time capability is supported before 
>> allocating
>>    and mapping the memory.
>> 
>>  Makefile                               |  1 +
>>  arm/aarch64/arm-cpu.c                  |  1 +
>>  arm/aarch64/include/kvm/kvm-cpu-arch.h |  1 +
>>  arm/aarch64/pvtime.c                   | 89 
>> ++++++++++++++++++++++++++
>>  arm/kvm-cpu.c                          | 14 ++--
>>  5 files changed, 99 insertions(+), 7 deletions(-)
>>  create mode 100644 arm/aarch64/pvtime.c
>> 
>> diff --git a/Makefile b/Makefile
>> index f251147..e9121dc 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -182,6 +182,7 @@ ifeq ($(ARCH), arm64)
>>  	OBJS		+= arm/aarch64/arm-cpu.o
>>  	OBJS		+= arm/aarch64/kvm-cpu.o
>>  	OBJS		+= arm/aarch64/kvm.o
>> +	OBJS		+= arm/aarch64/pvtime.o
>>  	ARCH_INCLUDE	:= $(HDRS_ARM_COMMON)
>>  	ARCH_INCLUDE	+= -Iarm/aarch64/include
>> 
>> diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
>> index d7572b7..326fb20 100644
>> --- a/arm/aarch64/arm-cpu.c
>> +++ b/arm/aarch64/arm-cpu.c
>> @@ -22,6 +22,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm 
>> *kvm)
>>  static int arm_cpu__vcpu_init(struct kvm_cpu *vcpu)
>>  {
>>  	vcpu->generate_fdt_nodes = generate_fdt_nodes;
>> +	kvm_cpu__setup_pvtime(vcpu);
>>  	return 0;
>>  }
>> 
>> diff --git a/arm/aarch64/include/kvm/kvm-cpu-arch.h 
>> b/arm/aarch64/include/kvm/kvm-cpu-arch.h
>> index 8dfb82e..b57d6e6 100644
>> --- a/arm/aarch64/include/kvm/kvm-cpu-arch.h
>> +++ b/arm/aarch64/include/kvm/kvm-cpu-arch.h
>> @@ -19,5 +19,6 @@
>> 
>>  void kvm_cpu__select_features(struct kvm *kvm, struct kvm_vcpu_init 
>> *init);
>>  int kvm_cpu__configure_features(struct kvm_cpu *vcpu);
>> +void kvm_cpu__setup_pvtime(struct kvm_cpu *vcpu);
>> 
>>  #endif /* KVM__KVM_CPU_ARCH_H */
>> diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
>> new file mode 100644
>> index 0000000..247e4f3
>> --- /dev/null
>> +++ b/arm/aarch64/pvtime.c
>> @@ -0,0 +1,89 @@
>> +#include "kvm/kvm.h"
>> +#include "kvm/kvm-cpu.h"
>> +#include "kvm/util.h"
>> +
>> +#include <linux/byteorder.h>
>> +#include <linux/types.h>
>> +
>> +#define AARCH64_PVTIME_IPA_MAX_SIZE	SZ_64K
>> +#define AARCH64_PVTIME_IPA_START	(ARM_MEMORY_AREA - \
>> +					 AARCH64_PVTIME_IPA_MAX_SIZE)
> 
> This doesn't change the fact that it overlaps with KVM_PCI_MMIO_AREA, 
> which is
> exposed to the guest in the DTB (see my reply to v2).

Yup, this is a bit of a problem, and overlapping regions are
a big no-no. Why can't the pvtime region be dynamically placed
after the RAM (after checking that there is enough space to
register it in the IPA space)?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
