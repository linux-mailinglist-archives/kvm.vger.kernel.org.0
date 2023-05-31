Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC332718116
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 15:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236298AbjEaNJw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 09:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236353AbjEaNJn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 09:09:43 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDBD12B;
        Wed, 31 May 2023 06:09:38 -0700 (PDT)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VD9Lax002204;
        Wed, 31 May 2023 13:09:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sMz3fBV8dPYC33/rBXj9AWmlDxb8zVk1GGTa8nX1C2Q=;
 b=BqbYo63Hc1u0zI/frttUAReKRXg0gk8GxnjvcEETvN5uEdDYkf9w7z8yOvp/qrtmwyfW
 YpPqCEv57vn0p/W3/O3jMu8NL9etOcGGApSXZOFnI/EF81ndrykJLi50Co2Htww9flh/
 qhhpasMstaEW7S4aEUh1HBjxJ+VPQRwEMJ6e4RYLGEQtPvF+/Huzm4CKADKf33gDEvZm
 UR/5l/YsQupdYi5sp7RTtRI74bg4ZDsZ2HhM2XEvzATk9qp9mxBSVX3BMU2ebHRdtbng
 TzQg/HgW5q5zGj4dFY8IEy5DwpRwURAEABTgZ9qBRhpA8vn/anuad7vPHkb+FUBDJsgF MQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qx4y3kxvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 13:09:37 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34VD9a6T003770;
        Wed, 31 May 2023 13:09:36 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qx4y3kxcs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 13:09:32 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34VC61s5012669;
        Wed, 31 May 2023 13:05:28 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([9.208.129.117])
        by ppma05wdc.us.ibm.com (PPS) with ESMTPS id 3qu9g5upb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 13:05:28 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34VD5Qkw6554346
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 13:05:26 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 62A9158043;
        Wed, 31 May 2023 13:05:26 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A12C958059;
        Wed, 31 May 2023 13:05:25 +0000 (GMT)
Received: from [9.61.88.233] (unknown [9.61.88.233])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 31 May 2023 13:05:25 +0000 (GMT)
Message-ID: <64d96082-8c05-0fb8-dfdd-96ad8efa6cd8@linux.ibm.com>
Date:   Wed, 31 May 2023 09:05:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 1/3] vfio: ap: realize the VFIO_DEVICE_GET_IRQ_INFO ioctl
Content-Language: en-US
To:     =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clegoate@redhat.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com, farman@linux.ibm.com,
        mjrosato@linux.ibm.com, alex.williamson@redhat.com,
        borntraeger@linux.ibm.com
References: <20230530223538.279198-1-akrowiak@linux.ibm.com>
 <20230530223538.279198-2-akrowiak@linux.ibm.com>
 <ee46966a-920a-37f6-9554-b2b10565cd58@redhat.com>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <ee46966a-920a-37f6-9554-b2b10565cd58@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3RBfMaAZAUFoEmKC1LkL4tw7WHS7K3Gw
X-Proofpoint-ORIG-GUID: QtVqwoq2wQHB85KJRhZSvUA9fXwzf9Lj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_08,2023-05-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 malwarescore=0 adultscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=850 clxscore=1015 spamscore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305310112
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/31/23 8:54 AM, Cédric Le Goater wrote:
> Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thank you for the review.
