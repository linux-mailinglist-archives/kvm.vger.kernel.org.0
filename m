Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2B54DA0B7
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 18:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350276AbiCORDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 13:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350449AbiCORDG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 13:03:06 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340335714B;
        Tue, 15 Mar 2022 10:01:53 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FGER9D019722;
        Tue, 15 Mar 2022 17:01:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=UOFhKzT17r8nHIqX6nZiw4Y/vWOMIJIOjcg3nyKy1QQ=;
 b=R3UGugpuMTgE6waYe6YGdG7UhuL+IOk70WHlR4rlVjJlpz2++90ODFIhl5VfmtPJuFgL
 yhXV5WhPBh9h49nAuLqAkUTVW/SfULAbLp7QObDFfeHnwm9JK8rk5hHdVTQLME5sAPXC
 rzjDKCAWn5MfgsQzP1LXeIoNc9aapdtfpYM3JcuLN1wB6Yr3rfGjXX0i/8zVtIcvVzrn
 apYAkwUgsIDTjA0WnuM0UT6q3K1zFF4KOk7ndyMMnsuJwcwY0xYI1p7l/SMFXrUbCwLr
 BTVapz29vWqrmm4AKhcRLwnC7rQmWmBtJK6w+dv2Y5ULXn9kLfRWjAGDlHC2RDgrAKvf Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etvbmcbww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 17:01:34 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22FGpTNY030717;
        Tue, 15 Mar 2022 17:01:34 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etvbmcbw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 17:01:34 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22FGxCYP013147;
        Tue, 15 Mar 2022 17:01:33 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma05wdc.us.ibm.com with ESMTP id 3erk59y3ec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 17:01:32 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22FH1ViF33227018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 17:01:31 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56FCF6A051;
        Tue, 15 Mar 2022 17:01:31 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7A9B6A047;
        Tue, 15 Mar 2022 17:01:28 +0000 (GMT)
Received: from [9.211.32.184] (unknown [9.211.32.184])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 15 Mar 2022 17:01:28 +0000 (GMT)
Message-ID: <99c7585c-47c5-9995-3fe6-c75f412b3479@linux.ibm.com>
Date:   Tue, 15 Mar 2022 13:01:27 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v4 15/32] vfio: introduce KVM-owned IOMMU type
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "schnelle@linux.ibm.com" <schnelle@linux.ibm.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "hca@linux.ibm.com" <hca@linux.ibm.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
        "svens@linux.ibm.com" <svens@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "vneethv@linux.ibm.com" <vneethv@linux.ibm.com>,
        "oberpar@linux.ibm.com" <oberpar@linux.ibm.com>,
        "freude@linux.ibm.com" <freude@linux.ibm.com>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
 <20220314194451.58266-16-mjrosato@linux.ibm.com>
 <20220314165033.6d2291a5.alex.williamson@redhat.com>
 <20220314231801.GN11336@nvidia.com>
 <BL1PR11MB5271DE700698C5FB11F5EEE78C109@BL1PR11MB5271.namprd11.prod.outlook.com>
 <72dd168c-dd40-356c-1fe5-02bdfca57d73@linux.ibm.com>
In-Reply-To: <72dd168c-dd40-356c-1fe5-02bdfca57d73@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: N7tfK37i4kJI7EzIQuKp76cTvmkOIo_4
X-Proofpoint-ORIG-GUID: Ohnogp1Ve9NEPlsuNV3Iw-LKunz56h8i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_08,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 spamscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150104
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/15/22 10:17 AM, Matthew Rosato wrote:
> On 3/15/22 3:57 AM, Tian, Kevin wrote:
>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>> Sent: Tuesday, March 15, 2022 7:18 AM
>>>
>>> On Mon, Mar 14, 2022 at 04:50:33PM -0600, Alex Williamson wrote:
>>>
>>>>> +/*
>>>>> + * The KVM_IOMMU type implies that the hypervisor will control the
>>> mappings
>>>>> + * rather than userspace
>>>>> + */
>>>>> +#define VFIO_KVM_IOMMU            11
>>>>
>>>> Then why is this hosted in the type1 code that exposes a wide variety
>>>> of userspace interfaces?  Thanks,
>>>
>>> It is really badly named, this is the root level of a 2 stage nested
>>> IO page table, and this approach needed a special flag to distinguish
>>> the setup from the normal iommu_domain.
>>>
>>> If we do try to stick this into VFIO it should probably use the
>>> VFIO_TYPE1_NESTING_IOMMU instead - however, we would like to delete
>>> that flag entirely as it was never fully implemented, was never used,
>>> and isn't part of what we are proposing for IOMMU nesting on ARM
>>> anyhow. (So far I've found nobody to explain what the plan here was..)
>>>
>>> This is why I said the second level should be an explicit iommu_domain
>>> all on its own that is explicitly coupled to the KVM to read the page
>>> tables, if necessary.
>>>
>>> But I'm not sure that reading the userspace io page tables with KVM is
>>> even the best thing to do - the iommu driver already has the pinned
>>> memory, it would be faster and more modular to traverse the io page
>>> tables through the pfns in the root iommu_domain than by having KVM do
>>> the translations. Lets see what Matthew says..
>>>
>>
>> Reading this thread it's sort of like an optimization to software 
>> nesting.
> 
> Yes, we want to avoid breaking to userspace for a very frequent 
> operation (RPCIT / updating shadow mappings)
> 
>> If that is the case does it make more sense to complete the basic form
>> of software nesting first and then adds this optimization?
>>
>> The basic form would allow the userspace to create a special domain
>> type which points to a user/guest page table (like hardware nesting)
>> but doesn't install the user page table to the IOMMU hardware (unlike
>> hardware nesting). When receiving invalidate cmd from userspace > the 
>> iommu driver walks the user page table (1st-level) and the parent
>> page table (2nd-level) to generate a shadow mapping for the
>> invalidated range in the non-nested hardware page table of this
>> special domain type.
>>
>> Once that works what this series does just changes the matter of
>> how the invalidate cmd is triggered. Previously iommu driver receives
>> invalidate cmd from Qemu (via iommufd uAPI) while now receiving
>> the cmd from kvm (via iommufd kAPI) upon interception of RPCIT.
>>  From this angle once the connection between iommufd and kvm fd
>> is established there is even no direct talk between iommu driver and
>> kvm.
> 
> But something somewhere still needs to be responsible for 
> pinning/unpinning of the guest table entries upon each RPCIT 
> interception.  e.g. the RPCIT intercept can happen because the guest 
> wants to invalidate some old mappings or has generated some new mappings 
> over a range, so we must shadow the new mappings (by pinning the guest 
> entries and placing them in the host hardware table / unpinning 
> invalidated ones and clearing their entry in the host hardware table).
> 

OK, this got clarified by Jason in another thread: What I was missing 
here was an assumption that the 1st-level has already mapped and pinned 
all of guest physical address space; in that case there's no need to 
invoke pin/unpin operations against a kvm from within the iommu domain 
(this series as-is does not pin all of the guest physical address space; 
it does pins/unpins on-demand at RPCIT time)
