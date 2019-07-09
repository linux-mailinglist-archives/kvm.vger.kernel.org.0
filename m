Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9601A6376D
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 16:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfGIOID (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 10:08:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39178 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725947AbfGIOID (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Jul 2019 10:08:03 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x69E2qkS007635
        for <kvm@vger.kernel.org>; Tue, 9 Jul 2019 10:08:01 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tmt0f6k6x-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2019 10:08:01 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <alifm@linux.ibm.com>;
        Tue, 9 Jul 2019 15:08:00 +0100
Received: from b01cxnp22035.gho.pok.ibm.com (9.57.198.25)
        by e14.ny.us.ibm.com (146.89.104.201) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 9 Jul 2019 15:07:59 +0100
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x69E7wIm53346782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Jul 2019 14:07:58 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B300AC05F;
        Tue,  9 Jul 2019 14:07:58 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1C37AC05B;
        Tue,  9 Jul 2019 14:07:57 +0000 (GMT)
Received: from [9.56.58.103] (unknown [9.56.58.103])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  9 Jul 2019 14:07:57 +0000 (GMT)
Subject: Re: [RFC v2 2/5] vfio-ccw: Fix memory leak and don't call cp_free in
 cp_init
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     farman@linux.ibm.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <cover.1562616169.git.alifm@linux.ibm.com>
 <fbb44bc85f5dfe4fdaebaf9cb74efcfae4743fba.1562616169.git.alifm@linux.ibm.com>
 <20190709120651.06d7666e.cohuck@redhat.com>
From:   Farhan Ali <alifm@linux.ibm.com>
Date:   Tue, 9 Jul 2019 10:07:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <20190709120651.06d7666e.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19070914-0052-0000-0000-000003DC24FE
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011400; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01229712; UDB=6.00647653; IPR=6.01010971;
 MB=3.00027649; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-09 14:08:00
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19070914-0053-0000-0000-0000619F900C
Message-Id: <1a6f6e71-037f-455a-062d-0e8fdd2476c5@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=957 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907090167
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/09/2019 06:06 AM, Cornelia Huck wrote:
> On Mon,  8 Jul 2019 16:10:35 -0400
> Farhan Ali <alifm@linux.ibm.com> wrote:
> 
>> We don't set cp->initialized to true so calling cp_free
>> will just return and not do anything.
>>
>> Also fix a memory leak where we fail to free a ccwchain
>> on an error.
>>
>> Fixes: 812271b910 ("s390/cio: Squash cp_free() and cp_unpin_free()")
>> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
>> ---
>>   drivers/s390/cio/vfio_ccw_cp.c | 11 +++++++----
>>   1 file changed, 7 insertions(+), 4 deletions(-)
> 
> (...)
> 
>> @@ -642,8 +647,6 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
>>   
>>   	/* Build a ccwchain for the first CCW segment */
>>   	ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
>> -	if (ret)
>> -		cp_free(cp);
> 
> Now that I look again: it's a bit odd that we set the bit in all cases,
> even if we have an error. We could move that into the !ret branch that
> sets ->initialized; but it does not really hurt.

By setting the bit, I am assuming you meant cmd.c64?

Yes, it doesn't harm anything but for better code readability you have a 
good point. I will move it into !ret branch in the first patch since I 
think it would be more appropriate there, no?

> 
>>   
>>   	/* It is safe to force: if it was not set but idals used
>>   	 * ccwchain_calc_length would have returned an error.
> 
> The rest of the patch looks good to me.
> 
> 

