Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DB7528AAD
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 18:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343719AbiEPQhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 12:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236382AbiEPQhK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 12:37:10 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E4F12AEF;
        Mon, 16 May 2022 09:37:09 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GGKns2026024;
        Mon, 16 May 2022 16:37:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=ShGjbpglBLalouXVGtD53uU+kTztPxlAOqZ9DvtSfFs=;
 b=O3nn3umTcB1LRzxinxpRPx4HIh2/BOMdTewlyW+aYcpAsuMupBSGUOVqo6BIl8bLpPuD
 bOyq0R490pN+MzfvvJvjm1T59fPpeTlhqtrV0rCAkQ5uBqYZGiAz8MAKG3mJON+iukMW
 vFaLRbDWG+KeUg5+LJ7unbKVtVhRxsCnNMBhMzuOWRkpAdDgB1oKITvdzpJmQwQKKASW
 GrLNdyYvgZTZeQUcnAxmdG5VDwmo3nVurkU8pMLKobWUFLUBEkbupdS9C3YV2Iw1BHcb
 psIndOIHK0tvFTnqRbDJae5OSUtDbCrwevzczQKqphFTY1fFInxYJ0Mpr/RQE+GFVcym jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3r0rukfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 16:37:07 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24GGZGDR008862;
        Mon, 16 May 2022 16:37:07 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3r0rukfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 16:37:07 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24GGSJcW001755;
        Mon, 16 May 2022 16:37:06 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma04wdc.us.ibm.com with ESMTP id 3g2429ye3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 16:37:06 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24GGb5MZ31785276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 16:37:05 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4442E7806B;
        Mon, 16 May 2022 16:37:05 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79D0A78072;
        Mon, 16 May 2022 16:37:04 +0000 (GMT)
Received: from [9.60.75.219] (unknown [9.60.75.219])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 16:37:04 +0000 (GMT)
Message-ID: <fc760c00-0559-68d8-fd2d-f29e014a6685@linux.ibm.com>
Date:   Mon, 16 May 2022 12:36:48 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v19 05/20] s390/vfio-ap: refresh guest's APCB by filtering
 AP resources assigned to mdev
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
 <20220404221039.1272245-6-akrowiak@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220404221039.1272245-6-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vQpxaQ3mIYbErmPuXYReqZu7Zmoam7Yc
X-Proofpoint-GUID: dwU_Y9Pm6byppR9FAOk-5b6waUgk_IbD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_15,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 clxscore=1011 malwarescore=0 suspectscore=0
 adultscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2205160092
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/4/22 18:10, Tony Krowiak wrote:
> |@@ -1306,8 +1392,6 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev, 
> kvm_get_kvm(kvm); matrix_mdev->kvm = kvm; - memcpy(&matrix_mdev->shadow_apcb, 
> &matrix_mdev->matrix, - sizeof(struct ap_matrix)); kvm_arch_crypto_set_masks(kvm, 
> matrix_mdev->shadow_apcb.apm, matrix_mdev->shadow_apcb.aqm, matrix_mdev->shadow_apcb.adm);|

This looks like an unrelated change. Does this snippet really belong to this patch?

-- 
-- Jason J. Herne (jjherne@linux.ibm.com)
