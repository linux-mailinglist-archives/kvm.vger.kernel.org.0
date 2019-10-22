Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2AADFC05
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 04:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730796AbfJVCrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 22:47:32 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39336 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfJVCrc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 22:47:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9M2d0HY062877;
        Tue, 22 Oct 2019 02:45:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=IOP2qUmHyCzlOIB/E3Sa7AbeDULWgDap01khNwHbm4M=;
 b=sIWAClKUcSthzc19DVO3fJtVN9iPxF5iQ3IkEfLHBlw516NLxbu8OcK8x7eueE+uWOHQ
 HI4pRdJk7fxh9Yo74RI+6QEbToSAUKpb3yU//+HbpQvb3292WWgzek5lAK/RfaDhInbM
 FakgfhJgc5cDbi/H69B3nwav7yqceoZJE7nLvdZrZC5BGXMhQR5oum8ggp+akwE3hBCg
 ownomZDx6qyWSafh7BdHqJan4eGHLJw4UP86bB5X2nbxlTNw64onWZxe06nPt98Qo5MZ
 7Z9o1Ugr81Nk1xap76XCy7uldiyPmV/doYPTgyXnVLgryB/SeYxwS9doGbfKYknbT18P PA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2vqswtbmku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 02:45:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9M2iDcS005685;
        Tue, 22 Oct 2019 02:45:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vrc00vt81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 02:45:38 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9M2jYBq022586;
        Tue, 22 Oct 2019 02:45:34 GMT
Received: from [10.191.30.27] (/10.191.30.27)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Oct 2019 19:45:33 -0700
Subject: Re: [PATCH v6 3/5] x86/kvm: Add "nopvspin" parameter to disable PV
 spinlocks
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org
Cc:     linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, peterz@infradead.org,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>
References: <1571102367-31595-1-git-send-email-zhenzhong.duan@oracle.com>
 <1571102367-31595-4-git-send-email-zhenzhong.duan@oracle.com>
 <87k18y1hc1.fsf@vitty.brq.redhat.com>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <a1a5b381-cd06-04ed-5d05-6cb7bfa070b8@oracle.com>
Date:   Tue, 22 Oct 2019 10:45:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <87k18y1hc1.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220025
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220025
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/10/21 19:14, Vitaly Kuznetsov wrote:
>> index 249f14a..e9c76d8 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -825,18 +825,44 @@ __visible bool __kvm_vcpu_is_preempted(long cpu)
>>    */
>>   void __init kvm_spinlock_init(void)
>>   {
>> -	/* Does host kernel support KVM_FEATURE_PV_UNHALT? */
>> -	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
>> +	/*
>> +	 * PV spinlocks is disabled if no host side support, then native
>> +	 * qspinlock will be used. As native qspinlock is a fair lock, there is
>> +	 * lock holder preemption issue using it in a guest, imaging one pCPU
>> +	 * running 10 vCPUs of same guest contending same lock.
>> +	 *
>> +	 * virt_spin_lock() is introduced as an optimization for that scenario
>> +	 * which is enabled by virt_spin_lock_key key. To use that optimization,
>> +	 * virt_spin_lock_key isn't disabled here.
>> +	 */
> My take (if I properly understood what you say) would be:
>
> "In case host doesn't support KVM_FEATURE_PV_UNHALT there is still an
> advantage of keeping virt_spin_lock_key enabled: virt_spin_lock() is
> preferred over native qspinlock when vCPU is preempted."

Yes, that's what I mean, maybe I didn't explain clearly due to my pool 
english,

I'll use your explanation instead.

>
>> +	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT)) {
>> +		pr_info("PV spinlocks disabled, no host support.\n");
>>   		return;
>> +	}
>>   
>> +	/*
>> +	 * Disable PV qspinlock and use native qspinlock when dedicated pCPUs
>> +	 * are available.
>> +	 */
>>   	if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
>> +		pr_info("PV spinlocks disabled with KVM_HINTS_REALTIME hints.\n");
>> +		static_branch_disable(&virt_spin_lock_key);
>> +		return;
>> +	}
>> +
>> +	if (num_possible_cpus() == 1) {
>> +		pr_info("PV spinlocks disabled, single CPU.\n");
>>   		static_branch_disable(&virt_spin_lock_key);
>>   		return;
>>   	}
>>   
>> -	/* Don't use the pvqspinlock code if there is only 1 vCPU. */
>> -	if (num_possible_cpus() == 1)
>> +	if (nopvspin) {
>> +		pr_info("PV spinlocks disabled, forced by \"nopvspin\" parameter.\n");
>> +		static_branch_disable(&virt_spin_lock_key);
>>   		return;
> You could've replaced this 'static_branch_disable(); return;' pattern
> with a goto to the end of the function to save a few lines but this
> looks good anyways.
>
> Reviewed-by: Vitaly Kuznetsov<vkuznets@redhat.com>

Ok, will do, thanks for review.

Zhenzhong

