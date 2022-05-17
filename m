Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B051F52AB01
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 20:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352277AbiEQShD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 14:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352278AbiEQSg6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 14:36:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F1B3669E;
        Tue, 17 May 2022 11:36:56 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24HIO9vF000774;
        Tue, 17 May 2022 18:36:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xSpmZomObbwmdVwXU2DztWRfkUMxLlEd6R0FQm0Cvqk=;
 b=U94saHecCqVzoNu8qSKsqaxqQOnUHnOAGuX1nuUvJeauNa8TJZtT17AqmzfFL9ZeFu3/
 iOiz0wnGoEW6GNCUu7HBlXSXX6iVCbFb+EiFiOFXZ+MUiOGF/8/d5zOWAqNoGbB3EZZ5
 p0sI+bhehLgnQjYenZ8w6GZAiXy2BFm7udHVHXW+SRhh60lR2qmbv/8AyvjxcNwtBr3W
 PMK/e7XO9BhPQrYY9dwCaE+rRXmCjyT/S/iIcGpF1dNtIY0Kg7okwy/+5v/Iw/688qDq
 dRrzPgIZKmi9JP3G7vY7xO0u3z/VwzzSlvW2vrZlNPA0eWol2xa/7apWUwZ4KybdMhTx vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4gy10bky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 18:36:54 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24HIOO3s001298;
        Tue, 17 May 2022 18:36:54 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g4gy10bk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 18:36:54 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24HI7mkN007589;
        Tue, 17 May 2022 18:36:53 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma03dal.us.ibm.com with ESMTP id 3g242ad2gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 17 May 2022 18:36:53 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24HIapVu35914134
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 18:36:52 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D784D6A054;
        Tue, 17 May 2022 18:36:51 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1B596A04F;
        Tue, 17 May 2022 18:36:50 +0000 (GMT)
Received: from [9.65.254.31] (unknown [9.65.254.31])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 17 May 2022 18:36:50 +0000 (GMT)
Message-ID: <08b82fea-b728-0920-297a-a0d3dd8cc176@linux.ibm.com>
Date:   Tue, 17 May 2022 14:36:50 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v19 07/20] s390/vfio-ap: rename matrix_dev->lock mutex to
 matrix_dev->mdevs_lock
Content-Language: en-US
To:     jjherne@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
 <20220404221039.1272245-8-akrowiak@linux.ibm.com>
 <a26ce34d-0ed8-5479-805b-d863ff056848@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <a26ce34d-0ed8-5479-805b-d863ff056848@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GDXWZ8emObZJ-VNq_4SmZ7TreLcKDhWa
X-Proofpoint-GUID: EZERV1N4eoBxGDdVK1OzneBLJqNJ3fMW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-17_03,2022-05-17_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 mlxlogscore=827 mlxscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170108
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thank you for the review.

On 5/17/22 10:02 AM, Jason J. Herne wrote:
> Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>

