Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16FD263597
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 20:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgIISIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 14:08:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35632 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725772AbgIISIA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Sep 2020 14:08:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599674878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VV6n2P1JqU0YPZMyUbTFLLb1CLWvWgHP/iQgdRcWwfw=;
        b=h63gNaVtn5xgiE7qUUCPac1UF24hgAAPJ+nyCt1dHnl/wjzzB0yadN8BANSUD1nB4kSGYG
        dm/93o98Vwf7H2BeBPYjrwpFm7H/ycP4M6JVsoUDkZSTGc6dsxHJMxgcfLt2gtj4WfkRK6
        QH43FnDO+iAS4pvpUdSiU8t1knITjTw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-CWBp0t5cPr-iJtqldYOYXQ-1; Wed, 09 Sep 2020 14:07:56 -0400
X-MC-Unique: CWBp0t5cPr-iJtqldYOYXQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E646E800683;
        Wed,  9 Sep 2020 18:07:54 +0000 (UTC)
Received: from [10.36.115.123] (ovpn-115-123.ams2.redhat.com [10.36.115.123])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 57CF31002D67;
        Wed,  9 Sep 2020 18:07:52 +0000 (UTC)
Subject: Re: [PATCH v3 4/5] KVM: arm64: Mask out filtered events in
 PCMEID{0,1}_EL1
To:     Marc Zyngier <maz@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com, James Morse <james.morse@arm.com>,
        linux-arm-kernel@lists.infradead.org, graf@amazon.com,
        Robin Murphy <robin.murphy@arm.com>,
        kvmarm@lists.cs.columbia.edu,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20200908075830.1161921-1-maz@kernel.org>
 <20200908075830.1161921-5-maz@kernel.org>
 <735f5464-3a45-8dc0-c330-ac5632bcb4b4@redhat.com>
 <dde5292adce235bea39bc927c1256bc8@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <d492cf6d-6572-572e-ceb2-37eec99a9307@redhat.com>
Date:   Wed, 9 Sep 2020 20:07:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <dde5292adce235bea39bc927c1256bc8@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 9/9/20 7:50 PM, Marc Zyngier wrote:
> Hi Eric,
> 
> On 2020-09-09 18:43, Auger Eric wrote:
>> Hi Marc,
>>
>> On 9/8/20 9:58 AM, Marc Zyngier wrote:
>>> As we can now hide events from the guest, let's also adjust its view of
>>> PCMEID{0,1}_EL1 so that it can figure out why some common events are not
>>> counting as they should.
>> Referring to my previous comment should we filter the cycle counter out?
>>>
>>> The astute user can still look into the TRM for their CPU and find out
>>> they've been cheated, though. Nobody's perfect.
>>>
>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>> ---
>>>  arch/arm64/kvm/pmu-emul.c | 29 +++++++++++++++++++++++++++++
>>>  arch/arm64/kvm/sys_regs.c |  5 +----
>>>  include/kvm/arm_pmu.h     |  5 +++++
>>>  3 files changed, 35 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>>> index 67a731bafbc9..0458860bade2 100644
>>> --- a/arch/arm64/kvm/pmu-emul.c
>>> +++ b/arch/arm64/kvm/pmu-emul.c
>>> @@ -765,6 +765,35 @@ static int kvm_pmu_probe_pmuver(void)
>>>      return pmuver;
>>>  }
>>>
>>> +u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
>>> +{
>>> +    unsigned long *bmap = vcpu->kvm->arch.pmu_filter;
>>> +    u64 val, mask = 0;
>>> +    int base, i;
>>> +
>>> +    if (!pmceid1) {
>>> +        val = read_sysreg(pmceid0_el0);
>>> +        base = 0;
>>> +    } else {
>>> +        val = read_sysreg(pmceid1_el0);
>>> +        base = 32;
>>> +    }
>>> +
>>> +    if (!bmap)
>>> +        return val;
>>> +
>>> +    for (i = 0; i < 32; i += 8) {
>> s/32/4?
> 
> I don't think so, see below.
> 
>>
>> Thanks
>>
>> Eric
>>> +        u64 byte;
>>> +
>>> +        byte = bitmap_get_value8(bmap, base + i);
>>> +        mask |= byte << i;
> 
> For each iteration of the loop, we read a byte from the bitmap
> (hence the += 8 above), and orr it into the mask. This makes 4
> iteration of the loop.
> 
> Or am I missing your point entirely?

Hum no you're right. Sorry for the noise.

Looks good to me:

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric


> 
> Thanks,
> 
>         M.

