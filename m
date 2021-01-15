Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31052F8249
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 18:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732189AbhAOR2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 12:28:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44426 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726809AbhAOR2I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 12:28:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610731601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VZBYusZAm1Is9olrKmtKLjdUp43A00Oaux7ATOrc+IQ=;
        b=eQMYWhw37sAwALhBAcTn6nUTKevzWBmKg51d1VsBwQM0oey8fSMIlnlQjejTsOHtNZW0qe
        LcMgl85WIUqtW17lgW/HV1uHsj7OXVLnGBx9a9v8wOLqyOa5a0LHHOwlsW+TGInf6ckJXy
        WWklVTLQs4wEUiGV+t7vm7Cjb0zVS78=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-Ah3VMAcvN4SiSGyadioQJQ-1; Fri, 15 Jan 2021 12:26:39 -0500
X-MC-Unique: Ah3VMAcvN4SiSGyadioQJQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC233107ACF9;
        Fri, 15 Jan 2021 17:26:37 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 37E01100AE30;
        Fri, 15 Jan 2021 17:26:34 +0000 (UTC)
Subject: Re: [PATCH 6/6] KVM: arm64: Upgrade PMU support to ARMv8.4
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20210114105633.2558739-1-maz@kernel.org>
 <20210114105633.2558739-7-maz@kernel.org>
 <ec06055b-56ad-1589-7a5d-95d9f47466ce@redhat.com>
 <28dab4367d6ced5a7d7cbc80ee77f68d@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <a0f7a8a7-81fc-282c-5b29-b037a425a8f7@redhat.com>
Date:   Fri, 15 Jan 2021 18:26:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <28dab4367d6ced5a7d7cbc80ee77f68d@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 1/15/21 5:42 PM, Marc Zyngier wrote:
> Hi Eric,
> 
> On 2021-01-15 14:01, Auger Eric wrote:
>> Hi Marc,
>>
>> On 1/14/21 11:56 AM, Marc Zyngier wrote:
>>> Upgrading the PMU code from ARMv8.1 to ARMv8.4 turns out to be
>>> pretty easy. All that is required is support for PMMIR_EL1, which
>>> is read-only, and for which returning 0 is a valid option.
>>>
>>> Let's just do that and adjust what we return to the guest.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>>  arch/arm64/kvm/sys_regs.c | 5 +++--
>>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index 8f79ec1fffa7..2f4ecbd2abfb 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -1051,10 +1051,10 @@ static u64 read_id_reg(const struct kvm_vcpu
>>> *vcpu,
>>>          /* Limit debug to ARMv8.0 */
>>>          val &= ~FEATURE(ID_AA64DFR0_DEBUGVER);
>>>          val |= FIELD_PREP(FEATURE(ID_AA64DFR0_DEBUGVER), 6);
>>> -        /* Limit guests to PMUv3 for ARMv8.1 */
>>> +        /* Limit guests to PMUv3 for ARMv8.4 */
>>>          val = cpuid_feature_cap_perfmon_field(val,
>>>                                ID_AA64DFR0_PMUVER_SHIFT,
>>> -                              kvm_vcpu_has_pmu(vcpu) ?
>>> ID_AA64DFR0_PMUVER_8_1 : 0);
>>> +                              kvm_vcpu_has_pmu(vcpu) ?
>>> ID_AA64DFR0_PMUVER_8_4 : 0);
>>>          break;
>>>      case SYS_ID_DFR0_EL1:
>>>          /* Limit guests to PMUv3 for ARMv8.1 */
>> what about the debug version in aarch32 state. Is it on purpose that you
>> leave it as 8_1?
> 
> That's a good point. There is also the fact that we keep reporting
> STALL_SLOT as a valid event even in PMCEID0_EL1 despite PMMIR_EL1.SLOTS
> always reporting 0.
Hum OK. I did not notice that ;-)

Thanks

Eric
> 
> I'll fix that and resend something next week.
> 
> Thanks,
> 
>         M.

