Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06726ED7F8
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 04:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbfKDDLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 3 Nov 2019 22:11:13 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43078 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728781AbfKDDLN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 3 Nov 2019 22:11:13 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA439JE4046155;
        Mon, 4 Nov 2019 03:10:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=PrR52E2oEk9F8UQ17/zP4kO3lqfsQqHG/6TYakme+WU=;
 b=e6Jh1cSM3/hkO7xcFRrkVH9WWqsbyUg8bsB3G+BGqJnsc7xNnBL+dsQIM0hMp3H5ynut
 Ikh1A/id0QXZOhfyqB9TspeUiRXZIXXEHodzRqsM+e5HvEy3a4LWjc19rMYC5iWTQW4f
 G8JkB3VbpFneRMNKEUgegyPp+8Q3NaeXyxPfvGFshVvcG3Q6pn135BNX/fTuYI7JTjt2
 yUoPqQdxaxPT3URmfY8jG3joQMr2WQhMnBN5Fs3C4NzrGWP1QXJ7Yppl4k+IjiZI7zdS
 bg/7g23FeO0aOC1XZHX8bUSS3HZfP56Js3oJjJRT838Ny6oYEBkO0Txa9HHDeh0KU0F0 iA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w11rpmhx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 03:10:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA4343Cr017272;
        Mon, 4 Nov 2019 03:10:53 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2w1kxkjwn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Nov 2019 03:10:53 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA43ApKq017345;
        Mon, 4 Nov 2019 03:10:51 GMT
Received: from [192.168.0.4] (/111.206.84.95)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 03:10:50 +0000
Subject: Re: [PATCH 5/5] cpuidle-haltpoll: fix up the branch check
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        joao.m.martins@oracle.com, rafael.j.wysocki@intel.com,
        rkrcmar@redhat.com, pbonzini@redhat.com
References: <1572060239-17401-1-git-send-email-zhenzhong.duan@oracle.com>
 <1572060239-17401-6-git-send-email-zhenzhong.duan@oracle.com>
 <20191101212613.GB20672@amt.cnet>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <bafc1688-02ea-77a4-fb1c-2fe6afa8a7cc@oracle.com>
Date:   Mon, 4 Nov 2019 11:10:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191101212613.GB20672@amt.cnet>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911040031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911040032
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/11/2 5:26, Marcelo Tosatti wrote:
> On Sat, Oct 26, 2019 at 11:23:59AM +0800, Zhenzhong Duan wrote:
>> Ensure pool time is longer than block_ns, so there is a margin to
>> avoid vCPU get into block state unnecessorily.
>>
>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
>> ---
>>   drivers/cpuidle/governors/haltpoll.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/cpuidle/governors/haltpoll.c b/drivers/cpuidle/governors/haltpoll.c
>> index 4b00d7a..59eadaf 100644
>> --- a/drivers/cpuidle/governors/haltpoll.c
>> +++ b/drivers/cpuidle/governors/haltpoll.c
>> @@ -81,9 +81,9 @@ static void adjust_poll_limit(struct cpuidle_device *dev, unsigned int block_us)
>>   	u64 block_ns = block_us*NSEC_PER_USEC;
>>   
>>   	/* Grow cpu_halt_poll_us if
>> -	 * cpu_halt_poll_us < block_ns < guest_halt_poll_us
>> +	 * cpu_halt_poll_us <= block_ns < guest_halt_poll_us
>>   	 */
>> -	if (block_ns > dev->poll_limit_ns && block_ns <= guest_halt_poll_ns) {
>> +	if (block_ns >= dev->poll_limit_ns && block_ns < guest_halt_poll_ns) {
> 					      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> If block_ns == guest_halt_poll_ns, you won't allow dev->poll_limit_ns to
> grow. Why is that?

Maybe I'm too strict here. My understanding is: if block_ns = guest_halt_poll_ns,
dev->poll_limit_ns will grow to guest_halt_poll_ns, then block_ns = dev->poll_limit_ns,
there is not a margin to ensure poll time is enough to cover the equal block time.
In this case, shrinking may be a better choice?

>
>> @@ -101,7 +101,7 @@ static void adjust_poll_limit(struct cpuidle_device *dev, unsigned int block_us)
>>   			val = guest_halt_poll_ns;
>>   
>>   		dev->poll_limit_ns = val;
>> -	} else if (block_ns > guest_halt_poll_ns &&
>> +	} else if (block_ns >= guest_halt_poll_ns &&
>>   		   guest_halt_poll_allow_shrink) {
>>   		unsigned int shrink = guest_halt_poll_shrink;
> And here you shrink if block_ns == guest_halt_poll_ns. Not sure
> why that makes sense either.

See above explanation.

Zhenzhong

