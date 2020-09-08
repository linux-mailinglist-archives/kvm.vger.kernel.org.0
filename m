Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53DC261B21
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 20:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731280AbgIHSzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 14:55:31 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:20110 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728350AbgIHSyu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Sep 2020 14:54:50 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 088IXZZd060588;
        Tue, 8 Sep 2020 14:54:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=YPY+Z8lLZHccuoXJgk288xOmQXMV5vbQugXDWW9wyfA=;
 b=MKo8FGI8UaVB8fVz8LVcnNXD1HBUwimVgyVP22Yp9/7MyX1skYNyAHZRGRzDh0cf4bFT
 igBOGrtVs43YfSjlIJbl7qqdUZjTXQoxo6thNdkC0B66vK1vLpb2tF2yvdd6N5vwdq9U
 ZWuvzYs2wP38AklKx6N7LOLWUqRnWy7XBfugB6FdA40/QbPnpoCu2ppwASHXipIIki+I
 rTy8HsKIpytCHpIbWqyUmI60DtNoLIk3I8L6+6zFDDROaItKGl6Et3T33dy6nvj6puE+
 0AHFBC9CUQyTxDupoTkeueOuMGucINf4/yT/N98Jgq6kjVp0jYD+ZA0vsQyFixgkc4rz UA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33edfjcqr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 14:54:46 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 088IY337063620;
        Tue, 8 Sep 2020 14:54:46 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33edfjcqqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 14:54:46 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 088IqGOZ028541;
        Tue, 8 Sep 2020 18:54:45 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03dal.us.ibm.com with ESMTP id 33c2a8ywgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 18:54:45 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 088Ish9e53870928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Sep 2020 18:54:43 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60D7FB205F;
        Tue,  8 Sep 2020 18:54:43 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 917EEB2064;
        Tue,  8 Sep 2020 18:54:42 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.141.115])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  8 Sep 2020 18:54:42 +0000 (GMT)
Subject: Re: [PATCH v10 02/16] s390/vfio-ap: use new AP bus interface to
 search for queue devices
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, kernel test robot <lkp@intel.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
 <20200821195616.13554-3-akrowiak@linux.ibm.com>
 <37cd9b7e-a619-6603-7e47-f5e85814d673@de.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <34c10327-8640-24e8-b882-96962cae5050@linux.ibm.com>
Date:   Tue, 8 Sep 2020 14:54:42 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <37cd9b7e-a619-6603-7e47-f5e85814d673@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_09:2020-09-08,2020-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 suspectscore=0 clxscore=1015 impostorscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009080171
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/4/20 4:11 AM, Christian Borntraeger wrote:
>
> On 21.08.20 21:56, Tony Krowiak wrote:
>> This patch refactor's the vfio_ap device driver to use the AP bus's
>> ap_get_qdev() function to retrieve the vfio_ap_queue struct containing
>> information about a queue that is bound to the vfio_ap device driver.
>> The bus's ap_get_qdev() function retrieves the queue device from a
>> hashtable keyed by APQN. This is much more efficient than looping over
>> the list of devices attached to the AP bus by several orders of
>> magnitude.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> Reported-by: kernel test robot <lkp@intel.com>
> I think this can go. No need to mark that an earlier version of this patch had an issue.

I was just following the instructions in the robot comments. I'll get 
rid of it.

>
>
> [...]
>
>> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
>> index f46dde56b464..a2aa05bec718 100644
>> --- a/drivers/s390/crypto/vfio_ap_private.h
>> +++ b/drivers/s390/crypto/vfio_ap_private.h
>> @@ -18,6 +18,7 @@
>>   #include <linux/delay.h>
>>   #include <linux/mutex.h>
>>   #include <linux/kvm_host.h>
>> +#include <linux/hashtable.h>
> I dont think that this header file needs it. Any user of it will now include this.
> Can you move this include into the respective C file when the hash stuff is
> used?

I can.

>
>
> Other than that this looks good.

