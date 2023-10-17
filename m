Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD6E7CC777
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 17:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344242AbjJQP3G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 11:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjJQP3F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 11:29:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B83F92
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 08:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697556499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C+wMnezdSmjs10pDeNJeo7+9S3n3Z8j46jkaSy9yiGY=;
        b=VGtaVnXxn+IQb4kuGkcQ/oXJPuTTHXDQ/pPgHlLux0rSFqqYnvojJEl8yDV47WpoHlRpCj
        AUDEaoKmLbEykZpwxkgmr0ZhnRoy+8JzGqdeJrD/fRVV2TnMY0dK+Mxz/k+RUeFJezMoqi
        mXHipZZ/VOSluiIyhiL0MF4e23MQQNs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-ZpPK_h1lNnK7KmZix5YMOA-1; Tue, 17 Oct 2023 11:28:08 -0400
X-MC-Unique: ZpPK_h1lNnK7KmZix5YMOA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 591A58E4148;
        Tue, 17 Oct 2023 15:28:08 +0000 (UTC)
Received: from localhost (unknown [10.39.193.165])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D540150;
        Tue, 17 Oct 2023 15:28:08 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Gavin Shan <gshan@redhat.com>,
        qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/3] arm/kvm: convert to read_sys_reg64
In-Reply-To: <CAFEAcA88O-VDq2rRfVhZ_6OShFq1ANEMmHWHVtNS5hCPQNYtdg@mail.gmail.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20231010142453.224369-1-cohuck@redhat.com>
 <20231010142453.224369-4-cohuck@redhat.com>
 <CAFEAcA88O-VDq2rRfVhZ_6OShFq1ANEMmHWHVtNS5hCPQNYtdg@mail.gmail.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Tue, 17 Oct 2023 17:28:06 +0200
Message-ID: <87y1g1clq1.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 17 2023, Peter Maydell <peter.maydell@linaro.org> wrote:

> On Tue, 10 Oct 2023 at 15:25, Cornelia Huck <cohuck@redhat.com> wrote:
>>
>> We can use read_sys_reg64 to get the SVE_VLS register instead of
>> calling GET_ONE_REG directly.
>>
>> Suggested-by: Gavin Shan <gshan@redhat.com>
>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> ---
>>  target/arm/kvm64.c | 6 +-----
>>  1 file changed, 1 insertion(+), 5 deletions(-)
>>
>> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
>> index 558c0b88dd69..d40c89a84752 100644
>> --- a/target/arm/kvm64.c
>> +++ b/target/arm/kvm64.c
>> @@ -500,10 +500,6 @@ uint32_t kvm_arm_sve_get_vls(CPUState *cs)
>>              .target = -1,
>>              .features[0] = (1 << KVM_ARM_VCPU_SVE),
>>          };
>> -        struct kvm_one_reg reg = {
>> -            .id = KVM_REG_ARM64_SVE_VLS,
>> -            .addr = (uint64_t)&vls[0],
>> -        };
>>          int fdarray[3], ret;
>>
>>          probed = true;
>> @@ -512,7 +508,7 @@ uint32_t kvm_arm_sve_get_vls(CPUState *cs)
>>              error_report("failed to create scratch VCPU with SVE enabled");
>>              abort();
>>          }
>> -        ret = ioctl(fdarray[2], KVM_GET_ONE_REG, &reg);
>> +        ret = read_sys_reg64(fdarray[2], &vls[0], KVM_REG_ARM64_SVE_VLS);
>>          kvm_arm_destroy_scratch_host_vcpu(fdarray);
>>          if (ret) {
>>              error_report("failed to get KVM_REG_ARM64_SVE_VLS: %s",
>
> read_sys_reg64() asserts that the register you're trying to
> read is 64 bits, but KVM_REG_ARM64_SVE_VLS is not, it's 512 bits:
>
> #define KVM_REG_ARM64_SVE_VLS           (KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
>                                          KVM_REG_SIZE_U512 | 0xffff)
>
> So this change would trip the assert on a host where SVE
> is supported and enabled.

Whoops, it seems that I misread this. (And my test environment didn't
have that enabled...)

