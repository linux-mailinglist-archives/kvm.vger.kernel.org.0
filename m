Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AF52CEC22
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 11:26:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729861AbgLDKZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 05:25:46 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27470 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729852AbgLDKZp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 05:25:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607077458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2T15ek84GRYZBFIB7crwXKiwkKfTgxR0/uZEpJtiF7w=;
        b=SLloYKDdYp+CyHGbNW1sCRZTqmqcoNANfgfQiNf33KX/U9SJJ8FWt4gAsaCyi0OlECXUTh
        tnCg9VcF8JPH62IgEFAKiwfC2E+lG83cf2fvTO0Bs47rSGm6LuOzONSYQHiuBTxKn7uqCA
        vxpNO48A3DuXVYqUtyffL+o6tdp4hOg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-EHJ7jY99MrmUOFed-1HElg-1; Fri, 04 Dec 2020 05:24:13 -0500
X-MC-Unique: EHJ7jY99MrmUOFed-1HElg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E4C8180A087;
        Fri,  4 Dec 2020 10:24:11 +0000 (UTC)
Received: from [10.36.112.89] (ovpn-112-89.ams2.redhat.com [10.36.112.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 59A2C620D7;
        Fri,  4 Dec 2020 10:23:59 +0000 (UTC)
Subject: Re: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
 unmanaged ASIDs
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     wangxingang <wangxingang5@huawei.com>,
        Xieyingtai <xieyingtai@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        qubingbing <qubingbing@hisilicon.com>
References: <20201118112151.25412-8-eric.auger@redhat.com>
 <1606829590-25924-1-git-send-email-wangxingang5@huawei.com>
 <2e69adf5-8207-64f7-fa8e-9f2bd3a3c4e3@redhat.com>
 <e10ad90dc5144c0d9df98a9a078091af@huawei.com>
 <20201204095338.GA1912466@myrica>
 <2de03a797517452cbfeab022e12612b7@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <0bf50dd6-ef3c-7aba-cbc1-1c2e17088470@redhat.com>
Date:   Fri, 4 Dec 2020 11:23:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <2de03a797517452cbfeab022e12612b7@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shameer, Jean-Philippe,

On 12/4/20 11:20 AM, Shameerali Kolothum Thodi wrote:
> Hi Jean,
> 
>> -----Original Message-----
>> From: Jean-Philippe Brucker [mailto:jean-philippe@linaro.org]
>> Sent: 04 December 2020 09:54
>> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
>> Cc: Auger Eric <eric.auger@redhat.com>; wangxingang
>> <wangxingang5@huawei.com>; Xieyingtai <xieyingtai@huawei.com>;
>> kvm@vger.kernel.org; maz@kernel.org; joro@8bytes.org; will@kernel.org;
>> iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
>> vivek.gautam@arm.com; alex.williamson@redhat.com;
>> zhangfei.gao@linaro.org; robin.murphy@arm.com;
>> kvmarm@lists.cs.columbia.edu; eric.auger.pro@gmail.com; Zengtao (B)
>> <prime.zeng@hisilicon.com>; qubingbing <qubingbing@hisilicon.com>
>> Subject: Re: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with
>> unmanaged ASIDs
>>
>> Hi Shameer,
>>
>> On Thu, Dec 03, 2020 at 06:42:57PM +0000, Shameerali Kolothum Thodi wrote:
>>> Hi Jean/zhangfei,
>>> Is it possible to have a branch with minimum required SVA/UACCE related
>> patches
>>> that are already public and can be a "stable" candidate for future respin of
>> Eric's series?
>>> Please share your thoughts.
>>
>> By "stable" you mean a fixed branch with the latest SVA/UACCE patches
>> based on mainline? 
> 
> Yes. 
> 
>  The uacce-devel branches from
>> https://github.com/Linaro/linux-kernel-uadk do provide this at the moment
>> (they track the latest sva/zip-devel branch
>> https://jpbrucker.net/git/linux/ which is roughly based on mainline.)
> 
> Thanks. 
> 
> Hi Eric,
> 
> Could you please take a look at the above branches and see whether it make sense
> to rebase on top of either of those?
> 
> From vSVA point of view, it will be less rebase hassle if we can do that.

Sure. I will rebase on top of this ;-)

Thanks

Eric
> 
> Thanks,
> Shameer
> 
>> Thanks,
>> Jean
> 

