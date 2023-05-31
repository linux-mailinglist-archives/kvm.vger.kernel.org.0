Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9ED71859F
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 17:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234271AbjEaPF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 11:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234028AbjEaPFe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 11:05:34 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C6C132;
        Wed, 31 May 2023 08:05:15 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VExh8o030623;
        Wed, 31 May 2023 15:05:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=OAFzuVl4Gut14uWD2Yrg29PHYgjJzWmlExTNSTZT85A=;
 b=CHhUirO+VMbOOydiS24nX02mODkxdd2uIMIlrEd9nBax50aXyRJHFNUYgOnjLgEYvSru
 8F76RrC6kQXsAUliMGxE0T8nUtIFtHalXenpwAoj0OhHsfzyfWqIFnSaIdTiteNayvws
 vuedf3YU6NLFPwfhWIFbb8IC68TEeR9jrVXBUDa0Cw43ztByg9AlXCZg+HMeV0hfLCDT
 qapEVJrGpoooor2I9PGtZGDpAIGaJM/wGZp1sTeCtY7xveLUfuTfCUEQ6OdxUSSx5/oh
 FhNUIp2baVeXwah6/q2+YaZJbQSMm+r69JAbM7dFMQRcEtkyQoK/cRQ0mq4ykF+kpYgF 1Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qx8g4r48m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 15:05:08 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34VF0iXM000431;
        Wed, 31 May 2023 15:05:06 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qx8g4r3r2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 15:05:06 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34VBQCfe008122;
        Wed, 31 May 2023 14:51:58 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([9.208.129.119])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3qu9g8c563-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 31 May 2023 14:51:58 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
        by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34VEpuMH36241942
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 May 2023 14:51:56 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C3185805E;
        Wed, 31 May 2023 14:51:56 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 425725805C;
        Wed, 31 May 2023 14:51:55 +0000 (GMT)
Received: from [9.61.34.174] (unknown [9.61.34.174])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 31 May 2023 14:51:55 +0000 (GMT)
Message-ID: <30741787-441a-034f-f8d4-9f1060841051@linux.ibm.com>
Date:   Wed, 31 May 2023 10:51:54 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 0/3] s390/vfio-ap: fix hang when mdev attached to guest is
 removed
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        alex.williamson@redhat.com, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, Cedric Le Goater <clegoate@redhat.com>
References: <20230530223538.279198-1-akrowiak@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <20230530223538.279198-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EmRd0YvUraoZ5bRlti79WC2E21bSGtE1
X-Proofpoint-ORIG-GUID: W1E9D6ibbAfbdenIxC64kSkaJgZ7fQgd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_10,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305310128
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/30/23 6:35 PM, Tony Krowiak wrote:
> When a user attempts to remove a vfio-ap mediated device attached to a
> guest, the operation hangs until the mdev's fd is closed by the guest
> (i.e., the hostdev is detached or the guest is shut down). This patch 
> series provides kernel-side code that allows userspace to set up a 
> communication channel that will allow the vfio_ap device driver to notify 
> userspace when a request to release the mdev is received, so that userspace
> can close the mdev fd and avoid the hang. The patch series provides the 
> following:  
> 
> 1. Introduces code to handle the VFIO_DEVICE_GET_IRQ_INFO and 
>    VFIO_DEVICE_SET_IRQS ioctl calls to set the eventfd_ctx for signaling a
>    device request to userspace. 
> 
> 2. Wires up the VFIO bus driver callback to request a release of the mdev.
>    When invoked, the vfio_ap device driver will use the eventfd_ctx set up
>    in #1 to signal a request to userspace to release the mdev.
> 

As to how this series eventually reaches master...  It touches both s390 and vfio.  

@Alex/@s390 maintainers -- I suggest it go through s390 given the diffstat, it's almost completely in s390 drivers code.  However there is a uapi hit to vfio.h (in patch 1) that should get at least an ACK from Alex beforehand.


