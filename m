Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03FA7657EC
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 17:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233382AbjG0Pm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 11:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbjG0Pm1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 11:42:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F1F2736
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 08:42:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCA0561EC2
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 15:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DE2C433CA;
        Thu, 27 Jul 2023 15:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690472536;
        bh=4KKGe8/tL2e7AyuNIyEcxwJSBh1LF8WzR7yHl+lFyDs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kPjEDml6qyUkAUkLyK1muIzmzWolQgw0SxPcAGUeGRVDr4ZXSCQEW5OWgZCqE/ta2
         gZUh/NPr9hbsDRPPqK7PmFP3vJKcjt9f10pXaTQ3FKDMuA+VzcMImnflWHF0BLE2y7
         LCVpseuM/MVnb4AdGrlODvBytCBubgpG4ZNDE1SKjOEQwz09tvaXYxOeadHHzZBtA+
         Ro/xbd6uavv3lEkNskU3XNwv/8MzaYYIEBr/raLeGaGVtpv9bYvI9ohk0PF3gATq6p
         oo90fZIyp/l9LHbgmOqh831caDuSYTBHvsPTLcKEb+mpMt6lQfX0OaxmWpj91RDnbL
         4q8LTVfD3lVQg==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qP381-00HOsQ-R9;
        Thu, 27 Jul 2023 16:42:13 +0100
MIME-Version: 1.0
Date:   Thu, 27 Jul 2023 16:42:08 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH 06/27] arm64: Add debug registers affected by HDFGxTR_EL2
In-Reply-To: <0c26ba18-1d82-b9c0-3643-bd8e4d2f58f4@arm.com>
References: <20230712145810.3864793-1-maz@kernel.org>
 <20230712145810.3864793-7-maz@kernel.org>
 <0c26ba18-1d82-b9c0-3643-bd8e4d2f58f4@arm.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <6e855aa9b49000edd555c75d206cc777@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: suzuki.poulose@arm.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, james.morse@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, anshuman.khandual@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-07-19 12:00, Suzuki K Poulose wrote:
> Hi Marc
> 
> On 12/07/2023 15:57, Marc Zyngier wrote:
>> The HDFGxTR_EL2 registers trap a (huge) set of debug and trace
>> related registers. Add their encodings (and only that, because
>> we really don't care about what these registers actually do at
>> this stage).
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>   arch/arm64/include/asm/sysreg.h | 78 
>> +++++++++++++++++++++++++++++++++
>>   1 file changed, 78 insertions(+)
>> 
>> diff --git a/arch/arm64/include/asm/sysreg.h 
>> b/arch/arm64/include/asm/sysreg.h
>> index 76289339b43b..9dfd127be55a 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -194,6 +194,84 @@
>>   #define SYS_DBGDTRTX_EL0		sys_reg(2, 3, 0, 5, 0)
>>   #define SYS_DBGVCR32_EL2		sys_reg(2, 4, 0, 7, 0)
>>   +#define SYS_BRBINF_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 
>> 2) | 0))
>> +#define SYS_BRBINFINJ_EL1		sys_reg(2, 1, 9, 1, 0)
>> +#define SYS_BRBSRC_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 
>> 2) | 1))
>> +#define SYS_BRBSRCINJ_EL1		sys_reg(2, 1, 9, 1, 1)
>> +#define SYS_BRBTGT_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 
>> 2) | 2))
>> +#define SYS_BRBTGTINJ_EL1		sys_reg(2, 1, 9, 1, 2)
>> +#define SYS_BRBTS_EL1			sys_reg(2, 1, 9, 0, 2)
>> +
>> +#define SYS_BRBCR_EL1			sys_reg(2, 1, 9, 0, 0)
>> +#define SYS_BRBFCR_EL1			sys_reg(2, 1, 9, 0, 1)
>> +#define SYS_BRBIDR0_EL1			sys_reg(2, 1, 9, 2, 0)
>> +
> 
> Merge conflict alert. The above are being added as part of the BRBE
> support series from Anshuman [0], though in a slightly different
> scheme
> for registers with numbers. e.g, SYS_BRBINF_EL1(0) vs SYS_BRBINF0_EL1.
> That series is not merged yet, but might go in this cycle.

Thanks for the heads up!

I'm pretty confident that this will not conflict too badly, as the
#defines are different. But I can always drag a prefix of Anshuman's
series into the KVM tree and resolve it there.

Cheers,

         M.
-- 
Jazz is not dead. It just smells funny...
