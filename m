Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB4D13C466
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 14:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgAON7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 08:59:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:50846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729256AbgAON67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 08:58:59 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EF70222C3;
        Wed, 15 Jan 2020 13:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579096738;
        bh=/G/weRCXbYPuSwrN2fOcmc9IMAtSW0V+wjMZcxSDxn8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ytuEmCKm0MYbr4DkGoe+3o7uNRCJlGbBzyN9FYICsCn4CppE/loxARmvmoz3h42Zd
         eH2gDh7+8+YPfaMiBYxAqP1E00+AMdDHCoZK7X6psiKuA0FLaczA+NAMD1rlE7dpjT
         O23E6godf3BYjzVUVq+n0cB/xaE4WRfxm0dcYl64=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1irjCC-0000PM-CF; Wed, 15 Jan 2020 13:58:56 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 15 Jan 2020 13:58:56 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        christoffer.dall@arm.com, catalin.marinas@arm.com,
        eric.auger@redhat.com, gregkh@linuxfoundation.org, will@kernel.org,
        andre.przywara@arm.com, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: get rid of var ret and out jump label in
 kvm_arch_vcpu_ioctl_set_guest_debug()
In-Reply-To: <ab61de3a04a74f74866683b062d0bab2@huawei.com>
References: <ab61de3a04a74f74866683b062d0bab2@huawei.com>
Message-ID: <728a5ea123bf6f55b1653e4ccac76175@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: linmiaohe@huawei.com, pbonzini@redhat.com, rkrcmar@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, christoffer.dall@arm.com, catalin.marinas@arm.com, eric.auger@redhat.com, gregkh@linuxfoundation.org, will@kernel.org, andre.przywara@arm.com, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-01-14 02:20, linmiaohe wrote:
> Friendly ping :)

Friendly reply:

>> From: Miaohe Lin <linmiaohe@huawei.com>
>> 
>> The var ret and out jump label is not really needed. Clean them up.
>> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>> ---
>>  arch/arm64/kvm/guest.c | 11 +++--------
>>  1 file changed, 3 insertions(+), 8 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c index 
>> 2fff06114a8f..3b836c91609e 100644
>> --- a/arch/arm64/kvm/guest.c
>> +++ b/arch/arm64/kvm/guest.c
>> @@ -834,14 +834,10 @@ int kvm_arch_vcpu_ioctl_translate(struct 
>> kvm_vcpu *vcpu,  int kvm_arch_vcpu_ioctl_set_guest_debug(struct 
>> kvm_vcpu *vcpu,
>>  					struct kvm_guest_debug *dbg)
>>  {
>> -	int ret = 0;
>> -
>>  	trace_kvm_set_guest_debug(vcpu, dbg->control);
>> 
>> -	if (dbg->control & ~KVM_GUESTDBG_VALID_MASK) {
>> -		ret = -EINVAL;
>> -		goto out;
>> -	}
>> +	if (dbg->control & ~KVM_GUESTDBG_VALID_MASK)
>> +		return -EINVAL;
>> 
>>  	if (dbg->control & KVM_GUESTDBG_ENABLE) {
>>  		vcpu->guest_debug = dbg->control;
>> @@ -856,8 +852,7 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct 
>> kvm_vcpu *vcpu,
>>  		vcpu->guest_debug = 0;
>>  	}
>> 
>> -out:
>> -	return ret;
>> +	return 0;

I don't think there is anything wrong with the existing code.
It may not be to your own taste, but is in keeping with a lot
of the KVM code.

If you were making changes to this code, I wouldn't object.
But on its own, this is just churn.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
