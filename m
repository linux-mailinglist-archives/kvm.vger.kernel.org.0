Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7933BE71F
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 13:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhGGLbC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 07:31:02 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64912 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230354AbhGGLbB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 07:31:01 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167B4Btu063345;
        Wed, 7 Jul 2021 07:28:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sJkuiIPWL+zmNUKTo92A4q5nuVa20X2F2oVcvtl4B48=;
 b=l584uJo+PdLaJJ34AJnDmNvNxBH8UmTWl05whuvc16XR3aTJ5y9yN8zx7aexeAAiR9ul
 bPmyBrhjSEYLKw9+T25+I7X1EoYLs8f4d3zqIphzLxOiyu8D+dgWgo7ZUuUpNXIbiNkj
 N5XnzoNxW3o2Y97CutzP6K//iy8jNqvUpkELEa6kSc/rAnKzp8d8I5BPrh3njBzS3EMf
 XjTtr4J1nsXiYHzm1Hud57shOloXIkkQqMJ+beBAp/t7B3opWColMw3wsa1HR0g7Ga7r
 SHnQwcKt5CTNMzxM3Y/n1JTFHQ1FO5qFYwY/BKt7HndMBnJQbEwpTizWtVjQqgRESIpK 9w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mc15ya7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 07:28:18 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 167B4m2h069150;
        Wed, 7 Jul 2021 07:28:18 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39mc15ya6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 07:28:18 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 167BNePm012146;
        Wed, 7 Jul 2021 11:28:15 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 39jf5h9q8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Jul 2021 11:28:14 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 167BQK6936569444
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 7 Jul 2021 11:26:20 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E40664C044;
        Wed,  7 Jul 2021 11:28:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 721A14C04A;
        Wed,  7 Jul 2021 11:28:11 +0000 (GMT)
Received: from oc6887364776.ibm.com (unknown [9.152.212.90])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  7 Jul 2021 11:28:11 +0000 (GMT)
Subject: Re: [PATCH v2 1/4] s390/cio: Make struct css_driver::remove return
 void
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>,
        kernel@pengutronix.de, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-kernel@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm@vger.kernel.org, Matthew Rosato <mjrosato@linux.ibm.com>
References: <20210706154803.1631813-1-u.kleine-koenig@pengutronix.de>
 <20210706154803.1631813-2-u.kleine-koenig@pengutronix.de>
 <87zguzfn8e.fsf@redhat.com> <20210706160543.3qfekhzalwsrtahv@pengutronix.de>
From:   Vineeth Vijayan <vneethv@linux.ibm.com>
Message-ID: <ccc9c098-504d-4fd4-43a9-ccb3fa2a2232@linux.ibm.com>
Date:   Wed, 7 Jul 2021 13:28:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706160543.3qfekhzalwsrtahv@pengutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: g821e7G6u4XTyuCXz1527U4_cwagVy8v
X-Proofpoint-GUID: DRW3uRCPRiFRux4cOwzLdMv-5I0AFuBq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-07_06:2021-07-06,2021-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 phishscore=0 impostorscore=0 mlxscore=0 spamscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Thank you. I will use the modified description. This will be picked up 
by Vasily/Heiko to the s390-tree.

Also Acked-by: Vineeth Vijayan <vneethv@linux.ibm.com>

One question, is this patchset supposed to have 4 patches ? Are we 
missing one ?

On 7/6/21 6:05 PM, Uwe Kleine-König wrote:
> Argh, too much copy&paste. I make this:
>
> 	The driver core ignores the return value of css_remove()
> 	(because there is only little it can do when a device
> 	disappears) and all callbacks return 0 anyhow.
>
> to make this actually correct.
>
>> Reviewed-by: Cornelia Huck<cohuck@redhat.com>
