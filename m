Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7FA5A4E12
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 15:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiH2N3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 09:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiH2N3S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 09:29:18 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2302E79A74;
        Mon, 29 Aug 2022 06:28:55 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27TDE5I4010778;
        Mon, 29 Aug 2022 13:28:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=dXD9swvkZ5AaQz5vGXwU9H/FB+K5Bq2dj89N70m7cBI=;
 b=i7FMxb3rwOYlbiC4VTqqBnaLcoU0UZ+LXsLUyTtwKrEQXLewKARiEZa9rMWypmMGyi+R
 Rz/piiiOtuPbUwlIoGSERpvxTv9eXzckDazbZcKRnH6rv0DDlPe1wQBTZuSmWFMmw1IF
 Ouxo5xR+8mf4j3dLbCB/UUQ6omUfDg3FMzK4GWtjZfJbnvhFCfjsfx8dqdxLB7lsW1Ct
 bWXOPo/Mm204TSSM663QBZIU3Erbak6ydDxNrch3Yuvqi04PkzB1U1ibnNbFGEKy1eql
 8ig7v8UOoXZb6ncPPyLewnfmcs3a3U8BLFChWJLOdv3eTkezEapKV37yqEPO4wUSik5x 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j8x5d8djk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Aug 2022 13:28:54 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27TDEBxq011393;
        Mon, 29 Aug 2022 13:28:54 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j8x5d8dj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Aug 2022 13:28:53 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27TDK9xI030512;
        Mon, 29 Aug 2022 13:28:53 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03dal.us.ibm.com with ESMTP id 3j7awagnqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Aug 2022 13:28:53 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27TDSqA842598728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Aug 2022 13:28:52 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 125A32805A;
        Mon, 29 Aug 2022 13:28:52 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 943E828059;
        Mon, 29 Aug 2022 13:28:51 +0000 (GMT)
Received: from [9.160.64.167] (unknown [9.160.64.167])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 29 Aug 2022 13:28:51 +0000 (GMT)
Message-ID: <1e3a21be-c103-3478-ae91-2f5a721c465d@linux.ibm.com>
Date:   Mon, 29 Aug 2022 09:28:51 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 0/2] s390/vfio-ap: fix two problems discovered in the
 vfio_ap driver
Content-Language: en-US
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com
References: <20220823150643.427737-1-akrowiak@linux.ibm.com>
In-Reply-To: <20220823150643.427737-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: P-ahZGfK52ObdocQsludQcSGk1o9yIKX
X-Proofpoint-GUID: 5cWLmAV-JK548-Bp0Lf1dOQe1g3zJ1d9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-29_07,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0 phishscore=0
 impostorscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208290060
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These two patches fix a couple of bugs in the vfio_ap driver code, it 
would be nice to get some r-b action so we can merge these fixes ASAP. 
Thanks.

On 8/23/22 11:06 AM, Tony Krowiak wrote:
> Two problems have been discovered with the vfio_ap device driver since the
> hot plug support was recently introduced:
>
> 1. Attempting to remove a matrix mdev after assigning a duplicate adapter
>     or duplicate domain results in a hang.
>
> 2. The queues associated with an adapter or domain being unassigned from
>     the matrix mdev do not get unlinked from it.
>
> Two patches are provided to resolve these problems.
>
> Change log v2 => v3:
> --------------------
> * Replaced the wrong commit IDs in the 'Fixes' tags in both patches.
>    (Halil and Alexander)
>
> * Changed the subject line and description of patch 01/02 to better reflect the
>    code changes in the patch. (Halil)
>
> Tony Krowiak (2):
>    s390/vfio-ap: bypass unnecessary processing of AP resources
>    s390/vfio-ap: fix unlinking of queues from the mdev
>
>   drivers/s390/crypto/vfio_ap_ops.c | 36 +++++++++++++++++++++++++++----
>   1 file changed, 32 insertions(+), 4 deletions(-)
>
