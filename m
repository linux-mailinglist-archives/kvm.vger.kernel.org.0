Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD244D9F99
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 17:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349870AbiCOQGQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 12:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349837AbiCOQGL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 12:06:11 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526A72AE2E;
        Tue, 15 Mar 2022 09:04:59 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FEoi77012311;
        Tue, 15 Mar 2022 16:04:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=tdEYLDx1G8bzKxisHf7Abo3qouFpdoa7ZzkGJTm29gw=;
 b=tUTvlYrCkbrSz9VorIEtZFp+W7P4gTPyEdEHyZUGQz293eSXrybnSZsptki9aa8/OPew
 w6CyKpL2s0GC2jipsBUUJBViBBa8wzKPtQyjElbQUGayNvjR0puS5Q9pjhLABsWCIFqz
 SwF7b8wN8LW0eIXQjEEjEXXyhwmqDtAq6P2f8l/9k8wHZjgGLhJyDc9Fmre76BCe/mek
 K/iA3fnV13LuOFT9P27E4qCpykHtMnmqVXxdbpEisv6iAdWtKD2Zctg/YHJeGn5vYmOW
 mRDDt/hiI1igFRsGGzCWTVrKzxb9yEoLp1/IJn7HtG+cEqFiVF6Nzu0ifCYNx8rJS92F Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etvx09vsx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 16:04:52 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22FFoSrE031868;
        Tue, 15 Mar 2022 16:04:51 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etvx09vry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 16:04:51 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22FFxtjY005384;
        Tue, 15 Mar 2022 16:04:50 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02dal.us.ibm.com with ESMTP id 3etaj6r9ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 16:04:50 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22FG4mXB33948066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 16:04:48 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8426AC05E;
        Tue, 15 Mar 2022 16:04:48 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34488AC05F;
        Tue, 15 Mar 2022 16:04:37 +0000 (GMT)
Received: from [9.211.32.184] (unknown [9.211.32.184])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 15 Mar 2022 16:04:36 +0000 (GMT)
Message-ID: <dbe8488f-2539-f81a-b730-26e58b78856a@linux.ibm.com>
Date:   Tue, 15 Mar 2022 12:04:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v4 15/32] vfio: introduce KVM-owned IOMMU type
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>, borntraeger@linux.ibm.com
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        linux-s390@vger.kernel.org, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, joro@8bytes.org, will@kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-doc@vger.kernel.org
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
 <20220314194451.58266-16-mjrosato@linux.ibm.com>
 <20220314165033.6d2291a5.alex.williamson@redhat.com>
 <20220314231801.GN11336@nvidia.com>
 <9618afae-2a91-6e4e-e8c3-cb83e2f5c3d9@linux.ibm.com>
 <20220315145520.GZ11336@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20220315145520.GZ11336@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -w36gmF1H8rJjnaDs5OGV7pUR03jgs89
X-Proofpoint-ORIG-GUID: OH7K6C4R5v45F-_abHJQ5ckSN6hzhDCe
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_03,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 mlxscore=0 malwarescore=0 phishscore=0 suspectscore=0
 bulkscore=0 spamscore=0 mlxlogscore=999 adultscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150102
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/15/22 10:55 AM, Jason Gunthorpe wrote:
> On Tue, Mar 15, 2022 at 09:36:08AM -0400, Matthew Rosato wrote:
>>> If we do try to stick this into VFIO it should probably use the
>>> VFIO_TYPE1_NESTING_IOMMU instead - however, we would like to delete
>>> that flag entirely as it was never fully implemented, was never used,
>>> and isn't part of what we are proposing for IOMMU nesting on ARM
>>> anyhow. (So far I've found nobody to explain what the plan here was..)
>>>
>>
>> I'm open to suggestions on how better to tie this into vfio.  The scenario
>> basically plays out that:
> 
> Ideally I would like it to follow the same 'user space page table'
> design that Eric and Kevin are working on for HW iommu.

'[RFC v16 0/9] SMMUv3 Nested Stage Setup (IOMMU part)' ??

https://lore.kernel.org/linux-iommu/20211027104428.1059740-1-eric.auger@redhat.com/

> 
> You have an 1st iommu_domain that maps and pins the entire guest physical
> address space.

Ahh, I see.

@Christian would it be OK to pursue a model that pins all of guest 
memory upfront?

> 
> You have an nested iommu_domain that represents the user page table
> (the ioat in your language I think)

Yes

> 
> When the guest says it wants to set a user page table then you create
> the nested iommu_domain representing that user page table and pass in
> the anchor (guest address of the root IOPTE) to the kernel to do the
> work. >
> The rule for all other HW's is that the user space page table is
> translated by the top level kernel page table. So when you traverse it
> you fetch the CPU page storing the guest's IOPTE by doing an IOVA
> translation through the first level page table - not through KVM.
> 
> Since the first level page table an the KVM GPA should be 1:1 this is
> an equivalent operation.
> 
>> 1) the iommu will be domain_alloc'd once VFIO_SET_IOMMU is issued -- so at
>> that time (or earlier) we have to make the decision on whether to use the
>> standard IOMMU or this alternate KVM/nested IOMMU.
> 
> So in terms of iommufd I would see it this would be an iommufd 'create
> a device specific iomm_domain' IOCTL and you can pass in a S390
> specific data blob to make it into this special mode.
> 
>>> This is why I said the second level should be an explicit iommu_domain
>>> all on its own that is explicitly coupled to the KVM to read the page
>>> tables, if necessary.
>>
>> Maybe I misunderstood this.  Are you proposing 2 layers of IOMMU that
>> interact with each other within host kernel space?
>>
>> A second level runs the guest tables, pins the appropriate pieces from the
>> guest to get the resulting phys_addr(s) which are then passed via iommu to a
>> first level via map (or unmap)?
> 
> 
> The first level iommu_domain has the 'type1' map and unmap and pins
> the pages. This is the 1:1 map with the GPA and ends up pinning all
> guest memory because the point is you don't want to take a memory pin
> on your performance path
> 
> The second level iommu_domain points to a single IO page table in GPA
> and is created/destroyed whenever the guest traps to the hypervisor to
> manipulate the anchor (ie the GPA of the guest IO page table).
> 

That makes sense, thanks for clarifying.

>>> But I'm not sure that reading the userspace io page tables with KVM is
>>> even the best thing to do - the iommu driver already has the pinned
>>> memory, it would be faster and more modular to traverse the io page
>>> tables through the pfns in the root iommu_domain than by having KVM do
>>> the translations. Lets see what Matthew says..
>>
>> OK, you lost me a bit here.  And this may be associated with the above.
>>
>> So, what the current implementation is doing is reading the guest DMA tables
>> (which we must pin the first time we access them) and then map the PTEs of
>> the associated guest DMA entries into the associated host DMA table (so,
>> again pin and place the address, or unpin and invalidate).  Basically we are
>> shadowing the first level DMA table as a copy of the second level DMA table
>> with the host address(es) of the pinned guest page(s).
> 
> You can't pin/unpin in this path, there is no real way to handle error
> and ulimit stuff here, plus it is really slow. I didn't notice any of
> this in your patches, so what do you mean by 'pin' above?

patch 18 does some symbol_get for gfn_to_page (which will drive 
hva_to_pfn under the covers) and kvm_release_pfn_dirty and uses those 
symbols for pin/unpin.

pin/unpin errors in this series are reliant on the fact that RPCIT is 
architected to include a panic response to the guest of 'mappings failed 
for the specified range, go refresh your tables and make room', thus 
allowing this to work for pageable guests.

Agreed this would be unnecessary if we've already mapped all of guest 
memory via a 1st iommu domain.

> 
> To be like other IOMMU nesting drivers the pages should already be
> pinned and stored in the 1st iommu_domain, lets say in an xarray. This
> xarray is populated by type1 map/unmap sytem calls like any
> iommu_domain.
> 
> A nested iommu_domain should create the real HW IO page table and
> associate it with the real HW IOMMU and record the parent 1st level iommu_domain.
> 
> When you do the shadowing you use the xarray of the 1st level
> iommu_domain to translate from GPA to host physical and there is no
> pinning/etc involved. After walking the guest table and learning the
> final vIOVA it is translated through the xarray to a CPU physical and
> then programmed into the real HW IO page table.
> 
> There is no reason to use KVM to do any of this, and is actively wrong
> to place CPU pages from KVM into an IOPTE that did not come through
> the type1 map/unmap calls that do all the proper validation and
> accounting.
> 
> Jason

