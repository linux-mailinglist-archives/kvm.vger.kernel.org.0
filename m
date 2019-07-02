Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5044F5D116
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 15:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfGBN65 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 09:58:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56432 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726341AbfGBN65 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Jul 2019 09:58:57 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x62DqSp2088926;
        Tue, 2 Jul 2019 09:58:40 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tg7fuufu9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Jul 2019 09:58:40 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x62Dt9D1020292;
        Tue, 2 Jul 2019 13:58:39 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03dal.us.ibm.com with ESMTP id 2tdym6xdss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Jul 2019 13:58:39 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x62DwdnW49348870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Jul 2019 13:58:39 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8B7FB2066;
        Tue,  2 Jul 2019 13:58:38 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAB0EB2065;
        Tue,  2 Jul 2019 13:58:38 +0000 (GMT)
Received: from [9.56.58.42] (unknown [9.56.58.42])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  2 Jul 2019 13:58:38 +0000 (GMT)
Subject: Re: [RFC v1 2/4] vfio-ccw: No need to call cp_free on an error in
 cp_init
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     farman@linux.ibm.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1561997809.git.alifm@linux.ibm.com>
 <5f1b69cd3a52e367f9f5014a3613768c8634408c.1561997809.git.alifm@linux.ibm.com>
 <20190702104257.102f32d3.cohuck@redhat.com>
From:   Farhan Ali <alifm@linux.ibm.com>
Message-ID: <66d92fe7-6395-46a6-b9bc-b76cbe7fb48e@linux.ibm.com>
Date:   Tue, 2 Jul 2019 09:58:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190702104257.102f32d3.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-02_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907020152
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/02/2019 04:42 AM, Cornelia Huck wrote:
> On Mon,  1 Jul 2019 12:23:44 -0400
> Farhan Ali <alifm@linux.ibm.com> wrote:
> 
>> We don't set cp->initialized to true so calling cp_free
>> will just return and not do anything.
>>
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> ---
>>   drivers/s390/cio/vfio_ccw_cp.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
>> index 5ac4c1e..cab1be9 100644
>> --- a/drivers/s390/cio/vfio_ccw_cp.c
>> +++ b/drivers/s390/cio/vfio_ccw_cp.c
>> @@ -647,8 +647,6 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
>>   
>>   	/* Build a ccwchain for the first CCW segment */
>>   	ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
>> -	if (ret)
>> -		cp_free(cp);
> 
> Makes sense; hopefully ccwchain_handle_ccw() cleans up correctly on
> error :) (I think it does)
> 

I have checked that it does as well, but wouldn't hurt if someone else 
also glances over once again :)

> Maybe add a comment
> 
> /* ccwchain_handle_ccw() already cleans up on error */
> 
> so we don't stumble over this in the future?

Sure.

> 
> (Also, does this want a Fixes: tag?)

This might warrant a fixes tag as well.
> 
>>   
>>   	if (!ret)
>>   		cp->initialized = true;
> 
> 
