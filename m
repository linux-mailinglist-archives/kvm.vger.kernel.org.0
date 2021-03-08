Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F313B33159D
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 19:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbhCHSNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 13:13:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50555 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230173AbhCHSMp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 13:12:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615227164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g3PfKhdiqdgUwSWYSwDNbfusFaETS5oAF78BcOmOgew=;
        b=KojPM+aCjtw7dZvKWAuFFjs6OQ+SE59GTh2hxHMYuVClQNO6oqblWOga7PCeU6LdlMWpM7
        uBvzMxmmW0h4lUGVhr/DNChmtpgw9fxjy5Ui19gZkatH2nr1e2HqimRq+43k1O/jlDWMpm
        meieghCrrWB4REOn6/z9Yh6qNYhzNEY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-LHQEfOXhMzaPdazJnqfR1g-1; Mon, 08 Mar 2021 13:12:40 -0500
X-MC-Unique: LHQEfOXhMzaPdazJnqfR1g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1E3980432E;
        Mon,  8 Mar 2021 18:12:35 +0000 (UTC)
Received: from [10.36.112.254] (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 29A7D5D756;
        Mon,  8 Mar 2021 18:12:22 +0000 (UTC)
Subject: Re: [PATCH v12 03/13] vfio: VFIO_IOMMU_SET_MSI_BINDING
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, will@kernel.org, maz@kernel.org,
        robin.murphy@arm.com, joro@8bytes.org, alex.williamson@redhat.com,
        tn@semihalf.com, zhukeqian1@huawei.com,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        wangxingang5@huawei.com, jiangkunkun@huawei.com,
        zhangfei.gao@linaro.org, zhangfei.gao@gmail.com,
        vivek.gautam@arm.com, shameerali.kolothum.thodi@huawei.com,
        yuzenghui@huawei.com, nicoleotsuka@gmail.com,
        lushenming@huawei.com, vsethi@nvidia.com
References: <20210223210625.604517-1-eric.auger@redhat.com>
 <20210223210625.604517-4-eric.auger@redhat.com> <YEIL3qmcRfhUoRGt@myrica>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <0e23edb9-9923-edb9-ac3d-8fb52d2fe8c6@redhat.com>
Date:   Mon, 8 Mar 2021 19:12:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YEIL3qmcRfhUoRGt@myrica>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jean,

On 3/5/21 11:45 AM, Jean-Philippe Brucker wrote:
> Hi,
> 
> On Tue, Feb 23, 2021 at 10:06:15PM +0100, Eric Auger wrote:
>> This patch adds the VFIO_IOMMU_SET_MSI_BINDING ioctl which aim
>> to (un)register the guest MSI binding to the host. This latter
>> then can use those stage 1 bindings to build a nested stage
>> binding targeting the physical MSIs.
> 
> Now that RMR is in the IORT spec, could it be used for the nested MSI
> problem?  For virtio-iommu tables I was planning to do it like this:
> 
> MSI is mapped at stage-2 with an arbitrary IPA->doorbell PA. We report
> this IPA to userspace through iommu_groups/X/reserved_regions. No change
> there. Then to the guest we report a reserved identity mapping at IPA
> (using RMR, an equivalent DT binding, or probed RESV_MEM for
> virtio-iommu).

Is there any DT binding equivalent?

 The guest creates that mapping at stage-1, and that's it.
> Unless I overlooked something we'd only reuse existing infrastructure and
> avoid the SET_MSI_BINDING interface.

Yes at first glance I think this should work. The guest SMMU driver will
continue allocating IOVA for MSIs but I think that's not an issue as
they won't be used.

For the SMMU case this makes the guest behavior different from the
baremetal one though. Typically you will never get any S1 fault. Also
the S1 mapping is static and direct.

I will prototype this too.

Thanks

Eric
> 
> Thanks,
> Jean
> 

