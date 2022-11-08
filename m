Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074336214CB
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 15:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbiKHOFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 09:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235033AbiKHOFH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 09:05:07 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A95C686AB;
        Tue,  8 Nov 2022 06:05:06 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A8DuQas018816;
        Tue, 8 Nov 2022 14:04:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Da4/O2Zd6WUKG4kUkKSzfI/XXsILh4u6FrSK9vP8CR4=;
 b=L94SbMbWrcR9dGMrLD0fzem+7JKCh2CTXoYi/1nJlevehDrfmTLUbo5JhR3LyDtIVfyN
 DI/hP/+sQtt0slqoi0GK1Ebs/S6HmPnIHXKYrSu2dSSiryfacnPxjyHqy40EzbbP3cO6
 2cRPLQFnFl+LgfeblEWukK0NL2scue4A3QPHCopEArgRPrls/pnbseWNiJE/OQ93IgvX
 gqXkP4A03dp6GeB7xMdaONhfSK//gOUKBqyT8CFJGGcfrws5Zp2gjVyWrlspJ8AHZEeh
 XdIQOFS0IdMz4cbUJrhxi1rBvVTMbSa3unh0WFnU0DTcQ9+EKJRMGZBJ0xLNXKdVw5Y1 jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kqkd8jdnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 14:04:52 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A8Cm7Oc013724;
        Tue, 8 Nov 2022 14:04:51 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kqkd8jdm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 14:04:51 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A8E4UX0009048;
        Tue, 8 Nov 2022 14:04:49 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01wdc.us.ibm.com with ESMTP id 3kngs3xxab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 14:04:49 +0000
Received: from smtpav06.dal12v.mail.ibm.com ([9.208.128.130])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A8E4kVl29819370
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Nov 2022 14:04:46 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2039C58061;
        Tue,  8 Nov 2022 14:04:48 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0BEA358059;
        Tue,  8 Nov 2022 14:04:47 +0000 (GMT)
Received: from [9.160.53.158] (unknown [9.160.53.158])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  8 Nov 2022 14:04:46 +0000 (GMT)
Message-ID: <d814e245-2255-15ce-cf3d-65788aa61689@linux.ibm.com>
Date:   Tue, 8 Nov 2022 09:04:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: S390 testing for IOMMUFD
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <0-v4-0de2f6c78ed0+9d1-iommufd_jgg@nvidia.com>
 <Y2msLjrbvG5XPeNm@nvidia.com>
 <fbb84105-cc6e-59bd-b09c-0ea4353d7605@linux.ibm.com>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <fbb84105-cc6e-59bd-b09c-0ea4353d7605@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QCSdPSDvXQEZ3KcRAL7rMnNrY2zU-c9u
X-Proofpoint-GUID: oDDYXrcvd-c8HddLK2SRDvjYSPtRFn4y
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 suspectscore=0 impostorscore=0 clxscore=1011 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211080084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/8/22 5:12 AM, Christian Borntraeger wrote:
>
>
> Am 08.11.22 um 02:09 schrieb Jason Gunthorpe:
>> On Mon, Nov 07, 2022 at 08:48:53PM -0400, Jason Gunthorpe wrote:
>>> [
>>> This has been in linux-next for a little while now, and we've completed
>>> the syzkaller run. 1300 hours of CPU time have been invested since the
>>> last report with no improvement in coverage or new detections. 
>>> syzkaller
>>> coverage reached 69%(75%), and review of the misses show substantial
>>> amounts are WARN_ON's and other debugging which are not expected to be
>>> covered.
>>> ]
>>>
>>> iommufd is the user API to control the IOMMU subsystem as it relates to
>>> managing IO page tables that point at user space memory.
>>
>> [chop cc list]
>>
>> s390 mdev maintainers,
>>
>> Can I ask your help to test this with the two S390 mdev drivers? Now
>> that gvt is passing and we've covered alot of the QA ground it is a
>> good time to run it.
>>
>> Take the branch from here:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/log/?h=for-next 
>>
>
>>
>> And build the kernel with
>>
>> CONFIG_VFIO_CONTAINER=n
>> CONFIG_IOMMUFD=y
>> CONFIG_IOMMUFD_VFIO_CONTAINER=y
>>
>> And your existing stuff should work with iommufd providing the iommu
>> support to vfio. There will be a dmesg confirming this.
>
> Gave it a quick spin with vfio_ap:
> [  401.679199] vfio_ap_mdev b01a7c33-9696-48b2-9a98-050e8e17c69a: 
> Adding to iommu group 1
> [  402.085386] iommufd: IOMMUFD is providing /dev/vfio/vfio, not VFIO.
>
> Some tests seem to work, but others dont (running into timeouts). I 
> need to look
> into that (or ideally Tony will have a look, FWIW 
> tests.test_vfio_ap.VfioAPAssignMdevToGuestTest
> fails for me.


I'm looking into it.


>
>
> The same kernel tree with defconfig (instead of 
> CONFIG_IOMMUFD_VFIO_CONTAINER=y) works fine.
>>
>> Let me know if there are any problems!
>>
>> If I recall there was some desire from the S390 platform team to start
>> building on iommufd to create some vIOMMU acceleration for S390
>> guests, this is a necessary first step.
>>
>> Thanks,
>> Jason
