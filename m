Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665792634F6
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 19:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgIIRur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 13:50:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbgIIRur (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 13:50:47 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 138DE218AC;
        Wed,  9 Sep 2020 17:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599673846;
        bh=pHkoGN/SrAl75I0SSLoE/8IUrQFIq3+oTpQRBnqBWCo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mxP9a4GO903rCGGzFFUdjWtiAtfijqoExzGe4sxhZjm/AOmgiSJ6bLkutsIOKoiNW
         Y1y+YYlyfA+eN2FNKxaPyN4huEE5yU+BdqKlRTLLADQNCu2oCtQNEHi7zrHbaOd2WX
         gzU8k0kCnREInSmgCUlqmx5TrXKiLMOGpIgHJ3uM=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1kG4F1-00ARBT-UW; Wed, 09 Sep 2020 18:50:44 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 09 Sep 2020 18:50:43 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, graf@amazon.com,
        kernel-team@android.com
Subject: Re: [PATCH v3 4/5] KVM: arm64: Mask out filtered events in
 PCMEID{0,1}_EL1
In-Reply-To: <735f5464-3a45-8dc0-c330-ac5632bcb4b4@redhat.com>
References: <20200908075830.1161921-1-maz@kernel.org>
 <20200908075830.1161921-5-maz@kernel.org>
 <735f5464-3a45-8dc0-c330-ac5632bcb4b4@redhat.com>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <dde5292adce235bea39bc927c1256bc8@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, robin.murphy@arm.com, mark.rutland@arm.com, graf@amazon.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2020-09-09 18:43, Auger Eric wrote:
> Hi Marc,
> 
> On 9/8/20 9:58 AM, Marc Zyngier wrote:
>> As we can now hide events from the guest, let's also adjust its view 
>> of
>> PCMEID{0,1}_EL1 so that it can figure out why some common events are 
>> not
>> counting as they should.
> Referring to my previous comment should we filter the cycle counter 
> out?
>> 
>> The astute user can still look into the TRM for their CPU and find out
>> they've been cheated, though. Nobody's perfect.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/kvm/pmu-emul.c | 29 +++++++++++++++++++++++++++++
>>  arch/arm64/kvm/sys_regs.c |  5 +----
>>  include/kvm/arm_pmu.h     |  5 +++++
>>  3 files changed, 35 insertions(+), 4 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>> index 67a731bafbc9..0458860bade2 100644
>> --- a/arch/arm64/kvm/pmu-emul.c
>> +++ b/arch/arm64/kvm/pmu-emul.c
>> @@ -765,6 +765,35 @@ static int kvm_pmu_probe_pmuver(void)
>>  	return pmuver;
>>  }
>> 
>> +u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
>> +{
>> +	unsigned long *bmap = vcpu->kvm->arch.pmu_filter;
>> +	u64 val, mask = 0;
>> +	int base, i;
>> +
>> +	if (!pmceid1) {
>> +		val = read_sysreg(pmceid0_el0);
>> +		base = 0;
>> +	} else {
>> +		val = read_sysreg(pmceid1_el0);
>> +		base = 32;
>> +	}
>> +
>> +	if (!bmap)
>> +		return val;
>> +
>> +	for (i = 0; i < 32; i += 8) {
> s/32/4?

I don't think so, see below.

> 
> Thanks
> 
> Eric
>> +		u64 byte;
>> +
>> +		byte = bitmap_get_value8(bmap, base + i);
>> +		mask |= byte << i;

For each iteration of the loop, we read a byte from the bitmap
(hence the += 8 above), and orr it into the mask. This makes 4
iteration of the loop.

Or am I missing your point entirely?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
