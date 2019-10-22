Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00CDCE0426
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 14:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388027AbfJVMs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 08:48:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44874 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730275AbfJVMs4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 08:48:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MCiXqG163323;
        Tue, 22 Oct 2019 12:47:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=vppjsuM3aTkGtdL8I7GSga2BnR0QS2xZhjmHJAapcRs=;
 b=VW246wRq2ra3oMJ9vKt5fVKA+KTK+wOv6OMe94YWzjkyhPofjnexN6dHhI7LGpy8vu88
 QUl2BgRNgDbNMyGu/B3E79uq/k/UgJBu5bKRKGmMquvLIejqbY2MFNOhRKTEq0KB1pPp
 HfulBIB0e8XPaTz0qBmbZvYVo35I41aEE1qMCmALXDbagFrxQM43y9AUMCnM10tcD+Ai
 lhj5gV5Q7z71UWSc/yISGbQAb3ujeF7bvogHeb+jYT9kS9u8PlMSoxMmwrQw17mBB5wt
 RcYqD5SbLsCPu94011J5I8HxhFyA8fxuyvFgNG3KhfvuWpG92PTsogbRmgPKoc6Z2QL8 6Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vqswtefrx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 12:47:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MCiE69049644;
        Tue, 22 Oct 2019 12:47:02 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2vsp3y58ge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 12:47:02 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MCktk2017217;
        Tue, 22 Oct 2019 12:46:57 GMT
Received: from [10.191.9.53] (/10.191.9.53)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 05:46:54 -0700
Subject: Re: [PATCH v7 3/5] x86/kvm: Add "nopvspin" parameter to disable PV
 spinlocks
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, boris.ostrovsky@oracle.com,
        jgross@suse.com, peterz@infradead.org, will@kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        mikelley@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <1571649076-2421-1-git-send-email-zhenzhong.duan@oracle.com>
 <1571649076-2421-4-git-send-email-zhenzhong.duan@oracle.com>
 <8736fl1071.fsf@vitty.brq.redhat.com>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <dbc50272-a4f5-ce7c-ba71-75031521f420@oracle.com>
Date:   Tue, 22 Oct 2019 20:46:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <8736fl1071.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9417 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220117
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly,

On 2019/10/22 19:36, Vitaly Kuznetsov wrote:

> Zhenzhong Duan<zhenzhong.duan@oracle.com>  writes:
>
...snip

>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> index 249f14a..3945aa5 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -825,18 +825,36 @@ __visible bool __kvm_vcpu_is_preempted(long cpu)
>>    */
>>   void __init kvm_spinlock_init(void)
>>   {
>> -	/* Does host kernel support KVM_FEATURE_PV_UNHALT? */
>> -	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
>> +	/*
>> +	 * In case host doesn't support KVM_FEATURE_PV_UNHALT there is still an
>> +	 * advantage of keeping virt_spin_lock_key enabled: virt_spin_lock() is
>> +	 * preferred over native qspinlock when vCPU is preempted.
>> +	 */
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
>> -		static_branch_disable(&virt_spin_lock_key);
>> -		return;
>> +		pr_info("PV spinlocks disabled with KVM_HINTS_REALTIME hints.\n");
>> +		goto out;
>>   	}
>>   
>> -	/* Don't use the pvqspinlock code if there is only 1 vCPU. */
>> -	if (num_possible_cpus() == 1)
>> -		return;
>> +	if (num_possible_cpus() == 1) {
>> +		pr_info("PV spinlocks disabled, single CPU.\n");
>> +		goto out;
>> +	}
>> +
>> +	if (nopvspin) {
>> +		pr_info("PV spinlocks disabled, forced by \"nopvspin\" parameter.\n");
>> +		goto out;
>> +	}
>> +
>> +	pr_info("PV spinlocks enabled\n");
>>   
>>   	__pv_init_lock_hash();
>>   	pv_ops.lock.queued_spin_lock_slowpath = __pv_queued_spin_lock_slowpath;
>> @@ -849,6 +867,8 @@ void __init kvm_spinlock_init(void)
>>   		pv_ops.lock.vcpu_is_preempted =
>>   			PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
>>   	}
>> +out:
>> +	static_branch_disable(&virt_spin_lock_key);
> You probably need to add 'return' before 'out:' as it seems you're
> disabling virt_spin_lock_key in all cases now).

virt_spin_lock_key is kept enabled in !kvm_para_has_feature(KVM_FEATURE_PV_UNHALT)
case which is the only case virt_spin_lock() optimization is used.

When PV qspinlock is enabled, virt_spin_lock() isn't called in
__pv_queued_spin_lock_slowpath() in which case we don't care
virt_spin_lock_key's value.

So adding 'return' or not are both ok, I chosed to save a line,
let me know if you prefer to add a 'return' and I'll change it.

btw: __pv_queued_spin_lock_slowpath() is alias of queued_spin_lock_slowpath()

Thanks
Zhenzhong

