Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DD21C6D1C
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 11:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgEFJkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 05:40:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728306AbgEFJkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 05:40:02 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56CAB2075E;
        Wed,  6 May 2020 09:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588758001;
        bh=PnheU1SB759b1ecFKgOFt4WnUTjCjzVdAEES0Im2Xtc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EtcPzrkg+dKsEn/zxiZdqfiIiMAg3jdP8w21mkGZg1GrxW7TqJqSFSW6NUYyq16jD
         jhC9kvc6joqytrdElp4LjrtbTnUjLDtCf6b6UTAGwZDaQULMpC479xmeoZvCDYSlQJ
         VPObgH6EMZ79giLTHPXYGwbJ3OnwgooE3ClKJfdk=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jWGX1-009uGa-OB; Wed, 06 May 2020 10:39:59 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 06 May 2020 10:39:59 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Scull <ascull@google.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 05/26] arm64: Document SW reserved PTE/PMD bits in Stage-2
 descriptors
In-Reply-To: <20200505155916.GB237572@google.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-6-maz@kernel.org>
 <20200505155916.GB237572@google.com>
User-Agent: Roundcube Webmail/1.4.3
Message-ID: <8b399c95ca1393e63cc1077ede8a45f6@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ascull@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, will@kernel.org, andre.przywara@arm.com, Dave.Martin@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andrew,

On 2020-05-05 16:59, Andrew Scull wrote:
> On Wed, Apr 22, 2020 at 01:00:29PM +0100, Marc Zyngier wrote:
>> Advertise bits [58:55] as reserved for SW in the S2 descriptors.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/include/asm/pgtable-hwdef.h | 2 ++
>>  1 file changed, 2 insertions(+)
>> 
>> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h 
>> b/arch/arm64/include/asm/pgtable-hwdef.h
>> index 6bf5e650da788..7eab0d23cdb52 100644
>> --- a/arch/arm64/include/asm/pgtable-hwdef.h
>> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
>> @@ -177,10 +177,12 @@
>>  #define PTE_S2_RDONLY		(_AT(pteval_t, 1) << 6)   /* HAP[2:1] */
>>  #define PTE_S2_RDWR		(_AT(pteval_t, 3) << 6)   /* HAP[2:1] */
>>  #define PTE_S2_XN		(_AT(pteval_t, 2) << 53)  /* XN[1:0] */
>> +#define PTE_S2_SW_RESVD		(_AT(pteval_t, 15) << 55) /* Reserved for SW 
>> */
>> 
>>  #define PMD_S2_RDONLY		(_AT(pmdval_t, 1) << 6)   /* HAP[2:1] */
>>  #define PMD_S2_RDWR		(_AT(pmdval_t, 3) << 6)   /* HAP[2:1] */
>>  #define PMD_S2_XN		(_AT(pmdval_t, 2) << 53)  /* XN[1:0] */
>> +#define PMD_S2_SW_RESVD		(_AT(pmdval_t, 15) << 55) /* Reserved for SW 
>> */
>> 
>>  #define PUD_S2_RDONLY		(_AT(pudval_t, 1) << 6)   /* HAP[2:1] */
>>  #define PUD_S2_RDWR		(_AT(pudval_t, 3) << 6)   /* HAP[2:1] */
>> --
>> 2.26.1
>> 
>> _______________________________________________
>> kvmarm mailing list
>> kvmarm@lists.cs.columbia.edu
>> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
> This is consistent with "Attribute fields in stage 1 VMSAv8-64 Block 
> and
> Page descriptors"

Do you mean "stage 2" instead? The reserved bits are the same, but I 
want
to be sure we have looked at the same thing (ARM DDI 0487F.a, D5-2603).

> Reviewed-by: Andrew Scull <ascull@google.com>

Thanks,

          M.
-- 
Jazz is not dead. It just smells funny...
