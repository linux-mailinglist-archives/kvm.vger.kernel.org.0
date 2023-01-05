Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9746A65F0D6
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 17:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234892AbjAEQGy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 11:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234951AbjAEQGj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 11:06:39 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2917D32E81;
        Thu,  5 Jan 2023 08:06:37 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305Fg5kZ008104;
        Thu, 5 Jan 2023 16:06:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=3z89m38tZ00stHG2meV21eS5wjurrMFlvqCdg83PPxY=;
 b=RQr3M+SkWWsOaZEdJxrMNwcn16L4tY2p1c736V7rOnD+BEM1XtC4+iMN8Z4bErVTbmG6
 aCkOJTAzS9gY8waeTlwBqML2X9Kg+Rj9b2/xDXBP+BZyq0ph0l3LootESGsGgLKQxcHM
 Blt8bfJsBQpoPSfGfouFNfxTY1UuDIN1OViU9/4Av00PjxOOAJrjtxR1EN3LvikC0rq3
 r0uv4HkJe24R/jRNfc6kjhATtwskn4h/aXR9gRiMujkcMQlpEe1wfY0yHvmCb1vudOQ2
 tBxGvo1WWzY2h7ukCuvxSizsaplhuWBHFotYvcxIZvvzkezMfMyGlPaSTIoZz4NUF/M1 Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx1dsgp29-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 16:06:36 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 305FtJMa025563;
        Thu, 5 Jan 2023 16:06:36 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx1dsgp1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 16:06:36 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 305DLs8L019434;
        Thu, 5 Jan 2023 16:06:34 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([9.208.129.114])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3mtcq7xnrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 16:06:34 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
        by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 305G6Wxd43450854
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Jan 2023 16:06:33 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1F635803F;
        Thu,  5 Jan 2023 16:06:32 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE92758060;
        Thu,  5 Jan 2023 16:06:31 +0000 (GMT)
Received: from [9.160.126.91] (unknown [9.160.126.91])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  5 Jan 2023 16:06:31 +0000 (GMT)
Message-ID: <dcd428a4-aaed-060e-34e0-69f931986ae6@linux.ibm.com>
Date:   Thu, 5 Jan 2023 11:06:31 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 1/1] vfio/type1: Respect IOMMU reserved regions in
 vfio_test_domain_fgsp()
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        Pierre Morel <pmorel@linux.ibm.com>,
        =?UTF-8?Q?Christian_Borntr=c3=a4ger?= <borntraeger@linux.ibm.com>
References: <20230104154202.1152198-1-schnelle@linux.ibm.com>
 <20230104154202.1152198-2-schnelle@linux.ibm.com>
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20230104154202.1152198-2-schnelle@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CL4dAM2FqwkSC6SaXCgGGiElCX_NhQyz
X-Proofpoint-ORIG-GUID: 12IPlv6-R3GtNBaqqw7hLyhslFOQewSl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_06,2023-01-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxscore=0 priorityscore=1501 spamscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301050126
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/4/23 10:42 AM, Niklas Schnelle wrote:
> Since commit cbf7827bc5dc ("iommu/s390: Fix potential s390_domain
> aperture shrinking") the s390 IOMMU driver uses reserved regions for the
> system provided DMA ranges of PCI devices. Previously it reduced the
> size of the IOMMU aperture and checked it on each mapping operation.
> On current machines the system denies use of DMA addresses below 2^32 for
> all PCI devices.
> 
> Usually mapping IOVAs in a reserved regions is harmless until a DMA
> actually tries to utilize the mapping. However on s390 there is
> a virtual PCI device called ISM which is implemented in firmware and
> used for cross LPAR communication. Unlike real PCI devices this device
> does not use the hardware IOMMU but inspects IOMMU translation tables
> directly on IOTLB flush (s390 RPCIT instruction). If it detects IOVA
> mappings outside the allowed ranges it goes into an error state. This
> error state then causes the device to be unavailable to the KVM guest.
> 
> Analysing this we found that vfio_test_domain_fgsp() maps 2 pages at DMA
> address 0 irrespective of the IOMMUs reserved regions. Even if usually
> harmless this seems wrong in the general case so instead go through the
> freshly updated IOVA list and try to find a range that isn't reserved,
> and fits 2 pages, is PAGE_SIZE * 2 aligned. If found use that for
> testing for fine grained super pages.
> 
> Fixes: 6fe1010d6d9c ("vfio/type1: DMA unmap chunking")
> Reported-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>

Thanks, this fixes the issue I'm seeing with ISM.

Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>


