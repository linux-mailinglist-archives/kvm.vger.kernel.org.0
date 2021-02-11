Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5051319142
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 18:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhBKRju (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 12:39:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53393 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232448AbhBKRhp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Feb 2021 12:37:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613064977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iI21Pcg7YQSwB2wQEIgSvnGnSK7Kb/kyFlXapjRwTPg=;
        b=aew6FnNiuNlpfXIDinakJ3EqPcCtFYpEF3MUUUhMa7N9DdNdlhTpYNue+8M0pIHjdJo++X
        hYHErRm6A9KGPu3qOJ8GpHKPAJgLdQGXhtCdF6Umijko0fcO43WuNlhm7SaxBJwIBNETUj
        w7aL1VGAP6TUkTvrefYCL08nTJQly8U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-Gj4ll3mqPfG2iEePjc3b1g-1; Thu, 11 Feb 2021 12:36:13 -0500
X-MC-Unique: Gj4ll3mqPfG2iEePjc3b1g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 132CC803F48;
        Thu, 11 Feb 2021 17:36:10 +0000 (UTC)
Received: from [10.36.114.34] (ovpn-114-34.ams2.redhat.com [10.36.114.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 298E85C1BD;
        Thu, 11 Feb 2021 17:36:02 +0000 (UTC)
Subject: Re: [PATCH v13 05/15] iommu/smmuv3: Get prepared for nested stage
 support
To:     Keqian Zhu <zhukeqian1@huawei.com>, eric.auger.pro@gmail.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com,
        alex.williamson@redhat.com
Cc:     jean-philippe@linaro.org, jacob.jun.pan@linux.intel.com,
        nicoleotsuka@gmail.com, vivek.gautam@arm.com, yi.l.liu@intel.com,
        zhangfei.gao@linaro.org
References: <20201118112151.25412-1-eric.auger@redhat.com>
 <20201118112151.25412-6-eric.auger@redhat.com>
 <118a047b-91f4-3c84-867f-6c0b89f9011e@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <0d949aef-6719-2ef4-f1cd-f323b4d4130b@redhat.com>
Date:   Thu, 11 Feb 2021 18:36:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <118a047b-91f4-3c84-867f-6c0b89f9011e@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Keqian,

On 2/2/21 8:14 AM, Keqian Zhu wrote:
> Hi Eric,
> 
> On 2020/11/18 19:21, Eric Auger wrote:
>> When nested stage translation is setup, both s1_cfg and
>> s2_cfg are set.
>>
>> We introduce a new smmu domain abort field that will be set
>> upon guest stage1 configuration passing.
>>
>> arm_smmu_write_strtab_ent() is modified to write both stage
>> fields in the STE and deal with the abort field.
>>
>> In nested mode, only stage 2 is "finalized" as the host does
>> not own/configure the stage 1 context descriptor; guest does.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v10 -> v11:
>> - Fix an issue reported by Shameer when switching from with vSMMU
>>   to without vSMMU. Despite the spec does not seem to mention it
>>   seems to be needed to reset the 2 high 64b when switching from
>>   S1+S2 cfg to S1 only. Especially dst[3] needs to be reset (S2TTB).
>>   On some implementations, if the S2TTB is not reset, this causes
>>   a C_BAD_STE error
>> ---
>>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 64 +++++++++++++++++----
>>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  2 +
>>  2 files changed, 56 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> index 18ac5af1b284..412ea1bafa50 100644
>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> @@ -1181,8 +1181,10 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>>  	 * three cases at the moment:
>>  	 *
>>  	 * 1. Invalid (all zero) -> bypass/fault (init)
>> -	 * 2. Bypass/fault -> translation/bypass (attach)
>> -	 * 3. Translation/bypass -> bypass/fault (detach)
>> +	 * 2. Bypass/fault -> single stage translation/bypass (attach)
>> +	 * 3. Single or nested stage Translation/bypass -> bypass/fault (detach)
>> +	 * 4. S2 -> S1 + S2 (attach_pasid_table)
>> +	 * 5. S1 + S2 -> S2 (detach_pasid_table)
> 
> The following line "BUG_ON(ste_live && !nested);" forbids this transform.

Yes as pointed out by Kunkun, there is always an abort in-between. I
will restore the original comment.

> And I have a look at the 6th patch, the transform seems S1 + S2 -> abort.
> So after detach, the status is not the same as that before attach. Does it
> match our expectation?

Indeed at detach time I think I should reset the abort() flag as this
latter is not imposed anymore by the guest.

Thanks!

Eric


> 
>>  	 *
>>  	 * Given that we can't update the STE atomically and the SMMU
>>  	 * doesn't read the thing in a defined order, that leaves us
>> @@ -1193,7 +1195,8 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>>  	 * 3. Update Config, sync
>>  	 */
>>  	u64 val = le64_to_cpu(dst[0]);
>> -	bool ste_live = false;
>> +	bool s1_live = false, s2_live = false, ste_live;
>> +	bool abort, nested = false, translate = false;
>>  	struct arm_smmu_device *smmu = NULL;
>>  	struct arm_smmu_s1_cfg *s1_cfg;
>>  	struct arm_smmu_s2_cfg *s2_cfg;
>> @@ -1233,6 +1236,8 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>>  		default:
>>  			break;
>>  		}
>> +		nested = s1_cfg->set && s2_cfg->set;
>> +		translate = s1_cfg->set || s2_cfg->set;
>>  	}
>>  
>>  	if (val & STRTAB_STE_0_V) {
>> @@ -1240,23 +1245,36 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>>  		case STRTAB_STE_0_CFG_BYPASS:
>>  			break;
>>  		case STRTAB_STE_0_CFG_S1_TRANS:
>> +			s1_live = true;
>> +			break;
>>  		case STRTAB_STE_0_CFG_S2_TRANS:
>> -			ste_live = true;
>> +			s2_live = true;
>> +			break;
>> +		case STRTAB_STE_0_CFG_NESTED:
>> +			s1_live = true;
>> +			s2_live = true;
>>  			break;
>>  		case STRTAB_STE_0_CFG_ABORT:
>> -			BUG_ON(!disable_bypass);
>>  			break;
>>  		default:
>>  			BUG(); /* STE corruption */
>>  		}
>>  	}
>>  
>> +	ste_live = s1_live || s2_live;
>> +
>>  	/* Nuke the existing STE_0 value, as we're going to rewrite it */
>>  	val = STRTAB_STE_0_V;
>>  
>>  	/* Bypass/fault */
>> -	if (!smmu_domain || !(s1_cfg->set || s2_cfg->set)) {
>> -		if (!smmu_domain && disable_bypass)
>> +
>> +	if (!smmu_domain)
>> +		abort = disable_bypass;
>> +	else
>> +		abort = smmu_domain->abort;
>> +
>> +	if (abort || !translate) {
>> +		if (abort)
>>  			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
>>  		else
>>  			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
>> @@ -1274,8 +1292,16 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
>>  		return;
>>  	}
>>  
>> +	BUG_ON(ste_live && !nested);
>> +
>> +	if (ste_live) {
>> +		/* First invalidate the live STE */
>> +		dst[0] = cpu_to_le64(STRTAB_STE_0_CFG_ABORT);
>> +		arm_smmu_sync_ste_for_sid(smmu, sid);
>> +	}
>> +
> [...]
> 
> Thanks,
> Keqian
> 

