Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B77A2CA4D6
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 15:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391444AbgLAOAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 09:00:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29906 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387744AbgLAOAl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 1 Dec 2020 09:00:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606831155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PwJG1illbebhBKC5v2IxyfNes6/XlUwSexlIWlX8yvI=;
        b=Sqts2fz4bA6bphVlsKG6Q49c1zum8LCZ1DpPxB3Tu1M9GAxjptOsSQWlTcAgDjljXGsywr
        QpLmkMBLkTDrizk4tuOpn3DMSmWcLtIzRdAysFk/AsUf//f+K3W2cILWEKnUZIP2HYVWXZ
        O3dqWRWiNmc8hqUsPk4YYJt3Le1Wgxw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-wovMo1sZOu2TKbhHgVoPFw-1; Tue, 01 Dec 2020 08:59:03 -0500
X-MC-Unique: wovMo1sZOu2TKbhHgVoPFw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8FF338558E9;
        Tue,  1 Dec 2020 13:59:00 +0000 (UTC)
Received: from [10.36.112.89] (ovpn-112-89.ams2.redhat.com [10.36.112.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A8A1A5C1BB;
        Tue,  1 Dec 2020 13:58:53 +0000 (UTC)
Subject: Re: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
To:     Xingang Wang <wangxingang5@huawei.com>
Cc:     alex.williamson@redhat.com, eric.auger.pro@gmail.com,
        iommu@lists.linux-foundation.org, jean-philippe@linaro.org,
        joro@8bytes.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, maz@kernel.org, robin.murphy@arm.com,
        vivek.gautam@arm.com, will@kernel.org, zhangfei.gao@linaro.org,
        xieyingtai@huawei.com
References: <20201118112151.25412-8-eric.auger@redhat.com>
 <1606829590-25924-1-git-send-email-wangxingang5@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <2e69adf5-8207-64f7-fa8e-9f2bd3a3c4e3@redhat.com>
Date:   Tue, 1 Dec 2020 14:58:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1606829590-25924-1-git-send-email-wangxingang5@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Xingang,

On 12/1/20 2:33 PM, Xingang Wang wrote:
> Hi Eric
> 
> On  Wed, 18 Nov 2020 12:21:43, Eric Auger wrote:
>> @@ -1710,7 +1710,11 @@ static void arm_smmu_tlb_inv_context(void *cookie)
>> 	 * insertion to guarantee those are observed before the TLBI. Do be
>> 	 * careful, 007.
>> 	 */
>> -	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
>> +	if (ext_asid >= 0) { /* guest stage 1 invalidation */
>> +		cmd.opcode	= CMDQ_OP_TLBI_NH_ASID;
>> +		cmd.tlbi.asid	= ext_asid;
>> +		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
>> +	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
> 
> Found a problem here, the cmd for guest stage 1 invalidation is built,
> but it is not delivered to smmu.
> 

Thank you for the report. I will fix that soon. With that fixed, have
you been able to run vSVA on top of the series. Do you need other stuff
to be fixed at SMMU level? As I am going to respin soon, please let me
know what is the best branch to rebase to alleviate your integration.

Best Regards

Eric

