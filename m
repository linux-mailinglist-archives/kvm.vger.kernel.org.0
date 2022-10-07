Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8555F79C7
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 16:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiJGOh1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 10:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiJGOhZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 10:37:25 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ECAAFBCF2
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 07:37:25 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 297EJASW019787;
        Fri, 7 Oct 2022 14:37:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=O/jiiHVMXq4R6DLh/TIkMPxS3A5CB1+Na0xw1/5Cpx4=;
 b=biK+3OiVbHsQYaxpSyud8u5v+7WCvkI/usk9ldtKBzijxA7fs9zVYw5orr4KZcq6KQck
 t2EbM0PeV8BEv+8mXwIDOPuw3G3s0oZuu6Qq/WBbXsKBloThB0vamqswEOgoak/CWNYo
 34icOL8troKJo2/hRg9GQ3AtOoOSJEvkz5aY3RhX3J9JpsxVNbWY70wf36s3mHWWY+8s
 ttjXUCtfTopmkPXKhR7VTB7WAnNrxbyP/KNtCknRQfzdchtNtifjVmbrUJa+CRMt7AKm
 StNsAEHGoBST7y04nCHbv79+oa1GwrwydeWFgj3IvzKQ5ZZLG6I2EZ2iygKqY2nTwPi9 Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k2ns6rn8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Oct 2022 14:37:16 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 297EQH4B017906;
        Fri, 7 Oct 2022 14:37:15 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k2ns6rn7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Oct 2022 14:37:15 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 297Eauh7017114;
        Fri, 7 Oct 2022 14:37:14 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04wdc.us.ibm.com with ESMTP id 3jxd6a9dpr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 07 Oct 2022 14:37:14 +0000
Received: from smtpav04.wdc07v.mail.ibm.com ([9.208.128.116])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 297EbDjO9241132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 7 Oct 2022 14:37:13 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3509058045;
        Fri,  7 Oct 2022 14:37:13 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4FBE58052;
        Fri,  7 Oct 2022 14:37:11 +0000 (GMT)
Received: from [9.160.126.121] (unknown [9.160.126.121])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  7 Oct 2022 14:37:11 +0000 (GMT)
Message-ID: <b04ce2fd-2c68-7b0f-ec43-3f0c27d35c0e@linux.ibm.com>
Date:   Fri, 7 Oct 2022 10:37:11 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 0/3] Allow the group FD to remain open when unplugging a
 device
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Qian Cai <cai@lca.pw>, Eric Farman <farman@linux.ibm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Yi Liu <yi.l.liu@intel.com>
References: <0-v1-90bf0950c42c+39-vfio_group_disassociate_jgg@nvidia.com>
 <20221006135315.3270b735.alex.williamson@redhat.com>
 <Yz9Z3um1HQHnEGVv@nvidia.com>
 <2a61068b-3645-27d0-5fae-65a6e1113a8d@linux.ibm.com>
 <Y0ArhhCOXEYQMC1q@nvidia.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <Y0ArhhCOXEYQMC1q@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Psptuq6elkjobD31W74qVp_Hj1c2aeIV
X-Proofpoint-GUID: U_x8CNaHzk9mDh3gjgwLASuT8XcudWre
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-06_05,2022-10-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 clxscore=1015 phishscore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=880 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210070087
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/7/22 9:37 AM, Jason Gunthorpe wrote:
> On Thu, Oct 06, 2022 at 07:28:53PM -0400, Matthew Rosato wrote:
> 
>>> Oh, I'm surprised the s390 testing didn't hit this!!
>>
>> Huh, me too, at least eventually - I think it's because we aren't
>> pinning everything upfront but rather on-demand so the missing the
>> type1 release / vfio_iommu_unmap_unpin_all wouldn't be so obvious.
>> I definitely did multiple VM (re)starts and hot (un)plugs.  But
>> while my test workloads did some I/O, the long-running one was
>> focused on the plug/unplug scenarios to recreate the initial issue
>> so the I/O (and thus pinning) done would have been minimal.
> 
> That explains ccw/ap a bit but for PCI the iommu ownership wasn't
> released so it becomes impossible to re-attach a container to the
> group. eg a 2nd VM can never be started
> 
> Ah well, thanks!
> 
> Jason

Well, this bugged me enough that I traced the v1 series without fixup and vfio-pci on s390 was OK because it was still calling detach_container on vm shutdown via this chain:

vfio_pci_remove
 vfio_pci_core_unregister_device
  vfio_unregister_group_dev
   vfio_device_remove_group
    vfio_group_detach_container

I'd guess non-s390 vfio-pci would do the same.  Alex also had the mtty mdev, maybe that's relevant.
