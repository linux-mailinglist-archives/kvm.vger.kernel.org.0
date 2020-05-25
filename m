Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEF81E0F4D
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 15:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403835AbgEYNVJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 09:21:09 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:4709 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403805AbgEYNVI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 09:21:08 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ecbc6370000>; Mon, 25 May 2020 06:20:55 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 25 May 2020 06:21:07 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 25 May 2020 06:21:07 -0700
Received: from [10.40.102.2] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 May
 2020 13:20:58 +0000
Subject: Re: [PATCH Kernel v22 0/8] Add UAPIs to support migration for VFIO
 devices
To:     Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     <cjia@nvidia.com>, <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>
References: <1589781397-28368-1-git-send-email-kwankhede@nvidia.com>
 <20200519105804.02f3cae8@x1.home> <20200525065925.GA698@joy-OptiPlex-7040>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <426a5314-6d67-7cbe-bad0-e32f11d304ea@nvidia.com>
Date:   Mon, 25 May 2020 18:50:54 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200525065925.GA698@joy-OptiPlex-7040>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590412855; bh=rfvzQ1dHfzD4GOc0GVDetG93nM12lVwp2xFrbbE4mrM=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=obFiMWLGm5rnR3RXAScvd/qKPQwMDIkOvlO/mrMnXbqKVmsRgT7mOw4OABMA8/fpa
         dxtZPIEmSYHo1rXH4y48NhxvMm2VOmvIIEp/ldTNClwSG6gFB0qo0G1+sleIvtne9S
         bIQhKlPwCKOlhfc8jLbCi+9CduGga+wUraCF7u8viKR1MCQ6NW8OkU975m3bKUC0Hx
         bNLivELzZ2daRgcDOHgRrcjs/l3DesT3hUNBpmnzaBmPtlSK+FdJGH0Fld6eve22cu
         Pl2XfwTbsh1StUr5ck+rpzWgkhORa4sFZoF6ZwOmud4Wl4m6MVw2XH/cBB5z96uEdK
         b3ffEN2fiUbZA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/25/2020 12:29 PM, Yan Zhao wrote:
> On Tue, May 19, 2020 at 10:58:04AM -0600, Alex Williamson wrote:
>> Hi folks,
>>
>> My impression is that we're getting pretty close to a workable
>> implementation here with v22 plus respins of patches 5, 6, and 8.  We
>> also have a matching QEMU series and a proposal for a new i40e
>> consumer, as well as I assume GVT-g updates happening internally at
>> Intel.  I expect all of the latter needs further review and discussion,
>> but we should be at the point where we can validate these proposed
>> kernel interfaces.  Therefore I'd like to make a call for reviews so
>> that we can get this wrapped up for the v5.8 merge window.  I know
>> Connie has some outstanding documentation comments and I'd like to make
>> sure everyone has an opportunity to check that their comments have been
>> addressed and we don't discover any new blocking issues.  Please send
>> your Acked-by/Reviewed-by/Tested-by tags if you're satisfied with this
>> interface and implementation.  Thanks!
>>
> hi Alex
> after porting gvt/i40e vf migration code to kernel/qemu v23, we spoted
> two bugs.
> 1. "Failed to get dirty bitmap for iova: 0xfe011000 size: 0x3fb0 err: 22"
>     This is a qemu bug that the dirty bitmap query range is not the same
>     as the dma map range. It can be fixed in qemu. and I just have a little
>     concern for kernel to have this restriction.
> 

I never saw this unaligned size in my testing. In this case if you can 
provide vfio_* event traces, that will helpful.

> 2. migration abortion, reporting
> "qemu-system-x86_64-lm: vfio_load_state: Error allocating buffer
> qemu-system-x86_64-lm: error while loading state section id 49(vfio)
> qemu-system-x86_64-lm: load of migration failed: Cannot allocate memory"
> 
> It's still a qemu bug and we can fixed it by
> "
> if (migration->pending_bytes == 0) {
> +            qemu_put_be64(f, 0);
> +            qemu_put_be64(f, VFIO_MIG_FLAG_END_OF_STATE);
> "

In which function in QEMU do you have to add this?

> and actually there are some extra concerns about this part, as reported in
> [1][2].
> 
> [1] data_size should be read ahead of data_offset
> https://lists.gnu.org/archive/html/qemu-devel/2020-05/msg02795.html.
> [2] should not repeatedly update pending_bytes in vfio_save_iterate()
> https://lists.gnu.org/archive/html/qemu-devel/2020-05/msg02796.html.
> 
> but as those errors are all in qemu, and we have finished basic tests in
> both gvt & i40e, we're fine with the kernel part interface in general now.
> (except for my concern [1], which needs to update kernel patch 1)
> 

 >> what if pending_bytes is not 0, but vendor driver just does not want  to
 >> send data in this iteration? isn't it right to get data_size first 
before
 >> getting data_offset?

If vendor driver doesn't want to send data but still has data in staging 
buffer, vendor driver still can control to send pending_bytes for this 
iteration as 0 as this is a trap field.

I would defer this to Alex.

> so I wonder which way in your mind is better, to give our reviewed-by to
> the kernel part now, or hold until next qemu fixes?
> and as performance data from gvt is requested from your previous mail, is
> that still required before the code is accepted?
> 
> BTW, we have also conducted some basic tests when viommu is on, and found out
> errors like
> "qemu-system-x86_64-dt: vtd_iova_to_slpte: detected slpte permission error (iova=0x0, level=0x3, slpte=0x0, write=1)
> qemu-system-x86_64-dt: vtd_iommu_translate: detected translation failure (dev=00:03:00, iova=0x0)
> qemu-system-x86_64-dt: New fault is not recorded due to compression of faults".
> 

I saw these errors, I'm looking into it.

Thanks,
Kirti
