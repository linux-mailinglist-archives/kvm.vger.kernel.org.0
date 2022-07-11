Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E875703E5
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 15:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiGKNLk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 09:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiGKNLj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 09:11:39 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0ACC32BA0;
        Mon, 11 Jul 2022 06:11:37 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26BCF8xv033132;
        Mon, 11 Jul 2022 13:11:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=eQYTAUtlK4KQtrI8ZC0Zaa7tKHqcmCRhAJiKQW2M0xs=;
 b=b0zw5cLI7R9Gsk5o04LrISaWON2fArTFCokZg7bXQSeRBIVnsYXppqn0HNXsDEWUQaq7
 JDI+e9vFTRsZoH+fPQFjfHu3OEsZ/SQCb4ItEYpfe1acl+CPoRbYhtfV0Xz14oeGKLtK
 Fml0IEx231jcA1OCMWu4xiOyj1eLmgQMrJmfsgKMSyTdDC0NinLzTp/hJyHVYPX4HWYb
 kwJClbG6HdrslSp4ayiPKX0MV/xekpfZARIz2/PxqzpwS/P9+dsGQRsSwmdRULxY/VAn
 wz0odsC3l4Ii6KN+1ZHTeOXBzG7yrzPo2CpdZiJ/g0vi01KY1qBxqJg9biK0F6VmEbc/ XA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h8hkc4eya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 13:11:36 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26BAnPuJ019205;
        Mon, 11 Jul 2022 13:11:36 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h8hkc4ex9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 13:11:36 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26BD6MUI012839;
        Mon, 11 Jul 2022 13:11:34 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3h71a8t34g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jul 2022 13:11:34 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26BDA4pl22610258
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Jul 2022 13:10:04 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2902211C052;
        Mon, 11 Jul 2022 13:11:31 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA04111C04C;
        Mon, 11 Jul 2022 13:11:30 +0000 (GMT)
Received: from [9.171.15.135] (unknown [9.171.15.135])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Jul 2022 13:11:30 +0000 (GMT)
Message-ID: <754d4ea2-8a1a-9b09-50c1-f877696b81f2@linux.ibm.com>
Date:   Mon, 11 Jul 2022 15:11:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/1] KVM: s390: Add facility 197 to the white list
Content-Language: en-US
To:     KVM <kvm@vger.kernel.org>
Cc:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
References: <20220711115108.6494-1-borntraeger@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220711115108.6494-1-borntraeger@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CfQpzrAjbAvXb9MKqtlhYNwXBZWk_iaW
X-Proofpoint-ORIG-GUID: XOcRegnwfmIzPU5FYcrljutwZWBnsso6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-11_18,2022-07-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 malwarescore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207110056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 11.07.22 um 13:51 schrieb Christian Borntraeger:
> z16 also provides facility 197 (The processor-activity-instrumentation
> extension 1). Lets add it to KVM.
> 
> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> ---
>   arch/s390/tools/gen_facilities.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/s390/tools/gen_facilities.c b/arch/s390/tools/gen_facilities.c
> index 530dd941d140..cb0aff5c0187 100644
> --- a/arch/s390/tools/gen_facilities.c
> +++ b/arch/s390/tools/gen_facilities.c
> @@ -111,6 +111,7 @@ static struct facility_def facility_defs[] = {
>   			193, /* bear enhancement facility */
>   			194, /* rdp enhancement facility */
>   			196, /* processor activity instrumentation facility */
> +			197, /* processor activity instrumentation extension 1 */
>   			-1  /* END */
>   		}
>   	},

Unless there are complaints, I will queue this with "white list" -> "allow list" and "lets" -> "let's".
