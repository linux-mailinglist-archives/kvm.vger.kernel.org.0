Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D901BEF5C9
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2019 07:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387583AbfKEGwz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 01:52:55 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:35312 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfKEGwy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 01:52:54 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA56pVfq180392;
        Tue, 5 Nov 2019 06:52:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=gTy58HMsZTBRLpQM3pQyloVPDJUmqS00HB111ETBoQk=;
 b=qYc2TJeP+sc79NSM3dM7IkWIeg51zK2moBUOvwZM1QDaYwWpTsVY7116Xb6c0agbf9pp
 7XHLty3B6nuio8s5aI1zk0qjzha+iwiHzDz2QkUOK5Ft80kq94a1wki3py3YFvSuMadt
 soJ+RmxarLQbTq2uazgIdtX8U44/fc8gYm9RYxLzlep6D84MNWgNKMi00lbR2M3g+tWB
 pmxzZiISHPamaEkrFUcs0V86SX4/d65yLme2B3VQCEMqFUu0M1BXc+B4G4J0GKgBCfpP
 93DXE8EVgsyeKM7EsVWYPSWF9A03t0VcfDlbzUGzlGDp9tvi45MIvspuLbaeCiTQU4GU cA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2w11rpv3c9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 06:52:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA56oRDl173370;
        Tue, 5 Nov 2019 06:50:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w2wchb6r9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Nov 2019 06:50:33 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA56nQBm028096;
        Tue, 5 Nov 2019 06:49:26 GMT
Received: from [192.168.0.4] (/139.215.143.17)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 Nov 2019 22:49:25 -0800
Subject: Re: [PATCH 5/5] cpuidle-haltpoll: fix up the branch check
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        joao.m.martins@oracle.com, rafael.j.wysocki@intel.com,
        rkrcmar@redhat.com, pbonzini@redhat.com
References: <1572060239-17401-1-git-send-email-zhenzhong.duan@oracle.com>
 <1572060239-17401-6-git-send-email-zhenzhong.duan@oracle.com>
 <20191101212613.GB20672@amt.cnet>
 <bafc1688-02ea-77a4-fb1c-2fe6afa8a7cc@oracle.com>
 <20191104150103.GA14887@amt.cnet>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <b7c33ed5-799b-51a0-b35b-86d979a7ad6c@oracle.com>
Date:   Tue, 5 Nov 2019 14:49:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104150103.GA14887@amt.cnet>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911050054
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9431 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911050054
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/11/4 23:01, Marcelo Tosatti wrote:
> On Mon, Nov 04, 2019 at 11:10:25AM +0800, Zhenzhong Duan wrote:
>> On 2019/11/2 5:26, Marcelo Tosatti wrote:
>>> On Sat, Oct 26, 2019 at 11:23:59AM +0800, Zhenzhong Duan wrote:
>>>> Ensure pool time is longer than block_ns, so there is a margin to
>>>> avoid vCPU get into block state unnecessorily.
>>>>
>>>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
>>>> ---
>>>>   drivers/cpuidle/governors/haltpoll.c | 6 +++---
>>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/cpuidle/governors/haltpoll.c b/drivers/cpuidle/governors/haltpoll.c
>>>> index 4b00d7a..59eadaf 100644
>>>> --- a/drivers/cpuidle/governors/haltpoll.c
>>>> +++ b/drivers/cpuidle/governors/haltpoll.c
>>>> @@ -81,9 +81,9 @@ static void adjust_poll_limit(struct cpuidle_device *dev, unsigned int block_us)
>>>>   	u64 block_ns = block_us*NSEC_PER_USEC;
>>>>   	/* Grow cpu_halt_poll_us if
>>>> -	 * cpu_halt_poll_us < block_ns < guest_halt_poll_us
>>>> +	 * cpu_halt_poll_us <= block_ns < guest_halt_poll_us
>>>>   	 */
>>>> -	if (block_ns > dev->poll_limit_ns && block_ns <= guest_halt_poll_ns) {
>>>> +	if (block_ns >= dev->poll_limit_ns && block_ns < guest_halt_poll_ns) {
>>> 					      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>
>>> If block_ns == guest_halt_poll_ns, you won't allow dev->poll_limit_ns to
>>> grow. Why is that?
>> Maybe I'm too strict here. My understanding is: if block_ns = guest_halt_poll_ns,
>> dev->poll_limit_ns will grow to guest_halt_poll_ns,
> OK.
>
>> then block_ns = dev->poll_limit_ns,
> block_ns = dev->poll_limit_ns = guest_halt_poll_ns. OK.
>
>> there is not a margin to ensure poll time is enough to cover the equal block time.
>> In this case, shrinking may be a better choice?
> Ok, so you are considering _on the next_ halt instance, if block_ns =
> guest_halt_poll_ns again?
Yes, I realized it's rarely to happen in nanosecond granularity.
>
> Then without the suggested modification: we don't shrink, poll for
> guest_halt_poll_ns again.
>
> With your modification: we shrink, because block_ns ==
> guest_halt_poll_ns.
>
> IMO what really clarifies things here is either the real sleep pattern
> or a synthetic sleep pattern similar to the real thing.
Agree
>
> Do you have a scenario where the current algorithm is maintaining
> a low dev->poll_limit_ns and performance is hurt?
>
> If you could come up with examples, such as the client/server pair at
> https://lore.kernel.org/lkml/20190514135022.GD4392@amt.cnet/T/
>
> or just a sequence of delays:
> block_ns, block_ns, block_ns-1,...
>
> It would be easier to visualize this.

Looks hard to generate a sequence of delays of same value in nanoseconds 
which is also CPU cycle granularity.

I think this patch doesn't help much for a real scenario, so pls ignore it.

Thanks

Zhenzhong


