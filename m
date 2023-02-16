Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8846990E8
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 11:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjBPKRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 05:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjBPKRS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 05:17:18 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B35AD3A;
        Thu, 16 Feb 2023 02:17:16 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G8fr9P001459;
        Thu, 16 Feb 2023 10:17:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=IJ/vOFfQDWnEAnUcTGF5mAtBpqxO3VI4XxcI9PPPiAw=;
 b=GKqwvUxAe1VLPSICktCvMczw71A52n17OKuBCIKekLJt0D6bjD6V3jxOJWhGbEDot+cU
 lMCH7KrftvJBN77MuEFq7w9Q2c01W4IMBU7e/ijFOVI2MtyAlLxgsWwARkIeskmXmJQh
 96zI9qadpIDCnTY/I8UTqts1ZiB/e1aOIehtob6Xt1KgYHkGcBLa42ghWkJz7qFZbbwe
 urlrJ7fpv8kzXr+4zWjtE4mtmL852CmKSzw6IXdp/LMSCIjIeCFDPrO3c/EREeqcd8sf
 EZyNN+kZ8Pi5+aOoTcQqWCeEGDU+SolhXHvtOKYrMlE+DQAzHHSJBWWhzxG6BhFWJ9b0 Tg== 
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nsfvwv25w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 10:17:15 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31G0sBUG008148;
        Thu, 16 Feb 2023 10:17:13 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3np2n6cs8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 10:17:13 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31GAH9r448693754
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 10:17:09 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF7742005A;
        Thu, 16 Feb 2023 10:17:09 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 721F92004F;
        Thu, 16 Feb 2023 10:17:09 +0000 (GMT)
Received: from [9.171.31.47] (unknown [9.171.31.47])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 16 Feb 2023 10:17:09 +0000 (GMT)
Message-ID: <fd06a430-8cc3-e754-8efc-ef1c2d61d6a5@linux.ibm.com>
Date:   Thu, 16 Feb 2023 11:17:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v1 1/1] s390: nmi: fix virtual-physical address confusion
To:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, imbrenda@linux.ibm.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20230215160252.14672-1-nrb@linux.ibm.com>
 <20230215160252.14672-2-nrb@linux.ibm.com>
 <Y+3KYSnJsznJEX4v@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
 <Y+35mHYZJlKT+e+s@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <Y+35mHYZJlKT+e+s@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0X8enNwaE6CArA7Y7ASGDGecu7smMEHa
X-Proofpoint-ORIG-GUID: 0X8enNwaE6CArA7Y7ASGDGecu7smMEHa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_07,2023-02-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 clxscore=1015
 mlxlogscore=745 mlxscore=0 adultscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160085
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/16/23 10:38, Alexander Gordeev wrote:
> On Thu, Feb 16, 2023 at 07:17:07AM +0100, Alexander Gordeev wrote:
>> Casting to (struct kvm_s390_sie_block *) is not superfluous,
> 
> s/not//

Do you want to pick this up or should it go through the kvm tree?
