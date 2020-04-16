Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D023F1ABA37
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 09:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439647AbgDPHpw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 03:45:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57087 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2439526AbgDPHps (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Apr 2020 03:45:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587023142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xtMw61WExPfRdJ7k/9e2uGO0mShWA0MWE6V5DxSJKqU=;
        b=i+G/8B+LndcvuUIqQdKBrI4GZL1jtZ6CTu+DL/h6yBNydVgnq5V2kcb77kLQ4A7WZbGedH
        lEHOvUzLDW4hWnGrPxMBJSgtyIzh3jrWpdcOQjAlfOkAqmrtQLSg8FnscRDejq031V/M0+
        fZJZBuhG309cxzchzwSuj6aWPFKhSTw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-362-UyxvZ--jPOSsOW2DrZQkxw-1; Thu, 16 Apr 2020 03:45:35 -0400
X-MC-Unique: UyxvZ--jPOSsOW2DrZQkxw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7354A8017F5;
        Thu, 16 Apr 2020 07:45:32 +0000 (UTC)
Received: from [10.36.115.53] (ovpn-115-53.ams2.redhat.com [10.36.115.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 943CE60BE0;
        Thu, 16 Apr 2020 07:45:25 +0000 (UTC)
Subject: Re: [PATCH v11 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
To:     Zhangfei Gao <zhangfei.gao@linaro.org>, eric.auger.pro@gmail.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com
Cc:     jean-philippe@linaro.org, shameerali.kolothum.thodi@huawei.com,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, peter.maydell@linaro.org, tn@semihalf.com,
        bbhushan2@marvell.com
References: <20200414150607.28488-1-eric.auger@redhat.com>
 <eb27f625-ad7a-fcb5-2185-5471e4666f09@linaro.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <06fe02f7-2556-8986-2f1e-dcdf59773b8c@redhat.com>
Date:   Thu, 16 Apr 2020 09:45:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <eb27f625-ad7a-fcb5-2185-5471e4666f09@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zhangfei,

On 4/16/20 6:25 AM, Zhangfei Gao wrote:
>=20
>=20
> On 2020/4/14 =E4=B8=8B=E5=8D=8811:05, Eric Auger wrote:
>> This version fixes an issue observed by Shameer on an SMMU 3.2,
>> when moving from dual stage config to stage 1 only config.
>> The 2 high 64b of the STE now get reset. Otherwise, leaving the
>> S2TTB set may cause a C_BAD_STE error.
>>
>> This series can be found at:
>> https://github.com/eauger/linux/tree/v5.6-2stage-v11_10.1
>> (including the VFIO part)
>> The QEMU fellow series still can be found at:
>> https://github.com/eauger/qemu/tree/v4.2.0-2stage-rfcv6
>>
>> Users have expressed interest in that work and tested v9/v10:
>> - https://patchwork.kernel.org/cover/11039995/#23012381
>> - https://patchwork.kernel.org/cover/11039995/#23197235
>>
>> Background:
>>
>> This series brings the IOMMU part of HW nested paging support
>> in the SMMUv3. The VFIO part is submitted separately.
>>
>> The IOMMU API is extended to support 2 new API functionalities:
>> 1) pass the guest stage 1 configuration
>> 2) pass stage 1 MSI bindings
>>
>> Then those capabilities gets implemented in the SMMUv3 driver.
>>
>> The virtualizer passes information through the VFIO user API
>> which cascades them to the iommu subsystem. This allows the guest
>> to own stage 1 tables and context descriptors (so-called PASID
>> table) while the host owns stage 2 tables and main configuration
>> structures (STE).
>>
>>
>=20
> Thanks Eric
>=20
> Tested v11 on Hisilicon kunpeng920 board via hardware zip accelerator.
> 1. no-sva works, where guest app directly use physical address via ioct=
l.
Thank you for the testing. Glad it works for you.
> 2. vSVA still not work, same as v10,
Yes that's normal this series is not meant to support vSVM at this stage.

I intend to add the missing pieces during the next weeks.

Thanks

Eric
> 3.=C2=A0 the v10 issue reported by Shameer has been solved,=C2=A0 first=
 start qemu
> with=C2=A0 iommu=3Dsmmuv3, then start qemu without=C2=A0 iommu=3Dsmmuv3
> 4. no-sva also works without=C2=A0 iommu=3Dsmmuv3
>=20
> Test details in https://docs.qq.com/doc/DRU5oR1NtUERseFNL
>=20
> Thanks
>=20

