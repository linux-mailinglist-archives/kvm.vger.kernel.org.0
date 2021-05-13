Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D68B37F6A0
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 13:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbhEMLVr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 07:21:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31759 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232072AbhEMLVk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 May 2021 07:21:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620904830;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gl58JM3qwCzTQk1/iD8HqqF6tQAH25wEwcXh1lA0IN4=;
        b=G7rxM+T51N5nYjRz5ixnpExRtzLFz1JLOawlSYfjC5tSlXZ7G4SyaP/xTtPFTd/uNCKIL8
        f9y3/UjEQrGGy/+yydDIfvyYSnj7VHQ6exn29ISdDSGSW3XYgj1+iJDQI3K4fsn0auXS0r
        DmH++yBwiCZVgWCVTESHWTewAoclSUc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-6g6Cj2c2OHeKzi8X1tXwfQ-1; Thu, 13 May 2021 07:20:27 -0400
X-MC-Unique: 6g6Cj2c2OHeKzi8X1tXwfQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED78180ED8E;
        Thu, 13 May 2021 11:20:25 +0000 (UTC)
Received: from [10.64.54.43] (vpn2-54-43.bne.redhat.com [10.64.54.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D0616EF48;
        Thu, 13 May 2021 11:20:23 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH] KVM: arm64: selftests: Request PMU feature in
 get-reg-list
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, drjones@redhat.com,
        pbonzini@redhat.com
References: <20210513130655.73154-1-gshan@redhat.com>
 <d717b9272cce16c62a4e3e671bb1f068@kernel.org>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <5c72317d-2fff-e260-1806-31163e9f893b@redhat.com>
Date:   Thu, 13 May 2021 23:20:49 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <d717b9272cce16c62a4e3e671bb1f068@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/13/21 9:14 PM, Marc Zyngier wrote:
> On 2021-05-13 14:06, Gavin Shan wrote:
>> Since the following commit, PMU registers are hidden from user until
>> it's explicitly requested by feeding feature (KVM_ARM_VCPU_PMU_V3).
>> Otherwise, 74 missing PMU registers are missing as the following
>> log indicates.
>>
>>    11663111cd49 ("KVM: arm64: Hide PMU registers from userspace when
>> not available")
>>
>>    # ./get-reg-list
>>    Number blessed registers:   308
>>    Number registers:           238
>>
>>    There are 74 missing registers.
>>    The following lines are missing registers:
>>
>>           ARM64_SYS_REG(3, 0, 9, 14, 1),
>>     ARM64_SYS_REG(3, 0, 9, 14, 2),
>>              :
>>     ARM64_SYS_REG(3, 3, 14, 15, 7),
>>
>> This fixes the issue of wrongly reported missing PMU registers by
>> requesting it explicitly.
>>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>  tools/testing/selftests/kvm/aarch64/get-reg-list.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
>> b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
>> index 486932164cf2..6c6bdc6f5dc3 100644
>> --- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
>> +++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
>> @@ -314,6 +314,8 @@ static void core_reg_fixup(void)
>>
>>  static void prepare_vcpu_init(struct kvm_vcpu_init *init)
>>  {
>> +    init->features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
>> +
>>      if (reg_list_sve())
>>          init->features[0] |= 1 << KVM_ARM_VCPU_SVE;
>>  }
> 
> Please see Andrew's series[1], which actually deals with options.
> 
>          M.
> 
> [1] https://lore.kernel.org/r/20210507200416.198055-1-drjones@redhat.com
>

Thanks, Marc. Yes, Drew's series already had the fix.
Sorry about the noise and please ignore this.

Thanks,
Gavin

