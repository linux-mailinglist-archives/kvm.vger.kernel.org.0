Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11DB354526
	for <lists+kvm@lfdr.de>; Mon,  5 Apr 2021 18:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239413AbhDEQ2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Apr 2021 12:28:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33912 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233689AbhDEQ2T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Apr 2021 12:28:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617640092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hDd+iS7d84828C4DpW9QT8Bs3288njEXcR/TmjGMo4A=;
        b=IL2a6ZR/bRP8Q61sHuN9vhwJvMEFudAptRlD5aOmOgpQHAG6gC9Wl4jvodl6Ul/ZQztJQb
        dwnwz3I1hcHT3IpgYPymy0HqnTqBTxh1T7eBdWPUYkq6fb4UdkKKELjRgYa4Mgpfx12jSd
        UpCVDXUOICp5SisBrTJUDIbNHxUI8pY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-NRQnBzeRMQywXtGu3YgRkw-1; Mon, 05 Apr 2021 12:28:08 -0400
X-MC-Unique: NRQnBzeRMQywXtGu3YgRkw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E81258189C6;
        Mon,  5 Apr 2021 16:28:06 +0000 (UTC)
Received: from [10.36.112.13] (ovpn-112-13.ams2.redhat.com [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FA9310016DB;
        Mon,  5 Apr 2021 16:28:00 +0000 (UTC)
Subject: Re: [PATCH v5 7/8] KVM: arm64: vgic-v3: Expose GICR_TYPER.Last for
 userspace
To:     Marc Zyngier <maz@kernel.org>
Cc:     eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, alexandru.elisei@arm.com, james.morse@arm.com,
        suzuki.poulose@arm.com, shuah@kernel.org, pbonzini@redhat.com
References: <20210404172243.504309-1-eric.auger@redhat.com>
 <20210404172243.504309-8-eric.auger@redhat.com>
 <878s5xf3ed.wl-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <f9788cb1-59c4-f936-89a2-40784a1c1500@redhat.com>
Date:   Mon, 5 Apr 2021 18:27:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <878s5xf3ed.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 4/5/21 12:10 PM, Marc Zyngier wrote:
> On Sun, 04 Apr 2021 18:22:42 +0100,
> Eric Auger <eric.auger@redhat.com> wrote:
>>
>> Commit 23bde34771f1 ("KVM: arm64: vgic-v3: Drop the
>> reporting of GICR_TYPER.Last for userspace") temporarily fixed
>> a bug identified when attempting to access the GICR_TYPER
>> register before the redistributor region setting, but dropped
>> the support of the LAST bit.
>>
>> Emulating the GICR_TYPER.Last bit still makes sense for
>> architecture compliance though. This patch restores its support
>> (if the redistributor region was set) while keeping the code safe.
>>
>> We introduce a new helper, vgic_mmio_vcpu_rdist_is_last() which
>> computes whether a redistributor is the highest one of a series
>> of redistributor contributor pages.
>>
>> With this new implementation we do not need to have a uaccess
>> read accessor anymore.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v4 -> v5:
>> - redist region list now is sorted by @base
>> - change the implementation according to Marc's understanding of
>>   the spec
>> ---
>>  arch/arm64/kvm/vgic/vgic-mmio-v3.c | 58 +++++++++++++++++-------------
>>  include/kvm/arm_vgic.h             |  1 +
>>  2 files changed, 34 insertions(+), 25 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> index e1ed0c5a8eaa..03a253785700 100644
>> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
>> @@ -251,45 +251,52 @@ static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
>>  		vgic_enable_lpis(vcpu);
>>  }
>>  
>> +static bool vgic_mmio_vcpu_rdist_is_last(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vgic_dist *vgic = &vcpu->kvm->arch.vgic;
>> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>> +	struct vgic_redist_region *iter, *rdreg = vgic_cpu->rdreg;
>> +
>> +	if (!rdreg)
>> +		return false;
>> +
>> +	if (vgic_cpu->rdreg_index < rdreg->free_index - 1) {
>> +		return false;
>> +	} else if (rdreg->count && vgic_cpu->rdreg_index == (rdreg->count - 1)) {
>> +		struct list_head *rd_regions = &vgic->rd_regions;
>> +		gpa_t end = rdreg->base + rdreg->count * KVM_VGIC_V3_REDIST_SIZE;
>> +
>> +		/*
>> +		 * the rdist is the last one of the redist region,
>> +		 * check whether there is no other contiguous rdist region
>> +		 */
>> +		list_for_each_entry(iter, rd_regions, list) {
>> +			if (iter->base == end && iter->free_index > 0)
>> +				return false;
>> +		}
> 
> In the above notes, you state that the region list is now sorted by
> base address, but I really can't see what sorts that list. And the
> lines above indicate that you are still iterating over the whole RD
> regions.
> 
> It's not a big deal (the code is now simple enough), but that's just
> to confirm that I understand what is going on here.

Sorry I should have removed the notes. I made the change but then I
noticed that the list was already sorted by redistributor region index
as the API forbids to register rdist regions in non ascending index
order. So sorting by base address was eventually causing more trouble
than it helped.

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 

