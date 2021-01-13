Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13D32F50FD
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 18:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbhAMRUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 12:20:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21645 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727893AbhAMRUQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 12:20:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610558329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7zVKCOf+hFcDGtIgPvTN+nqlHkfJziBSJGgxDULseSA=;
        b=Sn3AlBSEHhwlggABrBIzOob8qAnVc3TbivPnjAWaOA0SdGPRalb8KOKaGTMOzzSjxxzNE5
        HGSiRsXA9i8b30Ti1zY94MeCtOC7UvK/fR8zrdEoXwxy+ZRc35QbjkF9ynt1SPNiLP6+Tl
        Agjrr2scMIM+n62ihQ1HlDZQ2ww8aBg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-8ucV_A4hOSWMEuopppGN5w-1; Wed, 13 Jan 2021 12:18:45 -0500
X-MC-Unique: 8ucV_A4hOSWMEuopppGN5w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EFE94100C604;
        Wed, 13 Jan 2021 17:18:43 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 553EC2BFC7;
        Wed, 13 Jan 2021 17:18:41 +0000 (UTC)
Subject: Re: [PATCH 4/9] KVM: arm/arm64: vgic: Reset base address on
 kvm_vgic_dist_destroy()
To:     Marc Zyngier <maz@kernel.org>
Cc:     eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, alexandru.elisei@arm.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        shuah@kernel.org, pbonzini@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-5-eric.auger@redhat.com> <878s9ios44.wl-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <2291951d-987c-7b9f-e1a6-d4241f84fce5@redhat.com>
Date:   Wed, 13 Jan 2021 18:18:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <878s9ios44.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 12/28/20 4:41 PM, Marc Zyngier wrote:
> On Sat, 12 Dec 2020 18:50:05 +0000,
> Eric Auger <eric.auger@redhat.com> wrote:
>>
>> On vgic_dist_destroy(), the addresses are not reset. However for
>> kvm selftest purpose this would allow to continue the test execution
>> even after a failure when running KVM_RUN. So let's reset the
>> base addresses.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  arch/arm64/kvm/vgic/vgic-init.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
>> index 32e32d67a127..6147bed56b1b 100644
>> --- a/arch/arm64/kvm/vgic/vgic-init.c
>> +++ b/arch/arm64/kvm/vgic/vgic-init.c
>> @@ -335,14 +335,16 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
>>  	kfree(dist->spis);
>>  	dist->spis = NULL;
>>  	dist->nr_spis = 0;
>> +	dist->vgic_dist_base = VGIC_ADDR_UNDEF;
>>  
>> -	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
>> +	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
>>  		list_for_each_entry_safe(rdreg, next, &dist->rd_regions, list) {
>>  			list_del(&rdreg->list);
>>  			kfree(rdreg);
>>  		}
>>  		INIT_LIST_HEAD(&dist->rd_regions);
>> -	}
>> +	} else
>> +		kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
> 
> Since you have converted the hunk above to use dist->, you could do
> the same thing here. And the coding style dictates that you need {} on
> the else side as well.
sure

Thanks

Eric
> 
>>
>>  	if (vgic_has_its(kvm))
>>  		vgic_lpi_translation_cache_destroy(kvm);
>> @@ -362,6 +364,7 @@ void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
>>  	vgic_flush_pending_lpis(vcpu);
>>  
>>  	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
>> +	vgic_cpu->rd_iodev.base_addr = VGIC_ADDR_UNDEF;
>>  }
>>  
>>  /* To be called with kvm->lock held */
>> -- 
>> 2.21.3
>>
>>
> 
> Thanks,
> 
> 	M.
> 

