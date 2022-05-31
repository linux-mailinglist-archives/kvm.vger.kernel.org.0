Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED195391C6
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 15:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344041AbiEaNWd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 09:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238311AbiEaNWb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 09:22:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5C0541BB;
        Tue, 31 May 2022 06:22:30 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24VCNAVk024413;
        Tue, 31 May 2022 13:22:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=BrvagsYMt9G+0lZdV4MGWfIeYrtKVExehOIPqsI+tGE=;
 b=miA6Hrts2QsjLgeo5Ijaa4TiO4LmqN3rzJBAfRDc/fCGQW4cugwmZuJLvOb8mQZwrSKi
 Q5ixfwS8fl0Z5S+B9gR4kLQ/SoH40FReDoNfpbxEmRT9vNTPOf2x/0jDEICPEBkD8Wjv
 ui7+I4oMYaGoa/X0f1wspbF1UwbTsrGQhwxbxPwBqtGMM1Cg48phKY7hCSu9XFeWr2G7
 7gQCbZW/R7mVqVMHPZMxnRELkRdnlXKuFMVHmMDtIUVzFoitpZq4HQd3IEXiQHlmPpJt
 cOWR6r4GcKwidMXAW6wnvr4JGXhq9ar6Qhn3gbq4LKrk5QzxOh9VX/OxZMiUihFiwiOi UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gdjyr95a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 13:22:27 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24VDIgLX004856;
        Tue, 31 May 2022 13:22:27 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gdjyr959y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 13:22:27 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24VD6Y9e011985;
        Tue, 31 May 2022 13:22:26 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02dal.us.ibm.com with ESMTP id 3gd1acq7q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 13:22:26 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24VDMPkl4850572
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 May 2022 13:22:25 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F23B28059;
        Tue, 31 May 2022 13:22:25 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F49E28065;
        Tue, 31 May 2022 13:22:25 +0000 (GMT)
Received: from [9.60.75.219] (unknown [9.60.75.219])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 31 May 2022 13:22:25 +0000 (GMT)
Message-ID: <d8b68353-0c37-1c0f-b3de-c9de970a133c@linux.ibm.com>
Date:   Tue, 31 May 2022 09:22:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v19 18/20] s390/vfio-ap: update docs to include dynamic
 config support
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
 <20220404221039.1272245-19-akrowiak@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220404221039.1272245-19-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MlbOOcJNUC301_K1VYaWnI9lGsC-yVye
X-Proofpoint-ORIG-GUID: 7kYSWCCM0QbL8e61FYB6ARzPd_le9wSv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-05-31_04,2022-05-30_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205310068
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/4/22 18:10, Tony Krowiak wrote:
> Update the documentation in vfio-ap.rst to include information about the
> AP dynamic configuration support (e.g., hot plug of adapters, domains
> and control domains via the matrix mediated device's sysfs assignment
> attributes). This patch also makes a few minor tweaks to make corrections
> and clarifications.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>   Documentation/s390/vfio-ap.rst | 492 +++++++++++++++++++++++----------
>   1 file changed, 346 insertions(+), 146 deletions(-)

Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>


-- 
-- Jason J. Herne (jjherne@linux.ibm.com)
