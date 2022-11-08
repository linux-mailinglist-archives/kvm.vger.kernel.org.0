Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7486620CF2
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 11:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbiKHKN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 05:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233819AbiKHKN0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 05:13:26 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9722D756;
        Tue,  8 Nov 2022 02:13:20 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A89WvsG008722;
        Tue, 8 Nov 2022 10:12:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=dbSjy/6KboOVvEXug4RHKIbkd5zdJQGaWqPn2F0vmvw=;
 b=IgdXE9I+HvXUz4eIuyzU5UFe6yeJOGnCtSBWlJhIAh/xNHnbyrxJy/CbyK0p3C04yTMJ
 GmhK3qDhp0LMLd7D6IRA53r4BdKKUUIikyZFBSLjCWpMX+SdlJl4zUU/Ye7RYesNTC2R
 cTuiz7NAVy7f5XMiI7UPbfQNIzV2Qw7jd/68ba6w0V05eEJyttuBnCJyg+7ihpTdyAZP
 FB+Q9JN0IkhL/5D8g6KkM77/vM2lSYzql0VjvT+Yxf9xO3F+K8wQvFs3q/sCh00B2cVy
 KnMbh2bSnus9rSZW7FtOWRBX3RI6tYfwaKv0ceAxLlmdRGa1S3/dANyVmFaS0u+vDgcj rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kqkjf33d6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 10:12:58 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A89mkPA021424;
        Tue, 8 Nov 2022 10:12:58 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kqkjf33c1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 10:12:58 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A8A6TD7021901;
        Tue, 8 Nov 2022 10:12:55 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3kngp5ju97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 10:12:55 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A8ACqI366060624
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Nov 2022 10:12:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87C01A404D;
        Tue,  8 Nov 2022 10:12:52 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D19E3A4051;
        Tue,  8 Nov 2022 10:12:51 +0000 (GMT)
Received: from [9.171.92.113] (unknown [9.171.92.113])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  8 Nov 2022 10:12:51 +0000 (GMT)
Message-ID: <fbb84105-cc6e-59bd-b09c-0ea4353d7605@linux.ibm.com>
Date:   Tue, 8 Nov 2022 11:12:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: S390 testing for IOMMUFD
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <0-v4-0de2f6c78ed0+9d1-iommufd_jgg@nvidia.com>
 <Y2msLjrbvG5XPeNm@nvidia.com>
Content-Language: en-US
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <Y2msLjrbvG5XPeNm@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 88b1RjTTYRBxlBTkBjyzFSdWP3OuxAdE
X-Proofpoint-GUID: Kk3uXu49M0BUpX-dT-SrN4RafkObPTS3
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 impostorscore=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 lowpriorityscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211080054
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 08.11.22 um 02:09 schrieb Jason Gunthorpe:
> On Mon, Nov 07, 2022 at 08:48:53PM -0400, Jason Gunthorpe wrote:
>> [
>> This has been in linux-next for a little while now, and we've completed
>> the syzkaller run. 1300 hours of CPU time have been invested since the
>> last report with no improvement in coverage or new detections. syzkaller
>> coverage reached 69%(75%), and review of the misses show substantial
>> amounts are WARN_ON's and other debugging which are not expected to be
>> covered.
>> ]
>>
>> iommufd is the user API to control the IOMMU subsystem as it relates to
>> managing IO page tables that point at user space memory.
> 
> [chop cc list]
> 
> s390 mdev maintainers,
> 
> Can I ask your help to test this with the two S390 mdev drivers? Now
> that gvt is passing and we've covered alot of the QA ground it is a
> good time to run it.
> 
> Take the branch from here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/log/?h=for-next

> 
> And build the kernel with
> 
> CONFIG_VFIO_CONTAINER=n
> CONFIG_IOMMUFD=y
> CONFIG_IOMMUFD_VFIO_CONTAINER=y
> 
> And your existing stuff should work with iommufd providing the iommu
> support to vfio. There will be a dmesg confirming this.

Gave it a quick spin with vfio_ap:
[  401.679199] vfio_ap_mdev b01a7c33-9696-48b2-9a98-050e8e17c69a: Adding to iommu group 1
[  402.085386] iommufd: IOMMUFD is providing /dev/vfio/vfio, not VFIO.

Some tests seem to work, but others dont (running into timeouts). I need to look
into that (or ideally Tony will have a look, FWIW tests.test_vfio_ap.VfioAPAssignMdevToGuestTest
fails for me.


The same kernel tree with defconfig (instead of CONFIG_IOMMUFD_VFIO_CONTAINER=y) works fine.
> 
> Let me know if there are any problems!
> 
> If I recall there was some desire from the S390 platform team to start
> building on iommufd to create some vIOMMU acceleration for S390
> guests, this is a necessary first step.
> 
> Thanks,
> Jason
