Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43D8DCCF3A
	for <lists+kvm@lfdr.de>; Sun,  6 Oct 2019 09:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfJFHvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Oct 2019 03:51:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52822 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfJFHvH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Oct 2019 03:51:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x967nM7g046959;
        Sun, 6 Oct 2019 07:49:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=WUy2IUfGiHbAYoRWHgogT1eLEMfG3bVYEpIJvULOvFI=;
 b=IKhuN3BAuQlL1x/WDpWGaPCJ6A1rPlDMJ5nYrSaFwykf3sCKkCpVY4JufyGgNLCe4J4G
 FA7Jh1Vq/gUveHHA/+KP5zWRpChSOWeO3RJbbEqw8weu4Rjg3TwDbGfCjG3YjajwMUKG
 omLe0Z0AucbU8heFss1ZkhfFMKgurRClq5Dzs4ghyx8G31pFPtm8tmeLQAnCD3a2zLU7
 pgw0+mE2EqO1p0zb8qxZxdfAsMUrNCZRBtnmDjDdaxtpxBbkPA6t8zkrn3ZsfNcfNfnb
 nLjD68cuTFFiiaj/hsmvi+vnIDbBIHPOMQI7qMeCupGfQtrb6tj5xj8Q28l1ky2qctVN fw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2vek4q2udc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Oct 2019 07:49:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x967iIpL003455;
        Sun, 6 Oct 2019 07:49:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2vf4n6n325-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 06 Oct 2019 07:49:21 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x967nAC1032696;
        Sun, 6 Oct 2019 07:49:12 GMT
Received: from [10.191.5.27] (/10.191.5.27)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Oct 2019 00:49:10 -0700
Subject: Re: [PATCH v4 1/4] x86/kvm: Add "nopvspin" parameter to disable PV
 spinlocks
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        linux-kernel@vger.kernel.org
Cc:     vkuznets@redhat.com, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, pbonzini@redhat.com,
        rkrcmar@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        jgross@suse.com, sstabellini@kernel.org, peterz@infradead.org,
        Jonathan Corbet <corbet@lwn.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Will Deacon <will@kernel.org>
References: <1570111335-12731-1-git-send-email-zhenzhong.duan@oracle.com>
 <1570111335-12731-2-git-send-email-zhenzhong.duan@oracle.com>
 <26ef7beb-dad0-13c9-fc2f-217a5e046e4d@oracle.com>
From:   Zhenzhong Duan <zhenzhong.duan@oracle.com>
Organization: Oracle Corporation
Message-ID: <b0d6df7b-00ff-cdd8-f9f2-26af73256f5b@oracle.com>
Date:   Sun, 6 Oct 2019 15:49:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <26ef7beb-dad0-13c9-fc2f-217a5e046e4d@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9401 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910060079
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9401 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910060080
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/10/4 22:52, Boris Ostrovsky wrote:

> On 10/3/19 10:02 AM, Zhenzhong Duan wrote:
>>   void __init kvm_spinlock_init(void)
>>   {
>> -	/* Does host kernel support KVM_FEATURE_PV_UNHALT? */
>> -	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT))
>> -		return;
>> -
>> -	if (kvm_para_has_hint(KVM_HINTS_REALTIME))
>> +	/*
>> +	 * Don't use the pvqspinlock code if no KVM_FEATURE_PV_UNHALT feature
>> +	 * support, or there is REALTIME hints or only 1 vCPU.
>> +	 */
>> +	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT) ||
>> +	    kvm_para_has_hint(KVM_HINTS_REALTIME) ||
>> +	    num_possible_cpus() == 1) {
>> +		pr_info("PV spinlocks disabled\n");
>>   		return;
>> +	}
>>   
>> -	/* Don't use the pvqspinlock code if there is only 1 vCPU. */
>> -	if (num_possible_cpus() == 1)
>> +	if (nopvspin) {
>> +		pr_info("PV spinlocks disabled forced by \"nopvspin\" parameter.\n");
>> +		static_branch_disable(&virt_spin_lock_key);
> Would it make sense to bring here the other site where the key is
> disabled (in kvm_smp_prepare_cpus())?

Thanks for point out, I'll do it. Just not clear if I should do that in a separate patch,
there is a history about that code:

Its original place was here and then moved to kvm_smp_prepare_cpus() by below commit:
34226b6b ("KVM: X86: Fix setup the virt_spin_lock_key before static key get initialized")
which fixed jump_label_init() calling late issue.

Then 8990cac6 ("x86/jump_label: Initialize static branching early") move jump_label_init()
early, so commit 34226b6b could be reverted.

>
> (and, in fact, shouldn't all of the checks that result in early return
> above disable the key?)

I think we should enable he key for !kvm_para_has_feature(KVM_FEATURE_PV_UNHALT) case,
there is lock holder preemption issue as qspinlock is fair lock, virt_spin_lock()
is an optimization to that, imaging one pcpu running 10 vcpus of same guest
contending a same lock.

For kvm_para_has_hint(KVM_HINTS_REALTIME) case, hypervisor hints there is
no preemption and we should disable virt_spin_lock_key to use native qspinlock.

For the UP case, we don't care virt_spin_lock_key value.

For nopvspin case, we intentionally check native qspinlock code performance,
compare it with PV qspinlock, etc. So virt_spin_lock() optimization should be disabled.

Let me know if anything wrong with above understanding. Thanks

Zhenzhong

