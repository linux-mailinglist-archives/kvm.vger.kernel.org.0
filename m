Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE912C886B
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 16:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbgK3Pk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 10:40:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgK3Pk7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 10:40:59 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F880206C0;
        Mon, 30 Nov 2020 15:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606750818;
        bh=xvn4o/Ps2MmjI/dRiv8oM22Yyzf+9XlrLVdNZNcgBko=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kSS5E+WkPTc5oeXpPcINZm3eSBnDfvMq4J4iFv4rFWgZE78tctxrEWiefyOS7HuLy
         RIanrltHcrVOvGM/Tc+oyVthAQAS0lEOEmZAcg7+U0L8R7oL2yr3PXWF2pNi/Rzmjm
         WDvG8Hbkk7BplkrnRgmyn4gSEjGfR2v17P2sLvLU=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kjlHk-00Ejeo-7O; Mon, 30 Nov 2020 15:40:16 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 30 Nov 2020 15:40:16 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     David Brazdil <dbrazdil@google.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 2/2] KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV3=1 if the
 CPUs are Meltdown-safe
In-Reply-To: <20201130152655.oyzs2l4qg2pfzxmv@google.com>
References: <20201128124659.669578-1-maz@kernel.org>
 <20201128124659.669578-3-maz@kernel.org>
 <20201130152655.oyzs2l4qg2pfzxmv@google.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <4a398347b173c5c1a7a0ebd4b54a64bd@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: dbrazdil@google.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi David,

On 2020-11-30 15:26, David Brazdil wrote:
>> @@ -1227,9 +1229,16 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu 
>> *vcpu,
>>  	    (csv2 && arm64_get_spectre_v2_state() != SPECTRE_UNAFFECTED))
>>  		return -EINVAL;
>> 
>> -	/* We can only differ with CSV2, and anything else is an error */
>> +	/* Same thing for CSV3 */
>> +	csv3 = cpuid_feature_extract_unsigned_field(val, 
>> ID_AA64PFR0_CSV3_SHIFT);
>> +	if (csv3 > 1 ||
>> +	    (csv3 && arm64_get_meltdown_state() != SPECTRE_UNAFFECTED))
>> +		return -EINVAL;
>> +
>> +	/* We can only differ with CSV[23], and anything else is an error */
>>  	val ^= read_id_reg(vcpu, rd, false);
>> -	val &= ~(0xFUL << ID_AA64PFR0_CSV2_SHIFT);
>> +	val &= ~((0xFUL << ID_AA64PFR0_CSV2_SHIFT) ||
>> +		 (0xFUL << ID_AA64PFR0_CSV3_SHIFT));
> 
> That boolean OR looks like a typo.

It definitely is. Who the hell is writing this code?

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
