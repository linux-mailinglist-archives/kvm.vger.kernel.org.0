Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABE177E135
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 14:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244956AbjHPMN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 08:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241161AbjHPMM6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 08:12:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2BB1212F;
        Wed, 16 Aug 2023 05:12:57 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37GCAsOR002259;
        Wed, 16 Aug 2023 12:12:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7FNhRzBltffrklb4ZWXl8QxcFSZp9uWMwMZk+IG/ilI=;
 b=mWFy5FL0XrFEytTHTZrF0a8QwKYJJ0kBeCY8uxCaPp7Su9ddF8pm5k+m+q6Hy/jg3HF1
 nJpLbebtWpWjYkdlKLk6RpT+qCHcPOaVRVGUDup6gd51Hc4fpuGSzzpK9MmREOYLllAy
 HmpIpmgRnBxeYjqJtFLaOMjKxzhF0eY9NI/fZzmXWy4daAmoUY/jHq0k9YHCsLVzxRGW
 wlpCtpnOyISnudPJark72T+2pnTmptlYid7sfLQv4dIkUw+I2OjZ4LtEWOdqVnWHhFKa
 5vO6y566Gx2HhjBS4bdRyl9uGyy7mhjtlQhNv4ySUe8OKXucXvh0WqZa6LLpUKKODDVI MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgx22g6rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Aug 2023 12:12:56 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37GCB4qS003149;
        Wed, 16 Aug 2023 12:12:55 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sgx22g6r7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Aug 2023 12:12:55 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37GAQxH6001124;
        Wed, 16 Aug 2023 12:12:54 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3semsycc63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Aug 2023 12:12:53 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37GCCoY113238846
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Aug 2023 12:12:50 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A456020040;
        Wed, 16 Aug 2023 12:12:50 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3B8EC2004B;
        Wed, 16 Aug 2023 12:12:50 +0000 (GMT)
Received: from [9.152.224.253] (unknown [9.152.224.253])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 16 Aug 2023 12:12:50 +0000 (GMT)
Message-ID: <b841f8b4-b065-db5c-9339-f199301b2f12@linux.ibm.com>
Date:   Wed, 16 Aug 2023 14:12:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 00/12] s390/vfio_ap: crypto pass-through for SE guests
Content-Language: en-US
From:   Janosch Frank <frankja@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
References: <20230815184333.6554-1-akrowiak@linux.ibm.com>
 <b083c649-0032-4501-54eb-1d86af5fd4c8@linux.ibm.com>
In-Reply-To: <b083c649-0032-4501-54eb-1d86af5fd4c8@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qksQAiic00BEieg84a-LRAn5w6qJkkRv
X-Proofpoint-ORIG-GUID: JiO9OG5J-wVGIP9JdGWtqC4WmtXNkw-n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-16_10,2023-08-15_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308160105
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/16/23 13:39, Janosch Frank wrote:
> On 8/15/23 20:43, Tony Krowiak wrote:
>> This patch series is for the changes required in the vfio_ap device
>> driver to facilitate pass-through of crypto devices to a secure
>> execution guest. In particular, it is critical that no data from the
>> queues passed through to the SE guest is leaked when the guest is
>> destroyed. There are also some new response codes returned from the
>> PQAP(ZAPQ) and PQAP(TAPQ) commands that have been added to the
>> architecture in support of pass-through of crypto devices to SE guests;
>> these need to be accounted for when handling the reset of queues.
>>
> 
> @Heiko: Once this has soaked a day or two, could you please apply this
> and create a feature branch that I can pull from?

Sorry for the noise, for some reason I still had Heiko's old address in 
the address book. I'll delete it in a second.

Here we go again.
