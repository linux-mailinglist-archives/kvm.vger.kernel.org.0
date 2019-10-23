Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90DD4E0FBF
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 03:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733269AbfJWBjU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 21:39:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47504 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730047AbfJWBjT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 21:39:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9N1YOd8190852;
        Wed, 23 Oct 2019 01:36:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=mgnTopzGZ8f1FGKvPSTHhrMy24Rq85HzQQkpuJIKlp0=;
 b=BuVelkAPmWzz/ViA5GxMxUd6Ilv/ZHMliID3HYO+ysbz6xcFLl0G7qwrW9ZnhZ5+fw5K
 ZZwhM1WQ1gpb5f91a2e/3a5K45dUKqz8th5DCDbvJQLQfhXq8imBPNdnNJzDlaNpoHbk
 MtpwAQQ9uayFJCsgXIPxV4TOl4+N6WL5OrEp1fWLAPHtJEr3Ae5bbcqtmT5o/9Nh6ytW
 BCV30iby7KyJaxOZfvfwdPZ6v+bRwsi0ufN6DxKVo9xw4OiXTuuAcdsjuY8Jq3hxlM9O
 YCK0rVUp3NoDs/PhwZcs9Sw9XoQZjTDwsW4wqZi80KUm3adpOAZZ4Jpw0VMvsphz52N8 lA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vqu4qt1qa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Oct 2019 01:36:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9N1YE5W158224;
        Wed, 23 Oct 2019 01:36:10 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vsx23yaku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Oct 2019 01:36:10 +0000
Received: from abhmp0021.oracle.com (abhmp0021.oracle.com [141.146.116.27])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9N1a7iT001979;
        Wed, 23 Oct 2019 01:36:08 GMT
Received: from [10.191.28.118] (/10.191.28.118)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Oct 2019 01:36:07 +0000
Subject: Re: [PATCH v7 3/5] x86/kvm: Add "nopvspin" parameter to disable PV
 spinlocks
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, boris.ostrovsky@oracle.com, jgross@suse.com,
        peterz@infradead.org, will@kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        mikelley@microsoft.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <1571649076-2421-1-git-send-email-zhenzhong.duan@oracle.com>
 <1571649076-2421-4-git-send-email-zhenzhong.duan@oracle.com>
 <8736fl1071.fsf@vitty.brq.redhat.com>
 <dbc50272-a4f5-ce7c-ba71-75031521f420@oracle.com>
 <20191022210355.GR2343@linux.intel.com>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <f0065d49-36ae-8b1d-81b9-6e899042169f@oracle.com>
Date:   Wed, 23 Oct 2019 09:36:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191022210355.GR2343@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910230013
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910230013
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2019/10/23 5:03, Sean Christopherson wrote:
> On Tue, Oct 22, 2019 at 08:46:46PM +0800, Zhenzhong Duan wrote:
>> Hi Vitaly,
>>
>> On 2019/10/22 19:36, Vitaly Kuznetsov wrote:
>>
>>> Zhenzhong Duan<zhenzhong.duan@oracle.com>  writes:
>>>
>> ...snip
>>
>>>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>>>> index 249f14a..3945aa5 100644
>>>> --- a/arch/x86/kernel/kvm.c
>>>> +++ b/arch/x86/kernel/kvm.c
>>>> @@ -825,18 +825,36 @@ __visible bool __kvm_vcpu_is_preempted(long cpu)
>>>>    */
>>>>   void __init kvm_spinlock_init(void)
>>>>   {
>>>> -	/* Does host kernel support KVM_FEATURE_PV_UNHALT? */
>>>> -	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
>>>> +	/*
>>>> +	 * In case host doesn't support KVM_FEATURE_PV_UNHALT there is still an
>>>> +	 * advantage of keeping virt_spin_lock_key enabled: virt_spin_lock() is
>>>> +	 * preferred over native qspinlock when vCPU is preempted.
>>>> +	 */
>>>> +	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT)) {
>>>> +		pr_info("PV spinlocks disabled, no host support.\n");
>>>>   		return;
>>>> +	}
>>>> +	/*
>>>> +	 * Disable PV qspinlock and use native qspinlock when dedicated pCPUs
>>>> +	 * are available.
>>>> +	 */
>>>>   	if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
>>>> -		static_branch_disable(&virt_spin_lock_key);
>>>> -		return;
>>>> +		pr_info("PV spinlocks disabled with KVM_HINTS_REALTIME hints.\n");
>>>> +		goto out;
>>>>   	}
>>>> -	/* Don't use the pvqspinlock code if there is only 1 vCPU. */
>>>> -	if (num_possible_cpus() == 1)
>>>> -		return;
>>>> +	if (num_possible_cpus() == 1) {
>>>> +		pr_info("PV spinlocks disabled, single CPU.\n");
>>>> +		goto out;
>>>> +	}
>>>> +
>>>> +	if (nopvspin) {
>>>> +		pr_info("PV spinlocks disabled, forced by \"nopvspin\" parameter.\n");
>>>> +		goto out;
>>>> +	}
>>>> +
>>>> +	pr_info("PV spinlocks enabled\n");
>>>>   	__pv_init_lock_hash();
>>>>   	pv_ops.lock.queued_spin_lock_slowpath = __pv_queued_spin_lock_slowpath;
>>>> @@ -849,6 +867,8 @@ void __init kvm_spinlock_init(void)
>>>>   		pv_ops.lock.vcpu_is_preempted =
>>>>   			PV_CALLEE_SAVE(__kvm_vcpu_is_preempted);
>>>>   	}
>>>> +out:
>>>> +	static_branch_disable(&virt_spin_lock_key);
>>> You probably need to add 'return' before 'out:' as it seems you're
>>> disabling virt_spin_lock_key in all cases now).
>> virt_spin_lock_key is kept enabled in !kvm_para_has_feature(KVM_FEATURE_PV_UNHALT)
>> case which is the only case virt_spin_lock() optimization is used.
>>
>> When PV qspinlock is enabled, virt_spin_lock() isn't called in
>> __pv_queued_spin_lock_slowpath() in which case we don't care
>> virt_spin_lock_key's value.
>>
>> So adding 'return' or not are both ok, I chosed to save a line,
>> let me know if you prefer to add a 'return' and I'll change it.
> It'd be worth adding a comment here if you end up spinning another version
> to change the logging prefix.  The logic is sound and I like the end
> result, but I had the same knee jerk "this can't be right!?!?" reaction as
> Vitaly.

Sure, will do in next version.

Thanks

Zhenzhong

