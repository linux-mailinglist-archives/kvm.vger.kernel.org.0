Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9BD4E3FB9
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 14:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235785AbiCVNnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 09:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235877AbiCVNm6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 09:42:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC9185BF2;
        Tue, 22 Mar 2022 06:41:30 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22MDbMDM004427;
        Tue, 22 Mar 2022 13:41:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zBky09gpZxVUERWeYr3BZiOSqFMAs8Fbzj2n2/ZIL1M=;
 b=cKCQj0c5u1l+oi8e+lx6g1zD+za/WmjOmxUcN61U6C+41zEbruMuEvBVwWo78FCBRhYw
 vVtbReDpnXiNGMZ4KKDS82s5JRTaHzE1p1oTPq9tRKGdGpAjr0VFI4Jxjeipx9gdLRGr
 TYTPbjkXhO7TYzE+fiFrPzKOd5QjprLA4uYUrbE+boW4N1chU6Sg4BCWkIrb+8wOjdtQ
 zs/GGAd4fzhIPhzj0imkYkovH8VBXBC5sv/RT6FAO/faMDMEdzDobfxTuvuQ62BB1VP4
 Wa8+Aa2IkE6AcGQE0q8Hdo6Dwh2fDs7y6GcMD1g3CREii8xHNdeTqWGw2qsAGYtJarLf 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ey5wcc8cd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 13:41:27 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22MDdZ5P012439;
        Tue, 22 Mar 2022 13:41:27 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ey5wcc8c4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 13:41:27 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22MDZOmN003639;
        Tue, 22 Mar 2022 13:41:26 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma05wdc.us.ibm.com with ESMTP id 3ew6t9mbp3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Mar 2022 13:41:26 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22MDfOKs25559478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 13:41:25 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8FFE6E04E;
        Tue, 22 Mar 2022 13:41:24 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E05E6E052;
        Tue, 22 Mar 2022 13:41:23 +0000 (GMT)
Received: from [9.65.234.56] (unknown [9.65.234.56])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 22 Mar 2022 13:41:23 +0000 (GMT)
Message-ID: <381b7144-3e60-a825-06fb-ea15ecb4c365@linux.ibm.com>
Date:   Tue, 22 Mar 2022 09:41:22 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v18 14/18] s390/vfio-ap: sysfs attribute to display the
 guest's matrix
Content-Language: en-US
To:     jjherne@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
 <20220215005040.52697-15-akrowiak@linux.ibm.com>
 <d66ef5e1-9a77-a71c-e182-ca1f3fc17574@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <d66ef5e1-9a77-a71c-e182-ca1f3fc17574@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WPx93eGmqkoosjzIaxXGg2yp2gsj5woR
X-Proofpoint-GUID: kbt4o666BROnwwKsGqGmS7VnAruNwko0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_04,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203220078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/22/22 09:22, Jason J. Herne wrote:
> On 2/14/22 19:50, Tony Krowiak wrote:
>> The matrix of adapters and domains configured in a guest's APCB may
>> differ from the matrix of adapters and domains assigned to the matrix 
>> mdev,
>> so this patch introduces a sysfs attribute to display the matrix of
>> adapters and domains that are or will be assigned to the APCB of a guest
>> that is or will be using the matrix mdev. For a matrix mdev denoted by
>> $uuid, the guest matrix can be displayed as follows:
>>
>>     cat /sys/devices/vfio_ap/matrix/$uuid/guest_matrix
> My OCD wants you to name this matrix_guest instead of guest_matrix. 
> Simply
> because then "matrix" and "matrix_guest" will be grouped together when 
> doing
> an ls on the parent directory. As a system admin, its the little 
> things that
> make the difference :) Please consider... though I won't withhold an 
> R-b for
> it.

I am going to leave it as guest_matrix for two reasons:
1. To me, the name matrix_guest reads like the guest belongs to the 
matrix rather
     than the matrix belonging to the guest.
2. Changing it will require changes to all of the automated test cases 
that check
     sysfs to determine whether the attribute is present and I don't 
think the juice
     is worth the squeeze.

>
> Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
>

